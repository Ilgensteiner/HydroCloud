#!/bin/bash

# Halt on any error
set -e

echo -e "${green}Aktualisiere die Paketquellen..."
sudo apt-get update
sudo apt-get upgrade

echo -e "${green}Installiere Nginx und zugehörige Module..."
sudo apt-get install nginx -y

echo -e "${green}Installiere MySQL und zugehörige Entwicklerbibliotheken..."
sudo apt-get install -y libmysqlclient-dev \
                        libmysqlclient21 \
                        mysql-common

sudo apt-get install libmysqlclient-dev pkg-config

echo -e "${green}Installiere Python 3.12 und Entwicklerbibliotheken..."
sudo apt-get install -y python3.12 python3.12-venv python3-pip

echo -e "${green}Klone das Projekt von GitHub..."

# Schlüssel erstellen, falls nicht vorhanden
if [ ! -f /root/.ssh/deploy_key ]; then
  echo -e "${green}Erstelle einen neuen SSH Deploy-Key..."
  sudo ssh-keygen -t ed25519 -C "EC2Instance" -f /root/.ssh/deploy_key -N ''

  # Starten des ssh-agent mit sudo und Ausführen des ssh-add mit sudo
  eval "$(sudo ssh-agent -s)"
  sudo ssh-add /root/.ssh/deploy_key

  echo -e "${green}SSH Deploy-Key erstellt. Bitte fügen Sie den folgenden öffentlichen Schlüssel zu GitHub hinzu: (github.com/Repo/Setting/DeployKey)"
  sudo cat /root/.ssh/deploy_key.pub
  echo -e "${green}Nachdem der Schlüssel hinzugefügt wurde, führen Sie das Script erneut aus, um fortzufahren."
  exit 0
fi

project_dir="/var/www/HydroCloudAWS_Website"
sudo mkdir -p "$project_dir"
sudo git clone git@github.com:Ilgensteiner/HydroCloudAWS_Website.git "$project_dir" --config core.sshCommand="ssh -i ~/.ssh/deploy_key -o IdentitiesOnly=yes"
cd /var/www/HydroCloudAWS_Website
echo -e "${green}Installiere erforderliche Python-Pakete..."
sudo pip install -r requirements.txt --break-system-packages

echo -e "${green}Installiere gunicorn und andere Abhängigkeiten..."
sudo pip3 install gunicorn --break-system-packages
sudo apt install python3-dev default-libmysqlclient-dev build-essential libssl-dev
sudo apt install nginx -y
# sudo nginx --> wohl nicht nötig

sudo apt install -y supervisor

echo -e "${green}Konfiguriere Gunicorn..."
script_path="/etc/supervisor/conf.d/gunicorn.conf"
sudo mkdir -p $(dirname "$script_path")
sudo tee "$script_path" > /dev/null << 'EOF'

[program:gunicorn]
    directory=/var/www/HydroCloudAWS_Website
    command=/usr/local/bin/gunicorn --workers 3 --bind unix:/var/www/HydroCloudAWS_Website/app.sock HydroCloudWebsite.wsgi:application
    autostart=true
    autorestart=true
    stderr_logfile=/home/ubuntu/logs/gunicorn.err.log
    stdout_logfile=/home/ubuntu/logs/gunicorn.out.log
    [group:guni]
    programs:gunicorn

EOF

sudo mkdir -p /home/ubuntu/logs

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status

echo -e "${green}Konfiguriere Nginx..."
script_path="/etc/nginx/sites-available/django.conf"
sudo mkdir -p $(dirname "$script_path")
sudo tee "$script_path" > /dev/null << 'EOF'

# Nginx Configuration for sample Django application
    ######################################################
    server {
        listen 80;
        server_name 3.67.178.180;
        location / {
            include proxy_params;
            proxy_pass http://unix:/var/www/HydroCloudAWS_Website/app.sock;
        }
        location /static/ {
               autoindex on;
               alias /var/www/HydroCloudAWS_Website/static/;
        }
    }

EOF

sudo ln -sf /etc/nginx/sites-available/django.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo -e "${green}Erstelle das Skript zur Aktualisierung der IP-Adresse..."
# Skript zur IP-Aktualisierung erstellen
script_path="/var/www/bin/nginx_ipupdate.sh"
sudo mkdir -p $(dirname "$script_path")
sudo tee "$script_path" > /dev/null << 'EOF'
#!/bin/bash

# Fetch the new Public IPv4 Address
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
if [ -z "$public_ip" ]; then
    echo -e "${green}Failed to retrieve public IP address."
    exit 1
fi

# Define the nginx configuration file
django_conf="/etc/nginx/sites-available/django.conf"

# Backup the original nginx configuration file
sudo cp "$django_conf" "$django_conf.bak"

# Update the IP address in the nginx configuration file
sudo sed -i "s/server_name .*;/server_name $public_ip;/g" "$django_conf"

# Restart nginx to apply the changes
sudo systemctl restart nginx

echo -e "${green}Updated nginx configuration with new IP address: $public

EOF

echo -e "${green}Erstelle den Auto-Start Service"
script_path="/etc/systemd/system/hydrocloud.service"
sudo mkdir -p $(dirname "$script_path")
sudo tee "$script_path" > /dev/null << 'EOF'
[Unit]
Description=Unit for autostart of the webserver
After=network.target nginx.service
Wants=network.target nginx.service

[Service]
Type=oneshot
ExecStart=/bin/bash /var/www/bin/nginx_ipupdate.sh
User=root
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload
sudo systemctl enable hydrocloud.service

sudo reboot
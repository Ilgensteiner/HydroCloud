create table BlogCategory
(
    id          int auto_increment
        primary key,
    name        varchar(255) not null,
    description text         null,
    constraint id
        unique (id)
);

create table BlogPost
(
    id               int auto_increment
        primary key,
    title            varchar(255)             not null,
    subtitle         varchar(255)             null,
    authors          varchar(200)             not null,
    publication_date date default (curdate()) not null,
    content          text                     not null,
    preview_image    varchar(255)             null,
    constraint id
        unique (id)
);

create table BlogPostCategory
(
    id           int auto_increment
        primary key,
    blog_post_id int not null,
    category_id  int not null,
    constraint unique_blog_post_category
        unique (blog_post_id, category_id),
    constraint fk_blog_post
        foreign key (blog_post_id) references BlogPost (id)
            on delete cascade,
    constraint fk_category
        foreign key (category_id) references BlogCategory (id)
            on delete cascade
);

create table Greenhouses
(
    GreenhouseID    int auto_increment
        primary key,
    Location        varchar(255) not null,
    NumberOfSystems int          not null,
    Name            varchar(255) not null
);

create table GrowthStages
(
    GrowthStageName        varchar(255) not null
        primary key,
    GrowthStageDescription text         null
);

create table PlantSpecies
(
    PlantSpeciesName        varchar(255) not null
        primary key,
    PlantSpeciesDescription text         not null,
    Notes                   text         null
);

create table Plants
(
    PlantsID                       int auto_increment
        primary key,
    PlantSpeciesName               varchar(100)   not null,
    Comments                       text           null,
    Ideal_PHValueMin               decimal(10, 5) not null,
    Ideal_PHValueMax               decimal(10, 5) not null,
    Ideal_ECValueMin_mS_cm         decimal(10, 5) not null,
    Ideal_ECValueMax_mS_cm         decimal(10, 5) not null,
    Ideal_TDSValueMin              decimal(10, 5) not null,
    Ideal_TDSValueMax              decimal(10, 5) not null,
    Ideal_WaterLevelMin            decimal(10, 5) null,
    Ideal_WaterLevelMax            decimal(10, 5) null,
    Ideal_WaterTemperatureMin      decimal(10, 5) not null,
    Ideal_WaterTemperatureMax      decimal(10, 5) not null,
    Ideal_WaterOxygenLevelMin_mg_l decimal(10, 5) not null,
    Ideal_WaterOxygenLevelMax_mg_l decimal(10, 5) not null,
    Ideal_LightDurationMin         decimal(10, 5) not null,
    Ideal_LightDurationMax         decimal(10, 5) not null,
    Ideal_LightIntensityMin_nm     decimal(10, 5) not null,
    Ideal_LightIntensityMax_nm     decimal(10, 5) not null,
    Ideal_AirOxygenLevelMin        decimal(10, 5) null,
    Ideal_AirOxygenLevelMax        decimal(10, 5) null,
    Ideal_AirCO2LevelMin           decimal(10, 5) null,
    Ideal_AirCO2LevelMax           decimal(10, 5) null,
    Ideal_AirTemperatureDayMin     decimal(10, 5) not null,
    Ideal_AirTemperatureDayMax     decimal(10, 5) not null,
    Ideal_AirTemperatureNightMin   decimal(10, 5) not null,
    Ideal_AirTemperatureNightMax   decimal(10, 5) not null,
    Ideal_HumidityMin              decimal(10, 5) not null,
    Ideal_HumidityMax              decimal(10, 5) not null,
    Ideal_WN_Nitrogen              decimal(10, 5) null,
    Ideal_WN_Phosphor              decimal(10, 5) null,
    Ideal_WN_Potassium             decimal(10, 5) null,
    Ideal_WN_Sulfur                decimal(10, 5) null,
    Ideal_WN_Calcium               decimal(10, 5) null,
    Ideal_WN_Magnesium             decimal(10, 5) null,
    Ideal_WN_Iron                  decimal(10, 5) null,
    Ideal_WN_Manganese             decimal(10, 5) null,
    Ideal_WN_Boron                 decimal(10, 5) null,
    Ideal_WN_Copper                decimal(10, 5) null,
    Ideal_WN_Zinc                  decimal(10, 5) null,
    Ideal_WN_Molybdenum            decimal(10, 5) null,
    PlantName                      varchar(100)   not null,
    constraint Plants_ibfk_1
        foreign key (PlantSpeciesName) references PlantSpecies (PlantSpeciesName)
);

create index PlantSpeciesName
    on Plants (PlantSpeciesName);

create table SensorTypes
(
    SensorTypeID           int auto_increment
        primary key,
    SensorType             varchar(255)   not null,
    SensorTypesDescription text           not null,
    Unit                   varchar(50)    not null,
    System_ValueName       varchar(50)    not null,
    Difference_Warning     decimal(10, 5) not null,
    Difference_Critical    decimal(10, 5) not null
);

create table Subscriptions
(
    SubscriptionType varchar(100)   not null
        primary key,
    Price            decimal(10, 2) not null,
    DurationMonth    int            not null
);

create table Systems
(
    SystemID            int auto_increment
        primary key,
    GreenhouseID        int                            not null,
    SystemName          varchar(255)                   not null,
    CreationDate        date       default (curdate()) not null,
    ChangeDate          timestamp  default (curdate()) null on update CURRENT_TIMESTAMP,
    Comments            text                           null,
    GrowthStageName     varchar(255)                   not null,
    ReadyMadeFertilizer tinyint(1) default 0           not null,
    PHValue             decimal(10, 5)                 null,
    ECValue             decimal(10, 5)                 null,
    TDSValue            decimal(10, 5)                 null,
    WaterLevel          decimal(10, 5)                 null,
    WaterTemperature    decimal(10, 5)                 null,
    WaterOxygenLevel    decimal(10, 5)                 null,
    LightDuration       decimal(10, 5)                 null,
    LightIntensity      decimal(10, 5)                 null,
    AirOxygenLevel      decimal(10, 5)                 null,
    AirCO2Level         decimal(10, 5)                 null,
    AirTemperatureDay   decimal(10, 5)                 null,
    AirTemperatureNight decimal(10, 5)                 null,
    Humidity            decimal(10, 5)                 null,
    WN_Nitrogen         decimal(10, 5)                 null,
    WN_Phosphor         decimal(10, 5)                 null,
    WN_Potassium        decimal(10, 5)                 null,
    WN_Sulfur           decimal(10, 5)                 null,
    WN_Calcium          decimal(10, 5)                 null,
    WN_Magnesium        decimal(10, 5)                 null,
    WN_Iron             decimal(10, 5)                 null,
    WN_Manganese        decimal(10, 5)                 null,
    WN_Boron            decimal(10, 5)                 null,
    WN_Copper           decimal(10, 5)                 null,
    WN_Zinc             decimal(10, 5)                 null,
    WN_Molybdenum       decimal(10, 5)                 null,
    constraint Systems_ibfk_1
        foreign key (GreenhouseID) references Greenhouses (GreenhouseID),
    constraint Systems_ibfk_2
        foreign key (GrowthStageName) references GrowthStages (GrowthStageName)
);

create table Devices
(
    DeviceID          int auto_increment
        primary key,
    SensorTypeID      int                                          not null,
    SystemID          int                                          not null,
    DeviceName        varchar(255)                                 not null,
    DeviceDescription text                                         null,
    Status            enum ('active', 'inactive') default 'active' not null,
    Type              enum ('Pump', 'Sensor')     default 'Sensor' not null,
    constraint Devices_ibfk_1
        foreign key (SensorTypeID) references SensorTypes (SensorTypeID),
    constraint Devices_ibfk_2
        foreign key (SystemID) references Systems (SystemID)
);

create index SensorTypeID
    on Devices (SensorTypeID);

create index SystemID
    on Devices (SystemID);

create table HistoryDeviceData
(
    HistoryDeviceDataID int auto_increment
        primary key,
    DeviceID            int            not null,
    Date                date           not null,
    Time                time           not null,
    Measurement         decimal(10, 5) not null,
    constraint HistoryDeviceData_ibfk_1
        foreign key (DeviceID) references Devices (DeviceID)
);

create index DeviceID
    on HistoryDeviceData (DeviceID);

create table Media
(
    MediaID           int auto_increment
        primary key,
    MediaType         enum ('Bild', 'Video', 'Audio') not null,
    MediaName         varchar(255)                    not null,
    MediaDescription  text                            null,
    MediaURL          varchar(1000)                   not null,
    MediaThumbnailURL varchar(1000)                   not null,
    SystemID          int                             null,
    PlantsID          int                             null,
    GreenhouseID      int                             null,
    constraint Media_ibfk_1
        foreign key (SystemID) references Systems (SystemID),
    constraint Media_ibfk_2
        foreign key (PlantsID) references Plants (PlantsID),
    constraint Media_ibfk_3
        foreign key (GreenhouseID) references Greenhouses (GreenhouseID)
);

create index GreenhouseID
    on Media (GreenhouseID);

create index PlantsID
    on Media (PlantsID);

create index SystemID
    on Media (SystemID);

create index GreenhouseID
    on Systems (GreenhouseID);

create index GrowthStageName
    on Systems (GrowthStageName);

create table SystemsPlantsAssignment
(
    SystemID int not null,
    PlantsID int not null,
    primary key (SystemID, PlantsID),
    constraint SystemsPlantsAssignment_ibfk_1
        foreign key (SystemID) references Systems (SystemID),
    constraint SystemsPlantsAssignment_ibfk_2
        foreign key (PlantsID) references Plants (PlantsID)
);

create index PlantsID
    on SystemsPlantsAssignment (PlantsID);

create table TaxClasses
(
    TaxClassID int auto_increment
        primary key,
    TaxClass   varchar(255)   not null,
    TaxRate    decimal(10, 5) not null
);

create table Items
(
    ItemID            int auto_increment
        primary key,
    ItemName          varchar(255)                   not null,
    Description       text                           null,
    Manufacturer      varchar(255)                   null,
    Category          varchar(100)                   null,
    Price             decimal(10, 2)                 not null,
    TaxClassID        int                            not null,
    DiscountInPercent decimal(10, 5) default 0.00000 not null,
    ContentAmount     decimal(10, 2)                 null,
    Unit              varchar(50)                    null,
    EAN               varchar(13)                    null,
    UPC               varchar(12)                    null,
    ISBN              varchar(13)                    null,
    Stock             int                            null,
    Weight            decimal(10, 2)                 null,
    DimensionLength   decimal(10, 2)                 null,
    DimensionWidth    decimal(10, 2)                 null,
    DimensionHeight   decimal(10, 2)                 null,
    MetaTitle         varchar(255)                   null,
    MetaDescription   text                           null,
    URLSlug           varchar(255)                   null,
    Active            tinyint(1)     default 1       not null,
    constraint Items_ibfk_1
        foreign key (TaxClassID) references TaxClasses (TaxClassID)
);

create table ItemImages
(
    ImageID  int auto_increment
        primary key,
    ItemID   int          not null,
    ImageURL varchar(255) not null,
    constraint ItemImages_ibfk_1
        foreign key (ItemID) references Items (ItemID)
);

create index ItemID
    on ItemImages (ItemID);

create index TaxClassID
    on Items (TaxClassID);

create table auth_group
(
    id   int auto_increment
        primary key,
    name varchar(150) not null,
    constraint name
        unique (name)
);

create table auth_user
(
    id           int auto_increment
        primary key,
    password     varchar(128) not null,
    last_login   datetime(6)  null,
    is_superuser tinyint(1)   not null,
    username     varchar(150) not null,
    first_name   varchar(150) not null,
    last_name    varchar(150) not null,
    email        varchar(254) not null,
    is_staff     tinyint(1)   not null,
    is_active    tinyint(1)   not null,
    date_joined  datetime(6)  not null,
    constraint username
        unique (username)
);

create table Bugreports
(
    BugreportID        int auto_increment
        primary key,
    UserID             int                                                              not null,
    Description        text                                                             not null,
    CreatedAt          timestamp                              default CURRENT_TIMESTAMP null,
    Priority           enum ('low', 'medium', 'high')         default 'low'             not null,
    Status             enum ('open', 'in progress', 'closed') default 'open'            not null,
    CurrentProcessorID int                                                              null,
    LastUpdatedAt      timestamp                                                        null,
    constraint Bugreports_ibfk_1
        foreign key (UserID) references auth_user (id)
);

create table ContactInformation
(
    ContactID    int auto_increment
        primary key,
    UserID       int                                 not null,
    ContactType  enum ('Email', 'Telefon', 'Adress') not null,
    ContactValue text                                null,
    constraint ContactInformation_ibfk_1
        foreign key (UserID) references auth_user (id)
);

create table GreenhouseUserAssignment
(
    UserID       int not null,
    GreenhouseID int not null,
    primary key (UserID, GreenhouseID),
    constraint GreenhouseUserAssignment_ibfk_1
        foreign key (UserID) references auth_user (id),
    constraint GreenhouseUserAssignment_ibfk_2
        foreign key (GreenhouseID) references Greenhouses (GreenhouseID)
);

create index GreenhouseID
    on GreenhouseUserAssignment (GreenhouseID);

create table NotificationPreferences
(
    PreferenceID   int auto_increment
        primary key,
    UserID         int                                          not null,
    PreferenceType enum ('Email', 'SMS', 'App') default 'Email' not null,
    constraint NotificationPreferences_ibfk_1
        foreign key (UserID) references auth_user (id)
);

create table PasswordResetTokens
(
    TokenID   int auto_increment
        primary key,
    UserID    int                                 not null,
    Token     varchar(255)                        not null,
    CreatedAt timestamp default CURRENT_TIMESTAMP null,
    Status    enum ('Active', 'Used', 'Expired')  null,
    constraint PasswordResetTokens_ibfk_1
        foreign key (UserID) references auth_user (id)
);

create table Transactions
(
    TransactionsID        int auto_increment
        primary key,
    UserID                int                                     not null,
    Date                  date                                    not null,
    TotalAmount           decimal(10, 2)                          not null,
    Status                enum ('pending', 'completed', 'failed') null,
    ExternalTransactionID varchar(255)                            not null,
    constraint Transactions_ibfk_1
        foreign key (UserID) references auth_user (id)
);

create table TransactionItem
(
    TransactionItemID int auto_increment
        primary key,
    TransactionID     int not null,
    ItemID            int not null,
    Quantity          int not null,
    constraint TransactionItem_ibfk_1
        foreign key (TransactionID) references Transactions (TransactionsID),
    constraint TransactionItem_ibfk_2
        foreign key (ItemID) references Items (ItemID)
);

create index ItemID
    on TransactionItem (ItemID);

create index TransactionID
    on TransactionItem (TransactionID);

create table UserSubscriptions
(
    UserID           int          not null,
    SubscriptionType varchar(100) not null,
    StartDate        date         not null,
    EndDate          date         not null,
    primary key (UserID, SubscriptionType),
    constraint UserSubscriptions_ibfk_1
        foreign key (UserID) references auth_user (id),
    constraint UserSubscriptions_ibfk_2
        foreign key (SubscriptionType) references Subscriptions (SubscriptionType)
);

create index SubscriptionType
    on UserSubscriptions (SubscriptionType);

create table auth_user_groups
(
    id       bigint auto_increment
        primary key,
    user_id  int not null,
    group_id int not null,
    constraint auth_user_groups_user_id_group_id_94350c0c_uniq
        unique (user_id, group_id),
    constraint auth_user_groups_group_id_97559544_fk_auth_group_id
        foreign key (group_id) references auth_group (id),
    constraint auth_user_groups_user_id_6a12ed8b_fk_auth_user_id
        foreign key (user_id) references auth_user (id)
);

create table django_content_type
(
    id        int auto_increment
        primary key,
    app_label varchar(100) not null,
    model     varchar(100) not null,
    constraint django_content_type_app_label_model_76bd3d3b_uniq
        unique (app_label, model)
);

create table auth_permission
(
    id              int auto_increment
        primary key,
    name            varchar(255) not null,
    content_type_id int          not null,
    codename        varchar(100) not null,
    constraint auth_permission_content_type_id_codename_01ab375a_uniq
        unique (content_type_id, codename),
    constraint auth_permission_content_type_id_2f476e4b_fk_django_co
        foreign key (content_type_id) references django_content_type (id)
);

create table auth_group_permissions
(
    id            bigint auto_increment
        primary key,
    group_id      int not null,
    permission_id int not null,
    constraint auth_group_permissions_group_id_permission_id_0cd325b0_uniq
        unique (group_id, permission_id),
    constraint auth_group_permissio_permission_id_84c5c92e_fk_auth_perm
        foreign key (permission_id) references auth_permission (id),
    constraint auth_group_permissions_group_id_b120cbf9_fk_auth_group_id
        foreign key (group_id) references auth_group (id)
);

create table auth_user_user_permissions
(
    id            bigint auto_increment
        primary key,
    user_id       int not null,
    permission_id int not null,
    constraint auth_user_user_permissions_user_id_permission_id_14a6b632_uniq
        unique (user_id, permission_id),
    constraint auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm
        foreign key (permission_id) references auth_permission (id),
    constraint auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id
        foreign key (user_id) references auth_user (id)
);

create table django_admin_log
(
    id              int auto_increment
        primary key,
    action_time     datetime(6)       not null,
    object_id       longtext          null,
    object_repr     varchar(200)      not null,
    action_flag     smallint unsigned not null,
    change_message  longtext          not null,
    content_type_id int               null,
    user_id         int               not null,
    constraint django_admin_log_content_type_id_c4bce8eb_fk_django_co
        foreign key (content_type_id) references django_content_type (id),
    constraint django_admin_log_user_id_c564eba6_fk_auth_user_id
        foreign key (user_id) references auth_user (id),
    check (`action_flag` >= 0)
);

create table django_migrations
(
    id      bigint auto_increment
        primary key,
    app     varchar(255) not null,
    name    varchar(255) not null,
    applied datetime(6)  not null
);

create table django_session
(
    session_key  varchar(40) not null
        primary key,
    session_data longtext    not null,
    expire_date  datetime(6) not null
);

create index django_session_expire_date_a5c62663
    on django_session (expire_date);

create
    definer = db_admin@`%` procedure GetLatestSensorDataForSystem(IN system_id int)
BEGIN
    SELECT
        sys.SystemID,
        dev.DeviceID,
        dev.DeviceName,
        st.SensorType,
        hdd.Date,
        hdd.Time,
        hdd.Measurement AS LatestMeasurement,
        st.System_ValueName,
        st.Difference_Warning,
        st.Difference_Critical
    FROM
        Systems sys
    JOIN
        Devices dev ON sys.SystemID = dev.SystemID
    JOIN
        SensorTypes st ON dev.SensorTypeID = st.SensorTypeID
    JOIN
        HistoryDeviceData hdd ON dev.DeviceID = hdd.DeviceID
    WHERE
        hdd.HistoryDeviceDataID IN (
            SELECT MAX(HistoryDeviceDataID)
            FROM HistoryDeviceData
            GROUP BY DeviceID
        )
    AND
        sys.SystemID = system_id;
END;



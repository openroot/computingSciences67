/* */
CREATE TABLE `<database_name>`.`product` (
`id`                BIGINT(20)      UNSIGNED                        NOT NULL    AUTO_INCREMENT                                      COMMENT 'Primary key' ,
`created_at`        TIMESTAMP                                       NOT NULL                        DEFAULT CURRENT_TIMESTAMP       COMMENT 'Creation time' ,
`updated_at`        TIMESTAMP       on update CURRENT_TIMESTAMP     NULL                                                            COMMENT 'Last updated time' ,
`name`              VARCHAR(256)                                    NOT NULL                                                        COMMENT 'Product name' ,
`description`       TEXT                                            NULL                                                            COMMENT 'Product description' ,
`mrp`               DOUBLE                                          NULL                                                            COMMENT 'Maximum price',
`privateid`         VARCHAR(512)                                    NULL                                                            COMMENT 'Product private identifier' ,
`publicid`          VARCHAR(512)                                    NULL                                                            COMMENT 'Product public identifier' ,

PRIMARY KEY (`id`),
INDEX (`name`),
INDEX (`mrp`),
UNIQUE (`privateid`),
UNIQUE (`publicid`)
)
ENGINE = InnoDB;




CREATE TABLE `<database_name>`.`order` (
`id`                BIGINT(20)      UNSIGNED                        NOT NULL    AUTO_INCREMENT                                      COMMENT 'Primary key' ,
`created_at`        TIMESTAMP                                       NOT NULL                        DEFAULT CURRENT_TIMESTAMP       COMMENT 'Creation time' ,
`updated_at`        TIMESTAMP       on update CURRENT_TIMESTAMP     NULL                                                            COMMENT 'Last updated time' ,
`fk_product_id`     BIGINT(20)      UNSIGNED                        NOT NULL                                                        COMMENT 'Associated product id' ,
`quantity`          INT             UNSIGNED                        NULL                                                            COMMENT 'Ordered quantity' ,

PRIMARY KEY (`id`),
INDEX (`quantity`)
)
ENGINE = InnoDB;




ALTER TABLE `order`
ADD CONSTRAINT `fk_order_fk_product_id`
FOREIGN KEY ( `fk_product_id` )
REFERENCES `product` ( `id` )
ON DELETE CASCADE ON UPDATE RESTRICT; /* this should be the preferred most constraint, for foreign key */
/* */





/* */
/* Step 1 — Defining the Schema */
CREATE DATABASE IF NOT EXISTS `e_store`
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_general_ci;
SET default_storage_engine = INNODB;

CREATE TABLE `e_store`.`brands`(
`id` INT UNSIGNED NOT NULL auto_increment ,
`name` VARCHAR(250) NOT NULL ,
PRIMARY KEY(`id`)
);

CREATE TABLE `e_store`.`categories`(
`id` INT UNSIGNED NOT NULL auto_increment ,
`name` VARCHAR(250) NOT NULL ,
PRIMARY KEY(`id`)
);

CREATE TABLE `e_store`.`products`(
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
`name` VARCHAR(250) NOT NULL ,
`brand_id` INT UNSIGNED NOT NULL ,
`category_id` INT UNSIGNED NOT NULL ,
`attributes` JSON NOT NULL ,
PRIMARY KEY(`id`) ,
INDEX `CATEGORY_ID`(`category_id` ASC) ,
INDEX `BRAND_ID`(`brand_id` ASC) ,
CONSTRAINT `brand_id` FOREIGN KEY(`brand_id`) REFERENCES `e_store`.`brands`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE ,
CONSTRAINT `category_id` FOREIGN KEY(`category_id`) REFERENCES `e_store`.`categories`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO `e_store`.`brands`(`name`) VALUES ('Samsung');
INSERT INTO `e_store`.`brands`(`name`) VALUES ('Nokia');
INSERT INTO `e_store`.`brands`(`name`) VALUES ('Canon');
INSERT INTO `e_store`.`categories`(`name`) VALUES ('Television');
INSERT INTO `e_store`.`categories`(`name`) VALUES ('Mobile Phone');
INSERT INTO `e_store`.`categories`(`name`) VALUES ('Camera');

/* Step 2 — Creating Data in the JSON Field */
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Prime' , '1' , '1' ,
    '{"screen": "50 inch", "resolution": "2048 x 1152 pixels", "ports": {"hdmi": 1, "usb": 3}, "speakers": {"left": "10 watt", "right": "10 watt"}}');
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Octoview' , '1' , '1' ,
    '{"screen": "40 inch", "resolution": "1920 x 1080 pixels", "ports": {"hdmi": 1, "usb": 2}, "speakers": {"left": "10 watt", "right": "10 watt"}}');
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Dreamer' , '1' , '1' ,
    '{"screen": "30 inch", "resolution": "1600 x 900 pixles", "ports": {"hdmi": 1, "usb": 1}, "speakers": {"left": "10 watt", "right": "10 watt"}}');
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES( 'Bravia' , '1' , '1' ,
    '{"screen": "25 inch", "resolution": "1366 x 768 pixels", "ports": {"hdmi": 1, "usb": 0}, "speakers": {"left": "5 watt", "right": "5 watt"}}');
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Proton' , '1' , '1' ,
    '{"screen": "20 inch", "resolution": "1280 x 720 pixels", "ports": {"hdmi": 0, "usb": 0}, "speakers": {"left": "5 watt", "right": "5 watt"}}');

INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Desire' , '2' , '2' ,
    JSON_OBJECT(
        "network" , JSON_ARRAY("GSM" , "CDMA" , "HSPA" , "EVDO") ,
        "body" , "5.11 x 2.59 x 0.46 inches" ,
        "weight" , "143 grams" ,
        "sim" , "Micro-SIM" ,
        "display" , "4.5 inches" ,
        "resolution" , "720 x 1280 pixels" ,
        "os" , "Android Jellybean v4.3"
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Passion' , '2' , '2' ,
    JSON_OBJECT(
        "network" , JSON_ARRAY("GSM" , "CDMA" , "HSPA") ,
        "body" , "6.11 x 3.59 x 0.46 inches" ,
        "weight" , "145 grams" ,
        "sim" , "Micro-SIM" ,
        "display" , "4.5 inches" ,
        "resolution" , "720 x 1280 pixels" ,
        "os" , "Android Jellybean v4.3"
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Emotion' , '2' , '2' ,
    JSON_OBJECT(
        "network" , JSON_ARRAY("GSM" , "CDMA" , "EVDO") ,
        "body" , "5.50 x 2.50 x 0.50 inches" ,
        "weight" , "125 grams" ,
        "sim" , "Micro-SIM" ,
        "display" , "5.00 inches" ,
        "resolution" , "720 x 1280 pixels" ,
        "os" , "Android KitKat v4.3"
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Sensation' , '2' , '2' ,
    JSON_OBJECT(
        "network" , JSON_ARRAY("GSM" , "HSPA" , "EVDO") ,
        "body" , "4.00 x 2.00 x 0.75 inches" ,
        "weight" , "150 grams" ,
        "sim" , "Micro-SIM" ,
        "display" , "3.5 inches" ,
        "resolution" , "720 x 1280 pixels" ,
        "os" , "Android Lollipop v4.3"
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Joy' , '2' , '2' ,
    JSON_OBJECT(
        "network" , JSON_ARRAY("CDMA" , "HSPA" , "EVDO") ,
        "body" , "7.00 x 3.50 x 0.25 inches" ,
        "weight" , "250 grams" ,
        "sim" , "Micro-SIM" ,
        "display" , "6.5 inches" ,
        "resolution" , "1920 x 1080 pixels" ,
        "os" , "Android Marshmallow v4.3"
    )
);

INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Explorer' , '3' , '3' ,
    JSON_MERGE_PRESERVE(
        '{"sensor_type": "CMOS"}' ,
        '{"processor": "Digic DV III"}' ,
        '{"scanning_system": "progressive"}' ,
        '{"mount_type": "PL"}' ,
        '{"monitor_type": "LCD"}'
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Runner' , '3' , '3' ,
JSON_MERGE_PRESERVE(
    JSON_OBJECT("sensor_type" , "CMOS") ,
    JSON_OBJECT("processor" , "Digic DV II") ,
    JSON_OBJECT("scanning_system" , "progressive") ,
    JSON_OBJECT("mount_type" , "PL") ,
    JSON_OBJECT("monitor_type" , "LED")
)
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Traveler' , '3' , '3' ,
    JSON_MERGE_PRESERVE(
        JSON_OBJECT("sensor_type" , "CMOS") ,
        '{"processor": "Digic DV II"}' ,
        '{"scanning_system": "progressive"}' ,
        '{"mount_type": "PL"}' ,
        '{"monitor_type": "LCD"}'
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Walker' , '3' , '3' ,
    JSON_MERGE_PRESERVE(
        '{"sensor_type": "CMOS"}' ,
        '{"processor": "Digic DV I"}' ,
        '{"scanning_system": "progressive"}' ,
        '{"mount_type": "PL"}' ,
        '{"monitor_type": "LED"}'
    )
);
INSERT INTO `e_store`.`products`(`name` , `brand_id` , `category_id` , `attributes`)
VALUES('Jumper' , '3' , '3' ,
    JSON_MERGE_PRESERVE(
        '{"sensor_type": "CMOS"}' ,
        '{"processor": "Digic DV I"}' ,
        '{"scanning_system": "progressive"}' ,
        '{"mount_type": "PL"}' ,
        '{"monitor_type": "LCD"}'
    )
);

SELECT JSON_MERGE_PRESERVE('{"network": "GSM"}' , '{"network": "CDMA"}' , '{"network": "HSPA"}' , '{"network": "EVDO"}'); /* Output: {"network": ["GSM", "CDMA", "HSPA", "EVDO"]} */
SELECT JSON_TYPE(attributes) FROM `e_store`.`products`; /* This query will produce 15 OBJECT results to represent all of the products - five televisions, five mobile phones, and five cameras. */

/* Step 3 — Reading the Data from the JSON Field */
SELECT * FROM `e_store`.`products`
WHERE `category_id` = 1 AND JSON_EXTRACT(`attributes` , '$.ports.usb') > 0 AND JSON_EXTRACT(`attributes` , '$.ports.hdmi') > 0;
SELECT * FROM `e_store`.`products`
WHERE `category_id` = 1 AND `attributes` -> '$.ports.usb' > 0 AND `attributes` -> '$.ports.hdmi' > 0;

/* Step 4 — Updating Data in the JSON Field */
UPDATE `e_store`.`products`
SET `attributes` = JSON_INSERT(
    `attributes` ,
    '$.chipset' , 'Qualcomm'
)
WHERE `category_id` = 2; /* The JSON_INSERT function will only add the property to the object if it does not exists already. */
SELECT * FROM `e_store`.`products`
WHERE `category_id` = 2;

UPDATE `e_store`.`products`
SET `attributes` = JSON_REPLACE(
    `attributes` ,
    '$.chipset' ,
    'Qualcomm Snapdragon'
)
WHERE `category_id` = 2; /* The JSON_REPLACE function substitutes the property only if it is found. */

UPDATE `e_store`.`products`
SET `attributes` = JSON_SET(
    `attributes` ,
    '$.body_color' ,
    'red'
)
WHERE `category_id` = 1; /* The JSON_SET function will add the property if it is not found else replace it. */

/* Step 5 — Deleting Data from the JSON Field */
UPDATE `e_store`.`products`
SET `attributes` = JSON_REMOVE(`attributes` , '$.mount_type')
WHERE `category_id` = 3; /* JSON_REMOVE allows you to delete a certain key/value from your JSON columns. Using JSON_REMOVE function, it is possible to remove the mount_type key/value pairs from all cameras:
The JSON_REMOVE function returns the updated JSON after removing the specified key based on the path expression. */

DELETE FROM `e_store`.`products`
WHERE `category_id` = 2
AND JSON_EXTRACT(`attributes` , '$.os') LIKE '%Jellybean%'; /* Alternatively, you can DELETE entire rows using a JSON column.
Using DELETE and JSON_EXTRACT and LIKE, it is possible to remove all the mobile phones that have the “Jellybean” version of the Android operating system:
This query will remove the “Desire” and “Passion” models of mobile phones.
Working with a specific attribute requires the use of the JSON_EXTRACT function. First, the os property of mobile phones is extracted. And then the LIKE operator is applied to DELETE all records that contain the string Jellybean. */
/* */





/* */
CREATE TABLE `<database_name>`.`_template` (
    /* meta fields */
    `_metaid`           BIGINT      UNSIGNED    NOT NULL                                AUTO_INCREMENT  COMMENT 'meta field',
    `_metacreatedon`    TIMESTAMP               NOT NULL    DEFAULT CURRENT_TIMESTAMP                   COMMENT 'meta field',
    `_metatouchedon`    TIMESTAMP               NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaisvalid`      BOOLEAN                 NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaorder`        BIGINT                  NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaauthor`       VARCHAR(64)             NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaidconnect`    BIGINT                  NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaidinitial`    BIGINT                  NULL        DEFAULT NULL                                COMMENT 'meta field',
    `_metaiscurrent`    BOOLEAN                 NULL        DEFAULT NULL                                COMMENT 'meta field',
    /* ,table specific ,field(s) any */
    `_topic_sample`     VARCHAR(256)            NULL        DEFAULT NULL                                COMMENT 'table specific field',
    `_value_sample`     JSON                    NULL        DEFAULT NULL                                COMMENT 'table specific field',
    /* indexes */
    PRIMARY KEY             (`_metaid`),
    INDEX `_metaisvalid`    (`_metaisvalid`),
    INDEX `_metaidinitial`  (`_metaidinitial`),
    INDEX `_metaauthor`     (`_metaauthor`),
    INDEX `_metaiscurrent`  (`_metaiscurrent`),
    UNIQUE `_metaorder`     (`_metaorder`)
) ENGINE = MyISAM COMMENT = '_template table ,with two sample fields.';
/* */

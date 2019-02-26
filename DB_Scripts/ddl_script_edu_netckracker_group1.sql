/* EDU-NETCRAKCER GROUP1 DDL SCRIPT */

DROP TABLE IF EXISTS USER_A CASCADE;
DROP TABLE IF EXISTS ROLE_A CASCADE;
DROP TABLE IF EXISTS ASSIGNED_ROLE;
DROP TABLE IF EXISTS TICKET CASCADE;
DROP TABLE IF EXISTS TICKET_CLASS CASCADE;
DROP TABLE IF EXISTS TRIP CASCADE;
DROP TABLE IF EXISTS VEHICLE;
DROP TABLE IF EXISTS REPORT CASCADE;
DROP TABLE IF EXISTS REPORT_REPLY;
DROP TABLE IF EXISTS FEEDBACK;
DROP TABLE IF EXISTS SPACEPORT;
DROP TABLE IF EXISTS PLANET;
DROP TABLE IF EXISTS SERVICE CASCADE;
DROP TABLE IF EXISTS POSSIBLE_SERVICE CASCADE;
DROP TABLE IF EXISTS BOUGHT_SERVICE;
DROP TABLE IF EXISTS BUNDLE CASCADE;
DROP TABLE IF EXISTS BUNDLE_CLASS;
DROP TABLE IF EXISTS BUNDLE_SERVICE;
DROP TABLE IF EXISTS DISCOUNT CASCADE;
DROP TABLE IF EXISTS DISCOUNT_CLASS;
DROP TABLE IF EXISTS DISCOUNT_SERVICE;
DROP TABLE IF EXISTS NOTIFICATION;
DROP TABLE IF EXISTS NOTIFICATION_OBJECT;
DROP TABLE IF EXISTS SCHEDULE;
DROP TABLE IF EXISTS SUBSCRIPTION;

CREATE TABLE USER_A (
  USER_ID        SERIAL PRIMARY KEY,
  USER_NAME      VARCHAR(40) NOT NULL,
  USER_PASSWORD  VARCHAR(64) NOT NULL,
  USER_EMAIL     VARCHAR(40) NOT NULL UNIQUE,
  USER_TELEPHONE VARCHAR(15),
  USER_TOKEN     VARCHAR(256),
  USER_ACTIVATED BOOLEAN,
  USER_CREATED   DATE        NOT NULL
);

CREATE TABLE SUBSCRIPTION (
  USER_ID    INTEGER REFERENCES USER_A (USER_ID),
  CARRIER_ID INTEGER REFERENCES USER_A (USER_ID)
);

CREATE TABLE ROLE_A (
  ROLE_ID   SERIAL PRIMARY KEY,
  ROLE_NAME VARCHAR(18) NOT NULL
);

CREATE TABLE ASSIGNED_ROLE (
  USER_ID INTEGER REFERENCES USER_A (USER_ID),
  ROLE_ID INTEGER REFERENCES ROLE_A (ROLE_ID)
);

CREATE TABLE VEHICLE (
  VEHICLE_ID    SERIAL PRIMARY KEY,
  OWNER_ID      INTEGER REFERENCES USER_A (USER_ID),
  VEHICLE_NAME  VARCHAR(20) NOT NULL,
  VEHICLE_SEATS INTEGER     NOT NULL
);

CREATE TABLE PLANET (
  PLANET_ID   SERIAL PRIMARY KEY,
  PLANET_NAME VARCHAR(20) NOT NULL
);

CREATE TABLE SPACEPORT (
  SPACEPORT_ID   SERIAL PRIMARY KEY,
  SPACEPORT_NAME VARCHAR(40) NOT NULL,
  CREATION_DATE  DATE        NOT NULL,
  PLANET_ID      INTEGER REFERENCES PLANET (PLANET_ID)
);

-- TIMESTAMP - date and time with time zones
CREATE TABLE TRIP (
  TRIP_ID        SERIAL PRIMARY KEY,
  VEHICLE_ID     INTEGER REFERENCES VEHICLE (VEHICLE_ID),
  TRIP_STATUS    INTEGER,
  DEPARTURE_DATE TIMESTAMP    NOT NULL,
  ARRIVAL_DATE   TIMESTAMP    NOT NULL,
  DEPARTURE_ID   INTEGER REFERENCES SPACEPORT (SPACEPORT_ID),
  ARRIVAL_ID     INTEGER REFERENCES SPACEPORT (SPACEPORT_ID),
  TRIP_PHOTO     VARCHAR(128) NOT NULL,
  APPROVER_ID    INTEGER REFERENCES USER_A (USER_ID),
  CREATION_DATE  DATE         NOT NULL
);

CREATE TABLE TICKET_CLASS (
  CLASS_ID     SERIAL PRIMARY KEY,
  TRIP_ID      INTEGER REFERENCES TRIP (TRIP_ID),
  TICKET_PRICE INTEGER NOT NULL
);

CREATE TABLE TICKET (
  TICKET_ID     SERIAL PRIMARY KEY,
  PASSENGER_ID  INTEGER REFERENCES USER_A (USER_ID),
  CLASS_ID      INTEGER REFERENCES TICKET_CLASS (CLASS_ID),
  SEAT          INTEGER NOT NULL,
  PURCHASE_DATE TIMESTAMP
);

CREATE TABLE REPORT (
  REPORT_ID     SERIAL PRIMARY KEY,
  REPORTER_ID   INTEGER REFERENCES USER_A (USER_ID),
  APPROVER_ID   INTEGER REFERENCES USER_A (USER_ID),
  TRIP_ID       INTEGER REFERENCES TRIP (TRIP_ID),
  STATUS        INTEGER   NOT NULL,
  REPORT_RATE   INTEGER,
  REPORT_TEXT   TEXT      NOT NULL,
  CREATION_DATE TIMESTAMP NOT NULL
);

CREATE TABLE FEEDBACK (
  REPORTER_ID   INTEGER REFERENCES USER_A (USER_ID),
  APPROVER_ID   INTEGER REFERENCES USER_A (USER_ID),
  TRIP_ID       INTEGER REFERENCES TRIP (TRIP_ID),
  STATUS        INTEGER   NOT NULL,
  FEEDBACK_RATE INTEGER,
  FEEDBACK_TEXT TEXT      NOT NULL,
  CREATION_DATE TIMESTAMP NOT NULL
);


CREATE TABLE REPORT_REPLY (
  REPORT_ID     INTEGER REFERENCES REPORT (REPORT_ID),
  WRITER_ID     INTEGER REFERENCES USER_A (USER_ID),
  REPLY_TEXT    TEXT      NOT NULL,
  CREATION_DATE TIMESTAMP NOT NULL
);

CREATE TABLE SERVICE (
  SERVICE_ID          SERIAL PRIMARY KEY,
  SERVICE_NAME        VARCHAR(20) NOT NULL,
  SERVICE_DESCRIPTION VARCHAR(255)
);

CREATE TABLE POSSIBLE_SERVICE (
  P_SERVICE_ID  SERIAL PRIMARY KEY,
  SERVICE_ID    INTEGER REFERENCES SERVICE (SERVICE_ID),
  CLASS_ID      INTEGER REFERENCES TICKET_CLASS (CLASS_ID),
  SERVICE_PRICE INTEGER NOT NULL
);

CREATE TABLE BOUGHT_SERVICE (
  P_SERVICE_ID INTEGER REFERENCES POSSIBLE_SERVICE (P_SERVICE_ID),
  TICKET_ID    INTEGER REFERENCES TICKET (TICKET_ID)
);

CREATE TABLE BUNDLE (
  BUNDLE_ID          SERIAL PRIMARY KEY,
  START_DATE         DATE         NOT NULL,
  FINISH_DATE        DATE         NOT NULL,
  BUNDLE_PRICE       INTEGER      NOT NULL,
  BUNDLE_DESCRIPTION VARCHAR(255),
  BUNDLE_PHOTO       VARCHAR(128) NOT NULL
);

CREATE TABLE BUNDLE_CLASS (
  BUNDLE_ID   INTEGER REFERENCES BUNDLE (BUNDLE_ID),
  CLASS_ID    INTEGER REFERENCES TICKET_CLASS (CLASS_ID),
  ITEM_NUMBER INTEGER NOT NULL
);

CREATE TABLE BUNDLE_SERVICE (
  BUNDLE_ID    INTEGER REFERENCES BUNDLE (BUNDLE_ID),
  P_SERVICE_ID INTEGER REFERENCES POSSIBLE_SERVICE (P_SERVICE_ID),
  ITEM_NUMBER  INTEGER NOT NULL
);

CREATE TABLE DISCOUNT (
  DISCOUNT_ID   SERIAL PRIMARY KEY,
  START_DATE    DATE    NOT NULL,
  FINISH_DATE   DATE    NOT NULL,
  DISCOUNT_RATE INTEGER NOT NULL,
  DISCOUNT_TYPE BOOLEAN
);

CREATE TABLE DISCOUNT_CLASS (
  DISCOUNT_ID INTEGER REFERENCES DISCOUNT (DISCOUNT_ID),
  CLASS_ID    INTEGER REFERENCES TICKET_CLASS (CLASS_ID)
);

CREATE TABLE DISCOUNT_SERVICE (
  DISCOUNT_ID  INTEGER REFERENCES DISCOUNT (DISCOUNT_ID),
  P_SERVICE_ID INTEGER REFERENCES POSSIBLE_SERVICE (P_SERVICE_ID)
);

CREATE TABLE SCHEDULE (
  TRIP_ID       INTEGER REFERENCES TRIP (TRIP_ID),
  START_DATE    DATE    NOT NULL,
  FINISH_DATE   DATE    NOT NULL,
  INTERVAL      INTEGER NOT NULL,
  CREATION_DATE DATE    NOT NULL
);

CREATE TABLE NOTIFICATION_OBJECT (
  OBJECT_ID      SERIAL PRIMARY KEY,
  ACTOR_ID       INTEGER REFERENCES USER_A (USER_ID),
  ENTITY_TYPE_ID INTEGER NOT NULL,
  ENTITY_ID      INTEGER NOT NULL,
  CREATED_ON     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  STATUS         INTEGER NOT NULL
);

CREATE TABLE NOTIFICATION (
  NOTIFICATION_ID SERIAL PRIMARY KEY,
  OBJECT_ID       INTEGER REFERENCES NOTIFICATION_OBJECT (OBJECT_ID),
  NOTIFIER_ID     INTEGER REFERENCES USER_A (USER_ID),
  STATUS          INTEGER NOT NULL
);


insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('smillions0', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'daslott0@globo.com', '5066512688', null, true,
        '2018-08-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('kstollmeier1', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'glunn1@newyorker.com', '7267344912', null, false,
        '2018-12-20');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('bbarg2', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'cturner2@usatoday.com', '8288653181', null, true,
        '2018-10-02');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('cmallock3', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'bkeasey3@europa.eu', '6769109678', null, false,
        '2018-09-25');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('amcduffy4', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ocapitano4@springer.com', '8099658999', null, true,
        '2018-12-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('ncolbran5', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'volennachain5@lulu.com', '4977455075', null, false,
        '2018-09-23');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('mstebles6', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'aissacof6@nih.gov', '2111984543', null, false,
        '2018-09-26');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('rcuzen7', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'afurby7@yale.edu', '2877201380', null, true, '2018-08-21');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('kbrinkley8', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'astockings8@xinhuanet.com', '6301410308', null, false,
   '2018-09-01');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('lheggie9', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'jfinnigan9@i2i.jp', '4461166030', null, false,
        '2019-02-12');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('nwallegea', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'zthyinga@discuz.net', '2645882954', null, true,
        '2018-08-22');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('mmundeeb', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'pzambonb@reverbnation.com', '1431589105', null, false,
        '2018-09-05');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('jtrahearc', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'cminghettic@webnode.com', '5927917825', null, false,
        '2018-11-23');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('locurrigand', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'eswedelandd@weebly.com', '2221630447', null, false,
        '2019-01-13');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('zrowbothame', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'asnawdone@tuttocitta.it', '7551750078', null, true,
        '2018-09-28');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('hcreykef', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mstichallf@gmpg.org', '4871917729', null, false,
        '2018-10-06');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('cmartinieg', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'gholtg@tinypic.com', '4308043814', null, false,
        '2018-08-18');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('hiornsh', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'pfanshaweh@nbcnews.com', '5375746124', null, false,
        '2019-01-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('mattwelli', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'hkembreyi@instagram.com', '2362071272', null, false,
        '2018-09-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('cmulroyj', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'swellingj@tinypic.com', '5132776191', null, true,
        '2018-10-24');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('ekirkamk', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'sstortonk@deliciousdays.com', '6352053761', null, false,
   '2018-12-06');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('mpopescul', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'zwiltsherl@webmd.com', '2554745062', null, false,
        '2018-08-12');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('scaghanm', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mkernerm@kickstarter.com', '9189304771', null, false,
        '2018-11-27');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('erigollen', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'szellnern@paginegialle.it', '4655383946', null, false,
        '2019-02-03');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('tbagenalo', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ecustardo@reddit.com', '8917349055', null, false,
        '2018-12-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('agennrichp', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'adanilevichp@blogger.com', '8269890096', null, true,
        '2018-10-20');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('ssmallboneq', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ijeanneauq@webs.com', '9765029944', null, true,
        '2018-08-25');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('ccourteser', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ayerrallr@360.cn', '4619726184', null, true,
        '2018-10-09');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('bscreachs', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'rspeers@apache.org', '1077983994', null, true,
        '2018-11-01');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('fcasserlyt', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ncrowestt@cnet.com', '1047194135', null, false,
        '2018-11-02');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('cpeacheyu', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mrickeardu@noaa.gov', '2964053052', null, false,
        '2018-08-10');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('bvickerstaffv', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'chucksteppv@smugmug.com', '6603572844', null, false,
   '2019-01-04');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('lwalterw', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'oclemensonw@sina.com.cn', '7547834271', null, false,
        '2018-10-21');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('jstopperx', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'jcammishx@wikia.com', '3543911762', null, false,
        '2018-10-22');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('smaruskay', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'goelsy@mapy.cz', '8022392180', null, false, '2019-01-11');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('rdutnellz', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'cpiattoz@xing.com', '9617914965', null, false,
        '2018-11-23');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('jcrowcher10', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'thordell10@wp.com', '3516854965', null, false,
        '2019-01-20');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('cgalilee11', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'elewty11@typepad.com', '8965599290', null, false,
        '2018-11-18');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('kpiff12', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'kmusson12@fc2.com', '8711806461', null, true, '2018-11-06');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('snajera13', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'kjanu13@ucoz.com', '8019437846', null, false,
        '2018-09-07');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('wdodwell14', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'jtrammel14@examiner.com', '9265862246', null, true,
        '2018-08-05');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('dscholz15', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'acafferky15@w3.org', '6677191417', null, true,
        '2018-10-15');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('rtiesman16', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'gyelyashev16@smh.com.au', '5175841597', null, true,
        '2018-12-29');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('obende17', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'tcollin17@hubpages.com', '4168158332', null, true,
        '2018-12-02');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('cpetruk18', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'sbradnick18@miibeian.gov.cn', '8225224044', null, false,
   '2018-10-25');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('wpaternoster19', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'ldespenser19@google.com.hk', '5862972063', null,
        false, '2018-11-25');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values
  ('jfosdick1a', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'fgryglewski1a@walmart.com', '4615099881', null, false,
   '2018-11-06');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('pbenezet1b', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mbeggi1b@ehow.com', '7171222128', null, true,
        '2019-02-13');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('gkerridge1c', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mreis1c@bbc.co.uk', '3614491455', null, true,
        '2018-08-25');
insert into USER_A (USER_NAME, USER_PASSWORD, USER_EMAIL, USER_TELEPHONE, USER_TOKEN, USER_ACTIVATED, USER_CREATED)
values ('docahsedy1d', '055228cb4b2aafd8f4127ede8d8a7cef9a36ea0a', 'mjenicek1d@princeton.edu', '5244218170', null, true,
        '2018-08-22');

insert into ROLE_A (ROLE_NAME) values ('ROLE_ADMIN');
insert into ROLE_A (ROLE_NAME) values ('ROLE_USER');
insert into ROLE_A (ROLE_NAME) values ('ROLE_CARRIER');
insert into ROLE_A (ROLE_NAME) values ('ROLE_APPROVER');

insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (1, 1);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (1, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (2, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (3, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (4, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (5, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (6, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (7, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (8, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (9, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (10, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (11, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (12, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (13, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (14, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (15, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (16, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (17, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (18, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (19, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (20, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (21, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (22, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (23, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (24, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (25, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (26, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (27, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (28, 2);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (29, 3);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (30, 3);

insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (31, 30);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (32, 24);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (50, 30);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (32, 30);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 11);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 16);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 17);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 18);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 19);
insert into SUBSCRIPTION (USER_ID, CARRIER_ID) values (42, 20);

insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (11, 'ut', 15);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (21, 'mollis', 17);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (11, 'aliquet pulvinar', 10);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (18, 'eu', 20);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (30, 'metus', 15);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (24, 'massa volutpat', 16);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (16, 'faucibus', 18);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (16, 'eget', 12);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (16, 'leo', 18);
insert into VEHICLE (OWNER_ID, VEHICLE_NAME, VEHICLE_SEATS) values (8, 'proin at', 10);

insert into PLANET (PLANET_NAME) values ('EARTH');
insert into PLANET (PLANET_NAME) values ('MOON');
insert into PLANET (PLANET_NAME) values ('VENUS');
insert into PLANET (PLANET_NAME) values ('MARS');
insert into PLANET (PLANET_NAME) values ('NIBIRU');

insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('laoreet', '2017-07-06', 5);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('elementum', '2017-10-04', 4);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('erat', '2017-05-04', 3);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('sapien', '2018-12-22', 3);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('lacus', '2018-05-21', 4);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('placerat', '2018-12-31', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('vulputate', '2019-03-03', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('a', '2018-05-13', 3);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('neque', '2019-02-01', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('sed', '2017-09-26', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('at', '2018-09-03', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('egestas', '2017-05-25', 4);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('sem', '2017-12-19', 5);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('tellus', '2018-07-01', 4);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('vel', '2019-01-10', 5);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('convallis', '2018-12-24', 1);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('libero', '2019-02-17', 4);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('turpis', '2019-03-12', 2);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('porta', '2018-05-10', 2);
insert into SPACEPORT (SPACEPORT_NAME, CREATION_DATE, PLANET_ID) values ('sapien', '2017-09-23', 5);

insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, CREATION_DATE)
values (10, 1, '2018-02-23', '2019-11-28', 14, 1, 'PrimisIn.png', '2019-01-23');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, CREATION_DATE)
values (3, 2, '2018-07-11', '2019-10-07', 19, 9, 'At.tiff', '2017-12-17');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, APPROVER_ID, CREATION_DATE)
values (8, 3, '2018-10-28', '2019-10-01', 4, 8, 'OrciLuctus.tiff', 3, '2019-01-08');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, APPROVER_ID, CREATION_DATE)
values (2, 4, '2018-04-29', '2019-04-26', 19, 9, 'VivamusMetus.gif', 3, '2016-08-03');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, APPROVER_ID, CREATION_DATE)
values (7, 5, '2018-01-15', '2019-01-06', 13, 19, 'QuamFringilla.tiff', 3, '2019-01-09');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, APPROVER_ID, CREATION_DATE)
values (8, 6, '2018-08-12', '2019-12-21', 3, 2, 'IntegerTincidunt.jpeg', 2, '2017-10-28');
insert into TRIP (VEHICLE_ID, TRIP_STATUS, DEPARTURE_DATE, ARRIVAL_DATE, DEPARTURE_ID, ARRIVAL_ID, TRIP_PHOTO, APPROVER_ID, CREATION_DATE)
values (4, 7, '2018-02-18', '2019-09-14', 7, 14, 'LacusMorbiSem.jpeg', 13, '2018-10-07');

insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (1, 24453);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (1, 34666);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (2, 15787);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (2, 17247);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (3, 32192);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (3, 39187);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (4, 25191);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (4, 32588);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (5, 13582);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (5, 27469);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (6, 14015);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (6, 16637);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (7, 10664);
insert into TICKET_CLASS (TRIP_ID, TICKET_PRICE) values (7, 22534);

insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 1, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 1, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 1, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 1, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 2, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 4, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 3, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 4, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 3, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 3, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 3, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 3, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 4, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 4, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 4, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 5, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 5, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 5, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 5, 11, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 6, 12, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 8, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (33, 8, 6, '2018-05-02');
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 8, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 8, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 8, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 8, 11, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 12, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 7, 13, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (48, 7, 14, '2018-06-13');
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (50, 7, 15, '2018-05-13');
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (48, 7, 16, '2018-06-13');
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (1, 8, 17, '2018-05-13');
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 11, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 12, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 13, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 14, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 15, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 16, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 10, 17, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 9, 18, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 12, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 12, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 12, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 12, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 11, 11, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 12, 12, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 1, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 2, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 3, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 4, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 5, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 6, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 7, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 8, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 9, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 10, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 14, 11, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 12, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 13, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 14, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 15, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 16, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 17, null);
insert into TICKET (PASSENGER_ID, CLASS_ID, SEAT, PURCHASE_DATE) values (null, 13, 18, null);

insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION)
values ('ultrices', 'sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values ('metus',
                                                                'vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values ('sed',
                                                                'massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values ('nulla',
                                                                'ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION)
values ('ut', 'eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values
  ('eu', 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values ('ligula',
                                                                'vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION)
values ('nisi', 'morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION) values ('mattis',
                                                                'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien');
insert into SERVICE (SERVICE_NAME, SERVICE_DESCRIPTION)
values ('suspendisse', 'erat quisque erat eros viverra eget congue eget semper rutrum');

insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (3, 8, 716);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 8, 131);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (7, 8, 921);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (5, 4, 379);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (5, 9, 105);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (9, 3, 747);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 11, 760);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 10, 816);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (8, 4, 284);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (10, 4, 151);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 10, 577);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 9, 655);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (3, 2, 449);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (8, 7, 783);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (8, 13, 808);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (7, 10, 851);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 11, 511);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (10, 14, 604);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 12, 219);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 12, 670);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 9, 476);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (9, 7, 649);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (2, 5, 914);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (2, 2, 573);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 10, 630);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 3, 810);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (9, 1, 597);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (8, 11, 975);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 12, 761);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (7, 6, 898);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 9, 903);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (5, 13, 171);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (2, 5, 667);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 4, 431);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 9, 441);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (10, 11, 605);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (3, 14, 411);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 11, 323);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (10, 6, 254);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (9, 7, 114);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 14, 809);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 10, 943);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (3, 2, 395);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (10, 14, 963);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (8, 1, 473);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (6, 5, 291);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (4, 9, 743);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (1, 1, 635);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (7, 4, 875);
insert into POSSIBLE_SERVICE (SERVICE_ID, CLASS_ID, SERVICE_PRICE) values (9, 14, 607);

insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (1, 40);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (2, 40);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (14, 38);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (22, 38);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (22, 37);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (40, 38);
insert into BOUGHT_SERVICE (P_SERVICE_ID, TICKET_ID) values (40, 37);

insert into BUNDLE (START_DATE, FINISH_DATE, BUNDLE_PRICE, BUNDLE_DESCRIPTION, BUNDLE_PHOTO) values
  ('2018-08-15', '2019-04-15', 1883,
   'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer',
   'Semper.jpeg');
insert into BUNDLE (START_DATE, FINISH_DATE, BUNDLE_PRICE, BUNDLE_DESCRIPTION, BUNDLE_PHOTO) values
  ('2018-11-20', '2019-04-29', 2669,
   'libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus',
   'Eu.tiff');
insert into BUNDLE (START_DATE, FINISH_DATE, BUNDLE_PRICE, BUNDLE_DESCRIPTION, BUNDLE_PHOTO) values
  ('2018-12-04', '2019-04-29', 2302,
   'etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit',
   'SapienUt.gif');
insert into BUNDLE (START_DATE, FINISH_DATE, BUNDLE_PRICE, BUNDLE_DESCRIPTION, BUNDLE_PHOTO) values
  ('2018-11-07', '2019-04-19', 4446, 'ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit',
   'AeneanLectus.gif');

insert into BUNDLE_CLASS (BUNDLE_ID, CLASS_ID, ITEM_NUMBER) values (3, 7, 2);
insert into BUNDLE_CLASS (BUNDLE_ID, CLASS_ID, ITEM_NUMBER) values (3, 8, 1);
insert into BUNDLE_CLASS (BUNDLE_ID, CLASS_ID, ITEM_NUMBER) values (1, 7, 2);
insert into BUNDLE_CLASS (BUNDLE_ID, CLASS_ID, ITEM_NUMBER) values (2, 7, 5);
insert into BUNDLE_CLASS (BUNDLE_ID, CLASS_ID, ITEM_NUMBER) values (4, 8, 3);

insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (1, 14, 2);
insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (1, 22, 2);
insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (2, 40, 5);
insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (4, 1, 3);
insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (4, 2, 3);
insert into BUNDLE_SERVICE (BUNDLE_ID, P_SERVICE_ID, ITEM_NUMBER) values (4, 3, 3);

insert into DISCOUNT (START_DATE, FINISH_DATE, DISCOUNT_RATE, DISCOUNT_TYPE)
values ('2018-10-14', '2019-02-03', 14, true);
insert into DISCOUNT (START_DATE, FINISH_DATE, DISCOUNT_RATE, DISCOUNT_TYPE)
values ('2018-09-11', '2019-04-16', 12, true);
insert into DISCOUNT (START_DATE, FINISH_DATE, DISCOUNT_RATE, DISCOUNT_TYPE)
values ('2018-07-20', '2019-04-19', 79, false);
insert into DISCOUNT (START_DATE, FINISH_DATE, DISCOUNT_RATE, DISCOUNT_TYPE)
values ('2018-06-17', '2019-03-06', 19, true);

insert into DISCOUNT_CLASS (DISCOUNT_ID, CLASS_ID) values (1, 7);
insert into DISCOUNT_CLASS (DISCOUNT_ID, CLASS_ID) values (4, 7);
insert into DISCOUNT_CLASS (DISCOUNT_ID, CLASS_ID) values (1, 8);

insert into DISCOUNT_SERVICE (DISCOUNT_ID, P_SERVICE_ID) values (2, 1);
insert into DISCOUNT_SERVICE (DISCOUNT_ID, P_SERVICE_ID) values (2, 2);
insert into DISCOUNT_SERVICE (DISCOUNT_ID, P_SERVICE_ID) values (2, 3);
insert into DISCOUNT_SERVICE (DISCOUNT_ID, P_SERVICE_ID) values (3, 14);
insert into DISCOUNT_SERVICE (DISCOUNT_ID, P_SERVICE_ID) values (3, 22);

insert into SCHEDULE (START_DATE, FINISH_DATE, INTERVAL, CREATION_DATE)
values ('2016-08-03', '2020-08-03', 365, '2016-08-02');

insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE) values
  (15, null, 7, 1, null, 'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit',
   '2018-12-09');
insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE) values
  (35, 2, 7, 2, null, 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo',
   '2019-01-25');
insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE) values
  (36, 2, 6, 3, null,
   'duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh',
   '2018-12-28');
insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE) values
  (20, 3, 6, 4, null,
   'eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt', '2019-01-19');
insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE)
values (21, 3, 6, 5, 1, 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque', '2019-02-20');
insert into REPORT (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, REPORT_RATE, REPORT_TEXT, CREATION_DATE)
values (38, 4, 6, 6, null, 'aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', '2019-02-03');

insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values (6, 12,
                                                                                   'non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie',
                                                                                   '2019-03-12');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values (3, 13,
                                                                                   'augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet',
                                                                                   '2018-12-29');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values
  (3, 2, 'cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing',
   '2018-12-30');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values
  (2, 1, 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat',
   '2019-02-25');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values
  (3, 3, 'est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi',
   '2018-12-31');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values (5, 7,
                                                                                   'felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis',
                                                                                   '2019-12-18');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE)
values (5, 3, 'vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci', '2019-12-17');
insert into REPORT_REPLY (REPORT_ID, WRITER_ID, REPLY_TEXT, CREATION_DATE) values (3, 11,
                                                                                   'platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia',
                                                                                   '2019-01-28');

insert into FEEDBACK (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, FEEDBACK_RATE, FEEDBACK_TEXT, CREATION_DATE) values
  (44, null, 7, 1, 2,
   'velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat', '2019-01-17');
insert into FEEDBACK (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, FEEDBACK_RATE, FEEDBACK_TEXT, CREATION_DATE) values
  (32, 3, 6, 2, 10, 'morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', '2019-01-15');
insert into FEEDBACK (REPORTER_ID, APPROVER_ID, TRIP_ID, STATUS, FEEDBACK_RATE, FEEDBACK_TEXT, CREATION_DATE) values
  (19, 4, 5, 3, 10,
   'purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut',
   '2019-01-29');

INSERT INTO "user_a" (user_name, user_password, user_email, user_telephone, user_activated, user_created)
VALUES ('Isabelle', 'AOE63WGC1CF', 'sociis@odio.org', '(01329) 18558', false, '2018-05-16'),
  ('Edan', 'ZYG96YVW4AW', 'vel.est@dolor.ca', '(011171) 96231', false, '2018-08-26'),
  ('Xanthus', 'KSK30YRL5OW', 'Nullam.nisl@modales.net', '0800 339408', false, '2018-10-12'),
  ('Norman', 'DGO56VDD3MX', 'Pellentesque@at.net', '(024) 6668 4647', true, '2018-10-09'),
  ('Tallulah', 'JRY66AIH7FB', 'euismod@neque.net', '0877 792 6753', true, '2019-01-27'),
  ('Evan', 'FTQ95ECW7EK', 'eu.sem@lectussitamet.com', '(01674) 43406', false, '2019-01-12'),
  ('Rebecca', 'LZU70WAS1XK', 'netus@Namacnulla.org', '055 8403 1640', false, '2019-01-11'),
  ('Garrett', 'ZMB82XZH8ZX', 'ridiculus@lorgilla.org', '0800 487 9978', false, '2018-10-30'),
  ('Aurelia', 'JLF05SNO0OO', 'feugiat@molestieorci.ca', '055 9053 9374', true, '2018-06-25'),
  ('Darius', 'XFH62UKI4MK', 'libero.Morbi.accumsan@enean.edu', '0382 863 0163', true, '2018-11-17');
INSERT INTO "user_a" (user_name, user_password, user_email, user_telephone, user_activated, user_created)
VALUES ('Aphrodite', 'QMR37GCO4PE', 'Vivamus@quepurus.org', '0992 947 5892', false, '2019-01-23'),
  ('Kelly', 'AQS58QDH9UY', 'Aliquam.erat.volutpat@rringilla.co.uk', '(0114) 570 2823', true, '2019-01-16'),
  ('Oleg', 'LKM16ABG3VB', 'adipiscing@adisus.net', '0800 194520', false, '2018-05-01'),
  ('Colorado', 'XGK16TSV9ML', 'faucibus.lectus@est.edu', '076 2757 6347', false, '2018-09-25'),
  ('Connor', 'MBN44FZP8DZ', 'mauris.sapien.cursus@ctetuer.co.uk', '0800 649 0993', false, '2018-04-10'),
  ('Brenden', 'TVJ25VLS2PX', 'luctus@varius.com', '(016977) 7014', false, '2018-10-17'),
  ('Sara', 'QKA21HZA3RL', 'Sed@dui.ca', '(01955) 58755', false, '2018-12-30'),
  ('Leo', 'ZBA37WAF7ZA', 'risus.metus@ultrices.com', '(027) 5554 4316', false, '2018-07-23'),
  ('Kelsey', 'ZOD95WZU3HY', 'odio@egestas.com', '0500 306319', false, '2019-01-23'),
  ('Kato', 'XFT22GJD2JH', 'dolor.elit@vehulla.com', '0500 244208', true, '2018-05-16');
INSERT INTO "user_a" (user_name, user_password, user_email, user_telephone, user_activated, user_created)
VALUES ('Dillon', 'SLI57QKC9LD', 'arcuulum@bibendum.com', '0845 46 44', true, '2019-02-13'),
  ('Elliott', 'OBH04PUQ0EZ', 'est@sedleoCras.ca', '(016977) 7585', true, '2018-04-02'),
  ('Hermione', 'TJJ11MPN2IS', 'Donec.consectetuer.mauris@lia.org', '070 2981 5150', false, '2018-08-16'),
  ('Ira', 'MLS57LKL9SP', 'vitae@velarcueu.org', '076 8614 0877', false, '2018-06-14'),
  ('Chadwick', 'PHJ54HIA5CC', 'massa@justo.org', '(011903) 97274', true, '2018-03-03'),
  ('Christopher', 'CLO51UFV5TE', 'sapien@neque.net', '0845 46 46', true, '2019-02-01'),
  ('Guy', 'LYY41VUH8LL', 'auris.quis@orinterdum.com', '070 8775 1251', false, '2018-08-27'),
  ('Rebecca', 'ZXC47ESM0CE', 'loborti@elementumsem.org', '(018178) 58287', false, '2018-09-10'),
  ('Deanna', 'JSH48SBF3SN', 'scelerisque.mollhasellus@amet.edu', '0308 347 1589', false, '2018-07-26'),
  ('Levi', 'TXW01JOE9XN', 'orci@nmfeugiat.com', '(01580) 691212', false, '2018-08-18');


insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (50, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (51, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (52, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (53, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (54, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (55, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (56, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (57, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (58, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (59, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (60, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (61, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (62, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (63, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (64, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (65, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (66, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (67, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (68, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (69, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (70, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (71, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (73, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (73, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (74, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (75, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (76, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (77, 4);
insert into ASSIGNED_ROLE (USER_ID, ROLE_ID) values (78, 4);
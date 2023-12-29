-- CS4400: Introduction to Database Systems: Monday, September 11, 2023
-- Simple Airline Management System Course Project Database TEMPLATE (v0)

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
drop database if exists flight_tracking;
create database if not exists flight_tracking;
use flight_tracking;

-- Team 22 and Brandon Manville, Anand Singh, Nyshad Williams, Luke Dean

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

--
-- Table for airline
--

DROP TABLE IF EXISTS airline;
CREATE TABLE airline (
  airlineID char(30) not null,
  revenue decimal(6, 0) not null,
  primary key (airlineID)
) ENGINE=InnoDB;

--
-- Python be cool
--
INSERT INTO airline VALUES ('Delta', 53000);
INSERT INTO airline VALUES ('United', 48000);
INSERT INTO airline VALUES ('British Airways', 24000);
INSERT INTO airline VALUES ('Lufthansa', 35000);
INSERT INTO airline VALUES ('Air_France', 29000);
INSERT INTO airline VALUES ('KLM', 29000);
INSERT INTO airline VALUES ('Ryanair', 10000);
INSERT INTO airline VALUES ('Japan Airlines', 9000);
INSERT INTO airline VALUES ('China Southern Airlines', 14000);
INSERT INTO airline VALUES ('Korean Air Lines', 10000);
INSERT INTO airline VALUES ('American', 52000);

--
-- Table for locations
--
DROP TABLE IF EXISTS location;
CREATE TABLE location (
  locID char(10) not null,
  primary key (locID)
) ENGINE=InnoDB;

INSERT INTO location VALUES ('port_1');
INSERT INTO location VALUES ('port_2');
INSERT INTO location VALUES ('port_3');
INSERT INTO location VALUES ('port_10');
INSERT INTO location VALUES ('port_17');
INSERT INTO location VALUES ('plane_1');
INSERT INTO location VALUES ('plane_5');
INSERT INTO location VALUES ('plane_8');
INSERT INTO location VALUES ('plane_13');
INSERT INTO location VALUES ('plane_20');
INSERT INTO location VALUES ('port_12');
INSERT INTO location VALUES ('port_14');
INSERT INTO location VALUES ('port_15');
INSERT INTO location VALUES ('port_20');
INSERT INTO location VALUES ('port_4');
INSERT INTO location VALUES ('port_16');
INSERT INTO location VALUES ('port_11');
INSERT INTO location VALUES ('port_23');
INSERT INTO location VALUES ('port_7');
INSERT INTO location VALUES ('port_6');
INSERT INTO location VALUES ('port_13');
INSERT INTO location VALUES ('port_21');
INSERT INTO location VALUES ('port_18');
INSERT INTO location VALUES ('port_22');
INSERT INTO location VALUES ('plane_6');
INSERT INTO location VALUES ('plane_18');
INSERT INTO location VALUES ('plane_7');

--
-- Table for the flight routes
--

DROP TABLE IF EXISTS route;
CREATE TABLE route (
  routeID char(40) not null,
  primary key (routeID)
) ENGINE=InnoDB;

INSERT INTO route VALUES ('americas_hub_exchange');
INSERT INTO route VALUES ('americas_one');
INSERT INTO route VALUES ('americas_three');
INSERT INTO route VALUES ('americas_two');
INSERT INTO route VALUES ('big_europe_loop');
INSERT INTO route VALUES ('euro_north');
INSERT INTO route VALUES ('euro_south');
INSERT INTO route VALUES ('germany_local');
INSERT INTO route VALUES ('pacific_rim_tour');
INSERT INTO route VALUES ('south_euro_loop');
INSERT INTO route VALUES ('texas_local');

--
-- Table for airport
--

DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
  airportID char(3) not null,
  port_name char(50) not null,
  city char(30) not null,
  state char(30) not null,
  country char(3) not null,
  location char(10) default null,
  primary key (airportID),
  constraint fk1 foreign key (location) references location (locID)
) ENGINE=InnoDB;

INSERT INTO airport VALUES ('ATL', 'Atlanta Hartsfield_Jackson International', 'Atlanta', 'Georgia', 'USA', 'port_1');
INSERT INTO airport VALUES ('DXB', 'Dubai International', 'Dubai', 'Al Garhoud', 'UAE', 'port_2');
INSERT INTO airport VALUES ('HND', 'Tokyo International Haneda', 'Ota City', 'Tokyo', 'JPN', 'port_3');
INSERT INTO airport VALUES ('LHR', 'London Heathrow', 'London', 'England', 'GBR', 'port_4');
INSERT INTO airport VALUES ('IST', 'Istanbul International', 'Arnavutkoy', 'Istanbul ', 'TUR', NULL);
INSERT INTO airport VALUES ('DFW', 'Dallas_Fort Worth International', 'Dallas', 'Texas', 'USA', 'port_6');
INSERT INTO airport VALUES ('CAN', 'Guangzhou International', 'Guangzhou', 'Guangdong', 'CHN', 'port_7');
INSERT INTO airport VALUES ('DEN', 'Denver International', 'Denver', 'Colorado', 'USA', NULL);
INSERT INTO airport VALUES ('LAX', 'Los Angeles International', 'Los Angeles', 'California', 'USA', NULL);
INSERT INTO airport VALUES ('ORD', 'O_Hare International', 'Chicago', 'Illinois', 'USA', 'port_10');
INSERT INTO airport VALUES ('AMS', 'Amsterdam Schipol International', 'Amsterdam', 'Haarlemmermeer', 'NLD', 'port_11');
INSERT INTO airport VALUES ('CDG', 'Paris Charles de Gaulle', 'Roissy_en_France', 'Paris', 'FRA', 'port_12');
INSERT INTO airport VALUES ('FRA', 'Frankfurt International', 'Frankfurt', 'Frankfurt_Rhine_Main', 'DEU', 'port_13');
INSERT INTO airport VALUES ('MAD', 'Madrid Adolfo Suarez_Barajas', 'Madrid', 'Barajas', 'ESP', 'port_14');
INSERT INTO airport VALUES ('BCN', 'Barcelona International', 'Barcelona', 'Catalonia', 'ESP', 'port_15');
INSERT INTO airport VALUES ('FCO', 'Rome Fiumicino', 'Fiumicino', 'Lazio', 'ITA', 'port_16');
INSERT INTO airport VALUES ('LGW', 'London Gatwick', 'London', 'England', 'GBR', 'port_17');
INSERT INTO airport VALUES ('MUC', 'Munich International', 'Munich', 'Bavaria', 'DEU', 'port_18');
INSERT INTO airport VALUES ('MDW', 'Chicago Midway International', 'Chicago', 'Illinois', 'USA', NULL);
INSERT INTO airport VALUES ('IAH', 'George Bush Intercontinental', 'Houston', 'Texas', 'USA', 'port_20');
INSERT INTO airport VALUES ('HOU', 'William P_Hobby International', 'Houston', 'Texas', 'USA', 'port_21');
INSERT INTO airport VALUES ('NRT', 'Narita International', 'Narita', 'Chiba', 'JPN', 'port_22');
INSERT INTO airport VALUES ('BER', 'Berlin Brandenburg Willy Brandt International', 'Berlin', 'Schonefeld', 'DEU', 'port_23');

--
-- Table for airplane
--

DROP TABLE IF EXISTS airplane;
CREATE TABLE airplane (
  airlineID char(30) not null,
  tail_num char(7) not null,
  location char(10) default null,
  plane_type char(4) default null,
  props decimal(2,0) default null,
  skids boolean default null,
  jets decimal(2,0) default null,
  seat_cap decimal(2,0) not null,
  speed decimal (3,0) not null,
  primary key (airlineID, tail_num),
  constraint fk2 foreign key (airlineID) references airline (airlineID),
  constraint fk3 foreign key (location) references location (locID)
) ENGINE=InnoDB;

INSERT INTO airplane VALUES ('Delta', 'n106js', 'plane_1', 'jet', NULL, NULL, 2.0, 4, 800);
INSERT INTO airplane VALUES ('Delta', 'n110jn', NULL, 'jet', NULL, NULL, 2.0, 5, 800);
INSERT INTO airplane VALUES ('Delta', 'n127js', NULL, 'jet', NULL, NULL, 4.0, 4, 600);
INSERT INTO airplane VALUES ('United', 'n330ss', NULL, 'jet', NULL, NULL, 2.0, 4, 800);
INSERT INTO airplane VALUES ('United', 'n380sd', 'plane_5', 'jet', NULL, NULL, 2.0, 5, 400);
INSERT INTO airplane VALUES ('British Airways', 'n616lt', 'plane_6', 'jet', NULL, NULL, 2.0, 7, 600);
INSERT INTO airplane VALUES ('British Airways', 'n517ly', 'plane_7', 'jet', NULL, NULL, 2.0, 4, 600);
INSERT INTO airplane VALUES ('Lufthansa', 'n620la', 'plane_8', 'jet', NULL, NULL, 4.0, 4, 800);
INSERT INTO airplane VALUES ('Lufthansa', 'n401fj', NULL, NULL, NULL, NULL, NULL, 4, 300);
INSERT INTO airplane VALUES ('Lufthansa', 'n653fk', NULL, 'jet', NULL, NULL, 2.0, 6, 600);
INSERT INTO airplane VALUES ('Air_France', 'n118fm', NULL, 'prop', 2.0, False, NULL, 4, 400);
INSERT INTO airplane VALUES ('Air_France', 'n815pw', NULL, 'jet', NULL, NULL, 2.0, 3, 400);
INSERT INTO airplane VALUES ('KLM', 'n161fk', 'plane_13', 'jet', NULL, NULL, 4.0, 4, 600);
INSERT INTO airplane VALUES ('KLM', 'n337as', NULL, 'jet', NULL, NULL, 2.0, 5, 400);
INSERT INTO airplane VALUES ('KLM', 'n256ap', NULL, 'prop', 2.0, False, NULL, 4, 300);
INSERT INTO airplane VALUES ('Ryanair', 'n156sq', NULL, 'jet', NULL, NULL, 2.0, 8, 600);
INSERT INTO airplane VALUES ('Ryanair', 'n451fi', NULL, 'jet', NULL, NULL, 4.0, 5, 600);
INSERT INTO airplane VALUES ('Ryanair', 'n341eb', 'plane_18', 'prop', 2.0, True, NULL, 4, 400);
INSERT INTO airplane VALUES ('Ryanair', 'n353kz', NULL, 'prop', 2.0, True, NULL, 4, 400);
INSERT INTO airplane VALUES ('Japan Airlines', 'n305fv', 'plane_20', 'jet', NULL, NULL, 2.0, 6, 400);
INSERT INTO airplane VALUES ('Japan Airlines', 'n443wu', NULL, 'jet', NULL, NULL, 4.0, 4, 800);
INSERT INTO airplane VALUES ('China Southern Airlines', 'n454gq', NULL, NULL, NULL, NULL, NULL, 3, 400);
INSERT INTO airplane VALUES ('China Southern Airlines', 'n249yk', NULL, 'prop', 2.0, False, NULL, 4, 400);
INSERT INTO airplane VALUES ('Korean Air Lines', 'n180co', NULL, 'jet', NULL, NULL, 2.0, 5, 600);
INSERT INTO airplane VALUES ('American', 'n448cs', NULL, 'prop', 2.0, True, NULL, 4, 400);
INSERT INTO airplane VALUES ('American', 'n225sb', NULL, 'jet', NULL, NULL, 2.0, 8, 800);
INSERT INTO airplane VALUES ('American', 'n553qn', NULL, 'jet', NULL, NULL, 2.0, 5, 800);

--
-- Table for flight
--

DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
  flightID char(5) not null,
  route_follow char(20) not null,
  cost decimal(6,0) not null,
  supportedID  char(30) not null,
  support_num char(7) not null,
  progress decimal (2,0) not null,
  plane_status char(9) not null,
  next_time time not null,
  primary key (flightID),
  constraint fk4 foreign key (route_follow) references route (routeID),
  constraint fk5 foreign key (supportedID, support_num) references airplane (airlineID, tail_num)
) ENGINE=InnoDB;

INSERT INTO flight VALUES ('dl_10', 'americas_one', 200, 'Delta', 'n106js', 1, 'in_flight', 080000);
INSERT INTO flight VALUES ('un_38', 'americas_three', 200, 'United', 'n380sd', 2, 'in_flight', 143000);
INSERT INTO flight VALUES ('ba_61', 'americas_two', 200, 'British Airways', 'n616lt', 0, 'on_ground', 093000);
INSERT INTO flight VALUES ('lf_20', 'euro_north', 300, 'Lufthansa', 'n620la', 3, 'in_flight', 110000);
INSERT INTO flight VALUES ('km_16', 'euro_south', 400, 'KLM', 'n161fk', 6, 'in_flight', 140000);
INSERT INTO flight VALUES ('ba_51', 'big_europe_loop', 100, 'British Airways', 'n517ly', 0, 'on_ground', 113000);
INSERT INTO flight VALUES ('ja_35', 'pacific_rim_tour', 300, 'Japan Airlines', 'n305fv', 1, 'in_flight', 093000);
INSERT INTO flight VALUES ('ry_34', 'germany_local', 100, 'Ryanair', 'n341eb', 0, 'on_ground', 150000);

--
-- Table for the legs
--
DROP TABLE IF EXISTS leg;
CREATE TABLE leg (
  legID char(10) not null,
  distance decimal(5,0) not null,
  departs char(3) not null,
  arrives char(3) not null,
  primary key (legID),
  constraint fk6 foreign key (departs) references airport (airportID),
  constraint fk7 foreign key (arrives) references airport (airportID)
) ENGINE=InnoDB;

INSERT INTO leg VALUES ('leg_4', 600, 'ATL', 'ORD');
INSERT INTO leg VALUES ('leg_2', 3900, 'ATL', 'AMS');
INSERT INTO leg VALUES ('leg_1', 400, 'AMS', 'BER');
INSERT INTO leg VALUES ('leg_31', 3700, 'ORD', 'CDG');
INSERT INTO leg VALUES ('leg_14', 400, 'CDG', 'MUC');
INSERT INTO leg VALUES ('leg_3', 3700, 'ATL', 'LHR');
INSERT INTO leg VALUES ('leg_22', 600, 'LHR', 'BER');
INSERT INTO leg VALUES ('leg_23', 500, 'LHR', 'MUC');
INSERT INTO leg VALUES ('leg_29', 400, 'MUC', 'FCO');
INSERT INTO leg VALUES ('leg_16', 800, 'FCO', 'MAD');
INSERT INTO leg VALUES ('leg_25', 600, 'MAD', 'CDG');
INSERT INTO leg VALUES ('leg_13', 200, 'CDG', 'LHR');
INSERT INTO leg VALUES ('leg_24', 300, 'MAD', 'BCN');
INSERT INTO leg VALUES ('leg_5', 500, 'BCN', 'CDG');
INSERT INTO leg VALUES ('leg_27', 300, 'MUC', 'BER');
INSERT INTO leg VALUES ('leg_8', 600, 'BER', 'LGW');
INSERT INTO leg VALUES ('leg_21', 600, 'LGW', 'BER');
INSERT INTO leg VALUES ('leg_9', 300, 'BER', 'MUC');
INSERT INTO leg VALUES ('leg_28', 400, 'MUC', 'CDG');
INSERT INTO leg VALUES ('leg_11', 500, 'CDG', 'BCN');
INSERT INTO leg VALUES ('leg_6', 300, 'BCN', 'MAD');
INSERT INTO leg VALUES ('leg_26', 800, 'MAD', 'FCO');
INSERT INTO leg VALUES ('leg_30', 200, 'MUC', 'FRA');
INSERT INTO leg VALUES ('leg_17', 300, 'FRA', 'BER');
INSERT INTO leg VALUES ('leg_7', 4700, 'BER', 'CAN');
INSERT INTO leg VALUES ('leg_10', 1600, 'CAN', 'HND');
INSERT INTO leg VALUES ('leg_18', 100, 'HND', 'NRT');
INSERT INTO leg VALUES ('leg_12', 600, 'CDG', 'FCO');
INSERT INTO leg VALUES ('leg_15', 200, 'DFW', 'IAH');
INSERT INTO leg VALUES ('leg_20', 100, 'IAH', 'HOU');
INSERT INTO leg VALUES ('leg_19', 300, 'HOU', 'DFW');

--
-- Table for the contains relationship
-- A route contains legs
--

DROP TABLE IF EXISTS route_contains;
CREATE TABLE route_contains (
  routeID char(40) not null,
  legID char(10) not null,
  sequence decimal(2,0) not null,
  primary key (routeID, legID, sequence),
  constraint fk8 foreign key (routeID) references route (routeID),
  constraint fk9 foreign key (legID) references leg (legID)
) ENGINE=InnoDB;

INSERT INTO route_contains VALUES ('americas_hub_exchange', 'leg_4', 1);
INSERT INTO route_contains VALUES ('americas_one', 'leg_2', 1);
INSERT INTO route_contains VALUES ('americas_one', 'leg_1', 2);
INSERT INTO route_contains VALUES ('americas_three', 'leg_31', 1);
INSERT INTO route_contains VALUES ('americas_three', 'leg_14', 2);
INSERT INTO route_contains VALUES ('americas_two', 'leg_3', 1);
INSERT INTO route_contains VALUES ('americas_two', 'leg_22', 2);
INSERT INTO route_contains VALUES ('big_europe_loop', 'leg_23', 1);
INSERT INTO route_contains VALUES ('big_europe_loop', 'leg_29', 2);
INSERT INTO route_contains VALUES ('big_europe_loop', 'leg_16', 3);
INSERT INTO route_contains VALUES ('big_europe_loop', 'leg_25', 4);
INSERT INTO route_contains VALUES ('big_europe_loop', 'leg_13', 5);
INSERT INTO route_contains VALUES ('euro_north', 'leg_16', 1);
INSERT INTO route_contains VALUES ('euro_north', 'leg_24', 2);
INSERT INTO route_contains VALUES ('euro_north', 'leg_5', 3);
INSERT INTO route_contains VALUES ('euro_north', 'leg_14', 4);
INSERT INTO route_contains VALUES ('euro_north', 'leg_27', 5);
INSERT INTO route_contains VALUES ('euro_north', 'leg_8', 6);
INSERT INTO route_contains VALUES ('euro_south', 'leg_21', 1);
INSERT INTO route_contains VALUES ('euro_south', 'leg_9', 2);
INSERT INTO route_contains VALUES ('euro_south', 'leg_28', 3);
INSERT INTO route_contains VALUES ('euro_south', 'leg_11', 4);
INSERT INTO route_contains VALUES ('euro_south', 'leg_6', 5);
INSERT INTO route_contains VALUES ('euro_south', 'leg_26', 6);
INSERT INTO route_contains VALUES ('germany_local', 'leg_9', 1);
INSERT INTO route_contains VALUES ('germany_local', 'leg_30', 2);
INSERT INTO route_contains VALUES ('germany_local', 'leg_17', 3);
INSERT INTO route_contains VALUES ('pacific_rim_tour', 'leg_7', 1);
INSERT INTO route_contains VALUES ('pacific_rim_tour', 'leg_10', 2);
INSERT INTO route_contains VALUES ('pacific_rim_tour', 'leg_18', 3);
INSERT INTO route_contains VALUES ('south_euro_loop', 'leg_16', 1);
INSERT INTO route_contains VALUES ('south_euro_loop', 'leg_24', 2);
INSERT INTO route_contains VALUES ('south_euro_loop', 'leg_5', 3);
INSERT INTO route_contains VALUES ('south_euro_loop', 'leg_12', 4);
INSERT INTO route_contains VALUES ('texas_local', 'leg_15', 1);
INSERT INTO route_contains VALUES ('texas_local', 'leg_20', 2);
INSERT INTO route_contains VALUES ('texas_local', 'leg_19', 3);

--
-- Table of all passengers
--

DROP TABLE IF EXISTS passenger;
CREATE TABLE passenger (
	personID char(5) NOT NULL,
    fname char(10) NOT NULL,
    lname char(10) DEFAULT NULL,
    funds decimal(4, 0) not NULL,
    miles decimal (4, 0) not NULL,
    occupies char(9) NOT NULL,
    PRIMARY KEY (personID),
    CONSTRAINT fk10 FOREIGN KEY (occupies) REFERENCES location (locID)
) ENGINE=InnoDB;

INSERT INTO passenger VALUES ('p21', 'Mona', 'Harrison', 700.0, 771.0, 'plane_1');
INSERT INTO passenger VALUES ('p22', 'Arlene', 'Massey', 200.0, 374.0, 'plane_1');
INSERT INTO passenger VALUES ('p23', 'Judith', 'Patrick', 400.0, 414.0, 'plane_1');
INSERT INTO passenger VALUES ('p24', 'Reginald', 'Rhodes', 500.0, 292.0, 'plane_5');
INSERT INTO passenger VALUES ('p25', 'Vincent', 'Garcia', 300.0, 390.0, 'plane_5');
INSERT INTO passenger VALUES ('p26', 'Cheryl', 'Moore', 600.0, 302.0, 'plane_5');
INSERT INTO passenger VALUES ('p27', 'Michael', 'Rivera', 400.0, 470.0, 'plane_8');
INSERT INTO passenger VALUES ('p28', 'Luther', 'Matthews', 400.0, 208.0, 'plane_8');
INSERT INTO passenger VALUES ('p29', 'Moses', 'Parks', 700.0, 292.0, 'plane_13');
INSERT INTO passenger VALUES ('p30', 'Ora', 'Steele', 500.0, 686.0, 'plane_13');
INSERT INTO passenger VALUES ('p31', 'Antonio', 'Flores', 400.0, 547.0, 'plane_13');
INSERT INTO passenger VALUES ('p32', 'Glenn', 'Ross', 500.0, 257.0, 'plane_13');
INSERT INTO passenger VALUES ('p33', 'Irma', 'Thomas', 600.0, 564.0, 'plane_20');
INSERT INTO passenger VALUES ('p34', 'Ann', 'Maldonado', 200.0, 211.0, 'plane_20');
INSERT INTO passenger VALUES ('p35', 'Jeffrey', 'Cruz', 500.0, 233.0, 'port_12');
INSERT INTO passenger VALUES ('p36', 'Sonya', 'Price', 400.0, 293.0, 'port_12');
INSERT INTO passenger VALUES ('p37', 'Tracy', 'Hale', 700.0, 552.0, 'port_12');
INSERT INTO passenger VALUES ('p38', 'Albert', 'Simmons', 700.0, 812.0, 'port_14');
INSERT INTO passenger VALUES ('p39', 'Karen', 'Terry', 400.0, 541.0, 'port_15');
INSERT INTO passenger VALUES ('p40', 'Glen', 'Kelley', 700.0, 441.0, 'port_20');
INSERT INTO passenger VALUES ('p41', 'Brooke', 'Little', 300.0, 875.0, 'port_3');
INSERT INTO passenger VALUES ('p42', 'Daryl', 'Nguyen', 500.0, 691.0, 'port_4');
INSERT INTO passenger VALUES ('p43', 'Judy', 'Willis', 300.0, 572.0, 'port_14');
INSERT INTO passenger VALUES ('p44', 'Marco', 'Klein', 500.0, 572.0, 'port_15');
INSERT INTO passenger VALUES ('p45', 'Angelica', 'Hampton', 500.0, 663.0, 'port_16');

--
-- Vacation destinations and sequences
--

DROP TABLE IF EXISTS vacation;
CREATE TABLE vacation (
    passengerID char(5) NOT NULL,
	destination char(4) NOT NULL,
    sequence char(20) NOT NULL,
    PRIMARY KEY (passengerID, destination, sequence),
    CONSTRAINT fk11 FOREIGN KEY (passengerID) REFERENCES passenger (personID)
) ENGINE=InnoDB;

INSERT INTO vacation VALUES ('p21', 'AMS', 1);
INSERT INTO vacation VALUES ('p22', 'AMS', 1);
INSERT INTO vacation VALUES ('p23', 'BER', 1);
INSERT INTO vacation VALUES ('p24', 'MUC', 1);
INSERT INTO vacation VALUES ('p24', 'CDG', 2);
INSERT INTO vacation VALUES ('p25', 'MUC', 1);
INSERT INTO vacation VALUES ('p26', 'MUC', 1);
INSERT INTO vacation VALUES ('p27', 'BER', 1);
INSERT INTO vacation VALUES ('p28', 'LGW', 1);
INSERT INTO vacation VALUES ('p29', 'FCO', 1);
INSERT INTO vacation VALUES ('p29', 'LHR', 2);
INSERT INTO vacation VALUES ('p30', 'FCO', 1);
INSERT INTO vacation VALUES ('p30', 'MAD', 2);
INSERT INTO vacation VALUES ('p31', 'FCO', 1);
INSERT INTO vacation VALUES ('p32', 'FCO', 1);
INSERT INTO vacation VALUES ('p33', 'CAN', 1);
INSERT INTO vacation VALUES ('p34', 'HND', 1);
INSERT INTO vacation VALUES ('p35', 'LGW', 1);
INSERT INTO vacation VALUES ('p36', 'FCO', 1);
INSERT INTO vacation VALUES ('p37', 'FCO', 1);
INSERT INTO vacation VALUES ('p37', 'LGW', 2);
INSERT INTO vacation VALUES ('p37', 'CDG', 3);
INSERT INTO vacation VALUES ('p38', 'MUC', 1);
INSERT INTO vacation VALUES ('p39', 'MUC', 1);
INSERT INTO vacation VALUES ('p40', 'HND', 1);

--
-- Table of pilots
--

DROP TABLE IF EXISTS pilot;
CREATE TABLE pilot (
	pilotID char(5) NOT NULL,
    taxID char(11) NOT NULL,
    fname char(10) NOT NULL,
    lname char(10) default NULL,
    experience decimal(2, 0) not NULL,
    commands char(5) DEFAULT NULL,
    occupies char(9) NOT NULL,
    PRIMARY KEY (pilotID),
    CONSTRAINT fk12 FOREIGN KEY (commands) REFERENCES flight (flightID),
    CONSTRAINT fk13 FOREIGN KEY (occupies) REFERENCES location (locID),
    unique (taxID)
) ENGINE=InnoDB;

INSERT INTO pilot VALUES ('p1', '330-12-6907', 'Jeanne', 'Nelson', 31.0, 'dl_10', 'port_1');
INSERT INTO pilot VALUES ('p10', '769-60-1266', 'Lawrence', 'Morgan', 15.0, 'lf_20', 'port_3');
INSERT INTO pilot VALUES ('p11', '369-22-9505', 'Sandra', 'Cruz', 22.0, 'km_16', 'port_3');
INSERT INTO pilot VALUES ('p12', '680-92-5329', 'Dan', 'Ball', 24.0, 'ry_34', 'port_3');
INSERT INTO pilot VALUES ('p13', '513-40-4168', 'Bryant', 'Figueroa', 24.0, 'km_16', 'port_3');
INSERT INTO pilot VALUES ('p14', '454-71-7847', 'Dana', 'Perry', 13.0, 'km_16', 'port_3');
INSERT INTO pilot VALUES ('p15', '153-47-8101', 'Matt', 'Hunt', 30.0, 'ja_35', 'port_10');
INSERT INTO pilot VALUES ('p16', '598-47-5172', 'Edna', 'Brown', 28.0, 'ja_35', 'port_10');
INSERT INTO pilot VALUES ('p17', '865-71-6800', 'Ruby', 'Burgess', 36.0, NULL, 'port_10');
INSERT INTO pilot VALUES ('p18', '250-86-2784', 'Esther', 'Pittman', 23.0, NULL, 'port_10');
INSERT INTO pilot VALUES ('p19', '386-39-7881', 'Doug', 'Fowler', 2.0, NULL, 'port_17');
INSERT INTO pilot VALUES ('p2', '842-88-1257', 'Roxanne', 'Byrd', 9.0, 'dl_10', 'port_1');
INSERT INTO pilot VALUES ('p20', '522-44-3098', 'Thomas', 'Olson', 28.0, NULL, 'port_17');
INSERT INTO pilot VALUES ('p3', '750-24-7616', 'Tanya', 'Nguyen', 11.0, 'un_38', 'port_1');
INSERT INTO pilot VALUES ('p4', '776-21-8098', 'Kendra', 'Jacobs', 24.0, 'un_38', 'port_1');
INSERT INTO pilot VALUES ('p5', '933-93-2165', 'Jeff', 'Burton', 27.0, 'ba_61', 'port_1');
INSERT INTO pilot VALUES ('p6', '707-84-4555', 'Randal', 'Parks', 38.0, 'ba_61', 'port_1');
INSERT INTO pilot VALUES ('p7', '450-25-5617', 'Sonya', 'Owens', 13.0, 'lf_20', 'port_2');
INSERT INTO pilot VALUES ('p8', '701-38-2179', 'Bennie', 'Palmer', 12.0, 'ry_34', 'port_2');
INSERT INTO pilot VALUES ('p9', '936-44-6941', 'Marlene', 'Warner', 13.0, 'lf_20', 'port_3');

--
-- Table for licenses the pilots have
--

DROP TABLE IF EXISTS license;
CREATE TABLE license (
    pID char(5) NOT NULL,
	license_type char(7) NOT NULL,
    PRIMARY KEY (pID, license_type),
    CONSTRAINT fk14 FOREIGN KEY (pID) REFERENCES pilot (pilotID)
) ENGINE=InnoDB;

INSERT INTO license VALUES ('p1', 'jets');
INSERT INTO license VALUES ('p10', 'jets');
INSERT INTO license VALUES ('p11', 'jets');
INSERT INTO license VALUES ('p11', 'props');
INSERT INTO license VALUES ('p12', 'props');
INSERT INTO license VALUES ('p13', 'jets');
INSERT INTO license VALUES ('p14', 'jets');
INSERT INTO license VALUES ('p15', 'jets');
INSERT INTO license VALUES ('p15', 'props');
INSERT INTO license VALUES ('p15', 'testing');
INSERT INTO license VALUES ('p16', 'jets');
INSERT INTO license VALUES ('p17', 'jets');
INSERT INTO license VALUES ('p17', 'props');
INSERT INTO license VALUES ('p18', 'jets');
INSERT INTO license VALUES ('p19', 'jets');
INSERT INTO license VALUES ('p2', 'jets');
INSERT INTO license VALUES ('p2', 'props');
INSERT INTO license VALUES ('p20', 'jets');
INSERT INTO license VALUES ('p3', 'jets');
INSERT INTO license VALUES ('p4', 'jets');
INSERT INTO license VALUES ('p4', 'props');
INSERT INTO license VALUES ('p5', 'jets');
INSERT INTO license VALUES ('p6', 'jets');
INSERT INTO license VALUES ('p6', 'props');
INSERT INTO license VALUES ('p7', 'jets');
INSERT INTO license VALUES ('p8', 'props');
INSERT INTO license VALUES ('p9', 'jets');
INSERT INTO license VALUES ('p9', 'props');
INSERT INTO license VALUES ('p9', 'testing');
  
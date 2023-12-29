-- CS4400: Introduction to Database Systems: Tuesday, September 12, 2023
-- Simple Airline Management System Course Project Database (v0)

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

-- Define the database structures
create table airline (
	airlineID varchar(50),
    revenue integer default null,
    primary key (airlineID)
) engine = innodb;

INSERT INTO airline VALUES ('Delta', 53000);
INSERT INTO airline VALUES ('United', 48000);
INSERT INTO airline VALUES ('British Airways', 24000);
INSERT INTO airline VALUES ('Lufthansa', 35000);
INSERT INTO airline VALUES ('Air France', 29000);
INSERT INTO airline VALUES ('Ryanair', 10000);
INSERT INTO airline VALUES ('Japan Airlines', 9000);
INSERT INTO airline VALUES ('China Southern Airlines', 14000);
INSERT INTO airline VALUES ('KLM', 29000);
INSERT INTO airline VALUES ('Korean Air Lines', 10000);
INSERT INTO airline VALUES ('American', 52000);

create table location (
	locationID varchar(50),
    primary key (locationID)
) engine = innodb;

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
INSERT INTO location VALUES ('plane_4');
INSERT INTO location VALUES ('plane_11');
INSERT INTO location VALUES ('plane_26');
INSERT INTO location VALUES ('plane_27');
INSERT INTO location VALUES ('plane_16');
INSERT INTO location VALUES ('plane_9');

create table airplane (
	airlineID varchar(50),
    tail_num varchar(50),
    seat_capacity integer not null check (seat_capacity > 0),
    speed integer not null check (speed > 0),
    locationID varchar(50) default null,
    plane_type varchar(100) default null,
    skids boolean default null,
    propellers integer default null,
    jet_engines integer default null,
    primary key (airlineID, tail_num),
    constraint fk1 foreign key (airlineID) references airline (airlineID),
    constraint fk3 foreign key (locationID) references location (locationID)
) engine = innodb;

INSERT INTO airplane VALUES ('Delta', 'n106js', 4, 800, 'plane_1', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Delta', 'n110jn', 5, 800, null, 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Delta', 'n127js', 4, 600, null, 'jet', null, null, 4);
INSERT INTO airplane VALUES ('United', 'n330ss', 4, 800, 'plane_4', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('United', 'n380sd', 5, 400, 'plane_5', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('British Airways', 'n616lt', 7, 600, 'plane_6', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('British Airways', 'n517ly', 4, 600, 'plane_7', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Lufthansa', 'n620la', 4, 800, 'plane_8', 'jet', null, null, 4);
INSERT INTO airplane VALUES ('Lufthansa', 'n401fj', 4, 300, 'plane_9', null, null, null, null);
INSERT INTO airplane VALUES ('Lufthansa', 'n653fk', 6, 600, null, 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Air France', 'n118fm', 4, 400, 'plane_11', 'prop', FALSE, 2, null);
INSERT INTO airplane VALUES ('Air France', 'n815pw', 3, 400, null, 'jet', null, null, 2);
INSERT INTO airplane VALUES ('KLM', 'n161fk', 4, 600, 'plane_13', 'jet', null, null, 4);
INSERT INTO airplane VALUES ('KLM', 'n337as', 5, 400, null, 'jet', null, null, 2);
INSERT INTO airplane VALUES ('KLM', 'n256ap', 4, 300, null, 'prop', FALSE, 2, null);
INSERT INTO airplane VALUES ('Ryanair', 'n156sq', 8, 600, 'plane_16', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Ryanair', 'n451fi', 5, 600, null, 'jet', null, null, 4);
INSERT INTO airplane VALUES ('Ryanair', 'n341eb', 4, 400, 'plane_18', 'prop', TRUE, 2, null);
INSERT INTO airplane VALUES ('Ryanair', 'n353kz', 4, 400, null, 'prop', TRUE, 2, null);
INSERT INTO airplane VALUES ('Japan Airlines', 'n305fv', 6, 400, 'plane_20', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('Japan Airlines', 'n443wu', 4, 800, null, 'jet', null, null, 4);
INSERT INTO airplane VALUES ('China Southern Airlines', 'n454gq', 3, 400, null, null, null, null, null);
INSERT INTO airplane VALUES ('China Southern Airlines', 'n249yk', 4, 400, null, 'prop', FALSE, 2, null);
INSERT INTO airplane VALUES ('Korean Air Lines', 'n180co', 5, 600, null, 'jet', null, null, 2);
INSERT INTO airplane VALUES ('American', 'n448cs', 4, 400, null, 'prop', TRUE, 2, null);
INSERT INTO airplane VALUES ('American', 'n225sb', 8, 800, 'plane_26', 'jet', null, null, 2);
INSERT INTO airplane VALUES ('American', 'n553qn', 5, 800, 'plane_27', 'jet', null, null, 2);

create table airport (
	airportID char(3),
    airport_name varchar(200),
    city varchar(100) not null,
    state varchar(100) not null,
    country char(3) not null,
    locationID varchar(50) default null,
    primary key (airportID),
    constraint fk2 foreign key (locationID) references location (locationID)
) engine = innodb;

INSERT INTO airport VALUES ('ATL', 'Atlanta Hartsfield_Jackson International', 'Atlanta', 'Georgia', 'USA', 'port_1');
INSERT INTO airport VALUES ('DXB', 'Dubai International', 'Dubai', 'Al Garhoud', 'UAE', 'port_2');
INSERT INTO airport VALUES ('HND', 'Tokyo International Haneda', 'Ota City', 'Tokyo', 'JPN', 'port_3');
INSERT INTO airport VALUES ('LHR', 'London Heathrow', 'London', 'England', 'GBR', 'port_4');
INSERT INTO airport VALUES ('IST', 'Istanbul International', 'Arnavutkoy', 'Istanbul ', 'TUR', null);
INSERT INTO airport VALUES ('DFW', 'Dallas_Fort Worth International', 'Dallas', 'Texas', 'USA', 'port_6');
INSERT INTO airport VALUES ('CAN', 'Guangzhou International', 'Guangzhou', 'Guangdong', 'CHN', 'port_7');
INSERT INTO airport VALUES ('DEN', 'Denver International', 'Denver', 'Colorado', 'USA', null);
INSERT INTO airport VALUES ('LAX', 'Los Angeles International', 'Los Angeles', 'California', 'USA', null);
INSERT INTO airport VALUES ('ORD', 'O_Hare International', 'Chicago', 'Illinois', 'USA', 'port_10');
INSERT INTO airport VALUES ('AMS', 'Amsterdam Schipol International', 'Amsterdam', 'Haarlemmermeer', 'NLD', 'port_11');
INSERT INTO airport VALUES ('CDG', 'Paris Charles de Gaulle', 'Roissy_en_France', 'Paris', 'FRA', 'port_12');
INSERT INTO airport VALUES ('FRA', 'Frankfurt International', 'Frankfurt', 'Frankfurt_Rhine_Main', 'DEU', 'port_13');
INSERT INTO airport VALUES ('MAD', 'Madrid Adolfo Suarez_Barajas', 'Madrid', 'Barajas', 'ESP', 'port_14');
INSERT INTO airport VALUES ('BCN', 'Barcelona International', 'Barcelona', 'Catalonia', 'ESP', 'port_15');
INSERT INTO airport VALUES ('FCO', 'Rome Fiumicino', 'Fiumicino', 'Lazio', 'ITA', 'port_16');
INSERT INTO airport VALUES ('LGW', 'London Gatwick', 'London', 'England', 'GBR', 'port_17');
INSERT INTO airport VALUES ('MUC', 'Munich International', 'Munich', 'Bavaria', 'DEU', 'port_18');
INSERT INTO airport VALUES ('MDW', 'Chicago Midway International', 'Chicago', 'Illinois', 'USA', null);
INSERT INTO airport VALUES ('IAH', 'George Bush Intercontinental', 'Houston', 'Texas', 'USA', 'port_20');
INSERT INTO airport VALUES ('HOU', 'William P_Hobby International', 'Houston', 'Texas', 'USA', 'port_21');
INSERT INTO airport VALUES ('NRT', 'Narita International', 'Narita', 'Chiba', 'JPN', 'port_22');
INSERT INTO airport VALUES ('BER', 'Berlin Brandenburg Willy Brandt International', 'Berlin', 'Schonefeld', 'DEU', 'port_23');

create table person (
	personID varchar(50),
    first_name varchar(100) not null,
    last_name varchar(100) default null,
    locationID varchar(50) not null,
    primary key (personID),
    constraint fk8 foreign key (locationID) references location (locationID)
) engine = innodb;

INSERT INTO person VALUES ('p1', 'Jeanne', 'Nelson', 'plane_1');
INSERT INTO person VALUES ('p2', 'Roxanne', 'Byrd', 'plane_1');
INSERT INTO person VALUES ('p3', 'Tanya', 'Nguyen', 'plane_5');
INSERT INTO person VALUES ('p4', 'Kendra', 'Jacobs', 'plane_5');
INSERT INTO person VALUES ('p5', 'Jeff', 'Burton', 'plane_6');
INSERT INTO person VALUES ('p6', 'Randal', 'Parks', 'plane_6');
INSERT INTO person VALUES ('p7', 'Sonya', 'Owens', 'plane_8');
INSERT INTO person VALUES ('p8', 'Bennie', 'Palmer', 'plane_18');
INSERT INTO person VALUES ('p9', 'Marlene', 'Warner', 'plane_8');
INSERT INTO person VALUES ('p10', 'Lawrence', 'Morgan', 'plane_8');
INSERT INTO person VALUES ('p11', 'Sandra', 'Cruz', 'plane_13');
INSERT INTO person VALUES ('p12', 'Dan', 'Ball', 'plane_18');
INSERT INTO person VALUES ('p13', 'Bryant', 'Figueroa', 'plane_13');
INSERT INTO person VALUES ('p14', 'Dana', 'Perry', 'plane_13');
INSERT INTO person VALUES ('p15', 'Matt', 'Hunt', 'plane_20');
INSERT INTO person VALUES ('p16', 'Edna', 'Brown', 'plane_20');
INSERT INTO person VALUES ('p17', 'Ruby', 'Burgess', 'port_10');
INSERT INTO person VALUES ('p18', 'Esther', 'Pittman', 'port_12');
INSERT INTO person VALUES ('p19', 'Doug', 'Fowler', 'port_23');
INSERT INTO person VALUES ('p20', 'Thomas', 'Olson', 'port_4');
INSERT INTO person VALUES ('p21', 'Mona', 'Harrison', 'plane_1');
INSERT INTO person VALUES ('p22', 'Arlene', 'Massey', 'plane_1');
INSERT INTO person VALUES ('p23', 'Judith', 'Patrick', 'plane_1');
INSERT INTO person VALUES ('p24', 'Reginald', 'Rhodes', 'plane_5');
INSERT INTO person VALUES ('p25', 'Vincent', 'Garcia', 'plane_5');
INSERT INTO person VALUES ('p26', 'Cheryl', 'Moore', 'plane_5');
INSERT INTO person VALUES ('p27', 'Michael', 'Rivera', 'plane_8');
INSERT INTO person VALUES ('p28', 'Luther', 'Matthews', 'plane_8');
INSERT INTO person VALUES ('p29', 'Moses', 'Parks', 'plane_13');
INSERT INTO person VALUES ('p30', 'Ora', 'Steele', 'plane_13');
INSERT INTO person VALUES ('p31', 'Antonio', 'Flores', 'plane_13');
INSERT INTO person VALUES ('p32', 'Glenn', 'Ross', 'plane_13');
INSERT INTO person VALUES ('p33', 'Irma', 'Thomas', 'plane_20');
INSERT INTO person VALUES ('p34', 'Ann', 'Maldonado', 'plane_20');
INSERT INTO person VALUES ('p35', 'Jeffrey', 'Cruz', 'port_12');
INSERT INTO person VALUES ('p36', 'Sonya', 'Price', 'port_12');
INSERT INTO person VALUES ('p37', 'Tracy', 'Hale', 'port_12');
INSERT INTO person VALUES ('p38', 'Albert', 'Simmons', 'port_14');
INSERT INTO person VALUES ('p39', 'Karen', 'Terry', 'port_15');
INSERT INTO person VALUES ('p40', 'Glen', 'Kelley', 'port_20');
INSERT INTO person VALUES ('p41', 'Brooke', 'Little', 'port_3');
INSERT INTO person VALUES ('p42', 'Daryl', 'Nguyen', 'port_4');
INSERT INTO person VALUES ('p43', 'Judy', 'Willis', 'port_14');
INSERT INTO person VALUES ('p44', 'Marco', 'Klein', 'port_15');
INSERT INTO person VALUES ('p45', 'Angelica', 'Hampton', 'plane_26');
INSERT INTO person VALUES ('p46', 'Peppermint', 'Patty', 'plane_26');
INSERT INTO person VALUES ('p47', 'Charlie', 'Brown', 'plane_26');
INSERT INTO person VALUES ('p48', 'Lucy', 'van Pelt', 'plane_27');
INSERT INTO person VALUES ('p49', 'Linus', 'van Pelt', 'plane_27');

create table passenger (
	personID varchar(50),
    miles integer default 0,
    funds integer default 0,
    primary key (personID),
    constraint fk6 foreign key (personID) references person (personID)
) engine = innodb;

INSERT INTO passenger VALUES ('p21', 771, 700);
INSERT INTO passenger VALUES ('p22', 374, 200);
INSERT INTO passenger VALUES ('p23', 414, 400);
INSERT INTO passenger VALUES ('p24', 292, 500);
INSERT INTO passenger VALUES ('p25', 390, 300);
INSERT INTO passenger VALUES ('p26', 302, 600);
INSERT INTO passenger VALUES ('p27', 470, 400);
INSERT INTO passenger VALUES ('p28', 208, 400);
INSERT INTO passenger VALUES ('p29', 292, 700);
INSERT INTO passenger VALUES ('p30', 686, 500);
INSERT INTO passenger VALUES ('p31', 547, 400);
INSERT INTO passenger VALUES ('p32', 257, 500);
INSERT INTO passenger VALUES ('p33', 564, 600);
INSERT INTO passenger VALUES ('p34', 211, 200);
INSERT INTO passenger VALUES ('p35', 233, 500);
INSERT INTO passenger VALUES ('p36', 293, 400);
INSERT INTO passenger VALUES ('p37', 552, 700);
INSERT INTO passenger VALUES ('p38', 812, 700);
INSERT INTO passenger VALUES ('p39', 541, 400);
INSERT INTO passenger VALUES ('p40', 441, 700);
INSERT INTO passenger VALUES ('p41', 875, 300);
INSERT INTO passenger VALUES ('p42', 691, 500);
INSERT INTO passenger VALUES ('p43', 572, 300);
INSERT INTO passenger VALUES ('p44', 572, 500);
INSERT INTO passenger VALUES ('p45', 663, 500);

create table passenger_vacations (
	personID varchar(50),
    airportID char(3) not null,
    sequence integer check (sequence > 0),
    primary key (personID, sequence),
    constraint fk19 foreign key (personID) references person (personID)
		on update cascade on delete cascade,
    constraint fk20 foreign key (airportID) references airport (airportID)
) engine = innodb;

INSERT INTO passenger_vacations VALUES ('p21', 'AMS', 1);
INSERT INTO passenger_vacations VALUES ('p22', 'AMS', 1);
INSERT INTO passenger_vacations VALUES ('p23', 'BER', 1);
INSERT INTO passenger_vacations VALUES ('p24', 'MUC', 1);
INSERT INTO passenger_vacations VALUES ('p24', 'CDG', 2);
INSERT INTO passenger_vacations VALUES ('p25', 'MUC', 1);
INSERT INTO passenger_vacations VALUES ('p26', 'MUC', 1);
INSERT INTO passenger_vacations VALUES ('p27', 'BER', 1);
INSERT INTO passenger_vacations VALUES ('p28', 'LGW', 1);
INSERT INTO passenger_vacations VALUES ('p29', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p29', 'LHR', 2);
INSERT INTO passenger_vacations VALUES ('p30', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p30', 'MAD', 2);
INSERT INTO passenger_vacations VALUES ('p31', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p32', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p33', 'CAN', 1);
INSERT INTO passenger_vacations VALUES ('p34', 'HND', 1);
INSERT INTO passenger_vacations VALUES ('p35', 'LGW', 1);
INSERT INTO passenger_vacations VALUES ('p36', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p37', 'FCO', 1);
INSERT INTO passenger_vacations VALUES ('p37', 'LGW', 2);
INSERT INTO passenger_vacations VALUES ('p37', 'CDG', 3);
INSERT INTO passenger_vacations VALUES ('p38', 'MUC', 1);
INSERT INTO passenger_vacations VALUES ('p39', 'MUC', 1);
INSERT INTO passenger_vacations VALUES ('p40', 'HND', 1);
INSERT INTO passenger_vacations VALUES ('p45', 'ORD', 1);

create table leg (
	legID varchar(50),
    distance integer not null,
    departure char(3) not null,
    arrival char(3) not null,
    primary key (legID),
    constraint fk10 foreign key (departure) references airport (airportID),
    constraint fk11 foreign key (arrival) references airport (airportID)
) engine = innodb;

INSERT INTO leg VALUES ('leg_1', 400, 'AMS', 'BER');
INSERT INTO leg VALUES ('leg_2', 3900, 'ATL', 'AMS');
INSERT INTO leg VALUES ('leg_3', 3700, 'ATL', 'LHR');
INSERT INTO leg VALUES ('leg_4', 600, 'ATL', 'ORD');
INSERT INTO leg VALUES ('leg_5', 500, 'BCN', 'CDG');
INSERT INTO leg VALUES ('leg_6', 300, 'BCN', 'MAD');
INSERT INTO leg VALUES ('leg_7', 4700, 'BER', 'CAN');
INSERT INTO leg VALUES ('leg_8', 600, 'BER', 'LGW');
INSERT INTO leg VALUES ('leg_9', 300, 'BER', 'MUC');
INSERT INTO leg VALUES ('leg_10', 1600, 'CAN', 'HND');
INSERT INTO leg VALUES ('leg_11', 500, 'CDG', 'BCN');
INSERT INTO leg VALUES ('leg_12', 600, 'CDG', 'FCO');
INSERT INTO leg VALUES ('leg_13', 200, 'CDG', 'LHR');
INSERT INTO leg VALUES ('leg_14', 400, 'CDG', 'MUC');
INSERT INTO leg VALUES ('leg_15', 200, 'DFW', 'IAH');
INSERT INTO leg VALUES ('leg_16', 800, 'FCO', 'MAD');
INSERT INTO leg VALUES ('leg_17', 300, 'FRA', 'BER');
INSERT INTO leg VALUES ('leg_18', 100, 'HND', 'NRT');
INSERT INTO leg VALUES ('leg_19', 300, 'HOU', 'DFW');
INSERT INTO leg VALUES ('leg_20', 100, 'IAH', 'HOU');
INSERT INTO leg VALUES ('leg_21', 600, 'LGW', 'BER');
INSERT INTO leg VALUES ('leg_22', 600, 'LHR', 'BER');
INSERT INTO leg VALUES ('leg_23', 500, 'LHR', 'MUC');
INSERT INTO leg VALUES ('leg_24', 300, 'MAD', 'BCN');
INSERT INTO leg VALUES ('leg_25', 600, 'MAD', 'CDG');
INSERT INTO leg VALUES ('leg_26', 800, 'MAD', 'FCO');
INSERT INTO leg VALUES ('leg_27', 300, 'MUC', 'BER');
INSERT INTO leg VALUES ('leg_28', 400, 'MUC', 'CDG');
INSERT INTO leg VALUES ('leg_29', 400, 'MUC', 'FCO');
INSERT INTO leg VALUES ('leg_30', 200, 'MUC', 'FRA');
INSERT INTO leg VALUES ('leg_31', 3700, 'ORD', 'CDG');

create table route (
	routeID varchar(50),
    primary key (routeID)
) engine = innodb;

INSERT INTO route VALUES ('euro_north');
INSERT INTO route VALUES ('euro_south');
INSERT INTO route VALUES ('south_euro_loop');
INSERT INTO route VALUES ('big_europe_loop');
INSERT INTO route VALUES ('americas_one');
INSERT INTO route VALUES ('americas_two');
INSERT INTO route VALUES ('americas_three');
INSERT INTO route VALUES ('pacific_rim_tour');
INSERT INTO route VALUES ('germany_local');
INSERT INTO route VALUES ('texas_local');
INSERT INTO route VALUES ('americas_hub_exchange');

create table route_path (
	routeID varchar(50),
    legID varchar(50) not null,
    sequence integer check (sequence > 0),
    primary key (routeID, sequence),
    constraint fk12 foreign key (routeID) references route (routeID),
    constraint fk13 foreign key (legID) references leg (legID)
) engine = innodb;

INSERT INTO route_path VALUES ('euro_north', 'leg_16', 1);
INSERT INTO route_path VALUES ('euro_north', 'leg_24', 2);
INSERT INTO route_path VALUES ('euro_north', 'leg_5', 3);
INSERT INTO route_path VALUES ('euro_north', 'leg_14', 4);
INSERT INTO route_path VALUES ('euro_north', 'leg_27', 5);
INSERT INTO route_path VALUES ('euro_north', 'leg_8', 6);
INSERT INTO route_path VALUES ('euro_south', 'leg_21', 1);
INSERT INTO route_path VALUES ('euro_south', 'leg_9', 2);
INSERT INTO route_path VALUES ('euro_south', 'leg_28', 3);
INSERT INTO route_path VALUES ('euro_south', 'leg_11', 4);
INSERT INTO route_path VALUES ('euro_south', 'leg_6', 5);
INSERT INTO route_path VALUES ('euro_south', 'leg_26', 6);
INSERT INTO route_path VALUES ('south_euro_loop', 'leg_16', 1);
INSERT INTO route_path VALUES ('south_euro_loop', 'leg_24', 2);
INSERT INTO route_path VALUES ('south_euro_loop', 'leg_5', 3);
INSERT INTO route_path VALUES ('south_euro_loop', 'leg_12', 4);
INSERT INTO route_path VALUES ('big_europe_loop', 'leg_23', 1);
INSERT INTO route_path VALUES ('big_europe_loop', 'leg_29', 2);
INSERT INTO route_path VALUES ('big_europe_loop', 'leg_16', 3);
INSERT INTO route_path VALUES ('big_europe_loop', 'leg_25', 4);
INSERT INTO route_path VALUES ('big_europe_loop', 'leg_13', 5);
INSERT INTO route_path VALUES ('americas_one', 'leg_2', 1);
INSERT INTO route_path VALUES ('americas_one', 'leg_1', 2);
INSERT INTO route_path VALUES ('americas_two', 'leg_3', 1);
INSERT INTO route_path VALUES ('americas_two', 'leg_22', 2);
INSERT INTO route_path VALUES ('americas_three', 'leg_31', 1);
INSERT INTO route_path VALUES ('americas_three', 'leg_14', 2);
INSERT INTO route_path VALUES ('pacific_rim_tour', 'leg_7', 1);
INSERT INTO route_path VALUES ('pacific_rim_tour', 'leg_10', 2);
INSERT INTO route_path VALUES ('pacific_rim_tour', 'leg_18', 3);
INSERT INTO route_path VALUES ('germany_local', 'leg_9', 1);
INSERT INTO route_path VALUES ('germany_local', 'leg_30', 2);
INSERT INTO route_path VALUES ('germany_local', 'leg_17', 3);
INSERT INTO route_path VALUES ('texas_local', 'leg_15', 1);
INSERT INTO route_path VALUES ('texas_local', 'leg_20', 2);
INSERT INTO route_path VALUES ('texas_local', 'leg_19', 3);
INSERT INTO route_path VALUES ('americas_hub_exchange', 'leg_4', 1);

create table flight (
	flightID varchar(50),
    routeID varchar(50) not null,
    support_airline varchar(50) default null,
    support_tail varchar(50) default null,
    progress integer default null,
    airplane_status varchar(100) default null,
    next_time time default null,
    cost integer default 0,
	primary key (flightID),
    constraint fk14 foreign key (routeID) references route (routeID) on update cascade,
    constraint fk15 foreign key (support_airline, support_tail) references airplane (airlineID, tail_num)
		on update cascade on delete cascade
) engine = innodb;

INSERT INTO flight VALUES ('dl_10', 'americas_one', 'Delta', 'n106js', 1, 'in_flight', '08:00:00', 200);
INSERT INTO flight VALUES ('un_38', 'americas_three', 'United', 'n380sd', 2, 'in_flight', '14:30:00', 200);
INSERT INTO flight VALUES ('ba_61', 'americas_two', 'British Airways', 'n616lt', 0, 'on_ground', '09:30:00', 200);
INSERT INTO flight VALUES ('lf_20', 'euro_north', 'Lufthansa', 'n620la', 3, 'on_ground', '11:00:00', 300);
INSERT INTO flight VALUES ('km_16', 'euro_south', 'KLM', 'n161fk', 6, 'in_flight', '14:00:00', 400);
INSERT INTO flight VALUES ('ba_51', 'big_europe_loop', 'British Airways', 'n517ly', 0, 'on_ground', '11:30:00', 100);
INSERT INTO flight VALUES ('ja_35', 'pacific_rim_tour', 'Japan Airlines', 'n305fv', 1, 'in_flight', '09:30:00', 300);
INSERT INTO flight VALUES ('ry_34', 'germany_local', 'Ryanair', 'n341eb', 0, 'on_ground', '15:00:00', 100);
INSERT INTO flight VALUES ('am_96', 'americas_hub_exchange', 'American', 'n225sb', 1, 'on_ground', '21:30:00', 100);
INSERT INTO flight VALUES ('am_99', 'americas_hub_exchange', 'American', 'n553qn', 1, 'on_ground', '21:00:00', 100);
INSERT INTO flight VALUES ('am_86', 'south_euro_loop', 'Air France', 'n118fm', 4, 'on_ground', '23:45:00', 100);

create table pilot (
	personID varchar(50),
    taxID varchar(50) not null,
    experience integer default 0,
    commanding_flight varchar(50) default null,
    primary key (personID),
    unique key (taxID),
    constraint fk4 foreign key (personID) references person (personID),
    constraint fk9 foreign key (commanding_flight) references flight (flightID)
) engine = innodb;

INSERT INTO pilot VALUES ('p1', '330-12-6907', 31, 'dl_10');
INSERT INTO pilot VALUES ('p2', '842-88-1257', 9, 'dl_10');
INSERT INTO pilot VALUES ('p3', '750-24-7616', 11, 'un_38');
INSERT INTO pilot VALUES ('p4', '776-21-8098', 24, 'un_38');
INSERT INTO pilot VALUES ('p5', '933-93-2165', 27, 'ba_61');
INSERT INTO pilot VALUES ('p6', '707-84-4555', 38, 'ba_61');
INSERT INTO pilot VALUES ('p7', '450-25-5617', 13, 'lf_20');
INSERT INTO pilot VALUES ('p8', '701-38-2179', 12, 'ry_34');
INSERT INTO pilot VALUES ('p9', '936-44-6941', 13, 'lf_20');
INSERT INTO pilot VALUES ('p10', '769-60-1266', 15, 'lf_20');
INSERT INTO pilot VALUES ('p11', '369-22-9505', 22, 'km_16');
INSERT INTO pilot VALUES ('p12', '680-92-5329', 24, 'ry_34');
INSERT INTO pilot VALUES ('p13', '513-40-4168', 24, 'km_16');
INSERT INTO pilot VALUES ('p14', '454-71-7847', 13, 'km_16');
INSERT INTO pilot VALUES ('p15', '153-47-8101', 30, 'ja_35');
INSERT INTO pilot VALUES ('p16', '598-47-5172', 28, 'ja_35');
INSERT INTO pilot VALUES ('p17', '865-71-6800', 36, null);
INSERT INTO pilot VALUES ('p18', '250-86-2784', 23, null);
INSERT INTO pilot VALUES ('p19', '386-39-7881', 2, null);
INSERT INTO pilot VALUES ('p20', '522-44-3098', 28, null);
INSERT INTO pilot VALUES ('p46', '523-45-3098', 28, 'am_96');
INSERT INTO pilot VALUES ('p47', '524-46-3198', 28, 'am_96');
INSERT INTO pilot VALUES ('p48', '525-47-3298', 28, 'am_99');
INSERT INTO pilot VALUES ('p49', '526-48-3398', 28, 'am_99');

create table pilot_licenses (
	personID varchar(50),
    license varchar(100),
    primary key (personID, license),
    constraint fk5 foreign key (personID) references pilot (personID)
		on update cascade on delete cascade
) engine = innodb;

INSERT INTO pilot_licenses VALUES ('p1', 'jets');
INSERT INTO pilot_licenses VALUES ('p2', 'jets');
INSERT INTO pilot_licenses VALUES ('p2', 'props');
INSERT INTO pilot_licenses VALUES ('p3', 'jets');
INSERT INTO pilot_licenses VALUES ('p4', 'jets');
INSERT INTO pilot_licenses VALUES ('p4', 'props');
INSERT INTO pilot_licenses VALUES ('p5', 'jets');
INSERT INTO pilot_licenses VALUES ('p6', 'jets');
INSERT INTO pilot_licenses VALUES ('p6', 'props');
INSERT INTO pilot_licenses VALUES ('p7', 'jets');
INSERT INTO pilot_licenses VALUES ('p8', 'props');
INSERT INTO pilot_licenses VALUES ('p9', 'props');
INSERT INTO pilot_licenses VALUES ('p9', 'jets');
INSERT INTO pilot_licenses VALUES ('p9', 'testing');
INSERT INTO pilot_licenses VALUES ('p10', 'jets');
INSERT INTO pilot_licenses VALUES ('p11', 'jets');
INSERT INTO pilot_licenses VALUES ('p11', 'props');
INSERT INTO pilot_licenses VALUES ('p12', 'props');
INSERT INTO pilot_licenses VALUES ('p13', 'jets');
INSERT INTO pilot_licenses VALUES ('p14', 'jets');
INSERT INTO pilot_licenses VALUES ('p15', 'jets');
INSERT INTO pilot_licenses VALUES ('p15', 'props');
INSERT INTO pilot_licenses VALUES ('p15', 'testing');
INSERT INTO pilot_licenses VALUES ('p16', 'jets');
INSERT INTO pilot_licenses VALUES ('p17', 'jets');
INSERT INTO pilot_licenses VALUES ('p17', 'props');
INSERT INTO pilot_licenses VALUES ('p18', 'jets');
INSERT INTO pilot_licenses VALUES ('p19', 'jets');
INSERT INTO pilot_licenses VALUES ('p20', 'jets');
INSERT INTO pilot_licenses VALUES ('p46', 'jets');
INSERT INTO pilot_licenses VALUES ('p47', 'jets');
INSERT INTO pilot_licenses VALUES ('p48', 'jets');
INSERT INTO pilot_licenses VALUES ('p49', 'jets');

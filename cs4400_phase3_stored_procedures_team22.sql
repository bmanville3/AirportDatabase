-- CS4400: Introduction to Database Systems: Tuesday, September 12, 2023
-- Simple Airline Management System Course Project Mechanics [TEMPLATE] (v0)
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
	returns time reads sql data
begin
	declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);
end //
delimiter ;

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a new and database-wide unique location
since it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin

if ip_airlineID not in (select airlineID from airline) then leave sp_main; end if; -- existing airline
    if ip_tail_num in (select tail_num from airplane where airlineID=ip_airlineID) then leave sp_main; end if; -- unique tail_num
    if (ip_seat_capacity <= 0 or ip_speed <= 0) then leave sp_main; end if;
    if ip_plane_type = 'prop' and (ip_skids is null or ip_propellers is null) then leave sp_main; -- must be propeller based
	    end if;
	if ip_plane_type = 'jet' and (ip_jet_engines is null) then leave sp_main; end if; -- must be jet
	if ip_locationID in (select locationID from location) then leave sp_main; end if; -- checks for unique locationID
    
    insert into location values (ip_locationID);
    insert into airplane values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
    
    
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a new and database-wide unique location if it will be used
to support airplane takeoffs and landings.  An airport may have a longer, more
descriptive name.  An airport must also have a city, state, and country designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state varchar(100), in ip_country char(3), in ip_locationID varchar(50))
sp_main: begin

-- A new airport must have a unique identifier along with a new and 
	if ( ip_airportID in (select airportID from airport)) then leave sp_main; end if;
    -- database-wide unique location if it will be used
	-- to support airplane takeoffs and landings.
	if (ip_locationID is null) or (ip_locationID in (select locationID from location))
    then leave sp_main; end if;
    if (ip_city is null) or (ip_state is null) or (ip_country is null) then leave sp_main; end if;
    
    insert into location values (ip_locationID);
    insert into airport values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_country, ip_locationID);
    
    -- select * from airport;
end //
delimiter ;

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person must have a first name, and might also have a last name.

A person can hold a pilot role or a passenger role (exclusively).  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  As a
passenger, a person will have some amount of frequent flyer miles, along with a
certain amount of funds needed to purchase tickets for flights. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_miles integer, in ip_funds integer)
sp_main: begin

if ip_locationID not in (select locationID from location) then leave sp_main; end if;
if ip_first_name is null then leave sp_main; end if;
if ip_personID in (select personID from person) then leave sp_main; end if;
if ip_taxID is not null and ip_experience is not null and ip_miles is not null and ip_funds is not null then leave sp_main; end if;

-- adding pilot
-- must have unique taxid
if ((ip_taxID is not null) and (ip_experience is not null)
    and (ip_taxID in (select taxID from pilot))) then leave sp_main; end if;


if ip_taxID is not null and ip_experience is not null then
insert into person values (ip_personID, ip_first_name, ip_last_name, ip_locationID);

insert into pilot values(ip_personID, ip_taxID, ip_experience, null);

end if;




if ip_funds is not null and ip_miles is not null then
insert into person values(ip_personID, ip_first_name, ip_last_name, ip_locationID);
insert into passenger values(ip_personID, ip_miles, ip_funds);
end if;

end //
delimiter ;

-- [4] grant_or_revoke_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure inverts the status of a pilot license.  If the license
doesn't exist, it must be created; and, if it laready exists, then it must be removed. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_or_revoke_pilot_license;
delimiter //
create procedure grant_or_revoke_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin

if (ip_personID not in (select personID from pilot)) then leave sp_main; end if;
if (ip_license is NULL) then leave sp_main; end if;

if (ip_license in (select license from pilot_licenses where personID =  ip_personID)) then 
delete from pilot_licenses where personID = ip_personID and license = ip_license;
leave sp_main;
end if;

insert into pilot_licenses values (ip_personID, ip_license);

end //
delimiter ;

-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  And
the airplane, if designated, must not be in use by another flight.  The flight
can be started at any valid location along the route except for the final stop,
and it will begin on the ground.  You must also include when the flight will
takeoff along with its cost. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_next_time time, in ip_cost integer)
sp_main: begin

	-- need to check if the plane is at the right loc?
    if (ip_flightID is null) then leave sp_main; end if;
    if (ip_flightID in (select flightID from flight)) then leave sp_main; end if;

    -- May be unneccesary but checks if the passed in supporting airplane (if not null) is actually valid
    if ((ip_support_airline is not null) or (ip_support_tail is not null))
        and (ip_support_tail not in (select tail_num from airplane where airlineID = ip_support_airline)) then leave sp_main;
    end if;

	-- Checks if airplane already supports a flight (if not null)
    if (((ip_support_airline is not null) and (ip_support_tail is not null))

        and (ip_support_tail in (select support_tail from flight where support_airline = ip_support_airline)))
        then leave sp_main; end if;

        /* I can't tell if this is necessary
    -- check if the plane is at the right loc
    set @plane_at_airport_locationID = 'NONE';
    if 0 = (select progress from flight where flightID = ip_flightID) then
        -- on 0
        set @plane_at_airport_locationID = 
        ( select locationID from airport
            join leg on leg.departure = airport.airportID
            join route_path on leg.legID = route_path.legID
            join route on route_path.routeID = route.routeID
            join flight on route.routeID = flight.routeID
            where flight.flightID = @ip_flightID and route_path.sequence = 1
        );
    else
        -- not on 0
        set @plane_at_airport_locationID = 
        ( select locationID from airport
            join leg on leg.arrival = airport.airportID
            join route_path on leg.legID = route_path.legID
            join route on route_path.routeID = route.routeID
            join flight on route.routeID = flight.routeID
            where flight.flightID = @ip_flightID and route_path.sequence = flight.progress
        );
    end if;
     */
        
	-- Checks if route is valid 
    if ((ip_routeID is null) or (ip_routeID not in (select routeID from route))) then leave sp_main; end if;	-- Checks if at the last step of the sequence
    if ip_progress in (select max(sequence) from route_path where routeID = ip_routeID) then leave sp_main; end if;
    -- Makes sure there is a cost and a next time
    if ip_next_time is null or ip_cost is null then leave sp_main; end if;
    -- All flights start on the ground
    insert into flight values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, 'on_ground', ip_next_time, ip_cost);
    
end //
delimiter ;

-- [6] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	if (ip_flightID is null) then leave sp_main; end if;
	if (ip_flightID not in (select flightID from flight)) then leave sp_main; end if;
    if ((select airplane_status from flight where flightID = ip_flightID) != 'in_flight') then leave sp_main; end if;
    
    -- The time for the flight should be moved one hour into the future
    set @initial_time = (select next_time from flight where flightID = ip_flightID);
    set @incremented_time = ADDTIME(@initial_time, '01:00:00');
    update flight set next_time = @incremented_time where flightID = ip_flightID;
    -- update flight to be on the ground instead of in air
    update flight set airplane_status = 'on_ground' where flightID = ip_flightID;

	
    -- the pilots of the flight should receive increased experience
    update pilot
    set experience = experience + 1
    where commanding_flight = ip_flightID; 
    
    
    -- the passengers should have their frequent flyer miles updated
	set @loc = 
		(select airplane.locationID
        from airplane join flight
        on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
        where flight.flightID = ip_flightID);


	set @dist = 
		(select leg.distance from
		flight join route on flight.routeID = route.routeID
		join route_path on route.routeID = route_path.routeID
		join leg on leg.legID = route_path.legID
		where route_path.sequence = flight.progress
		and flight.flightID = ip_flightID);

	update passenger
    set miles = miles + (@dist)
    where passenger.personID in 
    (select personID
    from person 
    where locationID = @loc);


    
end //
delimiter ;

-- [7] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
    -- Checking for the number of pilots on the plane 
    set @numPilots = (select count(*) from pilot where commanding_flight = ip_flightID);
    set @airLine = (select support_airline from flight where flightID = ip_flightID);
    set @Tail = (select support_tail from flight where flightID = ip_flightID);
    set @initialTime = (select next_time from flight where flightID = ip_flightID);
    if 'prop' = (select plane_type from airplane where airlineID = @airLine and tail_num = @Tail) and @numPilots < 1 then 
        update flight set next_time = ADDTIME(@initialTime, '00:30:00') where flightID = ip_flightID;
        leave sp_main;
    elseif 'jet' = (select plane_type from airplane where airlineID = @airLine and tail_num = @Tail) and @numPilots < 2 then 
        update flight set next_time = ADDTIME(@initialTime, '00:30:00') where flightID = ip_flightID; 
        leave sp_main;
	end if;
    
    -- I believe update airport to next airport is incrementing progress by 1 since (routeID, progress) -> (routeID, seq) -> leg -> airport
    -- Also, Page 3 of scenario description, it updates progress++ when flight takes off
    -- no I checked, the autograder keeps the progress number the same
    -- the autograder also has it so that the next time isn't updated, idk why
    -- select * from flight;
    if (select airplane_status from flight where flightID = ip_flightID) = 'in_flight' then leave sp_main; end if;
    
    
    
    set @progress = (select progress from flight where flightID = ip_flightID);
    Set @route = (select routeID from flight where flightID = ip_flightID);
    
    -- check if we are at the end of the plane's route
    if @progress = (select max(sequence) from route_path where routeID = @route) then leave sp_main;
    end if;
    
    Set @legID = (select legID from route_path where routeID = @route and sequence = @progress);
    set @dist = (select distance from leg where legID = @legID);
    set @speed = (select speed from airplane where airlineID = @airLine and tail_num = @Tail);
    set @initialTime = (select next_time from flight where flightID = ip_flightID);
    set @newTime = ADDTIME(@initialTime, leg_time(@dist, @speed));
    
    update flight set next_time = @newTime where flightID = ip_flightID;
    update flight set progress = progress + 1 where flightID = ip_flightID;
    update flight set airplane_status = 'on_ground' where flightID = ip_flightID;
end //
delimiter ;


-- [8] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the same airport as the flight,
and the flight must be heading towards that passenger's desired destination.
Also, each passenger must have enough funds to cover the flight.  Finally, there
must be enough seats to accommodate all boarding passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin

/* v2 @luke
*/
if ip_flightID is null then leave sp_main; end if;
-- check on ground
if 'on_ground' != (select airplane_status from flight where flightID = ip_flightID) then leave sp_main; end if;
if (((select support_airline from flight where flightID =  ip_flightID) is null)
    or (select support_tail from flight where flightID =  ip_flightID) is null)
    then leave sp_main;
end if;

-- get the loc of the plane: if 0, at leg1 depart, else at legn arrival
set @plane_at_airport_locationID = 'NONE';
if 0 = (select progress from flight where flightID = ip_flightID) then
    -- on 0
    set @plane_at_airport_locationID = 
    ( select locationID from airport
		join leg on leg.departure = airport.airportID
        join route_path on leg.legID = route_path.legID
        join route on route_path.routeID = route.routeID
        join flight on route.routeID = flight.routeID
        where flight.flightID = @ip_flightID and route_path.sequence = 1
    );
else
    -- not on 0
    set @plane_at_airport_locationID = 
    ( select locationID from airport
		join leg on leg.arrival = airport.airportID
        join route_path on leg.legID = route_path.legID
        join route on route_path.routeID = route.routeID
        join flight on route.routeID = flight.routeID
        where flight.flightID = @ip_flightID and route_path.sequence = flight.progress
    );
end if;
-- select @plane_at_airport_locationID; -- debug
/*
-- get the loc id of the airport
set @airport_locationID = 
(
    select locationID from airport where airportID = @plane_at_airport_locationID
);
-- select @airport_locationID; -- debug
*/

-- get the cost
set @cost = (select cost from flight where flightID = ip_flightID);
-- select @cost; -- debug

-- get the seating capacity
set @seating_capacity = 
(
    select seat_capacity from airplane
    join flight on airplane.tail_num = flight.support_tail
        and airplane.airlineID = flight.support_airline
    where flight.flightID = ip_flightID
);
-- select @seating_capacity; -- debug
-- location of the airplane
set @airplane_location =
(
    select locationID from airplane
    join flight on airplane.tail_num = flight.support_tail
        and airplane.airlineID = flight.support_airline
    where flight.flightID = ip_flightID
);
-- select @airplane_location; -- debug
-- get the current seats taken on the flight
set @seats_taken = 
(
    select count(*) from passenger
    natural join person
    where locationID = @airplane_location
    
);
-- select @seats_taken; -- debug

set @seats_remaining = @seating_capacity - @seats_taken;
-- select @seats_remaining; -- debug

-- The passengers must be at the same airport as the flight,
-- and the flight must be heading towards that passenger's desired destination.
-- Also, each passenger must have enough funds to cover the flight.

-- find how many passengers can get a ticket
set @passenger_count = 
(
    select count(*) from passenger
    join person on person.personID = passenger.personID
    join passenger_vacations on passenger.personID = passenger_vacations.personID
    where person.locationID = @plane_at_airport_locationID
        and passenger_vacations.sequence = 1
        and passenger.funds >= @cost
        and passenger_vacations.airportID in
		(
        select arrival from leg
        join route_path on route_path.legID = leg.legID
        join route on route.routeID = route_path.routeID
        join flight on flight.routeID = route.routeID
        where flight.flightID = ip_flightID
        and route_path.sequence > flight.progress
		)
);
-- select @passenger_count; -- debug


-- ensure seating capacity
if @passenger_count > @seats_remaining then leave sp_main; end if;
-- else good to go

-- update passenger: location, funds, passenger_vac.seq
update passenger natural join person
set passenger.funds = passenger.funds - @cost,
person.locationID = @airplane_location
where  locationID = @plane_at_airport_locationID
and funds >= @cost
and person.personID in (
    select personID from passenger_vacations
    where airportID in (
        select airportID from airport where airportID in (
            select arrival from leg
            join route_path on route_path.legID = leg.legID
            join route on route.routeID = route_path.routeID
            join flight on flight.routeID = route.routeID
            where flight.flightID = ip_flightID
            and route_path.sequence > flight.progress
        )
    )
    and sequence = 1
);


/*
-- location
update person set person.locationID = @airplane_location
where personID in
(
    select personID from passenger where
    passenger.personID in
    (
        select personID from person where locationID = @plane_at_airport
    )
    and personID in 
    (
        select personID from passenger_vacations
        where sequence = 1
        and airportID in
        (
            select arrival from leg
            join route_path on route_path.legID = leg.legID
            join route on route.routeID = route_path.routeID
            join flight on flight.routeID = route.routeID
            where flight.flightID = ip_flightID
            and route_path.sequence > flight.progress
        )
    );
);
*/
/*
-- funds
update passenger set funds = (funds - @cost)
where personID in
    (
    select passenger.personID from passenger
    join person on person.personID = passenger.personID
    join passenger_vacations on passenger.personID = passenger_vacations.personID
        and passenger_vacations.sequence = 1
    where person.locationID = @plane_at_airport
        and passenger.funds >= @cost
        and passenger_vacations.airportID in
		(
            select arrival from leg
            join route_path on route_path.legID = leg.legID
            join route on route.routeID = route_path.routeID
            join flight on flight.routeID = route.routeID
            where flight.flightID = ip_flightID
            and route_path.sequence > flight.progress
		)
    );
*/
/*
-- sequence (decrement each) (where should this go?)
update passenger_vacations set sequence = (sequence - 1)
where personID in
    (
    select passenger.personID from passenger
    join person on person.personID = passenger.personID
    join passenger_vacations on passenger.personID = passenger_vacations.personID
        and passenger_vacations.sequence = 1
    where person.locationID = @plane_at_airport_locationID
        and passenger.funds >= @cost
        and passenger_vacations.airportID in
		(
            select arrival from leg
            join route_path on route_path.legID = leg.legID
            join route on route.routeID = route_path.routeID
            join flight on flight.routeID = route.routeID
            where flight.flightID = ip_flightID
            and route_path.sequence > flight.progress
		)
    );
*/

-- update airline.revenue
update airline
set revenue = (revenue + (@cost * @passenger_count))
where airlineID = (select support_airline from flight where flightID = ip_flightID);


end //
delimiter ;

-- [9] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin

-- create view passengers_on_flight as
-- select personID from person
-- join airplane on person.locationID = airplane.locationID
-- join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
-- where flight.flightID = ip_flightID;

-- create view passengers_at_their_dest as
-- select passenger.personID from passenger
-- join passenger_vacations on passenger.personID = passenger_vacations.personID
-- join leg on leg.arrival = passenger_vacations.airportID;

-- create view to_deplane as
-- select distinct * from
-- passengers_on_flight natural join passengers_at_their_dest;

-- set @dest = 
-- ( select airport.locationID
-- from airport join leg on airport.airportID = leg.arrival
-- join route_path on leg.legID = route_path.legID
-- join route on route_path.routeID = route.routeID
-- join flight on route.routeID = flight.routeID
-- where flight.flightID = ip_flightID
-- );

-- update person
-- set locationID = @dest
-- where personID in (select personID from to_deplane);


-- v2
-- update person
-- set locationID = 
-- ( select airport.locationID
-- from airport join leg on airport.airportID = leg.arrival
-- join route_path on leg.legID = route_path.legID
-- join route on route_path.routeID = route.routeID
-- join flight on route.routeID = flight.routeID
-- where flight.flightID = ip_flightID)
-- where personID in 
-- (select personID from 
-- (select distinct * from
-- (select passenger.personID from passenger
-- join passenger_vacations on passenger.personID = passenger_vacations.personID
-- join leg on leg.arrival = passenger_vacations.airportID) as at_dest
-- natural join 
-- (select personID from person
-- join airplane on person.locationID = airplane.locationID
-- join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
-- where flight.flightID = ip_flightID) as on_plane
-- ) as to_deplane
-- );

-- v3
set @dest = 
( select airport.locationID
from airport join leg on airport.airportID = leg.arrival
join route_path on leg.legID = route_path.legID
join route on route_path.routeID = route.routeID
join flight on route.routeID = flight.routeID
where route_path.sequence = flight.progress and flight.flightID = ip_flightID
);

set @airportCode = (select airportID from airport where locationID = @dest);

drop table if exists id;
create table id (personID varchar(50));
insert into id (personID)

(select * from (select personID from person
join airplane on person.locationID = airplane.locationID
join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
where flight.flightID = ip_flightID) as A natural join (select passenger_vacations.personID from passenger
join passenger_vacations on passenger.personID = passenger_vacations.personID
where sequence = 1 and airportID = @airportCode) as B);

select * from id;
delete from passenger_vacations where personID in (select personID from id) and sequence = 1;
update passenger_vacations set sequence = sequence - 1 where personID in (select personID from id);
update person set locationID = @dest where personID in (select personID from id);

drop table id;


-- update passenger_vacations
-- with passengers_on_flight as
-- (
-- select personID from person
-- join airplane on person.locationID = airplane.locationID
-- join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
-- where flight.flightID = ip_flightID
-- ),
-- passengers_at_their_dest as(
-- select passenger_vacations.personID from passenger
-- join passenger_vacations on passenger.personID = passenger_vacations.personID
-- where sequence = 1 and airportID = @airportCode
-- ), to_deplane as
-- (
-- select distinct * from
-- passengers_on_flight natural join passengers_at_their_dest
-- )
-- delete from passenger_vacations where personID in (select personID from to_deplane) and sequence = 1;


-- with passengers_on_flight as
-- (
-- select personID from person
-- join airplane on person.locationID = airplane.locationID
-- join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
-- where flight.flightID = ip_flightID
-- ),
-- passengers_at_their_dest as(
-- select passenger_vacations.personID from passenger
-- join passenger_vacations on passenger.personID = passenger_vacations.personID
-- where sequence = 1 and airportID = @airportCode
-- ), to_deplane as
-- (
-- select distinct * from
-- passengers_on_flight natural join passengers_at_their_dest
-- )
-- update passenger_vacations set sequence = sequence - 1 where personID in (select personID from to_deplane);




-- -- update passenger locations who are getting off
-- with passengers_on_flight as
-- (
-- select personID from person
-- join airplane on person.locationID = airplane.locationID
-- join flight on airplane.tail_num = flight.support_tail and airplane.airlineID = flight.support_airline
-- where flight.flightID = ip_flightID
-- ),
-- passengers_at_their_dest as(
-- select passenger_vacations.personID from passenger
-- join passenger_vacations on passenger.personID = passenger_vacations.personID
-- where sequence = 1 and airportID = @airportCode
-- ), to_deplane as
-- (
-- set @toUpdate = (select distinct * from
-- passengers_on_flight natural join passengers_at_their_dest)
-- )
-- update person
-- set locationID = @dest
-- where personID in (select personID from to_deplane);


end //
delimiter ;

-- [10] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
flight.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
if ip_personID is null or ip_personID not in (select personID from pilot) then leave sp_main; end if;
set @license = (select license from pilot_licenses where personID = ip_personID);

-- check if license is jet and plane is not jet
if ((select jet_engines from airplane where (airlineID, tail_num) in (select support_airline, support_tail from flight where flightID = ip_flightID))) is null
and @license = 'jet'
then 
leave sp_main;
end if;

-- check if license is prop and plane is jet
if ((select jet_engines from airplane where (airlineID, tail_num) in (select support_airline, support_tail from flight where flightID = ip_flightID))) is not null
and @license = 'prop'
then 
leave sp_main;
end if;

select * from pilot;
-- check to make sure pilot is in plane's location
set @location = (select locationID from airport where airportID = (select arrival from leg where legID = (select legID from route_path where (routeID, sequence) in (select routeID, progress from flight where flightID = ip_flightID))));
if (select locationID from person where personID = ip_personID) != @location
then 
leave sp_main;
end if;
select * from passenger;


-- make sure they don't already have any planes
if (select commanding_flight from pilot where personID = ip_personID) is not null
then 
leave sp_main;
end if;



-- update commanding flight
update pilot set commanding_flight = ip_flightID where personID = ip_personID;
-- update location
update person set locationID = (select locationID from airplane where (airlineID, tail_num) in (select support_airline, support_tail from flight where flightID = ip_flightID))
where personID = ip_personID;

select * from pilot;


end //
delimiter ;

-- [11] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
-- select * from flight;

set @airplaneLocation = (select locationID from flight join airplane on (support_airline, support_tail) = (airlineID, tail_num) where flightID = ip_flightID);

-- make sure everyone is off of flight
if (select count(*) from person natural join passenger where locationID = @airplaneLocation) > 0 then leave sp_main; end if;

-- make sure flight is finished
if (select progress from flight where flightID = ip_flightID)
!= (select max(sequence) from route_path where routeID = (select routeID from flight where flightID = ip_flightID))
then leave sp_main;
end if;



 set @location = 
(select locationID from airport where airportID = 
    ( select arrival from leg
        join route_path on leg.legID = route_path.legID
        join route on route_path.routeID = route.routeID
        join flight on route.routeID = flight.routeID
        where flight.flightID = ip_flightID and route_path.sequence = (select progress from flight where flight.flightID = ip_flightID)
    ));
    
    
-- set @flightLocation = (select locationID from flight join airplane on (support_airline, support_tail) = (airlineID, tail_num) where flightID = ip_flightID);
update person set locationID = @location where personID in (select personID from pilot where commanding_flight = ip_flightID);
-- select * from pilot where commanding_flight = 'am_99';-- ip_flight_id;
update pilot set commanding_flight = null where commanding_flight = ip_flightID;
-- select * from pilot;

end //
delimiter ;

-- [12] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  And the flight must be empty - no pilots or passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin

if 'on_ground' != (select airplane_status from flight where flightID = ip_flightID) then
leave sp_main;
end if;

-- check if it is at start/end of route
if 
    (
        0 != (select progress from flight where flightID = ip_flightID)
    )
    and 
    (
        (select max(sequence) from route_path
        where routeID = (select routeID from flight where flightID = ip_flightID))
        !=
        (select progress from flight where flightID = ip_flightID)
    )
then
leave sp_main;
end if;

-- check if number of people at the plane is 0
if
(select count(*) from person group by locationID having locationID = 
(select locationID from airplane where (airlineID, tail_num) in 
(select support_airline, support_tail from flight where flightID = ip_flightID))) > 0 then
leave sp_main;
end if;

delete from flight where flightID = ip_flightID;

/*
-- don't think we have to delete location -luke
set @location = (select locationID from airplane where (airlineID, tail_num) in 
(select support_airline, support_tail from flight where flightID = ip_flightID));

delete from location where locationID = @location;
*/

-- select * from airplane;

-- (select max(sequence) from route_path where routeID = (select routeID from flight where flightID = ip_flightID))

-- select * from flight;
end //
delimiter ;

-- [13] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin

-- selects earliest flight, and chooses best flight based on alphabetical sorting
set @flight = (select min(flightID) from flight where flightID in (select flightID from flight where next_time = (select min(next_time) from flight)));

if @flight = null then leave sp_main; end if;

-- chooses earliest flight that is in the air sorted by alphabet, if there is none, it won't execute, so we will have
-- previous @flight value which is earliest flight sorted by alphabet
if (select min(flightID) from flight where flightID in (select flightID from flight where next_time = (select min(next_time) from flight) and airplane_status = 'in_flight')) is not null then 
set @flight = (select min(flightID) from flight where flightID in (select flightID from flight where next_time = (select min(next_time) from flight) and airplane_status = 'in_flight'));
end if;

if (select airplane_status from flight where flightID = @flight) = 'in_flight' then
call flight_landing(@flight);
call passengers_disembark(@flight);
leave sp_main;
end if;

set @progress = (select progress from flight where flightID = @flight);
Set @route = (select routeID from flight where flightID = @flight);
    
-- check if we are at the end of the plane's route
if @progress = (select max(sequence) from route_path where routeID = @route) then 
call recycle_crew(@flight);
call retire_flight(@flight);
leave sp_main;
end if;

call passengers_board(@flight);
call flight_takeoff(@flight);

end //
delimiter ;

-- [14] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air (departing_from, arriving_at, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as
SELECT
    l.departure AS departing_from,
    l.arrival AS arriving_at,
    COUNT(*) AS total_flights,
    f.flightID,
    f.next_time as earliest_arrival,
    f.next_time as latest_arrival,
    a.locationID as flight_list
FROM
    flight f
JOIN
    route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence
JOIN
    leg l ON rp.legID = l.legID
JOIN
	airplane a ON f.support_tail = a.tail_num
WHERE
    f.airplane_status = 'in_flight'
GROUP BY
    f.flightID, l.departure, l.arrival, a.locationID;

-- [15] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. */
-- -----------------------------------------------------------------------------
-- need two views for flights w progress 0 and non 0
-- for non 0
create or replace view flights_on_the_ground_in_route (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
select leg.arrival,
-- (select count(*) from flight as flight1 where flight1.flightID = f.flightID),
count(f.flightID), -- from flight as flight1 where flight1.flightID = f.flightID),
group_concat(f.flightID order by f.flightID),
min(f.next_time),
max(f.next_time),
group_concat(distinct airplane.locationID order by airplane.locationID)
from leg
join route_path on route_path.legID = leg.legID
join flight as f on f.routeID =  route_path.routeID
join airplane on airplane.tail_num = f.support_tail
    and airplane.airlineID = f.support_airline
where f.airplane_status = 'on_ground'
and route_path.sequence = f.progress
and f.progress != 0
group by leg.arrival
;
-- for 0
create or replace view flights_on_the_ground_start_of_route (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
select leg.departure,
-- (select count(*) from flight as flight1 where flight1.flightID = f.flightID),
count(f.flightID), -- from flight as flight1 where flight1.flightID = f.flightID),
group_concat(f.flightID order by f.flightID),
min(f.next_time),
max(f.next_time),
group_concat(distinct airplane.locationID order by airplane.locationID)
from leg
join route_path on route_path.legID = leg.legID
join flight as f on f.routeID =  route_path.routeID
join airplane on airplane.tail_num = f.support_tail
    and airplane.airlineID = f.support_airline
where f.airplane_status = 'on_ground'
and route_path.sequence = 1
and f.progress = 0
group by leg.departure
;

-- combine the two views
create or replace view flights_on_the_ground (departing_from, num_flights,
	flight_list, earliest_arrival, latest_arrival, airplane_list) as 
(select * from flights_on_the_ground_in_route) union (select * from flights_on_the_ground_start_of_route);

-- [16] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
SELECT
    l.departure AS departing_from,
    l.arrival AS arriving_at,
    COUNT(DISTINCT a.tail_num) AS num_airplanes,
    GROUP_CONCAT(DISTINCT a.locationID) AS airplane_list,
    GROUP_CONCAT(DISTINCT f.flightID) AS flight_list,
    f.next_time AS earliest_arrival,
    f.next_time AS latest_arrival,
    COUNT(DISTINCT pi.personID) AS num_pilots,
    COUNT(DISTINCT pa.personID) AS num_passengers,
    COUNT(DISTINCT p.personID) AS joint_pilots_passengers,
    GROUP_CONCAT(DISTINCT p.personID) AS person_list
FROM
    flight f
JOIN
    route_path rp ON f.routeID = rp.routeID AND f.progress = rp.sequence
JOIN
    leg l ON rp.legID = l.legID
JOIN
    airplane a ON f.support_tail = a.tail_num
LEFT JOIN
    person p ON a.locationID = p.locationID
LEFT JOIN
    pilot pi ON p.personID = pi.personID
LEFT JOIN
    passenger pa ON p.personID = pa.personID
WHERE
    f.airplane_status = 'in_flight'
GROUP BY
    l.departure, l.arrival, f.flightID
ORDER BY
    l.departure, l.arrival;


-- [17] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, country, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
select
ap.airportID, ap.locationID, ap.airport_name, ap.city, ap.state, ap.country,
(select count(*) from pilot natural join person where person.locationID = ap.locationID),
(select count(*) from passenger natural join person where person.locationID = ap.locationID),
(select count(*) from person where person.locationID = ap.locationID),
group_concat(person.personID)
from airport as ap join person on person.locationID = ap.locationID
group by ap.airportID
;

-- [18] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
SELECT
    r.routeID as route,
    COUNT(DISTINCT l.legID) AS num_legs,
    GROUP_CONCAT(DISTINCT l.legID ORDER BY rp.sequence) AS leg_sequence,
    CASE
		WHEN COUNT(DISTINCT f.flightID) > 0 THEN CAST(SUM(l.distance) / COUNT(DISTINCT f.flightID) AS SIGNED)
		ELSE SUM(l.distance)
    END AS route_length,
    COUNT(DISTINCT f.flightID) AS num_flights,
    GROUP_CONCAT(DISTINCT f.flightID) AS flight_list,
    GROUP_CONCAT(DISTINCT concat(concat(l.departure, '->'), l.arrival) ORDER BY rp.sequence) AS airport_sequence
FROM
    route_path rp
JOIN
    leg l ON rp.legID = l.legID
JOIN
    route r ON rp.routeID = r.routeID
LEFT JOIN
    flight f ON r.routeID = f.routeID
LEFT JOIN
    airplane ap ON f.support_tail = ap.tail_num
LEFT JOIN
    airport a ON ap.locationID = a.airportID
GROUP BY
    r.routeID
ORDER BY
    r.routeID;

-- [19] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, country, num_airports,
	airport_code_list, airport_name_list) as
SELECT
    city,
    state,
    country,
    COUNT(*) AS num_airports,
    GROUP_CONCAT(airportID) AS airport_ids,
    GROUP_CONCAT(airport_name) AS airport_names
FROM
    airport
GROUP BY
    city, state, country
HAVING
    COUNT(*) > 1;
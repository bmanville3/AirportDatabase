import pandas as pd
from numpy import nan as NaN

#Please go in to each csv when imported from excel and assess the clean up needed
#These lines may or may not need to be modified on a case to case basis
#I manually went in and delete random ,,,, that ended up at the bottom of the csv
routes = pd.read_csv('DataRoutes.csv').replace({NaN: 'NULL'})
flights = pd.read_csv('DataFlights.csv').replace({NaN: 'NULL'})
persons = pd.read_csv('DataPersons.csv').replace({NaN: 'NULL'})
locations = pd.read_csv('DataLocations.csv')
planes = pd.read_csv('DataAirplanes.csv').replace({NaN: 'NULL'})
ports = pd.read_csv('DataAirports.csv').replace({NaN: 'NULL'})

#We will now write insert statements for MySQL
#My thought process:
#It is helpful to insert the data based on the order of the tables
#This will ensure there are no (accidental/unneccesary) integrity key restraints
#If done out of order, ensure that the table you are inserting to does not reference another table
#This code will sacrifice efficiency in order to have the insert table statements be grouped together by table
#I will be writing this data to a notepad file to copy and paste into excel

def iAirline(ID, rev):
    return f'''INSERT INTO airline VALUES ('{ID}', {rev});\n'''

def iLocation(ID):
   return f'''INSERT INTO location VALUES ('{ID}');\n'''

def iAirport(ID, name, city, state, country, location):
    return f'''INSERT INTO airport VALUES ('{ID}', '{name}', '{city}', '{state}', '{country}', '{location}');\n'''

def iRoute(ID):
    return f'''INSERT INTO route VALUES ('{ID}');\n'''

def iAirplane(aID, tnum, loc, type, props, skids, jets, seat_cap, speed):
   return f'''INSERT INTO airplane VALUES ('{aID}', '{tnum}', '{loc}', '{type}', {props}, {skids}, {jets}, {seat_cap}, {speed});\n'''

def iFlight(ID, route, cost, sID, snum, progress, pstatus, next_time):
   return f'''INSERT INTO flight VALUES ('{ID}', '{route}', {cost}, '{sID}', '{snum}', {progress}, '{pstatus}', {next_time});\n'''

def iLeg(ID, distance, departs, arrives):
   return f'''INSERT INTO leg VALUES ('{ID}', {distance}, '{departs}', '{arrives}');\n'''

def iContains(routeID, legID, seq):
   return f'''INSERT INTO route_contains VALUES ('{routeID}', '{legID}', {seq});\n'''

def iPass(ID, fname, lname, funds, miles, occupies):
   return f'''INSERT INTO passenger VALUES ('{ID}', '{fname}', '{lname}', {funds}, {miles}, '{occupies}');\n'''

def iVac(ID, des, seq):
   return f'''INSERT INTO vacation VALUES ('{ID}', '{des}', {seq});\n'''

def iPilot(ID, taxID, fname, lname, exp, commands, occupies):
   return f'''INSERT INTO pilot VALUES ('{ID}', '{taxID}', '{fname}', '{lname}', {exp}, '{commands}', '{occupies}');\n'''

def iLic(ID, type):
   return f'''INSERT INTO license VALUES ('{ID}', '{type}');\n'''

aLines = []

file = open("MySQLInsertsProjectPhaseII.txt", 'w')
string = ''
for index, row in planes.iterrows():
   if not row['airlineID'] in aLines:
       string += iAirline(row['airlineID'], row['airline_revenue'])
       aLines.append(row['airlineID'])

for index, row in locations.iterrows():
   string += iLocation(row['locationID'])

for index, row in routes.iterrows():
   string += iRoute(row['routeID'])

for index, row in ports.iterrows():
   string += iAirport(row['airportID'], row['airport_name'], row['city'], row['state'], row['country_code'], row['locationID'])

for index, row in planes.iterrows():
   string += iAirplane(row['airlineID'], row['tail_num'], row['locationID'], row['plane_type'], row['props'], row['skids'], row['jets'], row['seat capacity'], row['speed'])

for index, row in flights.iterrows():
   string += iFlight(row['flightID'], row['routeID'], row['cost'], row['support_airline'], row['support_tail'], row['progress'], row['airplane_status'], row['next_time']).replace(':', '')

allLegIDs = []
for index, row in routes.iterrows():
   legsOfRoute = row['legs'].replace('"', '').split(', ')
   for leg in legsOfRoute:
      ID, ArDp, dis = leg.split(':')
      ArDp = ArDp.split('-->')
      if not ID in allLegIDs:
         allLegIDs.append(ID)
         string += iLeg(ID, dis.replace('mi', ''), ArDp[0], ArDp[1])

#This could be done more efficiently by doing this at the same time as we create the leg inserts
#This could be done since we guarantee the forein legID key will be made before we reference it in the route_contains table
#But, we will do this inefficiently so we can have all the 'insert leg' statements separate from the 'insert route_contains'
for index, row in routes.iterrows():
   seq = 0
   legsOfRoute = row['legs'].replace('"', '').split(', ')
   for leg in legsOfRoute:
      #sequence will be 1-indexed
      seq += 1
      ID, ArDp, dis = leg.split(':')
      ArDp = ArDp.split('-->')
      string += iContains(row['routeID'], ID, seq)

for index, row in persons.iterrows():
   if row['taxID'] == 'NULL':
       string += iPass(row['personID'], row['first_name'], row['last_name'], row['funds'], row['miles'], row['locationID'])

#Once again, choosing inefficiency to have separate insert statements
for index, row in persons.iterrows():
   if row['taxID'] == 'NULL' and row['vacations'] != 'NULL':
      seq = 0
      listOfVac = row['vacations'].replace('"', '').split(', ')
      for vac in listOfVac:
         #seq will be 1-indexed
         seq += 1
         string += iVac(row['personID'], vac, seq)

#This could have also been done with persons, but to have it separate we will do it here
for index, row in persons.iterrows():
   if row['taxID'] != 'NULL':
      string += iPilot(row['personID'], row['taxID'], row['first_name'], row['last_name'], row['experience'], row['associated_flight'], row['locationID'])

#Could have been done with pilots
for index, row in persons.iterrows():
   if row['taxID'] != 'NULL':
      listOfLic = row['license_types'].replace('"', '').split(', ')
      for lic in listOfLic:
         string += iLic(row['personID'], lic)

string = string.replace("'NULL'", 'NULL')
file.write(string)
file.close()
import os
os.system("notepad.exe MySQLInsertsProjectPhaseII.txt")
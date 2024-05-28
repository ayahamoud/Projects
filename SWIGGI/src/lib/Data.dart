// ------------------------------------------ City ------------------------------------------
class City {
  final int cityNumber;
  final String cityName;
  final int countryNumber;
  City({required this.cityNumber, required this.cityName, required this.countryNumber,});
}
final List<City> cities = [
  City(cityNumber: 1, cityName: 'Vienna', countryNumber: 1),
  City(cityNumber: 2, cityName: 'Drancy', countryNumber: 2),
  City(cityNumber: 3, cityName: 'Frankreich', countryNumber: 2),
  City(cityNumber: 4, cityName: 'Budapest', countryNumber: 3),
  City(cityNumber: 5, cityName: 'Prague', countryNumber: 4),
  City(cityNumber: 6, cityName: 'Strassnitz', countryNumber: 4),
  City(cityNumber: 7, cityName: 'Auschwitz', countryNumber: 5),
  City(cityNumber: 8, cityName: 'Kielce', countryNumber: 5),
  City(cityNumber: 9, cityName: 'Lodz', countryNumber: 5),
  City(cityNumber: 10, cityName: 'Maly Trostinec', countryNumber: 6),
  City(cityNumber: 11, cityName: 'Nisko', countryNumber: 5),
  City(cityNumber: 12, cityName: 'Riga', countryNumber: 7),
  City(cityNumber: 13, cityName: 'Terezin', countryNumber: 4),
  City(cityNumber: 14, cityName: 'Warsaw', countryNumber: 5),
  City(cityNumber: 15, cityName: 'New York', countryNumber: 8),
  City(cityNumber: 16, cityName: 'Melbourne', countryNumber: 9),
  City(cityNumber: 17, cityName: 'Lublin', countryNumber: 5),
  City(cityNumber: 18, cityName: 'Hodonin', countryNumber: 4),
  City(cityNumber: 19, cityName: 'Prostejov', countryNumber: 4),
  City(cityNumber: 20, cityName: 'Dasice', countryNumber: 4),
  City(cityNumber: 21, cityName: 'Skalica', countryNumber: 10),
  City(cityNumber: 22, cityName: 'Straznice', countryNumber: 4),
];
// ------------------------------------------ Country ------------------------------------------
class Country {
  final int countryNumber;
  final String countryName;
  Country({required this.countryNumber, required this.countryName,});
}
final List<Country> countries = [
  Country(countryNumber: 1, countryName: 'Austria'),
  Country(countryNumber: 2, countryName: 'France'),
  Country(countryNumber: 3, countryName: 'Hungary'),
  Country(countryNumber: 4, countryName: 'Czech Republic'),
  Country(countryNumber: 5, countryName: 'Poland'),
  Country(countryNumber: 6, countryName: 'Belarus'),
  Country(countryNumber: 7, countryName: 'Latvia'),
  Country(countryNumber: 8, countryName: 'United States'),
  Country(countryNumber: 9, countryName: 'Australia'),
  Country(countryNumber: 10, countryName: 'Slovakia'),
];
// ------------------------------------------ Religion ------------------------------------------
class Religion {
  final int religionID;
  final String religionName;
  Religion({required this.religionID, required this.religionName,});
}
final List<Religion> religions = [
  Religion(religionID: 1, religionName: 'Jewish'),
];
// ------------------------------------------ Quarter ------------------------------------------
class Quarter {
  final int quarterId;
  final int quarterNumber;
  final String quarterName;
  final int cityNumber;
  Quarter({required this.quarterId, required this.quarterNumber, required this.quarterName, required this.cityNumber,});
}
final List<Quarter> quarters = [
  Quarter(quarterId: 1, quarterNumber: 1010, quarterName: 'Innere Stadt', cityNumber: 1),
];
// ------------------------------------------ ConcentrationCamp ------------------------------------------
class ConcentrationCamp {
  final int concentrationCampNumber;
  final String concentrationCampName;
  final int cityNumber;
  ConcentrationCamp({required this.concentrationCampNumber, required this.concentrationCampName, required this.cityNumber,});
}
final List<ConcentrationCamp> concentrationCamps = [
  ConcentrationCamp(concentrationCampNumber: 1, concentrationCampName: 'Auschwitz', cityNumber: 7),
  ConcentrationCamp(concentrationCampNumber: 2, concentrationCampName: 'Kielce', cityNumber: 8),
  ConcentrationCamp(concentrationCampNumber: 3, concentrationCampName: 'Litzmannstadt', cityNumber: 9),
  ConcentrationCamp(concentrationCampNumber: 4, concentrationCampName: 'Maly Trostinec', cityNumber: 10),
  ConcentrationCamp(concentrationCampNumber: 5, concentrationCampName: 'Nisko', cityNumber: 11),
  ConcentrationCamp(concentrationCampNumber: 6, concentrationCampName: 'Riga', cityNumber: 12),
  ConcentrationCamp(concentrationCampNumber: 7, concentrationCampName: 'Theresienstadt', cityNumber: 13),
  ConcentrationCamp(concentrationCampNumber: 8, concentrationCampName: 'Vienna', cityNumber: 1),
  ConcentrationCamp(concentrationCampNumber: 9, concentrationCampName: 'Treblinka', cityNumber: 14),
  ConcentrationCamp(concentrationCampNumber: 10, concentrationCampName: 'New York', cityNumber: 15),
  ConcentrationCamp(concentrationCampNumber: 11, concentrationCampName: 'Strassnitz', cityNumber: 6),
  ConcentrationCamp(concentrationCampNumber: 12, concentrationCampName: 'Melbourne', cityNumber: 16),
  ConcentrationCamp(concentrationCampNumber: 13, concentrationCampName: 'Lublin', cityNumber: 17),
  ConcentrationCamp(concentrationCampNumber: 14, concentrationCampName: 'Modliborzyce', cityNumber: 17),
  ConcentrationCamp(concentrationCampNumber: 15, concentrationCampName: 'Hodonin', cityNumber: 18),
];
// ------------------------------------------ House ------------------------------------------
class House {
  final int houseId;
  final int houseNumber;
  final String streetName;
  final int quarterId;
  final double gpsCoordsX;
  final double gpsCoordsY;
  final String embedCode;
  House({required this.houseId, required this.houseNumber, required this.streetName, required this.quarterId, required this.gpsCoordsX, required this.gpsCoordsY, required this.embedCode,});
}
final List<House> houses = [
  House(houseId: 1, houseNumber: 4, streetName: 'Habsburgergasse', quarterId: 1, gpsCoordsX: 48.2088244, gpsCoordsY: 16.3686463, embedCode: '<iframe src=https://www.google.com/maps/embed/v1/place?key=AIzaSyCEemwzZfd2oVS9u4n0o9fxlbser99Wk6c&q=Habsburgergasse+4+Vienna+Austria" width="600" height="450" style="border:0" loading="lazy" allowfullscreen="" ></iframe>',),
  House(houseId: 2, houseNumber: 14, streetName: 'Herrengasse', quarterId: 1, gpsCoordsX: 48.2107612, gpsCoordsY: 16.3650914, embedCode: '<iframe src=https://www.google.com/maps/embed/v1/place?key=AIzaSyCEemwzZfd2oVS9u4n0o9fxlbser99Wk6c&q=Herrengasse+14+Vienna+Austria" width="600" height="450" style="border:0" loading="lazy" allowfullscreen="" ></iframe>',),
  House(houseId: 3, houseNumber: 8, streetName: 'Judenplatz', quarterId: 1, gpsCoordsX: 48.2119187, gpsCoordsY: 16.3692474, embedCode: '<iframe src=https://www.google.com/maps/embed/v1/place?key=AIzaSyCEemwzZfd2oVS9u4n0o9fxlbser99Wk6c&q=Judenplatz+8%2F4+Vienna+Austria" width="600" height="450" style="border:0" loading="lazy" allowfullscreen="" ></iframe>',),
  House(houseId: 4, houseNumber: 5, streetName: 'Kohlmarkt', quarterId: 1, gpsCoordsX: 48.2089734, gpsCoordsY: 16.3681716, embedCode: '<iframe src=https://www.google.com/maps/embed/v1/place?key=AIzaSyCEemwzZfd2oVS9u4n0o9fxlbser99Wk6c&q=Kohlmarkt+5%2F3+Vienna+Austria" width="600" height="450" style="border:0" loading="lazy" allowfullscreen="" ></iframe>',),
  House(houseId: 5, houseNumber: 4, streetName: 'Parisergasse', quarterId: 1, gpsCoordsX: 48.2112546, gpsCoordsY: 16.3693814, embedCode: '<iframe src=https://www.google.com/maps/embed/v1/place?key=AIzaSyCEemwzZfd2oVS9u4n0o9fxlbser99Wk6c&q=Parisergasse+4+Vienna+Austria" width="600" height="450" style="border:0" loading="lazy" allowfullscreen="" ></iframe>',),
];
// ------------------------------------------ Person ------------------------------------------
class Person {
  final int? personID;
  final String? firstName;
  final String? maidenName;
  final String? lastName;
  final String? gender;
  final int? religionID;
  final DateTime? dateOfBirth;
  final int? placeBirth;
  final DateTime? dateOfDeath;
  final int? placeDeath;
  final int? houseID;
  final int? deportedFrom;
  final int? deportedTo;
  final DateTime? dateOfDeport;
  final String? Biography;

  Person({required this.personID, required this.firstName, required this.maidenName, required this.lastName, required this.gender, required this.religionID, required this.dateOfBirth, required this.placeBirth, required this.dateOfDeath, required this.placeDeath, required this.houseID, required this.deportedFrom, required this.deportedTo, required this.dateOfDeport, required this.Biography,});
}
final List<Person> persons = [
  Person(personID: 1, firstName: 'Paul', maidenName: null, lastName: 'Adler', gender: 'M', religionID: 1, dateOfBirth: DateTime(1888, 7, 4), placeBirth: 1, dateOfDeath: DateTime(1939, 10, 26), placeDeath: 5, houseID: 1, deportedFrom: 1, deportedTo: 5, dateOfDeport: DateTime(1939, 10, 27),Biography:'Paul Adler was the son of Eduard Moses Adler married Franziska Glas on the 10th of Sep.1882 in the Stadttempel, Vienna. He had two siblings: Margartha and Paul Adler.Paul married Rachela nee Tracht. Rachela Tracht had three children from a former marriage to Tobias Singer: Walter (born 1924), Felizia (born 1915) and Alfred Singer (born 1911).'),
  Person(personID: 2, firstName: 'Rachela', maidenName: 'Tracht', lastName: 'Adler', gender: 'F', religionID: 1, dateOfBirth: DateTime(1890, 4, 12), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 1, deportedFrom: 1, deportedTo: 2, dateOfDeport: DateTime(1941, 2, 19),Biography: 'Paul married Rachela nee Tracht. Rachela Tracht had three children from a former marriage to Tobias Singer: Walter (born 1924), Felizia (born 1915) and Alfred Singer (born 1911).'),
  Person(personID: 3, firstName: 'Ludwig', maidenName: null, lastName: 'Albrecht', gender: 'M', religionID: 1, dateOfBirth: DateTime(1872, 7, 18), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 4, firstName: 'Melanie', maidenName: 'Elias', lastName: 'Albrecht', gender: 'F', religionID: 1, dateOfBirth: DateTime(1879, 5, 25), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 5, firstName: 'Elly', maidenName: 'Brukner', lastName: 'Bettelheim', gender: 'F', religionID: 1, dateOfBirth: DateTime(1887, 7, 2), placeBirth: 1, dateOfDeath: DateTime(1943, 4, 9), placeDeath: 7, houseID: 4, deportedFrom: 4, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 22),Biography: null),
  Person(personID: 6, firstName: 'Ernst', maidenName: null, lastName: 'Bettelheim', gender: 'M', religionID: 1, dateOfBirth: DateTime(1873, 1, 21), placeBirth: 4, dateOfDeath: DateTime(1943, 3, 27), placeDeath: 7, houseID: 4, deportedFrom: 4, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 22),Biography: null),
  Person(personID: 7, firstName: 'Berthold', maidenName: null, lastName: 'Brammer', gender: 'M', religionID: 1, dateOfBirth: DateTime(1877, 3, 8), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 8, firstName: 'Theodora', maidenName: 'Schiller', lastName: 'Brammer', gender: 'M', religionID: 1, dateOfBirth: DateTime(1878, 11, 8), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 9, firstName: 'Blanka', maidenName: null, lastName: 'Braun', gender: 'F', religionID: 1, dateOfBirth: DateTime(1881, 11, 6), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 10, firstName: 'Arthur', maidenName: null, lastName: 'Dawid', gender: 'M', religionID: 1, dateOfBirth: DateTime(1877, 11, 13), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 11, firstName: 'Julie', maidenName: null, lastName: 'Doctor', gender: 'F', religionID: 1, dateOfBirth: DateTime(1869, 2, 28), placeBirth: null, dateOfDeath: DateTime(1943, 10, 15), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 8, 20),Biography: null),
  Person(personID: 12, firstName: 'Irene', maidenName: null, lastName: 'Fabri', gender: 'F', religionID: 1, dateOfBirth: DateTime(1867, 5, 22), placeBirth: null, dateOfDeath: DateTime(1943, 8, 12), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 6, 20),Biography: null),
  Person(personID: 13, firstName: 'Markus', maidenName: null, lastName: 'Fleischner', gender: 'M', religionID: 1, dateOfBirth: DateTime(1873, 4, 4), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 3, dateOfDeport: DateTime(1941, 10, 23),Biography: null),
  Person(personID: 14, firstName: 'Berta', maidenName: null, lastName: 'Fränkel', gender: 'F', religionID: 1, dateOfBirth: DateTime(1872, 8, 7), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 15, firstName: 'Malvine', maidenName: null, lastName: 'Friedland', gender: 'F', religionID: 1, dateOfBirth: DateTime(1876, 5, 18), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 16, firstName: 'Elisabeth', maidenName: null, lastName: 'Fröhlich', gender: 'F', religionID: 1, dateOfBirth: DateTime(1871, 12, 29), placeBirth: null, dateOfDeath: DateTime(1942, 12, 24), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 17, firstName: 'Gustav Adolf', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: 1, dateOfBirth: DateTime(1869, 6, 15), placeBirth: 5, dateOfDeath: DateTime(1943, 6, 16), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 18, firstName: 'Bettina', maidenName: 'Bruckner', lastName: 'Klein', gender: 'F', religionID: 1, dateOfBirth: DateTime(1892, 12, 10), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 19, firstName: 'Johanna', maidenName: null, lastName: 'Klein', gender: 'F', religionID: 1, dateOfBirth: DateTime(1862, 11, 5), placeBirth: null, dateOfDeath: DateTime(1943, 1, 21), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 20, firstName: 'Olga', maidenName: null, lastName: 'Klein', gender: 'F', religionID: 1, dateOfBirth: DateTime(1891, 7, 22), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 21, firstName: 'Lola', maidenName: null, lastName: 'Kurti', gender: 'F', religionID: 1, dateOfBirth: DateTime(1894, 3, 10), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 22, firstName: 'Franz', maidenName: null, lastName: 'Lindner', gender: 'M', religionID: 1, dateOfBirth: DateTime(1905, 7, 24), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 1, 11),Biography: null),
  Person(personID: 23, firstName: 'Martha', maidenName: null, lastName: 'Lindner', gender: 'F', religionID: 1, dateOfBirth: DateTime(1880, 4, 5), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 1, 11),Biography: null),
  Person(personID: 24, firstName: 'Karoline', maidenName: null, lastName: 'Lohde', gender: 'F', religionID: 1, dateOfBirth: DateTime(1874, 3, 11), placeBirth: null, dateOfDeath: null, placeDeath: 9, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 25, firstName: 'Sigmar', maidenName: null, lastName: 'Lohde', gender: 'M', religionID: 1, dateOfBirth: DateTime(1897, 3, 23), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 26, firstName: 'Ernst', maidenName: null, lastName: 'Neumann', gender: 'M', religionID: 1, dateOfBirth: DateTime(1879, 1, 20), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 9, 10),Biography: null),
  Person(personID: 27, firstName: 'Elisabeth', maidenName: 'Schmidl', lastName: 'Popper', gender: 'F', religionID: 1, dateOfBirth: DateTime(1867, 7, 21), placeBirth: 1, dateOfDeath: DateTime(1942, 9, 19), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 6, 20),Biography: null),
  Person(personID: 28, firstName: 'Leopold Josef Leopold', maidenName: null, lastName: 'Popper', gender: 'M', religionID: 1, dateOfBirth: DateTime(1866, 12, 10), placeBirth: 1, dateOfDeath: DateTime(1943, 3, 16), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 6, 20),Biography: null),
  Person(personID: 29, firstName: 'Wilhelm', maidenName: null, lastName: 'Roth', gender: 'M', religionID: 1, dateOfBirth: DateTime(1878, 10, 23), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 30, firstName: 'Otto', maidenName: null, lastName: 'Schmidek', gender: 'M', religionID: 1, dateOfBirth: DateTime(1897, 8, 15), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 3, deportedTo: null, dateOfDeport: null,Biography: null),
  Person(personID: 31, firstName: 'Berta', maidenName: null, lastName: 'Schneyer', gender: 'F', religionID: 1, dateOfBirth: DateTime(1879, 1, 27), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 32, firstName: 'Hermine', maidenName: null, lastName: 'Schwarz', gender: 'F', religionID: 1, dateOfBirth: DateTime(1888, 8, 20), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 33, firstName: 'Isidor', maidenName: null, lastName: 'Spronz', gender: 'M', religionID: 1, dateOfBirth: DateTime(1864, 2, 25), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 34, firstName: 'Amalie', maidenName: null, lastName: 'Stern', gender: 'F', religionID: 1, dateOfBirth: DateTime(1855, 10, 24), placeBirth: null, dateOfDeath: DateTime(1942, 7, 29), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 35, firstName: 'Pauline', maidenName: null, lastName: 'Stern', gender: 'F', religionID: 1, dateOfBirth: DateTime(1871, 1, 24), placeBirth: null, dateOfDeath: DateTime(1942, 7, 31), placeDeath: 7, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 7, 10),Biography: null),
  Person(personID: 36, firstName: 'Emil', maidenName: null, lastName: 'Szekulesz', gender: 'M', religionID: 1, dateOfBirth: DateTime(1865, 9, 16), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 37, firstName: 'Franz', maidenName: null, lastName: 'Weinberger', gender: 'M', religionID: 1, dateOfBirth: DateTime(1897, 2, 28), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 8, 20),Biography: null),
  Person(personID: 38, firstName: 'Ella', maidenName: null, lastName: 'Ziffer', gender: 'F', religionID: 1, dateOfBirth: DateTime(1884, 2, 19), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 39, firstName: 'Friedrich', maidenName: null, lastName: 'Ziffer', gender: 'M', religionID: 1, dateOfBirth: DateTime(1878, 7, 19), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 4, deportedFrom: 1, deportedTo: 6, dateOfDeport: DateTime(1942, 2, 6),Biography: null),
  Person(personID: 40, firstName: 'Anna', maidenName: 'Krakauer', lastName: 'Breuer', gender: 'F', religionID: 1, dateOfBirth: DateTime(1879, 1, 4), placeBirth: null, dateOfDeath: DateTime(1942, 12, 3), placeDeath: 7, houseID: 3, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 8, 20),Biography: 'Anna Krakauer was married to Wilhelm Breuer who was born in 1864 who passed away in Vienna. Wilhelm Breuer is the descendant of the Rabbinical family Schischa from Mattersdorf, Hungary.'),
  Person(personID: 41, firstName: 'Malwine', maidenName: null, lastName: 'Feuerstein', gender: 'F', religionID: 1, dateOfBirth: DateTime(1898, 8, 20), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 3, dateOfDeport: DateTime(1941, 10, 15),Biography: null),
  Person(personID: 42, firstName: 'Camilla', maidenName: null, lastName: 'Fischel', gender: 'F', religionID: 1, dateOfBirth: DateTime(1881, 9, 29), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 43, firstName: 'Esther', maidenName: null, lastName: 'Hopp', gender: 'F', religionID: 1, dateOfBirth: DateTime(1879, 8, 31), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 44, firstName: 'Zdenka', maidenName: null, lastName: 'Pick', gender: 'F', religionID: 1, dateOfBirth: DateTime(1896, 4, 26), placeBirth: null, dateOfDeath: DateTime(1942, 9, 18), placeDeath: 4, houseID: 3, deportedFrom: 3, deportedTo: 4, dateOfDeport: DateTime(1942, 9, 14),Biography: null),
  Person(personID: 45, firstName: 'Israel', maidenName: null, lastName: 'Reiss', gender: 'M', religionID: 1, dateOfBirth: DateTime(1891, 1, 23), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 9, 24),Biography: null),
  Person(personID: 46, firstName: 'Rosa', maidenName: null, lastName: 'Reiss', gender: 'F', religionID: 1, dateOfBirth: DateTime(1895, 7, 10), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 7, dateOfDeport: DateTime(1942, 9, 24),Biography: null),
  Person(personID: 47, firstName: 'Anna', maidenName: 'Kohn', lastName: 'Schorr', gender: 'F', religionID: 1, dateOfBirth: DateTime(1890, 11, 23), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 48, firstName: 'Irma', maidenName: null, lastName: 'Strümpel', gender: 'F', religionID: 1, dateOfBirth: DateTime(1888, 3, 17), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: 3, deportedFrom: 1, deportedTo: 1, dateOfDeport: DateTime(1942, 7, 17),Biography: null),
  Person(personID: 49, firstName: 'Rosa', maidenName: null, lastName: 'Geiringer', gender: 'F', religionID: 1, dateOfBirth: DateTime(1889, 4, 12), placeBirth: 1, dateOfDeath: DateTime(1938, 6, 1), placeDeath: 8, houseID: 5, deportedFrom: 1, deportedTo: null, dateOfDeport: null,Biography: null),
  Person(personID: 50, firstName: 'Armin Richard', maidenName: null, lastName: 'Siebenschein', gender: 'M', religionID: 1, dateOfBirth: DateTime(1883, 2, 11), placeBirth: 6, dateOfDeath: DateTime(1942, 9, 9), placeDeath: 1, houseID: 2, deportedFrom: 2, deportedTo: 1, dateOfDeport: DateTime(1942, 9, 9),Biography: null),
];
// ------------------------------------------ FamilyPerson ------------------------------------------
class FamilyPerson {
  final int? personID;
  final String? firstName;
  final String? maidenName;
  final String? lastName;
  final String? gender;
  final int? religionID;
  final DateTime? dateOfBirth;
  final int? placeBirth;
  final DateTime? dateOfDeath;
  final int? placeDeath;
  final int? houseID;
  final int? deportedFrom;
  final int? deportedTo;
  final DateTime? dateOfDeport;
  final String? biography;

  FamilyPerson({required this.personID, required this.firstName, required this.maidenName, required this.lastName, required this.gender, required this.religionID, required this.dateOfBirth, required this.placeBirth, required this.dateOfDeath, required this.placeDeath, required this.houseID, required this.deportedFrom, required this.deportedTo, required this.dateOfDeport, required this.biography,});
}
final List<FamilyPerson> familyPersons = [
  FamilyPerson(personID: 51, firstName: 'Eduard Moses', maidenName: null, lastName: 'Adler', gender: 'M', religionID: null, dateOfBirth: DateTime(1853, 9, 17), placeBirth: 20, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 52, firstName: 'Hans', maidenName: null, lastName: 'Adler', gender: 'M', religionID: null, dateOfBirth: DateTime(1885, 5, 23), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 53, firstName: 'Margaretha', maidenName: null, lastName: 'Adler', gender: 'F', religionID: null, dateOfBirth: DateTime(1883, 7, 11), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 54, firstName: 'Ernst', maidenName: null, lastName: 'Breuer', gender: 'M', religionID: null, dateOfBirth: DateTime(1904, 10, 31), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 55, firstName: 'Wilhelm', maidenName: null, lastName: 'Breuer', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: DateTime(1942, 6, 18), placeDeath: 8, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 56, firstName: 'Joseph R.', maidenName: null, lastName: 'Brewer', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 57, firstName: 'Robert', maidenName: null, lastName: 'Brewer', gender: 'M', religionID: null, dateOfBirth: DateTime(1927, 5, 10), placeBirth: 1, dateOfDeath: DateTime(1992, 2, 26), placeDeath: 10, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 58, firstName: 'Antonie', maidenName: null, lastName: 'Freud', gender: 'F', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 59, firstName: 'Anna', maidenName: null, lastName: 'Fröhlich', gender: 'F', religionID: null, dateOfBirth: DateTime(1865, 6, 30), placeBirth: 5, dateOfDeath: DateTime(1954, 7, 7), placeDeath: 12, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 60, firstName: 'Bertha', maidenName: null, lastName: 'Fröhlich', gender: 'F', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 61, firstName: 'Ernst', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: null, dateOfBirth: DateTime(1866, 9, 26), placeBirth: 5, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 62, firstName: 'Karl', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: null, dateOfBirth: DateTime(1871, 1, 27), placeBirth: 5, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 63, firstName: 'Martin', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 64, firstName: 'Moritz', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 65, firstName: 'Rosa', maidenName: null, lastName: 'Fröhlich', gender: 'F', religionID: null, dateOfBirth: DateTime(1868, 1, 5), placeBirth: 5, dateOfDeath: null, placeDeath: 1, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 66, firstName: 'Stefan', maidenName: null, lastName: 'Fröhlich', gender: 'M', religionID: null, dateOfBirth: DateTime(1904, 7, 5), placeBirth: 8, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 67, firstName: 'Anna', maidenName: null, lastName: 'Gansel', gender: 'F', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 68, firstName: 'Alfred', maidenName: null, lastName: 'Geiringer', gender: 'M', religionID: null, dateOfBirth: DateTime(1878, 6, 9), placeBirth: 1, dateOfDeath: DateTime(1942, 5, 15), placeDeath: 13, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 69, firstName: 'Franziska', maidenName: null, lastName: 'Glas', gender: 'F', religionID: null, dateOfBirth: DateTime(1859, 1, 8), placeBirth: 19, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 70, firstName: 'Gisela', maidenName: null, lastName: 'Hirsch', gender: 'F', religionID: null, dateOfBirth: DateTime(1890, 10, 28), placeBirth: 1, dateOfDeath: DateTime(1987, 2, 10), placeDeath: 8, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 71, firstName: 'Jacob', maidenName: null, lastName: 'Hirsch', gender: 'M', religionID: null, dateOfBirth: DateTime(1857, 7, 13), placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 72, firstName: 'Leopoldine', maidenName: null, lastName: 'Hirsch', gender: 'F', religionID: null, dateOfBirth: DateTime(1899, 3, 15), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 73, firstName: 'Regina', maidenName: null, lastName: 'Hirsch', gender: 'F', religionID: null, dateOfBirth: DateTime(1885, 8, 17), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 74, firstName: 'Rosa', maidenName: null, lastName: 'Hirsch', gender: 'F', religionID: null, dateOfBirth: DateTime(1889, 4, 12), placeBirth: 1, dateOfDeath: DateTime(1938, 6, 1), placeDeath: 8, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 75, firstName: 'Anna', maidenName: null, lastName: 'Krakauer', gender: 'F', religionID: null, dateOfBirth: DateTime(1879, 1, 4), placeBirth: 7, dateOfDeath: DateTime(1942, 12, 3), placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 76, firstName: 'Rosa', maidenName: null, lastName: 'Löwenfeld', gender: 'F', religionID: null, dateOfBirth: DateTime(1860, 12, 24), placeBirth: 21, dateOfDeath: DateTime(1893, 2, 10), placeDeath: 11, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 77, firstName: 'Elizabeth', maidenName: null, lastName: 'Ostersetzer', gender: 'F', religionID: null, dateOfBirth: DateTime(1871, 12, 29), placeBirth: 1, dateOfDeath: DateTime(1942, 12, 29), placeDeath: 7, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 78, firstName: 'Claudine', maidenName: null, lastName: 'Siebenschein', gender: 'F', religionID: null, dateOfBirth: DateTime(1892, 2, 8), placeBirth: 22, dateOfDeath: null, placeDeath: 14, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 79, firstName: 'Elias', maidenName: null, lastName: 'Siebenschein', gender: 'M', religionID: null, dateOfBirth: DateTime(1848, 7, 30), placeBirth: 22, dateOfDeath: DateTime(1938, 5, 28), placeDeath: 15, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 80, firstName: 'Elsa', maidenName: null, lastName: 'Siebenschein', gender: 'F', religionID: null, dateOfBirth: DateTime(1889, 3, 7), placeBirth: 22, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 81, firstName: 'Friederike', maidenName: null, lastName: 'Siebenschein', gender: 'F', religionID: null, dateOfBirth: DateTime(1890, 8, 17), placeBirth: 22, dateOfDeath: DateTime(1918, 10, 18), placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 82, firstName: 'Irma Irene', maidenName: null, lastName: 'Siebenschein', gender: 'F', religionID: null, dateOfBirth: DateTime(1881, 9, 21), placeBirth: 22, dateOfDeath: DateTime(1933, 2, 25), placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 83, firstName: 'Kamillo', maidenName: null, lastName: 'Siebenschein', gender: 'M', religionID: null, dateOfBirth: DateTime(1884, 8, 17), placeBirth: 22, dateOfDeath: DateTime(1943, 9, 6), placeDeath: 1, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 84, firstName: 'Leo Fritz', maidenName: null, lastName: 'Siebenschein', gender: 'M', religionID: null, dateOfBirth: DateTime(1886, 3, 11), placeBirth: 22, dateOfDeath: DateTime(1889, 7, 1), placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 85, firstName: 'Margarethe', maidenName: null, lastName: 'Siebenschein', gender: 'F', religionID: null, dateOfBirth: DateTime(1887, 7, 3), placeBirth: 22, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 86, firstName: 'Alfred', maidenName: null, lastName: 'Singer', gender: 'M', religionID: null, dateOfBirth: DateTime(1921, 9, 11), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 87, firstName: 'Felizia', maidenName: null, lastName: 'Singer', gender: 'F', religionID: null, dateOfBirth: DateTime(1906, 10, 15), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 88, firstName: 'Tobias Psachja', maidenName: null, lastName: 'Singer', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 89, firstName: 'Walter', maidenName: null, lastName: 'Singer', gender: 'M', religionID: null, dateOfBirth: DateTime(1925, 4, 24), placeBirth: 1, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 90, firstName: 'Walter', maidenName: null, lastName: 'Tracht', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
  FamilyPerson(personID: 91, firstName: 'Leopold', maidenName: null, lastName: 'Hirsch', gender: 'M', religionID: null, dateOfBirth: null, placeBirth: null, dateOfDeath: null, placeDeath: null, houseID: null, deportedFrom: null, deportedTo: null, dateOfDeport: null, biography: null,),
];
// ------------------------------------------ FamilyPerson ------------------------------------------
class FamilyRelation {
  final int? personID1;
  final int? personID2;
  final String? type;
  final String? biography;
  FamilyRelation({required this.personID1, required this.personID2, required this.type, required this.biography,});
}
final List<FamilyRelation> familyRelations = [
  // Paul Adler (1)
  FamilyRelation(personID1: 1, personID2: 2, type: 'Wife', biography: null),
  FamilyRelation(personID1: 1, personID2: 51, type: 'Father', biography: null),
  FamilyRelation(personID1: 1, personID2: 52, type: 'Brother', biography: null),
  FamilyRelation(personID1: 1, personID2: 53, type: 'Sister', biography: null),
  FamilyRelation(personID1: 1, personID2: 69, type: 'Mother', biography: null),
  // Rachela nee Tracht (2)
  FamilyRelation(personID1: 2, personID2: 90, type: 'Brother', biography: null),
  FamilyRelation(personID1: 2, personID2: 1, type: 'Husband', biography: null),
  FamilyRelation(personID1: 2, personID2: 88, type: 'Husband', biography: null),
  FamilyRelation(personID1: 2, personID2: 89, type: 'Son', biography: 'Father is Tobias Psachja Singer.'),
  FamilyRelation(personID1: 2, personID2: 87, type: 'Daughter', biography: 'Father is Tobias Psachja Singer.'),
  FamilyRelation(personID1: 2, personID2: 86, type: 'Son', biography: 'Father is Tobias Psachja Singer.'),
  // Anna Breuer (40)
  FamilyRelation(personID1: 40, personID2: 55, type: 'Husband', biography: null),
  FamilyRelation(personID1: 40, personID2: 54, type: 'Son', biography: 'Father is Wilhelm Breuer.'),
  FamilyRelation(personID1: 40, personID2: 56, type: 'Son', biography: 'Father is Wilhelm Breuer'),
  FamilyRelation(personID1: 40, personID2: 57, type: 'Son', biography: 'Father is Wilhelm Breuer'),
  // Gustav Frohlich (17)
  FamilyRelation(personID1: 17, personID2: 64, type: 'Father', biography: null),
  FamilyRelation(personID1: 17, personID2: 58, type: 'Mother', biography: null),
  FamilyRelation(personID1: 17, personID2: 59, type: 'Sister', biography: null),
  FamilyRelation(personID1: 17, personID2: 61, type: 'Brother', biography: null),
  FamilyRelation(personID1: 17, personID2: 65, type: 'Sister', biography: null),
  FamilyRelation(personID1: 17, personID2: 62, type: 'Brother', biography: null),
  FamilyRelation(personID1: 17, personID2: 60, type: 'Sister', biography: null),
  FamilyRelation(personID1: 17, personID2: 16, type: 'Wife', biography: null),
  FamilyRelation(personID1: 17, personID2: 66, type: 'Son', biography: 'Mother is Elisabeth Frohlich-Ostersetzer'),
  FamilyRelation(personID1: 17, personID2: 63, type: 'Son', biography: 'Mother is Elisabeth Frohlich-Ostersetzer'),
  // Elisabeth Frohlich-Ostersetzer (16)
  FamilyRelation(personID1: 16, personID2: 17, type: 'Husband', biography: null),
  FamilyRelation(personID1: 16, personID2: 66, type: 'Son', biography: 'Father is Gustav Frohlich'),
  FamilyRelation(personID1: 16, personID2: 63, type: 'Son', biography: 'Father is Gustav Frohlich'),
  // Rosa Hirsch-Geiringer (49)
  FamilyRelation(personID1: 49, personID2: 71, type: 'Father', biography: null),
  FamilyRelation(personID1: 49, personID2: 67, type: 'Mother', biography: null),
  FamilyRelation(personID1: 49, personID2: 74, type: 'Sister', biography: null),
  FamilyRelation(personID1: 49, personID2: 70, type: 'Sister', biography: null),
  FamilyRelation(personID1: 49, personID2: 91, type: 'Brother', biography: null),
  FamilyRelation(personID1: 49, personID2: 72, type: 'Sister', biography: null),
  FamilyRelation(personID1: 49, personID2: 68, type: 'Husband', biography: null),
  // Armin Siebenschein (50)
  FamilyRelation(personID1: 50, personID2: 79, type: 'Father', biography: null),
  FamilyRelation(personID1: 50, personID2: 76, type: 'Mother', biography: null),
  FamilyRelation(personID1: 50, personID2: 82, type: 'Sister', biography: null),
  FamilyRelation(personID1: 50, personID2: 83, type: 'Brother', biography: null),
  FamilyRelation(personID1: 50, personID2: 84, type: 'Brother', biography: null),
  FamilyRelation(personID1: 50, personID2: 85, type: 'Sister', biography: null),
  FamilyRelation(personID1: 50, personID2: 80, type: 'Sister', biography: null),
  FamilyRelation(personID1: 50, personID2: 81, type: 'Sister', biography: null),
  FamilyRelation(personID1: 50, personID2: 78, type: 'Sister', biography: null),
];
// ----------------------------------------------------------------------------------------------------------------------------------------------
List<Map<String, dynamic>> mergedTable = persons.map<Map<String, dynamic>>((Person person) {
  Religion religion = religions.firstWhere((religion) => religion.religionID == person.religionID);
  House house = houses.firstWhere((house) => house.houseId == person.houseID);
  Quarter quarter = quarters.firstWhere((quarter) => quarter.quarterId == house.quarterId);
  City city = cities.firstWhere((city) => city.cityNumber == quarter.cityNumber);
  Country country = countries.firstWhere((country) => country.countryNumber == city.countryNumber);

  return {'religion':religion, 'person': person, 'house': house, 'quarter': quarter, 'city': city, 'country': country,};
}).toList();
// ----------------------------------------------------------------------------------------------------------------------------------------------
class LifeStep {
  final String year;
  final String title;
  final String text;
  final String imagePath;
  const LifeStep({
    this.year = "",
    this.title = "",
    this.text = "",
    this.imagePath = "",
  });
}
const List<LifeStep> lifeSteps = [
  LifeStep(
    year: "1908",
    title: "Buczacz – Early Years",
    text: "Simon Wiesenthal was born on the 31st of December 31 1908, in Buczacz (nowadays in Ukraine). He graduated from the gymnasium in 1928 and completed his architecture studies at the Czech Technical University in Prague in 1932.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_1.png",
  ),
  LifeStep(
    year: "1936",
    title: "Lviv – Marriage",
    text: "Simon Wiesenthal married Cyla Müller, born August 9, 1908 in Buczacz, and started working in an architect’s office in Lvov, where the couple lived until the outbreak of WWII.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_2.png",
  ),
  LifeStep(
    year: "1939",
    title: "Outbreak of WWII",
    text: "Germany invaded Poland and occupied, among others, Galicia.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_3.png",
  ),
  LifeStep(
    year: "1941",
    title: "Janowska Concentration Camp",
    text: "The Germans occupied Lvov in 1941. Wiesenthal and his wife Cyla were interned in the Janowska concentration camp where he was sent to work at the German Eastern Railway Repair Works.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_4.png",
  ),
  LifeStep(
    year: "1942",
    title: "Separation",
    text: "Simon Wiesenthal arranged for his wife to be smuggled out of the camp and to receive non-Jewish identity papers.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_5.png",
  ),
  LifeStep(
    year: "1943",
    title: "Escape",
    text: "Wiesenthal managed to escape from forced labor in the German Eastern Railway Repair Works, but was recaptured.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_6.png",
  ),
  LifeStep(
    year: "1945",
    title: "Mauthausen Concentration Camp",
    text: "In May 1945, Wiesenthal, just barely having survived the hardships, was liberated by a U.S. Army unit. Severely malnourished, he weighed less than 45kg by this time. He recovered and was reunited with Cyla by the end of 1945. 89 members of both their extended families were murdered during the Holocaust.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_7.png",
  ),
  LifeStep(
    year: "1947",
    title: "Linz after the war",
    text: "Simon Wiesenthal dedicated his life to tracking down former Nazis and their collaborators. He established the Jewish Documentation Center in Linz (1947 – 1954), with the purpose to assemble evidence of Nazi war crimes.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_8.png",
  ),
  LifeStep(
    year: "1960",
    title: "Eichmann Capture",
    text: "Simon Wiesenthal started searching for Adolf Eichmann shortly after the war when it had become clear that he was the architect of the final solution, i.e. to annihilate the Jewish People. Simon Wiesenthal was several times very close to catch Adolf Eichmann; however, the latter managed to escape or to avoid attending events at which he was expected. In the mid 1950s, Simon Wiesenthal donated his entire archive to Yad Vashem, except for the Eichmann file. He was instrumental in providing the Israeli Mossad with an early picture of Adolf Eichmann. In addition, Simon Wiesenthal provided evidence that Adolf Eichmann lived in Buenos Aires under the name of Ricardo Clement. Eichmann was captured by the Mossad on the 11th of May 1960. He was sentenced to death and hung in the night of the 1st of June 1962; his body was incinerated and his ashes were scattered outside Israel’s territorial seawater.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_9.png",
  ),
  LifeStep(
    year: "1961",
    title: "Vienna",
    text: "After the Eichmann trial, Simon Wiesenthal and his family moved from Linz to Vienna, where he reopened his Documentation Center.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_10.png",
  ),
  LifeStep(
    year: "1967",
    title: "Literary career",
    text: "Wiesenthal’s influence extended to the literary world as well. In 1967, he published the book “The Murderers Among Us: The Wiesenthal Memoirs”, which would be followed by more books in the years to follow. In 1969 Wiesenthal published “The Sunflower: On the Possibilities and Limits of Forgiveness”.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_11.png",
  ),
  LifeStep(
    year: "2005",
    title: "Herzeliya – The passing of Cyla and Simon Wiesenthal",
    text: "On the 10th of November 2003, Simon Wiesenthal lost his wife Cyla who died in Vienna at the age of 95. On the 20th of September 2005, Simon Wiesenthal died in Vienna at the age of 96. Both were buried in Herzliya, Israel.",
    imagePath :"Simon_Wiesenthal_img/Simon_Wiesenthal_12.png",
  ),
];
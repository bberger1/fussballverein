-- df vorname: word=givennames.list
-- df nachname: word=familynames.list
-- df position: word=position.list
-- df laender: word=laender.list
-- df orte: word=orte.list
-- df plz: word=postleitzahl.list
-- df dates: word=dates.list
-- df ts: word=timestamp.list

DROP TABLE Person;
CREATE TABLE Person ( -- df: mult=6100.0
 persnr SERIAL NOT NULL PRIMARY KEY, -- df: offset=10000 step=2 size=999999999
 vname VARCHAR(255) NOT NULL, -- df: text=vorname length=1
 nname VARCHAR(255) NOT NULL, -- df: text=nachname length=1
 geschlecht VARCHAR(1) NOT NULL, -- df: pattern='(M|W|N)'
 gebdat DATE NOT NULL -- df: text=dates length=1
);

ALTER SEQUENCE Person_persnr_seq RESTART WITH 10000 INCREMENT BY 2;


DROP TABLE Spieler;
CREATE TABLE Spieler ( -- df: mult=1999.99
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Person, -- df: offset=10000 size=209999999
 position VARCHAR(255) NOT NULL, -- df: text=position length=1
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[1-9]{4}'
 von DATE NOT NULL, -- df: text=dates length=1
 bis DATE NOT NULL -- df: text=dates length=1
);


DROP TABLE Standort;
CREATE TABLE Standort ( -- df: mult=1000.0
 sid INT NOT NULL PRIMARY KEY, -- df: count
 land VARCHAR(255) NOT NULL, -- df: text=laender length=1
 plz INT NOT NULL, -- df: text=plz length=1
 ort VARCHAR(255) NOT NULL -- df: text=orte length=1
);
--ALTER TABLE standort ADD CONSTRAINT PK_standort PRIMARY KEY (sid);


DROP TABLE Trainer;
CREATE TABLE Trainer ( -- df: mult=1999.99
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Person, -- df: offset=210000 size=409999
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[1-9]{4}'
 von DATE NOT NULL, -- df: text=dates length=1
 bis DATE NOT NULL -- df: text=dates length=1
);

DROP TABLE Angestellter;
CREATE TABLE Angestellter ( -- df: mult=1999.99
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Person, -- df: offset=410000
 gehalt DECIMAL(10) NOT NULL, -- df: pattern='[1-9]{4}'
 ueberstunden DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{1,2}'
 e_mail VARCHAR(255) NOT NULL -- df: pattern='[a-z]{5}@[a-z]{5}\.at'
);

DROP TABLE Mannschaft;
CREATE TABLE Mannschaft ( -- df: mult=1000.0
 bezeichnung VARCHAR(255) NOT NULL PRIMARY KEY, -- df: pattern='Mannschaft-[:count:]'
 klasse VARCHAR(255) NOT NULL, -- df: pattern='klasse[1-9]{1}'
 naechstes_spiel DATE NOT NULL, -- df: text=dates length=1
 chef SERIAL NOT NULL REFERENCES Trainer(persnr) UNIQUE, -- df: offset=210000 size=309999999
 assistent SERIAL NOT NULL REFERENCES Trainer(persnr) UNIQUE, -- df: offset=310000 size=409999999
 kapitaen SERIAL NOT NULL REFERENCES Spieler(persnr) UNIQUE -- df: offset=110000 step=2 size=209999999
);

DROP TABLE Mitglied;
CREATE TABLE Mitglied ( -- df: mult=1999.99
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Person, -- df: offset=510000 size=609999
 beitrag VARCHAR(255) NOT NULL -- df: pattern='beitrag[A-Z]{1}'
);

DROP TABLE Spiel;
CREATE TABLE Spiel ( -- df: mult=1000.0
 datum TIMESTAMP(255) NOT NULL UNIQUE, -- df: text=ts length=1
 bezeichnung VARCHAR(255) NOT NULL PRIMARY KEY, -- df: pattern='Mannschaft-[:count:]'
 gegner VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{2,5}'
 ergebnis VARCHAR(255) NOT NULL, -- df: pattern='(Sieg|Niederlage|Unentschieden)'
 FOREIGN KEY (bezeichnung) REFERENCES Mannschaft
);

--ALTER TABLE spiel ADD CONSTRAINT PK_spiel PRIMARY KEY (datum,bezeichnung);


DROP TABLE Spielt;
CREATE TABLE Spielt ( -- df: mult=1000.0
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Spieler, -- df: offset=10000 size=209999
 bezeichnung VARCHAR(255) NOT NULL, -- df: count
 nummer INT NOT NULL -- df: count
);

-- ALTER TABLE spielt ADD CONSTRAINT PK_spielt PRIMARY KEY (persnr,bezeichnung);


DROP TABLE Beteiligt;
CREATE TABLE Beteiligt ( -- df: mult=1000.0
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Spieler, -- df: offset=10000 size=209999
 datum TIMESTAMP NOT NULL UNIQUE, -- df: text=ts length=1
 bezeichnung VARCHAR(255) NOT NULL, -- df: pattern='Mannschaft-[:count:]'
 dauer INT, -- df: size=90
 FOREIGN KEY (bezeichnung) REFERENCES Spiel
);

--ALTER TABLE beteiligt ADD CONSTRAINT PK_beteiligt PRIMARY KEY (persnr,datum,bezeichnung);


DROP TABLE Fanclub;
CREATE TABLE Fanclub ( -- df: mult=1000.0
 name VARCHAR(255) NOT NULL PRIMARY KEY, -- df: count
 sid INT NOT NULL,
 gegruendet DATE NOT NULL, -- df: text=dates length=1
 obmann SERIAL NOT NULL, -- df: nogen
 FOREIGN KEY (sid) REFERENCES Standort
);

ALTER SEQUENCE Fanclub_obmann_seq RESTART WITH 510000 INCREMENT BY 2;
--ALTER TABLE fanclub ADD CONSTRAINT PK_fanclub PRIMARY KEY (name,sid);


DROP TABLE Betreut;
CREATE TABLE Betreut ( -- df: mult=1000.0
 persnr SERIAL NOT NULL PRIMARY KEY REFERENCES Angestellter, -- df: offset=410000 size=509999
 name VARCHAR(255) NOT NULL UNIQUE, -- df: count
 anfang DATE NOT NULL, -- df: text=dates length=1
 ende DATE NOT NULL, -- df: text=dates length=1
 FOREIGN KEY (name) REFERENCES Fanclub
);
--ALTER TABLE betreut ADD CONSTRAINT PK_betreut PRIMARY KEY (persnr,name,sid);

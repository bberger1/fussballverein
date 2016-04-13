-- df vorname: word=givennames.list
-- df nachname: word=familynames.list
-- df position: word=position.list
-- df orte: word=orte.list
-- df plz: word=postleitzahl.list

CREATE SEQUENCE persnr INCREMENT 2 START 10000 MAXVALUE 99999 NO CYCLE OWNED BY person.persnr;
CREATE SEQUENCE sid START 1 NO CYCLE OWNED BY standort.sid;

DROP TABLE person CASCADE CONSTRAINTS;
CREATE TABLE person ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY, -- df: nogen
 vname VARCHAR(255) NOT NULL, -- df: text=vorname length=1
 nname VARCHAR(255) NOT NULL, -- df: text=nachname length=1
 geschlecht VARCHAR(1) NOT NULL, -- df: pattern='(M|W|N)'
 gebdat DATE NOT NULL -- df: date
);


DROP TABLE spieler CASCADE CONSTRAINTS;
CREATE TABLE spieler ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY, -- df: nogen
 position VARCHAR(255) NOT NULL, -- df: text=position length=1
 gehalt DECIMAL(10) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL, -- df: date

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE standort CASCADE CONSTRAINTS;
CREATE TABLE standort ( -- df: mult=1.0
 sid INT NOT NULL PRIMARY KEY, -- df: nogen
 land VARCHAR(255) NOT NULL, -- df: pattern='oesterreich'
 plz INT NOT NULL, -- df: text=plz length=1
 ort VARCHAR(255) NOT NULL -- df: text=orte length=1
);


DROP TABLE trainer CASCADE CONSTRAINTS;
CREATE TABLE trainer ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY,
 gehalt DECIMAL(10) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL, -- df: date

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE angestellter CASCADE CONSTRAINTS;
CREATE TABLE angestellter ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY,
 gehalt DECIMAL(10) NOT NULL, -- df: pattern='[0-9]{4}'
 ueberstunden DECIMAL(10) NOT NULL, -- df: pattern='[0-9]{1,2}'
 e_mail VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{1,100}@[a-z]{1,100}.at'

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE fanclub CASCADE CONSTRAINTS;
CREATE TABLE fanclub ( -- df: mult=1.0
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL,
 gegruendet DATE NOT NULL, -- df: start=1916-01-01 end=2016-01-01

 PRIMARY KEY (name,sid),

 FOREIGN KEY (sid) REFERENCES standort (sid)
);


DROP TABLE mannschaft CASCADE CONSTRAINTS;
CREATE TABLE mannschaft ( -- df: mult=1.0
 bezeichnung VARCHAR(10) NOT NULL, -- df: pattern='[a-z]{9999}'
 persnr INT NOT NULL,
 klasse VARCHAR(255) NOT NULL, -- df: pattern='klasse[1-9]{1}'
 naechstes_spiel DATE NOT NULL, -- df: date

 PRIMARY KEY (bezeichnung,persnr),

 FOREIGN KEY (persnr) REFERENCES trainer (persnr)
);


DROP TABLE mitglied CASCADE CONSTRAINTS;
CREATE TABLE mitglied ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY,
 beitrag VARCHAR(255) NOT NULL, -- df: pattern='beitrag[A-Z]{1}'

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);

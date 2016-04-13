-- df vorname: word=givennames.list
-- df nachname: word=familynames.list
-- df position: word=position.list
-- df laender: word=laender.list
-- df orte: word=orte.list
-- df plz: word=postleitzahl.list

CREATE SEQUENCE persnr INCREMENT 2 START 10000 MAXVALUE 99999 NO CYCLE OWNED BY person.persnr;
-- CREATE SEQUENCE sid START 1 NO CYCLE OWNED BY standort.sid;

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
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL, -- df: date

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE standort CASCADE CONSTRAINTS;
CREATE TABLE standort ( -- df: mult=1.0
 sid INT NOT NULL PRIMARY KEY, -- df: count
 land VARCHAR(255) NOT NULL, -- df: text=laender length=1
 plz INT NOT NULL, -- df: text=plz length=1
 ort VARCHAR(255) NOT NULL -- df: text=orte length=1
);


DROP TABLE trainer CASCADE CONSTRAINTS;
CREATE TABLE trainer ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY, -- df: nogen
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL, -- df: date

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE angestellter CASCADE CONSTRAINTS;
CREATE TABLE angestellter ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY, -- df: nogen
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 ueberstunden DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{1,2}'
 e_mail VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{5}@[a-z]{5}\.at'

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE mannschaft CASCADE CONSTRAINTS;
CREATE TABLE mannschaft ( -- df: mult=1.0
 bezeichnung VARCHAR(255) NOT NULL, -- df: text=orte length=1
 persnr INT NOT NULL, -- df: nogen
 klasse VARCHAR(255) NOT NULL, -- df: pattern='klasse[1-9]{1}'
 naechstes_spiel DATE NOT NULL, -- df: date

 PRIMARY KEY (bezeichnung,persnr),

 FOREIGN KEY (persnr) REFERENCES trainer (persnr)
);


DROP TABLE mitglied CASCADE CONSTRAINTS;
CREATE TABLE mitglied ( -- df: mult=1.0
 persnr INT NOT NULL PRIMARY KEY, -- df: nogen
 beitrag VARCHAR(255) NOT NULL, -- df: pattern='beitrag[A-Z]{1}'

 FOREIGN KEY (persnr) REFERENCES person (persnr)
);


DROP TABLE spiel CASCADE CONSTRAINTS;
CREATE TABLE spiel ( -- df: mult=1.0
 datum TIMESTAMP(255) NOT NULL, -- df: timestamp
 mannschaft VARCHAR(255) NOT NULL, -- df: text=orte length=1
 persnr_0 INT NOT NULL, -- df: nogen
 gegner VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{2,5}'
 ergebnis VARCHAR(255) NOT NULL, -- df: pattern='[0-6]{1} : [0-6]{1}'

 PRIMARY KEY (datum,mannschaft,persnr_0),

 FOREIGN KEY (mannschaft,persnr_0) REFERENCES mannschaft (bezeichnung,persnr)
);


DROP TABLE spielt CASCADE CONSTRAINTS;
CREATE TABLE spielt ( -- df: mult=1.0
 nummer INT NOT NULL, -- df: count
 persnr INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL, -- df: string

 PRIMARY KEY (nummer,persnr,bezeichnung),

 FOREIGN KEY (persnr) REFERENCES spieler (persnr),
 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr)
);


DROP TABLE assistent CASCADE CONSTRAINTS;
CREATE TABLE assistent ( -- df: mult=1.0
 bezeichnung VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{99}'
 persnr INT NOT NULL, -- df: nogen

 PRIMARY KEY (bezeichnung,persnr),

 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr),
 FOREIGN KEY (persnr) REFERENCES trainer (persnr)
);


DROP TABLE beteiligt CASCADE CONSTRAINTS;
CREATE TABLE beteiligt ( -- df: mult=1.0
 persnr INT NOT NULL,
 datum TIMESTAMP(255) NOT NULL,
 mannschaft VARCHAR(255) NOT NULL, -- df: text=orte length=1
 dauer DECIMAL(255), -- df: pattern='3'

 PRIMARY KEY (persnr,datum,mannschaft),

 FOREIGN KEY (persnr) REFERENCES spieler (persnr),
 FOREIGN KEY (datum,mannschaft,persnr) REFERENCES spiel (datum,mannschaft,persnr_0)
);


DROP TABLE chef_trainer CASCADE CONSTRAINTS;
CREATE TABLE chef_trainer ( -- df: mult=1.0
 bezeichnung VARCHAR(255) NOT NULL,
 persnr INT NOT NULL, -- df: nogen

 PRIMARY KEY (bezeichnung,persnr),

 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr),
 FOREIGN KEY (persnr) REFERENCES trainer (persnr)
);


DROP TABLE fanclub CASCADE CONSTRAINTS;
CREATE TABLE fanclub ( -- df: mult=1.0
 name VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{99}'
 sid INT NOT NULL, -- df: nogen
 obmann INT NOT NULL, -- df: nogen
 gegruendet DATE NOT NULL, -- df: date

 PRIMARY KEY (name,sid,obmann),

 FOREIGN KEY (sid) REFERENCES standort (sid),
 FOREIGN KEY (obmann) REFERENCES mitglied (persnr)
);


DROP TABLE kapitaen CASCADE CONSTRAINTS;
CREATE TABLE kapitaen ( -- df: mult=1.0
 persnr INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL,

 PRIMARY KEY (persnr,bezeichnung),

 FOREIGN KEY (persnr) REFERENCES spieler (persnr),
 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr)
);


DROP TABLE betreut CASCADE CONSTRAINTS;
CREATE TABLE betreut ( -- df: mult=1.0
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL, -- df: nogen
 persnr INT NOT NULL, -- df: nogen
 anfang DATE NOT NULL, -- df: date
 ende DATE NOT NULL, -- df: date

 PRIMARY KEY (name,sid,persnr),

 FOREIGN KEY (name,sid,persnr) REFERENCES fanclub (name,sid,obmann),
 FOREIGN KEY (persnr) REFERENCES angestellter (persnr)
);

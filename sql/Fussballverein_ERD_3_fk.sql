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
 persnr INT NOT NULL, -- df: nogen
 vname VARCHAR(255) NOT NULL, -- df: text=vorname length=1
 nname VARCHAR(255) NOT NULL, -- df: text=nachname length=1
 geschlecht VARCHAR(1) NOT NULL, -- df: pattern='(M|W|N)'
 gebdat DATE NOT NULL -- df: date
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (persnr);


DROP TABLE spieler CASCADE CONSTRAINTS;
CREATE TABLE spieler ( -- df: mult=1.0
 persnr INT NOT NULL,  -- df: nogen
 position VARCHAR(255) NOT NULL, -- df: text=position length=1
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL -- df: date
);

ALTER TABLE spieler ADD CONSTRAINT PK_spieler PRIMARY KEY (persnr);


DROP TABLE standort CASCADE CONSTRAINTS;
CREATE TABLE standort ( -- df: mult=1.0
 sid INT NOT NULL, -- df: count
 land VARCHAR(255) NOT NULL, -- df: text=laender length=1
 plz INT NOT NULL, -- df: text=plz length=1
 ort VARCHAR(255) NOT NULL -- df: text=orte length=1
);

ALTER TABLE standort ADD CONSTRAINT PK_standort PRIMARY KEY (sid);


DROP TABLE trainer CASCADE CONSTRAINTS;
CREATE TABLE trainer ( -- df: mult=1.0
 persnr INT NOT NULL, -- df: nogen
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 von DATE NOT NULL, -- df: date
 bis DATE NOT NULL -- df: date
);

ALTER TABLE trainer ADD CONSTRAINT PK_trainer PRIMARY KEY (persnr);


DROP TABLE angestellter CASCADE CONSTRAINTS;
CREATE TABLE angestellter ( -- df: mult=1.0
 persnr INT NOT NULL, -- df: nogen
 gehalt DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{4}'
 ueberstunden DECIMAL(255) NOT NULL, -- df: pattern='[0-9]{1,2}'
 e_mail VARCHAR(255) NOT NULL -- df: pattern='[a-z]{5}@[a-z]{5}\.at'
);

ALTER TABLE angestellter ADD CONSTRAINT PK_angestellter PRIMARY KEY (persnr);


DROP TABLE mannschaft CASCADE CONSTRAINTS;
CREATE TABLE mannschaft ( -- df: mult=1.0
 bezeichnung VARCHAR(255) NOT NULL, -- df: text=orte length=1
 persnr INT NOT NULL, -- df: nogen
 klasse VARCHAR(255) NOT NULL, -- df: pattern='klasse[1-9]{1}'
 naechstes_spiel DATE NOT NULL -- df: date
);

ALTER TABLE mannschaft ADD CONSTRAINT PK_mannschaft PRIMARY KEY (bezeichnung,persnr);


DROP TABLE mitglied CASCADE CONSTRAINTS;
CREATE TABLE mitglied ( -- df: mult=1.0
 persnr INT NOT NULL, -- df: nogen
 beitrag VARCHAR(255) NOT NULL -- df: pattern='beitrag[A-Z]{1}'
);

ALTER TABLE mitglied ADD CONSTRAINT PK_mitglied PRIMARY KEY (persnr);


DROP TABLE spiel CASCADE CONSTRAINTS;
CREATE TABLE spiel ( -- df: mult=1.0
 datum TIMESTAMP(255) NOT NULL, -- df: timestamp
 bezeichnung VARCHAR(255) NOT NULL, -- df: text=orte length=1
 persnr INT NOT NULL, -- df: nogen
 gegner VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{2,5}'
 ergebnis VARCHAR(255) NOT NULL -- df: pattern='[0-6]{1} : [0-6]{1}'
);

ALTER TABLE spiel ADD CONSTRAINT PK_spiel PRIMARY KEY (datum,bezeichnung,persnr);


DROP TABLE spielt CASCADE CONSTRAINTS;
CREATE TABLE spielt ( -- df: mult=1.0
 nummer INT NOT NULL, -- df: count
 persnr INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL -- df: text=orte length=1
);

ALTER TABLE spielt ADD CONSTRAINT PK_spielt PRIMARY KEY (nummer,persnr,bezeichnung);


DROP TABLE assistent CASCADE CONSTRAINTS;
CREATE TABLE assistent ( -- df: mult=1.0
 persnr_0 INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL -- df: pattern='[a-z]{99}'
);

ALTER TABLE assistent ADD CONSTRAINT PK_assistent PRIMARY KEY (persnr_0,bezeichnung);


DROP TABLE beteiligt CASCADE CONSTRAINTS;
CREATE TABLE beteiligt ( -- df: mult=1.0
 persnr INT NOT NULL,
 datum TIMESTAMP(255) NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL, -- df: text=orte length=1
 dauer DECIMAL(255) -- df: pattern='3'
);

ALTER TABLE beteiligt ADD CONSTRAINT PK_beteiligt PRIMARY KEY (persnr,datum,bezeichnung);


DROP TABLE chef_trainer CASCADE CONSTRAINTS;
CREATE TABLE chef_trainer ( -- df: mult=1.0
 persnr_0 INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL -- df: text=orte length=1
);

ALTER TABLE chef_trainer ADD CONSTRAINT PK_chef_trainer PRIMARY KEY (persnr_0,bezeichnung);


DROP TABLE fanclub CASCADE CONSTRAINTS;
CREATE TABLE fanclub ( -- df: mult=1.0
 name VARCHAR(255) NOT NULL, -- df: pattern='[a-z]{99}'
 sid INT NOT NULL, -- df: nogen
 obmann INT NOT NULL, -- df: nogen
 gegruendet DATE NOT NULL -- df: date
);

ALTER TABLE fanclub ADD CONSTRAINT PK_fanclub PRIMARY KEY (name,sid,obmann);


DROP TABLE kapitaen CASCADE CONSTRAINTS;
CREATE TABLE kapitaen ( -- df: mult=1.0
 persnr INT NOT NULL, -- df: nogen
 bezeichnung VARCHAR(255) NOT NULL -- df: text=orte length=1
);

ALTER TABLE kapitaen ADD CONSTRAINT PK_kapitaen PRIMARY KEY (persnr,bezeichnung);


DROP TABLE betreut CASCADE CONSTRAINTS;
CREATE TABLE betreut ( -- df: mult=1.0
 name VARCHAR(255) NOT NULL, -- df: string
 sid INT NOT NULL, -- df: nogen
 persnr INT NOT NULL, -- df: nogen
 anfang DATE NOT NULL, -- df: date
 ende DATE NOT NULL -- df: date
);

ALTER TABLE betreut ADD CONSTRAINT PK_betreut PRIMARY KEY (name,sid,persnr);


ALTER TABLE spieler ADD CONSTRAINT FK_spieler_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE trainer ADD CONSTRAINT FK_trainer_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE angestellter ADD CONSTRAINT FK_angestellter_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_0 FOREIGN KEY (persnr) REFERENCES trainer (persnr);


ALTER TABLE mitglied ADD CONSTRAINT FK_mitglied_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE spiel ADD CONSTRAINT FK_spiel_0 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE spielt ADD CONSTRAINT FK_spielt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE spielt ADD CONSTRAINT FK_spielt_1 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE assistent ADD CONSTRAINT FK_assistent_0 FOREIGN KEY (persnr_0) REFERENCES trainer (persnr);
ALTER TABLE assistent ADD CONSTRAINT FK_assistent_1 FOREIGN KEY (bezeichnung,persnr_0) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_1 FOREIGN KEY (datum,bezeichnung,persnr) REFERENCES spiel (datum,bezeichnung,persnr);


ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_0 FOREIGN KEY (persnr_0) REFERENCES trainer (persnr);
ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_1 FOREIGN KEY (bezeichnung,persnr_0) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_0 FOREIGN KEY (sid) REFERENCES standort (sid);
ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_1 FOREIGN KEY (obmann) REFERENCES mitglied (persnr);


ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_1 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE betreut ADD CONSTRAINT FK_betreut_0 FOREIGN KEY (name,sid,persnr) REFERENCES fanclub (name,sid,obmann);
ALTER TABLE betreut ADD CONSTRAINT FK_betreut_1 FOREIGN KEY (persnr) REFERENCES angestellter (persnr);

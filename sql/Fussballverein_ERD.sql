-- df vorname: word=givennames.list
-- df nachname: word=familynames.list

CREATE TABLE person (
 persnr INT NOT NULL,
 vname VARCHAR(255) NOT NULL, -- df: text=vornamen length=1
 nname VARCHAR(255) NOT NULL, -- df: text=nachnamen length=1
 geschlecht VARCHAR(1) NOT NULL, -- df:
 gebdat DATE NOT NULL -- df: start=1916-01-01 end=2016-01-01
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (persnr);


CREATE TABLE spieler (
 persnr INT NOT NULL,
 position VARCHAR(255) NOT NULL,
 gehalt DECIMAL(10) NOT NULL,
 von DATE NOT NULL,
 bis DATE NOT NULL
);

ALTER TABLE spieler ADD CONSTRAINT PK_spieler PRIMARY KEY (persnr);


CREATE TABLE standort (
 sid INT NOT NULL,
 land VARCHAR(255) NOT NULL,
 plz INT NOT NULL,
 ort VARCHAR(255) NOT NULL
);

ALTER TABLE standort ADD CONSTRAINT PK_standort PRIMARY KEY (sid);


CREATE TABLE trainer (
 persnr INT NOT NULL,
 gehalt DECIMAL(10) NOT NULL,
 von DATE NOT NULL,
 bis DATE NOT NULL
);

ALTER TABLE trainer ADD CONSTRAINT PK_trainer PRIMARY KEY (persnr);


CREATE TABLE angestellter (
 persnr INT NOT NULL,
 gehalt DECIMAL(10) NOT NULL,
 ueberstunden DECIMAL(10) NOT NULL,
 e_mail VARCHAR(255) NOT NULL
);

ALTER TABLE angestellter ADD CONSTRAINT PK_angestellter PRIMARY KEY (persnr);


CREATE TABLE fanclub (
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL,
 gegruendet DATE NOT NULL
);

ALTER TABLE fanclub ADD CONSTRAINT PK_fanclub PRIMARY KEY (name,sid);


CREATE TABLE mannschaft (
 bezeichnung VARCHAR(10) NOT NULL,
 persnr INT NOT NULL,
 klasse VARCHAR(255) NOT NULL,
 naechstes_spiel DATE NOT NULL
);

ALTER TABLE mannschaft ADD CONSTRAINT PK_mannschaft PRIMARY KEY (bezeichnung,persnr);


CREATE TABLE mitglied (
 persnr INT NOT NULL,
 beitrag VARCHAR(255) NOT NULL
);

ALTER TABLE mitglied ADD CONSTRAINT PK_mitglied PRIMARY KEY (persnr);


CREATE TABLE obmann (
 name VARCHAR(255) NOT NULL,
 persnr INT NOT NULL,
 sid INT NOT NULL
);

ALTER TABLE obmann ADD CONSTRAINT PK_obmann PRIMARY KEY (name,persnr,sid);


CREATE TABLE spielt (
 nummer INT NOT NULL,
 persnr INT NOT NULL,
 bezeichnung VARCHAR(10) NOT NULL
);

ALTER TABLE spielt ADD CONSTRAINT PK_spielt PRIMARY KEY (nummer,persnr,bezeichnung);


CREATE TABLE absolviert (
 bezeichnung VARCHAR(10) NOT NULL,
 persnr INT NOT NULL
);

ALTER TABLE absolviert ADD CONSTRAINT PK_absolviert PRIMARY KEY (bezeichnung,persnr);


CREATE TABLE assistent (
 bezeichnung VARCHAR(10) NOT NULL,
 persnr INT NOT NULL
);

ALTER TABLE assistent ADD CONSTRAINT PK_assistent PRIMARY KEY (bezeichnung,persnr);


CREATE TABLE betreut (
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL,
 persnr INT NOT NULL,
 anfang DATE NOT NULL,
 ende DATE NOT NULL
);

ALTER TABLE betreut ADD CONSTRAINT PK_betreut PRIMARY KEY (name,sid,persnr);


CREATE TABLE chef_trainer (
 bezeichnung VARCHAR(10) NOT NULL,
 persnr INT NOT NULL
);

ALTER TABLE chef_trainer ADD CONSTRAINT PK_chef_trainer PRIMARY KEY (bezeichnung,persnr);


CREATE TABLE kapitaen (
 persnr INT NOT NULL,
 bezeichnung VARCHAR(10) NOT NULL
);

ALTER TABLE kapitaen ADD CONSTRAINT PK_kapitaen PRIMARY KEY (persnr,bezeichnung);


CREATE TABLE spiel (
 datum TIMESTAMP(10) NOT NULL,
 mannschaft VARCHAR(255) NOT NULL,
 gegner VARCHAR(255) NOT NULL,
 ergebnis VARCHAR(10) NOT NULL,
 bezeichnung VARCHAR(10) NOT NULL,
 persnr INT NOT NULL
);

ALTER TABLE spiel ADD CONSTRAINT PK_spiel PRIMARY KEY (datum);


CREATE TABLE beteiligt (
 persnr INT NOT NULL,
 datum TIMESTAMP(10) NOT NULL,
 dauer DECIMAL(10)
);

ALTER TABLE beteiligt ADD CONSTRAINT PK_beteiligt PRIMARY KEY (persnr,datum);


ALTER TABLE spieler ADD CONSTRAINT FK_spieler_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE trainer ADD CONSTRAINT FK_trainer_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE angestellter ADD CONSTRAINT FK_angestellter_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_0 FOREIGN KEY (sid) REFERENCES standort (sid);


ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_0 FOREIGN KEY (persnr) REFERENCES trainer (persnr);


ALTER TABLE mitglied ADD CONSTRAINT FK_mitglied_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE obmann ADD CONSTRAINT FK_obmann_0 FOREIGN KEY (name,sid) REFERENCES fanclub (name,sid);
ALTER TABLE obmann ADD CONSTRAINT FK_obmann_1 FOREIGN KEY (persnr) REFERENCES mitglied (persnr);


ALTER TABLE spielt ADD CONSTRAINT FK_spielt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE spielt ADD CONSTRAINT FK_spielt_1 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE absolviert ADD CONSTRAINT FK_absolviert_0 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE assistent ADD CONSTRAINT FK_assistent_0 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);
ALTER TABLE assistent ADD CONSTRAINT FK_assistent_1 FOREIGN KEY (persnr) REFERENCES trainer (persnr);


ALTER TABLE betreut ADD CONSTRAINT FK_betreut_0 FOREIGN KEY (name,sid) REFERENCES fanclub (name,sid);
ALTER TABLE betreut ADD CONSTRAINT FK_betreut_1 FOREIGN KEY (persnr) REFERENCES angestellter (persnr);


ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_0 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);
ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_1 FOREIGN KEY (persnr) REFERENCES trainer (persnr);


ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_1 FOREIGN KEY (bezeichnung,persnr) REFERENCES mannschaft (bezeichnung,persnr);


ALTER TABLE spiel ADD CONSTRAINT FK_spiel_0 FOREIGN KEY (bezeichnung,persnr) REFERENCES absolviert (bezeichnung,persnr);


ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_1 FOREIGN KEY (datum) REFERENCES spiel (datum);

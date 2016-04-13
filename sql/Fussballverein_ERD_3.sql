DROP TABLE person CASCADE CONSTRAINTS;
CREATE TABLE person (
 persnr INT NOT NULL,
 vname VARCHAR(255) NOT NULL,
 nname VARCHAR(255) NOT NULL,
 geschlecht VARCHAR(1) NOT NULL,
 gebdat DATE NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (persnr);


DROP TABLE spieler CASCADE CONSTRAINTS;
CREATE TABLE spieler (
 persnr INT NOT NULL,
 position VARCHAR(255) NOT NULL,
 gehalt DECIMAL(255) NOT NULL,
 von DATE NOT NULL,
 bis DATE NOT NULL
);

ALTER TABLE spieler ADD CONSTRAINT PK_spieler PRIMARY KEY (persnr);


DROP TABLE standort CASCADE CONSTRAINTS;
CREATE TABLE standort (
 sid INT NOT NULL,
 land VARCHAR(255) NOT NULL,
 plz INT NOT NULL,
 ort VARCHAR(255) NOT NULL
);

ALTER TABLE standort ADD CONSTRAINT PK_standort PRIMARY KEY (sid);


DROP TABLE trainer CASCADE CONSTRAINTS;
CREATE TABLE trainer (
 persnr INT NOT NULL,
 gehalt DECIMAL(255) NOT NULL,
 von DATE NOT NULL,
 bis DATE NOT NULL
);

ALTER TABLE trainer ADD CONSTRAINT PK_trainer PRIMARY KEY (persnr);


DROP TABLE angestellter CASCADE CONSTRAINTS;
CREATE TABLE angestellter (
 persnr INT NOT NULL,
 gehalt DECIMAL(255) NOT NULL,
 ueberstunden DECIMAL(255) NOT NULL,
 e_mail VARCHAR(255) NOT NULL
);

ALTER TABLE angestellter ADD CONSTRAINT PK_angestellter PRIMARY KEY (persnr);


DROP TABLE mannschaft CASCADE CONSTRAINTS;
CREATE TABLE mannschaft (
 bezeichnung VARCHAR(255) NOT NULL,
 klasse VARCHAR(255) NOT NULL,
 naechstes_spiel DATE NOT NULL,
 persnr INT NOT NULL
);

ALTER TABLE mannschaft ADD CONSTRAINT PK_mannschaft PRIMARY KEY (bezeichnung);


DROP TABLE mitglied CASCADE CONSTRAINTS;
CREATE TABLE mitglied (
 persnr INT NOT NULL,
 beitrag VARCHAR(255) NOT NULL
);

ALTER TABLE mitglied ADD CONSTRAINT PK_mitglied PRIMARY KEY (persnr);


DROP TABLE spiel CASCADE CONSTRAINTS;
CREATE TABLE spiel (
 datum TIMESTAMP(255) NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL,
 gegner VARCHAR(255) NOT NULL,
 ergebnis VARCHAR(255) NOT NULL
);

ALTER TABLE spiel ADD CONSTRAINT PK_spiel PRIMARY KEY (datum,bezeichnung);


DROP TABLE spielt CASCADE CONSTRAINTS;
CREATE TABLE spielt (
 nummer INT NOT NULL,
 persnr INT NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL
);

ALTER TABLE spielt ADD CONSTRAINT PK_spielt PRIMARY KEY (nummer,persnr,bezeichnung);


DROP TABLE assistent CASCADE CONSTRAINTS;
CREATE TABLE assistent (
 persnr_0 INT NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL
);

ALTER TABLE assistent ADD CONSTRAINT PK_assistent PRIMARY KEY (persnr_0,bezeichnung);


DROP TABLE beteiligt CASCADE CONSTRAINTS;
CREATE TABLE beteiligt (
 persnr INT NOT NULL,
 datum TIMESTAMP(255) NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL,
 dauer DECIMAL(255)
);

ALTER TABLE beteiligt ADD CONSTRAINT PK_beteiligt PRIMARY KEY (persnr,datum,bezeichnung);


DROP TABLE chef_trainer CASCADE CONSTRAINTS;
CREATE TABLE chef_trainer (
 persnr_0 INT NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL
);

ALTER TABLE chef_trainer ADD CONSTRAINT PK_chef_trainer PRIMARY KEY (persnr_0,bezeichnung);


DROP TABLE fanclub CASCADE CONSTRAINTS;
CREATE TABLE fanclub (
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL,
 obmann INT NOT NULL,
 gegruendet DATE NOT NULL
);

ALTER TABLE fanclub ADD CONSTRAINT PK_fanclub PRIMARY KEY (name,sid,obmann);


DROP TABLE kapitaen CASCADE CONSTRAINTS;
CREATE TABLE kapitaen (
 persnr INT NOT NULL,
 bezeichnung VARCHAR(255) NOT NULL
);

ALTER TABLE kapitaen ADD CONSTRAINT PK_kapitaen PRIMARY KEY (persnr,bezeichnung);


DROP TABLE betreut CASCADE CONSTRAINTS;
CREATE TABLE betreut (
 name VARCHAR(255) NOT NULL,
 sid INT NOT NULL,
 persnr INT NOT NULL,
 anfang DATE NOT NULL,
 ende DATE NOT NULL
);

ALTER TABLE betreut ADD CONSTRAINT PK_betreut PRIMARY KEY (name,sid,persnr);


ALTER TABLE spieler ADD CONSTRAINT FK_spieler_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE trainer ADD CONSTRAINT FK_trainer_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE angestellter ADD CONSTRAINT FK_angestellter_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE mannschaft ADD CONSTRAINT FK_mannschaft_0 FOREIGN KEY (persnr) REFERENCES trainer (persnr);


ALTER TABLE mitglied ADD CONSTRAINT FK_mitglied_0 FOREIGN KEY (persnr) REFERENCES person (persnr);


ALTER TABLE spiel ADD CONSTRAINT FK_spiel_0 FOREIGN KEY (bezeichnung) REFERENCES mannschaft (bezeichnung);


ALTER TABLE spielt ADD CONSTRAINT FK_spielt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE spielt ADD CONSTRAINT FK_spielt_1 FOREIGN KEY (bezeichnung) REFERENCES mannschaft (bezeichnung);


ALTER TABLE assistent ADD CONSTRAINT FK_assistent_0 FOREIGN KEY (persnr_0) REFERENCES trainer (persnr);
ALTER TABLE assistent ADD CONSTRAINT FK_assistent_1 FOREIGN KEY (bezeichnung) REFERENCES mannschaft (bezeichnung);


ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE beteiligt ADD CONSTRAINT FK_beteiligt_1 FOREIGN KEY (datum,bezeichnung) REFERENCES spiel (datum,bezeichnung);


ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_0 FOREIGN KEY (persnr_0) REFERENCES trainer (persnr);
ALTER TABLE chef_trainer ADD CONSTRAINT FK_chef_trainer_1 FOREIGN KEY (bezeichnung) REFERENCES mannschaft (bezeichnung);


ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_0 FOREIGN KEY (sid) REFERENCES standort (sid);
ALTER TABLE fanclub ADD CONSTRAINT FK_fanclub_1 FOREIGN KEY (obmann) REFERENCES mitglied (persnr);


ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_0 FOREIGN KEY (persnr) REFERENCES spieler (persnr);
ALTER TABLE kapitaen ADD CONSTRAINT FK_kapitaen_1 FOREIGN KEY (bezeichnung) REFERENCES mannschaft (bezeichnung);


ALTER TABLE betreut ADD CONSTRAINT FK_betreut_0 FOREIGN KEY (name,sid,persnr) REFERENCES fanclub (name,sid,obmann);
ALTER TABLE betreut ADD CONSTRAINT FK_betreut_1 FOREIGN KEY (persnr) REFERENCES angestellter (persnr);



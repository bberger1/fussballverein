-- df vorname: word=givennames.list
-- df nachname: word=familynames.list
-- df position: word=position.list
-- df laender: word=laender.list
-- df orte: word=orte.list
-- df plz: word=postleitzahl.list
-- df dates: word=dates.list

DROP TABLE Person;
CREATE TABLE Person ( -- df: mult=2000.0
 persnr TIMESTAMP NOT NULL UNIQUE -- df: timestamp
);

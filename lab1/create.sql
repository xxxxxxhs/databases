CREATE TABLE coordinates (
    id INT NOT NULL PRIMARY KEY,
    xCor INT,
    yCor INT
);
CREATE TABLE areaObject (
    id INT NOT NULL PRIMARY KEY,
    objName VARCHAR(64) NOT NULL,
    coorId INT NOT NULL REFERENCES coordinates (id)
);
CREATE TABLE life (
    id INT NOT NULL PRIMARY KEY,
    lived BOOLEAN
);
CREATE TABLE characterr (
    id INT NOT NULL PRIMARY KEY,
    charName VARCHAR(64) NOT NULL,
    locationAreaId INT NOT NULL REFERENCES areaObject (id),
    currLifeId INT NOT NULL REFERENCES life (id)
);
CREATE TABLE natureObject (
    id INT NOT NULL PRIMARY KEY,
    natName VARCHAR(64) NOT NULL,
    situatedAtAreaId INT NOT NULL REFERENCES areaObject (id)
);
CREATE TABLE enchantment (
    id INT NOT NULL PRIMARY KEY,
    enchName VARCHAR(64),
    sourceAreaObjId INT NOT NULL REFERENCES areaObject (id),
    destinationCharId INT NOT NULL REFERENCES characterr (id)
);
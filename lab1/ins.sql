INSERT INTO coordinates (id, xCor, yCor)
VALUES (1, 0 , 0);

INSERT INTO coordinates (id, xcor, ycor)
VALUES (2, 1, 1);

INSERT INTO areaobject (id, objname, coorid)
VALUES
(1, 'edge', 1),
(2, 'landscape', 2);

INSERT INTO life (id, lived)
VALUES
(1, true),
(2, false),
(3, false);

INSERT INTO characterr (id, charname, locationareaid, currlifeid)
VALUES (1, 'Dzhiziruck', 1, 2);

INSERT INTO natureobject (id, natname, situatedatareaid)
VALUES
(1, 'dune', 2),
(2, 'hill', 2);

INSERT INTO enchantment (id, enchname, sourceareaobjid, destinationcharid)
VALUES (1, 'beauty', 2, 1);
CREATE TABLE coordinates (
    id INT NOT NULL PRIMARY KEY,
    x_cor INT,
    y_cor INT
);
CREATE TABLE area_object (
    id INT NOT NULL PRIMARY KEY,
    obj_name VARCHAR(64) NOT NULL,
    coor_id INT NOT NULL REFERENCES coordinates (id)
);
CREATE TABLE characterr (
    id INT NOT NULL PRIMARY KEY,
    char_name VARCHAR(64) NOT NULL,
    location_area_id INT NOT NULL REFERENCES area_object (id)
);
CREATE TABLE life (
    id INT NOT NULL PRIMARY KEY,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    char_owner_id INT NOT NULL REFERENCES characterr (id)
);
CREATE TABLE nature_object (
    id INT NOT NULL PRIMARY KEY,
    nat_name VARCHAR(64) NOT NULL,
    situated_at_area_id INT NOT NULL REFERENCES area_object (id)
);
CREATE TABLE enchantment (
    id INT NOT NULL PRIMARY KEY,
    ench_name VARCHAR(64),
    source_area_obj_id INT NOT NULL REFERENCES area_object (id),
    destination_char_id INT NOT NULL REFERENCES characterr (id)
);
CREATE DATABASE animal_db;

CREATE TABLE animal_name (
    id SERIAL PRIMARY KEY,
    weather VARCHAR(50),
    time TIME,
    lvl1 VARCHAR(50),
    lvl2 VARCHAR(50),
    lvl3 VARCHAR(50)
);

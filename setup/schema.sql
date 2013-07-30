-- DROP DATABASE mycel2;
-- CREATE DATABASE mycel2;
-- CREAT USER {username}
-- GRANT ALL ON mycel2.* TO '{username}'@localhost IDENTIFIED BY '{password}';
-- mysql -u {username} -p < schema.sql

USE mycel2;
SET storage_engine=INNODB;

CREATE TABLE UserTypes (
    id   INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(128) NOT NULL UNIQUE KEY,

    PRIMARY KEY (id)
);

CREATE TABLE Users (
    id            INT NOT NULL AUTO_INCREMENT,
    username      VARCHAR(64) NOT NULL UNIQUE KEY,
    password      VARCHAR(64),
    password_salt VARCHAR(64),
    name          VARCHAR(128),
    age           INT,
    printerquota  INT NOT NULL DEFAULT 0,
    minutes       INT NOT NULL,
    type          INT NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (type) REFERENCES UserTypes(id)
);

CREATE TABLE Hours (
    id         INT NOT NULL AUTO_INCREMENT,
    open_from  CHAR(5),
    open_until CHAR(5),
    closed     BOOLEAN NOT NULL DEFAULT 0,

    PRIMARY KEY (id)
);

CREATE TABLE OpeningHours (
    id        INT NOT NULL AUTO_INCREMENT,
    monday    INT NOT NULL,
    tuesday   INT NOT NULL,
    wednesday INT NOT NULL,
    thursday  INT NOT NULL,
    friday    INT NOT NULL,
    saturday  INT NOT NULL,
    sunday    INT NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (monday) REFERENCES Hours(id),
    FOREIGN KEY (tuesday) REFERENCES Hours(id),
    FOREIGN KEY (wednesday) REFERENCES Hours(id),
    FOREIGN KEY (thursday) REFERENCES Hours(id),
    FOREIGN KEY (friday) REFERENCES Hours(id),
    FOREIGN KEY (saturday) REFERENCES Hours(id),
    FOREIGN KEY (sunday) REFERENCES Hours(id)
);

CREATE TABLE YearHours (
    id            INT NOT NULL AUTO_INCREMENT,
    opening_hours INT,

    PRIMARY KEY (id),
    FOREIGN KEY (opening_hours) REFERENCES OpeningHours(id)
);

CREATE TABLE ExceptionHours (
    id            INT NOT NULL AUTO_INCREMENT,
    weeknr        INT NOT NULL,
    opening_hours INT NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (opening_hours) REFERENCES OpeningHours(id)
);

CREATE TABLE WeekExceptions (
    year INT NOT NULL,
    week INT NOT NULL,

    PRIMARY KEY(year, week),
    FOREIGN KEY (year) REFERENCES YearHours(id),
    FOREIGN KEY (week) REFERENCES ExceptionHours(id)
);

CREATE TABLE Options (
    id            INT NOT NULL AUTO_INCREMENT,
    opening_hours INT,
    homepage      VARCHAR(256),
    printer       VARCHAR(128),
    age_min       INT,
    age_max       INT,
    minutes       INT,
    short_minutes INT,

    PRIMARY KEY (id),
    FOREIGN KEY (opening_hours) REFERENCES YearHours(id)
);

CREATE TABLE Levels (
    id      INT NOT NULL AUTO_INCREMENT,
    type    INT NOT NULL,
    name    VARCHAR(128) NOT NULL,
    owner   INT,
    options INT,

    PRIMARY KEY (id),
    FOREIGN KEY (owner) REFERENCES Levels(id),
    FOREIGN KEY (type) REFERENCES LevelTypes(id),
    FOREIGN KEY (options) REFERENCES Options(id) ON DELETE CASCADE
);

CREATE TABLE LevelTypes (
    id   INT NOT NULL AUTO_INCREMENT,
    type VARCHAR(64) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE Clients (
    hwaddr    CHAR(64) NOT NULL,
    ipaddr    CHAR(64),
    name      VARCHAR(128) NOT NULL,
    owner     INT,
    shorttime BOOLEAN NOT NULL DEFAULT 0,
    options   INT,

    PRIMARY KEY (hwaddr),
    FOREIGN KEY (owner) REFERENCES Levels(id),
    FOREIGN KEY (options) REFERENCES Options(id) ON DELETE CASCADE
);

CREATE TABLE Admins (
    id            INT NOT NULL AUTO_INCREMENT,
    username      VARCHAR(64) NOT NULL UNIQUE KEY,
    password      VARCHAR(64) NOT NULL,
    password_salt VARCHAR(64) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE LevelAdmins (
    level INT NOT NULL,
    admin INT NOT NULL,

    PRIMARY KEY (level, admin),
    FOREIGN KEY (level) REFERENCES Levels(id),
    FOREIGN KEY (admin) REFERENCES Admins(id)
);
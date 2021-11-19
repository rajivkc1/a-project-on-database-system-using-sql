DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS assigned;
DROP TABLE IF EXISTS checks_in;
DROP TABLE IF EXISTS govern;
DROP TABLE IF EXISTS procedure_;
DROP TABLE IF EXISTS supervisor;

CREATE TABLE patient(
  pid     INTEGER  NOT NULL PRIMARY KEY,
  name    VARCHAR(24) NOT NULL,
  ssn     VARCHAR(11) NOT NULL UNIQUE,
  email   VARCHAR(33) UNIQUE,
  phone   VARCHAR(12),
  dob     VARCHAR(10)  NOT NULL,
  gender  VARCHAR(10) NOT NULL,
  address VARCHAR(52) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE employee(
  eid      INTEGER  NOT NULL PRIMARY KEY,
  name     VARCHAR(22) NOT NULL,
  email    VARCHAR(29) NOT NULL UNIQUE,
  phone    VARCHAR(12) NOT NULL,
  dob      VARCHAR(10)  NOT NULL,
  gender   VARCHAR(10) NOT NULL,
  position VARCHAR(9) NOT NULL,
  salary   VARCHAR(7) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE room(
  room_no   VARCHAR(6) NOT NULL PRIMARY KEY,
  room_type VARCHAR(13) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE assigned(
  admit_date     VARCHAR(10)  NOT NULL,
  discharge_date VARCHAR(10)  NOT NULL,
  room_no        VARCHAR(6) NOT NULL,
  pid            INTEGER  NOT NULL,
  PRIMARY KEY (pid, room_no),
  FOREIGN KEY(pid) REFERENCES patient(pid) ON DELETE CASCADE,
  FOREIGN KEY(room_no) REFERENCES room(room_no) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE checks_in(
  pid  INTEGER  NOT NULL,
  eid  INTEGER  NOT NULL,
  date_ VARCHAR(10)  NOT NULL,
  time_ VARCHAR(8) NOT NULL,
  PRIMARY KEY (pid, eid, time_),
  FOREIGN KEY(pid) REFERENCES patient(pid) ON DELETE CASCADE,
  FOREIGN KEY(eid) REFERENCES employee(eid) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE govern(
  date_    VARCHAR(10)  NOT NULL,
  time_    VARCHAR(8) NOT NULL,
  eid     INTEGER  NOT NULL,
  room_no VARCHAR(6) NOT NULL,
  PRIMARY KEY (eid, room_no, time_),
  FOREIGN KEY(eid) REFERENCES employee(eid) ON DELETE CASCADE,
  FOREIGN KEY(room_no) REFERENCES room(room_no) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE procedure_(
  pid       INTEGER  NOT NULL,
  eid       INTEGER  NOT NULL,
  diagnosis VARCHAR(26) NOT NULL,
  cost      VARCHAR(7) NOT NULL,
  FOREIGN KEY(eid) REFERENCES employee(eid) ON DELETE CASCADE,
  FOREIGN KEY(pid) REFERENCES patient(pid) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE supervisor(
  eidX INTEGER  NOT NULL,
  eidY INTEGER  NOT NULL,
  PRIMARY KEY (eidX, eidY),
  FOREIGN KEY(eidX) REFERENCES employee(eid) ON DELETE CASCADE,
  FOREIGN KEY(eidY) REFERENCES employee(eid) ON DELETE CASCADE
) ENGINE = InnoDB;
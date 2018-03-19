DROP TABLE IF EXISTS `chain`;
CREATE TABLE `chain` (
  `p_hash`      VARCHAR(125) NOT NULL,
  `bchash`      VARCHAR(125) NOT NULL,
  `merkle_root` VARCHAR(125) NOT NULL,
  `bcdata`      VARCHAR(1024) DEFAULT NULL,
  `tt`          VARCHAR(30)  NOT NULL,
  PRIMARY KEY (`bchash`)
);

DROP TABLE IF EXISTS `pseudonyms`;
CREATE TABLE `pseudonyms` (
  `GUID`      VARCHAR(38)  NOT NULL,
  `bcaddress` VARCHAR(182) NOT NULL,
  `ip`        VARCHAR(50)  NOT NULL,
  `value`     BIGINT DEFAULT 0,
  `tt`        VARCHAR(30)  NOT NULL,
  PRIMARY KEY (`bcaddress`)
);

DROP TABLE IF EXISTS `bckeys`;
CREATE TABLE `bckeys` (
  `bckey`     VARCHAR(90)  NOT NULL,
  `bcaddress` VARCHAR(182) NOT NULL,
  `tt`        VARCHAR(30)  NOT NULL,
  PRIMARY KEY (`bcaddress`)
);

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `signature` VARCHAR(256) NOT NULL,
  `bcaddress` VARCHAR(182) NOT NULL,
  `tt`        VARCHAR(30)  NOT NULL,
  PRIMARY KEY (`signature`)
);

DROP TABLE IF EXISTS `candidates_pool`;
CREATE TABLE `candidates_pool` (
  `signature` VARCHAR(256)   NOT NULL,
  `bcaddress` VARCHAR(182)   NOT NULL,
  `hash`      VARCHAR(125)   NOT NULL,
  `message`   VARCHAR(32765) NOT NULL,
  `fee`       BIGINT DEFAULT 0,
  `tt`        VARCHAR(30)    NOT NULL,
  PRIMARY KEY (`signature`)
)
  ENGINE = InnoDB
  CHARACTER SET latin1;

DROP TABLE IF EXISTS `candidates_log`;
CREATE TABLE `candidates_log` (
  `signature` VARCHAR(256)   NOT NULL,
  `bcaddress` VARCHAR(182)   NOT NULL,
  `hash`      VARCHAR(125)   NOT NULL,
  `message`   VARCHAR(32765) NOT NULL,
  `fee`       BIGINT DEFAULT 0,
  `tt`        VARCHAR(30)    NOT NULL,
  `tt_mined`  VARCHAR(30)    NOT NULL,
  PRIMARY KEY (`signature`)
)
  ENGINE = InnoDB
  CHARACTER SET latin1;
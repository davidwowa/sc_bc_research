DROP TABLE candidates_pool;
DROP TABLE candidates_log;

ALTER TABLE chain ADD `nr` BIGINT NOT NULL;
ALTER TABLE messages ADD `tt` VARCHAR(30) NOT NULL;
ALTER TABLE pseudonyms ADD `value` BIGINT DEFAULT 0;

INSERT INTO candidates_pool (signature, bcaddress, message, fee, tt) VALUES ('asdasd', 'asdasda', 'asdasdasd', '234', '3234234');

SELECT * from chain;
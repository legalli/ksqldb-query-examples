-- Problem statement: Need to create a ksqlDB table from a topic that has no keys
-- Pre-requisites: have a topic without keys
-- This example uses a topic (users-no-keys) generated with the Datagen connector in Confluent Cloud
-- The connector is configured with the USERS template and io.confluent.connect.transforms.Drop$Key SMT

-- Create a stream from the topic
CREATE STREAM USERS_NO_KEYS_STREAM (
    REGISTERTIME BIGINT,
    USERID STRING,
    REGIONID STRING,
    GENDER STRING)
WITH (
    KAFKA_TOPIC='users-no-keys',
    KEY_FORMAT='KAFKA',
    VALUE_FORMAT='AVRO');

-- Create a table from the stream
-- Key is identified in the GROUP BY statement
CREATE TABLE USERS_NO_KEYS_TBL 
WITH (
    KAFKA_TOPIC='users-no-keys-tbl',
    KEY_FORMAT='KAFKA',
    VALUE_FORMAT='AVRO')
AS SELECT
    USERID,
    LATEST_BY_OFFSET(REGISTERTIME) AS REGISTERTIME,
    LATEST_BY_OFFSET(REGIONID) AS REGIONID,
    LATEST_BY_OFFSET(GENDER) AS GENDER
FROM USERS_NO_KEYS_STREAM
GROUP BY USERID EMIT CHANGES;

-- Query the table created
SELECT *
FROM USERS_NO_KEYS_TBL;
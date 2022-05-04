/*
 Filename- Code1_create_raw_tables.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code create Raw tables.
These tables act as raw tables which are used to feed data to final table created in code 3 and 4
where we manipulate the data relevantly
*/

drop table if exists title_raw;

    CREATE TABLE title_raw (
        tconst VARCHAR(40),
    titletype VARCHAR(40),
    primaryTitle VARCHAR ( 1000 ),
    originalTitle VARCHAR ( 1000 ),
    isAdult BOOLEAN,
    startYear VARCHAR ( 4 ),
    endYear VARCHAR ( 4 ),
    runtimeMinutes  INT,
    genres VARCHAR ( 200 ));


drop table if exists title_principal_raw;

    CREATE TABLE title_principal_raw (
        tconst VARCHAR(40),
    ordering INT,
    nconst VARCHAR ( 40),
    category VARCHAR ( 40 ),
    job VARCHAR ( 400 ),
    character VARCHAR ( 1000 ));

drop table if exists name_basics_raw;

    CREATE TABLE name_basics_raw (
        nconst VARCHAR(40),
    primaryname VARCHAR ( 200),
    birthyear VARCHAR ( 4),
    deathyear VARCHAR ( 4),
    primaryprofession VARCHAR ( 100 ),
    knownfortitles VARCHAR ( 1000 ));


drop table if exists rating_raw;

    CREATE TABLE rating_raw (
        tconst VARCHAR(40),
    averageRating DECIMAL,
    numVotes int);


--Summary: 8 of 8 statements executed in 109 ms
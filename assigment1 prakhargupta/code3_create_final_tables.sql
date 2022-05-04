/*
 Filename- Code3_create_final_tables.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code create final tables they will be later used as placeholder for data insertions
*/




drop  table  if exists title  CASCADE;
drop table if exists name_basics CASCADE;
drop table if exists title_principal CASCADE;
drop table if exists rating CASCADE;


    CREATE TABLE title (
    id              int,
    tconst          VARCHAR(40),
    titletype       VARCHAR(40),
    primaryTitle    VARCHAR ( 1000 ),
    originalTitle   VARCHAR ( 1000 ),

    startYear       VARCHAR ( 4 ),
    endYear         VARCHAR ( 4 ),
    runtimeMinutes  INT,
    genres          VARCHAR ( 200 ),
    primary key (id)
                       );



    CREATE TABLE name_basics
    (
        personid    int,
        nconst      VARCHAR(40),
        primaryname VARCHAR(200),
        birthyear   VARCHAR(4),
        deathyear   VARCHAR(4),
        primary key (personid)

    );


    CREATE TABLE title_principal (
    id              int REFERENCES title (id),
    tconst          VARCHAR(40),
    ordering        INT,
    nconst          VARCHAR ( 40),
    personid        int REFERENCES name_basics (personid),
    category        VARCHAR ( 40 ),

    primary key (id,ordering)
                                 );



    CREATE TABLE rating (
    id              int REFERENCES title (id),
    nconst          VARCHAR(40),
    averageRating   DECIMAL,
    numVotes        int,
     primary key (id) );

--Summary: 8 of 8 statements executed in 62 ms
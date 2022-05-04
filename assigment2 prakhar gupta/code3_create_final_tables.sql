/*
 Filename- Code3_create_final_tables.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code create final tables they will be later used as placeholder for data insertions
*/




drop  table  if exists Title  CASCADE;
drop  table  if exists Genre  CASCADE;

drop  table  if exists Title_Genre CASCADE ;
drop  table  if exists Member  CASCADE;

drop  table  if exists Title_Actor CASCADE ;
drop  table  if exists Title_Writer  CASCADE;

drop  table  if exists Title_Director  CASCADE;
drop  table  if exists Title_Producer  CASCADE;

drop  table  if exists Character CASCADE;
drop  table  if exists Actor_Title_Character  CASCADE;







    CREATE TABLE Title (
    id              int,

    type       VARCHAR(40),
    originalTitle   VARCHAR ( 1000 ),

    startYear       VARCHAR ( 4 ),
    endYear         VARCHAR ( 4 ),
    runtime  INT,
    avgRating DECIMAL,
    numVotes        int,

    primary key (id)
                       );

    CREATE TABLE Genre(
     id              int,

    genre       VARCHAR(40),
    primary key (id)
    );

    CREATE TABLE Title_Genre(
     genre             int,

    title      int,
    primary key (genre,title)
    );

    CREATE TABLE Member
    (
        id    int,
        name VARCHAR(200),
        birthyear   VARCHAR(4),
        deathyear   VARCHAR(4),
        primary key (id)

    );

        CREATE TABLE Title_Actor
    (
        title    int,
        actor int,

        primary key (title,actor)

    );

            CREATE TABLE Title_Writer
    (
        title    int,
        Writer int,

        primary key (title,Writer)

    );


                CREATE TABLE Title_Director
    (
        title    int,
        Director int,

        primary key (title,Director)

    );

                    CREATE TABLE Title_Producer
    (
        title    int,
        Producer int,

        primary key (title,Producer)

    );

                        CREATE TABLE Character
    (
        id    int,
        character VARCHAR ( 1000 ),

        primary key (id)

    );


    CREATE TABLE  Actor_Title_Character
    (
        actor    int,
        title int,
        character int,
        primary key (actor,title,character)

    );





--
--     CREATE TABLE name_basics
--     (
--         personid    int,
--         nconst      VARCHAR(40),
--         primaryname VARCHAR(200),
--         birthyear   VARCHAR(4),
--         deathyear   VARCHAR(4),
--         primary key (personid)
--
--     );
--
--
--     CREATE TABLE title_principal (
--     id              int REFERENCES title (id),
--     tconst          VARCHAR(40),
--     ordering        INT,
--     nconst          VARCHAR ( 40),
--     personid        int REFERENCES name_basics (personid),
--     category        VARCHAR ( 40 ),
--
--     primary key (id,ordering)
--                                  );
--
--
--
--     CREATE TABLE rating (
--     id              int REFERENCES title (id),
--     nconst          VARCHAR(40),
--     averageRating   DECIMAL,
--     numVotes        int,
--      primary key (id) );

--Summary: 8 of 8 statements executed in 62 ms
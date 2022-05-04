-- Author Prakhar Gupta


CREATE TABLE Memberclean as
    select id ,replace(name, '"', '''') "name",deathyear,birthyear from member;
drop table if exists Genreclean ;
CREATE TABLE Genreclean AS
    select id, replace(genre, '"', '''') "genre" from genre;

drop table if exists Characterclean ;
CREATE TABLE Characterclean AS
    select id, replace(character.character, '"', '''') "character" from character;
drop table if exists Titleclean;
CREATE TABLE Titleclean as
    select id,type,replace(title.title, '"', '''') "title",replace(originaltitle, '"', '''') "originaltitle",startyear,endyear
    ,runtime,avgrating,numvotes from title;

COPY (
    SELECT array_to_json(array_agg(json_strip_nulls(row_to_json(t))))
    FROM (SELECT id "_id", name "name", birthyear "birthYear", deathyear "deathYear"
          FROM Memberclean) t) to
    'C:\Users\Prakhar Gupta\Desktop\BDcs620\assigm4\members.json';
-- change location

-- mongoimport --db IMDB --collection members --jsonArray --file "members.json" --drop

drop table if exists mongomovies;
create table mongomovies as
SELECT id "_id", type, title, originaltitle, cast(startYear as INTEGER) "startYear", cast(endYear as INTEGER) "endYear", runtime,
       avgrating, numvotes, genres, actors, directorid as directors, producerid as producers, writerid as writers FROM Titleclean T
    LEFT JOIN (SELECT title as titleid, array_agg(g.genre) as genres
            FROM title_genre JOIN Genreclean g
    ON title_genre.genre = g.id
            GROUP BY titleid ORDER BY titleid) as dummya ON T.id = dummya.titleid
    LEFT JOIN (SELECT title as titleid, array_agg(director) as directorid
            FROM title_director GROUP BY titleid) as dummyb ON T.id = dummyb.titleid
    LEFT JOIN (SELECT title as titleid, array_agg(producer) as producerid
            FROM title_producer GROUP BY titleid) as dummyc ON T.id = dummyc.titleid
    LEFT JOIN (SELECT title as titleid, array_agg(writer) as writerid
            FROM title_writer GROUP BY titleid) as dummyd ON T.id = dummyd.titleid
    LEFT JOIN (SELECT titleid, json_agg(actors) as actors FROM
            (SELECT dummye.titleid, json_build_object('actor', dummye.actorid, 'roles', dummye.roles) as actors FROM
            (SELECT atc.title as titleid, atc.actor as actorid, array_agg(x.character) as roles
            FROM Characterclean x JOIN actor_title_character atc
    ON x.id = atc.character
            GROUP BY (atc.title, atc.actor) ORDER BY (atc.title, atc.actor)) as dummye) AS doo
            GROUP BY titleid) as dummyf ON dummyf.titleid = T.id ;



COPY (SELECT json_strip_nulls(row_to_json(t.*)) FROM
(select * from mongomovies) t) to
    'C:\Users\Prakhar Gupta\Desktop\BDcs620\assigm4\movies.json';
-- change location

-- mongoimport --db IMDB --collection movies --file "movies.json" --drop
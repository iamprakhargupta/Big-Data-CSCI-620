/*
 Filename- Code4_insert_data.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code inserts data to final tables using raw tables.
*/




drop  table  if exists Title_p  CASCADE;

CREATE TABLE Title_p as
 select a.*,b.numVotes,b.avgRating from    (select
cast(substr(tconst,3) as INTEGER) "id",
titletype as type,
originalTitle,
genres,
startYear,
endYear,
runtimeMinutes as runtime from title_raw  where isadult=False) a left join
     (select cast(substr(tconst,3) as INTEGER) as id,averagerating as avgRating, numVotes as numVotes  from rating_raw)b
on a.id=b.id;


insert into title
select id,
type,
originalTitle,
startYear,
endYear,
runtime,
avgRating,
numVotes
from title_p;


commit ;

insert into genre
    select row_number() over (order by a.genre) "id",a.genre from
(select unnest(string_to_array(genres, ',')) as genre from title_p group by 1) a ;


insert into Title_Genre
select b.id as "genre",a.title as "title" from
(select id as  title ,unnest(string_to_array(genres, ',')) as genre_name from title_p) a inner join
    (select * from genre)b on a.genre_name=b.genre;

ALTER TABLE Title_Genre
    ADD CONSTRAINT fk_id_genre FOREIGN KEY (genre) REFERENCES genre (id);

ALTER TABLE Title_Genre
    ADD CONSTRAINT fk_id_title FOREIGN KEY (title) REFERENCES title (id);


insert into member
select
 cast(substr(nconst,3) as INTEGER) "id",

 primaryname as name,
 birthyear,
 deathyear from name_basics_raw;

commit ;

drop table if exists actor;

create table actor as
    select   cast(substr(nconst,3) as INTEGER) "actor",cast(substr(tconst,3) as INTEGER)
        "title" from title_principal_raw where category='actor' ;

drop table if exists title_actor_p;

create table title_actor_p as
select actor, title from actor where (actor in (select id from member)) and (title in (select id from title));

insert into title_actor
select  title,actor from title_actor_p group by 1,2;

ALTER TABLE title_actor
    ADD CONSTRAINT fk_id_member FOREIGN KEY (actor) REFERENCES member (id);


ALTER TABLE title_actor
    ADD CONSTRAINT fk_id_title FOREIGN KEY (title) REFERENCES title (id);


drop table if exists director_p;

create table director_p as
    select   cast(substr(nconst,3) as INTEGER) "director",cast(substr(tconst,3) as INTEGER)
        "title" from title_principal_raw where category='director' ;


insert into title_director
select title,director from director_p where (director in (select id from member))
                                         and (title in (select id from title)) group by 1,2;


ALTER TABLE title_director
    ADD CONSTRAINT fk_id_member FOREIGN KEY (director) REFERENCES member (id);


ALTER TABLE title_director
    ADD CONSTRAINT fk_id_title FOREIGN KEY (title) REFERENCES title (id);




drop table if exists writer_p;

create table writer_p as
    select   cast(substr(nconst,3) as INTEGER) "writer",cast(substr(tconst,3) as INTEGER)
        "title" from title_principal_raw where category='writer' ;


insert into title_writer
select title,writer from writer_p where (writer in (select id from member))
                                         and (title in (select id from title)) group by 1,2;


ALTER TABLE title_writer
    ADD CONSTRAINT fk_id_member FOREIGN KEY (writer) REFERENCES member (id);


ALTER TABLE title_writer
    ADD CONSTRAINT fk_id_title FOREIGN KEY (title) REFERENCES title (id);






drop table if exists producer_p;

create table producer_p as
    select   cast(substr(nconst,3) as INTEGER) "producer",cast(substr(tconst,3) as INTEGER)
        "title" from title_principal_raw where category='producer' ;


insert into title_producer
select title,producer from producer_p where (producer in (select id from member))
                                         and (title in (select id from title)) group by 1,2;


ALTER TABLE title_producer
    ADD CONSTRAINT fk_id_member FOREIGN KEY (producer) REFERENCES member (id);


ALTER TABLE title_producer
    ADD CONSTRAINT fk_id_title FOREIGN KEY (title) REFERENCES title (id);





drop table if exists character_p;

create table character_p as
    select  row_number() over (order by b.character) "id", b.character from (
                                                                        select a.character
                                                                            "character" from (select unnest(string_to_array(substr(character, 3, length(character) - 4) , '","'))
                                                                            as character from title_principal_raw where character is not null)a group by 1 ) b;


insert into character
select id,character from character_p;

drop table actor_title_character_p;

create table actor_title_character_p as
select a.character "character",a.actor,a.title from (select unnest(string_to_array(substr(character, 3, length(character) - 4) , '","'))
                            as character,cast(substr(nconst,3) as INTEGER) "actor",cast(substr(tconst,3) as INTEGER) "title"
                                            from title_principal_raw where character is not null and category='actor')a
                            where(a.actor in (select actor from title_actor ))
                                         and (a.title in (select title_actor.title from title_actor))  group by 1,2,3;



insert into actor_title_character
select a.actor,a.title,b.id from actor_title_character_p a join character b on a.character=b.character;


ALTER TABLE actor_title_character
    ADD CONSTRAINT fk_actor_actor FOREIGN KEY (actor,title) REFERENCES title_actor (actor,title);



ALTER TABLE actor_title_character
    ADD CONSTRAINT fk_character FOREIGN KEY (character) REFERENCES character (id);







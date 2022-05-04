/*
 Filename- q1.sql
 Author - Prakhar Gupta (pg9349)
 */


drop table if exists moviesubset CASCADE;;
create table moviesubset as
    select * from title where runtime> 75;

--s1

drop view if exists comedymovies;
create view comedymovies as
    select id,title,startyear as year from moviesubset where id in (select title from title_genre where genre=6);

drop materialized view if exists comedymoviesmaterialized;
create materialized view comedymoviesmaterialized as
    select id,title,startyear as year from moviesubset where id in (select title from title_genre where genre=6);

--s2
drop table if exists noncomedy CASCADE;
create table noncomedy as
     select a.id ,a.title , a.year from (select id,title,startyear as year from moviesubset where id in (select title from title_genre where genre<>6))a left join
        (select id from comedymoviesmaterialized)b on a.id=b.id where b.id is null;

---Testing
select title,genre from title_genre where title in (14606,16970,18208);



drop view if exists noncomedymovies;
create view noncomedymovies as
    select id,title,year from noncomedy group by 1,2,3;

drop materialized view if exists noncomedymoviesmaterialized;
create materialized view noncomedymoviesmaterialized as
    select id,title,year from noncomedy group by 1,2,3;

--s3
drop view if exists comedyactor;
create view comedyactor as
select  b.id,b.name,b.birthyear,b.deathyear from
(select id,name,birthyear,deathyear,a.title from title_actor a join member m on a.actor = m.id)b join comedymoviesmaterialized c
on b.title=c.id  group by 1,2,3,4;

drop materialized view if exists comedyactormaterialized;
create materialized view  comedyactormaterialized as
select  b.id,b.name,b.birthyear,b.deathyear from
(select id,name,birthyear,deathyear,a.title from title_actor a join member m on a.actor = m.id)b join comedymoviesmaterialized c
on b.title=c.id  group by 1,2,3,4;

--s4

drop view if exists noncomedyactor;
create view noncomedyactor as
select  b.id,b.name,b.birthyear,b.deathyear from
(select id,name,birthyear,deathyear from title_actor a join member m on a.actor = m.id)b left join comedyactormaterialized c
on b.id=c.id where c.id is null;

drop materialized view if exists noncomedyactormaterialized;
create materialized view  noncomedyactormaterialized as
select  b.id,b.name,b.birthyear,b.deathyear from
(select id,name,birthyear,deathyear from title_actor a join member m on a.actor = m.id)b left join comedyactormaterialized c
on b.id=c.id where c.id is null;


--s5
drop view if exists actedin;
create view actedin as
select a.title as movie,actor from title_actor a join moviesubset b on a.title=b.id;


drop materialized view if exists actedinmaterialized;
create materialized view actedinmaterialized as
select a.title as movie,actor from title_actor a join moviesubset b on a.title=b.id;



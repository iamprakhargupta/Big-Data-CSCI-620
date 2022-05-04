/*
 Author- Prakhar Gupta
 joining.sql
 This code created a table movies for Q1 for HW3
 */

create table selected_movies as
select f.title,max(f.cast)  from
(select b.title "title",b.actor "actor",count(character) "cast" from (select * from title where runtime>90)a
    join title_actor b on a.id=b.title
    join actor_title_character atc on b.actor = atc.actor and b.title = atc.title group by 1,2)f
group by 1 having max(f.cast)=1;

drop table if exists movies;
create table movies as
select row_number() over (order by a.title) "uniquekey",a.title as movieid,type,startyear,runtime,avgrating,tg.genre "genreid",g.genre "genre",m.id "memberid",m.birthyear,c.character from selected_movies a join title b on a.title=b.id join title_genre tg on b.id = tg.title
    join genre g on g.id = tg.genre join title_actor ta  on a.title=ta.title join member m on ta.actor = m.id
    join actor_title_character atc on ta.title=atc.title and ta.actor=atc.actor join character c on atc.character = c.id;


select count(*) from movies;
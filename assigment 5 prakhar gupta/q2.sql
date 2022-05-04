
/*
 Filename- q3.sql
 Author - Prakhar Gupta (pg9349)
 */

--Global as a View mapping

--All_Movie(id, title, year, genre), which contains each movie with its main genre
drop view if exists all_movies;
create view all_movies as
    (select a.* ,'comedy' as Genre from comedymovies a)
union
(select b.*,'noncomedy' as Genre from noncomedy b);



drop view if exists all_movies;
create view all_movies as
    (select a.* ,'comedy' as Genre from comedymoviesmaterialized a)
union
(select b.*,'noncomedy' as Genre from noncomedymoviesmaterialized b);






-- All_Actor(id, name, birthYear, deathYear), which contains each actor.

drop view if exists all_actor;
create  view all_actor as
    (select a.* from comedyactor a)
union
(select b.* from noncomedyactor b);


drop  view if exists all_actor;
create  view all_actor as
    (select a.* from comedyactormaterialized a)
union
(select b.* from noncomedyactormaterialized b);


--All_Movie_Actor(actor, movie), which stores actors participating in movies.

drop view if exists All_Movie_Actor ;
create  view All_Movie_Actor as
 select * from actedin;



drop view if exists All_Movie_Actor ;
create  view All_Movie_Actor as
 select * from actedinmaterialized;







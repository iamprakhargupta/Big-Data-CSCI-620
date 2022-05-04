/*
 Author - prakhar gupta
 questions 1 to 4
 */

--q1
create table Popular_Movie_Actors as
select a.* from title_actor a join  (select id from title where type='movie' and avgrating>5)b on
    a.title=b.id;
--q2

create table L1 as
select actor "actor1",count(*) from Popular_Movie_Actors group by 1
having count(*)>=5;

--q3
drop table if exists l2;
create table L2 as
    select actor1,actor2, count (dummy2.title) from (select b.actor "actor1",b.title from l1 a join popular_movie_actors b on actor1=actor)dummy1 join
(select title , actor "actor2"
from Popular_Movie_Actors  )dummy2 on dummy1.title=dummy2.title and actor1<actor2 group by 1,2 having count(dummy2.title)>=5;


--q4
drop table if exists l3;
create table L3 as
    select top.actor1,top.actor2,top.actor3,count(title) as c from
    (select a1.actor as actor1,a2.actor as actor2, a3.actor as actor3 , a1.title from popular_movie_actors a1 join popular_movie_actors a2 on a1.title = a2.title
join popular_movie_actors a3 on a3.title=a2.title where a1.actor<a2.actor and a2.actor < a3.actor) top
join (select actor1,actor2 from L2) base on base.actor1=top.actor1 and  base.actor2=top.actor2
group by 1,2,3 having count(title)>=5;




--- Count queries
select count(*) from l2;
select count(*) from l3;
select count(*) from l1;

--- cross checking
select * from l2 where actor1=78 and actor2=181003;
select * from l2 where actor1=78 and actor2=855579;
select * from l2 where actor1=181003 and actor2=855579;





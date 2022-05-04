/*
 Filename- q5.sql
 Author - Prakhar Gupta (pg9349)
 */



--Query 1 optimised

-- Non materialized view
select a.* from   ((select a.* from comedyactor a)
union
(select b.* from noncomedyactor b)) a join
(select actor,count(movie) "countof" from (select * from actedin) aa where movie in (
    select ff.id from ((select a.* ,'comedy' as Genre from comedymovies a)
union
(select b.*,'noncomedy' as Genre from noncomedy b))ff where year::integer>=2000 and year::integer<=2005
    )
    group by 1 having count(movie)>10)b
on a.id=b.actor where deathyear is null;

--1 min 6 s

-- Materialized view

select a.* from   ((select a.* from comedyactormaterialized a)
union
(select b.* from noncomedyactormaterialized b)) a join
(select actor,count(movie) "countof" from (select * from actedin) aa where movie in (
    select ff.id from ((select a.* ,'comedy' as Genre from comedymoviesmaterialized a)
union
(select b.*,'noncomedy' as Genre from noncomedymoviesmaterialized b))ff where year::integer>=2000 and year::integer<=2005
    )
    group by 1 having count(movie)>10)b
on a.id=b.actor where deathyear is null;
--10 sec




--Query 2 optimised

select * from noncomedyactor where name like 'Ja%';

--1 s 935 ms

select * from noncomedyactormaterialized where name like 'Ja%';

--97 ms


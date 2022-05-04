/*
 Filename- q4.sql
 Author - Prakhar Gupta (pg9349)
 */


--Query 1

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

-- 1m 4s

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

--10 secs

--Query 2

-- Non materialized view
select a.* from (    (select aaa.* from comedyactor aaa)
union
(select bbb.* from noncomedyactor bbb)
) a join
(select * from (select * from actedin)ff) aa left join
(select id from   ((select a11.* ,'comedy' as Genre from comedymovies a11)
union
(select b11.*,'noncomedy' as Genre from noncomedy b11)) ff where Genre='comedy')am on aa.movie=am.id
on a.id=aa.actor where name like 'Ja%' and am.id is null
group by 1,2,3,4;

--1m 9s

-- Materialized view

select a.* from (    (select aaa.* from comedyactormaterialized aaa)
union
(select bbb.* from noncomedyactormaterialized bbb)
) a join
(select * from (select * from actedinmaterialized)ff) aa left join
(select id from   ((select a11.* ,'comedy' as Genre from comedymoviesmaterialized a11)
union
(select b11.*,'noncomedy' as Genre from noncomedymoviesmaterialized b11)) ff where Genre='comedy')am on aa.movie=am.id
on a.id=aa.actor where name like 'Ja%' and am.id is null
group by 1,2,3,4;

--3s


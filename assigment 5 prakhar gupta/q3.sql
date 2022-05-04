/*
 Filename- q2.sql
 Author - Prakhar Gupta (pg9349)
 */

--Query1
select a.* from all_actor a join
(select actor,count(movie) "countof" from all_movie_actor aa where movie in (
    select id from all_movies where year::integer>=2000 and year::integer<=2005
    )
    group by 1 having count(movie)>10)b
on a.id=b.actor where deathyear is null;
--8s

--Query2

select a.* from all_actor a join
(select * from all_movie_actor) aa left join
(select id from all_movies where Genre='comedy')am on aa.movie=am.id
on a.id=aa.actor where name like 'Ja%' and am.id is null
group by 1,2,3,4;
--6s










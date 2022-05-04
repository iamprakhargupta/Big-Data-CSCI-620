/*
 Filename- q2.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code contains answer to question no 2. Queries are given below. Every query is also followed by a query which is
used for print count of rows fetched
*/




/*
 q2.1
 */



select count(*) from title_actor a left join actor_title_character b on a.title=b.title and b.actor=a.actor
where b.character is null;--1831057 ---11 s 736 ms

select a.title,a.actor from title_actor a left join actor_title_character b on a.title=b.title and b.actor=a.actor
where b.character is null;--4 s 287 ms

/*
 q 2.2
 */

select t.originaltitle,t.startyear "Title start year",c.name "actor name" from title t join
(select a.*,b.* from title_actor a join member b on a.actor=b.id where b.name like 'Phi%' and b.deathyear is NULL)c
on t.id=c.title where t.startyear <>'2014' and t.type='movie' group by 1,2,3;--17 s 387 ms

select count(*) from title t join
(select a.*,b.* from title_actor a join member b on a.actor=b.id where b.name like 'Phi%' and b.deathyear is NULL) c
on t.id=c.title where t.startyear <>'2014' and t.type='movie';--2265


/*
 q 2.3
 */

-- Since Genre id are given alphabetically talk show genre id will be 25 based on the IMDB data
-- in our table hence we are filtering it without joining the genre table

select f.producer "member id",f.name "Producer name" ,count(tg.genre) "Most Talk shows in 2017 count" from
(select c.producer,c.name,t.originaltitle,t.id from
(select a.*,m.* from title_producer a join member m on a.producer = m.id where m.name like '%Gill%')c
    join title t on c.title = t.id where t.startyear='2017')f join title_genre tg on f.id=tg.title where
 tg.genre=25 group by f.producer, f.name order by "Most Talk shows in 2017 count" desc ;--55 s 967 ms

 /*
  q 2.4
  */
select b.producer "Producer id",b.name "Producer Name", count(c.id) "No of long-run titles" from
(select a.title,a.producer,m.name from title_producer a join member m on a.producer = m.id where m.deathyear is null)b
join
(select t.id from title t where t.runtime>120)c on b.title=c.id group by 1,2 order by "No of long-run titles" desc ;

select count(*) from (select b.producer "Producer id",b.name "Producer Name", count(c.id) "No of long-run titles" from
(select a.title,a.producer,m.name from title_producer a join member m on a.producer = m.id where m.deathyear is null)b
join
(select t.id from title t where t.runtime>120)c on b.title=c.id group by 1,2 order by "No of long-run titles" desc )a;



/*
 q 2.5
 */


select a1.actor,m.name,a1.character from
(select atc.actor,atc.title,c.character
from character c join actor_title_character atc on c.id=atc.character where c.character='Jesus Christ')a1
join member m on a1.actor=m.id where deathyear is null group by 1,2,3;


select count(*) from (select a1.title,m.name from
(select atc.actor,atc.title,c.character
from character c join actor_title_character atc on c.id=atc.character where c.character='Jesus Christ')a1
join member m on a1.actor=m.id where deathyear is null group by 1,2)a;

/*
 Filename- q3.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code uses explain command to get json output to visualize the execution plan
*/




/*
 q2.1
 */

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select count(*) from title_actor a left join actor_title_character b on a.title=b.title and b.actor=a.actor
where b.character is null;



/*
 q 2.2
 */
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t.originaltitle,t.startyear "Title start year",c.name "actor name",c.deathyear from title t join
(select a.*,b.* from title_actor a join member b on a.actor=b.id where b.name like 'Phi%' and b.deathyear is NULL)c
on t.id=c.title where t.startyear <>'2014' and t.type='movie' group by 1,2,3,4;


/*
 q 2.3
 */
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select f.producer "member id",f.name "Producer name" ,count(tg.genre) "Most Talk shows in 2017 count" from
(select c.producer,c.name,t.originaltitle,t.id from
(select a.*,m.* from title_producer a join member m on a.producer = m.id where m.name like '%Gill%')c
    join title t on c.title = t.id where t.startyear='2017')f join title_genre tg on f.id=tg.title where
 tg.genre=25 group by f.producer, f.name order by "Most Talk shows in 2017 count" desc ;--43 s 373 ms

 /*
  q 2.4
  */
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select b.producer "Producer id",b.name "Producer Name", count(c.id) "No of long-run titles" from
(select a.title,a.producer,m.name from title_producer a join member m on a.producer = m.id where m.deathyear is null)b
join
(select t.id from title t where t.runtime>120)c on b.title=c.id group by 1,2 order by "No of long-run titles" desc ;


/*
 q 2.5
 */

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select a1.actor,m.name,a1.character from
(select atc.actor,atc.title,c.character
from character c join actor_title_character atc on c.id=atc.character where c.character='Jesus Christ')a1
join member m on a1.actor=m.id where deathyear is null group by 1,2,3;


/*
 Filename- q5.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code adds indexes as per query requirements and then runs the respective queries and there explain commands for
execution plan
*/




--- Query 1
CREATE INDEX actor_title_character_index
ON actor_title_character(character);

CREATE INDEX actor_title_character_index2
ON actor_title_character(title);

CREATE INDEX title_actor_index
ON title_actor(title);

CREATE INDEX actor_title_character_index3
ON actor_title_character(actor);

CREATE INDEX title_actor_index2
ON title_actor(actor);




select count(*) from title_actor a left join actor_title_character b on a.title=b.title and b.actor=a.actor
where b.character is null;--10 s 515 ms


EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select count(*) from title_actor a left join actor_title_character b on a.title=b.title and b.actor=a.actor
where b.character is null;--1831057


--- Query 2

CREATE INDEX member_index1
ON member(name);

CREATE INDEX title_index1
ON title(type);

CREATE INDEX title_index2
ON title(startyear);

CREATE INDEX member_index2
ON member(id);

CREATE INDEX title_index3
ON title(id);



select t.originaltitle,t.startyear "Title start year",c.name "actor name",c.deathyear from title t join
(select a.*,b.* from title_actor a join member b on a.actor=b.id where b.name like 'Phi%' and b.deathyear is NULL)c
on t.id=c.title where t.startyear <>'2014' and t.type='movie' group by 1,2,3,4;--11 s 892 ms


EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t.originaltitle,t.startyear "Title start year",c.name "actor name",c.deathyear from title t join
(select a.*,b.* from title_actor a join member b on a.actor=b.id where b.name like 'Phi%' and b.deathyear is NULL)c
on t.id=c.title where t.startyear <>'2014' and t.type='movie' group by 1,2,3,4;



--- Query 3

CREATE INDEX producer_index1
ON title_producer(producer);



CREATE INDEX title_genre_index1
ON title_genre(title);

select f.producer "member id",f.name "Producer name" ,count(tg.genre) "Most Talk shows in 2017 count" from
(select c.producer,c.name,t.originaltitle,t.id from
(select a.*,m.* from title_producer a join member m on a.producer = m.id where m.name like '%Gill%')c
    join title t on c.title = t.id where t.startyear='2017')f join title_genre tg on f.id=tg.title where
 tg.genre=25 group by f.producer, f.name order by "Most Talk shows in 2017 count" desc ;--42 s 497 ms

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
    select f.producer "member id",f.name "Producer name" ,count(tg.genre) "Most Talk shows in 2017 count" from
    (select c.producer,c.name,t.originaltitle,t.id from
    (select a.*,m.* from title_producer a join member m on a.producer = m.id where m.name like '%Gill%')c
        join title t on c.title = t.id where t.startyear='2017')f join title_genre tg on f.id=tg.title where
     tg.genre=25 group by f.producer, f.name order by "Most Talk shows in 2017 count" desc ;

--- Query 4

CREATE INDEX title_index4
ON title(runtime);

CREATE INDEX title_producer_index5
on title_producer(title);

select b.producer "Producer id",b.name "Producer Name", count(c.id) "No of long-run titles" from
(select a.title,a.producer,m.name from title_producer a join member m on a.producer = m.id where m.deathyear is null)b
join
(select t.id from title t where t.runtime>120)c on b.title=c.id group by 1,2 order by "No of long-run titles" desc ;--7 s 480 ms

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select b.producer "Producer id",b.name "Producer Name", count(c.id) "No of long-run titles" from
(select a.title,a.producer,m.name from title_producer a join member m on a.producer = m.id where m.deathyear is null)b
join
(select t.id from title t where t.runtime>120)c on b.title=c.id group by 1,2 order by "No of long-run titles" desc ;


--- Query 5

CREATE INDEX character_index2
on character(character);




select a1.actor,m.name,a1.character from
(select atc.actor,atc.title,c.character
from character c join actor_title_character atc on c.id=atc.character where c.character='Jesus Christ')a1
join member m on a1.actor=m.id where deathyear is null group by 1,2,3;--203 ms



EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select a1.actor,m.name,a1.character from
(select atc.actor,atc.title,c.character
from character c join actor_title_character atc on c.id=atc.character where c.character='Jesus Christ')a1
join member m on a1.actor=m.id where deathyear is null group by 1,2,3;




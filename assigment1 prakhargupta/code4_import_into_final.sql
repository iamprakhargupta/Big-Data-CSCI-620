/*
 Filename- Code4_import_into_final.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
This code inserts values into final tables after relevant preprocessing
*/


insert into title
select
cast(substr(tconst,3) as INTEGER) "id",
tconst,
titletype,
primaryTitle,
originalTitle,

startYear,
endYear,
runtimeMinutes,
genres from title_raw where titletype='movie' and isadult=False;

commit ;


insert into name_basics
select
 cast(substr(nconst,3) as INTEGER) "personid",
 nconst,
 primaryname,
 birthyear,
 deathyear from name_basics_raw;

commit ;


drop table if exists title_principal_processing;

    CREATE TABLE title_principal_processing (
    id              int REFERENCES title (id),
    tconst          VARCHAR(40),
    ordering        INT,
    nconst          VARCHAR ( 40),
    personid        int REFERENCES name_basics (personid),
    category        VARCHAR ( 40 ),

    primary key (id,ordering)
                                 );

insert  into title_principal_processing
select a.* from (select
    cast(substr(tconst,3) as INTEGER) "id",
    tconst,
    ordering,
    nconst,
    cast(substr(nconst,3) as INTEGER) "personid",
    category
   from title_principal_raw ) a where a.id in (select id from title) and a.personid in
                                                                                      (select personid from name_basics) ;


insert  into title_principal
select * from title_principal_processing where category in ('director','producer','writer','actor','actress');


insert into rating
select * from (select cast(substr(a.tconst,3) as INTEGER) "id",
       a.*
from rating_raw a )b where b.id in (select id from title);


commit;
drop table if exists title_principal_processing;


--Summary: 9 of 9 statements executed in 14 min, 19 sec, 960 ms
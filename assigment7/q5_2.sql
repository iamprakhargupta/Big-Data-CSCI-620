/*
 Author - prakhar gupta
 questions 5
 */


select * from autol6;

drop table if exists autol6name;
create table autol6name as
    select a.c "Count",b.name "actor1name",c.name "actor2name",d.name "actor3name",e.name "actor4name",f.name "actor5name",g.name "actorname"
    from autol6 a left join member b on a.actor1=b.id left join member c on a.actor2=c.id
        left join member d on a.actor3=d.id left join member e on a.actor4=e.id left join member f on a.actor5=f.id left join  member g on a.actor6=g.id;

select * from autol6name;
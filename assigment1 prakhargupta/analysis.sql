/*
 Filename- Analysis.sql
 Author - Prakhar Gupta (pg9349)
 */

/*
Getting familiar with data
*/



select category,count(*) from title_principal group by 1;

select min(runtimeminutes),max(runtimeminutes),avg(runtimeminutes) from title;

select min(numvotes)"min no of votes",max(numvotes)"Max no of Votes",avg(numvotes)"Average no of votes" from rating;


select a.id,primarytitle,count(*) "No of main cast" from title a  join title_principal p on a.id = p.id group by 1,2 order by count(*) desc,1  limit 10;


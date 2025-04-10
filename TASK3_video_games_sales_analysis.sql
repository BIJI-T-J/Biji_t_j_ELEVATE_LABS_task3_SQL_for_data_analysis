-- creating databse and using it 
create database video_games;
use video_games;

-- number of records in table 
select count(*) from vgsales;

-- data cleaning and preprocessing
select * from vgsales
where vgsales.Rank is null
	or
    vgsales.Name is null
    or
    vgsales.Platform is null
    or
    vgsales.Year is null
    or
    vgsales.Genre is null
    or
    vgsales.Publisher is null
    or
    vgsales.NA_Sales is null
    or
    vgsales.EU_Sales is null
    or
    vgsales.JP_Sales is null
    or
    vgsales.Other_Sales is null
    or
    vgsales.Global_Sales is null;
    
    
    
-- 1.Find the top 10 platforms with highest globally selling videogames
select distinct platform, round(sum(global_sales),3) as total_sale
from vgsales
group by platform
order by total_sale desc
limit 10;



--  2.Which genre of video games is most famous and purchased in japan.create a view
create view famous_japan_genre as
select genre, round(sum(jp_sales),2)as japan_sales
from vgsales
group by genre
order by japan_sales desc
limit 1;
select * from famous_japan_genre;



--  3.Which are the top3 genre of video games is most famous worldwide.
create view top3_games as 
select genre, round(sum(global_sales),2)as world_sales
from vgsales
group by genre
order by world_sales desc
limit 3;
select * from top3_games;



-- 4.which is the world-wide highest selling game name 
select vgsales.name, global_sales
from vgsales
order by global_sales desc
limit 1;



-- 5.Which publishers gets the highest sales from video game publishing in north america
select publisher, round(sum(na_sales),2) as north_america_sale
from vgsales
group by publisher
order by north_america_sale desc
limit 2;



-- 6.what is the top 3 pokemon games according to total world wide sales
select vgsales.name ,global_sales
from vgsales
where vgsales.name like '%pokemon%'
order by global_sales desc
limit 3;



-- 7.Which game that released before and after 2000 secured highest world wide sale.
-- highest revenue game before 2000 
select vgsales.name, vgsales.year, global_sales
from vgsales
where vgsales.year<2000
order by global_sales desc
limit 1;
-- highest sold game after 2000
select vgsales.name, vgsales.year, global_sales
from vgsales
where vgsales.year>=2000
order by global_sales desc
limit 1;



-- 8.Which is the best selling game, its publisher, platform and genre in each year. present the data in chronological order
create view each_year_bestseller as
select year, name, genre, publisher, global_sales
from(
select vgsales.year,vgsales.name, genre, publisher, global_sales,
	rank() over(partition by vgsales.year order by global_sales desc) as ranks
from vgsales) as t1
where ranks=1;
select * from each_year_bestseller;



-- 9.Which is the publisher with most number of games published and with highest sales
-- most number of publications 
select publisher, count(publisher) as games_published
from vgsales
group by publisher
order by count(publisher) desc
limit 1;
-- most sales
select publisher, round(sum(global_sales),2) as sales
from vgsales
group by publisher
order by sum(global_sales) desc
limit 1;



-- 10. retrieve the details of the oldest and the latest released games with top 3 sales
-- oldest game
select vgsales.year,vgsales.name, genre, publisher, global_sales
from vgsales
where vgsales.year=(select min(vgsales.year) from vgsales)
order by global_sales desc
limit 3;
-- latest game
select vgsales.year,vgsales.name, genre, publisher, global_sales
from vgsales
where vgsales.year=(select max(vgsales.year) from vgsales)
order by global_sales desc
limit 3;



-- 11.Retrieve top 3 selling games and it's details in japan, north america, europe.
select vgsales.year,vgsales.name, genre, publisher, jp_sales
from vgsales
where jp_sales=(select max(jp_sales) from vgsales);
select vgsales.year,vgsales.name, genre, publisher, eu_sales
from vgsales
where eu_sales=(select max(eu_sales) from vgsales);
select vgsales.year,vgsales.name, genre, publisher, na_sales
from vgsales
where na_sales=(select max(na_sales) from vgsales);

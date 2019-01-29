-- Creating the database Assignment
create database Assignment;

-- Using the database Assignment using the use keyword
use Assignment;

-- DROP TABLE IF EXISTS bajaj, hero, infosys, eicher, tcs, tvs;
-- Import the tables bajaj, hero, infosys, eicher, tcs, tvs from csv using Table Data Import Wizard
-- Two columns are imported as text explicitly because of a row having empty value for these two columns
-- These columns are Deliverable Quantity and % Deli. Qty to Traded Qty


-- Change the text date into Date format
update bajaj set Date = str_to_date(Date, '%d-%M-%Y');
update hero set Date = str_to_date(Date, '%d-%M-%Y');
update infosys set Date = str_to_date(Date, '%d-%M-%Y');
update eicher set Date = str_to_date(Date, '%d-%M-%Y');
update tcs set Date = str_to_date(Date, '%d-%M-%Y');
update tvs set Date = str_to_date(Date, '%d-%M-%Y');

--  For all the tables bajaj, hero, infosys, eicher, tcs, tvs
-- modify the datatype of Date from text to Date
alter table bajaj
modify Date DATE;

alter table hero
modify Date DATE;

alter table infosys
modify Date DATE;

alter table eicher
modify Date DATE;

alter table tcs
modify Date DATE;

alter table tvs
modify Date DATE;

-- Drop the tables bajaj1, tcs1, tvs1, infosys1, eicher1, hero1 if they already exist
DROP TABLE IF EXISTS bajaj1, tcs1, tvs1, infosys1, eicher1, hero1;

-- Create tables bajaj1, tcs1, tvs1, infosys1, eicher1, hero1 from
-- bajaj, tcs, tvs, infosys, eicher, hero respectively using create table select command
-- The if condition used checks for the row number and calculated the moving average for row number
-- greter than 20 and 50 else fill the moving averages with NULL
create table bajaj1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from bajaj
window w as (order by Date); 

create table hero1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from hero
window w as (order by Date); 

create table infosys1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from infosys
window w as (order by Date); 

create table eicher1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from eicher
window w as (order by Date); 

create table tcs1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from tcs
window w as (order by Date); 

create table tvs1 (PRIMARY KEY (Date))
select Date, `Close Price`,
IF(ROW_NUMBER() over w > 19, avg(`Close Price`)  over (order by Date rows between 19 preceding and current row), NULL)  as `20 Day MA`,
IF(ROW_NUMBER() over w > 49, avg(`Close Price`)  over (order by Date rows between 49 preceding and current row), NULL)  as `50 Day MA`
from tvs
window w as (order by Date); 
 
-- Drop the master stocks table if it already exist 
DROP TABLE IF EXISTS `master stocks`;


-- create a new master stocks table by joining the 
-- bajaj, tcs, tvs, infosys, eicher, hero tables
CREATE TABLE `assignment`.`master stocks` 
select b.Date as Date,b.`Close Price` as `Bajaj`, tc.`Close Price` as `TCS`, tv.`Close Price` as `TVS`,
i.`Close Price` as `Infosys`, e.`Close Price` as `Eicher`, h.`Close Price` as `Hero` 
from bajaj as b inner join 
tcs  as tc on b.Date = tc.Date inner join
tvs  as tv on tc.Date = tv.Date inner join
infosys as i on tv.Date = i.Date inner join
eicher as e on i.Date = e.Date inner join
hero as h on e.Date = h.Date;

-- desc `master stocks`;
-- select count(*) from `master stocks`;

-- Drop the bajaj2, hero2, eicher2, infosys2, tcs2, tvs2 tables if they exist already
drop table if exists bajaj2, hero2, eicher2, infosys2, tcs2, tvs2;

-- Create table bajaj2
-- by using Date, Close Price and Signal columns
-- The signal is calculated using LAG function which considers the row which is offset before
-- the current row where the function is defined as LAG(expression, offset) over a window.
-- The case statement contains multiple "WHEN" which evaluates an expression and then return 
-- some output accordingly specified in "THEN"
create table `bajaj2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from bajaj1
window w as (ORDER BY DATE);

create table `hero2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from hero1
window w as (ORDER BY DATE);

create table `eicher2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from eicher1
window w as (ORDER BY DATE);

create table `infosys2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from infosys1
window w as (ORDER BY DATE);

create table `tcs2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from tcs1
window w as (ORDER BY DATE);

create table `tvs2`
select Date, `Close Price`,
CASE
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "BUY"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "SELL"
WHEN LAG(`20 Day MA` > `50 Day MA`, 1) OVER w and (`20 Day MA` > `50 Day MA`) THEN "HOLD"
WHEN LAG(`20 Day MA` < `50 Day MA`, 1) OVER w and (`20 Day MA` < `50 Day MA`) THEN "HOLD"
END as `Signal`
from tvs1
window w as (ORDER BY DATE);

Drop function if exists getSignal ;
-- UDF to take Date as input
-- and return signal from bajaj stock data
create function getSignal (d Date)
	returns varchar(10)
    deterministic
return (select `Signal`
from bajaj2
where `Date` = d);

-- select getSignal("2018-02-05") as `Signal`;


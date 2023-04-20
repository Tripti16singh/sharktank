SELECT * FROM sharktank.shark_data;
-- total number of episodes in each season1 = 35 season2 = 42
select season, count(distinct epno) as 'total episode' from sharktank.shark_data
group by season ;


-- total number of pitches in each season 1 = 116 and season 2 = 67
select season, count(distinct pitchno) from sharktank.shark_data
group by season;

-- total number of pitches in each episode 
select epnum, count(pitchno) from sharktank.shark_data
where season = 1
group by epnum
order by count(pitchno);


-- total of industries for investment max = food min = entertainment
  select industry, count(industry) from sharktank.shark_data
  group by industry
  order by count(industry) desc;
  
  -- gender wise - total pitchers male (280), female(109), transgender(2) indsutrty wise
select industry, sum(male) as 'total male' , sum(female)  as 'total female', sum(Transgender_Presenters) as 'total transgender' from sharktank.shark_data
group by industry;

-- gender ratio
select round(sum(male)/sum(no_of_presenters),2) *100 as 'total male %' , floor(sum(female)/sum(no_of_presenters)*100)  as 'total female %', round(sum(Transgender_Presenters)/sum(no_of_presenters),2)*100 as 'total transgender %' 
from sharktank.shark_data;

-- offers received season1 = 78 and season- 52
select sum(offer_received) from sharktank.shark_data
where season = 2;

-- converserion rate industry wise

select industry, floor(sum(offer_received)/count(pitchno) *100) as 'conversation_rate' from sharktank.shark_data
where season = 1
group by industry;

-- acceptance rate - 100% in vehicles and electrical vehicles
select industry, floor(sum(accepted_offer)/count(pitchno) *100) as 'acceptance_rate' from sharktank.shark_data
where season = 1
group by industry;

-- total offers accepted in s1 = 55 and s2 = 43
select sum(accepted_offer) from sharktank.shark_data
where season = 2;

-- state- wise pitches max - maharashtra
select state, count(brand) as 'brand_ count' from sharktank.shark_data
-- where season = 1
group by state 
order by count(brand) desc;

-- city wise number of brands - 
select season, city, count(city) as max_brand_city from
(select season, city, count(brand) over (partition by city order by brand) as brand_count
from shark_data)t
group by season,city
order by count(city) desc
limit 15;


-- max amount requested - toal amount asked - 37657 in s1 -- (problem)
-- select sum(ask_amount) as 'total_ask_amount'from sharktank.shark_data
-- where season = 1;
-- select  max(ask_amount) as 'total_ask_amount'from sharktank.shark_data
-- where season = 1;

-- least amount requested. s1- 531101 ans s2- 467229
select season,  sum(valuation_requested)from sharktank.shark_data 
group by season;

-- offers rejected by the picthers
select  season , brand, Industry ,count(accepted_offer) as 'rejected_ offer' from sharktank.shark_data
where accepted_offer = 0 or NULL
group by brand, season, industry ;

-- deal done by sharks together. 
select season, industry, brand, deal_amount, deal_equity, no_sharks_deal from sharktank.shark_data
where no_sharks_deal > 1;

-- sum of loan/debt 
select season, floor(sum(deal_amount)) as 'total_invested_amount' , sum(deal_equity) as 'total_equity %' , sum(deal_debt) as 'total_debt' from sharktank.shark_data
group by season;

-- top 3 investments - investment, equity andd debt
select season, rnk, industry, brand, deal_amount
from (select industry, brand, season,deal_amount, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_amount DESC) AS rnk
from shark_data) t1
where 	rnk <= 3;

-- top 3 equity
 select season, rnk, industry, brand , deal_equity
from (select industry, brand, season, deal_equity, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_equity DESC) AS rnk
from shark_data) t1
where 	rnk <= 3
;
-- top 3 debt 
 select season, rnk, industry, brand , deal_debt
from (select industry, brand, season, deal_debt, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_debt DESC) AS rnk
from shark_data) t1
where 	rnk <= 3
;

-- which shark invested the most in both season.

select season, ashneer as 'investor', floor(sum(column_value)) as total_invested from
(SELECT season, 'ashneer_investment_amount' AS ashneer, ashneer_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'namita_investment_amount' AS namita, namita_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'vineeta_investment_amount' AS vineeta, vineeta_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'anupam_investment_amount' AS anupam, anupam_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'aman_investment_amount' AS aman, aman_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'amit_investment_amount' AS amit, amit_investment_amount AS column_value
FROM shark_data
UNION ALL
SELECT season, 'ghazal_investment_amount' AS ghazal, ghazal_investment_amount AS column_value
FROM shark_data) t1
group by season, ashneer
order by total_invested desc;

-- TOTAL INVESTMNET,EQUITY,AND DEBT INVESTMENT DONE BY ALL THE INVESTORS
SELECT * FROM new_table;


-- NO. OF COMPANIES INVESTED BY THE INVESTORS INDIVIUALLLY IN BOTH THE SEASONS.
select season, investor, industry, sum(total_count) as count_brand_investment, floor(sum(total)) as total_brand_investment from
(select season, investor, industry, sum(count_sum) as total_count, sum(column_value) as total from
(select season, investor,brand,count(brand) as count_sum, column_value, industry from 
(select season,brand,industry,'ashneer_investment_amount' as investor, ashneer_investment_amount as column_value from shark_data
where Ashneer_Investment_Amount > 0
union all
select season,brand,industry,'Namita_Investment_Amount' as investor, Namita_Investment_Amount as column_value from shark_data
where Namita_Investment_Amount > 0
union all
select season,brand,industry,'Anupam_Investment_Amount' as investor, Anupam_Investment_Amount as column_value from shark_data
where Anupam_Investment_Amount > 0
union all
select season,brand,industry,'Vineeta_Investment_Amount' as investor, Vineeta_Investment_Amount as column_value from shark_data
where Vineeta_Investment_Amount > 0
union all
select season,brand,industry,'Aman_Investment_Amount' as investor, Aman_Investment_Amount as column_value from shark_data
where Aman_Investment_Amount > 0
union all
select season,brand,industry,'Peyush_Investment_Amount' as investor, Peyush_Investment_Amount as column_value from shark_data
where Peyush_Investment_Amount > 0
union all
select season,brand,industry,'Ghazal_Investment_Amount' as investor, Ghazal_Investment_Amount as column_value from shark_data
where Ghazal_Investment_Amount > 0
union all
select season,brand,industry,'Amit_Investment_Amount' as investor, Amit_Investment_Amount as column_value from shark_data
where Amit_Investment_Amount > 0) t1
group by season ,investor, brand, Industry,column_value) t2
group by season, industry, investor,column_value) t3
group by season, industry, investor;

--  investors wise investment in brands, type, amount, equity [ASHNEER]
select season, brand, industry, ashneer_investment_amount, ashneer_investment_equity, ashneer_debt_amount from shark_data
where Ashneer_Investment_Amount >=1;

-- --  investors wise investment in brands, type, amount, equity [NAMITA]
select season, brand, industry, Namita_Investment_Amount, Namita_Investment_Equity, Namita_Debt_Amount from shark_data
where Namita_Investment_Amount >=1;

--  investors wise investment in brands, type, amount, equity [ANUPAM]
select season, brand, industry, Anupam_Investment_Amount, Anupam_Investment_Equity, Anupam_Debt_Amount from shark_data
where Anupam_Investment_Amount >= 1;

--  investors wise investment in brands, type, amount, equity [VINEETA]
select season, brand, industry, Vineeta_Investment_Amount, Vineeta_Investment_Equity, Vineeta_Debt_Amount from shark_data
where Vineeta_Investment_Amount >=1;

--  investors wise investment in brands, type, amount, equity [AMAN]
select season, brand, industry, Aman_Investment_Amount, Aman_Investment_Equity, Aman_Debt_Amount from shark_data
where Aman_Investment_Amount >=1
ORDER BY Aman_Investment_Amount DESC;

--  investors wise investment in brands, type, amount, equity [PEYUSH]  
select season, brand, industry, Peyush_Investment_Amount, Peyush_Investment_Equity, Peyush_Debt_Amount from shark_data
where Peyush_Investment_Amount >=1;

--  investors wise investment in brands, type, amount, equity [GHAZAL]
select season, brand, industry, Ghazal_Investment_Amount, Ghazal_Investment_Equity, Ghazal_Debt_Amount from shark_data
where Ghazal_Investment_Amount >=1;

--  investors wise investment in brands, type, amount, equity [AMIT]
select season, brand, industry, Amit_Investment_Amount, Amit_Investment_Equity, Aman_Debt_Amount from shark_data
where Amit_Investment_Amount >=1;

-- PITCHERS AGE
SELECT SEASON,SUM(No_of_Presenters), PITCHERS_AVERAGE_AGE FROM shark_data
GROUP BY SEASON,Pitchers_Average_Age;

-- YEAR OF FOUNDATION OF BRANDS
SELECT SEASON, STARTED, COUNT(BRAND) AS FOUNDATION_YEAR_COUNT FROM shark_data
GROUP BY SEASON, STARTED
ORDER BY FOUNDATION_YEAR_COUNT DESC;

-- BRANDS WHICH RECEIVED MORE INVESTMENT THAN ASKED
SELECT BRAND, Industry,ask_amount,deal_amount FROM shark_data
WHERE ASK_AMOUNT < deal_amount;

-- BRANDS WHICH GAVE MORE EQUITY THAN ORGINALLY PROPOSED. 
SELECT BRAND, INDUSTRY, OFFERED_EQUITY,DEAL_EQUITY FROM SHARK_DATA
WHERE OFFERED_EQUITY < DEAL_EQUITY;

-- BRANDS WHICH RECEIVED SAME VALUATION THAT REQUESTED.
SELECT BRAND, VALUATION_REQUESTED,DEAL_VALUATION FROM SHARK_DATA
WHERE VALUATION_REQUESTED = DEAL_VALUATION 
ORDER BY VALUATION_REQUESTED DESC;

-- BRANDS WHICH HAD NO REVENUE BEFORE RECIEVING OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED FROM SHARK_DATA
WHERE REVENUE = 0 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1;

-- BRANDS WHICH REVENUE, AND POSITIVE MARGIN BEFORE THEY RECEIVED OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED,GROSS_MARGIN,REVENUE,DEAL_AMOUNT FROM SHARK_DATA
WHERE REVENUE >= 1 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1;

-- BRANDS WHICH NEGATIVE REVENUE BEFORE THEY RECEIVED OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED,GROSS_MARGIN,REVENUE,DEAL_AMOUNT FROM SHARK_DATA
WHERE REVENUE < 0 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1

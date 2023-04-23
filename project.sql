SELECT * FROM `targetsql-384104.shark_tank.shark_tank ` LIMIT 1000;
-- Total number of episodes in each season
select count(epno) from `targetsql-384104.shark_tank.shark_tank `
group by season;

-- Total number of pitches in each season 1 = 152 and season 2 = 168
select season, count(distinct pitchno) from `targetsql-384104.shark_tank.shark_tank ` 
group by season;

-- Total number of pitches in each episode 
select season,epnum, count(pitchno)from `targetsql-384104.shark_tank.shark_tank `

group by epnum,season
order by count(pitchno);

-- Total of industries for investment max = food min = entertainment
  select industry, count(industry) from `targetsql-384104.shark_tank.shark_tank `
  group by industry
  order by count(industry) desc;

  -- Gender wise - total pitchers male (280), female(109), transgender(2) indsutrty wise
select industry, sum(male) male ,sum(female) female, sum(Transgender_Presenters) transgender
from `targetsql-384104.shark_tank.shark_tank `
group by industry;

-- Gender ratio
select round(sum(male)/sum(no_of_presenters),2) *100 male , floor(sum(female)/sum(no_of_presenters)*100) female,
round(sum(Transgender_Presenters)/sum(no_of_presenters),2)*100 transgender
from `targetsql-384104.shark_tank.shark_tank `;

-- Number of Offers Received in each season.
select season, sum(offer_received) received_offer from `targetsql-384104.shark_tank.shark_tank `
group by season;

-- Converserion rate industry wise

select season, industry, floor(sum(offer_received)/count(pitchno) *100) conversation_rate from `targetsql-384104.shark_tank.shark_tank `

group by season, industry;

-- Acceptance rate -
select season, industry, floor(sum(accepted_offer)/count(pitchno) *100) acceptance_rate from `targetsql-384104.shark_tank.shark_tank `

group by season,industry;

-- Total offers accepted 
select season,  sum(accepted_offer) from `targetsql-384104.shark_tank.shark_tank `
group by season;

-- State- wise pitches max - maharashtra
select state, count(brand) brand_count from `targetsql-384104.shark_tank.shark_tank `
group by state 
order by count(brand) desc;
 
-- City wise number of brands - 
select season, city, count(city) as max_brand_city from
(select season, city, count(brand) over (partition by city order by brand) as brand_count
from `targetsql-384104.shark_tank.shark_tank ` )t
group by season,city
order by count(city) desc
limit 15;

-- Max amount requested 
select season, floor(sum(ask_amount)) total_ask_amount from `targetsql-384104.shark_tank.shark_tank `
group by season
;

-- Least amount requested. 
select season,  floor(sum(valuation_requested)) requested_valuation from  `targetsql-384104.shark_tank.shark_tank `
group by season;

-- Offers rejected by the picthers
select  season , brand, Industry ,count(accepted_offer) rejected_offer from `targetsql-384104.shark_tank.shark_tank `
where accepted_offer = 0 or NULL
group by brand, season, industry ;

-- Deal done by sharks together. 
select season, industry, brand, deal_amount, deal_equity, no_sharks_deal from `targetsql-384104.shark_tank.shark_tank `
where no_sharks_deal > 1;

-- Sum of loan/debt 
select season, floor(sum(deal_amount)) total_invested_amount , sum(deal_equity) total_equity , sum(deal_debt) total_debt from 
`targetsql-384104.shark_tank.shark_tank `
group by season;

-- Top 3 investments - investment, equity andd debt
select season, rnk, industry, brand, deal_amount
from (select industry, brand, season,deal_amount, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_amount DESC) AS rnk
from `targetsql-384104.shark_tank.shark_tank `) t1
where 	rnk <= 3;

-- Top 3 equity
 select season, rnk, industry, brand , deal_equity
from (select industry, brand, season, deal_equity, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_equity DESC) AS rnk
from `targetsql-384104.shark_tank.shark_tank `) t1
where 	rnk <= 3
;
-- Top 3 debt 
 select season, rnk, industry, brand , deal_debt
from (select industry, brand, season, deal_debt, DENSE_RANK () OVER ( PARTITION BY  season ORDER BY deal_debt DESC) AS rnk
from `targetsql-384104.shark_tank.shark_tank `) t1
where 	rnk <= 3
;

-- Which shark invested the most in both season.

select season, ashneer investor, floor(sum(column_value)) as total_invested from
(SELECT season, 'ashneer_investment_amount' AS ashneer, ashneer_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'namita_investment_amount' AS namita, namita_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'vineeta_investment_amount' AS vineeta, vineeta_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'anupam_investment_amount' AS anupam, anupam_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'aman_investment_amount' AS aman, aman_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'amit_investment_amount' AS amit, amit_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `
UNION ALL
SELECT season, 'ghazal_investment_amount' AS ghazal, ghazal_investment_amount AS column_value
FROM `targetsql-384104.shark_tank.shark_tank `) t1
group by season, ashneer
order by total_invested desc;

-- NO. OF COMPANIES INVESTED BY THE INVESTORS INDIVIUALLLY IN BOTH THE SEASONS.

select season, investor, industry, sum(total_count) as count_brand_investment, floor(sum(total)) as total_brand_investment from
(select season, investor, industry, sum(count_sum) as total_count, sum(column_value) as total from
(select season, investor,brand,count(brand) as count_sum, column_value, industry from 
(select season,brand,industry,'ashneer_investment_amount' as investor, ashneer_investment_amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Ashneer_Investment_Amount > 0
union all
select season,brand,industry,'Namita_Investment_Amount' as investor, Namita_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Namita_Investment_Amount > 0
union all
select season,brand,industry,'Anupam_Investment_Amount' as investor, Anupam_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `  
where Anupam_Investment_Amount > 0
union all
select season,brand,industry,'Vineeta_Investment_Amount' as investor, Vineeta_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Vineeta_Investment_Amount > 0
union all
select season,brand,industry,'Aman_Investment_Amount' as investor, Aman_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Aman_Investment_Amount > 0
union all
select season,brand,industry,'Peyush_Investment_Amount' as investor, Peyush_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Peyush_Investment_Amount > 0
union all
select season,brand,industry,'Ghazal_Investment_Amount' as investor, Ghazal_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Ghazal_Investment_Amount > 0
union all
select season,brand,industry,'Amit_Investment_Amount' as investor, Amit_Investment_Amount as column_value from `targetsql-384104.shark_tank.shark_tank `
where Amit_Investment_Amount > 0) t1
group by season ,investor, brand, Industry,column_value) t2
group by season, industry, investor,column_value) t3
group by season, industry, investor;

--  Investors wise investment in brands, type, amount, equity [ASHNEER]
select season, brand, industry, ashneer_investment_amount, ashneer_investment_equity, Ashneer__debt_amount from `targetsql-384104.shark_tank.shark_tank `
where Ashneer_Investment_Amount >=1;

-- Investors wise investment in brands, type, amount, equity [NAMITA]
select season, brand, industry, Namita_Investment_Amount, Namita_Investment_Equity, Namita_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Namita_Investment_Amount >=1;

--  Investors wise investment in brands, type, amount, equity [ANUPAM]
select season, brand, industry, Anupam_Investment_Amount, Anupam_Investment_Equity, Anupam_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Anupam_Investment_Amount >= 1;

--  Investors wise investment in brands, type, amount, equity [VINEETA]
select season, brand, industry, Vineeta_Investment_Amount, Vineeta_Investment_Equity, Vineeta_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Vineeta_Investment_Amount >=1;

--  Investors wise investment in brands, type, amount, equity [AMAN]
select season, brand, industry, Aman_Investment_Amount, Aman_Investment_Equity, Aman_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Aman_Investment_Amount >=1
ORDER BY Aman_Investment_Amount DESC;

--  Investors wise investment in brands, type, amount, equity [PEYUSH]  
select season, brand, industry, Peyush_Investment_Amount, Peyush_Investment_Equity, Peyush_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Peyush_Investment_Amount >=1;

--  Investors wise investment in brands, type, amount, equity [GHAZAL]
select season, brand, industry, Ghazal_Investment_Amount, Ghazal_Investment_Equity, Ghazal_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Ghazal_Investment_Amount >=1;

--  Investors wise investment in brands, type, amount, equity [AMIT]
select season, brand, industry, Amit_Investment_Amount, Amit_Investment_Equity, Aman_Debt_Amount from `targetsql-384104.shark_tank.shark_tank `
where Amit_Investment_Amount >=1;

-- PITCHERS AGE
SELECT SEASON,SUM(No_of_Presenters), PITCHERS_AVERAGE_AGE FROM `targetsql-384104.shark_tank.shark_tank `
GROUP BY SEASON,Pitchers_Average_Age;

-- YEAR OF FOUNDATION OF BRANDS
SELECT SEASON, STARTED, COUNT(BRAND) AS FOUNDATION_YEAR_COUNT FROM `targetsql-384104.shark_tank.shark_tank `
GROUP BY SEASON, STARTED
ORDER BY FOUNDATION_YEAR_COUNT DESC;

-- YEAR OF FOUNDATION OF BRANDS
SELECT SEASON, STARTED, COUNT(BRAND) AS FOUNDATION_YEAR_COUNT FROM `targetsql-384104.shark_tank.shark_tank `
GROUP BY SEASON, STARTED
ORDER BY FOUNDATION_YEAR_COUNT DESC;

-- BRANDS WHICH RECEIVED MORE INVESTMENT THAN ASKED
SELECT BRAND, Industry,ask_amount,deal_amount FROM `targetsql-384104.shark_tank.shark_tank `
WHERE ASK_AMOUNT < deal_amount;

-- BRANDS WHICH GAVE MORE EQUITY THAN ORGINALLY PROPOSED. 
SELECT BRAND, INDUSTRY, OFFERED_EQUITY,DEAL_EQUITY FROM `targetsql-384104.shark_tank.shark_tank `
WHERE OFFERED_EQUITY < DEAL_EQUITY;

-- BRANDS WHICH RECEIVED SAME VALUATION THAT REQUESTED.
SELECT BRAND, VALUATION_REQUESTED,DEAL_VALUATION FROM `targetsql-384104.shark_tank.shark_tank `
WHERE VALUATION_REQUESTED = DEAL_VALUATION 
ORDER BY VALUATION_REQUESTED DESC;

-- BRANDS WHICH HAD NO REVENUE BEFORE RECIEVING OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED FROM `targetsql-384104.shark_tank.shark_tank `
WHERE REVENUE = 0 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1;

-- BRANDS WHICH REVENUE, AND POSITIVE MARGIN BEFORE THEY RECEIVED OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED,GROSS_MARGIN,REVENUE,DEAL_AMOUNT FROM `targetsql-384104.shark_tank.shark_tank `
WHERE REVENUE >= 1 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1;

-- BRANDS WHICH NEGATIVE REVENUE BEFORE THEY RECEIVED OFFERS.
SELECT BRAND,INDUSTRY,BUSINESS,STARTED,GROSS_MARGIN,REVENUE,DEAL_AMOUNT FROM `targetsql-384104.shark_tank.shark_tank `
WHERE REVENUE < 0 AND OFFER_RECEIVED = 1 AND ACCEPTED_OFFER = 1






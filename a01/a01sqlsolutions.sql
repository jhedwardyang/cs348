-- QUERY 1:
-- A customer wants to know what parts are available between the sizes of 43 through 47
-- (including 43 and 47) of brand 'Brand#42'. Write a query to retrieve all such parts. The
-- output should have a single column p_name, and is ordered by p_name.

SELECT P_NAME FROM PART WHERE P_SIZE >= 43 AND P_SIZE <=47 AND P_BRAND = 'Brand#42' ORDER BY P_NAME;

-- QUERY 2:
-- The collection team in our Canadian office wants to know the custkeys, names and phone
-- numbers of all local customers that owe us money so that they can harass these customers
-- over the phone. Write a query that will retrieve all custkeys, names, and phone numbers
-- of customers in the nation of ‘CANADA’ that have an account balance strictly less than
-- zero. The output should have the column names: c_custkey, c_name, c_phone and is
-- sorted in this order.

SELECT C_CUSTKEY, C_NAME, C_PHONE 
FROM CUSTOMER INNER JOIN NATION ON C_NATIONKEY = N_NATIONKEY 
WHERE N_NAME = 'CANADA' AND C_ACCTBAL < 0
ORDER BY C_CUSTKEY, C_NAME, C_PHONE;

-- QUERY 3:
-- Management wants to improve client relations, with both customers and suppliers, who
-- trust us the most. They want a list of all names and phone numbers belonging to either
-- customers that have an account balance strictly greater than 9975 or suppliers that have
-- an account balance strictly greater than 9500. Write a single statement to retrieve these
-- required names and phone numbers. The output should have the column names: name,
-- phone and and is sorted in this order.

SELECT C_NAME AS name, C_PHONE AS phone FROM CUSTOMER WHERE C_ACCTBAL > 9975 
UNION 
SELECT S_NAME, S_PHONE FROM SUPPLIER WHERE S_ACCTBAL > 9500
ORDER BY name, phone;

--QUERY 4:
-- Management wants to know which countries are well represented by our network of
-- suppliers. Write a statement to list the name of each nation that contains at least two
-- different suppliers.

SELECT DISTINCT N_NAME FROM SUPPLIER S1, SUPPLIER S2, NATION WHERE S1.S_SUPPKEY <> S2.S_SUPPKEY AND S1.S_NATIONKEY=N_NATIONKEY AND S2.S_NATIONKEY=N_NATIONKEY

-- Alternate, but can't be expressed in relational algebra:
SELECT N_NAME
FROM NATION, SUPPLIER
WHERE N_NATIONKEY = S_NATIONKEY
GROUP BY N_NAME
HAVING COUNT(N_NAME) >= 2;

-- QUERY 5:
-- For each region and for each nation located in that region, list the region name and nation
-- name. For regions not containing a nation, the output should contain a single tuple with
-- the region name and a NULL nation name. The output should consist of the column
-- names: region, nation and is ordered by these columns.

SELECT R_NAME AS region, N_NAME as nation FROM REGION LEFT JOIN NATION ON R_REGIONKEY = N_REGIONKEY 
ORDER BY R_NAME, N_NAME

-- QUERY 6:
-- Management is concerned about the sheer number of customers who open an account
-- using our website, but never buy anything. They want to know how many such customers
-- exist in our database. Retrieve a single tuple with a single attribute (named ‘Total’) which
-- will represent the total number of customers in our database that have never placed an
-- order.

SELECT COUNT(*) AS Total FROM CUSTOMER WHERE C_CUSTKEY NOT IN (SELECT O_CUSTKEY FROM ORDERS);

-- QUERY 7:
-- Management wants to ensure that our best customer in every country is taken care of by
-- specially trained customer representatives. For each nation list the nation name, customer
-- name and the largest account balance of the customer located in that nation. For this
-- question you can assume that every nation contains at least one customer that has at least
-- one order.
select N_NAME AS nation_name, c_name, C_ACCTBAL as acct_balance
from CUSTOMER C, NATION N
where C_NATIONKEY = N_NATIONKEY 
AND C_ACCTBAL = (SELECT max(C_ACCTBAL) from CUSTOMER D where C.C_NATIONKEY = D.C_NATIONKEY)
order by nation_name, c_name, acct_balance;


-- QUERY 8:
-- For each nation, list the nation key, nation name, the number of orders placed by
-- customers living in that nation, and the cumulative price for all of those orders cast as a
-- DECIMAL(13,2). The result should have the column names : n_key, n_name,
-- num_orders, cum_price and is ordered by descending cumulative order price
-- (cum_price).

-- SOLUTION A (NOT PERFECT, LOSES NATIONS WITHOUT ANY CUSTOMERS, OR
--              WITH CUSTOMERS BUT NO ORDERS)

SELECT N_NATIONKEY as n_key, N_NAME, 
        COUNT(*) NUMORDERS,
        CAST(SUM(O_TOTALPRICE) AS DECIMAL(13,2)) CUMPRICE
FROM NATION, CUSTOMER, ORDERS
WHERE N_NATIONKEY = C_NATIONKEY
AND C_CUSTKEY = O_CUSTKEY
GROUP BY N_NATIONKEY, N_NAME
ORDER BY CUMPRICE DESC;

-- SOLUTION B (BETTER) - gets all nations, but includes NULL instead of zero

SELECT N_NATIONKEY as n_key, N_NAME, 
        COUNT(O_ORDERKEY) NUMORDERS,
        CAST(SUM(O_TOTALPRICE) AS DECIMAL(13,2)) CUMPRICE
FROM NATION LEFT OUTER JOIN CUSTOMER
                ON N_NATIONKEY = C_NATIONKEY
            LEFT OUTER JOIN ORDERS
                ON C_CUSTKEY = O_CUSTKEY
GROUP BY N_NATIONKEY, N_NAME
ORDER BY CUMPRICE DESC;

-- EB - SOLUTION C - Replaces NULL results with 0, gets all countries, only one outer join
SELECT N_NATIONKEY as n_key, N_NAME, IFNULL(NUM_ORDERS, 0) NUMORDERS, IFNULL(TOTPRICE, 0) CUMPRICE
FROM NATION N
LEFT JOIN
(SELECT C_NATIONKEY, COUNT(*)  NUM_ORDERS, CAST(SUM(O_TOTALPRICE) AS DECIMAL(13,2)) TOTPRICE
FROM ORDERS, CUSTOMER
WHERE O_CUSTKEY = C_CUSTKEY
GROUP BY C_NATIONKEY) OT
ON N.N_NATIONKEY = OT.C_NATIONKEY
ORDER BY CUMPRICE DESC;

-- QUERY 9:
-- The management team wants a list of nations whose sales have been under-performing.
-- Print out the list of nation names along with the total number of orders placed by
-- customers from those nations but only for nations that have below average number of
-- orders compared to all nations.


-- Steps:   1 Get Average orders by nation
--          2 Query as with 8 to get orders by nation < average
-- Issue: divide by zero if we have no nations

SELECT N_NATIONKEY as n_key, N_NAME, IFNULL(NUM_ORDERS, 0) NUM_ORDERS, IFNULL(TOTPRICE, 0) CUM_PRICE
    FROM NATION N
LEFT JOIN
    (SELECT C_NATIONKEY, COUNT(*)  NUM_ORDERS, CAST(SUM(O_TOTALPRICE) AS DECIMAL(13,2)) TOTPRICE
        FROM ORDERS, CUSTOMER
        WHERE O_CUSTKEY = C_CUSTKEY
        GROUP BY C_NATIONKEY) OT
ON N.N_NATIONKEY = OT.C_NATIONKEY
HAVING NUM_ORDERS < (SELECT (SELECT COUNT(*) FROM ORDERS) / (SELECT COUNT(*) FROM NATION));

-- QUERY 10
-- For each customer market segment, list the:
-- 1. market segment
-- 2. cumulative (total) order price for orders of status 'F' made by customers in that
-- market segment
-- 3. cumulative (total) order price for orders of status 'O' made by customers in that
-- market segment
-- 4. cumulative (total) order price for orders of status 'P' made by customers in that
-- market segment
-- The totals should be cast as DECIMAL(13,2) and the output should consist of column
-- names: c_mktsegment, total_F, total_O, and total_P, respectively. Order the result by
-- c_mktsegment.

SELECT C_MKTSEGMENT, 
                MAX(CASE WHEN O_STATUS = 'F' THEN TOTAL ELSE NULL END) AS TOTAL_F,
                MAX(CASE WHEN O_STATUS = 'O' THEN TOTAL ELSE NULL END) AS TOTAL_O,
                MAX(CASE WHEN O_STATUS = 'P' THEN TOTAL ELSE NULL END) AS TOTAL_P
        FROM   (SELECT C.C_MKTSEGMENT,
                O.O_ORDERSTATUS     AS O_STATUS, 
                CAST(SUM(O.O_TOTALPRICE) AS DECIMAL(13,2)) AS TOTAL 
        FROM   CUSTOMER C LEFT OUTER JOIN ORDERS O 
        ON  O.O_CUSTKEY  = C.C_CUSTKEY 
        GROUP BY C.C_MKTSEGMENT, O.O_ORDERSTATUS) AS ORDER_TOTALSA 
        GROUP BY C_MKTSEGMENT
        ORDER BY C_MKTSEGMENT;


-- EB - Simplified, no subqueries
SELECT C_MKTSEGMENT, 
    CAST(SUM(CASE WHEN O_ORDERSTATUS = 'F' THEN O_TOTALPRICE ELSE 0 END) AS DECIMAL(13,2)) AS TOTAL_F,
    CAST(SUM(CASE WHEN O_ORDERSTATUS = 'O' THEN O_TOTALPRICE ELSE 0 END) AS DECIMAL(13,2)) AS TOTAL_O,
    CAST(SUM(CASE WHEN O_ORDERSTATUS = 'P' THEN O_TOTALPRICE ELSE 0 END) AS DECIMAL(13,2)) AS TOTAL_P
FROM   CUSTOMER C
LEFT JOIN ORDERS O
    ON  C.C_CUSTKEY = O.O_CUSTKEY 
GROUP BY C.C_MKTSEGMENT
ORDER BY C_MKTSEGMENT;
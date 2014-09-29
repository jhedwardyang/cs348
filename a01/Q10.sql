# Edward Yang, Fall 2014 - CS348
# A01 Q10
# For each customer market segment, list the:
# 1. market segment
# 2. cumulative order price for orders of status 'F' made by customers in that market segment
# 3. cumulative order price for orders of status 'O' made by customers in that market segment
# 4. cumulative order price for orders of status 'P' made by customers in that market segment
# The cumulative order prices should be cast as DECIMAL(11,2) and given the output names total_F, total_O, and total_P, respectively. Order the result by market segment.
# Hint: Try to use the divide and conquer approach and think of dividing the task into smaller tasks. Then use the results as intermediate tables to build a larger query! Note that this is a difficult question and there are many ways of handling this task. You are free to read up on external resources and utilize SQL commands/syntax not taught in the course. Part of this exercise is for you to discover the most suitable approach and method available in SQL to generate the report requested.

SELECT t.mktsegment c_mktsegment, # select the market segment
SUM(CASE WHEN (t.orderstatus = 'F') THEN t.sum ELSE 0 END) as total_F, # if orderstatus = 'F', sum it here
SUM(CASE WHEN (t.orderstatus = 'O') THEN t.sum ELSE 0 END) as total_O, # if orderstatus = 'O', sum it here
SUM(CASE WHEN (t.orderstatus = 'P') THEN t.sum ELSE 0 END) as total_P # if orderstatus = 'P', sum it here
# table t is designed to group each of customers orders into market segment
FROM (
	SELECT o.o_custkey, o.o_orderstatus orderstatus, CAST(SUM(o.o_totalprice) AS DECIMAL(11,2)) sum, c.c_custkey, c.c_mktsegment mktsegment
	FROM ORDERS o # get all orders
	JOIN CUSTOMER c # joined to customers
	ON o.o_custkey = c.c_custkey # on foreignkey custkey
	JOIN NATION n # joined to nations
	ON c.c_nationkey = n.n_nationkey # on foreign key nationkey
	GROUP BY o.o_custkey, o.o_orderstatus, c.c_mktsegment # group by multiple categories (custkey, orderstatus, mktsegment)
) t
GROUP BY t.mktsegment
ORDER BY c_mktsegment ASC
;
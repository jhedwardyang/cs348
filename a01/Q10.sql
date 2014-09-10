# Edward Yang, Fall 2014 - CS348
# A01 Q10
# For each customer market segment, list the:
# 1. market segment
# 2. cumulative order price for orders of status 'F' made by customers in that market segment
# 3. cumulative order price for orders of status 'O' made by customers in that market segment
# 4. cumulative order price for orders of status 'P' made by customers in that market segment
# The cumulative order prices should be cast as DECIMAL(11,2) and given the output names total_F, total_O, and total_P, respectively. Order the result by market segment.
# Hint: Try to use the divide and conquer approach and think of dividing the task into smaller tasks. Then use the results as intermediate tables to build a larger query! Note that this is a difficult question and there are many ways of handling this task. You are free to read up on external resources and utilize SQL commands/syntax not taught in the course. Part of this exercise is for you to discover the most suitable approach and method available in SQL to generate the report requested.

SELECT t2.c_nationkey, t2.n_name,
SUM(CASE WHEN (t2.o_orderstatus = 'F') THEN t2.sum ELSE 0 END) as total_F,
SUM(CASE WHEN (t2.o_orderstatus = 'O') THEN t2.sum ELSE 0 END) as total_O,
SUM(CASE WHEN (t2.o_orderstatus = 'P') THEN t2.sum ELSE 0 END) as total_P
FROM
(
	SELECT SUM(t.sum) sum, t.c_nationkey, t.o_orderstatus, t.n_name
	FROM
	(
		SELECT o.o_custkey, o.o_orderstatus, SUM(o.o_totalprice) sum, c.c_custkey, c.c_nationkey, n.n_name
		FROM ORDERS o
		JOIN CUSTOMER c
		ON o.o_custkey = c.c_custkey
		JOIN NATION n
		ON c.c_nationkey = n.n_nationkey
		GROUP BY o.o_custkey, o.o_orderstatus
	) t
	GROUP BY t.o_orderstatus, t.c_nationkey
) t2
GROUP BY t2.t2.c_nationkey
;
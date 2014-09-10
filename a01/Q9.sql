# Edward Yang, Fall 2014 - CS348
# A01 Q09
# The management team wants a list of nations whose sales have been underperforming. Print out the list of nation names along with the total number of orders placed by customers from those nations but only for nations that have below average number of orders compared to all other nations.
# Note: You may not hard code the average number of orders per nation in the query! Your query must find the average number of orders per nation and then compare it to the totals for each nation to create a list of nations underperforming the average sales figure.
# Hint: You should first write a query that finds out the average number of sales per nation. Then wrap it in a larger query to get the final answer.

SELECT SUM(c) sum, n.n_nationkey
FROM (
	SELECT o.o_custkey, COUNT(*) c, c.c_nationkey
	FROM ORDERS o
	JOIN CUSTOMER c
	ON o.o_custkey = c.c_custkey
	GROUP BY o.o_custkey
) t
JOIN NATION n
ON t.c_nationkey = n.n_nationkey
GROUP BY t.c_nationkey
HAVING sum > (
	SELECT AVG(t2.sum)
	FROM (
		SELECT SUM(c) sum, n.n_nationkey
		FROM (
			SELECT o.o_custkey, COUNT(*) c, c.c_nationkey
			FROM ORDERS o
			JOIN CUSTOMER c
			ON o.o_custkey = c.c_custkey
			GROUP BY o.o_custkey
		) t
		JOIN NATION n
		ON t.c_nationkey = n.n_nationkey
		GROUP BY t.c_nationkey
	) t2
)
;
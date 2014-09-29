# Edward Yang, Fall 2014 - CS348
# A01 Q09
# The management team wants a list of nations whose sales have been underperforming. Print out the list of nation names along with the total number of orders placed by customers from those nations but only for nations that have below average number of orders compared to all other nations.
# Note: You may not hard code the average number of orders per nation in the query! Your query must find the average number of orders per nation and then compare it to the totals for each nation to create a list of nations underperforming the average sales figure.
# Hint: You should first write a query that finds out the average number of sales per nation. Then wrap it in a larger query to get the final answer.

# Strategy: Find the average number of orders per nation in a subquery then use that in the HAVING clause

SELECT n.n_name nation_name, SUM(c) total_orders # select count, nationkey
FROM ( # from subquery
	SELECT o.o_custkey, COUNT(*) c, c.c_nationkey # get all custkeys, with total order count, and nationkey
	FROM ORDERS o # orders
	JOIN CUSTOMER c # customers
	ON o.o_custkey = c.c_custkey # on foreign key custkey
	GROUP BY o.o_custkey # grouped by their cust key
) t
JOIN NATION n # joined on nation table
ON t.c_nationkey = n.n_nationkey # on foreign key
GROUP BY t.c_nationkey # grouped by the nation key
HAVING total_orders < ( # where the count of the nations orders if greator than
	SELECT AVG(t2.count) # average of all count
	FROM (
		SELECT SUM(c) count, n.n_nationkey # number of all orders
		FROM (
			SELECT o.o_custkey, COUNT(*) c, c.c_nationkey
			FROM ORDERS o
			JOIN CUSTOMER c
			ON o.o_custkey = c.c_custkey
			GROUP BY o.o_custkey # grouped by custkey
		) t
		JOIN NATION n
		ON t.c_nationkey = n.n_nationkey
		GROUP BY t.c_nationkey # then grouped by nationkey
	) t2
)
ORDER BY nation_name, total_orders ASC
;	
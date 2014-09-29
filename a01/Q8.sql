# Edward Yang, Fall 2014 - CS348
# A01 Q08
# For each nation, list the nation key, nation name, the number of orders placed by customers living in that nation, and the cumulative price for all of those orders cast as a DECIMAL(11,2). Order the result by descending cumulative order price.

SELECT n.n_nationkey n_key, n.n_name, COUNT(t.t_count) num_orders, SUM(t.t_totalprice) cum_price # select nation key, nation name, count of orders, total cumulative price of orders
FROM ( # from a temp table
	SELECT c.c_custkey t_custkey, COUNT(o.o_totalprice) t_count, CAST(SUM(o.o_totalprice) AS DECIMAL(11,2)) t_totalprice, c.c_nationkey t_nationkey # which returns customerkey, number of orders and price which that customer spent and which nation they are from
	FROM ORDERS o # to get this from orders table (alias o)
	JOIN CUSTOMER c # joined on customer table (alias c)
	ON o.o_custkey = c.c_custkey # match on foreign key custkey
	GROUP BY o.o_custkey # group them by the customer
) t # call the table t
JOIN NATION n # join the nation table
ON n.n_nationkey = t.t_nationkey # on foreign key nationkey
GROUP BY n.n_nationkey # group the customers by their nationkey
ORDER BY cum_price DESC # order by the total value descending
;
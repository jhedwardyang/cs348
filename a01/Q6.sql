# Edward Yang, Fall 2014 - CS348
# A01 Q06
# Management is concerned about the sheer number of customers who open an account using our website, but never buy anything. They want to know how many such customers exist in our database. Retrieve a single tuple with a single attribute (named ‘Total’) which will represent the total number of customers in our database that have never placed an order.

# Strategy: Design an intermediary query which returns all the customers who have not purchased anything. Left join will ensure 0 orders will be included. The exterier query can then just count them. Remember to alias the column.

SELECT COUNT(*) 'Total' FROM # select the count (alias 'Total')
( #  from a inner query
	SELECT c.c_custkey # select the customer keys
	FROM CUSTOMER c # from the table customer (alias c)
	LEFT OUTER JOIN ORDERS o # joined onto the orders table
	ON c.c_custkey = o.o_custkey # on the foreign key custkey
	GROUP BY c_custkey # grouped by the customer key
	HAVING COUNT(o.o_custkey) = 0 # where the customer has 0 orders
) counts # (alias to counts) required since inner query, has no use in this query
;
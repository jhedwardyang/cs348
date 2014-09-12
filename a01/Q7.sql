# Edward Yang, Fall 2014 - CS348
# A01 Q07
# Management wants to ensure that our best customer in every country is taken care of by specially trained customer representatives. For each nation list the nation name, customer name and the largest account balance of the customer located in that nation. For this question you can assume that every nation contains at least one customer that has at least one order.
# In your physical submission explain whether your solution will work when the assumption that every nation contains at least one customer that has at least one order is taken away.

# Strategy: Generate an intermediate query which will find the maximum balance per nation. Ensure that you use the proper RIGHT join in case there is no customer in that nation. Afterwards find that customer and LEFT join to ensure no customer case. Afterwards find the customer with that maximum balance. :) 

SELECT t.nationname, c.c_name, t.maxacctbal # select nation name, customer name, max account balance
FROM 
( # inner table
	SELECT c_nationkey nationkey, MAX(c_acctbal) maxacctbal, n.n_name nationname # select nationkey, maximum account balance, nation name
	FROM CUSTOMER c # from customer table (alias c)
	RIGHT OUTER JOIN NATION n # right joined on nation table (alias n), RIGHT JOIN permits the NULL result when a nation doesn't have any customers
	ON n.n_nationkey = c.c_nationkey # on foreign key nationkey
	GROUP BY c_nationkey # grouped by nationkeys
) t # temporary table alias as t
LEFT OUTER JOIN CUSTOMER c # join temp table on customer table (alias c), LEFT JOIN permits the NULL results from above to continue being used
ON t.maxacctbal = c.c_acctbal # find the customer with the maximum account balance that we found earlier
;

# Part 2: My solution DOES work in the case that there is no customers due to the appropriate use of LEFT/RIGHT JOINs
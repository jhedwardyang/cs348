# Edward Yang, Fall 2014 - CS348
# A01 Q07
# Management wants to ensure that our best customer in every country is taken care of by specially trained customer representatives. For each nation list the nation name, customer name and the largest account balance of the customer located in that nation. For this question you can assume that every nation contains at least one customer that has at least one order.
# In your physical submission explain whether your solution will work when the assumption that every nation contains at least one customer that has at least one order is taken away.

# Strategy: Generate an intermediate query which will find the maximum balance per nation. Ensure that you use the proper RIGHT join in case there is no customer in that nation. Afterwards find that customer and LEFT join to ensure no customer case. Afterwards find the customer with that maximum balance. :) 

SELECT n.n_name nation_name, c.c_name, MAX(c.c_acctbal) acct_balance # get the nation, name and account balance
FROM NATION n # from table nation
LEFT JOIN CUSTOMER c # joined onto customer c
ON n.n_nationkey = c.c_nationkey # on foreign key
GROUP BY n.n_nationkey # group by nationkey
ORDER BY nation_name, c.c_name, acct_balance # order by
;

# Part 2: My solution DOES work in the case that there is no customers due to the appropriate use of LEFT/RIGHT JOINs
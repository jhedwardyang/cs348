# Edward Yang, Fall 2014 - CS348
# A01 Q05
# For each region and for each nation located in that region, list the region name and nation name. For regions not containing a nation, the output should contain a single tuple with the region name and a NULL nation name. Order the result by region name, nation name.

# Strategy: Simple JOIN statement between region and nation. By adding a left on the join, it'll automatically add even if nation is NULL.

SELECT r.r_name, n.n_name # select the region name and nation name
FROM REGION r # from the region table (alias r)
LEFT OUTER JOIN NATION n # joined on the nation table (alias n), LEFT OUTER JOIN forces the NULL result if no nations are in a region
ON r.r_regionkey = n.n_regionkey # match the foreign keys
ORDER BY r.r_name, n.n_name ASC # order by region name, then nation name alphabetically
;
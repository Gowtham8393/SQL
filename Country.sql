SELECT 
    c1.country AS team_a,
    c2.country as team_b
FROM 
    dbt_tgt.tgt."countries" c1
JOIN 
    dbt_tgt.tgt."countries" c2
    ON c1.country < c2.country
ORDER BY 
    team_a, team_b;

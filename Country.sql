--- to select cricket team and play against each country once 

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

create or replace table "DBT_TGT"."TGT"."countries"
(country varchar(200));
select country as team_a from dbt_tgt.tgt."countries";

INSERT INTO "DBT_TGT"."TGT"."countries"  
VALUES 
('India'),
('Pakistan'),
('Srilanka'),
('Japan'),
('Australia'),
('America');

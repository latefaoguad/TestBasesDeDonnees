-- "latefa-hafida.oguad.1@ens.etsmtl.ca".score source

CREATE OR REPLACE VIEW "latefa-hafida.oguad.1@ens.etsmtl.ca".score
AS SELECT c.id,
    c.url,
    c.title,
    c.lang,
    c.last_crawled,
    c.last_updated,
    c.last_updated_date,
    c.md5hash,
        CASE
            WHEN length(h.content) = 0 THEN 0.0::double precision
            ELSE percent_rank() OVER (ORDER BY (length(h.content)))
        END AS score
   FROM louis_v005.crawl c
     LEFT JOIN louis_v005.html_content h ON c.md5hash = h.md5hash;
     
 --afficher les resultats de la vue score
select * from "latefa-hafida.oguad.1@ens.etsmtl.ca".score;
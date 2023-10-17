drop FUNCTION "latefa-hafida.oguad.1@ens.etsmtl.ca".recherche(text);
CREATE OR REPLACE FUNCTION "latefa-hafida.oguad.1@ens.etsmtl.ca".recherche(keyword text)
    RETURNS TABLE (
        url text,
        title text,
        score float8 
    ) AS $$
    BEGIN
        -- Sélectionner les résultats de la requête directement dans la table de résultat
        RETURN QUERY
        SELECT s.url, s.title, s.score
        FROM "latefa-hafida.oguad.1@ens.etsmtl.ca".score s
        WHERE s.title ILIKE '%' || keyword || '%'
        ORDER BY s.score DESC
        LIMIT 10;
    END;
$$ LANGUAGE plpgsql;


--exemple utilisation fonction recherche 
select * from  "latefa-hafida.oguad.1@ens.etsmtl.ca".recherche('canada');
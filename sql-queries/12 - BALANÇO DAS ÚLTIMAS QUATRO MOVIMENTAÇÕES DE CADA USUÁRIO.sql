WITH ultimas_4_transacoes AS (
    SELECT 
        t.*,
        ROW_NUMBER() OVER (PARTITION BY t.CD_CLIENTE ORDER BY t.DT_TRANSACAO DESC) AS row_numbers
    FROM TbTransacoes t
),
balanco_calculado AS (
    SELECT 
        CD_CLIENTE,
        VR_TRANSACAO,
        CASE 
            WHEN CD_TRANSACAO = 110 THEN VR_TRANSACAO  -- Cash in (110) - Somar
            WHEN CD_TRANSACAO = 220 THEN -VR_TRANSACAO  -- Cashout (220) - Subtrair
            WHEN CD_TRANSACAO = 0 THEN VR_TRANSACAO  -- Cashback (000) - Somar
            ELSE 0  
        END AS BALANCO
    FROM ultimas_4_transacoes
    WHERE row_numbers <= 4
)
SELECT 
    CD_CLIENTE,
    SUM(BALANCO) AS BALANCO_ULTIMAS_4
FROM balanco_calculado
GROUP BY CD_CLIENTE
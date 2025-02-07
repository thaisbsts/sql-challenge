WITH transacoes_com_mes AS (
    SELECT 
        CD_TRANSACAO, 
        VR_TRANSACAO, 
        DATE_FORMAT(DT_TRANSACAO, '%Y-%m') AS ANO_MES
    FROM TbTransacoes
),
cash_in AS (
    SELECT 
        ANO_MES, 
        SUM(VR_TRANSACAO) AS SOMA_CASH_IN
    FROM transacoes_com_mes
    WHERE CD_TRANSACAO = 110
    GROUP BY ANO_MES
),
cash_out AS (
    SELECT 
        ANO_MES, 
        SUM(VR_TRANSACAO) AS SOMA_CASH_OUT
    FROM transacoes_com_mes
    WHERE CD_TRANSACAO = 220
    GROUP BY ANO_MES
)

-- Simulando o FULL OUTER JOIN com LEFT JOIN e RIGHT JOIN
SELECT 
    COALESCE(ci.ANO_MES, co.ANO_MES) AS ANO_MES,
    COALESCE(SOMA_CASH_IN, 0) AS SOMA_CASH_IN,
    COALESCE(SOMA_CASH_OUT, 0) AS SOMA_CASH_OUT,
    COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0) AS TOTAL,
    (COALESCE(SOMA_CASH_IN, 0) / NULLIF(COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0), 0) * 100) AS PERCENTUAL_CASH_IN,
    (COALESCE(SOMA_CASH_OUT, 0) / NULLIF(COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0), 0) * 100) AS PERCENTUAL_CASH_OUT
FROM cash_in ci
LEFT JOIN cash_out co ON ci.ANO_MES = co.ANO_MES

UNION

SELECT 
    COALESCE(ci.ANO_MES, co.ANO_MES) AS ANO_MES,
    COALESCE(SOMA_CASH_IN, 0) AS SOMA_CASH_IN,
    COALESCE(SOMA_CASH_OUT, 0) AS SOMA_CASH_OUT,
    COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0) AS TOTAL,
    (COALESCE(SOMA_CASH_IN, 0) / NULLIF(COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0), 0) * 100) AS PERCENTUAL_CASH_IN,
    (COALESCE(SOMA_CASH_OUT, 0) / NULLIF(COALESCE(SOMA_CASH_IN, 0) + COALESCE(SOMA_CASH_OUT, 0), 0) * 100) AS PERCENTUAL_CASH_OUT
FROM cash_out co
LEFT JOIN cash_in ci ON ci.ANO_MES = co.ANO_MES

ORDER BY ANO_MES;

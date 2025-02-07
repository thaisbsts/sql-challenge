CREATE VIEW vw_saldo_acumulado AS
WITH saldo_acumulado AS (
    SELECT
        CD_CLIENTE,
        DT_TRANSACAO,
        VR_TRANSACAO,
        CD_TRANSACAO,
        SUM(CASE 
                WHEN CD_TRANSACAO = '000' THEN VR_TRANSACAO
                WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO
                WHEN CD_TRANSACAO = '220' THEN -VR_TRANSACAO
                ELSE 0 
            END) OVER (PARTITION BY CD_CLIENTE ORDER BY DT_TRANSACAO) AS SALDO_ACUMULADO
    FROM
        TbTransacoes
),
last_saldo AS (
    SELECT 
        CD_CLIENTE,
        SALDO_ACUMULADO,
        ROW_NUMBER() OVER (PARTITION BY CD_CLIENTE ORDER BY DT_TRANSACAO DESC) AS row_num
    FROM saldo_acumulado
)
SELECT
    CD_CLIENTE,
    SALDO_ACUMULADO AS LAST_SALDO_ACUMULADO
FROM
    last_saldo
WHERE
    row_num = 1;

SELECT * FROM vw_saldo_acumulado;
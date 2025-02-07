WITH clientes_com_saldo_maior_que_100 AS (
    SELECT CD_CLIENTE
    FROM vw_saldo_acumulado
    WHERE LAST_SALDO_ACUMULADO > 100
),
transacoes_mais_antiga_mais_recente AS (
    SELECT 
        t.CD_CLIENTE,
        MIN(t.DT_TRANSACAO) AS DATA_TRANSACAO_ANTIGA,
        MAX(t.DT_TRANSACAO) AS DATA_TRANSACAO_RECENTE
    FROM TbTransacoes t
    INNER JOIN clientes_com_saldo_maior_que_100 c 
        ON t.CD_CLIENTE = c.CD_CLIENTE
    GROUP BY t.CD_CLIENTE
)
SELECT 
    t.*,
    CASE 
        WHEN t.DT_TRANSACAO = tr.DATA_TRANSACAO_ANTIGA THEN 'Mais Antiga'
        WHEN t.DT_TRANSACAO = tr.DATA_TRANSACAO_RECENTE THEN 'Mais Recente'
        ELSE 'Outro'
    END AS TIPO_TRANSACAO
FROM TbTransacoes t
INNER JOIN transacoes_mais_antiga_mais_recente tr
    ON t.CD_CLIENTE = tr.CD_CLIENTE
    AND (t.DT_TRANSACAO = tr.DATA_TRANSACAO_ANTIGA OR t.DT_TRANSACAO = tr.DATA_TRANSACAO_RECENTE);
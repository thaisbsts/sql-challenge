WITH cashback_usuarios AS (
    SELECT DISTINCT CD_CLIENTE, DT_TRANSACAO
    FROM TbTransacoes
    WHERE CD_TRANSACAO = '000'
)

SELECT COUNT(DISTINCT dt.CD_CLIENTE) AS quantidade_usuarios
FROM cashback_usuarios cb
JOIN TbTransacoes dt
    ON cb.CD_CLIENTE = dt.CD_CLIENTE
    AND dt.DT_TRANSACAO > cb.DT_TRANSACAO;
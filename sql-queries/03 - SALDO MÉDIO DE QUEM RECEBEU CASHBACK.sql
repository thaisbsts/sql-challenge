SELECT 
    ls.CD_CLIENTE, 
    ls.LAST_SALDO_ACUMULADO
FROM vw_saldo_acumulado ls
JOIN (
    SELECT DISTINCT CD_CLIENTE
    FROM TbTransacoes
    WHERE CD_TRANSACAO = '000'
) cashback ON ls.CD_CLIENTE = cashback.CD_CLIENTE
ORDER BY ls.CD_CLIENTE;

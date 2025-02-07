CREATE DATABASE DB;

USE DB;

CREATE TABLE TbClientes (
    CD_CLIENTE INT PRIMARY KEY,
    NM_CLIENTE VARCHAR(100)
);

CREATE TABLE TbTransacoes (
    CD_CLIENTE INT,
    DT_TRANSACAO DATE,
    CD_TRANSACAO VARCHAR(3),
    VR_TRANSACAO DOUBLE,
    PRIMARY KEY (CD_CLIENTE, DT_TRANSACAO, CD_TRANSACAO)
);

INSERT INTO TbClientes (CD_CLIENTE, NM_CLIENTE)
VALUES
(1, 'João'),
(2, 'Maria'),
(3, 'José'),
(4, 'Adilson'),
(5, 'Cleber');

INSERT INTO TbTransacoes (CD_CLIENTE, DT_TRANSACAO, CD_TRANSACAO, VR_TRANSACAO)
VALUES
(1, '2021-08-28', '000', 20.00),
(1, '2021-09-09', '110', 78.90),
(1, '2021-09-17', '220', 58.00),
(1, '2021-11-15', '110', 178.90),
(1, '2021-12-24', '220', 110.37),
(5, '2021-10-28', '110', 220.00),
(5, '2021-11-07', '110', 380.00),
(5, '2021-12-05', '220', 398.86),
(5, '2021-12-14', '220', 33.90),
(5, '2021-12-21', '220', 16.90),
(3, '2021-10-05', '110', 720.90),
(3, '2021-11-05', '110', 720.90),
(3, '2021-12-05', '110', 720.90),
(4, '2021-10-09', '000', 50.00);

WITH transacoes_ajustadas AS (
    SELECT
        CD_CLIENTE,
        DT_TRANSACAO,
        CD_TRANSACAO,
        VR_TRANSACAO,
        CASE 
            WHEN TRIM(CD_TRANSACAO) = '000' THEN VR_TRANSACAO
            WHEN TRIM(CD_TRANSACAO) = '110' THEN VR_TRANSACAO
            WHEN TRIM(CD_TRANSACAO) = '220' THEN (-VR_TRANSACAO)
            ELSE 0
        END AS VR_AJUSTADO
    FROM TbTransacoes
),
saldo_acumulado AS (
    SELECT 
        CD_CLIENTE,
        DT_TRANSACAO,
        SUM(VR_AJUSTADO) OVER (PARTITION BY CD_CLIENTE ORDER BY DT_TRANSACAO) AS SALDO_ACUMULADO
    FROM transacoes_ajustadas
),
saldo_medio AS (
    SELECT
        t.CD_CLIENTE,
        t.NM_CLIENTE,
        (SUM(s.SALDO_ACUMULADO) / COUNT(DISTINCT s.DT_TRANSACAO)) AS SALDO_MEDIO
    FROM saldo_acumulado s
    JOIN TbClientes t ON s.CD_CLIENTE = t.CD_CLIENTE
    WHERE s.DT_TRANSACAO BETWEEN '2021-11-01' AND '2021-11-30'
    GROUP BY t.CD_CLIENTE, t.NM_CLIENTE
)
SELECT 
    SM.NM_CLIENTE,
    SM.SALDO_MEDIO
FROM saldo_medio SM
ORDER BY SM.SALDO_MEDIO DESC
LIMIT 1;

drop table TbTransacoes;
select * from TbTransacoes;
select * from transacoes_ajustadas;

-- 1. Criando uma CTE para calcular os valores ajustados das transações
WITH valores_ajustados AS (
    SELECT 
        CD_CLIENTE,
        DT_TRANSACAO,
        CASE 
            WHEN CD_TRANSACAO = '000' THEN VR_TRANSACAO
            WHEN CD_TRANSACAO = '110' THEN VR_TRANSACAO
            WHEN CD_TRANSACAO = '220' THEN -VR_TRANSACAO
            ELSE 0
        END AS VR_AJUSTADO
    FROM TbTransacoes
),

-- 2. Calculando o saldo acumulado para cada cliente
saldos_acumulados AS (
    SELECT 
        CD_CLIENTE,
        DT_TRANSACAO,
        SUM(VR_AJUSTADO) OVER (
            PARTITION BY CD_CLIENTE 
            ORDER BY DT_TRANSACAO
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS SALDO_ACUMULADO
    FROM valores_ajustados
),

-- 3. Calculando o saldo médio de novembro para cada cliente
saldo_medio_novembro AS (
    SELECT 
        sa.CD_CLIENTE,
        COALESCE(
            (
                SELECT (
                    ((DAY(t1.DT_TRANSACAO) + 1) * t1.SALDO_ACUMULADO) +
                    ((DAY(t1.DT_TRANSACAO) - 1) * 
                        COALESCE((
                            SELECT sa2.SALDO_ACUMULADO
                            FROM saldos_acumulados sa2
                            WHERE sa2.CD_CLIENTE = sa.CD_CLIENTE
                            AND sa2.DT_TRANSACAO < '2021-11-01'
                            ORDER BY sa2.DT_TRANSACAO DESC
                            LIMIT 1
                        ), 0)
                    )
                ) / 30
                FROM saldos_acumulados t1
                WHERE t1.CD_CLIENTE = sa.CD_CLIENTE
                AND t1.DT_TRANSACAO >= '2021-11-01'
                AND t1.DT_TRANSACAO <= '2021-11-30'
                ORDER BY t1.DT_TRANSACAO
                LIMIT 1
            ),
            (
                SELECT SALDO_ACUMULADO
                FROM saldos_acumulados sa3
                WHERE sa3.CD_CLIENTE = sa.CD_CLIENTE
                AND sa3.DT_TRANSACAO < '2021-11-01'
                ORDER BY sa3.DT_TRANSACAO DESC
                LIMIT 1
            )
        ) AS saldo_medio
    FROM saldos_acumulados sa
    GROUP BY sa.CD_CLIENTE
)

-- 4. Encontrando o cliente com maior saldo médio
SELECT 
    c.NM_CLIENTE,
    smn.saldo_medio
FROM saldo_medio_novembro smn
JOIN TbClientes c ON c.CD_CLIENTE = smn.CD_CLIENTE
WHERE smn.saldo_medio = (
    SELECT MAX(saldo_medio)
    FROM saldo_medio_novembro
)
LIMIT 1;

<h1 align="center" style="font-weight: bold;">Análise de Transações Financeiras (SQL + Python) 💻</h1>

<p align="center">
  <img src="https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54">
  &nbsp;
  <img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white">
</p>


<p align="center">
 <a href="#geral">Informações Gerais</a> • 
  <a href="#structure">Estrutura do Banco de Dados</a> •
  <a href="#technologies">Sobre as tecnologias utilizadas</a> •
 <a href="#aboutproject">Especificação do Projeto</a> •
</p>

<h2 id="geral">🚀 Informações Gerais</h2>
O objetivo do desafio é analisar as transações dos clientes a partir de um banco de dados relacional, respondendo perguntas sobre saldo, movimentações e comportamento financeiro. <ins>Este projeto inclui duas abordagens:</ins>  

SQL puro – Resolvendo as consultas diretamente no banco de dados.  
Python + Databricks – Utilizando PySpark para processar os dados de maneira escalável.

<h2 id="structure">🤖 Estrutura dos Dados </h2>

TbTransacoes:

| Coluna        | Tipo     |
|---------------|----------|
| CD_CLIENTE    | INTEGER  |
| DT_TRANSACAO  | DATE     |
| CD_TRANSACAO  | INTEGER  |
| VR_TRANSACAO  | FLOAT    |

TbCliente:

| Coluna        | Tipo     |
|---------------|----------|
| CD_CLIENTE    | INTEGER  |
| NM_CLIENTE    | VARCHAR  |

**Relacionamento:**

* TbTransacoes e TbCliente estão relacionadas através da coluna CD_CLIENTE.
* Um cliente (TbCliente) pode ter várias transações (TbTransacoes).
* Uma transação (TbTransacoes) está associada a um único cliente (TbCliente).


<h2 id="technologies">🤖 Sobre as tecnologias utilizadas </h2>
Neste projeto, utilizei o PySpark em conjunto com o Databricks, uma plataforma de análise de dados altamente escalável, que oferece suporte a PySpark para processamento distribuído. O PySpark tem uma capacidade de processar grandes volumes de dados de forma distribuída e eficiente, o que é essencial para o contexto de transações financeiras. Além disso, eu também respondi as mesmas 12 perguntas em SQL para explorar ambas abordagens.

<h2 id="aboutproject">📝 Especificação do Projeto</h2>
O projto consiste em responder as seguintes perguntas:  

-- Qual cliente teve o maior saldo médio no mês 11? 

-- Qual é o saldo de cada cliente?

-- Qual é o saldo médio de clientes que receberam CashBack?

-- Qual o ticket médio das quatro últimas movimentações dos usuários?

-- Qual é a proporção entre Cash In/Out mensal?

-- Qual a última transação de cada tipo para cada usuário?

-- Qual a última transação de cada tipo para cada usuário por mês?

-- Qual quatidade de usuários que movimentaram a conta?

-- Qual o balanço do final de 2021?

-- Quantos usuários que receberam CashBack continuaram interagindo com este banco?

-- Qual a primeira e a última movimentação dos usuários com saldo maior que R$100?

-- Qual o balanço das últimas quatro movimentações de cada usuário?

-- Qual o ticket médio das últimas quatro movimentações de cada usuário?

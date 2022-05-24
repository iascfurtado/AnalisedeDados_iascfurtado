-- SET GLOBAL LOCAL_INFILE = 1;
-- SHOW GLOBAL VARIABLES LIKE 'local_infile';
/*/
LOAD DATA LOCAL INFILE 
'C:/Users/Pichau/Google Drive/PREPARATORIO T.i/0 data/6 PORTFOLIO DATA COM SQL/2EDA MySQL/olist_customers_dataset.csv'
INTO TABLE tb_customers
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);
/*/
USE mentoria_um;
SELECT * FROM ocupacao;

LOAD DATA LOCAL INFILE 
'C:/Users/Pichau/Google Drive/PREPARATORIO T.I/0 data/9MENTORIAS/testetecnico_telemedicina/ocupacao.csv'
INTO TABLE ocupacao
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(client, speciality_x, create_date, report_date, physician, name, client_name, city, state, value);

-- COMEÇAR CONSULTAS DAQUI -- 
-- 1)Quantas linhas e colunas existem na base?
SELECT COUNT(client) AS qtd_linhas_tb FROM ocupacao; -- linhas
SELECT COUNT(*) AS qtd_colunas FROM information_schema.COLUMNS
WHERE TABLE_NAME = 'ocupacao'; -- colunas

-- 2)É possível classificar as colunas em entidades/grupos?
SELECT client_name, COUNT(DISTINCT speciality_x) AS exames, speciality_x, CAST(create_date AS DATE) AS data_entrada
FROM ocupacao
GROUP BY 4, speciality_x, client_name
ORDER BY create_date, client_name;


-- 3)Qual o exame mais recente e o mais antigo da base?
SELECT speciality_x, CAST(create_date AS DATE)
FROM ocupacao
GROUP BY create_date
ORDER BY create_date ASC
LIMIT 3; -- mais antigo

SELECT speciality_x, CAST(create_date AS DATE)
FROM ocupacao
GROUP BY create_date
ORDER BY create_date DESC
LIMIT 3; -- mais recente


-- 4)Quantos exames foram realizados, no total da base
SELECT COUNT(speciality_x) AS qtd_exames_feitos, 
COUNT(DISTINCT speciality_x) AS qtd_tipo_exames 
FROM ocupacao; -- exames total

-- 5) Quantos tipos de exames diferentes existem na base
SELECT COUNT(DISTINCT speciality_x) AS qtd_tipo_exames 
FROM ocupacao;

-- 6) Qual a quantidade de médicos que existem nessa base?
SELECT * FROM ocupacao;
SELECT COUNT(DISTINCT physician) AS qtd_de_medicos
FROM ocupacao;

-- 7)Quantos clientes diferentes (clínicas/hospitais) temos na base?
SELECT COUNT(DISTINCT client_name) AS clientes_distintos
FROM ocupacao;

-- 8)Para qual estado a empresa realizou o maior número de laudos de exames?
SELECT state, COUNT(state) AS pedidos_por_UF
FROM ocupacao
GROUP BY state
ORDER BY 2 DESC
LIMIT 5;

-- 9)Para qual estado a empresa realizou o menor número de laudos de exames?
SELECT state, COUNT(state) AS pedidos_por_UF
FROM ocupacao
GROUP BY state
ORDER BY 2
LIMIT 5;

-- 10)Distribuição percentual de exames em cada estado;
SELECT state, ROUND((COUNT(state)*100/tb1.totalexame),2) AS percent
FROM ocupacao, (SELECT COUNT(speciality_x) AS totalexame FROM ocupacao) AS tb1
GROUP BY state
ORDER BY 2 DESC;
-- 100*27/304493


-- 11)Quais os 5 clientes que mais solicitaram mais laudos de exames?
SELECT client_name, COUNT(client_name) AS pedidos_por_cliente
FROM ocupacao
GROUP BY client_name
ORDER BY 2 DESC
LIMIT 5;

-- 12)Qual o exame mais caro e o mais barato?
SELECT speciality_x, value 
FROM ocupacao
GROUP BY speciality_x
ORDER BY value ASC
LIMIT 5; -- mais barato

SELECT speciality_x, value 
FROM ocupacao
GROUP BY speciality_x
ORDER BY value DESC
LIMIT 5; -- mais caro


-- 13)Qual o top 5 médicos que realizaram mais exames?
SELECT name, COUNT(speciality_x) AS exames
FROM ocupacao
GROUP BY physician, name
ORDER BY exames DESC
LIMIT 5;


-- 14)Qual o médico que realizou menos exames? Como foi o desempenho dele no mês? -- nao consegui responder
SELECT name, COUNT(speciality_x) AS exames, MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
GROUP BY mes, physician
ORDER BY mes;



-- O TOP CLIENTE QUE MAIS SOLICITOU EXAMES QUER SABER:
-- 1) Quantidade de exames que solicitou, por mês;
SELECT client, COUNT(speciality_x) AS exames
FROM ocupacao
GROUP BY client
ORDER BY exames DESC
LIMIT 1; -- saber quem é o cliente top CLIENT = 119

SELECT client_name, COUNT(speciality_x), MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
WHERE client = 119
GROUP BY  client, mes
ORDER BY mes; -- saber quantos exames por mes solicitou


-- marido que fez o de baixo que é com subquery de subquery
/*/SELECT client_name, COUNT(speciality_x) AS exames, MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
WHERE client = ( SELECT client 
                   FROM (SELECT client, COUNT(speciality_x) AS exames
					       FROM ocupacao
						  GROUP BY client
					      ORDER BY exames DESC
                          LIMIT 1) AS tb1
				)
GROUP BY client, mes
ORDER BY mes ASC;/*/

-- 2) Valor total dos exames que solicitou, por mês;
SELECT client_name, SUM(value) AS valor_ttl_exames, MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
WHERE client = 119
GROUP BY  client, mes
ORDER BY mes;

-- 3) 5 principais especialidades que solicitou no último mês;
SELECT client_name, speciality_x AS tipos_exames, COUNT(speciality_x) AS qtd_exames, MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
WHERE client = 119 AND MONTH(CAST(create_date AS DATE)) = 3
GROUP BY speciality_x, mes
ORDER BY qtd_exames DESC
LIMIT 5;

-- 4) Média de valores das 5 principais especialidades que solicitou no último mês disponível na base;
-- primeiro pegar as cinco principais especialidades solicitadas no mes, questao acima: eletrocardiograma, eletroencefalograma, espirometria, rx torax pa, rx coluna
SELECT speciality_x, value 
FROM ocupacao
WHERE speciality_x IN('ELETROCARDIOGRAMA', 'ELETROENCEFALOGRAMA', 'ESPIROMETRIA', 'RX-TORAX (PA) COM LEITURA OIT', 'RX-COLUNA LOMBO-SACRA')
GROUP BY speciality_x;

-- pegar o valor dessas cinco 26,29,26,4,34 a média deveria ser a soma desses valores dividido pelos valores, que daria 119/5 = 23,8
-- pegar a media desses valores considerando apenas os exames acima
SELECT client_name, ROUND(AVG( DISTINCT value),2) AS media_valores 
FROM ocupacao
WHERE client = 119 AND speciality_x IN('ELETROCARDIOGRAMA', 'ELETROENCEFALOGRAMA', 'ESPIROMETRIA', 'RX-TORAX (PA) COM LEITURA OIT', 'RX-COLUNA LOMBO-SACRA')
GROUP BY client_name; -- resultado nao bate com calculo acima


-- 5) 5 principais cidades que solicitaram exames para esse cliente, no último mês;
SELECT client_name, state
FROM ocupacao
WHERE client = 119 AND YEAR(CAST(create_date AS DATE)) = 2019  AND MONTH(CAST(create_date AS DATE)) = 3 
GROUP BY state, speciality_x
ORDER BY state DESC; -- city só retorna zero


-- 6) Qual a especialidade de exames que foi menos demandada? (RX-BACIA) Essa característica se repete nos meses anteriores? (NÃO)
SELECT client_name, speciality_x AS tipos_exames, COUNT(speciality_x) AS qtd_exames, MONTH(CAST(create_date AS DATE)) AS mes
FROM ocupacao
WHERE client = 119 
GROUP BY tipos_exames
ORDER BY qtd_exames, mes;
-- RX BACIA
-- NÃO



-- EXTRA: É possível correlacionar exames menos demandados com valor mais alto?
SELECT speciality_x, COUNT(speciality_x) AS qtd_exames, value
FROM ocupacao
GROUP BY speciality_x
ORDER BY qtd_exames ASC, value DESC
LIMIT 10;


/*/ Entregar para o cliente TOP 1 em valores gastos o relatório abaixo, utilizando os dados do mês mais recente disponível na base:

    • especialidades
    • qtd laudos de exames realizados
    • total valor que será pago à empresa de telemedicina
    • média de valor de cada exame
    • qtd de estados diferentes onde realizou laudos de exames /*/
    
    SELECT DISTINCT(speciality_x) AS 'Especialidades', COUNT(speciality_x) AS 'Qtd Realizados', SUM(value) AS 'Total Valor', ROUND(AVG(DISTINCT value),2) 'Média Valor', COUNT(DISTINCT state) AS 'Qtd Estados'
    FROM ocupacao
    WHERE client = 119 AND YEAR(CAST(create_date AS DATE)) = 2019 AND MONTH(CAST(create_date AS DATE)) = 3
    GROUP BY speciality_x
    ORDER BY speciality_x;




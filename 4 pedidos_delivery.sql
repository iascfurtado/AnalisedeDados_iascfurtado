-- SET GLOBAL LOCAL_INFILE = 1;
-- SHOW GLOBAL VARIABLES LIKE 'local_infile';
USE mentoria_um;

/*/
LOAD DATA LOCAL INFILE 
'C:/Users/Pichau/Google Drive/PREPARATORIO T.I/0 data/9MENTORIAS/testetecnico_pedidos_delivery/base_pedidos1.csv'
INTO TABLE base_pedidos
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(id_pedido,	horario_local, turno_pedido, data_ultimo_status, total_pedido, credito, 	 
total_pago, tipo_entrega, agendada,	data_criacao_agendamento, versao_app,
tipo_dispositivo, sistema_operacional, tipo_pagamento, cliente_estado, cliente_cidade,	
cliente_distrito, cliente_latlong, cliente_status_ultimo_mes, cliente_sensivel_cupom,
cliente_horario_preferido, comercio_cidade,	comercio_distrito, comercio_latlong, 
comercio_tipo, e_promocao, qtd_itens, horario_pedido, id_cliente);
/*/
SELECT * FROM base_pedidos;

-- COMEÇAR CONSULTAS DAQUI -- 
-- 1)Quantas linhas e colunas existem na base?
SELECT COUNT(id_pedido) AS qtd_linhas_tb 
FROM base_pedidos; -- linhas

SELECT COUNT(*) AS qtd_colunas 
FROM information_schema.COLUMNS
WHERE TABLE_NAME = 'base_pedidos'; -- colunas

-- 4)Quantos pedidos existem na base?
SELECT COUNT(id_pedido) AS qtd_pedidos 
FROM base_pedidos;

-- 5)Quantos usuários existem na base?
SELECT COUNT(DISTINCT(id_cliente)) AS qtd_clientes 
FROM base_pedidos;

-- 6) Verifique se todos os pedidos são únicos.
SELECT DISTINCT id_pedido, id_cliente, tipo_dispositivo
FROM base_pedidos
GROUP BY id_pedido; 

-- 7)Qual o pedido mais recente e o mais antigo da base?
SELECT id_pedido, CAST(horario_local AS DATE) AS mais_antigo
FROM base_pedidos
GROUP BY horario_local
ORDER BY horario_local ASC
LIMIT 3; -- mais antigo

SELECT id_pedido, CAST(horario_local AS DATE) AS mais_recente
FROM base_pedidos
GROUP BY horario_local
ORDER BY horario_local DESC
LIMIT 3; -- mais recente


/*/8) Quais foram os valores mínimo, máximo e médio gasto por todos os clientes 
durante os meses disponíveis na base? /*/
SELECT MIN(total_pedido) AS minimo, 
MAX(total_pedido) AS maximo, 
ROUND(AVG(total_pedido),2) AS medio
FROM base_pedidos;

-- 9)Qual o dispositivo que faz mais pedidos?
SELECT tipo_dispositivo, COUNT(tipo_dispositivo) AS tipo_distinto
FROM base_pedidos
GROUP BY tipo_dispositivo
ORDER BY COUNT(tipo_dispositivo) DESC;

-- 10) Qual sistema operacional é mais usado para os pedidos?
SELECT sistema_operacional, COUNT(sistema_operacional) AS sistema
FROM base_pedidos
GROUP BY sistema_operacional
ORDER BY COUNT(sistema_operacional) DESC;

-- 11) Qual o estado que faz mais pedidos?
SELECT cliente_estado, COUNT(cliente_estado) AS estados
FROM base_pedidos
GROUP BY cliente_estado
ORDER BY COUNT(cliente_estado) DESC
LIMIT 10;

-- 12) No estado mais pedido, qual a cidade que faz mais pedidos?
SELECT cliente_cidade, COUNT(cliente_cidade) AS cidades
FROM base_pedidos
WHERE cliente_estado = 'SP'
GROUP BY cliente_cidade
ORDER BY COUNT(cliente_cidade) DESC
LIMIT 10;

-- 13. Qual a quantidade e percentual de pedidos por turno?
SELECT turno_pedido, ROUND((COUNT(turno_pedido)*100/tb1.turno_do_pedido),2) AS percent
FROM base_pedidos, (SELECT COUNT(turno_pedido) AS turno_do_pedido FROM base_pedidos) AS tb1
GROUP BY turno_pedido
ORDER BY 2 DESC;
-- 100*medida/totaldedadosdabase

-- 14. Qual a quantidade e percentual de pedidos por tipo (Comida brasileira, lanches, etc)?
SELECT comercio_tipo, ROUND((COUNT(comercio_tipo)*100/tb1.tipo_do_comercio),2) AS percent
FROM base_pedidos, (SELECT COUNT(comercio_tipo) AS tipo_do_comercio FROM base_pedidos) AS tb1
GROUP BY comercio_tipo
ORDER BY 2 DESC
LIMIT 10;

-- 15. Qual o percentual de clientes que são novos na base?
SELECT cliente_status_ultimo_mes, ROUND((COUNT(cliente_status_ultimo_mes)*100/tb1.cliente_mes),2) AS percent
FROM base_pedidos, (SELECT COUNT(cliente_status_ultimo_mes) AS cliente_mes FROM base_pedidos) AS tb1
WHERE cliente_status_ultimo_mes = 'New'
GROUP BY cliente_status_ultimo_mes;


-- Intermediário
-- 16. Qual a quantidade de itens pedidos, em média?
SELECT ROUND(AVG(qtd_itens),1) AS media_pedidos
FROM base_pedidos;

-- 17. Qual a média de valores dos pedidos?
SELECT ROUND(AVG(total_pedido),2) AS media_valor_pedido
FROM base_pedidos;

-- 18. Qual o percentual de pedidos que são agendados?
SELECT agendada, ROUND((COUNT(agendada)*100/tb1.pedido_agendado),2) AS percent
FROM base_pedidos, (SELECT COUNT(agendada) AS pedido_agendado FROM base_pedidos) AS tb1
GROUP BY agendada
ORDER BY 2 DESC
LIMIT 10;

-- 19. Qual o tipo de pedido preferido por turno?
SELECT comercio_tipo, turno_pedido, COUNT(comercio_tipo) AS tipo_de_comida
FROM base_pedidos
GROUP BY turno_pedido
ORDER BY turno_pedido;

-- 20. Em qual turno dos dias se tem o maior ticket médio? (média de valor de pedidos)
-- R$55,35
SELECT turno_pedido, ROUND(AVG(total_pedido),2) AS media_valor_pedido
FROM base_pedidos
GROUP BY turno_pedido 
HAVING media_valor_pedido >= 55
ORDER BY media_valor_pedido DESC;

-- 21. Em qual tipo de pedidos se tem o maior ticket médio? (média de valor de pedidos)
SELECT comercio_tipo, 
COUNT(comercio_tipo) AS qtd_de_tipo, 
ROUND(AVG(total_pedido),2) AS media_valor_pedido
FROM base_pedidos
GROUP BY comercio_tipo 
HAVING media_valor_pedido >= 55
ORDER BY qtd_de_tipo DESC
LIMIT 5;


/*/22. Para clientes sensíveis a cupons, qual tem o maior ticket médio? 
(média de valor de pedidos)
sensíveis são os que tem sensibilidade média e alta/*/
SELECT cliente_sensivel_cupom AS sensibilidade_cupom,
COUNT(cliente_sensivel_cupom) AS qtd, 
ROUND(AVG(total_pedido),2)  AS média_de_pedido
FROM base_pedidos
WHERE cliente_sensivel_cupom IN ('media','alta')
GROUP BY cliente_sensivel_cupom
ORDER BY 3 DESC;


-- 23. Para clientes sensíveis a cupons, qual o principal tipo de pedidos?
SELECT comercio_tipo, COUNT(comercio_tipo) AS qtd_tipo, cliente_sensivel_cupom
FROM base_pedidos
WHERE cliente_sensivel_cupom IN ('media','alta')
GROUP BY comercio_tipo
ORDER BY 2 DESC;

-- Avançado
/*/ 24. Como analista da empresa, os restaurantes de Sorocaba que vendem lanches querem saber 
qual o melhor turno para ofertar um cupom, com base na sensibilidade dos clientes e do ticket 
médio. (Pode embasar a resposta com tabelas, gráficos, etc)/*/
SELECT turno_pedido, 
	COUNT(id_pedido) AS qtd_pedidos, 
	ROUND(AVG(total_pedido),2) AS media_pedido,
	cliente_sensivel_cupom AS sensibilidade
FROM base_pedidos
WHERE comercio_tipo = 'Lanches' 
	AND comercio_cidade = 'sorocaba' 
	AND cliente_sensivel_cupom IN ('media','alta')
GROUP BY turno_pedido
	HAVING media_pedido > 55
ORDER BY qtd_pedidos DESC;


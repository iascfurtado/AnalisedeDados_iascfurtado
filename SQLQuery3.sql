-- COMELÇANDO A ANALISAR AS TABELAS, começamos com a primeira tabela
-- ver quais os campos que ela possui
SELECT TOP 10 * FROM dbo.olist_customers_dataset

-- criando tabelas de producao, que tenham as informacoes necessarias
-- e ocupem o menor espaco possivel dentro do bd

CREATE TABLE tb_atual_olist_costumer 
--pode aparecer como tb_act de actual ou ainda tb_fact de fato
(
	customer_id nvarchar(150), --nvarchar significa que é um campo texto de tamanhos 
	--variaveis, podendo ter registro com poucos ou muitos caracteres
	customer_unique_id nvarchar(150),
	customer_zip_code_prefix nvarchar(15),
	customer_city nvarchar(100),
	customer_state char(2)
)
-- pra executar as coisas aqui tem que selecionar tudo o que quer executar e clicar
-- em executar
SELECT * FROM tb_atual_olist_costumer

-- inserindo na tabela criada TODAS as informacoes que estao contidas na tabela
-- de carga unindo um insert into com o select from, já que a ordem em que os campos
-- foram criados na tabela de producao é a mesma é só dizer o nome de onde vem a tabela
-- caso contrario, teria que ir dizendo a ordem na qual selecionar um por um, separando
-- por virgula
INSERT INTO tb_atual_olist_costumer SELECT * FROM dbo.olist_customers_dataset 
--NÃO RODAR NOVAMENTE PARA NAO DUPLICAR AS INFORMACOES

-- outros tipos de tipos de dados para usar aqui seriam os
-- int para numeros inteiros 1,2,3,4,5,
-- float para valores monetarios
-- nvarchar para campo de texto
-- datetime que contem a data e hora min e segundo

-- criar as demais tabelas producao para continuar o serviço
CREATE TABLE tb_atual_geolocation 
(
	geolocation_zip_code_prefix nvarchar(15),
	geolocation_lat nvarchar(100),
	geolocation_lng nvarchar(100),
	geolocation_city nvarchar(100),
	geolocation_state char (2)
)
SELECT * FROM tb_atual_geolocation
INSERT INTO tb_atual_geolocation SELECT * FROM olist_geolocation_dataset

CREATE TABLE tb_atual_pedidos 
(
	order_id nvarchar (100),
	order_item_id int,
	product_id nvarchar(100),
	seller_id nvarchar(100),
	shipping_limit_date datetime,
	price float,
	freight_value float
)
SELECT * FROM tb_atual_pedidos

-- inserir na tabela producao os dados da tabela carga onde
-- a coluna que era varchar e deveria ser datetime
-- ja convertendo na inserção o dado de varchar para datetime
INSERT INTO tb_atual_pedidos 
SELECT order_id,order_item_id,product_id,seller_id,
CONVERT(DATETIME, shipping_limit_date, 102), -- esse 102 é o código do
--mysql server no estilo dos USA para datas
price,freight_value
FROM olist_order_items_dataset


CREATE TABLE tb_atual_pagamentos
(
order_id nvarchar (100),
payment_sequential int,
payment_type nvarchar (100),
payment_installments int,
payment_value float
)
SELECT * FROM tb_atual_pagamentos
INSERT INTO tb_atual_pagamentos SELECT * FROM olist_order_payments_dataset

CREATE TABLE tb_atual_ordens
(
order_id nvarchar (100),
customer_id nvarchar (100),
order_status nvarchar (50),
order_purchase_timestamp datetime,
order_approved_at datetime,
order_delivered_carrier_date datetime,
order_delivered_customer_date datetime,
order_estimated_delivery_date datetime
)
SELECT * FROM tb_atual_ordens
INSERT INTO tb_atual_ordens SELECT * FROM olist_orders_dataset

CREATE TABLE tb_atual_produtos
(
	product_id nvarchar(100),
	product_category_name nvarchar(100),
	product_name_lenght nvarchar(10),
	product_description_lenght nvarchar(10),
	product_photos_qty nvarchar(10),
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int,
)
SELECT*FROM tb_atual_produtos
INSERT INTO tb_atual_produtos SELECT * FROM olist_products_dataset

CREATE TABLE tb_atual_vendedores
(
	seller_id nvarchar(100),
	seller_zip_code_prefix nvarchar (10),
	seller_city nvarchar (50),
	seller_state nvarchar (2)
)
SELECT * FROM tb_atual_vendedores
INSERT INTO tb_atual_vendedores SELECT * FROM olist_sellers_dataset

CREATE TABLE tb_atual_traducao 
(
	product_category_name nvarchar(100),
	product_category_name_english nvarchar (100)
)
SELECT * FROM tb_atual_traducao
INSERT INTO tb_atual_traducao SELECT * FROM product_category_name_translation

USE [Portfolio-ias]

SELECT * FROM tb_atual_olist_costumer
SELECT * FROM tb_atual_ordens

-------- respondendo a perguntas para análise de dados
--- quais dos clientes cadastrados fizeram uma compra?
-- quais os comportamentos dos clientes

SELECT pedidos.*, clientes.customer_city, clientes.customer_state 
FROM tb_atual_ordens AS pedidos 
INNER JOIN tb_atual_olist_costumer AS clientes
ON pedidos.customer_id = clientes.customer_id

-- SELECT todas(*) as informacoes da tabela apelidada de pedidos + (,)
-- a coluna customer_city da tabela apelidada de clientes
-- da tabela de ordems chamando ela (AS) de pedidos MAIS (inner join)
-- com a tabela de clientes chamando ela (AS) de clientes onde (ON)
-- as colunas que vao ser cruzadas vao ser as customer_id
-- mostrando primeiro a da tabela pedidos e depois a da tabela clientes


-- criando views para salvar a consulta para futuras análises
CREATE VIEW vw_pedidos_por_clientes
AS
SELECT pedidos.*, clientes.customer_city, clientes.customer_state 
FROM tb_atual_ordens AS pedidos 
INNER JOIN tb_atual_olist_costumer AS clientes
ON pedidos.customer_id = clientes.customer_id

SELECT * FROM vw_pedidos_por_clientes

CREATE VIEW vw_pedidos_por_clientes_filtrado
AS
SELECT pedidos.*, clientes.customer_city, clientes.customer_state 
FROM tb_atual_ordens AS pedidos 
INNER JOIN tb_atual_olist_costumer AS clientes
ON pedidos.customer_id = clientes.customer_id
WHERE order_status = 'delivered'

SELECT * FROM vw_pedidos_por_clientes_filtrado

-- criando uma planilha no excel para visualizaçao
-- no excel, busca obter dados, do banco de dados SQL Server
-- copia o nome do servidor da parte do sql server em conectar e mecanismo
-- de banco de dados
-- coloca o nome do banco que é opcional mas é bom colocar
-- na parte de instrucao sql coloca a consulta de view que se quer
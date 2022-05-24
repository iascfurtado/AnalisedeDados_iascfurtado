SELECT TOP 10 * FROM dbo.olist_customers_dataset -- ok
SELECT TOP 10 * FROM olist_geolocation_dataset -- ok
SELECT TOP 10 * FROM olist_order_items_dataset -- OK
SELECT TOP 10 * FROM olist_order_payments_dataset --ok
SELECT TOP 10 * FROM olist_orders_dataset --ok
SELECT TOP 10 * FROM olist_products_dataset --ok
SELECT TOP 10 * FROM olist_sellers_dataset --ok
SELECT TOP 10 * FROM product_category_name_translation --ok
-- selecionando todas as tabelas principais para ver quais sao os seus
-- campos e tambem selecionando apenas as 10 primeiras colocacoes
-- para nao precisar mostrar a tabela gigantesca
-- apareceram problemas na tabela de carga onde na hora de carregar haviam
-- dados que eram para ser datetime mas foram carregados como varchar, nesse caso
-- é necessário fazer um update nessas tabelas para atualizar esses campos para ai
-- sim criar a tabela de producao, sendo

UPDATE [dbo].[olist_orders_dataset] 
SET order_estimated_delivery_date = NULL
WHERE order_estimated_delivery_date=''




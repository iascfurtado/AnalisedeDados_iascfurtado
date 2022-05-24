USE mppb;
-- cota para avaliar quantidade de servidores no Município por cargo, por lotação e por tipo de contrato

SELECT * FROM excepciobanan; 
SELECT * FROM comissionban; 
SELECT * FROM efetivbanan; -- ok

DROP TABLE excepciobanan;

SELECT COUNT(nome_servidor) FROM excepciobanan;
SELECT COUNT(nome_servidor) FROM comissionban;
SELECT COUNT(nome_servidor) FROM efetivbanan;

SELECT DISTINCT(lotacao), COUNT(nome_servidor) FROM excepciobanan GROUP BY lotacao;
SELECT DISTINCT(cargo), COUNT(nome_servidor) FROM excepciobanan GROUP BY cargo ORDER BY cargo ASC;

SELECT DISTINCT(lotacao), COUNT(nome_servidor) FROM comissionban GROUP BY lotacao;
SELECT DISTINCT(cargo), COUNT(nome_servidor) FROM comissionban GROUP BY cargo ORDER BY cargo ASC;

SELECT DISTINCT(cargo), COUNT(nome_servidor) FROM efetivbanan GROUP BY cargo ORDER BY cargo ASC;
SELECT DISTINCT(lotacao), COUNT(nome_servidor) FROM efetivbanan GROUP BY lotacao;
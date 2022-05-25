USE hashtagmovie;

SELECT * FROM alugueis;
SELECT * FROM atores;
SELECT * FROM atuacoes;
SELECT * FROM clientes;
SELECT * FROM filmes;

-- 1)
SELECT titulo AS 'Título',  COUNT(id_aluguel) AS 'Qtd Alugueis', ano_lancamento AS 'Ano de Lançamento' 
FROM filmes
INNER JOIN alugueis
ON filmes.id_filme = alugueis.id_filme
GROUP BY titulo
ORDER BY COUNT(id_aluguel) DESC, titulo ASC
LIMIT 5;


-- 2)
SELECT genero AS 'Gênero', COUNT(id_aluguel) AS 'Qtd Alugueis'
FROM filmes
INNER JOIN alugueis
ON filmes.id_filme = alugueis.id_filme
GROUP BY genero
ORDER BY COUNT(id_aluguel) DESC, titulo ASC
LIMIT 5;


-- 3)
SELECT nome_cliente AS 'Clientes', 
ROUND(SUM(preco_aluguel), 2) AS 'R$ Total',
COUNT(id_aluguel) AS 'Qtd Alugada',
DATE_FORMAT(data_aluguel, '%Y-01-01') AS 'Data de Aluguel'
FROM alugueis
INNER JOIN clientes
ON alugueis.id_cliente = clientes.id_cliente
INNER JOIN filmes
ON filmes.id_filme = alugueis.id_filme
WHERE DATE_FORMAT(data_aluguel, '%Y-01-01') >= '2019-01-01'
GROUP BY nome_cliente, DATE_FORMAT(data_aluguel, '%Y-01-01')
ORDER BY DATE_FORMAT(data_aluguel, '%Y-01-01'), COUNT(id_aluguel) DESC, nome_cliente
LIMIT 10;


-- 4)
SELECT nome_cliente AS 'Clientes', 
ROUND(SUM(preco_aluguel), 2) AS 'R$ Total',
COUNT(id_aluguel) AS 'Qtd Alugada',
DATE_FORMAT(data_aluguel, '%Y-01-01') AS 'Data de Aluguel'
FROM alugueis
INNER JOIN clientes
ON alugueis.id_cliente = clientes.id_cliente
INNER JOIN filmes
ON filmes.id_filme = alugueis.id_filme
WHERE DATE_FORMAT(data_aluguel, '%Y-01-01') >= '2019-01-01'
GROUP BY nome_cliente, DATE_FORMAT(data_aluguel, '%Y-01-01')
ORDER BY DATE_FORMAT(data_aluguel, '%Y-01-01'), COUNT(id_aluguel) ASC, nome_cliente;


-- 5)
SELECT ROUND(AVG(Media_de_Alugueis),1) AS 'Média de Alugueis' FROM 
(
	SELECT nome_cliente AS 'Nome do Cliente', ROUND(AVG(qnt_aluguel), 1) AS Media_de_Alugueis
	FROM 
		(
        SELECT nome_cliente,
		COUNT(id_aluguel) AS qnt_aluguel,
		DATE_FORMAT(data_aluguel, '%Y-01-01')
		FROM clientes
		INNER JOIN alugueis
		ON clientes.id_cliente = alugueis.id_cliente
		WHERE DATE_FORMAT(data_aluguel, '%Y-01-01') >= '2017-01-01'
		GROUP BY nome_cliente, DATE_FORMAT(data_aluguel, '%Y-01-01')
		) AS subquery
		GROUP BY nome_cliente
        ORDER BY ROUND(AVG(qnt_aluguel), 1) DESC
) AS subquery2;


-- 6) 
SELECT ROUND(AVG(preco_aluguel), 2) AS 'Preço Médio' FROM filmes;

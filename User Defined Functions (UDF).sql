/* Exercícios:
1. Criar uma database, criar as tabelas abaixo, definindo o tipo de dados e a relação PK/FK e popular
com alguma massa de dados de teste (Suficiente para testar UDFs)
Funcionário (Código, Nome, Salário)
Dependendente (Código_Dep, Código_Funcionário, Nome_Dependente, Salário_Dependente)
a) Código no Github ou Pastebin de uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
b) Código no Github ou Pastebin de uma Scalar Function que Retorne a soma dos Salários dos
dependentes, mais a do funcionário. */

USE MASTER
--DROP DATABASE funcionario
CREATE DATABASE funcionario
GO
USE funcionario 

CREATE TABLE funcionario(
cod_func     INT              NOT NULL,
nome_func    VARCHAR(30)      NOT NULL,
salario_func DECIMAL(10,2)    NOT NULL
PRIMARY KEY(cod_func)
)

CREATE TABLE dependente(
cod_dep          INT              NOT NULL,
cod_func         INT              NOT NULL,
nome_dep         VARCHAR(30)      NOT NULL,
salario_dep      DECIMAL(10,2)    NOT NULL,
PRIMARY KEY(cod_dep),
FOREIGN KEY(cod_func) REFERENCES funcionario (cod_func)
)

INSERT INTO funcionario VALUES
    (1, 'João', 5000.00),
    (2, 'Maria', 6000.00),
    (3, 'Pedro', 5500.00)

INSERT INTO dependente VALUES
    (1, 1, 'Ana', 1000.00),
    (2, 1, 'Luiz', 800.00),
    (3, 2, 'Carla', 1200.00),
    (4, 3, 'Mariana', 900.00)

CREATE FUNCTION fn_tabela()
RETURNS @tabela TABLE (
nome_func        VARCHAR(30),
nome_dep         VARCHAR(30),
salario_func     DECIMAL(10,2),
salario_dep      DECIMAL(10,2)
)
BEGIN 
      INSERT INTO @tabela (nome_func, salario_func, nome_dep, salario_dep)
	  SELECT f.nome_func, f.salario_func, d.nome_dep, d.salario_dep  FROM funcionario f
	  INNER JOIN dependente d ON f.cod_func = d.cod_func
RETURN
END

SELECT * FROM fn_tabela()

CREATE FUNCTION fn_soma(@cod_func INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
       DECLARE @soma DECIMAL(10,2)
IF (@cod_func > 0)
	BEGIN
	SELECT @soma = COALESCE(SUM(d.salario_dep), 0)
        FROM dependente d
        WHERE d.cod_func = @cod_func

		DECLARE @salario_func DECIMAL(10,2)
        SELECT @salario_func = salario_func
        FROM funcionario
        WHERE cod_func = @cod_func
		SET @soma = @soma + @salario_func
	END
	RETURN @soma
END

SELECT dbo.fn_soma(3) AS Soma_dos_Salarios

/*2. Fazer uma Function que retorne
a) a partir da tabela Produtos (codigo, nome, valor unitário e qtd estoque), quantos produtos
estão com estoque abaixo de um valor de entrada
b) Uma tabela com o código, o nome e a quantidade dos produtos que estão com o estoque
abaixo de um valor de entrada */
CREATE TABLE produtos(
cod_prod       INT           NOT NULL,
nome_prod      VARCHAR(30)   NOT NULL,
valor_uni      DECIMAL(7,2)  NOT NULL,
qtd_estoque    INT           NOT NULL
PRIMARY KEY (cod_prod)
)
INSERT INTO produtos VALUES
    (1, 'Camisa', 25.00, 100),
    (2, 'Calça', 35.50, 80),
    (3, 'Sapato', 50.00, 50),
	(4, 'Cinto', 15.00, 8),
	(5, 'Meias', 4.00, 5)

CREATE FUNCTION fn_tabela_produtos(@valor_de_entrada INT )
RETURNS @tabela TABLE (
cod_prod        INT,
nome_prod       VARCHAR(30),
valor_uni       DECIMAL(7,2),
qtd_estoque     INT
)
BEGIN 
      INSERT INTO @tabela (cod_prod, nome_prod, valor_uni , qtd_estoque)
	  SELECT cod_prod, nome_prod, valor_uni, qtd_estoque  FROM produtos
	  WHERE qtd_estoque < @valor_de_entrada
RETURN
END

SELECT * FROM fn_tabela_produtos(10)

/*3. Criar, uma UDF, que baseada nas tabelas abaixo, retorne
Nome do Cliente, Nome do Produto, Quantidade e Valor Total, Data de hoje
Tabelas iniciais:
Cliente (Codigo, nome)
Produto (Codigo, nome, valor) */

CREATE TABLE cliente(
cod_cli       INT           NOT NULL,
nome_cli      VARCHAR(30)   NOT NULL
PRIMARY KEY (cod_cli)
)

CREATE TABLE produto(
cod_prod       INT           NOT NULL,
nome_prod      VARCHAR(30)   NOT NULL,
valor          DECIMAL(7,2)  NOT NULL
PRIMARY KEY (cod_prod)
)
CREATE TABLE venda(
cod_prod      INT           NOT NULL,
cod_cli       INT           NOT NULL,
qtd           INT           NOT NULL,
FOREIGN KEY(cod_prod) REFERENCES produto (cod_prod),
FOREIGN KEY(cod_cli) REFERENCES cliente (cod_cli)
)

INSERT INTO cliente VALUES
    (1, 'João'),
    (2, 'Maria'),
    (3, 'Pedro')

INSERT INTO produto VALUES
    (1, 'Camiseta', 29.99),
    (2, 'Calça', 39.99),
    (3, 'Sapato', 59.99)

INSERT INTO venda VALUES
    (1, 1, 2), -- João comprou 2 camisetas
    (2, 2, 1), -- Maria comprou 1 calça
    (3, 3, 3); -- Pedro comprou 3 sapatos

CREATE FUNCTION fn_venda()
RETURNS TABLE
AS
RETURN (
    SELECT 
        c.nome_cli AS NomeCliente,
        p.nome_prod AS NomeProduto,
        v.qtd AS Quantidade,
        v.qtd * p.valor AS ValorTotal,
        GETDATE() AS DataAtual
    FROM 
        venda v
    INNER JOIN 
        cliente c ON v.cod_cli = c.cod_cli
    INNER JOIN 
        produto p ON v.cod_prod = p.cod_prod
)

SELECT * FROM fn_venda()

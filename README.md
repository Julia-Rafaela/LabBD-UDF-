Exercícios:
1. Criar uma database, criar as tabelas abaixo, definindo o tipo de dados e a relação PK/FK e popular
com alguma massa de dados de teste (Suficiente para testar UDFs)
Funcionário (Código, Nome, Salário)
Dependendente (Código_Dep, Código_Funcionário, Nome_Dependente, Salário_Dependente)
a) Código no Github ou Pastebin de uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)
b) Código no Github ou Pastebin de uma Scalar Function que Retorne a soma dos Salários dos
dependentes, mais a do funcionário.
2. Fazer uma Function que retorne
a) a partir da tabela Produtos (codigo, nome, valor unitário e qtd estoque), quantos produtos
estão com estoque abaixo de um valor de entrada
b) Uma tabela com o código, o nome e a quantidade dos produtos que estão com o estoque
abaixo de um valor de entrada

3. Criar, uma UDF, que baseada nas tabelas abaixo, retorne
Nome do Cliente, Nome do Produto, Quantidade e Valor Total, Data de hoje
Tabelas iniciais:
Cliente (Codigo, nome)
Produto (Codigo, nome, valor)

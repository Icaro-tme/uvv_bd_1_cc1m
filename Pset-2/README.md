
### QUESTÃO 01: 
```SQL
--Prepare um relatório que mostre a média salarial dos funcionários de cada departamento. 

SELECT numero_departamento, TRUNCATE(AVG(salario),2) AS media_salarial /*TRUNCATE() faz com que o salario mostre apenas 2 decimais*/
FROM funcionario 
GROUP BY numero_departamento;
```
Tabela resultante:
```SQL
+---------------------+----------------+
| numero_departamento | media_salarial |
+---------------------+----------------+
|                   1 |       55000.00 |
|                   4 |       31000.00 |
|                   5 |       33250.00 |
+---------------------+----------------+
```
---
### QUESTÃO 02: 
Prepare um relatório que mostre a média salarial dos homens e das mulheres.

```SQL


SELECT 
(CASE WHEN sexo = 'M' THEN 'MASCULINO'
WHEN sexo = 'F' THEN 'FEMININO'
END) sexo,  /* CASE(Condicionais) troca a apresentação dos valores selecionados nas instâncias procuradas Ex: M -> Masculino*/

ROUND(AVG(salario),2) AS media_salarial /*TRUNCATE(AVG) faz com que o salario mostre apenas 2 decimais*/
FROM funcionario 
GROUP BY sexo;
```

```SQL
+-----------+----------------+
| sexo      | media_salarial |
+-----------+----------------+
| FEMININO  |       31000.00 |
| MASCULINO |       37600.00 |
+-----------+----------------+
```

--
### QUESTÃO 03: 
Prepare um relatório que liste o nome dos departamentos e, para cada departamento, inclua as seguintes informações de seus funcionários: nome completo, a data de nascimento, a idade em anos completos e o salário.

```SQL
SELECT departamento.nome_departamento, CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS nome_funcionario, 
funcionario.data_nascimento,  year(curdate()) - YEAR(data_nascimento) AS idade, 
funcionario.salario AS Salario 

FROM departamento

INNER JOIN funcionario ON departamento.numero_departamento = funcionario.numero_departamento

ORDER BY departamento.nome_departamento ASC; /*Ordem de departamento ASCENDENTE*/;
```

Tabela resultante:
<sub><sup>Ordenado para legibilidade</sup></sub>:

```SQL
+-------------------+------------------+-----------------+-------+----------+
| nome_departamento | nome_funcionario | data_nascimento | Idade | Salario  |
+-------------------+------------------+-----------------+-------+----------+
| Administração     | Alice J.Zelaya   | 1968-01-19      |    54 | 25000.00 |
| Administração     | Jennifer S.Souza | 1941-06-20      |    81 | 43000.00 |
| Administração     | André V.Pereira  | 1969-03-29      |    53 | 25000.00 |
| Matriz            | Jorge E.Brito    | 1937-11-10      |    85 | 55000.00 |
| Pesquisa          | Ronaldo K.Lima   | 1962-09-15      |    60 | 38000.00 |
| Pesquisa          | João B.Silva     | 1965-01-09      |    57 | 30000.00 |
| Pesquisa          | Fernando T.Wong  | 1955-12-08      |    67 | 40000.00 |
| Pesquisa          | Joice A.Leite    | 1972-07-31      |    50 | 25000.00 |
+-------------------+------------------+-----------------+-------+----------+
```
---
### QUESTÃO 04:
Prepare um relatório que mostre o nome completo dos funcionários, a idade em anos completos, o salário atual e o salário com um reajuste que obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a 35.000 o reajuste deve ser de 15%. 
```SQL
SELECT CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS nome, 
funcionario.data_nascimento, YEAR(CURDATE()) - YEAR(data_nascimento) AS idade, TRUNCATE(salario,2) AS salario_atual, TRUNCATE(salario,2)*1.2 AS salario_reajustado
FROM funcionario
WHERE salario < 35000 /*Salarios menores que 35 mil recebem 20% reajuste*/

UNION

SELECT CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS nome, funcionario.data_nascimento, YEAR(curdate()) - YEAR(data_nascimento) AS idade, TRUNCATE(salario,2) AS salario_atual, TRUNCATE(salario,2)*1.15 AS salario_reajustado 
FROM funcionario
WHERE salario >= 35000 /*Salarios igual ou maiores que 35 mil recebem 15% reajuste*/

ORDER BY salario_reajustado ASC; /*Ordem de salario reajustado ASCENDENTE*/
```

Tabela resultante 
<sub><sup>Ordenado para legibilidade</sup></sub>:

```SQL
+------------------+-----------------+-------+---------------+--------------------+
| nome             | data_nascimento | idade | salario_atual | salario_reajustado |
+------------------+-----------------+-------+---------------+--------------------+
| Joice A.Leite    | 1972-07-31      |    50 |      25000.00 |         30000.0000 |
| André V.Pereira  | 1969-03-29      |    53 |      25000.00 |         30000.0000 |
| Alice J.Zelaya   | 1968-01-19      |    54 |      25000.00 |         30000.0000 |
| João B.Silva     | 1965-01-09      |    57 |      30000.00 |         36000.0000 |
| Ronaldo K.Lima   | 1962-09-15      |    60 |      38000.00 |         43700.0000 |
| Fernando T.Wong  | 1955-12-08      |    67 |      40000.00 |         46000.0000 |
| Jennifer S.Souza | 1941-06-20      |    81 |      43000.00 |         49450.0000 |
| Jorge E.Brito    | 1937-11-10      |    85 |      55000.00 |         63250.0000 |
+------------------+-----------------+-------+---------------+--------------------+
```
---
### QUESTÃO 05: 
Prepare um relatório que liste, para cada departamento, o nome do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento (em ordem crescente) e por salário dos funcionários (em ordem decrescente). 


```SQL
SELECT departamento.nome_departamento as  'Departamento', 
CONCAT(funcionario.primeiro_nome," ", funcionario.nome_meio,".",funcionario.ultimo_nome) AS 'Nome Funcionário', 
funcionario.salario AS 'Salário',
CONCAT(func_gerente.primeiro_nome," ", func_gerente.nome_meio,".", func_gerente.ultimo_nome) AS 'Nome Gerente'

FROM departamento

LEFT JOIN funcionario 
ON departamento.numero_departamento = funcionario.numero_departamento 
/*Ver a tabela funcionario, sem alias, pra juntar de acordo com departamento*/

LEFT JOIN funcionario AS func_gerente 
ON departamento.cpf_gerente = func_gerente.cpf 
/*Ver a tabela funcionario, com o alias de gerente, pra juntar de acordo com o CPF, identificando quem é gerente*/

ORDER BY nome_departamento ASC, funcionario.salario DESC;
```
Tabela resultante:
```SQL
+-----------------+-------------------+----------+------------------+
| Departamento    | Nome Funcionário  | Salário  | Nome Gerente     |
+-----------------+-------------------+----------+------------------+
| Administração   | Jennifer S.Souza  | 43000.00 | Jennifer S.Souza |
| Administração   | André V.Pereira   | 25000.00 | Jennifer S.Souza |
| Administração   | Alice J.Zelaya    | 25000.00 | Jennifer S.Souza |
| Matriz          | Jorge E.Brito     | 55000.00 | Jorge E.Brito    |
| Pesquisa        | Fernando T.Wong   | 40000.00 | Fernando T.Wong  |
| Pesquisa        | Ronaldo K.Lima    | 38000.00 | Fernando T.Wong  |
| Pesquisa        | João B.Silva      | 30000.00 | Fernando T.Wong  |
| Pesquisa        | Joice A.Leite     | 25000.00 | Fernando T.Wong  |
+-----------------+-------------------+----------+------------------+
```

### QUESTÃO 06: 
Prepare um relatório que mostre o nome completo dos funcionários que têm dependentes, o departamento onde eles trabalham e, para cada funcionário, também liste o nome completo dos dependentes, a idade em anos de cada dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer como “Masculino” ou “Feminino”). 
```SQL
SELECT CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Funcionario com dependente',
departamento.nome_departamento AS 'Departamento onde Trabalham',
CONCAT(dependente.nome_dependente," ", funcionario.nome_meio,".",funcionario.ultimo_nome) AS 'Nome do Dependente',
YEAR(curdate()) - YEAR(dependente.data_nascimento) AS 'Idade do dependente',
(CASE dependente.sexo
WHEN 'M' THEN 'Masculino'
WHEN 'F' THEN 'Feminino'
END) AS 'Sexo do dependente'
FROM funcionario
INNER JOIN dependente ON dependente.cpf_funcionario=funcionario.cpf
INNER JOIN departamento ON departamento.numero_departamento = funcionario.numero_departamento;
```
Tabela resultante:
```SQL
+----------------------------+-----------------------------+--------------------+---------------------+--------------------+
| Funcionario com dependente | Departamento onde Trabalham | Nome do Dependente | Idade do dependente | Sexo do dependente |
+----------------------------+-----------------------------+--------------------+---------------------+--------------------+
| João B.Silva               | Pesquisa                    | Alicia B.Silva     |                  34 | Feminino           |
| João B.Silva               | Pesquisa                    | Elizabeth B.Silva  |                  55 | Feminino           |
| João B.Silva               | Pesquisa                    | Michael B.Silva    |                  34 | Masculino          |
| Fernando T.Wong            | Pesquisa                    | Alicia T.Wong      |                  36 | Feminino           |
| Fernando T.Wong            | Pesquisa                    | Janaína T.Wong     |                  64 | Feminino           |
| Fernando T.Wong            | Pesquisa                    | Tiago T.Wong       |                  39 | Masculino          |
| Jennifer S.Souza           | Administração               | Antonio S.Souza    |                  80 | Masculino          |
+----------------------------+-----------------------------+--------------------+---------------------+--------------------+
```

### QUESTÃO 07: 
Prepare um relatório que mostre, para cada funcionário que NÃO TEM dependente, seu nome completo, departamento e salário.
```SQL
SELECT 
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Funcionario sem dependente',
departamento.nome_departamento AS 'Departamento onde Trabalham',
funcionario.salario AS 'Salário'
FROM funcionario

INNER JOIN departamento ON departamento.numero_departamento = funcionario.numero_departamento

WHERE cpf NOT IN (SELECT cpf_funcionario FROM dependente); 
/*Apenas selecionar funcionários quais o CPF não aparece na coluna cpf_funcionário dentro da tabela Dependentes*/
```
Tabela resultante:

| Funcionario sem dependente | Departamento onde Trabalham | Salário  |
|----------------------------|-----------------------------|----------|
| Joice A.Leite              | Pesquisa                    | 25000.00 |
| Ronaldo K.Lima             | Pesquisa                    | 38000.00 |
| Jorge E.Brito              | Matriz                      | 55000.00 |
| André V.Pereira            | Administração               | 25000.00 |
| Alice J.Zelaya             | Administração               | 25000.00 |
|----------------------------|-----------------------------|----------|


### QUESTÃO 08: 
Prepare um relatório que mostre, para cada departamento, os projetos desse departamento e o nome completo dos funcionários que estão alocados em cada projeto. Além disso inclua o número de horas trabalhadas por cada funcionário, em cada projeto.
```SQL
SELECT 
departamento.nome_departamento AS 'Departamento', 
projeto.nome_projeto 'Nome do projeto',
CONCAT(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) "Nome do funcionário", 
TRUNCATE(trabalha_em.horas,1) 'Horas trabalhadas'

FROM funcionario

INNER JOIN departamento 
INNER JOIN projeto
INNER JOIN trabalha_em
WHERE (funcionario.cpf = trabalha_em.cpf_funcionario) 
AND (projeto.numero_projeto = trabalha_em.numero_projeto )
AND (funcionario.numero_departamento = departamento.numero_departamento )

ORDER BY projeto.numero_projeto ASC;
```
Tabela resultante:

| Departamento    | Nome do projeto  | Nome do funcionário  | Horas trabalhadas |
|-----------------|------------------|----------------------|-------------------|
| Pesquisa        | ProdutoX         | João B Silva         |              32.5 |
| Pesquisa        | ProdutoX         | Joice A Leite        |              20.0 |
| Pesquisa        | ProdutoY         | João B Silva         |               7.5 |
| Pesquisa        | ProdutoY         | Fernando T Wong      |              10.0 |
| Pesquisa        | ProdutoY         | Joice A Leite        |              10.0 |
| Pesquisa        | ProdutoZ         | Fernando T Wong      |              10.0 |
| Pesquisa        | ProdutoZ         | Ronaldo K Lima       |              40.0 |
| Pesquisa        | Informatização   | Fernando T Wong      |              10.0 |
| Administração   | Informatização   | André V Pereira      |              35.0 |
| Administração   | Informatização   | Alice J Zelaya       |              10.0 |
| Pesquisa        | Reogarnização    | Fernando T Wong      |              10.0 |
| Matriz          | Reogarnização    | Jorge E Brito        |               0.0 |
| Administração   | Reogarnização    | Jennifer S Souza     |              15.0 |
| Administração   | Novosbenefícios  | Jennifer S Souza     |              20.0 |
| Administração   | Novosbenefícios  | André V Pereira      |               5.0 |
| Administração   | Novosbenefícios  | Alice J Zelaya       |              30.0 |
|-----------------|------------------|----------------------|-------------------|


### QUESTÃO 09: 
Prepare um relatório que mostre a soma total das horas de cada projeto em cada departamento. Obs.: o relatório deve exibir o nome do departamento, o nome do projeto e a soma total das horas.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 10: 
Prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 11: 
Considerando que o valor pago por hora trabalhada em um projeto é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas naquele projeto.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 12: 
Seu chefe está verificando as horas trabalhadas pelos funcionários nos projetos e percebeu que alguns funcionários, mesmo estando alocadas à algum projeto, não registraram nenhuma hora trabalhada. Sua tarefa é preparar um relatório que liste o nome do departamento, o nome do projeto e o nome dos funcionários que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 13: 
Durante o natal deste ano a empresa irá presentear todos os funcionários e todos os dependentes (sim, a empresa vai dar um presente para cada funcionário e um presente para cada dependente de cada funcionário) e pediu para que você preparasse um relatório que listasse o nome completo das pessoas a serem presenteadas (funcionários e dependentes), o sexo e a idade em anos completos (para poder comprar um presente adequado). Esse relatório deve estar ordenado pela idade em anos completos, de forma decrescente. 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 14: 
Prepare um relatório que exiba quantos funcionários cada departamento tem.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 15: 
Como um funcionário pode estar alocado em mais de um projeto, prepare um relatório que exiba o nome completo do funcionário, o departamento desse funcionário e o nome dos projetos em que cada funcionário está alocado. Atenção: se houver algum funcionário que não está alocado em nenhum projeto, o nome completo e o departamento também devem aparecer no relatório. 
```SQL

```
Tabela resultante:
```SQL

```

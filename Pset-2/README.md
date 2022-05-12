
## QUESTÃO 01: 
>Prepare um relatório que mostre a **média salarial** dos **funcionários de cada departamento**. 

```SQL
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
TRUNCATE(AVG(salario),2) AS `Média Salarial`/*TRUNCATE() faz com que o salario mostre apenas 2 decimais*/

FROM funcionario 
INNER JOIN departamento ON funcionario.numero_departamento = departamento.numero_departamento

GROUP BY departamento.numero_departamento
ORDER BY `Média Salarial` ASC;
```
### Tabela 01: 

  * Ordenado por média salarial ascendente para melhor legibilidade
  
| Nome do Departamento | Média Salarial  |
|----------------------|-----------------|
| Administração        |        31000.00 |
| Pesquisa             |        33250.00 |
| Matriz               |        55000.00 |


---

## QUESTÃO 02: 
>Prepare um relatório que mostre a **média salarial** dos **homens e das mulheres**.

```SQL
SELECT 
(CASE WHEN sexo = 'M' THEN 'MASCULINO'
WHEN sexo = 'F' THEN 'FEMININO'
END) 'Sexo',  /* CASE(Condicionais) troca a apresentação dos valores selecionados nas instâncias procuradas Ex: M -> Masculino*/
ROUND(AVG(salario),2) AS 'Média salarial' 

FROM funcionario 
GROUP BY Sexo;
```
### Tabela 02: 


| Sexo      | Média salarial  |
|-----------|-----------------|
| FEMININO  |        31000.00 |
| MASCULINO |        37600.00 |



---

## QUESTÃO 03: 
>Prepare um relatório que liste o **nome dos departamentos** e, para cada departamento, inclua as seguintes informações de seus funcionários: **nome completo**, a **data de nascimento**, a **idade** em anos completos e o **salário**.

```SQL
SELECT 
departamento.nome_departamento AS 'Nome Departamento', 
funcionario.data_nascimento AS 'Data de Nascimento',
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Nome do Funcionário', 
TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS 'Idade', 
funcionario.salario AS 'Salario'

FROM departamento

INNER JOIN funcionario ON departamento.numero_departamento = funcionario.numero_departamento

ORDER BY `Nome Departamento` ASC; /*Ordem de departamento ASCENDENTE*/;
```

### Tabela 03:
* Ordenado por departamento para melhor legibilidade

| Nome Departamento | Data de Nascimento | Nome do Funcionário  | Idade | Salario  |
|-------------------|--------------------|----------------------|-------|----------|
| Administração     | 1968-01-19         | Alice J.Zelaya       |    54 | 25000.00 |
| Administração     | 1941-06-20         | Jennifer S.Souza     |    80 | 43000.00 |
| Administração     | 1969-03-29         | André V.Pereira      |    53 | 25000.00 |
| Matriz            | 1937-11-10         | Jorge E.Brito        |    84 | 55000.00 |
| Pesquisa          | 1962-09-15         | Ronaldo K.Lima       |    59 | 38000.00 |
| Pesquisa          | 1965-01-09         | João B.Silva         |    57 | 30000.00 |
| Pesquisa          | 1955-12-08         | Fernando T.Wong      |    66 | 40000.00 |
| Pesquisa          | 1972-07-31         | Joice A.Leite        |    49 | 25000.00 |


---
## QUESTÃO 04:
>Prepare um relatório que mostre o **nome completo dos funcionários**, a **idade em anos** completos, o **salário atual** e o **salário com um reajuste** que obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a 35.000 o reajuste deve ser de 15%.

```SQL
SELECT 
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Nome Completo', 
TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS 'Idade',
TRUNCATE(salario,2) AS 'Salario', 
TRUNCATE(salario,2)*1.2 AS 'Salario Reajustado'

FROM funcionario
WHERE salario < 35000 /*Salarios menores que 35 mil recebem 20% reajuste*/

UNION

SELECT CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Nome Completo',
TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS 'Idade',
TRUNCATE(salario,2) AS 'Salario', 
TRUNCATE(salario,2)*1.15 AS'Salario Reajustado' 

FROM funcionario
WHERE salario >= 35000 /*Salarios igual ou maiores que 35 mil recebem 15% reajuste*/

ORDER BY `Salario Reajustado` ASC; /*Ordem de salario reajustado ASCENDENTE*/
```

### Tabela 04: 
* Ordenado em Salário para melhor legibilidade

| Nome do Funcionário  | Idade | Salário  | Salário Reajustado  |
|----------------------|-------|----------|---------------------|
| Joice A.Leite        |    49 | 25000.00 |          30000.0000 |
| André V.Pereira      |    53 | 25000.00 |          30000.0000 |
| Alice J.Zelaya       |    54 | 25000.00 |          30000.0000 |
| João B.Silva         |    57 | 30000.00 |          36000.0000 |
| Ronaldo K.Lima       |    59 | 38000.00 |          43700.0000 |
| Fernando T.Wong      |    66 | 40000.00 |          46000.0000 |
| Jennifer S.Souza     |    80 | 43000.00 |          49450.0000 |
| Jorge E.Brito        |    84 | 55000.00 |          63250.0000 |

---
## QUESTÃO 05: 
>Prepare um relatório que liste, para cada **departamento**, o **nome do gerente** e o **nome dos funcionários**. Ordene esse relatório por **nome do departamento** (em ordem crescente) e por **salário dos funcionários** (em ordem decrescente). 


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
### Tabela 05:

| Departamento    | Nome do Funcionário  | Salário  | Nome do Gerente  |
|-----------------|----------------------|----------|------------------|
| Administração   | Jennifer S.Souza     | 43000.00 | Jennifer S.Souza |
| Administração   | Alice J.Zelaya       | 25000.00 | Jennifer S.Souza |
| Administração   | André V.Pereira      | 25000.00 | Jennifer S.Souza |
| Matriz          | Jorge E.Brito        | 55000.00 | Jorge E.Brito    |
| Pesquisa        | Fernando T.Wong      | 40000.00 | Fernando T.Wong  |
| Pesquisa        | Ronaldo K.Lima       | 38000.00 | Fernando T.Wong  |
| Pesquisa        | João B.Silva         | 30000.00 | Fernando T.Wong  |
| Pesquisa        | Joice A.Leite        | 25000.00 | Fernando T.Wong  |

---

## QUESTÃO 06: 
>Prepare um relatório que mostre o **nome completo** dos funcionários **que têm dependentes**, o **departamento** onde eles trabalham e, para cada funcionário, também liste o **nome completo dos dependentes**, a **idade** em anos de cada dependente e o **sexo** (o sexo NÃO DEVE aparecer como M ou F, deve aparecer como “Masculino” ou “Feminino”). 
```SQL
SELECT 
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Funcionario com dependente',
departamento.nome_departamento AS 'Departamento onde Trabalham',
CONCAT(dependente.nome_dependente," ", funcionario.nome_meio,".",funcionario.ultimo_nome) AS 'Nome do Dependente',
TIMESTAMPDIFF(YEAR, dependente.data_nascimento, CURDATE()) AS 'Idade do dependente',
(CASE dependente.sexo
WHEN 'M' THEN 'Masculino'
WHEN 'F' THEN 'Feminino'
END) AS 'Sexo do dependente'

FROM funcionario

INNER JOIN dependente ON dependente.cpf_funcionario=funcionario.cpf
INNER JOIN departamento ON departamento.numero_departamento = funcionario.numero_departamento;
```
### Tabela 06:

| Funcionario com dependente | Departamento onde Trabalham | Nome do Dependente | Idade do dependente | Sexo do dependente |
|----------------------------|-----------------------------|--------------------|---------------------|--------------------|
| João B.Silva               | Pesquisa                    | Alicia B.Silva     |                  33 | Feminino           |
| João B.Silva               | Pesquisa                    | Elizabeth B.Silva  |                  55 | Feminino           |
| João B.Silva               | Pesquisa                    | Michael B.Silva    |                  34 | Masculino          |
| Fernando T.Wong            | Pesquisa                    | Alicia T.Wong      |                  36 | Feminino           |
| Fernando T.Wong            | Pesquisa                    | Janaína T.Wong     |                  64 | Feminino           |
| Fernando T.Wong            | Pesquisa                    | Tiago T.Wong       |                  38 | Masculino          |
| Jennifer S.Souza           | Administração               | Antonio S.Souza    |                  80 | Masculino          |


---

## QUESTÃO 07: 
>Prepare um relatório que mostre, para cada **funcionário** que **NÃO TEM dependente**, seu **nome completo**, **departamento** e **salário**.
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
### Tabela 07:

| Funcionario sem dependente | Departamento onde Trabalham | Salário  |
|----------------------------|-----------------------------|----------|
| Joice A.Leite              | Pesquisa                    | 25000.00 |
| Ronaldo K.Lima             | Pesquisa                    | 38000.00 |
| Jorge E.Brito              | Matriz                      | 55000.00 |
| André V.Pereira            | Administração               | 25000.00 |
| Alice J.Zelaya             | Administração               | 25000.00 |


---

## QUESTÃO 08: 
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
### Tabela 08:

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


---

## QUESTÃO 09: 
Prepare um relatório que mostre a soma total das horas de cada projeto em cada departamento. Obs.: o relatório deve exibir o nome do departamento, o nome do projeto e a soma total das horas.

```SQL
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
projeto.nome_projeto AS 'Nome do Projeto', 
SUM(trabalha_em.horas) AS 'Horas Trabalhadas'

FROM trabalha_em

INNER JOIN projeto ON trabalha_em.numero_projeto = projeto.numero_projeto
INNER JOIN departamento ON departamento.numero_departamento = projeto.numero_departamento
GROUP BY projeto.nome_projeto, 
ORDER BY SUM(trabalha_em.horas) ASC;
```

### Tabela 09:
  
 <sub><sup>HORAS ordenadas para melhor legibilidade</sup></sub>
| Nome do Departamento | Nome do Projeto  | Horas Trabalhadas |
|----------------------|------------------|-------------------|
| Matriz               | Reogarnização    |              25.0 |
| Pesquisa             | ProdutoY         |              27.5 |
| Pesquisa             | ProdutoZ         |              50.0 |
| Pesquisa             | ProdutoX         |              52.5 |
| Administração        | Informatização   |              55.0 |
| Administração        | Novosbenefícios  |              55.0 |


---

## QUESTÃO 10: 
Prepare um relatório que mostre a média salarial dos funcionários de cada departamento.
```SQL
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
TRUNCATE(AVG(salario),2) AS 'Media Salarial'

FROM funcionario

INNER JOIN departamento ON funcionario.numero_departamento = departamento.numero_departamento
GROUP BY nome_departamento
ORDER BY TRUNCATE(AVG(salario),2) ASC;
```
### Tabela 10:

| Nome do Departamento | Media Salarial |
|----------------------|----------------|
| Administração        |       31000.00 |
| Pesquisa             |       33250.00 |
| Matriz               |       55000.00 |


---

## QUESTÃO 11: 
Considerando que o valor pago por hora trabalhada em um projeto é de 50 reais, prepare um relatório que mostre o nome completo do funcionário, o nome do projeto e o valor total que o funcionário receberá referente às horas trabalhadas naquele projeto.
```SQL
SELECT 
CONCAT(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) AS 'Nome do funcionário', 
projeto.nome_projeto AS 'Nome do Projeto', 
trabalha_em.horas AS 'Horas Trabalhadas',
trabalha_em.horas*50 AS 'Valor Total por Horas'

FROM funcionario
INNER JOIN trabalha_em on trabalha_em.cpf_funcionario = funcionario.cpf
INNER JOIN projeto on projeto.numero_projeto = trabalha_em.numero_projeto

ORDER BY primeiro_nome ASC, trabalha_em.horas ASC;
```
### Tabela 11:

| Nome do funcionário  | Nome do Projeto  | Horas Trabalhadas | Valor Total por Horas |
|----------------------|------------------|-------------------|-----------------------|
| Alice J Zelaya       | Informatização   |              10.0 |                 500.0 |
| Alice J Zelaya       | Novosbenefícios  |              30.0 |                1500.0 |
| André V Pereira      | Novosbenefícios  |               5.0 |                 250.0 |
| André V Pereira      | Informatização   |              35.0 |                1750.0 |
| Fernando T Wong      | ProdutoZ         |              10.0 |                 500.0 |
| Fernando T Wong      | Informatização   |              10.0 |                 500.0 |
| Fernando T Wong      | Reogarnização    |              10.0 |                 500.0 |
| Fernando T Wong      | ProdutoY         |              10.0 |                 500.0 |
| Jennifer S Souza     | Reogarnização    |              15.0 |                 750.0 |
| Jennifer S Souza     | Novosbenefícios  |              20.0 |                1000.0 |
| João B Silva         | ProdutoY         |               7.5 |                 375.0 |
| João B Silva         | ProdutoX         |              32.5 |                1625.0 |
| Joice A Leite        | ProdutoY         |              10.0 |                 500.0 |
| Joice A Leite        | ProdutoX         |              20.0 |                1000.0 |
| Jorge E Brito        | Reogarnização    |               0.0 |                   0.0 |
| Ronaldo K Lima       | ProdutoZ         |              40.0 |                2000.0 |

---

## QUESTÃO 12: 
Seu chefe está verificando as horas trabalhadas pelos funcionários nos projetos e percebeu que alguns funcionários, mesmo estando alocadas à algum projeto, não registraram nenhuma hora trabalhada. Sua tarefa é preparar um relatório que liste o nome do departamento, o nome do projeto e o nome dos funcionários que, mesmo estando alocados a algum projeto, não registraram nenhuma hora trabalhada.
```SQL
SELECT 
departamento.nome_departamento AS 'Nome do departamento', 
projeto.nome_projeto AS 'Projeto Designado', 
CONCAT(funcionario.primeiro_nome," ", funcionario.nome_meio,".",funcionario.ultimo_nome) AS 'Nome Funcionario', 
trabalha_em.horas AS 'Horas'

FROM funcionario
INNER JOIN departamento on departamento.numero_departamento = funcionario.numero_departamento
INNER JOIN trabalha_em on trabalha_em.cpf_funcionario = funcionario.cpf
INNER JOIN projeto on projeto.numero_projeto = trabalha_em.numero_projeto

WHERE (trabalha_em.horas = 0) OR (trabalha_em.horas IS NULL) ;
```
### Tabela 12:

| Nome do departamento | Projeto Designado | Nome Funcionario | Horas |
|----------------------|-------------------|------------------|-------|
| Matriz               | Reogarnização     | Jorge E.Brito    |   0.0 |


---

## QUESTÃO 13: 
Durante o natal deste ano a empresa irá presentear todos os funcionários e todos os dependentes (sim, a empresa vai dar um presente para cada funcionário e um presente para cada dependente de cada funcionário) e pediu para que você preparasse um relatório que listasse o nome completo das pessoas a serem presenteadas (funcionários e dependentes), o sexo e a idade em anos completos (para poder comprar um presente adequado). Esse relatório deve estar ordenado pela idade em anos completos, de forma decrescente. 
```SQL
SELECT 
CONCAT(funcionario.primeiro_nome," ", funcionario.nome_meio,".",funcionario.ultimo_nome) AS 'Pessoas a presentear', 
(CASE WHEN sexo = 'M' THEN 'MASCULINO'
WHEN sexo = 'F' THEN 'FEMININO'
END) 'Sexo',
TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS 'Idade'

FROM funcionario

UNION

SELECT /*Lembrar de por prefixos em todos os dados por conta do JOIN*/
CONCAT(dependente.nome_dependente," ",funcionario.ultimo_nome) AS 'Pessoas a presentear', 
/*Considerando que dependentes compartilham sobrenomes por matrimônio e paternidade, 
mas que não compartilham 100% de sobrenomes, exceto em caso de fraternidade, 
assume-se apenas o ultimo nome do funcionário à que depende*/
(CASE WHEN dependente.sexo = 'M' THEN 'MASCULINO'
WHEN dependente.sexo = 'F' THEN 'FEMININO'
END) 'Sexo',
TIMESTAMPDIFF(YEAR, dependente.data_nascimento, CURDATE()) AS 'Idade'

FROM dependente

INNER JOIN funcionario on dependente.cpf_funcionario = funcionario.cpf

ORDER BY Idade DESC; /*Ordem de salario reajustado ASCENDENTE*/
```
### Tabela 13:

| Pessoas a presentear | Sexo      | Idade |
|----------------------|-----------|-------|
| Jorge E.Brito        | MASCULINO |    84 |
| Antonio Souza        | MASCULINO |    80 |
| Jennifer S.Souza     | FEMININO  |    80 |
| Fernando T.Wong      | MASCULINO |    66 |
| Janaína Wong         | FEMININO  |    64 |
| Ronaldo K.Lima       | MASCULINO |    59 |
| João B.Silva         | MASCULINO |    57 |
| Elizabeth Silva      | FEMININO  |    55 |
| Alice J.Zelaya       | FEMININO  |    54 |
| André V.Pereira      | MASCULINO |    53 |
| Joice A.Leite        | FEMININO  |    49 |
| Tiago Wong           | MASCULINO |    38 |
| Alicia Wong          | FEMININO  |    36 |
| Michael Silva        | MASCULINO |    34 |
| Alicia Silva         | FEMININO  |    33 |


---

## QUESTÃO 14: 
Prepare um relatório que exiba quantos funcionários cada departamento tem.
```SQL
SELECT departamento.nome_departamento AS 'Nome Departamentos', 
COUNT(funcionario.cpf) as 'Quantidade de funcionarios'

FROM departamento

INNER JOIN funcionario on funcionario.numero_departamento = departamento.numero_departamento

GROUP BY departamento.nome_departamento

ORDER BY `Quantidade de Funcionarios` ASC; /* Uso de crase para selecinar alias da coluna com espaço (``)*/
```
### Tabela 14:

| Nome Departamentos | Quantidade de funcionarios |
|--------------------|----------------------------|
| Matriz             |                          1 |
| Administração      |                          3 |
| Pesquisa           |                          4 |


---

## QUESTÃO 15: 
Como um funcionário pode estar alocado em mais de um projeto, prepare um relatório que exiba o nome completo do funcionário, o departamento desse funcionário e o nome dos projetos em que cada funcionário está alocado. Atenção: se houver algum funcionário que não está alocado em nenhum projeto, o nome completo e o departamento também devem aparecer no relatório. 
```SQL
SELECT 
CONCAT(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) "Nome Completo",
departamento.nome_departamento 'Nome do Departamento', 
projeto.nome_projeto 'Projeto designado'

FROM funcionario

INNER JOIN departamento
INNER JOIN trabalha_em 
INNER JOIN projeto

WHERE departamento.numero_departamento = funcionario.numero_departamento 
AND projeto.numero_projeto = trabalha_em.numero_projeto 
AND trabalha_em.cpf_funcionario = funcionario.cpf

ORDER BY `Nome Completo` ASC;
```
### Tabela 15:

| Nome Completo    | Nome do Departamento | Projeto designado |
|------------------|----------------------|-------------------|
| Alice J Zelaya   | Administração        | Novosbenefícios   |
| Alice J Zelaya   | Administração        | Informatização    |
| André V Pereira  | Administração        | Novosbenefícios   |
| André V Pereira  | Administração        | Informatização    |
| Fernando T Wong  | Pesquisa             | Reogarnização     |
| Fernando T Wong  | Pesquisa             | ProdutoY          |
| Fernando T Wong  | Pesquisa             | Informatização    |
| Fernando T Wong  | Pesquisa             | ProdutoZ          |
| Jennifer S Souza | Administração        | Reogarnização     |
| Jennifer S Souza | Administração        | Novosbenefícios   |
| João B Silva     | Pesquisa             | ProdutoX          |
| João B Silva     | Pesquisa             | ProdutoY          |
| Joice A Leite    | Pesquisa             | ProdutoY          |
| Joice A Leite    | Pesquisa             | ProdutoX          |
| Jorge E Brito    | Matriz               | Reogarnização     |
| Ronaldo K Lima   | Pesquisa             | ProdutoZ          |


---


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
+--------+----------------+
| sexo   | media_salarial |
+--------+----------------+
| FEMALE |       31000.00 |
| MALE   |       37600.00 |
+--------+----------------+
```


### QUESTÃO 03: 
Prepare um relatório que liste o nome dos departamentos e, para cada departamento, inclua as seguintes informações de seus funcionários: nome completo, a data de nascimento, a idade em anos completos e o salário.

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
Tabela resultante:
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

### QUESTÃO 04:
Prepare um relatório que mostre o nome completo dos funcionários, a idade em anos completos, o salário atual e o salário com um reajuste que obedece ao seguinte critério: se o salário atual do funcionário é inferior a 35.000 o reajuste deve ser de 20%, e se o salário atual do funcionário for igual ou superior a 35.000 o reajuste deve ser de 15%. 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 05: 
Prepare um relatório que liste, para cada departamento, o nome do gerente e o nome dos funcionários. Ordene esse relatório por nome do departamento (em ordem crescente) e por salário dos funcionários (em ordem decrescente). 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 06: QUESTÃO 06: 
Prepare um relatório que mostre o nome completo dos funcionários que têm dependentes, o departamento onde eles trabalham e, para cada funcionário, também liste o nome completo dos dependentes, a idade em anos de cada dependente e o sexo (o sexo NÃO DEVE aparecer como M ou F, deve aparecer como “Masculino” ou “Feminino”). 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 07: 
Prepare um relatório que mostre, para cada funcionário que NÃO TEM dependente, seu nome completo, departamento e salário.
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 08: 
Prepare um relatório que mostre, para cada departamento, os projetos desse departamento e o nome completo dos funcionários que estão alocados em cada projeto. Além disso inclua o número de horas trabalhadas por cada funcionário, em cada projeto.
```SQL

```
Tabela resultante:
```SQL

```

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

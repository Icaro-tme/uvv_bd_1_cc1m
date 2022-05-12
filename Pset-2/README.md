
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
```SQL
--Prepare um relatório que mostre a média salarial dos homens e das mulheres.

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
```SQL
--Prepare um relatório que liste o nome dos departamentos e, para cada departamento, inclua as seguintes informações de seus funcionários: 
--o nome completo, a data de nascimento, a idade em anos completos e o salário.

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
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 05: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 06: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 07: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 08: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 09: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 10: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 11: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 12: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 13: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 14: 
```SQL

```
Tabela resultante:
```SQL

```

### QUESTÃO 15: 
```SQL

```
Tabela resultante:
```SQL

```

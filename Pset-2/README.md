
### QUESTÃO 01: 
```SQL
--Prepare um relatório que mostre a média salarial dos funcionários de cada departamento. 

SELECT numero_departamento, ROUND(AVG(salario),2) AS media_salarial /*ROUND(AVG) faz com que o salario mostre apenas 2 decimais*/
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

ROUND(AVG(salario),2) AS media_salarial /*ROUND(AVG) faz com que o salario mostre apenas 2 decimais*/
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
--Prepare um relatório que liste o nome dos departamentos e, para cada departamento, inclua as seguintes informações de seus funcionários: o nome completo, a data de nascimento, a idade em anos completos e o salário.

```
Tabela resultante:
```SQL

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

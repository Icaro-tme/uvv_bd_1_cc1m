
### QUESTÃO 01: 
```SQL
--Prepare um relatório que mostre a média salarial dos funcionários de cada departamento. 

SELECT numero_departamento, ROUND(AVG(salario),2) AS media_salarial --ROUND(AVG) faz com que o salario mostre apenas 2 decimais
FROM funcionario 
GROUP BY numero_departamento;
```

### QUESTÃO 02: 



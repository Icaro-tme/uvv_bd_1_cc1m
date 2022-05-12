--Questão 1
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
TRUNCATE(AVG(salario),2) AS `Média Salarial`/*TRUNCATE() faz com que o salario mostre apenas 2 decimais*/

FROM funcionario 
INNER JOIN departamento ON funcionario.numero_departamento = departamento.numero_departamento

GROUP BY departamento.numero_departamento
ORDER BY `Média Salarial` ASC;


--Questão 2
SELECT 
(CASE WHEN sexo = 'M' THEN 'MASCULINO'
WHEN sexo = 'F' THEN 'FEMININO'
END) 'Sexo',  /* CASE(Condicionais) troca a apresentação dos valores selecionados nas instâncias procuradas Ex: M -> Masculino*/
ROUND(AVG(salario),2) AS 'Média salarial' 

FROM funcionario 
GROUP BY Sexo;

--Questão 3
SELECT 
departamento.nome_departamento AS 'Nome Departamento', 
funcionario.data_nascimento AS 'Data de Nascimento',
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Nome do Funcionário', 
TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS 'Idade', 
funcionario.salario AS 'Salario'

FROM departamento

INNER JOIN funcionario ON departamento.numero_departamento = funcionario.numero_departamento

ORDER BY `Nome Departamento` ASC; /*Ordem de departamento ASCENDENTE*/;

--Questão 4
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

--Questão 5
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

--Questão 6
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

--Questão 7
SELECT 
CONCAT(primeiro_nome," ", nome_meio,".",ultimo_nome) AS 'Funcionario sem dependente',
departamento.nome_departamento AS 'Departamento onde Trabalham',
funcionario.salario AS 'Salário'
FROM funcionario

INNER JOIN departamento ON departamento.numero_departamento = funcionario.numero_departamento

WHERE cpf NOT IN (SELECT cpf_funcionario FROM dependente); 
/*Apenas selecionar funcionários quais o CPF não aparece na coluna cpf_funcionário dentro da tabela Dependentes*/

--Questão 8
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

--Questão 9
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
projeto.nome_projeto AS 'Nome do Projeto', 
SUM(trabalha_em.horas) AS 'Horas Trabalhadas'

FROM trabalha_em

INNER JOIN projeto ON trabalha_em.numero_projeto = projeto.numero_projeto
INNER JOIN departamento ON departamento.numero_departamento = projeto.numero_departamento
GROUP BY projeto.nome_projeto, 
ORDER BY SUM(trabalha_em.horas) ASC;

--Questão 10
SELECT 
departamento.nome_departamento AS 'Nome do Departamento', 
TRUNCATE(AVG(salario),2) AS 'Media Salarial'

FROM funcionario

INNER JOIN departamento ON funcionario.numero_departamento = departamento.numero_departamento
GROUP BY nome_departamento
ORDER BY TRUNCATE(AVG(salario),2) ASC;

--Questão 11
SELECT 
CONCAT(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) AS 'Nome do funcionário', 
projeto.nome_projeto AS 'Nome do Projeto', 
trabalha_em.horas AS 'Horas Trabalhadas',
trabalha_em.horas*50 AS 'Valor Total por Horas'

FROM funcionario
INNER JOIN trabalha_em on trabalha_em.cpf_funcionario = funcionario.cpf
INNER JOIN projeto on projeto.numero_projeto = trabalha_em.numero_projeto

ORDER BY `Nome do funcionário` ASC, trabalha_em.horas ASC;

--Questão 12
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

--Questão 13
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

ORDER BY Idade DESC; 

--Questão 14
SELECT departamento.nome_departamento AS 'Nome Departamentos', 
COUNT(funcionario.cpf) as 'Quantidade de funcionarios'

FROM departamento

INNER JOIN funcionario on funcionario.numero_departamento = departamento.numero_departamento

GROUP BY departamento.nome_departamento

ORDER BY `Quantidade de Funcionarios` ASC; /* Uso de crase para selecinar alias da coluna com espaço (``)*/

--Questão 15
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
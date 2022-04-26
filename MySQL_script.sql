

/*Criar usuario e dar dotos os privilégios para todas as operações*/
CREATE USER 'icaro'@'localhost' IDENTIFIED BY '123123';

GRANT ALL PRIVILEGES ON *.* TO 'icaro'@'localhost';

/*Flush nos privilegios pra dar reload nos usuarios*/
FLUSH PRIVILEGES;

/*sair da sessão mysql para entrar com usuário novo criado*/

exit

mysql -u icaro -p;

/*criar database*/
CREATE DATABASE UVV;

/*selecionar satabase para fazer alterações/inserir dados*/
USE UVV;

/*criar tabela departamento & comentarios*/
CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);

ALTER TABLE departamento COMMENT 'Tabela que armazenará as informações dos departamentos';

ALTER TABLE departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É a PK da tabela.';

ALTER TABLE departamento MODIFY COLUMN cpf_gerente CHAR(11) COMMENT 'CPF do gerente do departamento. FK para tabela funcionários';

ALTER TABLE departamento MODIFY COLUMN nome_departamento VARCHAR(15) COMMENT 'Nome do departamento. Deve ser único.';

ALTER TABLE departamento MODIFY COLUMN data_inicio_gerente DATE COMMENT 'Data do início do gerente no departamento.';

/*criar Indice Unico (AK) e adicioná-lo ao departamento.nome_departamento*/
CREATE UNIQUE INDEX indunico
 ON departamento
 ( nome_departamento );

/*criar tabela funcionario & comentarios*/
CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(50) NOT NULL,
                sexo CHAR(1) NOT NULL,
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);

ALTER TABLE funcionario COMMENT 'Tabela que armazena as informações dos funcionários.';

ALTER TABLE funcionario MODIFY COLUMN cpf CHAR(11) COMMENT 'CPF do funcionário. Será a PK da tabela.';

ALTER TABLE funcionario MODIFY COLUMN primeiro_nome VARCHAR(15) COMMENT 'Primeiro nome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN nome_meio CHAR(1) COMMENT 'Inicial do nome do meio.';

ALTER TABLE funcionario MODIFY COLUMN ultimo_nome VARCHAR(15) COMMENT 'Sobrenome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN data_nascimento DATE COMMENT 'Data de nascimento do funcionario.';

ALTER TABLE funcionario MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Endereço do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN sexo CHAR(1) COMMENT 'sexo do funcionario.';

ALTER TABLE funcionario MODIFY COLUMN salario DECIMAL(10, 2) COMMENT 'Salário do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN cpf_supervisor CHAR(11) COMMENT 'CPF do supervisor. FK de si mesma (auto-relacionamento)';

ALTER TABLE funcionario MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento do funcionário.';

/*criar tabela dependente & comentarios*/
CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1) NOT NULL,
                data_nascimento DATE,
                parentesco VARCHAR(15) NOT NULL,
                PRIMARY KEY (cpf_funcionario, nome_dependente)
);

ALTER TABLE dependente COMMENT 'Tabela que armazena as informações dos dependentes dos funcionários.';

ALTER TABLE dependente MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'para a tabela funcionário.';

ALTER TABLE dependente MODIFY COLUMN nome_dependente VARCHAR(15) COMMENT 'Nome do dependente. Faz parte da PK desta tabela.';

ALTER TABLE dependente MODIFY COLUMN sexo CHAR(1) COMMENT 'sexo do dependente.';

ALTER TABLE dependente MODIFY COLUMN data_nascimento DATE COMMENT 'Data de nascimento do dependente.';

ALTER TABLE dependente MODIFY COLUMN parentesco VARCHAR(15) COMMENT 'Descrição do parentesco do dependente com o funcionário.';

/*criar tabela projeto & comentarios*/
CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);

ALTER TABLE projeto COMMENT 'Tabela que armazena as informações sobre os projetos dos departamentos.';

ALTER TABLE projeto MODIFY COLUMN numero_projeto INTEGER COMMENT 'Número do projeto. É a PK desta tabela.';

ALTER TABLE projeto MODIFY COLUMN nome_projeto VARCHAR(15) COMMENT 'Nome do projeto. Deve ser único.';

ALTER TABLE projeto MODIFY COLUMN local_projeto VARCHAR(15) COMMENT 'Localização do projeto.';

ALTER TABLE projeto MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É uma FK para a tabela departamento.';

/*criar tabela trabalha_em & comentarios*/
CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto)
);

ALTER TABLE trabalha_em COMMENT 'Tabela para armazenar quais funcionários trabalham em quais projetos.';

ALTER TABLE trabalha_em MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'para a tabela funcionário.';

ALTER TABLE trabalha_em MODIFY COLUMN numero_projeto INTEGER COMMENT 'Para a tabela projeto.';

ALTER TABLE trabalha_em MODIFY COLUMN horas DECIMAL(3, 1) COMMENT 'Horas trabalhadas pelo funcionário neste projeto.';

/*criar tabela localizacoes_departamento & comentarios*/
CREATE TABLE localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);

ALTER TABLE localizacoes_departamento COMMENT 'Tabela que armazena as possíveis localizações dos departamentos.';

ALTER TABLE localizacoes_departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'm é uma FK para a tabela departamento.';

ALTER TABLE localizacoes_departamento MODIFY COLUMN local VARCHAR(15) COMMENT 'Localização do departamento. Faz parte da PK desta tabela.';

/*----- Adicionando Constraints/Criando relações entre tabelas com foreign keys ----- */

--Foreign key que faltava no projeto
ALTER TABLE funcionario ADD CONSTRAINT departamento_funcionario_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
--A adição dessa foreign key implica que para adicionar os primeiros dados deve se desabilitar os checks de FK para a sessão pois as tabelas estão vazias, e depois ligá-las novamente


ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

/*----------------INSERTS DE DADOS--------------------*/
/*
# Desativar o Foreign Key check da sessão para a inserção dos primeiros dados (não é permitido a insersão de um dado que é foreign key de uma outra tabela quando o mesmo não existe nela Ex: Departamento precisa de uma chave que existe em funcionario (CPF) mas funcionario precisa de uma chave que exite em departamento (num_departamento)) 
*/

SET FOREIGN_KEY_CHECKS=0;

--# Insert da tabela funcionarios
--# Jorge precisa ser inserido primeiro pois o CPF dele é uma foreign key de outros funcionarios
INSERT INTO funcionario(primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('Jorge', 'E', 'Brito', '88866555576', '1937-11-10','Rua do Horto, 35, São Paulo, SP', 'M', '55000', '88866555576', 1 ),
('Jennifer', 'S', 'Souza', '98765432168', '1941-06-20','Av.Arthur de Lima, 54, Santo André, SP', 'F', '43000', '88866555576', 4 ),
('Alice', 'J', 'Zelaya', '99988777767', '1968-01-19','Rua Souza Lima, 35, Curitiba, PR', 'F', '25000', '98765432168', 4 ),
('André', 'V', 'Pereira', '98798798733', '1969-03-29','Rua Timbira, 35, São Paulo, SP', 'M', '25000', '98765432168', 4 ),
('Fernando', 'T', 'Wong', '33344555587', '1955-12-08','Rua da Lapa, 34, São Paulo, SP', 'M', '40000', '88866555576', 5 ),
('João', 'B', 'Silva', '12345678966', '1965-01-09','Rua das Flores, 751, São Paulo, SP', 'M', '30000', '33344555587', 5 ),
('Ronaldo', 'K', 'Lima', '66688444476', '1962-09-15','Rua Rebouças, 65, Piracicaba, SP', 'M', '38000', '33344555587', 5 ),
('Joice', 'A', 'Leite', '45345345376', '1972-07-31','Av. Lucas Obes, 74, São Paulo, SP', 'F', '25000', '33344555587', 5 );

--Ativar o Foreign Key check da sessão após a inserção dos primeiros dados 
SET FOREIGN_KEY_CHECKS=1;


--# Insert da tabela departamento		
INSERT INTO departamento (nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES ('Pesquisa', 5, 33344555587, '1988-05-22'),
('Administração', 4, 98765432168, '1995-01-01'),
('Matriz', 1, 88866555576, '1981-06-19');

--# Insert da tabela localizacoes_departamento
INSERT INTO localizacoes_departamento (numero_departamento, local) 	 
VALUES (1, 'São Paulo'),
(4, 'Mauá'),
(5, 'Santo André'),
(5, 'Itu'),
(5, 'São Paulo');

--# Insert da tabela projeto
INSERT INTO projeto (nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES ('ProdutoX', 1, 'Santo André', 5),
('ProdutoY', 2, 'Itu', 5),
('ProdutoZ', 3, 'São Paulo', 5),
('Informatização', 10,'Mauá', 4),
('Reogarnização', 20, 'São Paulo', 1),
('Novosbenefícios', 30, 'Mauá', 4);

--# Insert da tabela dependente
INSERT INTO dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES (33344555587, 'Alicia', 'F', '1986-04-05', 'Filha'),
(33344555587, 'Tiago', 'M', '1983-10-25', 'Filho'),
(33344555587, 'Janaína', 'F', '1958-05-03', 'Esposa'),
(98765432168, 'Antonio', 'M', '1942-02-28', 'Marido'),
(12345678966, 'Michael', 'M', '1988-01-04', 'Filho'),
(12345678966, 'Alicia', 'F', '1988-12-30', 'Filha'),
(12345678966, 'Elizabeth', 'F', '1967-05-05', 'Esposa');

--# Insert da tabela trabalha_em
insert into trabalha_em (cpf_funcionario, numero_projeto, horas)
values (12345678966, 1, 32.5),
(12345678966, 2, 7.5),
(66688444476, 3, 40.0),
(45345345376, 1, 20.0),
(45345345376, 2, 10.0),
(33344555587, 2, 10.0),
(33344555587, 3, 10.0),
(33344555587, 10, 10.0),
(33344555587, 20, 10.0),
(99988777767, 30, 30.0),
(99988777767, 10, 10.0),
(98798798733, 10, 35.0),
(98798798733, 30, 5.0),
(98765432168, 30, 20.0),
(98765432168, 20, 15.0),
(88866555576, 20, 0);

-->Fim dos inserts





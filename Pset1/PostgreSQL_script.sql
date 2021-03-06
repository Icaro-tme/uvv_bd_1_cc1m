


--> SQL da Criação Usuário pelo PGADMIN 4 & DATABASE

CREATE ROLE icaro WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	PASSWORD '123123';

CREATE DATABASE uvv
    WITH 
    OWNER = icaro
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
   	ALLOW_CONNECTIONS = TRUE;

COMMENT ON DATABASE uvv
IS 'Database UVV para amazenamento das tabelas';


/*---------------Conexão com a database (senha 123123)------------------*/

\c uvv icaro;

--> senha 123123


--> SQL da Criação Elmasri pelo PGADMIN


CREATE SCHEMA elmasri
    AUTHORIZATION icaro;

COMMENT ON SCHEMA elmasri
    IS 'Esquema de Banco de Dados';


/*--------------- Trocar o schema public para o Elmasri ------------------*/
SET SEARCH_PATH TO elmasri, "icaro", public;



ALTER USER icaro
SET SEARCH_PATH TO elmasri, "icaro", public;


--> Tabela departamento + Comentarios sobre tabela


CREATE TABLE departamento (
                numero_departamento INTEGER NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT pk_departamento PRIMARY KEY (numero_departamento)
);
COMMENT ON TABLE departamento IS 'Tabela que armazenará as informações dos departamentos';
COMMENT ON COLUMN departamento.numero_departamento IS 'Número do departamento. É a PK da tabela.';
COMMENT ON COLUMN departamento.cpf_gerente IS 'CPF do gerente do departamento. FK para tabela funcionários';
COMMENT ON COLUMN departamento.nome_departamento IS 'Nome do departamento. Deve ser único.';
COMMENT ON COLUMN departamento.data_inicio_gerente IS 'Data do início do gerente no departamento.';



--> Criação de AK (indice unico)

CREATE UNIQUE INDEX indunico
 ON departamento
 ( nome_departamento );


/*
# Tabela funcionarios + Comentarios sobre tabela
# Constraints extras: Sexo apenas F/M 
# Salario não pode ser negativo
*/
CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(50) NOT NULL,
                sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F')),
                salario NUMERIC(10,2) CHECK (salario >= 0),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INTEGER NOT NULL,

             
                CONSTRAINT pk_funcionario PRIMARY KEY (cpf)

);
COMMENT ON TABLE funcionario IS 'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN funcionario.cpf IS 'CPF do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN funcionario.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN funcionario.nome_meio IS 'Inicial do nome do meio.';
COMMENT ON COLUMN funcionario.ultimo_nome IS 'Sobrenome do funcionário.';
COMMENT ON COLUMN funcionario.data_nascimento IS 'Data de nascimento do funcionario.';
COMMENT ON COLUMN funcionario.endereco IS 'Endereço do funcionário.';
COMMENT ON COLUMN funcionario.sexo IS 'sexo do funcionario.';
COMMENT ON COLUMN funcionario.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN funcionario.cpf_supervisor IS 'CPF do supervisor. FK de si mesma (auto-relacionamento)';
COMMENT ON COLUMN funcionario.numero_departamento IS 'Número do departamento do funcionário.';


/*
# Tabela dependente + Comentarios sobre tabela
# Constraints extras: Sexo apenas F/M 
*/
CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1) NOT NULL CHECK (SEXO IN ('M', 'F')),
                data_nascimento DATE,
                parentesco VARCHAR(15) NOT NULL,

                CONSTRAINT pk_dependente PRIMARY KEY (cpf_funcionario, nome_dependente)
);
COMMENT ON TABLE dependente IS 'Tabela que armazena as informações dos dependentes dos funcionários.';
COMMENT ON COLUMN dependente.cpf_funcionario IS 'para a tabela funcionário.';
COMMENT ON COLUMN dependente.nome_dependente IS 'Nome do dependente. Faz parte da PK desta tabela.';
COMMENT ON COLUMN dependente.sexo IS 'sexo do dependente.';
COMMENT ON COLUMN dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN dependente.parentesco IS 'Descrição do parentesco do dependente com o funcionário.';



--> Tabela projeto + Comentarios sobre tabela

CREATE TABLE projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_projeto PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE projeto IS 'Tabela que armazena as informações sobre os projetos dos departamentos.';
COMMENT ON COLUMN projeto.numero_projeto IS 'Número do projeto. É a PK desta tabela.';
COMMENT ON COLUMN projeto.nome_projeto IS 'Nome do projeto. Deve ser único.';
COMMENT ON COLUMN projeto.local_projeto IS 'Localização do projeto.';
COMMENT ON COLUMN projeto.numero_departamento IS 'Número do departamento. É uma FK para a tabela departamento.';

/*
# Tabela trabalha_em + Comentarios sobre tabela
# Constraints extras: horas trabalhadas não pode ser negativo
*/
CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL CHECK (horas >= 0),

                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE trabalha_em IS 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN trabalha_em.cpf_funcionario IS 'para a tabela funcionário.';
COMMENT ON COLUMN trabalha_em.numero_projeto IS 'Para a tabela projeto.';
COMMENT ON COLUMN trabalha_em.horas IS 'Horas trabalhadas pelo funcionário neste projeto.';



--> Tabela localizacoes_departamento + Comentarios sobre tabela

CREATE TABLE localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localiacoes_departamento PRIMARY KEY (numero_departamento, local)
);
COMMENT ON TABLE localizacoes_departamento IS 'Tabela que armazena as possíveis localizações dos departamentos.';
COMMENT ON COLUMN localizacoes_departamento.numero_departamento IS 'm é uma FK para a tabela departamento.';
COMMENT ON COLUMN localizacoes_departamento.local IS 'Localização do departamento. Faz parte da PK desta tabela.';


/*
 ---------------- Relacionamentos de chave estrangeira entre tabelas -------------------
*/

--Foreign key que faltava no projeto
ALTER TABLE funcionario ADD CONSTRAINT departamento_funcionario_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
--A adição dessa foreign key implica que para adicionar os primeiros dados deve se desabilitar os checks de FK para a sessão pois as tabelas estão vazias, e depois ligá-las novamente

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (CPF)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (CPF)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_Em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (CPF)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (CPF)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_Em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


/*------------------------------INSERSÃO DE VALORES NAS TABELAS CRIADAS-----------------------------*/

/*
# Desativar o Foreign Key check (trigger) da sessão para a inserção dos primeiros dados (não é permitido a insersão de um dado que é foreign key de uma outra tabela quando o mesmo não existe nela Ex: Departamento precisa de uma chave que existe em funcionario (CPF) mas funcionario precisa de uma chave que exite em departamento (num_departamento)) 
*/

ALTER TABLE funcionario DISABLE TRIGGER ALL;



--# Insert da tabela funcionarios

INSERT INTO funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento,endereco, sexo, salario, cpf_supervisor, numero_departamento) 	
VALUES  ('Fernando', 'T', 'Wong', 33344555587, '1955-08-12', 'Rua da Lapa, 34, São Paulo, SP', 'M', 40.000, 88866555576,5),('João', 'B', 'Silva', 12345678966, '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 33344555587, 5),('Alice', 'J', 'Zelaya', 99988777767, '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25.000, 98765432168, 4),('Jennifer', 'S', 'Souza', 98765432168, '1941-06-20', 'Av.Arthur de Lima, 54, Santo André, SP', 'F', 43.000, 88866555576, 4),('Ronaldo', 'K', 'Lima', 66688444476, '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', 38.000, 33344555587, 5),('Joice', 'A', 'Leite', 45345345376, '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', 25.000, 33344555587, 5),('André', 'V', 'Pereira', 98798798733, '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', 25.000, 98765432168, 4),('Jorge', 'E', 'Brito', 88866555576, '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55.000, 88866555576, 1);

--Após insersão as constraint serão reativadas e validadas  departamento_funcionario_fk
ALTER TABLE funcionario DISABLE TRIGGER ALL;

ALTER TABLE funcionario VALIDATE CONSTRAINT departamento_funcionario_fk;


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


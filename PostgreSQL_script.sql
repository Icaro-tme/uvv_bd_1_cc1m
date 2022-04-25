/*
-> SQL da Criação Usuário pelo PGADMIN 4 & DATABASE
*/
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


/*
-> SQL da Criação Elmasri pelo PGADMIN
*/

CREATE SCHEMA elmasri
    AUTHORIZATION icaro;

COMMENT ON SCHEMA elmasri
    IS 'Esquema de Banco de Dados';

/*
-> Tabela departamento + Comentarios sobre tabela
*/

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


/*
-> Criação de AK (indice unico)
*/
CREATE UNIQUE INDEX indunico
 ON departamento
 ( nome_departamento );


/*
-> Tabela funcionarios + Comentarios sobre tabela
*/
CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30) NOT NULL,
                sexo CHAR(1) NOT NULL,
                salario NUMERIC(10,2),
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
-> Tabela dependente + Comentarios sobre tabela
*/
CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1) NOT NULL,
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


/*
-> Tabela projeto + Comentarios sobre tabela
*/
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
-> Tabela trabalha_em + Comentarios sobre tabela
*/
CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE trabalha_em IS 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN trabalha_em.cpf_funcionario IS 'para a tabela funcionário.';
COMMENT ON COLUMN trabalha_em.numero_projeto IS 'Para a tabela projeto.';
COMMENT ON COLUMN trabalha_em.horas IS 'Horas trabalhadas pelo funcionário neste projeto.';


/*
-> Tabela localizacoes_departamento + Comentarios sobre tabela
*/
CREATE TABLE localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local_ VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localiacoes_departamento PRIMARY KEY (numero_departamento, local_)
);
COMMENT ON TABLE localizacoes_departamento IS 'Tabela que armazena as possíveis localizações dos departamentos.';
COMMENT ON COLUMN localizacoes_departamento.numero_departamento IS 'm é uma FK para a tabela departamento.';
COMMENT ON COLUMN localizacoes_departamento.local_ IS 'Localização do departamento. Faz parte da PK desta tabela.';


/*
 ---------------- Relacionamentos de chave estrangeira entre tabelas -------------------
*/
ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT departamento_funcionario_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk1
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

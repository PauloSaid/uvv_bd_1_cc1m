CREATE ROLE "Paulo" WITH
    LOGIN
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    NOREPLICATION
    CONNECTION LIMIT -1
    PASSWORD '123';

CREATE DATABASE uvv
    WITH 
    OWNER = "Paulo"
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    CONNECTION LIMIT = -1;

\c uvv;

   CREATE SCHEMA elmasri
    AUTHORIZATION "Paulo";


   ALTER USER "Paulo"
SET SEARCH_PATH TO elmasri, "$Paulo", public;

CREATE TABLE elmasri.funcionarios (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                numero_departamento INTEGER NOT NULL,
                cpf_supervisor CHAR(11) NOT NULL,
                CONSTRAINT pk_funcionarios PRIMARY KEY (cpf)
);
COMMENT ON TABLE elmasri.funcionarios IS 'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN elmasri.funcionarios.cpf IS 'CPF do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN elmasri.funcionarios.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.nome_meio IS 'Inicial do nome do meio.';
COMMENT ON COLUMN elmasri.funcionarios.ultimo_nome IS 'Sobrenome do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.data_nascimento IS 'Data de nascimento do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.endereco IS 'Endereço do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.sexo IS 'Sexo do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionarios.numero_departamento IS 'Número do departamento do funcionário. FK de departamento';
COMMENT ON COLUMN elmasri.funcionarios.cpf_supervisor IS 'Cpf do supervisor. É FK da própria tabela.';



CREATE TABLE elmasri.dependentes (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT pk_dependentes PRIMARY KEY (cpf_funcionario, nome_dependente)
);
COMMENT ON TABLE elmasri.dependentes IS 'Tabela que armazena as informações dos dependentes dos funcionários.';
COMMENT ON COLUMN elmasri.dependentes.cpf_funcionario IS 'CPF do funcionário. PK desta tabela e FK de funcionário.';
COMMENT ON COLUMN elmasri.dependentes.nome_dependente IS 'Nome do dependente. Faz parte da PK desta tabela.';
COMMENT ON COLUMN elmasri.dependentes.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependentes.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependentes.parentesco IS 'Descrição do parentesco do dependente com o funcionário.';


CREATE TABLE elmasri.departamentos (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT pk_departamentos PRIMARY KEY (numero_departamento)
);
COMMENT ON TABLE elmasri.departamentos IS 'Tabela que armazena as informaçoẽs dos departamentos.';
COMMENT ON COLUMN elmasri.departamentos.numero_departamento IS 'Número do departamento. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.departamentos.nome_departamento IS 'Nome do departamento. Deve ser único.';
COMMENT ON COLUMN elmasri.departamentos.cpf_gerente IS 'CPF do gerente do departamento.FK de funcionários.';
COMMENT ON COLUMN elmasri.departamentos.data_inicio_gerente IS 'Data do início do gerente no departamento.';

CREATE UNIQUE INDEX departamentos_idx
 ON elmasri.departamentos
 ( nome_departamento );



CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_projeto PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE elmasri.projeto IS 'Tabela que armazena as informações sobre os projetos dos departamentos.';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto. Deve ser único.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Número do departamento. É uma FK de departamento.';


CREATE UNIQUE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto );


CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionário. PK desta tabela e FK de funcionário.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Número do projeto. PK desta tabela e FK de projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionário neste projeto.';

CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localizacoes_departamento PRIMARY KEY (numero_departamento, local)
);
COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela que armazena as possíveis localizações dos departamentos.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento. PK desta tabela e FK de departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento. Faz parte da PK desta tabela.';

ALTER TABLE elmasri.departamentos ADD CONSTRAINT funcionarios_departamentos_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.dependentes ADD CONSTRAINT funcionarios_dependentes_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionarios_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.funcionarios ADD CONSTRAINT funcionarios_funcionarios_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionarios (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamentos_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamentos (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.projeto ADD CONSTRAINT departamentos_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamentos (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento) 
VALUES ('88866555576', 'Jorge', 'E', 'Brito', '1937-11-10','RuadoHorto35,SãoPaulo,SP', 'M', '55000', '88866555576', 1 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('98765432168', 'Jennifer', 'S', 'Souza', '1941-06-20','AvArthurLima54,SantoAndré,SP', 'F', '43000', '88866555576', 4 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('99988777767', 'Alice', 'J', 'Zelaya', '1968-01-19','RuaSouzaLima35,Curitiba,PR', 'F', '25000', '98765432168', 4 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('98798798733','André', 'V','Pereira', '1969-03-29','RuaTimbira35,SãoPaulo,SP', 'M', '25000', '98765432168', 4 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('33344555587', 'Fernando', 'T', 'Wong', '1955-12-08','RuadaLapa34,São Paulo,SP', 'M', '40000', '88866555576', 5 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('12345678966', 'João', 'B', 'Silva', '1965-01-09','RuadasFlores751,SãoPaulo,SP', 'M', '30000', '33344555587', 5 );

INSERT INTO elmasri.funcionarios(cpf,primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('66688444476', 'Ronaldo', 'K', 'Lima', '1962-09-15','RuaRebouças65,Piracicaba,SP', 'M', '38000', '33344555587', 5 );

INSERT INTO elmasri.funcionarios(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento ) 
VALUES ('45345345376','Joice', 'A', 'Leite', '1972-07-31','AvLucasObes74,SãoPaulo,SP', 'F', '25000', '33344555587', 5 );





INSERT INTO elmasri.departamentos( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Matriz', 1, '88866555576', '1981-06-19');

INSERT INTO elmasri.departamentos( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Pesquisa', 5, '33344555587', '1988-05-22');

INSERT INTO elmasri.departamentos( nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
VALUES( 'Administração', 4, '98765432168', ' 1995-01-01');




INSERT INTO elmasri.localizacoes_departamento( numero_departamento, local)
VALUES( 1, ' São Paulo');

INSERT INTO elmasri.localizacoes_departamento( numero_departamento, local)
VALUES( 4, ' Mauá');

INSERT INTO elmasri.localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' Santo André');

INSERT INTO elmasri.localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' Itu');

INSERT INTO elmasri.localizacoes_departamento( numero_departamento, local)
VALUES( 5, ' São Paulo');





INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoX', 1, 'Santo André', 5);

INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoY', 2, 'Itu', 5);

INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'ProdutoZ', 3, 'São Paulo', 5);

INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Informatização', 10, 'Mauá', 4);

INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Reorganização', 20, 'São Paulo', 1);

INSERT INTO elmasri.projeto( nome_projeto, numero_projeto, local_projeto, numero_departamento)
VALUES( 'Novosbenefícios', 30, 'Mauá', 4);



INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Alícia', 'F', '1986-04-05', 'Filha');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Tiago', 'M', '1983-10-25', 'Filho');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '98765432168', 'Antonio', 'M', '1942-02-28', 'Marido');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Michael', 'M', '1988-01-04', 'Filho');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Alícia', 'F', '1988-12-30', 'Filha');

INSERT INTO elmasri.dependentes( cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES( '12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');




INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '12345678966', 1, '32.5');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '12345678966', 2, '7.5');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '66688444476', 3, '40.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '45345345376', 1, '20.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '45345345376', 2, '20.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 2, '10.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 3, '10.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 10, '10.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '33344555587', 20, '10.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '99988777767', 30, '30.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '99988777767', 10, '10.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98798798733', 10, '35.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98798798733', 30, '5.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98765432168', 30, '20.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '98765432168', 20, '15.0');

INSERT INTO elmasri.trabalha_em( cpf_funcionario, numero_projeto, horas)
VALUES( '88866555576', 20, '0');
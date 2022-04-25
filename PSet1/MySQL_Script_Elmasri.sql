mysql -u root -p
computacao@raiz


create database uvv


create user paulo identified by '123456';

grant all privileges on uvv.* to paulo;


system mysql -u paulo -p
123456

use uvv;

CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(45),
                sexo CHAR(1),
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);

CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                PRIMARY KEY (cpf_funcionario, nome_dependente)

);
CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);

CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE  localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);

CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);

CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto_trabalha_em INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto_trabalha_em)
);

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE  localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto_trabalha_em)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;







INSERT INTO funcionario
VALUES (88866555576, 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, 88866555576, 1);

INSERT INTO funcionario
VALUES(33344555587, 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa, 34, São Paulo, SP', 'M', 40000, 88866555576, 5);

INSERT INTO funcionario
VALUES (98765432168, 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av. Arthur de Lima, 54, Santo André, SP', 'F', 43000, 88866555576, 4);

INSERT INTO funcionario
VALUES (12345678966, 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 33344555587, 5);

INSERT INTO funcionario
VALUES (66688444476, 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', 38000, 33344555587, 5);

INSERT INTO funcionario
VALUES (45345345376, 'Joice', 'A', 'Leite', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', 25000, 33344555587, 5);

INSERT INTO funcionario
VALUES (99988777767, 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, 98765432168, 4);

INSERT INTO funcionario
VALUES (98798798733, 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', 25000, 98765432168, 4);




INSERT INTO departamento
VALUES (1, 'Matriz', 88866555576, '1981-06-19');

INSERT INTO departamento
VALUES (5, 'Pesquisa', 33344555587, '1988-05-22');

INSERT INTO departamento
VALUES (4, 'Administração', 98765432168, '1995-01-01');




INSERT INTO localizacoes_departamento 
VALUES (1, 'São Paulo');

INSERT INTO localizacoes_departamento 
VALUES (4, 'Mauá');

INSERT INTO localizacoes_departamento
VALUES (5, 'Santo Andre');

INSERT INTO localizacoes_departamento 
VALUES (5, 'Itu');

INSERT INTO localizacoes_departamento 
VALUES (5, 'São Paulo');




INSERT INTO projeto
VALUES (1, 'ProdutoX', 'Santo André', 5);

INSERT INTO projeto
VALUES (2, 'ProdutoY', 'Itu', 5);

INSERT INTO projeto
VALUES (3, 'ProdutoZ', 'São Paulo', 5);

INSERT INTO projeto
VALUES (10, 'Informatização', 'Mauá', 4);

INSERT INTO projeto
VALUES (20, 'Reorganização', 'São Paulo', 1);

INSERT INTO projeto
VALUES (30, 'Novosbenefícios', 'Mauá', 4);





INSERT INTO dependente
VALUES (33344555587, 'Alicia', 'F', '1986-04-05', 'Filha');

INSERT INTO dependente
VALUES (33344555587, 'Tiago', 'M', '1983-10-25', 'Filho');

INSERT INTO dependente
VALUES (33344555587, 'Janaína', 'F', '1958-05-03', 'Esposa');

INSERT INTO dependente
VALUES (98765432168, 'Antonio', 'M', '1942-02-28', 'Marido');

INSERT INTO dependente
VALUES (12345678966, 'Michael', 'M', '1988-01-04', 'Filho');

INSERT INTO dependente
VALUES (12345678966, 'Alicia', 'F', '1988-12-30', 'Filha');

INSERT INTO dependente
VALUES (12345678966, 'Elizabeth', 'F', '1967-05-05', 'Esposa');




INSERT INTO trabalha_em 
VALUES (12345678966, 1, 32.5);


INSERT INTO trabalha_em 
VALUES (12345678966, 2, 7.5);


INSERT INTO trabalha_em 
VALUES (66688444476, 3, 40);


INSERT INTO trabalha_em 
VALUES (45345345376, 1, 20);


INSERT INTO trabalha_em 
VALUES (45345345376, 2, 20);


INSERT INTO trabalha_em 
VALUES (33344555587, 2, 10);


INSERT INTO trabalha_em 
VALUES (33344555587, 3, 10);


INSERT INTO trabalha_em 
VALUES (33344555587, 10, 10);


INSERT INTO trabalha_em 
VALUES (33344555587, 20, 10);


INSERT INTO trabalha_em 
VALUES (99988777767, 30, 30);


INSERT INTO trabalha_em 
VALUES (99988777767, 10, 10);


INSERT INTO trabalha_em 
VALUES (98798798733, 10, 35);


INSERT INTO trabalha_em 
VALUES (98798798733, 30, 5);

INSERT INTO trabalha_em 
VALUES (98765432168, 30, 20);

INSERT INTO trabalha_em 
VALUES (98765432168, 20, 15);

INSERT INTO trabalha_em 
VALUES (88866555576, 20, 0);
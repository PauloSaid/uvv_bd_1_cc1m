use uvv;



-- Questão 01

SELECT ROUND(AVG(salario),2) AS media_salarial, d.nome_departamento 
FROM funcionario f 
INNER JOIN departamento d 
ON d.numero_departamento = f.numero_departamento 
GROUP BY d.nome_departamento; 

-- Questão 02

SELECT round(AVG(f.salario),2) AS media_salarial, f.sexo 
FROM funcionario f 
GROUP BY f.sexo; 

-- Questão 03

SELECT f.primeiro_nome, f.nome_meio, f.ultimo_nome, f.data_nascimento, YEAR(curdate()) - YEAR(data_nascimento) AS Idade, f.salario, d.nome_departamento 
FROM funcionario f 
INNER JOIN departamento d 
ON f.numero_departamento = d.numero_departamento; 

-- Questão 04

SELECT 
CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS NomeCompleto, 
year(curdate()) - year(data_nascimento) as idade, f.salario, 
CASE 
    WHEN salario >= 35000 THEN salario*1.20 
    ELSE salario*1.15 
END AS SalarioReajustado 
from funcionario f; 

-- Questão 05

SELECT nome_departamento, g.primeiro_nome AS gerente, f.primeiro_nome AS funcionario, salario 
FROM departamento d 
INNER JOIN funcionario f, 
(SELECT primeiro_nome, cpf 
FROM funcionario f 
INNER JOIN departamento d WHERE f.cpf = d.cpf_gerente) AS G 
WHERE d.numero_departamento = f.numero_departamento AND g.cpf=d.cpf_gerente ORDER BY d.nome_departamento ASC, f.salario DESC; 

-- Questão 06

SELECT dp.nome_departamento AS "Nome do Departamento", CONCAT(f.primeiro_nome, " ", f.nome_meio, " ", f.ultimo_nome) AS "Nome Funcionário", d.nome_dependente AS "Nome do Dependente", YEAR(curdate()) - YEAR(d.data_nascimento) AS "Idade do Dependente", 
(CASE 
WHEN d.sexo = "m" THEN "Masculino" 
WHEN d.sexo = "f" THEN "Feminino" 
END) AS "Sexo do Dependente" 
FROM funcionario f 
INNER JOIN dependente d ON d.cpf_funcionario=f.cpf 
INNER JOIN departamento dp ON dp.numero_departamento=f.numero_departamento; 

-- Questão 07

SELECT f.cpf AS "CPF do Funcionário", CONCAT(f.primeiro_nome, " ", f.nome_meio, " ", f.ultimo_nome) AS "Nome Funcionário", dp.nome_departamento, f.salario 
FROM funcionario f 
INNER JOIN departamento dp ON dp.numero_departamento = f.numero_departamento 
WHERE 
NOT EXISTS( 
			SELECT 1 FROM dependente dp WHERE dp.cpf_funcionario = f.cpf 
); 

-- Questão 08

SELECT d.nome_departamento, 
	 CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario, 
	 p.nome_projeto, 
	 t.horas 
FROM trabalha_em t 
INNER JOIN funcionario f ON t.cpf_funcionario=f.cpf 
INNER JOIN departamento d ON d.numero_departamento=f.numero_departamento 
INNER JOIN projeto p ON p.numero_projeto=t.numero_projeto 
ORDER BY d.numero_departamento 
;

-- Questão 09

SELECT d.nome_departamento, p.nome_projeto, SUM(t.horas) AS "Total de Horas" 
FROM projeto p 
INNER JOIN departamento d ON d.numero_departamento=p.numero_departamento 
INNER JOIN trabalha_em t ON t.numero_projeto=p.numero_projeto 
GROUP BY p.nome_projeto;

-- Questão 10

SELECT ROUND(AVG(salario),2) AS media_salarial, d.nome_departamento 
FROM funcionario f 
INNER JOIN departamento d 
ON d.numero_departamento = f.numero_departamento 
GROUP BY d.nome_departamento; 

-- Questão 11

SELECT CONCAT(f.primeiro_nome, " ", f.nome_meio, " ", f.ultimo_nome) AS "Nome Completo", p.nome_projeto, t.horas, (t.horas*50) AS "Total Pago" 
FROM trabalha_em AS t 
INNER JOIN funcionario AS f ON t.cpf_funcionario=f.cpf 
INNER JOIN projeto AS p ON t.numero_projeto=p.numero_projeto 
ORDER BY f.primeiro_nome;

-- Questão 12

SELECT d.nome_departamento, CONCAT(f.primeiro_nome, " ", f.nome_meio, " ", f.ultimo_nome) AS "Nome Funcionário", p.nome_projeto, t.horas 
FROM trabalha_em AS t 
INNER JOIN funcionario f ON t.cpf_funcionario=f.cpf 
INNER JOIN projeto p ON t.numero_projeto=p.numero_projeto 
INNER JOIN departamento d ON d.numero_departamento=f.numero_departamento 
WHERE t.horas=0;

-- Questão 13

SELECT CONCAT(f.primeiro_nome, " ", f.nome_meio, " ", f.ultimo_nome) AS "Nome Completo Funcionário", f.sexo AS "Sexo do Funcionário", YEAR(curdate()) - YEAR(f.data_nascimento) AS "Idade do Funcionário", 
dp.nome_dependente AS "Nome de seu Dependente", dp.sexo AS "Sexo do Dependente", (YEAR(curdate()) - YEAR(dp.data_nascimento)) AS "Idade do Dependente" 
FROM funcionario AS f 
INNER JOIN dependente AS dp ON f.cpf=dp.cpf_funcionario 
ORDER BY f.data_nascimento;

-- Questão 14

SELECT d.nome_departamento AS "Nome do Departamento",
(
	SELECT COUNT(*) 
		FROM funcionario AS f 
		WHERE f.numero_departamento=d.numero_departamento 
        
) AS "Total de Funcionários" 
FROM departamento AS d;
        
-- Questão 15

SELECT DISTINCT CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) as "Nome", 
d.nome_departamento AS departamento,  
p.nome_projeto AS projeto 
FROM departamento d INNER JOIN projeto p INNER JOIN trabalha_em t INNER JOIN funcionario f  
WHERE d.numero_departamento = f.numero_departamento AND p.numero_projeto = t.numero_projeto AND 
t.cpf_funcionario = f.cpf 
UNION 
SELECT DISTINCT CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS Nome, 
d.nome_departamento AS departamento,  
"Sem Projeto" AS projeto 
FROM departamento d INNER JOIN projeto p INNER JOIN trabalha_em t INNER JOIN funcionario f 
WHERE d.numero_departamento = f.numero_departamento AND p.numero_projeto = t.numero_projeto AND 
(f.cpf NOT IN (SELECT t.cpf_funcionario FROM trabalha_em t)); 
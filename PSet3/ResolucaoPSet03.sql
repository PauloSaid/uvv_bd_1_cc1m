with recursive classificacao_P as (
	select c.codigo, concat(nome) as nome, c.codigo_pai 
	from classificacao as c 
	where codigo_pai is null
	
	union all
	
	select  c2.codigo, concat(clasp.nome, '-->', c2.nome) , c2.codigo_pai 
	from classificacao as c2
	inner join classificacao_P as clasp on clasp.codigo = c2.codigo_pai
	where c2.codigo_pai is not null
)

select codigo as Código, nome as Itens, codigo_pai as "Código Pai"
from classificacao_P 
order by classificacao_P;




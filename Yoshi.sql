-- Yoshi request
select bp.name `id`, date_format(bp.creation, '%Y-%m-%d') `date create`, bp.customer_name, bp.customer_tel , 
	case when timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) =0 then 1 
	else timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `year_type`,
	case when tspb.id is not null then tspb.month_type else timestampdiff(month, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `month_type`,
	bp.rank1, 
	case when bp.contract_status = 'Contracted' then 'Contracted' else bp.rank_update end `type`,
	CASE WHEN bp.contract_status = 'Contracted' then 'x' else 'ok' end `without contracted`
from tabSME_BO_and_Plan bp left join temp_sme_pbx_BO tspb on (bp.name = tspb.id)
where bp.rank1 in ('S', 'A', 'B', 'C', 'F') ;

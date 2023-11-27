

-- SABC result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-11-01' then 'S' when rank_A_date >= '2023-11-01' then 'A' when rank_B_date >= '2023-11-01' then 'B' when rank_C_date >= '2023-11-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-11-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-11-01' or rank_A_date >= '2023-11-01' or rank_B_date >= '2023-11-01' or rank_C_date >= '2023-11-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('SABC', 'S', 'A', 'B', 'C') )
order by sme.id asc;



-- F_3mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-11-01' then 'S' when rank_A_date >= '2023-11-01' then 'A' when rank_B_date >= '2023-11-01' then 'B' when rank_C_date >= '2023-11-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-11-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-11-01' or rank_A_date >= '2023-11-01' or rank_B_date >= '2023-11-01' or rank_C_date >= '2023-11-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type <= 3)
order by sme.id asc;


-- F_6mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-11-01' then 'S' when rank_A_date >= '2023-11-01' then 'A' when rank_B_date >= '2023-11-01' then 'B' when rank_C_date >= '2023-11-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-11-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-11-01' or rank_A_date >= '2023-11-01' or rank_B_date >= '2023-11-01' or rank_C_date >= '2023-11-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type between 4 and 6)
order by sme.id asc;


-- F_9mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-11-01' then 'S' when rank_A_date >= '2023-11-01' then 'A' when rank_B_date >= '2023-11-01' then 'B' when rank_C_date >= '2023-11-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-11-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-11-01' or rank_A_date >= '2023-11-01' or rank_B_date >= '2023-11-01' or rank_C_date >= '2023-11-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type between 7 and 9)
order by sme.id asc;





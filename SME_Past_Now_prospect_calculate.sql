
CREATE TABLE `temp_sme_pbx_BO_1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_tel` varchar(255) DEFAULT NULL,
  `pbx_status` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `current_staff` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `month_type` int(11) DEFAULT NULL COMMENT '3=3 months or less, 6=6months or less, 9=9months or less, 12=12months or less',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=204987 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


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


insert into tabSME_BO_and_Plan; select * from tabSME_BO_and_Plan_bk where name not in (select name from tabSME_BO_and_Plan);

select * from tabsme_Sales_partner_bk where name not in (select name from tabsme_Sales_partner);

-- check and add to the list temp_sme_pbx_BO
select bp.name `id`, bp.customer_tel `tel`, null `pbx_status`, null `date`, sme.staff_no `current_staff`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `type`,
	timestampdiff(month,date_format(bp.creation, '%Y-%m-%d'), date(now())) `month_type`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') >= '2023-11-01' and bp.rank_update in ('S', 'A', 'B', 'C') 
	and bp.contract_status not in ('Contracted', 'Cancelled')
order by bp.name asc;

-- updtate assign to new people
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tss on (bp.name = tss.id)
set bp.staff_no = tss.current_staff
where tss.`type` in ('SABC', 'S', 'A', 'B', 'C') ;



-- __________________________________________ F_3mo result __________________________________________
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





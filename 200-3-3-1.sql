

-- export for 200-3-3-1 daily report
select date_format(bp.creation, '%Y-%m-%d') `input_date`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_no else smec.staff_no end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	bp.rank_update, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`, bp.customer_tel `tel`, null `telno`, bp.customer_name ,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village , 
	bp.maker, bp.model, bp.usd_loan_amount, bp.disbursement_date_pay_date , bp.name `primary_key`, bp.`type` `contract_type`, bp.approch_list, bp.is_sales_partner,
	case when left(bp.is_sales_partner, locate(' ', bp.is_sales_partner)-1) in ('X', 'Y', 'Z') then 1 else 0 end `is_sales_partner`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') >=  date(now()) -- '2024-06-04' 
and bp.rank_update in ('S', 'A', 'B', 'C', 'F', 'G') 
order by bp.name asc;


-- export visit for 200-3-3-1 
select sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	sme.staff_no `Staff No`, sme.staff_name `Staff Name`, bp.visit_date, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`,
	bp.name `customer_id` , bp.customer_name , bp.customer_tel `phone1` , null `phone2`, bp.`type`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bp.visit_date = date(now()) 
and bp.visit_date is not null
order by bp.visit_date asc, sme.id asc, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) desc;




create table `temp_sme_SABCF` (
  `id` int(11) not null auto_increment,
  `current_staff` varchar(255) default null,
  `type` varchar(255) default null,
  primary key (`id`)
) engine=innodb auto_increment=116054 default charset=utf8mb4 collate=utf8mb4_general_ci;


create table `temp_sme_SABCF_remove_duplicate` (
  `id` int(11) not null auto_increment,
  `current_staff` varchar(255) default null,
  `type` varchar(255) default null,
  primary key (`id`)
) engine=innodb auto_increment=1 default charset=utf8mb4 collate=utf8mb4_general_ci;


-- SME_now_SABC https://docs.google.com/spreadsheets/d/1ufgINqUYboNJtQLqMFbywADzm_mLQTllh4QtlZODPi0/edit#gid=700696176
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	-- sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`, bp.staff_no `Staff No`, sme.staff_name `Staff Name`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	1 `point`, `type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name , bp.customer_tel ,
	bp.ringi_status , bp.ringi_comment , bp.disbursement_date_pay_date , bp.contract_status , bp.contract_comment , bp.customer_card , bp.rank1 , bp.approch_list , bp.rank_update , 
	bp.visit_date , bp.visit_or_not ,
	case when contract_status = 'Cancelled' then 'Cancelled' else null end `Cancelled Result`, 
	case when rank_update in ('S','A','B','C') then 1 else 0 end `SABC`, 
	case when rank_update in ('C') then 1 else 0 end `C`, 
	sme.sales_cc `sales_cc`, bp.name `id`,
	concat(bp.staff_no,'-', date_format(bp.visit_date, '%c'),'-',date_format(bp.visit_date, '%e'),'-', case when bp.priority_to_visit = '' then 1 else bp.priority_to_visit end ) `Visit plan M-D-P`,
	regexp_replace(bp.sp_cc , '[^[:digit:]]', '') `Sales promotion CC`,
	bp.rank_update_sp_cc ,
	case when left(bp.double_count, locate('-', bp.double_count)-2) = '' then bp.double_count else left(bp.double_count, locate('-', bp.double_count)-2) end `Double count person`,
	regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') `CC`,
	date_format(bp.creation, '%Y-%m-%d') `Date created`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end `rank1_SABC`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.contract_status = 'Contracted' then date_format(bp.modified, '%Y-%m-%d') else null end `rank_X_date`,
	rank_S_date, rank_A_date, rank_B_date, rank_C_date,
	case when bp.contract_status = 'Cancelled' then date_format(bp.modified, '%Y-%m-%d') else null end `Cancelled_date`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year`,
	case -- 1. New customer is order below here
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'S' then 1.1
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'A' then 1.2
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'B' then 1.3
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'C' then 1.4
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'F' then 1.5
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'G' then 1.6
		-- 2.1 Dormant customer with high loan amount (over 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 50000 then 2.11
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 40000 then 2.12
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 30000 then 2.13
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 20000 then 2.14
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 10000 then 2.15
		-- 2.2 Dormant customer with low loan amount (less than 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 50000 then 2.21
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 40000 then 2.22
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 30000 then 2.23
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 20000 then 2.24
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 10000 then 2.25
		-- 2.3 Dormant customer with low loan amount and asset (less than 10,000$) but has good business they will be sales partner is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '1 Bank/ທະນາຄານ' then 2.31
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '2 Insurance/ບໍລິສັດ ປະກັນໄພ' then 2.32
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '14 Finance Institute/ສະຖາບັນການເງິນ' then 2.33
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '15 Leasing/ບໍລິສັດ ສິນເຊື່ອ' then 2.34
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ' then 2.35
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່' then 2.36
		-- 3.1 Existing customer with high increase amount (over 1,000$) is order below here
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 50000 then 3.11
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 40000 then 3.12
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 30000 then 3.13
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 20000 then 3.14
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 10000 then 3.15
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 5000 then 3.16
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 3000 then 3.17
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 1000 then 3.18
		-- 3.2 Increase customer with low increase amount (less than 1,000$) and delay collection Rank CF need to upgrade collection rank to be SAB is order below here
	end `visit_order`,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village,
	is_sales_partner `SP_rank`
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.rank_update in ('S','A','B','C')
	and bp.contract_status not in ('Contracted', 'Cancelled')  -- if contracted before '2023-10-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
	and bp.name not in (select id from temp_sme_SABCF) -- if it's in SABC target not need
	and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null -- if resigned staff no need
order by sme.id asc;



-- SME_past_SABC https://docs.google.com/spreadsheets/d/1ufgINqUYboNJtQLqMFbywADzm_mLQTllh4QtlZODPi0/edit#gid=700696176
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	-- sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`, bp.staff_no `Staff No`, sme.staff_name `Staff Name`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	1 `point`, `type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name , bp.customer_tel ,
	bp.ringi_status , bp.ringi_comment , bp.disbursement_date_pay_date , bp.contract_status , bp.contract_comment , bp.customer_card , bp.rank1 , bp.approch_list , bp.rank_update , 
	bp.visit_date , bp.visit_or_not ,
	case when contract_status = 'Cancelled' then 'Cancelled' else null end `Cancelled Result`, 
	case when rank_update in ('S','A','B','C') then 1 else 0 end `SABC`, 
	case when rank_update in ('C') then 1 else 0 end `C`, 
	sme.sales_cc `sales_cc`, bp.name `id`,
	concat(bp.staff_no,'-', date_format(bp.visit_date, '%c'),'-',date_format(bp.visit_date, '%e'),'-', case when bp.priority_to_visit = '' then 1 else bp.priority_to_visit end ) `Visit plan M-D-P`,
	regexp_replace(bp.sp_cc , '[^[:digit:]]', '') `Sales promotion CC`,
	bp.rank_update_sp_cc ,
	case when left(bp.double_count, locate('-', bp.double_count)-2) = '' then bp.double_count else left(bp.double_count, locate('-', bp.double_count)-2) end `Double count person`,
	regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') `CC`,
	date_format(bp.creation, '%Y-%m-%d') `Date created`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end `rank1_SABC`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.contract_status = 'Contracted' then date_format(bp.modified, '%Y-%m-%d') else null end `rank_X_date`,
	rank_S_date, rank_A_date, rank_B_date, rank_C_date,
	case when bp.contract_status = 'Cancelled' then date_format(bp.modified, '%Y-%m-%d') else null end `Cancelled_date`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year`,
	case -- 1. New customer is order below here
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'S' then 1.1
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'A' then 1.2
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'B' then 1.3
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'C' then 1.4
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'F' then 1.5
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'G' then 1.6
		-- 2.1 Dormant customer with high loan amount (over 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 50000 then 2.11
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 40000 then 2.12
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 30000 then 2.13
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 20000 then 2.14
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 10000 then 2.15
		-- 2.2 Dormant customer with low loan amount (less than 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 50000 then 2.21
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 40000 then 2.22
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 30000 then 2.23
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 20000 then 2.24
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 10000 then 2.25
		-- 2.3 Dormant customer with low loan amount and asset (less than 10,000$) but has good business they will be sales partner is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '1 Bank/ທະນາຄານ' then 2.31
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '2 Insurance/ບໍລິສັດ ປະກັນໄພ' then 2.32
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '14 Finance Institute/ສະຖາບັນການເງິນ' then 2.33
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '15 Leasing/ບໍລິສັດ ສິນເຊື່ອ' then 2.34
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ' then 2.35
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່' then 2.36
		-- 3.1 Existing customer with high increase amount (over 1,000$) is order below here
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 50000 then 3.11
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 40000 then 3.12
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 30000 then 3.13
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 20000 then 3.14
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 10000 then 3.15
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 5000 then 3.16
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 3000 then 3.17
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 1000 then 3.18
		-- 3.2 Increase customer with low increase amount (less than 1,000$) and delay collection Rank CF need to upgrade collection rank to be SAB is order below here
	end `visit_order`,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village,
	is_sales_partner `SP_rank`
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
-- where bp.`custtbl_id` is not null and bp.creation >= '2022-10-01'
where bp.name in (select id from temp_sme_SABCF where `type` in ('SABC', 'S', 'A', 'B', 'C') )
order by case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end asc;




-- SME_now_F https://docs.google.com/spreadsheets/d/1HoPxR88w3o-_vGvFEpqxmIVztBLf4XU6vJm5x2NZmfg/edit#gid=1233301414
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	-- sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`, bp.staff_no `Staff No`, sme.staff_name `Staff Name`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	1 `point`, `type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name , bp.customer_tel ,
	bp.ringi_status , bp.ringi_comment , bp.disbursement_date_pay_date , bp.contract_status , bp.contract_comment , bp.customer_card , bp.rank1 , bp.approch_list , bp.rank_update , 
	bp.visit_date , bp.visit_or_not ,
	case when contract_status = 'Cancelled' then 'Cancelled' else null end `Cancelled Result`, 
	case when rank_update in ('S','A','B','C') then 1 else 0 end `SABC`, 
	case when rank_update in ('C') then 1 else 0 end `C`, 
	sme.sales_cc `sales_cc`, bp.name `id`,
	concat(bp.staff_no,'-', date_format(bp.visit_date, '%c'),'-',date_format(bp.visit_date, '%e'),'-', case when bp.priority_to_visit = '' then 1 else bp.priority_to_visit end ) `Visit plan M-D-P`,
	regexp_replace(bp.sp_cc , '[^[:digit:]]', '') `Sales promotion CC`,
	bp.rank_update_sp_cc ,
	case when left(bp.double_count, locate('-', bp.double_count)-2) = '' then bp.double_count else left(bp.double_count, locate('-', bp.double_count)-2) end `Double count person`,
	regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') `CC`,
	date_format(bp.creation, '%Y-%m-%d') `Date created`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end `rank1_SABC`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.contract_status = 'Contracted' then date_format(bp.modified, '%Y-%m-%d') else null end `rank_X_date`,
	rank_S_date, rank_A_date, rank_B_date, rank_C_date,
	case when bp.contract_status = 'Cancelled' then date_format(bp.modified, '%Y-%m-%d') else null end `Cancelled_date`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year`,
	case -- 1. New customer is order below here
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'S' then 1.1
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'A' then 1.2
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'B' then 1.3
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'C' then 1.4
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'F' then 1.5
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'G' then 1.6
		-- 2.1 Dormant customer with high loan amount (over 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 50000 then 2.11
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 40000 then 2.12
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 30000 then 2.13
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 20000 then 2.14
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 10000 then 2.15
		-- 2.2 Dormant customer with low loan amount (less than 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 50000 then 2.21
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 40000 then 2.22
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 30000 then 2.23
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 20000 then 2.24
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 10000 then 2.25
		-- 2.3 Dormant customer with low loan amount and asset (less than 10,000$) but has good business they will be sales partner is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '1 Bank/ທະນາຄານ' then 2.31
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '2 Insurance/ບໍລິສັດ ປະກັນໄພ' then 2.32
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '14 Finance Institute/ສະຖາບັນການເງິນ' then 2.33
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '15 Leasing/ບໍລິສັດ ສິນເຊື່ອ' then 2.34
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ' then 2.35
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່' then 2.36
		-- 3.1 Existing customer with high increase amount (over 1,000$) is order below here
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 50000 then 3.11
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 40000 then 3.12
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 30000 then 3.13
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 20000 then 3.14
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 10000 then 3.15
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 5000 then 3.16
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 3000 then 3.17
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 1000 then 3.18
		-- 3.2 Increase customer with low increase amount (less than 1,000$) and delay collection Rank CF need to upgrade collection rank to be SAB is order below here
	end `visit_order`,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village,
	is_sales_partner `SP_rank`
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.rank_update in ('F')
	and bp.contract_status not in ('Contracted', 'Cancelled')  -- if contracted before '2023-10-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
	and bp.name not in (select id from temp_sme_SABCF) -- if it's in SABC target not need
	and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null -- if resigned staff no need
order by sme.id asc;




-- Past prospect F
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	-- sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`, bp.staff_no `Staff No`, sme.staff_name `Staff Name`, 
	sme.dept `DEPT`, 
	sme.sec_branch `SECT`, 
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	1 `point`, `type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name , bp.customer_tel ,
	bp.ringi_status , bp.ringi_comment , bp.disbursement_date_pay_date , bp.contract_status , bp.contract_comment , bp.customer_card , bp.rank1 , bp.approch_list , bp.rank_update , 
	bp.visit_date , bp.visit_or_not ,
	case when contract_status = 'Cancelled' then 'Cancelled' else null end `Cancelled Result`, 
	case when rank_update in ('S','A','B','C') then 1 else 0 end `SABC`, 
	case when rank_update in ('C') then 1 else 0 end `C`, 
	sme.sales_cc `sales_cc`, bp.name `id`,
	concat(bp.staff_no,'-', date_format(bp.visit_date, '%c'),'-',date_format(bp.visit_date, '%e'),'-', case when bp.priority_to_visit = '' then 1 else bp.priority_to_visit end ) `Visit plan M-D-P`,
	regexp_replace(bp.sp_cc , '[^[:digit:]]', '') `Sales promotion CC`,
	bp.rank_update_sp_cc ,
	case when left(bp.double_count, locate('-', bp.double_count)-2) = '' then bp.double_count else left(bp.double_count, locate('-', bp.double_count)-2) end `Double count person`,
	regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') `CC`,
	date_format(bp.creation, '%Y-%m-%d') `Date created`,
	case when bp.rank1 in ('S','A','B','C') then 1 else 0 end `rank1_SABC`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.contract_status = 'Contracted' then date_format(bp.modified, '%Y-%m-%d') else null end `rank_X_date`,
	rank_S_date, rank_A_date, rank_B_date, rank_C_date,
	case when bp.contract_status = 'Cancelled' then date_format(bp.modified, '%Y-%m-%d') else null end `Cancelled_date`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year`,
	case -- 1. New customer is order below here
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'S' then 1.1
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'A' then 1.2
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'B' then 1.3
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted') and bp.rank_update = 'C' then 1.4
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'F' then 1.5
		when bp.`type` = 'New' and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.contract_status not in ('Contracted', 'Cancelled') and bp.rank_update = 'G' then 1.6
		-- 2.1 Dormant customer with high loan amount (over 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 50000 then 2.11
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 40000 then 2.12
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 30000 then 2.13
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 20000 then 2.14
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_loan_amount_of_old_contract >= 10000 then 2.15
		-- 2.2 Dormant customer with low loan amount (less than 10,000$) is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 50000 then 2.21
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 40000 then 2.22
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 30000 then 2.23
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 20000 then 2.24
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract >= 10000 then 2.25
		-- 2.3 Dormant customer with low loan amount and asset (less than 10,000$) but has good business they will be sales partner is order below here
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '1 Bank/ທະນາຄານ' then 2.31
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '2 Insurance/ບໍລິສັດ ປະກັນໄພ' then 2.32
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '14 Finance Institute/ສະຖາບັນການເງິນ' then 2.33
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '15 Leasing/ບໍລິສັດ ສິນເຊື່ອ' then 2.34
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ' then 2.35
		when (bp.`type` = 'Dor' or bp.list_type = 'Dor_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.business_type = '37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່' then 2.36
		-- 3.1 Existing customer with high increase amount (over 1,000$) is order below here
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 50000 then 3.11
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 40000 then 3.12
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 30000 then 3.13
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 20000 then 3.14
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 10000 then 3.15
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 5000 then 3.16
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 3000 then 3.17
		when (bp.`type` = 'Inc' or bp.list_type = 'Inc_happycall') and bp.visit_or_not != 'Yes - ຢ້ຽມຢາມແລ້ວ' and bp.usd_asset_value_amount_of_old_contract - bp.usd_loan_amount_of_old_contract >= 1000 then 3.18
		-- 3.2 Increase customer with low increase amount (less than 1,000$) and delay collection Rank CF need to upgrade collection rank to be SAB is order below here
	end `visit_order`,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village,
	is_sales_partner `SP_rank`
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') )
order by sme.id asc;














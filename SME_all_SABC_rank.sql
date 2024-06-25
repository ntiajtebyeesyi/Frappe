

-- SME_all_SABC_rank from tabSME_BO_and_Plan
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
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where (bp.rank_update in ('S','A','B','C') ) -- if F rank and modifiled over 3months not need
	and case when bp.contract_status = 'Contracted' then 0 else 1 end != 0 -- if contracted before '2023-10-01' then not need
	and case when bp.contract_status = 'Cancelled' then 0 else 1 end != 0 -- if cencalled before '2023-10-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
	-- and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null -- if resigned staff no need
order by bp.name asc;






-- SME_all_SABC_rank from tabSME_BO_and_Plan
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
	is_sales_partner `SP_rank`,
	bp.credit, bp.rank_of_credit, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`,
	case when bp.modified >= '2024-06-01' then 'called' else 'x' end `call_status`,
	bp.reason_of_credit
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
/* where bp.name in (657785, 661188, 662660, 662860, 662168, 659063, 660231, 661892, 659522, 660468, 662906, 662375, 661233, 654722, 659097, 656265, 662435, 631207, 656591, 658143, 660166, 662159, 661914, 662307, 662914, 662745, 660958, 661979, 662370, 662949, 662374, 662668, 661788, 655451, 658505, 661061, 661526, 662515, 655918, 658271, 661412, 651912, 655302, 657684, 661900, 662277, 663035, 660743, 663011, 660963, 663003, 660199, 660747, 662207, 662438, 661375, 662580, 655995, 660098, 662339, 654717, 655588, 661226, 657744, 659691, 660683, 661231, 661782, 663024, 661048, 661330, 660665, 661623, 660790, 658964, 660232, 662094, 662605, 662719, 662104, 662614, 641846, 653994, 661895, 662694, 653301, 660490, 662569, 658833, 660479, 661216, 662436, 656177, 660531, 662759, 656931, 662815, 661779, 663047, 661772, 662827, 662766, 656646, 655892, 656494, 659531, 653421, 655049, 656470, 657593, 661674, 662383, 662751, 652289, 661183, 661544, 662313, 662781, 661100, 661801, 662058, 662676, 657219, 655943, 663023, 661580, 659518, 660046, 661770, 662755, 659707, 661939, 662119, 657083, 660449, 660692, 661656, 662357, 662818, 662729, 662805, 652025, 661701, 662931, 662721, 584252, 650303, 657270, 660206, 660436, 661869, 662681, 662233, 639455, 662190, 663030, 624539, 654141, 654890, 659422, 662226, 655218, 662080, 661853, 663015, 661863, 646456, 650571, 660668, 660975, 661559, 662074, 662915, 653011, 661696, 662992, 654698, 657227, 658563, 659506, 660739, 662134, 662762, 661777, 661003, 662087, 661490, 633422, 638111, 656296, 661101, 661822, 662799, 662790, 662924, 642494, 648619, 657725, 658197, 661083, 661820, 662161, 662736, 660533, 661922, 662840, 661601, 646726, 660096, 662930, 648157, 657233, 661090, 662643, 662973, 657656, 661097, 659680, 659687, 648728, 654063, 660107, 662148, 661126, 660526, 661146, 654374, 661938, 641970, 656003, 660789, 661862, 650129, 655913, 656460, 656999, 657767, 659105, 659714, 660426, 661223, 661929, 662850, 660075, 660620, 662390, 663000, 623484, 628531, 649014, 652742, 658490, 662199, 662965, 662737, 629318, 646714, 648664, 660055, 660373, 662942, 646911, 663025, 661950, 661804, 650359, 655275, 659806, 663001, 654660, 660357, 661134, 662016, 662996, 662917, 655254, 661852, 660687, 662958, 660459, 660481, 662288, 662828, 660443, 663008, 652991, 661255, 661953, 662373, 642991, 650630, 654610, 655318, 657105, 660088, 660748, 661299, 641844, 660123, 661797, 663044, 662202, 660103, 660486, 661200, 661627, 662282, 660177, 660995, 662173, 660991, 13121, 13883, 661936, 612164, 660654, 662239, 662975, 659703, 660695, 654602, 662981, 661959, 661721, 662289, 654553, 659729, 660664, 660064, 656654, 661622, 662298, 662904, 656072, 661519, 662347, 662732, 661594, 662283, 662962, 662866, 662865, 662856, 657728, 661234, 663043, 660092, 661239, 662266, 662862, 647489, 657221, 661191, 661824, 662258, 657810, 661397, 662331, 662910, 662382, 662900, 663033, 661670
) -- Have_execution_date */
/* where bp.name in (662380, 662618, 662181, 662629, 658967, 661600, 662824, 662768, 662636, 662792, 662341, 662171, 662779, 662610, 660658, 662089, 658872, 660908, 661982, 663017, 658242, 659069, 659505, 660689, 661195, 662365, 662689, 660686, 661835, 662364, 662686, 658142, 658585, 659584, 660473, 661095, 661521, 662183, 662701, 657707, 661212, 662275, 662243, 663016, 660607, 662770, 662777, 654009, 657409, 658899, 662120, 661851, 662988, 655598, 657974, 655035, 662281, 662525, 661538, 662909, 660681, 661194, 661951, 662188, 662750, 658663, 660788, 660066, 660550, 661639, 658037, 658675, 659588, 659979, 660546, 661114, 661485, 662114, 663032, 662740, 653624, 653843, 658085, 658722, 659600, 659994, 660543, 660997, 661492, 662122, 662926, 655090, 662484, 662366, 662609, 662166, 662552, 662602, 661599, 662809, 661611, 662234, 662003, 662315, 662978, 661327, 662224, 662986, 659485, 661075, 662106, 662764, 662229, 662710, 662193, 662817, 648518, 660741, 661899, 662358, 653642, 655895, 656795, 657737, 658489, 659941, 660375, 661605, 662793, 654965, 655817, 656302, 659048, 659649, 662788, 652448, 653671, 655002, 655551, 655901, 657052, 657597, 658245, 659006, 659573, 660041, 661064, 662361, 658528, 655585, 662814, 660007, 660937, 662600, 659499, 659504, 660402, 660920, 662744, 653219, 653700, 659802, 661326, 662571, 662591, 662718, 659652, 656464, 657677, 659033, 660135, 660706, 661178, 658549, 659716, 660183, 660613, 653401, 654062, 654509, 661145, 662293, 662933, 660397, 662437, 652734, 653415, 654096, 659088, 660117, 660942, 662363, 662297, 662998, 657789, 662126, 658251, 658551, 660864, 662086, 662553, 662832, 658318, 661565, 662385, 662649, 662678, 661478, 662983, 662655, 657729, 662617, 654518, 656579, 656631, 657215, 658273, 658882, 659621, 661045, 662890, 653840, 656821, 657338, 659822, 662270, 662473, 662176, 662534, 657130, 661055, 661392, 662286, 662919, 661052, 662761, 655947, 660634, 662359, 663040, 658485, 659523, 660158, 661608, 662311, 662913, 658007, 658476, 658867, 658299, 658573, 661057, 661320, 662784, 12191, 658774, 660110, 662225, 662303, 659672, 660705, 662520, 657712, 660149, 660226, 661204, 662249, 662393, 661668, 663013, 657947, 658792, 662203, 662756, 662214, 662284, 662892, 662757, 637201, 658281, 660737, 661620, 662972, 661932, 661199, 661787, 662292, 662963, 662217, 662990, 662505, 662897, 662921, 662494, 661870, 662797, 660720, 662032, 659465, 655729, 659552, 659997, 660469, 659679, 660145, 660625, 662152, 662725, 660545, 662314, 662712, 659341, 662348, 661197, 662791, 658435, 659519, 661875, 662671, 662801, 659075, 660673, 661140, 661646, 662376, 653050, 654302, 658199, 658970, 662336, 662760, 660144, 660787, 661228, 662861, 658329, 658334, 658335, 659701, 654886, 662002, 658481, 658637, 660219, 658024, 658503, 55823, 659067, 661825, 662356, 662823, 661144, 661803, 662340, 662642, 660176, 662326, 662650, 660710, 653080, 657625, 657738, 659724, 660084, 660676, 661931, 662388, 661879, 657872, 661918, 656900, 657658, 659064, 659569, 661479, 662355, 659300, 659050, 659692, 660068, 661549, 662391, 662692, 663005, 114487, 659632, 662392, 661389, 662264, 663037, 662138, 660971, 662235, 636216, 661948, 662132, 662982, 662300, 662843, 661122, 662938, 662702, 659160, 662592, 651490, 658521, 662918, 658574, 662387, 662835, 661805, 663045, 661917, 662241, 663041, 660970, 661564, 658922, 660080, 659299, 662812, 659066, 663007, 661115, 662287, 660019, 661062, 662077, 662635, 662953, 657981, 660155, 662928, 661024, 657508, 657638, 658473, 659511, 660095, 661933, 660140, 661677, 658942, 661579, 662206, 659083, 661930, 661460, 655303, 657790, 661794, 660696, 662097, 658277, 661923, 649786, 660118, 661222, 661765, 661906, 647790, 653909, 661767, 662864, 660185, 663026, 661481, 658507, 661913, 663022, 663042, 663038, 662194, 662961, 663009, 662218, 662960, 661621, 659682, 660948, 660954, 662211, 662377, 631706, 657581, 660457, 661826, 662248, 662891, 640555, 660104, 660677, 660791, 661676, 662025, 663039, 662280, 661253, 659477, 660377, 661957, 662500, 650332, 662222, 660736, 661614, 661378, 662245, 661943, 661778, 662969, 661934, 660492, 662259, 663020, 661210, 661510, 661937, 662078, 662749, 662317, 660723, 661029, 661359, 662012, 663029, 659102, 661955, 660593, 659671, 660898, 661760, 662068, 662798, 659702, 660731, 663046, 662980, 658258, 661406, 662443, 662905, 663004, 655593, 657764, 657797, 658323, 659722, 660169, 661256, 662066, 662966, 662849, 662296, 663028, 662776, 662795, 662912, 660704, 661831, 662082, 662895, 662102, 662976, 663002, 662894, 659935, 662674, 662005, 662839, 662947, 662257, 662863, 662874, 662939, 662968, 660072, 655246, 662952, 661237, 586846, 656584, 660002, 660709, 661185, 662137, 662991, 660112, 662111, 662911, 650716, 661257, 661587, 662794, 655440, 660491, 662187, 661586, 660125, 660716, 661251, 661399, 662987, 660627, 661724, 662959, 662260, 662920, 653137, 657763, 662927, 660412, 659728, 662877, 663021, 660679, 662937, 653554, 654159, 654976, 655553, 655747
) -- No_execution_date */
where bp.name in (657785, 661188, 662660, 662860, 662168, 659063, 660231, 661892, 659522, 660468, 662906, 662375, 661233, 654722, 659097, 656265, 662435, 631207, 656591, 658143, 660166, 662159, 661914, 662307, 662914, 662745, 660958, 661979, 662370, 662949, 662374, 662668, 661788, 655451, 658505, 661061, 661526, 662515, 655918, 658271, 661412, 651912, 655302, 657684, 661900, 662277, 663035, 660743, 663011, 660963, 663003, 660199, 660747, 662207, 662438, 661375, 662580, 655995, 660098, 662339, 654717, 655588, 661226, 657744, 659691, 660683, 661231, 661782, 663024, 661048, 661330, 660665, 661623, 660790, 658964, 660232, 662094, 662605, 662719, 662104, 662614, 641846, 653994, 661895, 662694, 653301, 660490, 662569, 658833, 660479, 661216, 662436, 656177, 660531, 662759, 656931, 662815, 661779, 663047, 661772, 662827, 662766, 656646, 655892, 656494, 659531, 653421, 655049, 656470, 657593, 661674, 662383, 662751, 652289, 661183, 661544, 662313, 662781, 661100, 661801, 662058, 662676, 657219, 655943, 663023, 661580, 659518, 660046, 661770, 662755, 659707, 661939, 662119, 657083, 660449, 660692, 661656, 662357, 662818, 662729, 662805, 652025, 661701, 662931, 662721, 584252, 650303, 657270, 660206, 660436, 661869, 662681, 662233, 639455, 662190, 663030, 624539, 654141, 654890, 659422, 662226, 655218, 662080, 661853, 663015, 661863, 646456, 650571, 660668, 660975, 661559, 662074, 662915, 653011, 661696, 662992, 654698, 657227, 658563, 659506, 660739, 662134, 662762, 661777, 661003, 662087, 661490, 633422, 638111, 656296, 661101, 661822, 662799, 662790, 662924, 642494, 648619, 657725, 658197, 661083, 661820, 662161, 662736, 660533, 661922, 662840, 661601, 646726, 660096, 662930, 648157, 657233, 661090, 662643, 662973, 657656, 661097, 659680, 659687, 648728, 654063, 660107, 662148, 661126, 660526, 661146, 654374, 661938, 641970, 656003, 660789, 661862, 650129, 655913, 656460, 656999, 657767, 659105, 659714, 660426, 661223, 661929, 662850, 660075, 660620, 662390, 663000, 623484, 628531, 649014, 652742, 658490, 662199, 662965, 662737, 629318, 646714, 648664, 660055, 660373, 662942, 646911, 663025, 661950, 661804, 650359, 655275, 659806, 663001, 654660, 660357, 661134, 662016, 662996, 662917, 655254, 661852, 660687, 662958, 660459, 660481, 662288, 662828, 660443, 663008, 652991, 661255, 661953, 662373, 642991, 650630, 654610, 655318, 657105, 660088, 660748, 661299, 641844, 660123, 661797, 663044, 662202, 660103, 660486, 661200, 661627, 662282, 660177, 660995, 662173, 660991, 13121, 13883, 661936, 612164, 660654, 662239, 662975, 659703, 660695, 654602, 662981, 661959, 661721, 662289, 654553, 659729, 660664, 660064, 656654, 661622, 662298, 662904, 656072, 661519, 662347, 662732, 661594, 662283, 662962, 662866, 662865, 662856, 657728, 661234, 663043, 660092, 661239, 662266, 662862, 647489, 657221, 661191, 661824, 662258, 657810, 661397, 662331, 662910, 662382, 662900, 663033, 661670, 662380, 662618, 662181, 662629, 658967, 661600, 662824, 662768, 662636, 662792, 662341, 662171, 662779, 662610, 660658, 662089, 658872, 660908, 661982, 663017, 658242, 659069, 659505, 660689, 661195, 662365, 662689, 660686, 661835, 662364, 662686, 658142, 658585, 659584, 660473, 661095, 661521, 662183, 662701, 657707, 661212, 662275, 662243, 663016, 660607, 662770, 662777, 654009, 657409, 658899, 662120, 661851, 662988, 655598, 657974, 655035, 662281, 662525, 661538, 662909, 660681, 661194, 661951, 662188, 662750, 658663, 660788, 660066, 660550, 661639, 658037, 658675, 659588, 659979, 660546, 661114, 661485, 662114, 663032, 662740, 653624, 653843, 658085, 658722, 659600, 659994, 660543, 660997, 661492, 662122, 662926, 655090, 662484, 662366, 662609, 662166, 662552, 662602, 661599, 662809, 661611, 662234, 662003, 662315, 662978, 661327, 662224, 662986, 659485, 661075, 662106, 662764, 662229, 662710, 662193, 662817, 648518, 660741, 661899, 662358, 653642, 655895, 656795, 657737, 658489, 659941, 660375, 661605, 662793, 654965, 655817, 656302, 659048, 659649, 662788, 652448, 653671, 655002, 655551, 655901, 657052, 657597, 658245, 659006, 659573, 660041, 661064, 662361, 658528, 655585, 662814, 660007, 660937, 662600, 659499, 659504, 660402, 660920, 662744, 653219, 653700, 659802, 661326, 662571, 662591, 662718, 659652, 656464, 657677, 659033, 660135, 660706, 661178, 658549, 659716, 660183, 660613, 653401, 654062, 654509, 661145, 662293, 662933, 660397, 662437, 652734, 653415, 654096, 659088, 660117, 660942, 662363, 662297, 662998, 657789, 662126, 658251, 658551, 660864, 662086, 662553, 662832, 658318, 661565, 662385, 662649, 662678, 661478, 662983, 662655, 657729, 662617, 654518, 656579, 656631, 657215, 658273, 658882, 659621, 661045, 662890, 653840, 656821, 657338, 659822, 662270, 662473, 662176, 662534, 657130, 661055, 661392, 662286, 662919, 661052, 662761, 655947, 660634, 662359, 663040, 658485, 659523, 660158, 661608, 662311, 662913, 658007, 658476, 658867, 658299, 658573, 661057, 661320, 662784, 12191, 658774, 660110, 662225, 662303, 659672, 660705, 662520, 657712, 660149, 660226, 661204, 662249, 662393, 661668, 663013, 657947, 658792, 662203, 662756, 662214, 662284, 662892, 662757, 637201, 658281, 660737, 661620, 662972, 661932, 661199, 661787, 662292, 662963, 662217, 662990, 662505, 662897, 662921, 662494, 661870, 662797, 660720, 662032, 659465, 655729, 659552, 659997, 660469, 659679, 660145, 660625, 662152, 662725, 660545, 662314, 662712, 659341, 662348, 661197, 662791, 658435, 659519, 661875, 662671, 662801, 659075, 660673, 661140, 661646, 662376, 653050, 654302, 658199, 658970, 662336, 662760, 660144, 660787, 661228, 662861, 658329, 658334, 658335, 659701, 654886, 662002, 658481, 658637, 660219, 658024, 658503, 55823, 659067, 661825, 662356, 662823, 661144, 661803, 662340, 662642, 660176, 662326, 662650, 660710, 653080, 657625, 657738, 659724, 660084, 660676, 661931, 662388, 661879, 657872, 661918, 656900, 657658, 659064, 659569, 661479, 662355, 659300, 659050, 659692, 660068, 661549, 662391, 662692, 663005, 114487, 659632, 662392, 661389, 662264, 663037, 662138, 660971, 662235, 636216, 661948, 662132, 662982, 662300, 662843, 661122, 662938, 662702, 659160, 662592, 651490, 658521, 662918, 658574, 662387, 662835, 661805, 663045, 661917, 662241, 663041, 660970, 661564, 658922, 660080, 659299, 662812, 659066, 663007, 661115, 662287, 660019, 661062, 662077, 662635, 662953, 657981, 660155, 662928, 661024, 657508, 657638, 658473, 659511, 660095, 661933, 660140, 661677, 658942, 661579, 662206, 659083, 661930, 661460, 655303, 657790, 661794, 660696, 662097, 658277, 661923, 649786, 660118, 661222, 661765, 661906, 647790, 653909, 661767, 662864, 660185, 663026, 661481, 658507, 661913, 663022, 663042, 663038, 662194, 662961, 663009, 662218, 662960, 661621, 659682, 660948, 660954, 662211, 662377, 631706, 657581, 660457, 661826, 662248, 662891, 640555, 660104, 660677, 660791, 661676, 662025, 663039, 662280, 661253, 659477, 660377, 661957, 662500, 650332, 662222, 660736, 661614, 661378, 662245, 661943, 661778, 662969, 661934, 660492, 662259, 663020, 661210, 661510, 661937, 662078, 662749, 662317, 660723, 661029, 661359, 662012, 663029, 659102, 661955, 660593, 659671, 660898, 661760, 662068, 662798, 659702, 660731, 663046, 662980, 658258, 661406, 662443, 662905, 663004, 655593, 657764, 657797, 658323, 659722, 660169, 661256, 662066, 662966, 662849, 662296, 663028, 662776, 662795, 662912, 660704, 661831, 662082, 662895, 662102, 662976, 663002, 662894, 659935, 662674, 662005, 662839, 662947, 662257, 662863, 662874, 662939, 662968, 660072, 655246, 662952, 661237, 586846, 656584, 660002, 660709, 661185, 662137, 662991, 660112, 662111, 662911, 650716, 661257, 661587, 662794, 655440, 660491, 662187, 661586, 660125, 660716, 661251, 661399, 662987, 660627, 661724, 662959, 662260, 662920, 653137, 657763, 662927, 660412, 659728, 662877, 663021, 660679, 662937, 653554, 654159, 654976, 655553, 655747
) -- all 
order by sme.id asc;











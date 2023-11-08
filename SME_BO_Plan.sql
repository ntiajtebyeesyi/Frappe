
create table `sme_org` (
	`id` int(11) not null auto_increment,
	`affiliation` varchar(255) default null,
	`director` varchar(255) default null,
	`g-dept_no` int(11) not null,
	`g-dept` varchar(255) default null,
	`dept_no` int(11) not null,
	`dept` varchar(255) default null,
	`sec_branch_no` int(11) not null,
	`sec_branch` varchar(255) default null,
	`unit_no` int(11) not null,
	`unit` varchar(255) default null,
	`m-unit_no` int(11) not null,
	`mini_unit` varchar(255) default null,
	`sales_pair` varchar(255) default null,
	`sales_cc` varchar(255) default null,
	`staff_no` varchar(255) default null,
	`staff_name` varchar(255) default null,
	`gender` varchar(255) default null,
	`former_job` varchar(255) default null,
	`hire_date` date not null,
	`title` varchar(255) default null,
	`h_b` varchar(255) default null,
	`rank` int(11) not null,
	`retirement_date` date default null,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default charset=utf8;


-- ------------------------------------ SME BO & Plan ---------------------------------------------
select * from tabSME_BO_and_Plan order by name desc;
select * from sme_bo_and_plan_id_seq ;

alter table tabSME_BO_and_Plan change name name bigint(20) auto_increment ; -- to make your form can add new record after you import data by cvs
alter table tabSME_BO_and_Plan auto_increment=11448;

update tabSME_BO_and_Plan set normal_bullet = normalbullet, disbursement_date_pay_date = disbursement_datepay_date  ;
alter table tabSME_BO_and_Plan drop column normalbullet;
alter table tabSME_BO_and_Plan drop column disbursement_datepay_date;

-- add datetime
SELECT ADDTIME("10:54:21", "00:10:00") as Updated_time ;
SELECT ADDTIME("2023-08-01 12:55:45.212689000", "02:00:00") as Updated_time ;
-- deduct datetime
SELECT SUBTIME('06:14:03', '15:50:90') AS Result;
SELECT SUBTIME('2019-05-01 11:15:45', '20 04:02:01') AS Result; 

select date_format('2023-08-02', '%c'); -- Numeric month name (0 to 12) https://www.w3schools.com/sql/func_mysql_date_format.asp
select date_format('2023-08-02', '%e'); -- Day of the month as a numeric value (0 to 31) https://www.w3schools.com/sql/func_mysql_date_format.asp

select * from tabSME_BO_and_Plan tsbap order by name desc;
select * from tabSME_BO_and_Plan tsbap where staff_no = '1180';
select * from tabUser tu ;

alter table tabSME_BO_and_Plan auto_increment=11549;
alter table tabSME_BO_and_Plan drop column priority_for_visit;


-- tabSME_BO_and_Plan -> test SME_BO_and_Plan https://docs.google.com/spreadsheets/d/1dqrXSSNq6ACAKzOuep62Qxl8ebKF9SUI3Z5v6e6f9sE/edit#gid=1867067672
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
where (bp.rank_update in ('S','A','B','C') or bp.rank1 in ('S','A','B','C') or (bp.rank_update = 'F' and bp.modified >= '2023-07-01') or bp.list_type is not null ) -- if F rank and modifiled over 3months not need
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-10-01' then 0 else 1 end != 0 -- if contracted before '2023-10-01' then not need
	and case when bp.contract_status = 'Cancelled' and date_format(bp.modified, '%Y-%m-%d') < '2023-10-01' then 0 else 1 end != 0 -- if cencalled before '2023-10-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
	and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null -- if resigned staff no need
order by bp.name asc;


-- where (bp.rank_update in ('S','A','B','C') or (bp.rank_update = 'F' and timestampdiff(month, modified, date(now())) <= 3) or bp.list_type is not null ) -- if F rank and modifiled over 3months not need

-- ______________________________________________________________ rank SABCF yesterday need to follow today ______________________________________________________________
select date_format(bp.creation, '%Y-%m-%d') `Date created`, date_format(bp.modified, '%Y-%m-%d') `Timestamp`, 
	-- sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`, bp.staff_no `Staff No`, sme.staff_name `Staff Name`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	bp.rank1, case when bp.rank1 in ('S','A','B','C') then 'SABC' when bp.rank1 = 'F' then 'F' end `group_rank1`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when date_format(bp.modified, '%Y-%m-%d') != '2023-09-26' then null when bp.contract_status = 'Contracted' then 'Contracted' 
		when bp.contract_status = 'Cancelled' then 'Cancelled' when bp.rank_update in ('S','A','B','C') then 'SABC' when bp.rank_update = 'F' then 'F'
	end `Result today`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') = '2023-09-25' and bp.rank1 in ('S','A','B','C','F') and bp.`type` in ('New', 'Dor','Inc')
order by bp.name asc;

-- ______________________________________________________________ Visit ______________________________________________________________
-- visit result https://docs.google.com/spreadsheets/d/16W3U7r1WCSONrnFZdSXwb_1iNCbhCxCl2mmmWidhupI/edit#gid=266017824
select bp.modified `Date`, bp.contract_no , bp.name `customer_id` , bp.customer_name , bp.customer_tel `phone1` , null `phone2`, bp.`type`,  sme.unit_no `Unit_no`, sme.unit `Unit`,
	bp.staff_no `Staff No`, sme.staff_name `Staff Name`, bp.visit_date , null `The reason of visit`, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`,
	null `collateral`, null `Interested in product`, null `Negotiate with`, 
	case when bp.rank_update = 'S' then 'S ຕ້ອງການເງິນໃນມື້ນີ້ມື້ອຶ່ນ' when bp.rank_update = 'A' then 'A ຕ້ອງການເງິນພາຍໃນອາທິດໜ້າ' when bp.rank_update = 'B' then 'B ຕ້ອງການເງິນພາຍໃນເດືອນນີ້'
		when bp.rank_update = 'C' then 'C ຕ້ອງການເງິນພາຍໃນເດືອນໜ້າ' when bp.rank_update = 'F' then 'F ຮູ້ຂໍ້ມູນລົດແຕ່ຍັງບໍ່ຕ້ອງການ' 
	end `Rank`,
	null `Negotiations`, null `Negotiation documents`, null `Location`,
	bp.disbursement_date_pay_date `Date will contract`, bp.usd_amount `Loan amount (USD)`, concat(bp.maker, ' ', bp.model) `Details of Collateral`, bp.usd_value `Asset value (USD)`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
where bp.visit_date >= '2023-08-24' and left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) = 'Yes' and bp.visit_date is not null
order by bp.visit_date ;

update tabSME_BO_and_Plan set visit_or_not = 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' where visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ';


-- ______________________________________________________________ check and update wrong amount ______________________________________________________________
select * from tabSME_BO_and_Plan where usd_loan_amount >= 100000;

select case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	`type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name 
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.usd_loan_amount >= 100000;


-- ______________________________________________________________ Check and Update set date for each rank ______________________________________________________________
-- add these collumn for for Kawakatsu method 2023-08-30
alter table tabSME_BO_and_Plan add column `rank_S_date` date default null;
alter table tabSME_BO_and_Plan add column `rank_A_date` date default null;
alter table tabSME_BO_and_Plan add column `rank_B_date` date default null;
alter table tabSME_BO_and_Plan add column `rank_C_date`date default null;

-- check and update the data for each rank
select name, rank1 , rank_update , rank_S_date , rank_A_date , rank_B_date , rank_C_date from tabSME_BO_and_Plan where rank_update in ('S','A','B','C');

update tabSME_BO_and_Plan 
	set rank_S_date = case when rank_update = 'S' then date_format(modified, '%Y-%m-%d') else rank_S_date end,
	rank_A_date = case when rank_update = 'A' then date_format(modified, '%Y-%m-%d') else rank_A_date end,
	rank_B_date = case when rank_update = 'B' then date_format(modified, '%Y-%m-%d') else rank_B_date end,
	rank_C_date = case when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end,
	rank_update = case when contract_status = 'Contracted' then 'S' else rank_update end,
	ringi_status = case when contract_status = 'Contracted' then 'Approved' else ringi_status end,
	rank1 = case when date_format(creation, '%Y-%m-%d') = date_format(modified, '%Y-%m-%d') then rank_update else rank1 end


-- ______________________________________________________________ -- add column for happy call 2023-09-10 ______________________________________________________________
alter table tabSME_BO_and_Plan add column `list_type` varchar(255) default null;
alter table tabSME_BO_and_Plan add column `contract_no_old` int(11) default null;

-- Dormant 
select * from tabSME_BO_and_Plan tsbap where name between 16880 and 28849;

update tabSME_BO_and_Plan set creation = now(), modified = now(), modified_by = 'Administrator', owner = 'Administrator'
where name between 16880 and 28849;

-- Existing 
select * from tabSME_BO_and_Plan tsbap where name between 28850 and 40822;

update tabSME_BO_and_Plan set creation = now(), modified = now(), modified_by = 'Administrator', owner = 'Administrator'
where name between 28850 and 36345;

-- to make your form can add new record after you import data by cvs
alter table tabSME_BO_and_Plan auto_increment=36346; -- next id
insert into sme_bo_and_plan_id_seq select 36346, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_bo_and_plan_id_seq;


-- _________________________________________________________ 200-3-3-1 _________________________________________________________
-- after change this then need to update on form http://13.250.153.252:8000/app/doctype/SME_BO_and_Plan
alter table tabSME_BO_and_Plan rename column `usd_amount` to `usd_loan_amount`;  
alter table tabSME_BO_and_Plan rename column `province_and_city` to `real_estate_province_and_city`;


-- export for 200-3-3-1 daily report
select date_format(bp.creation, '%Y-%m-%d') `input_date`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	bp.rank_update, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`, bp.customer_tel `tel`, null `telno`, bp.customer_name ,
	left(bp.address_province_and_city, locate('-', bp.address_province_and_city)-2) `province`, 
	replace(bp.address_province_and_city, left(bp.address_province_and_city, locate('-', bp.address_province_and_city)+1), '')  `district`, bp.address_village , 
	bp.maker, bp.model, bp.usd_loan_amount, bp.disbursement_date_pay_date , bp.name `primary_key`, bp.`type` `contract_type`, bp.approch_list 
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') >= date(now()) and bp.rank_update in ('S', 'A', 'B', 'C', 'F', 'G') 
order by bp.name asc;


-- BO https://docs.google.com/spreadsheets/d/1rKhGY4JN5N0EZs8WiUC8dVxFAiwGrxcMp8-K_Scwlg4/edit#gid=1793628529&fvid=551853106
select bp.staff_no, 1 `case`, case when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.case_no, bp.contract_no, bp.customer_name, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Now Result`, 
	bp.disbursement_date_pay_date , 'ແຜນເພີ່ມ' `which`, bp.name 
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
where (bp.rank_update in ('S','A','B','C') or bp.list_type is not null ) 
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-09-01' then 0 else 1 end != 0 -- if contracted before '2023-09-01' then not need
	and date_format(bp.modified, '%Y-%m-%d') >= date(now()) and bp.disbursement_date_pay_date between '2023-09-18' and '2023-09-23'
	and bp.ringi_status != 'Rejected'
order by bp.name asc;


-- ______________________________________________ update tabNow (All - Contracted - Cancelled) ______________________________________________
select name, staff_no, double_count , callcenter_of_sales from tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id) where tss.`type` = 'F';

update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.staff_no = tss.current_staff ;

update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.callcenter_of_sales = null
where bp.name in (38355,39748,60528,60624,61785,62172,62208,62815,62823,63701,64270,65542,66451,66754,14928,59544,14978,51183,61271,108360,108417,108476,108757,108779,68289,68309,108913,69318,108662,108846,108374,108453,108575,109029,108633,109042,108694,108738,108964,109020,108773,108429,109456,109793,109955,110052,110070,109235,109313,109355,109386,110292,110318,110349,109612,109623,109639,109683,109686,109724,109759,109432,109414,109205,109853,109223,109815,109868,109088,111635,111675,110956,111677,111009,111712,111735,111736,111748,111213,111222,111239,111281,111296,110689,111302,111206,111088,110522,111363,111403,110495,111519,111575,111580,111588,111603,111604,111605,110885,111634,111785,111871,111880,111896,111913,111914,111940,112031,112041,112042,112043,112044,112045,112052,112097,112120,112124,112125,112159,112172,112184,114417,114628,114972,115510,115521,115531,13800,63804,109739,110176
)

-- updtate F rank assign to new people
update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.staff_no = tss.current_staff
where tss.`type` = 'F'

update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.callcenter_of_sales = null
where bp.name in (30,1370,121,1376,871,2248,1794,891,1809,944,1877,2321,2363,2375,1970,2384,1181,1212,1227,1252,1264,1268,2447,2451,1282,1295,1305,1315,2152,1325,1339,1349,1357,1363,3082,3877,3093,3664,3132,3166,3710,2668,3246,3765,3533,3000,3004,3565,3575,3815,2796,3335,2817,4227,4553,7428,6514,6886,7459,7206,6931,6944,6956,7262,6964,7271,6613,7274,6986,7512,7292,6997,7004,7308,7312,7537,7327,7035,7331,7556,7560,7077,6221,6775,7102,7593,6807,8567,8067,8338,8090,7668,8353,8855,8110,8604,8112,7697,8898,8396,7706,7905,8143,8903,7908,8405,8167,8927,8665,8438,7735,7744,8451,7948,8200,7759,8465,7761,8708,8974,8486,7984,7986,7797,8747,7806,8015,8017,8281,8289,8545,8045,7832,7624,9914,9362,9080,9365,9920,9378,9392,9119,9444,9175,9965,9495,9223,9705,9534,9556,9885,9022,9577,9038,9341,9912,11778,11945,11949,11951,10953,13848,13610,13858,13618,13619,13862,12583,13873,13874,13876,13881,13882,13345,13889,12987,12988,13892,12628,12629,13666,12630,13669,13386,13387,13388,12676,13708,13710,13712,13094,13715,14005,13166,13169,14016,13770,14018,12859,13202,13796,12886,12887,12889,13569,12915,13600,12551,14392,14615,14905,14393,14394,14617,14911,14618,15363,14950,15184,14142,15189,14982,15193,14985,14176,15027,14489,15250,14801,14802,14515,15278,14538,15120,14597,14072,14598,14599,14600,14601,15340,15341,14088,15342,14089,14090,14091,14391,16356,16362,15371,15598,15601,16373,15624,15898,15641,16707,16434,16719,16724,15440,15441,15442,15970,15456,15465,16504,15515,16297,15522,15808,16531,15554,15555,15556,15826,16347,16352,38731,37272,37273,38756,38770,37299,38221,38791,38224,36358,36359,38232,36361,38246,38825,36367,36368,38258,38842,38851,36375,38286,38866,36390,36407,38341,38901,38903,38375,38914,38916,37489,38399,16770,37516,38446,38500,36467,38974,38520,38003,38993,37591,16811,16813,39004,37602,37603,37604,37627,37633,37640,36513,37653,36522,38091,38104,38105,37184,38121,38124,38135,37837,38145,37231,37233,37236,38154,38722,38155,38723,38730,39578,53117,52519,39192,51950,39593,51966,39606,53169,53182,52569,39312,39626,53896,39316,53897,53194,52016,53909,39650,53912,39331,53913,39332,39732,52612,52042,39366,52047,39377,39757,52070,39763,52079,52091,52093,53306,39772,53327,52715,52718,52116,52123,53346,52756,50821,52780,51592,52167,53364,39443,52174,39444,52199,39451,52231,52851,52852,52922,52926,39461,53477,51808,52290,51811,52992,52995,51818,53516,51821,53002,51826,53005,53532,53006,39105,53536,53012,51851,39116,53646,52462,51903,52465,39571,54837,55449,55455,55460,56512,54884,55461,54892,54895,54900,55469,56520,54903,56523,55478,56525,56531,54302,54941,56141,56143,53976,54406,55528,54409,54410,55020,56599,53990,55037,53993,55050,54518,54529,55061,54008,54012,56622,55074,56198,56202,54019,56206,54603,55094,55095,56702,54046,55107,55601,54054,56756,54060,55658,56804,55132,56834,55674,56837,54685,55678,56839,54104,55140,56331,54708,56344,56349,56867,56870,54162,55697,55698,56873,54169,54178,54180,56885,54191,55296,56890,54195,54764,56892,54200,55323,55329,55333,55739,55339,56914,54221,56429,56918,54230,54244,54821,55833,55436,54256,55441,57534,58199,57553,59800,59450,58884,58885,58894,58445,57165,58447,57170,58450,57710,57713,57825,57826,58521,57871,57890,58538,58548,59496,57366,57368,57371,58023,57415,57416,59314,59323,57437,59328,57445,59335,57454,58665,57455,56921,58678,59651,58690,56933,59371,58705,62171,60166,60168,60816,60824,62627,60242,61514,61074,61579,61602,61616,61161,61166,61679,60616,62490,62493,62495,62891,63251,65055,63797,63806,63322,64313,66304,66306,67789,65918,67870,65515,65523,67510,65254,68091,68093,68656,68695,69115,68254,68265,68014,68017,13811,15025
)



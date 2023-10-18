
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
where (bp.rank_update in ('S','A','B','C', 'F') or bp.list_type is not null )
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-09-01' then 0 else 1 end != 0 -- if contracted before '2023-09-01' then not need
	and case when bp.contract_status = 'Cancelled' and date_format(bp.modified, '%Y-%m-%d') < '2023-09-01' then 0 else 1 end != 0 -- if cencalled before '2023-09-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
order by bp.name asc;


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



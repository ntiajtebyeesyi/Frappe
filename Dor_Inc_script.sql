

-- _________________________________________________________ Dormant and Existing  _________________________________________________________
-- 
select name, contract_no, old_contract_no, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no
from tabSME_BO_and_Plan tsbap where list_type is not null and list_type = 'Dor_happycall';


-- add col for happy call
alter table tabSME_BO_and_Plan add column owner_staff_no varchar(255) default null, 
	add column usd_loan_amount_of_old_contract decimal(20,2) not null default '0.00',
	add column usd_principal_outstanding_amount_of_old_contract decimal(20,2) not null default '0.00',
	add column usd_asset_value_amount_of_old_contract decimal(20,2) not null default '0.00',
	add column business_type varchar(255) default null;


-- create table for prepare import data from Excel file and update 
create table `temp_sme_happycall` (
	`contract_no` int(11) not null auto_increment,
	`case_no` varchar(255) default null,
	`list_type` varchar(255) not null,
	`customer_name` varchar(255) default null,
	`customer_tel` varchar(255) default null,
	`visit_or_not` varchar(255) default null,
	`visit_date` date default null,
	`rank1` varchar(255) default null,
	`rank_update` varchar(255) default null,
	`usd_loan_amount` decimal(20,2) default null,
	`usd_loan_amount_of_old_contract` decimal(20,2) default null,
	`usd_principal_outstanding_amount_of_old_contract` decimal(20,2) default null,
	`usd_asset_value_amount_of_old_contract` decimal(20,2) default null,
	`business_type` varchar(255) default null,
	`staff_no` varchar(255) default null,
	`owner_staff_no` varchar(255) default null,
	primary key (`contract_no`)
) engine=InnoDB auto_increment=1 default charset=utf8;



-- 1) import from 
select old_contract_no `contract_no`, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no
from tabSME_BO_and_Plan where list_type = 'Dor_happycall' ;


-- 2) import data from csv to temp_sme_happycall
 -- please see example on https://github.com/Khamvang/Frappe


-- 3) check and delete contract no which is not exist on new source
-- Dormant customer
select * from tabSME_BO_and_Plan where list_type = 'Dor_happycall' and old_contract_no not in (select contract_no from temp_sme_happycall where list_type = 'Dor_happycall');
-- delete
delete from tabSME_BO_and_Plan where list_type = 'Dor_happycall' and old_contract_no not in (select contract_no from temp_sme_happycall where list_type = 'Dor_happycall');

-- Increase customer
select * from tabSME_BO_and_Plan where list_type = 'Inc_happycall' and old_contract_no not in (select contract_no from temp_sme_happycall where list_type = 'Inc_happycall');
-- delete
delete from tabSME_BO_and_Plan where list_type = 'Inc_happycall' and old_contract_no not in (select contract_no from temp_sme_happycall where list_type = 'Inc_happycall');


-- 4) import from temp_sme_happycall to tabSME_BO_and_Plan
-- Dormant customer
insert into tabSME_BO_and_Plan (contract_no, old_contract_no, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no)
select contract_no, contract_no `old_contract_no`, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no 
from temp_sme_happycall where list_type = 'Dor_happycall' and contract_no not in (select contract_no from tabSME_BO_and_Plan where list_type = 'Dor_happycall');

-- Inc customer
insert into tabSME_BO_and_Plan (contract_no, old_contract_no, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no)
select contract_no, contract_no `old_contract_no`, case_no, list_type, customer_name, customer_tel, visit_or_not, visit_date, rank1, rank_update, usd_loan_amount,
	usd_loan_amount_of_old_contract, usd_principal_outstanding_amount_of_old_contract, usd_asset_value_amount_of_old_contract, business_type, staff_no, owner_staff_no 
from temp_sme_happycall where list_type = 'Inc_happycall' and contract_no not in (select contract_no from tabSME_BO_and_Plan where list_type = 'Inc_happycall');

-- 5) Update data on table SME BO
select * from tabSME_BO_and_Plan bp inner join temp_sme_happycall tsh on (bp.contract_no = tsh.contract_no and bp.list_type is not null)

update tabSME_BO_and_Plan bp inner join temp_sme_happycall tsh on (bp.contract_no = tsh.contract_no and bp.list_type is not null)
set bp.case_no = tsh.case_no, bp.customer_tel = tsh.customer_tel, bp.visit_or_not = tsh.visit_or_not, bp.visit_date = tsh.visit_date, bp.rank1 = tsh.rank1, bp.rank_update = tsh.rank_update,
	bp.usd_loan_amount_of_old_contract = tsh.usd_loan_amount_of_old_contract, bp.usd_principal_outstanding_amount_of_old_contract = tsh.usd_principal_outstanding_amount_of_old_contract,
	bp.usd_asset_value_amount_of_old_contract = tsh.usd_asset_value_amount_of_old_contract, bp.business_type = tsh.business_type, bp.staff_no = tsh.staff_no, bp.owner_staff_no = tsh.owner_staff_no



-- 6) Query data to Google sheet to order to visit
select bp.name, bp.`type`, bp.rank_update, visit_or_not, bp.usd_loan_amount_of_old_contract , bp.usd_asset_value_amount_of_old_contract ,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end 'now status',
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
	end `visit_order`
from tabSME_BO_and_Plan bp where `type` = 'Inc' and list_type is not null ;





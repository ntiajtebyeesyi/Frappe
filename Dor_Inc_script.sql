

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



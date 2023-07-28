
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
alter table tabSME_BO_and_Plan auto_increment=15001;

update tabSME_BO_and_Plan set normal_bullet = normalbullet, disbursement_date_pay_date = disbursement_datepay_date  ;
alter table tabSME_BO_and_Plan drop column normalbullet;
alter table tabSME_BO_and_Plan drop column disbursement_datepay_date;

-- tabSME_BO_and_Plan -> test SME_BO_and_Plan https://docs.google.com/spreadsheets/d/1dqrXSSNq6ACAKzOuep62Qxl8ebKF9SUI3Z5v6e6f9sE/edit#gid=1867067672
select modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	null `DEPT`, null `SECT`, null `Unit_no`, null `Unit`,
	staff_no `Staff No`, staff_name `Staff Name`, `point` , `type` , usd_amount , normal_bullet , contract_no , case_no , customer_name , customer_tel ,
	ringi_status , ringi_comment , disbursement_date_pay_date , contract_status , contract_comment , customer_card , rank1 , approch_list , rank_update , 
	visit_date , visit_or_not ,
	null `Cancelled Result`, null `SABC`, null `C`, null `sales_cc`
from tabSME_BO_and_Plan;



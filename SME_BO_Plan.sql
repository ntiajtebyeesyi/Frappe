
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
	sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	bp.staff_no `Staff No`, sme.staff_name `Staff Name`, case when bp.`point` = '0.5' then 0.5 when bp.double_count != '' then 0.5 else 1 end `point`, 
	`type` , case when bp.`point` = '0.5' then bp.usd_amount when bp.double_count != '' then bp.usd_amount * 0.5 else bp.usd_amount end  `usd_amount`, 
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
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Cancelled Result`,
	concat(bp.maker, ' - ', bp.model) `collateral`, bp.`year` 
	-- concat('=hyperlink(', concat('"http://13.250.153.252:8000/app/sme_bo_and_plan/', name) ,'","', bp.customer_name, '")') `For visit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
where bp.rank_update in ('S','A','B','C', 'F')
order by bp.name asc;


-- rank F yesterday
select date_format(bp.creation, '%Y-%m-%d') `Date created`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	bp.staff_no `Staff No`, sme.staff_name `Staff Name`, bp.double_count, bp.callcenter_of_sales , bp.`type` , bp.usd_amount , bp.normal_bullet, bp.customer_name, 
	bp.rank1 , bp.rank_update, bp.ringi_status, bp.contract_status , bp.sp_cc `SP CC`, bp.rank_update_sp_cc `Rank of SP CC`, 
	bp.modified `Date updated`, case when bp.modified < date(now()) then 'Pending' else UL
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
where date_format(bp.creation, '%Y-%m-%d') = '2023-08-21' and bp.rank1 = 'F' and bp.`type` in ('New', 'Dor','Inc')
order by sme.unit_no , bp.staff_no, bp.creation ;

-- rank SABC yesterday
select bp.modified `Timestamp`, concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	bp.staff_no `Staff No`, sme.staff_name `Staff Name`, `point` , `type` , bp.usd_amount , bp.normal_bullet, bp.customer_name, 
	bp.rank1 , bp.rank_update, bp.credit `Sales promotion CC`, bp.credit, bp.rank_of_credit ,
	bp.ringi_status, bp.creation `Date created`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
where date_format(bp.creation, '%Y-%m-%d') = '2023-08-05' and bp.rank1 in ('S','A','B','C')
order by sme.unit_no , bp.staff_no ;


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
	rank_C_date = case when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end
-- where name >= 15544


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

alter table tabSME_BO_and_Plan change name name bigint(20) auto_increment ; -- to make your form can add new record after you import data by cvs
alter table tabSME_BO_and_Plan auto_increment=36346;
insert into sme_bo_and_plan_id_seq select 36346, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_bo_and_plan_id_seq;





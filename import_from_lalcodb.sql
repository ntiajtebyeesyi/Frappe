



-- create table on lalcodb for preparing import from lalacodb to frappe
create table sme_org (
	"id" serial4 not null,
	"affiliation" varchar(255) default null,
	"director" varchar(255) default null,
	"g-dept_no" serial4 not null,
	"g-dept" varchar(255) default null,
	"dept_no" serial4 not null,
	"dept" varchar(255) default null,
	"sec_branch_no" serial4 not null,
	"sec_branch" varchar(255) default null,
	"unit_no" serial4 not null,
	"unit" varchar(255) default null,
	"m-unit_no" serial4 not null,
	"mini_unit" varchar(255) default null,
	"sales_pair" varchar(255) default null,
	"sales_cc" varchar(255) default null,
	"staff_no" varchar(255) default null,
	"staff_name" varchar(255) default null,
	"gender" varchar(255) default null,
	"former_job" varchar(255) default null,
	"hire_date" date not null,
	"title" varchar(255) default null,
	"h_b" varchar(255) default null,
	"rank" serial4 not null,
	"retirement_date" date default null,
	constraint sme_org_key primary key ("id")
);


select * from custtbl where inputdate = date(now())

select * from users u 

-- migration from lalcodb to frappe
select TO_CHAR(inputdate :: DATE, 'yyyy-mm-dd') "creation", TO_CHAR(inputdate :: DATE, 'yyyy-mm-dd') "modified", 'Administrator' "modified_by", 'Administrator' "owner",
	staffid "staff_no", case custtype when '1' then 'Dor' when '2' then 'Inc' when '3' then 'New' else '' end "type", visiteddate "visit_date", null "visit_or_not", loanamount "usd_loan_amount",
	concat(firstname, ' ', lastname ) "customer_name", telno1 "customer_tel", rank1 "rank1", rank1 "rank_update", null "customer_card", null "ringi_status", null "ringi_comment", 
	null "contract_status", null "contract_comment", fundwantdate "disbursement_date_pay_date", null "normal_bullet", maker "maker", model "model" , "year", 0 "usd_value",
	null "address_province_and_city", addr "address_village", concat(staffid,' - ', staffname) "callcenter_of_sales"
from custtbl c left join sme_org sme on (c.staffid = sme.staff_no)
where inputdate = date(now());

where staffid in ('3836', '3881') and rank1 in ('S','A','B','C','F'); 

-- _________________________________________________________ task on 2023-11-01 _________________________________________________________
-- on frappe -> add a col for keep refer id
alter table tabSME_BO_and_Plan add column `custtbl_id` int(11) default null;

-- on lalcodb -> migration from lalcodb to frappe -- refer data D:\OneDrive - LALCO lalcoserver\OneDrive - Lao Asean Leasing Co. Ltd\Daily memo\2023-10\2023-10-31\Past prospect.xlsx
select TO_CHAR(inputdate :: DATE, 'yyyy-mm-dd') "creation", TO_CHAR(inputdate :: DATE, 'yyyy-mm-dd') "modified", 'Administrator' "modified_by", 'Administrator' "owner",
	staffid "staff_no", case custtype when '1' then 'Dor' when '2' then 'Inc' when '3' then 'New' else '' end "type", visiteddate "visit_date", null "visit_or_not", loanamount "usd_loan_amount",
	concat(firstname, ' ', lastname ) "customer_name", telno1 "customer_tel", rank1 "rank1", rank1 "rank_update", null "customer_card", null "ringi_status", null "ringi_comment", 
	null "contract_status", null "contract_comment", fundwantdate "disbursement_date_pay_date", null "normal_bullet", maker "maker", model "model" , "year", 0 "usd_value",
	null "address_province_and_city", addr "address_village", upper(concat(staffid,' - ', staffname)) "callcenter_of_sales",
	c.id "custtbl_id"
from custtbl c left join sme_org sme on (c.staffid = sme.staff_no)
-- where inputdate = date(now());
where rank1 in ('S','A','B','C') and c.telno1 not in ('90305750744','902079970742','902072367890','902055552819','902056782343','902095332801','902058532394','902055596720','902028666684','902056608555','902056518333','902058925539','902023970666','902092617696','902077014328','902077735926','902059593373','902091041459','902097566639','902076146500','90309444015','90309374063','902096349743','902055552819','902058562223','902091205051','902091205051','902099866542','902022888797','902099990879','902099990879','902055173407','90309374063','902055558783','902098500356','902099799807','902055558783','90309374063','90304566520','902099799807','902055558783','90309155272','90309155272','902099866542','902022345623','902022345623','90309155272','90304566520','90305750744','902099192163','902022345623','902029381051','902099192163','90309410052','902099866542','902059593373','902099866542','90304566520','90304566520','902098500356','902097982324','90309155272','902099192163','902029381051','902091214420','90305750744','902099142111','902055558783','902055411053','902055411053','902055173407','90305750744','90305750744','902029381051','902097982324','90305750744','90305750744','902097982324','902029381051','902099142111','902098996630','90304983575','902099937771','902023333997','90309949413','902091649049','902077747377','902023333997','902055123434','902055105588','902056484555','90304615862','902056518333','902099937771','902055028029','90305756146','902028954118','902077779909','902055392639','902058597306','902058597306','902058597306','902052234580','902096528104','902023688811','902057045759','902058281281','902099595444','902055047248','902055552819','902056927509','90309993621','902058666658','902055552819','902055028029','902093995282','902055028029','902059926620','902093558305','902055167062','902055167062','902091205051','902029700377','902055028029','902057045759','902076921406','902078837044','902029667355','90309444015','902096466562','902058292356','902076665596','902099953614','902092870499','902077014328','902055173407'
) and c.inputdate < '2023-08-01'; 

-- to make your form can add new record after you import data from lalcodb
alter table tabSME_BO_and_Plan auto_increment=187309; -- next id
insert into sme_bo_and_plan_id_seq select 187309, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_bo_and_plan_id_seq;

-- _________________________________________________________ END _________________________________________________________

-- _________________________________________________________ task on 2023-11-08 _________________________________________________________
-- export to check and remove duplicate
select name 'id', staff_no 'current_staff', custtbl_id, customer_name, customer_tel, rank1 , creation , modified 
from tabSME_BO_and_Plan 
where custtbl_id is not null


-- backup and store in D:\OneDrive - LALCO lalcodb1\OneDrive - Lao Asean Leasing Co. Ltd\frappe\tabSME_BO_and_Plan_F_rank_from_lalcodb_20221001_to_20230731.sql
select * -- name 'id', staff_no 'current_staff', custtbl_id, customer_name, customer_tel, rank1 , creation , modified 
from tabSME_BO_and_Plan 
where custtbl_id is not null and rank1 = 'F'











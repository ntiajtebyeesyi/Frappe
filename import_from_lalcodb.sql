



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


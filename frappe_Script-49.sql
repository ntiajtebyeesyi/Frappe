




select `name` 'id', date_format(creation, '%Y-%m-%d') 'date_created', date_format(modified, '%Y-%m-%d') 'date_updated',
	concat(staff_no, ' - ', staff_name) 'sales_person', broker_name , broker_tel , facebook , broker_workplace , business_type , `year` 
	address_province , address_district , address_village , ever_introduced , contract_no , `rank` , 
	date_will_contract , customer_name , customer_tel , currency , amount , collateral , remark 
from tabfive_relationships 


select * from tabfive_relationships order by name desc limit 10;
select * from five_relationships_id_seq;


-- add datetime
SELECT ADDTIME("10:54:21", "00:10:00") as Updated_time ;
SELECT ADDTIME("2023-08-01 12:55:45.212689000", "02:00:00") as Updated_time ;
-- deduct datetime
SELECT SUBTIME('06:14:03', '15:50:90') AS Result;
SELECT SUBTIME('2019-05-01 11:15:45', '20 04:02:01') AS Result; 

select date_format('2023-08-02', '%c'); -- Numeric month name (0 to 12) https://www.w3schools.com/sql/func_mysql_date_format.asp
select date_format('2023-08-02', '%e'); -- Day of the month as a numeric value (0 to 31) https://www.w3schools.com/sql/func_mysql_date_format.asp

select * from tabSME_BO_and_Plan tsbap order by name desc; -- 51554
select * from tabSME_BO_and_Plan tsbap where staff_no = '577' ;
select * from tabUser tu ;
select * from sme_org so ;






-- check and update the data for each rank
select name, rank1 , rank_update , rank_S_date , rank_A_date , rank_B_date , rank_C_date from tabSME_BO_and_Plan where rank_update in ('S','A','B','C');


-- update rank, own_salesperson, customer_tel
update tabSME_BO_and_Plan 
	set rank_S_date = case when rank_update = 'S' then date_format(modified, '%Y-%m-%d') else rank_S_date end,
	rank_A_date = case when rank_update = 'A' then date_format(modified, '%Y-%m-%d') else rank_A_date end,
	rank_B_date = case when rank_update = 'B' then date_format(modified, '%Y-%m-%d') else rank_B_date end,
	rank_C_date = case when rank_update = 'C' then date_format(modified, '%Y-%m-%d') else rank_C_date end,
	rank_update = case when contract_status = 'Contracted' then 'S' else rank_update end,
	ringi_status = case when contract_status = 'Contracted' then 'Approved' else ringi_status end,
	visit_or_not = case when contract_status = 'Contracted' then 'Yes - ຢ້ຽມຢາມແລ້ວ' when visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ' then 'No - ຍັງບໍ່ໄດ້ລົງຢ້ຽມຢາມ' else visit_or_not end,
	rank1 = case when date_format(creation, '%Y-%m-%d') = date_format(modified, '%Y-%m-%d') then rank_update else rank1 end,
	`own_salesperson` = case when `own_salesperson` is not null then `own_salesperson` when callcenter_of_sales is null or callcenter_of_sales = '' then staff_no else regexp_replace(callcenter_of_sales  , '[^[:digit:]]', '') end,
	customer_tel = 
	case when customer_tel = '' then ''
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(customer_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(customer_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(customer_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(customer_tel , '[^[:digit:]]', ''),8))
	end
;


update tabsme_Sales_partner
	set broker_tel  = 
	case when broker_tel = '' then ''
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
	end
;


select * from tabSME_BO_and_Plan tsbap where visit_date > date(now()) and visit_or_not = 'Yes - ຢ້ຽມຢາມແລ້ວ';

select bp.staff_no , bp.callcenter_of_sales , bp.double_count , bp.name ,
	case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end `Staff NO`,
	case when locate(' ', bp.callcenter_of_sales) = 0 then bp.callcenter_of_sales else left(bp.callcenter_of_sales, locate(' ', bp.callcenter_of_sales)-1) end `CC No`,
	case when locate(' ', bp.double_count) = 0 then bp.double_count else left(bp.double_count, locate(' ', bp.double_count)-1) end `Double count NO`
from tabSME_BO_and_Plan bp where creation >= date(now())


-- rank SABCF yesterday need to follow today
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
	case when bp.contract_status = 'Contracted' then 'Contracted' when date_format(bp.modified, '%Y-%m-%d') = '2023-12-06' then 'No follow'
		when bp.contract_status = 'Cancelled' then 'Cancelled' when bp.rank_update in ('S','A','B','C') then 'SABC' when bp.rank_update in ('F', 'G') then 'F'
	end `Result today`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`, concat(bp.maker, ' - ', bp.model, ' (', bp.`year`, ')') `collateral`
	, bp.customer_name, bp.customer_tel , bp.`type` 
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') = '2023-12-06' and bp.rank1 in ('S','A','B','C','F') and bp.`type` in ('New', 'Dor','Inc')
order by case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end asc;


-- all rank SABCF in the past need to follow today
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
	case when bp.contract_status = 'Contracted' then 'Contracted' when date_format(bp.modified, '%Y-%m-%d') < '2023-09-28' then 'No follow'
		when bp.contract_status = 'Cancelled' then 'Cancelled' when bp.rank_update in ('S','A','B','C') then 'SABC' when bp.rank_update in ('F', 'G') then 'F'
	end `Result today`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`, bp.name
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where (bp.rank_update in ('S','A','B','C', 'F') or bp.list_type is not null )
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < date(now()) then 0 else 1 end != 0 -- if contracted before '2023-09-01' then not need
	and case when bp.contract_status = 'Cancelled' and date_format(bp.modified, '%Y-%m-%d') < date(now()) then 0 else 1 end != 0 -- if cencalled before '2023-09-01' then not need
	and bp.`type` in ('New', 'Dor', 'Inc') -- new only 3 products
	and date_format(bp.creation, '%Y-%m-%d') < date(now())
	and case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end is not null
order by case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end asc;



-- visit result https://docs.google.com/spreadsheets/d/16W3U7r1WCSONrnFZdSXwb_1iNCbhCxCl2mmmWidhupI/edit#gid=266017824
select bp.modified `Date`, bp.contract_no , bp.name `customer_id` , bp.customer_name , bp.customer_tel `phone1` , null `phone2`, bp.`type`, 
	sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	sme.staff_no `Staff No`, sme.staff_name `Staff Name`, bp.visit_date , null `The reason of visit`, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`,
	null `collateral`, null `Interested in product`, null `Negotiate with`, 
	case when bp.rank_update = 'S' then 'S ຕ້ອງການເງິນໃນມື້ນີ້ມື້ອຶ່ນ' when bp.rank_update = 'A' then 'A ຕ້ອງການເງິນພາຍໃນອາທິດໜ້າ' when bp.rank_update = 'B' then 'B ຕ້ອງການເງິນພາຍໃນເດືອນນີ້'
		when bp.rank_update = 'C' then 'C ຕ້ອງການເງິນພາຍໃນເດືອນໜ້າ' when bp.rank_update = 'F' then 'F ຮູ້ຂໍ້ມູນລົດແຕ່ຍັງບໍ່ຕ້ອງການ' 
	end `Rank`,
	null `Negotiations`, bp.evidence `Negotiation documents`, bp.visit_location_url `Location`,
	bp.disbursement_date_pay_date `Date will contract`, bp.usd_loan_amount `Loan amount (USD)`, concat(bp.maker, ' ', bp.model) `Details of Collateral`, bp.usd_value `Asset value (USD)`,
	bp.visit_checker, bp.actual_visit_or_not, bp.comment_by_visit_checker,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bp.visit_date >= date(now()) and bp.visit_date is not null
	-- and left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) = 'Yes' 
order by bp.visit_date ;


select sme.dept `DEPT`, sme.sec_branch `SECT`, sme.unit_no `Unit_no`, sme.unit `Unit`,
	bp.staff_no `Staff No`, sme.staff_name `Staff Name`, bp.visit_date, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) `Visit or not`,
	bp.name `customer_id` , bp.customer_name , bp.customer_tel `phone1` , null `phone2`, bp.`type`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
where bp.visit_date between '2023-12-01' and date(now()) and bp.visit_date is not null
order by bp.visit_date asc, sme.id asc, left(bp.visit_or_not, locate('-', bp.visit_or_not)-2) desc;


-- check and update wrong amount 
select * from tabSME_BO_and_Plan where usd_loan_amount >= 100000;

select case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.dept else smec.dept end `DEPT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.sec_branch else smec.sec_branch end `SECT`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit_no else smec.unit_no end `Unit_no`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.unit else smec.unit end `Unit`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then bp.staff_no else regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') end `Staff No`, 
	case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.staff_name else smec.staff_name end `Staff Name`, 
	`type`, bp.usd_loan_amount, 
	bp.normal_bullet , bp.contract_no , bp.case_no , bp.customer_name, date_format(bp.creation, '%Y-%m-%d') 'Date created', bp.rank_update
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.usd_loan_amount >= 100000;



select * from tabUser where name in ('lalco1@lalco.la', 'lalco2@lalco.la', 'champagne3807@lalco.la', 'an3824@lalco.la', 'sing3839@lalco.la', 'phone3336@lalco.la')
order by modified 

select name, creation , modified , modified_by , owner , email , first_name , last_name , username, time_zone,`language`, gender , birth_date , phone , mobile_no, 
	 desk_theme, last_known_versions, onboarding_status 
from tabUser where name in ('saeng3931@lalco.la')
order by field(name, 'saeng3931@lalco.la') 





-- BO https://docs.google.com/spreadsheets/d/1rKhGY4JN5N0EZs8WiUC8dVxFAiwGrxcMp8-K_Scwlg4/edit#gid=1793628529&fvid=551853106
select bp.staff_no, 1 `case`, case when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.case_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Now Result`, 
	bp.disbursement_date_pay_date , 'ແຜນເພີ່ມ' `which`, bp.name, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
 where bp.name in (198120,196112,199161,199165,198961,199171,193797,199055,193796,198946,34921,1232,198717,198943,198984,199107,199168,197380,198954,198782,198881,198938,199049,198878,198880,240,198868,198869,196215,198957,198005,198871,193785,195786,198677,198922,198914,199127,198990,196958,199078,196132,198584,198985,198989,196404,198538,198749,199128,193300,197542,198533,198760,197788,198139,198953,197156,194593,196527,197660,199141,194886,197547,199200,195978,198362,198474,196872,197466,198845,198874,197612,199060,198624,198177,196222,195109,193645,197033,195664,193336,198925,193186,196976,198281,198529,198027,193569,198947,196182,198459,198652,198188,194126,198200,198049,199185,199207,199183,34799,198979,198981,198247,198503,198886,198394,66724,198217,198794,198875,194056,198664,198501,198687,198578,198816,198792,195113,197572,198206,197673,198614,198615,85986,77392,75144,199114,199117,198897,198949,109578,198888,199167,197678,198662,198367,197245,198962,199053,199188,197492,196087,198940,198879,199116,193998,197931,197116,196941,198124,197936,199033,194292,198386,198915,198893,199182,114410,196535,117839,198920,198918,199121,192943,193146,198286,198753,196919,198873,198872,195488,198757,198298,199057,197237,198998,199174,197472,198971,198728,198907,199000,199120,199094,199178,197449,198785,192975,198524,198919,199122,198924,198923,194307,198381,192913,195916,198354,198916,198900,199175,197826,199113,190785,198864,199036,199039,199059,194732,193208,198952,198999,198994,198725,198980,199176,196055,197396,199173,199189,198905,199184,199179,198876,199115,72564,194563,195743,198861,104758,95533,108310,104493,87040,3791,198932,197842,195645,198917,199056,199172,187837,194547,196140,196723,197395,197765,197904,198334,198076,198518,198911,198967,199159,198912,197905,198068,198891,198993,198686,196096,199180,198969,119285,115513,198955,199208,197920,198650,198519,198921,90193,109930,72158,199187,198945,199044,199124,189383,197168,198956,199103,196116,198724,198910,199126,193016,72492,199045)
 order by field(bp.name, 198120,196112,199161,199165,198961,199171,193797,199055,193796,198946,34921,1232,198717,198943,198984,199107,199168,197380,198954,198782,198881,198938,199049,198878,198880,240,198868,198869,196215,198957,198005,198871,193785,195786,198677,198922,198914,199127,198990,196958,199078,196132,198584,198985,198989,196404,198538,198749,199128,193300,197542,198533,198760,197788,198139,198953,197156,194593,196527,197660,199141,194886,197547,199200,195978,198362,198474,196872,197466,198845,198874,197612,199060,198624,198177,196222,195109,193645,197033,195664,193336,198925,193186,196976,198281,198529,198027,193569,198947,196182,198459,198652,198188,194126,198200,198049,199185,199207,199183,34799,198979,198981,198247,198503,198886,198394,66724,198217,198794,198875,194056,198664,198501,198687,198578,198816,198792,195113,197572,198206,197673,198614,198615,85986,77392,75144,199114,199117,198897,198949,109578,198888,199167,197678,198662,198367,197245,198962,199053,199188,197492,196087,198940,198879,199116,193998,197931,197116,196941,198124,197936,199033,194292,198386,198915,198893,199182,114410,196535,117839,198920,198918,199121,192943,193146,198286,198753,196919,198873,198872,195488,198757,198298,199057,197237,198998,199174,197472,198971,198728,198907,199000,199120,199094,199178,197449,198785,192975,198524,198919,199122,198924,198923,194307,198381,192913,195916,198354,198916,198900,199175,197826,199113,190785,198864,199036,199039,199059,194732,193208,198952,198999,198994,198725,198980,199176,196055,197396,199173,199189,198905,199184,199179,198876,199115,72564,194563,195743,198861,104758,95533,108310,104493,87040,3791,198932,197842,195645,198917,199056,199172,187837,194547,196140,196723,197395,197765,197904,198334,198076,198518,198911,198967,199159,198912,197905,198068,198891,198993,198686,196096,199180,198969,119285,115513,198955,199208,197920,198650,198519,198921,90193,109930,72158,199187,198945,199044,199124,189383,197168,198956,199103,196116,198724,198910,199126,193016,72492,199045)

 where (bp.rank_update in ('S','A','B','C') or bp.list_type is not null ) 
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-12-06' then 0 else 1 end != 0 -- if contracted before '2023-09-29' then not need
	and bp.disbursement_date_pay_date between '2024-01-06' and '2024-01-31'  and date_format(bp.modified, '%Y-%m-%d') >= '2024-01-05'
	and bp.ringi_status != 'Rejected' -- and bp.contract_status != 'Cancelled'
order by sme.id ;



-- updtate F rank assign to new people
update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.staff_no = tss.current_staff, bp.callcenter_of_sales = null 
where tss.`type` = 'F'


select * from tabSME_BO_and_Plan tsbap where name in (178866,179107,179347,179581,179828,180095,180343,180589,180832,181080,181327,181622,181881,182117,182358,182598,182855,183101
)


-- SABC result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	sme.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-12-01' then 'S' when rank_A_date >= '2023-12-28' then 'A' when rank_B_date >= '2023-12-28' then 'B' when rank_C_date >= '2023-12-28' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-12-28' then 'Called' else '-' end `Call or not (only date)`,
	case when bp.modified >= '2023-12-28' and (bp.rank_update in ('S', 'A', 'B', 'C', 'F', 'G', 'FFF') or bp.contract_status in ('Contracted', 'Cancelled')) then 'Called' else '-' end `Call or not (date and rank)`,
	tb.pbx_status `LCC check`, 
	case when rank_S_date >= '2023-12-28' or rank_A_date >= '2023-12-28' or rank_B_date >= '2023-12-28' or rank_C_date >= '2023-12-28' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`,
	case when bp.modified < date(now()) then '-' when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `rank of call today`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
where bp.name in (select id from temp_sme_pbx_BO where `type` in ('SABC', 'S', 'A', 'B', 'C') )
order by sme.id asc;


insert into tabSME_BO_and_Plan; select * from tabSME_BO_and_Plan_bk where name not in (select name from tabSME_BO_and_Plan);

select * from tabsme_Sales_partner_bk where name not in (select name from tabsme_Sales_partner);

-- check and add to the list temp_sme_pbx_BO
select bp.name `id`, bp.customer_tel `tel`, null `pbx_status`, null `date`, sme.staff_no `current_staff`, 
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `type`,
	timestampdiff(month,date_format(bp.creation, '%Y-%m-%d'), date(now())) `month_type`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') >= '2023-11-01' and bp.rank_update in ('S', 'A', 'B', 'C') 
	and bp.contract_status not in ('Contracted', 'Cancelled')
order by bp.name asc;



select timestampdiff(month,'2009-06-18','2009-07-29') ; -- return months; 

-- F_3mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-12-01' then 'S' when rank_A_date >= '2023-12-01' then 'A' when rank_B_date >= '2023-12-01' then 'B' when rank_C_date >= '2023-12-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-12-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-12-01' or rank_A_date >= '2023-12-01' or rank_B_date >= '2023-12-01' or rank_C_date >= '2023-12-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type <= 3)
order by sme.id asc;


-- F_6mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-12-01' then 'S' when rank_A_date >= '2023-12-01' then 'A' when rank_B_date >= '2023-12-01' then 'B' when rank_C_date >= '2023-12-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-12-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-12-01' or rank_A_date >= '2023-12-01' or rank_B_date >= '2023-12-01' or rank_C_date >= '2023-12-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type between 4 and 6)
order by sme.id asc;


-- F_9mo result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, 
	-- concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`,
	case when rank_S_date >= '2023-12-01' then 'S' when rank_A_date >= '2023-12-01' then 'A' when rank_B_date >= '2023-12-01' then 'B' when rank_C_date >= '2023-12-01' then 'C' else bp.rank_update end `rank_update`,
	is_sales_partner `SP_rank`, 
	case when bp.modified >= '2023-12-01' then 'Called' else '-' end `Call or not`,
	'' `LCC check`, 
	case when rank_S_date >= '2023-12-01' or rank_A_date >= '2023-12-01' or rank_B_date >= '2023-12-01' or rank_C_date >= '2023-12-01' then 1 else 0 end `visit target`,
	bp.visit_or_not , 
	bp.disbursement_date_pay_date, bp.ringi_status,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.name in (select id from temp_sme_SABCF where `type` in ('F') and month_type between 7 and 9)
order by sme.id asc;






-- ------------------------------------ sme orgstaff ------------------------------------
create table `sme_orgstaff` (
	`id` int(11) not null auto_increment,
	`staff_no` varchar(255) default null,
	`staff_name` varchar(255) default null,
	`gender` varchar(255) default null,
	`first_name_lo` varchar(255) default null,
	`last_name_lo` varchar(255) default null,
	`first_name_en` varchar(255) default null,
	`last_name_en` varchar(255) default null,
	`branch` varchar(255) default null,
	`department` date not null,
	`job_title` varchar(255) default null,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default charset=utf8;


drop table sme_orgstaff 




alter table tabSME_Collection rename column call_by to who_call;




















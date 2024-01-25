




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
	case when bp.contract_status = 'Contracted' then 'Contracted' when date_format(bp.modified, '%Y-%m-%d') = date_format(bp.creation, '%Y-%m-%d') then 'No follow'
		when bp.contract_status = 'Cancelled' then 'Cancelled' when bp.rank_update in ('S','A','B','C') then 'SABC' when bp.rank_update in ('F', 'G') then 'F'
	end `Result after followed`,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`, concat(bp.maker, ' - ', bp.model, ' (', bp.`year`, ')') `collateral`
	, bp.customer_name, bp.customer_tel , bp.`type` 
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where date_format(bp.creation, '%Y-%m-%d') >= '2024-01-03' and bp.rank1 in ('S','A','B','C','F') and bp.`type` in ('New', 'Dor','Inc')
order by case when bp.callcenter_of_sales is null or bp.callcenter_of_sales = '' then sme.id else smec.id end asc;


select name, owner_staff_no , staff_no  from tabSME_BO_and_Plan tsbap where name in ()


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
select sme.staff_no, 1 `case`, case when bp.`type` = 'New' then 'NEW' when bp.`type` = 'Dor' then 'DOR' when bp.`type` = 'Inc' then 'INC' end `type`,
	bp.usd_loan_amount, bp.case_no, bp.contract_no, -- bp.customer_name, 
	concat('=HYPERLINK("http://13.250.153.252:8000/app/sme_bo_and_plan/"&',bp.name,',', '"' , bp.customer_name, '"',')' ) `customer_name`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' 
		when bp.ringi_status = 'Approved' then 'APPROVED' when bp.ringi_status = 'Pending approval' then 'PENDING' 
		when bp.ringi_status = 'Draft' then 'DRAFT' when bp.ringi_status = 'Not Ringi' then 'No Ringi' 
	end `Now Result`, 
	bp.disbursement_date_pay_date , 'ແຜນເພີ່ມ' `which`, bp.name, case when bp.credit_remark is not null then bp.credit_remark else bp.contract_comment end `comments`
from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
 where bp.name in (196112,199165,199801,201825,201827,201837,202162,202464,199637,201854,34924,200873,202544,196958,199304,201893,202557,199554,200151,200453,200617,201785,198650,199893,200043,197384,197722,200505,201851,200841,202516,200946,202549,198954,200347,200480,201776,201818,202218,202442,198943,199564,198519,240,199777,201773,196215,198005,202018,199127,201523,200363,199318,201878,202160,198538,201860,196404,198523,194309,201504,202652,200707,200865,201765,199174,201847,202224,197472,201911,202439,193797,193796,202134,198728,199120,201812,200117,201055,201811,201761,202174,197449,202485,202129,199181,199122,198924,200076,201707,201234,200644,200901,199282,197673,198614,198615,199446,201758,201124,202058,202587,197931,201931,191889,202429,201935,202204,202572,201216,201712,197678,199248,201897,202016,202535,198662,198367,198962,198915,200579,200909,201638,201894,202223,201714,200904,200878,202366,193998,197936,202562,197675,197116,199833,201766,194292,201748,202038,202482,201760,202653,196535,199121,13341,109411,201127,201828,199111,200911,192943,196919,200177,200490,200140,200923,198757,201858,201339,187837,196140,198076,198911,199159,199776,199950,200230,200502,200716,201313,202119,202634,198912,199407,200834,202256,199986,202275,201901,198969,199723,201201,201887,202446,202449,115513,201824,202370,72492,200701,200704,200846,201621,202245,202434,202187,202210,199468,200187,200965,200951,201798,202205,202230,201870,197168,200766,201488,202212,201907,198724,201835,202046,202327,202077,199296,61796,116538,192981,114390,202179,201778,116016,197542,200191,202334,201330,202415,198139,196527,198474,198845,201333,201631,201912,201990,202172,200517,194763,201916,197660,198281,196182,194126,199185,201924,202060,202070,202460,202461,200213,200253,202197,195978,198362,196872,197466,202325,197612,198624,193645,201688,201918,193186,195113,197572,201029,201902,202603,198459,198652,198200,198049,199207,199490,199628,199966,199974,200594,200906,34799,200136,202365,200514,200872,201296,201866,202003,202247,202605,201879,202036,202509,194056,198501,198687,198816,201849,201856,201852,201871,201794,201864,201364,202424,201348,201850,201876,201949,198518,193208,201549,202000,202216,200637,201881,202198,201312,201556,202012,202202,199176,95533,200771,202635,196055,201784,201936,201943,108310,197842,201857,202072,202351,202255,199803,201954)
 order by field(bp.name, 196112,199165,199801,201825,201827,201837,202162,202464,199637,201854,34924,200873,202544,196958,199304,201893,202557,199554,200151,200453,200617,201785,198650,199893,200043,197384,197722,200505,201851,200841,202516,200946,202549,198954,200347,200480,201776,201818,202218,202442,198943,199564,198519,240,199777,201773,196215,198005,202018,199127,201523,200363,199318,201878,202160,198538,201860,196404,198523,194309,201504,202652,200707,200865,201765,199174,201847,202224,197472,201911,202439,193797,193796,202134,198728,199120,201812,200117,201055,201811,201761,202174,197449,202485,202129,199181,199122,198924,200076,201707,201234,200644,200901,199282,197673,198614,198615,199446,201758,201124,202058,202587,197931,201931,191889,202429,201935,202204,202572,201216,201712,197678,199248,201897,202016,202535,198662,198367,198962,198915,200579,200909,201638,201894,202223,201714,200904,200878,202366,193998,197936,202562,197675,197116,199833,201766,194292,201748,202038,202482,201760,202653,196535,199121,13341,109411,201127,201828,199111,200911,192943,196919,200177,200490,200140,200923,198757,201858,201339,187837,196140,198076,198911,199159,199776,199950,200230,200502,200716,201313,202119,202634,198912,199407,200834,202256,199986,202275,201901,198969,199723,201201,201887,202446,202449,115513,201824,202370,72492,200701,200704,200846,201621,202245,202434,202187,202210,199468,200187,200965,200951,201798,202205,202230,201870,197168,200766,201488,202212,201907,198724,201835,202046,202327,202077,199296,61796,116538,192981,114390,202179,201778,116016,197542,200191,202334,201330,202415,198139,196527,198474,198845,201333,201631,201912,201990,202172,200517,194763,201916,197660,198281,196182,194126,199185,201924,202060,202070,202460,202461,200213,200253,202197,195978,198362,196872,197466,202325,197612,198624,193645,201688,201918,193186,195113,197572,201029,201902,202603,198459,198652,198200,198049,199207,199490,199628,199966,199974,200594,200906,34799,200136,202365,200514,200872,201296,201866,202003,202247,202605,201879,202036,202509,194056,198501,198687,198816,201849,201856,201852,201871,201794,201864,201364,202424,201348,201850,201876,201949,198518,193208,201549,202000,202216,200637,201881,202198,201312,201556,202012,202202,199176,95533,200771,202635,196055,201784,201936,201943,108310,197842,201857,202072,202351,202255,199803,201954);
where (bp.rank_update in ('S','A','B','C') or bp.list_type is not null ) 
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-12-06' then 0 else 1 end != 0 -- if contracted before '2023-09-29' then not need
	and bp.disbursement_date_pay_date between '2024-01-24' and '2024-01-31'  and date_format(bp.modified, '%Y-%m-%d') >= '2024-01-24'
	and bp.ringi_status != 'Rejected' -- and bp.contract_status != 'Cancelled'
order by sme.id ;



-- updtate F rank assign to new people
update tabSME_BO_and_Plan bp inner join temp_sme_SABCF tss on (bp.name = tss.id)
set bp.staff_no = tss.current_staff, bp.callcenter_of_sales = null 
where tss.`type` = 'F'


select * from tabsme_Sales_partner tsp where name in (738,1026,4744,454,4143,553,480,481)


-- SABC result
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	sme.staff_no `Staff No`, 
	bp.own_salesperson ,
	sme.staff_name `Staff Name`, 
	bp.usd_loan_amount, bp.customer_name, bp.customer_tel,
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

select * from tabsme_Sales_partner where name = 2037; not in (select name from tabsme_Sales_partner);

select bp.name , bp.staff_no, te.staff_no, te.name from tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
where bp.staff_no <> te.name and bp.name <= 10000;

update tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
set bp.staff_no = te.name where bp.name in (72451, 72623, 75313, 77608) and bp.staff_no <> te.name ;



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




















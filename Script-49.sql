




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
	set broker_tel = 
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
	end,
	broker_type = case when refer_type = 'LMS_Broker' then 'SP - ນາຍໜ້າໃນອາດີດ' else broker_type end
;



select COUNT(*) 
from tabsme_Sales_partner sp left join sme_org sme on (case when locate(' ', sp.current_staff) = 0 then sp.current_staff else left(sp.current_staff, locate(' ', sp.current_staff)-1) end = sme.staff_no)
inner join temp_sme_pbx_SP ts on (ts.id = sp.name)
where sp.refer_type = 'tabSME_BO_and_Plan'

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


update tabSME_BO_and_Plan set is_sales_partner = 'No-ບໍ່ສົນໃຈ' where is_sales_partner is null


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
 where bp.name in (196112,205451,205453,207268,209487,208388,207238,212055,213741,214126,215326,201854,209070,207281,212228,212229,212678,215258,201851,212937,214736,214581,200347,212220,212222,208716,214824,208158,201812,207774,208652,212226,240,199777,201773,202457,203182,201849,212887,209066,201919,203664,96467,212231,212943,214958,200977,199530,209377,196215,213958,214893,209399,205750,211672,213819,214468,215285,209677,207271,209666,212216,212224,214818,209470,209663,214913,213865,214040,206253,207287,208455,209493,209532,209591,213322,214242,214245,203152,204247,204933,209078,198139,198845,201631,201990,209200,208764,204926,209230,206284,207251,211462,213791,214094,208040,210616,205583,206335,193208,205624,213766,214543,201881,202034,207024,211928,200637,212207,206376,210177,212494,205732,207266,213841,212201,205318,206278,206263,206569,210017,214593,206191,207048,209008,209656,211117,209764,212351,214007,214662,212976,213443,203150,207350,209397,203318,206962,206342,210806,213564,215242,192396,204444,205373,208627,210180,211938,212599,214277,206298,211293,200704,200846,109712,202655,208230,63804,116104,214194,214716,108896,202239,110169,206472,205158,214198,199468,200187,211899,212230,214707,214731,214796,214678,211963,211069,214555,212665,214580,213087,214312,214316,192981,114390,112275,202311,100072,117675,202166,21195,21186,213382,197842,202874,207041,208811,210153,211492,214607,209179,211490,203146,209490,211942,213091,208392,212878,197449,205740,197673,198615,199446,201124,203231,205449,207984,211989,212779,213067,205720,209279,212709,203007,209023,208218,210012,211018,214343,213927,208562,208554,194292,203109,206070,208904,212624,213318,215065,215328,201760,205501,207942,206474,196535,199121,13341,109411,201828,198129,212831,199111,200911,200517,194763,201916,203397,206017,211768,212860,207957,214216,202557,211446,212657,210077,213372,209484,214310,203151,210375,212314,213051,209453,210430,212213,212672,213964,198962,202223,207633,204622,210094,211871,25533,213595,214429,214772,214215,214383,210551,214176,214174,207283,210351,212925,214124,213776,214119,213775,214125,205774,206592,207267,208379,210683,215246,117382,209916,212278,205285,208759,206815,212682,205734,214897,202899,201994,214243,211566,214535,202195,200985,205869,211789,213715,214602,205804,205085,205646,205515,206093,206717,206721,206984,207574,208687,209266,208533,210070,210163,209799,211242,211530,212952,213934,214286,214608,211442,212384,214436,213877,213935,214426,205593,205751,205785,206454,207823,208007,208862,210540,207499,210580,211097,212587,212702,205780,209382,201910,206299,206682,207735,208660,212014,212373,212386,213727,213876,213924,215102,215187,215228,66463,201454,206203,207716,211023,213459,206535,214747,204721,207274,208242,208699,213780,214362,113370,200594,200906,212382,213264,214630,214266,214615,213023,214622,214726,202365,206565,209222,213239,208848,209872,211198,211355,206120,208391,209120,210337,211749,209659,213219,202697,206180,208510,210565,211974,214264,206819,214314,206005,211830,213767,214522,198742,62219,212944,198687,198816,204616,211273,212948,212949,215053,30002,204871,202635,203013,204178,209339,210621,211992,198517,213840,214023,213203,199122,202248,202435,203456,209745,214341,201234,213269,197168,203168,202088,205377,206055,208042,213475,208029,214132,214131,198724,201835,206078,200230,205939,212172,213346,202077,205417,206680,208385,213431,192943,196919,200177,200490,202372,203657,205125,207270,213281,200923,208891,214501,213988,202251,207390,201858,202165,202048,202703,202707,203627,197932,211995,199415,200327,213019,202261,213845,204789,205075,205448,205662,205753,207263,208364,208333,209238,214051,210744,212348,212355,205505,199036,200235,213100,206002,207528,210863,199407,202256,202770,205636,203193,209057,209866,211636,212695,213418,33387,206517,205807,208556,212383,197116,199833,202389,204433,204437,205805,211294,212581,213101,204404,212947) order by field(bp.name, 196112,205451,205453,207268,209487,208388,207238,212055,213741,214126,215326,201854,209070,207281,212228,212229,212678,215258,201851,212937,214736,214581,200347,212220,212222,208716,214824,208158,201812,207774,208652,212226,240,199777,201773,202457,203182,201849,212887,209066,201919,203664,96467,212231,212943,214958,200977,199530,209377,196215,213958,214893,209399,205750,211672,213819,214468,215285,209677,207271,209666,212216,212224,214818,209470,209663,214913,213865,214040,206253,207287,208455,209493,209532,209591,213322,214242,214245,203152,204247,204933,209078,198139,198845,201631,201990,209200,208764,204926,209230,206284,207251,211462,213791,214094,208040,210616,205583,206335,193208,205624,213766,214543,201881,202034,207024,211928,200637,212207,206376,210177,212494,205732,207266,213841,212201,205318,206278,206263,206569,210017,214593,206191,207048,209008,209656,211117,209764,212351,214007,214662,212976,213443,203150,207350,209397,203318,206962,206342,210806,213564,215242,192396,204444,205373,208627,210180,211938,212599,214277,206298,211293,200704,200846,109712,202655,208230,63804,116104,214194,214716,108896,202239,110169,206472,205158,214198,199468,200187,211899,212230,214707,214731,214796,214678,211963,211069,214555,212665,214580,213087,214312,214316,192981,114390,112275,202311,100072,117675,202166,21195,21186,213382,197842,202874,207041,208811,210153,211492,214607,209179,211490,203146,209490,211942,213091,208392,212878,197449,205740,197673,198615,199446,201124,203231,205449,207984,211989,212779,213067,205720,209279,212709,203007,209023,208218,210012,211018,214343,213927,208562,208554,194292,203109,206070,208904,212624,213318,215065,215328,201760,205501,207942,206474,196535,199121,13341,109411,201828,198129,212831,199111,200911,200517,194763,201916,203397,206017,211768,212860,207957,214216,202557,211446,212657,210077,213372,209484,214310,203151,210375,212314,213051,209453,210430,212213,212672,213964,198962,202223,207633,204622,210094,211871,25533,213595,214429,214772,214215,214383,210551,214176,214174,207283,210351,212925,214124,213776,214119,213775,214125,205774,206592,207267,208379,210683,215246,117382,209916,212278,205285,208759,206815,212682,205734,214897,202899,201994,214243,211566,214535,202195,200985,205869,211789,213715,214602,205804,205085,205646,205515,206093,206717,206721,206984,207574,208687,209266,208533,210070,210163,209799,211242,211530,212952,213934,214286,214608,211442,212384,214436,213877,213935,214426,205593,205751,205785,206454,207823,208007,208862,210540,207499,210580,211097,212587,212702,205780,209382,201910,206299,206682,207735,208660,212014,212373,212386,213727,213876,213924,215102,215187,215228,66463,201454,206203,207716,211023,213459,206535,214747,204721,207274,208242,208699,213780,214362,113370,200594,200906,212382,213264,214630,214266,214615,213023,214622,214726,202365,206565,209222,213239,208848,209872,211198,211355,206120,208391,209120,210337,211749,209659,213219,202697,206180,208510,210565,211974,214264,206819,214314,206005,211830,213767,214522,198742,62219,212944,198687,198816,204616,211273,212948,212949,215053,30002,204871,202635,203013,204178,209339,210621,211992,198517,213840,214023,213203,199122,202248,202435,203456,209745,214341,201234,213269,197168,203168,202088,205377,206055,208042,213475,208029,214132,214131,198724,201835,206078,200230,205939,212172,213346,202077,205417,206680,208385,213431,192943,196919,200177,200490,202372,203657,205125,207270,213281,200923,208891,214501,213988,202251,207390,201858,202165,202048,202703,202707,203627,197932,211995,199415,200327,213019,202261,213845,204789,205075,205448,205662,205753,207263,208364,208333,209238,214051,210744,212348,212355,205505,199036,200235,213100,206002,207528,210863,199407,202256,202770,205636,203193,209057,209866,211636,212695,213418,33387,206517,205807,208556,212383,197116,199833,202389,204433,204437,205805,211294,212581,213101,204404,212947);
where (bp.rank_update in ('S','A','B','C') or bp.list_type is not null ) 
	and case when bp.contract_status = 'Contracted' and bp.disbursement_date_pay_date < '2023-12-06' then 0 else 1 end != 0 -- if contracted before '2023-09-29' then not need
	and bp.disbursement_date_pay_date between '2024-02-13' and '2024-02-29'  and date_format(bp.modified, '%Y-%m-%d') >= '2024-02-13'
	and bp.ringi_status != 'Rejected' -- and bp.contract_status != 'Cancelled'
order by sme.id ;

select * from tabSME_BO_and_Plan tsbap where name = 209279

-- update backup data 
replace into tabSME_BO_and_Plan_bk select * from tabSME_BO_and_Plan; -- Updated Rows	190082
replace into tabsme_Sales_partner_bk select * from tabsme_Sales_partner; -- Updated Rows	196024

-- xyz to import to tabsme_Sales_partner
insert into tabsme_Sales_partner (`current_staff`, `owner_staff`, `broker_type`, `broker_name`, `broker_tel`, `address_province_and_city`, `address_village`, `business_type`,
	`year`, `refer_id`, `refer_type`, `creation`, `modified`, `owner`)
select bp.staff_no `current_staff`, bp.own_salesperson `owner_staff`, bp.is_sales_partner `broker_type`, bp.customer_name `broker_name`, bp.customer_tel `broker_tel`,
	bp.address_province_and_city, bp.address_village, bp.business_type, bp.`year`, bp.name `refer_id`, 'tabSME_BO_and_Plan' `refer_type`,
	bp.creation, bp.modified, bp.owner
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.is_sales_partner in ('X - ລູກຄ້າໃໝ່ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Y - ລູກຄ້າເກົ່າ ທີ່ສົນໃຈເປັນນາຍໜ້າ', 'Z - ລູກຄ້າປັດຈຸບັນ ທີ່ສົນໃຈເປັນນາຍໜ້າ')
	and bp.name not in (select refer_id from tabsme_Sales_partner where refer_type = 'tabSME_BO_and_Plan');

-- to make your form can add new record after you import data from tabSME_BO_and_Plan
select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner;
alter table tabsme_Sales_partner auto_increment= 110532 ; -- next id
insert into sme_sales_partner_id_seq select (select max(name)+1 `next_not_cached_value` from tabsme_Sales_partner), minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count 
from sme_bo_and_plan_id_seq;




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


-- 
insert into tabSME_BO_and_Plan; select * from tabSME_BO_and_Plan_bk where name not in (select name from tabSME_BO_and_Plan);

select * from tabsme_Sales_partner_bk where name not in (select name from tabsme_Sales_partner);

select bp.name , bp.staff_no, te.staff_no, te.name from tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
where bp.staff_no <> te.name and bp.name <= 10000;

update tabSME_BO_and_Plan bp left join tabsme_Employees te on (bp.staff_no = te.staff_no)
set bp.staff_no = te.name where bp.name in (72451, 72623, 75313, 77608) and bp.staff_no <> te.name ;


-- SABC export the current list 
select * from temp_sme_pbx_BO tspb;

-- SABC Additional list for SABC less or 1 year
select bp.name `id`, bp.customer_tel, null `pbx_status`, null `date`, staff_no `current_staff`, 
	case when bp.rank_update in ('S', 'A', 'B', 'C') then bp.rank_update else bp.rank1 end `type`, 
	case when timestampdiff(month, bp.creation, date(now())) > 36 then 36 else timestampdiff(month, bp.creation, date(now())) end `month_type`,
	case when bp.contract_status = 'Contracted' then 'Contracted' when bp.contract_status = 'Cancelled' then 'Cancelled' else bp.rank_update end `Now Result`
from tabSME_BO_and_Plan bp 
where ( (bp.rank1 in ('S', 'A', 'B', 'C') and date_format(bp.creation, '%Y-%m-%d') between '2024-01-01' and '2024-01-31' and bp.rank_update not in ('FFF') )
	or bp.rank_update in ('S', 'A', 'B', 'C') )
	and bp.contract_status not in ('Contracted', 'Cancelled');




-- update
update tabSME_BO_and_Plan bp inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
set bp.staff_no = tb.current_staff 


select sp.name, sp.current_staff, sp.owner_staff , te.name , te.staff_no 
from tabsme_Sales_partner sp left join tabsme_Employees te on (sp.owner_staff = te.staff_no) 
where sp.current_staff != te.name

update  tabsme_Sales_partner sp left join tabsme_Employees te on (sp.owner_staff = te.staff_no) 
set sp.owner_staff = te.name
where sp.owner_staff != te.name


-- Yoshi request
select bp.name `id`, date_format(bp.creation, '%Y-%m-%d') `date create`, bp.customer_name, bp.customer_tel , 
	case when timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) =0 then 1 
	else timestampdiff(year, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `year_type`,
	case when tspb.id is not null then tspb.month_type else timestampdiff(month, date_format(bp.creation, '%Y-%m-%d'), date(now())) end `month_type`,
	bp.rank1, 
	case when bp.contract_status = 'Contracted' then 'Contracted' else bp.rank_update end `type`,
	case when bp.contract_status = 'Contracted' then 'x' else 'ok' end `without contracted`,
	case when sme.staff_no is not null then concat(sme.staff_no, ' - ', sme.staff_name)
		when smec.staff_no is not null then concat(smec.staff_no, ' - ', smec.staff_name)
		else null
	end 'current_staff'
from tabSME_BO_and_Plan bp left join temp_sme_pbx_BO tspb on (bp.name = tspb.id)
left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.rank1 in ('S', 'A', 'B', 'C', 'F') ;




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




















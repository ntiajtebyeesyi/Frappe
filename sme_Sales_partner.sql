

-- form for import data from csv to frappe 
select current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, contract_no, `rank`, refer_id  
from tabsme_Sales_partner 

-- add column
alter table tabsme_Sales_partner add column refer_id int(11) not null default 0;


-- to make your form can add new record after you import data by cvs
alter table tabsme_Sales_partner auto_increment=94768; -- next id
insert into sme_sales_partner_id_seq select 94768, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_sales_partner_id_seq;

update tabsme_Sales_partner set modified = date(now()); -- creation = date(now()),


-- export to google sheet
select sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sme.staff_no, sme.staff_name, sp.broker_type, sp.broker_name, sp.`rank`, sp.date_for_introduction, sp.customer_name,
	sp.modified `date_update`, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`, sp.name `id`
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = 'SP -  ນາຍໜ້າໃນອາດີດ';


-- temp update current_staff
create table temp_sme_sales_partner (
	id int(11) not null auto_increment,
	current_staff varchar(255) ,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- update contact_no
update tabsme_Sales_partner set broker_tel = 
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


-- SP export to google sheet https://docs.google.com/spreadsheets/d/17coswPI_uF-E3aEXbqMpQD_en1FDKUFX95zXluT3dhs/edit#gid=564749378
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sp.current_staff `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = 'SP -  ນາຍໜ້າໃນອາດີດ' order by sme.id ;


-- 5way export to google sheet https://docs.google.com/spreadsheets/d/15wAmhxB0gDAHDwa6WSmY-PqPvAm6eOoIP5YKp48wTi4/edit#gid=406704453
select sp.name `id`, date_format(sp.modified, '%Y-%m-%d') `date_update`, sme.`dept`, sme.`sec_branch`, sme.`unit_no`, sme.unit, sp.current_staff `staff_no` , sme.staff_name, sp.owner_staff 'owner', 
	sp.broker_type, sp.broker_name, sp.address_province_and_city, sp.`rank`, sp.date_for_introduction, sp.customer_name, concat('http://13.250.153.252:8000/app/sme_sales_partner/', sp.name) `Edit`,
	case when sp.owner_staff = sp.current_staff then '1' else 0 end `owner_takeover`,
	sp.broker_tel
from tabsme_Sales_partner sp left join sme_org sme on (sp.current_staff = sme.staff_no)
where sp.broker_type = '5way - 5ສາຍພົວພັນ' and sp.owner_staff = sp.current_staff order by sme.id ;


-- _____________________________________________________________ update current staff for tabsme_Sales_partner _____________________________________________________________
-- export current data
select name `id`, current_staff , refer_id 
from tabsme_Sales_partner where broker_type = 'SP -  ນາຍໜ້າໃນອາດີດ';

-- update 
update tabsme_Sales_partner sp inner join temp_sme_sales_partner tsp on (sp.name = tsp.id)
set sp.current_staff = tsp.current_staff ;


-- _____________________________________________________________ update Sales partner _____________________________________________________________
-- SP
update tabsme_Sales_partner set broker_type = 'SP - ນາຍໜ້າໃນອາດີດ', refer_type = 'LMS_Broker' where name between 1 and 5677;

-- 5way
update tabsme_Sales_partner set broker_type = '5way - 5ສາຍພົວພັນ', refer_type = '5way' where name between 5678 and 94767;














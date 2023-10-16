

-- form for import data from csv to frappe 
select current_staff, owner_staff, broker_type, broker_name, broker_tel, address_province_and_city, address_village, broker_workplace, business_type, ever_introduced, contract_no, `rank`, refer_id  
from tabsme_Sales_partner 

-- add column
alter table tabsme_Sales_partner add column refer_id int(11) not null default 0;


-- to make your form can add new record after you import data by cvs
alter table tabsme_Sales_partner auto_increment=5678; -- next id
insert into sme_sales_partner_id_seq select 5678, minimum_value, maximum_value, start_value, increment, cache_size, cycle_option, cycle_count from sme_sales_partner_id_seq;




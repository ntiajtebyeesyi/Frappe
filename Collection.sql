
-- 1) select data to show in google sheet and looker studio
select cb.contract_no, sme.`g-dept`, sme.dept, sme.sec_branch, sme.unit, cb.sales_staff, cb.collection_staff, cb.collection_cc_staff,
	cb.customer_name, cb.debt_type, cb.collection_status, cb.now_amount_usd, ac.date, ac.collection_method, ac.call_result, ac.visited_result,
	ac.rank_of_case, ac.next_policy, ac.policy_due_date, ac.promise_date,
	concat('http://13.250.153.252:8000/app/activity_of_collection/', ac.name) `edit`,
	ac.priority
from tabcontract_base cb 
left join sme_org sme on (case when locate(' ', cb.sales_staff) = 0 then cb.sales_staff else left(cb.sales_staff, locate(' ', cb.sales_staff)-1) end = sme.staff_no)
left join tabActivity_of_collection ac on ac.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
order by sme.id asc;


-- 2) insert collection order to collection and collection CC people
insert into tabActivity_of_collection (`contract_no`, `collection_staff`, `date`, `collection_method`, `collectioin_result`, `priority`)
select cb.contract_no, cb.collection_staff, 
	case when cb.collection_status = 'already paid' then null else '2024-03-20' end `date`, 
	case when cb.collection_status = 'already paid' then '' else 'Visit / ລົງຢ້ຽມຢາມ' end `collection_method`, 
	case when cb.collection_status = 'already paid' then 'Paid / ຈ່າຍ' else null end `collectioin_result`,
	case when cb.collection_status = 'already paid' then ''
		when count(ac.exceptional) >=1 then 1 -- Exceptional case
		when ac2.gps_status = 'offline' or cb.gps_status = 'offline' then 2 -- GPS Offline
		when count(ifnull(ac.promise_date, 1)) >= 1 then 3 -- No payment promise
		when count(ac.promise_date) or ac2.promise_date > date(now()) then 4 -- Break payment primise
		else 5 -- Others
	end `priority` 
from tabcontract_base cb left join tabActivity_of_collection ac on (ac.contract_no = cb.name)
left join tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
 where cb.debt_type != '' and cb.collection_status = '0'
group by cb.name ;


alter table tabActivity_of_collection add is_order int(11)


-- update
update tabcontract_base cb
left join tabActivity_of_collection ac2 on ac2.name = (select name from tabActivity_of_collection where contract_no = cb.name order by name desc limit 1)
set ac2.is_order = 1 
where ac2.contract_no in (2087517,2104276,2104393,2094767,2076519,2098028,2090574,2072869,2075390,2077071,2105768,2105086,2105356,2087034,2074744,2087715,2097141,2102468,2078128,2099849,2089658,2083786,2089639,2082244,2105806,2101938,2076173,2098513,2100492,2096654,2102966,2097631,2104633,2104319,2103192,2099707,2098399,2095495,2090776,2098608,2098158,2098546,2090892,2102562,2099451,2101807,2104981,2100987,2104874,2104107,2088844,2097284,2094027,2094569,2103374,2103380,2086526,2102132,2101298,2102077,2102228,2089063,2089966,2104706,2101059,2098828,2101460,2094932,2076620,2074813,2098084,2096372,2079762,2079882,2071359,2084047,2067534,2066769,2083353,2105809,2083935,2081245,2101918,2082751,2062731,2099550,2101159,2098631,2096765,2094393,2092477,2086960,2088830,2086007,2089127,2079264,2073107,2087672,2102013,2105044,2101537,2073266,2097349,2102808,2060802,2084609,2100971,2089610,2105808,2090327,2076603,2089739,2090731,2102390,2068805)


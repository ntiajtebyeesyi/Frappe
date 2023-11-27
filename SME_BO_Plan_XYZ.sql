
-- XYZ
select bp.modified `Timestamp`, 
	bp.name `id`,
	sme.unit_no `Unit_no`, 
	sme.unit `Unit`, 
	bp.staff_no `Staff No`, 
	sme.staff_name `Staff Name`, 
	bp.customer_name, bp.customer_tel,
	bp.is_sales_partner,
	concat('http://13.250.153.252:8000/app/sme_bo_and_plan/', name) `Edit`
from tabSME_BO_and_Plan bp left join sme_org sme on (bp.staff_no = sme.staff_no)
left join sme_org smec on (regexp_replace(bp.callcenter_of_sales  , '[^[:digit:]]', '') = smec.staff_no)
where bp.is_sales_partner in ('X-ລູກຄ້າປັດຈຸບັນສົນໃຈເປັນນາຍໜ້າ', 'Y-ລູກຄ້າເກົ່າສົນໃຈເປັນນາຍໜ້າ', 'Z-ລູກຄ້າໃໝ່ສົນໃຈເປັນນາຍໜ້າ')
order by sme.id asc;

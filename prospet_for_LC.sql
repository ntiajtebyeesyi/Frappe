select 
bp.contract_no ,
bp.case_no `customer_id`,
bp.customer_name  `customer_name_lo`,
null `customer_name_en`,
null `currency`,
bp.usd_loan_amount `lending amount`,
null `USD Equivalent`,
null `Black list`,
null `company_name`,
bp.customer_tel `customer_tel1`,
null `customer_tel2`,
null `village`,
null `city`,
null `province`,
'Prospect_customer' `customer_type`,
null `Loan amount`,
null `position`,
	case bp.business_type when '37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່' then '1)Mining' 
						when '21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ' then '3)Trading/export-import'
						when '36 Logicstics-warehousing/ບໍລິການຂົນສົ່ງ-ສາງ' then '4)Logistics'
						when '6 Argricultural/ກະສິກຳ ແລະ ການກະເສດ' then '7)Agriculture'
		else 'Other' end `Business Type` 
	from tabSME_BO_and_Plan bp left join sme_org sme on (case when locate(' ', bp.staff_no) = 0 then bp.staff_no else left(bp.staff_no, locate(' ', bp.staff_no)-1) end = sme.staff_no)
inner join temp_sme_pbx_BO tb on (tb.id = bp.name)
where bp.business_type in ('37 Mining/ການຂຸດຄົ້ນບໍ່ແຮ່','21 Export-Import/ສົ່ງອອກ-ນຳເຂົ້າ','36 Logicstics-warehousing/ບໍລິການຂົນສົ່ງ-ສາງ','6 Argricultural/ກະສິກຳ ແລະ ການກະເສດ')
order by sme.id asc;



-- 1) create temp_sme_pbx_BO for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_BO` (
  `id` int(11) not null auto_increment,
  `customer_tel` varchar(255) default null,
  `pbx_status` varchar(255) default null,
  `date` datetime default null,
  `current_staff` varchar(255) default null,
  `type` varchar(255) default null,
  `month_type` int(11) default null comment '3=3 months or less, 6=6months or less, 9=9months or less, 12=12months or less',
  primary key (`id`)
) engine=innodb auto_increment=1 default charset=utf8mb3 collate=utf8mb3_general_ci;


-- 2) create temp_sme_pbx_SP for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_SP` (
	`id` int(11) not null auto_increment,
	`broker_tel` varchar(255) default null,
	`pbx_status` varchar(255) default null,
	`date` datetime default null,
	primary key (`id`)
)engine=InnoDB auto_increment=1 default CHARSET=utf8mb3 collate=utf8mb3_general_ci;

-- 2.1 update current sales
update temp_sme_pbx_SP ts inner join tabsme_Sales_partner sp on (ts.id = sp.name)
set ts.current_staff = sp.current_staff ;

-- 2.2 insert new record to temp_sme_pbx_SP
insert into temp_sme_pbx_SP 
select sp.name `id`, sp.broker_tel, null `pbx_status`, null `date`, sp.current_staff from tabsme_Sales_partner sp inner join sme_org sme on (sp.current_staff = sme.staff_no)
where name not in (select id from temp_sme_pbx_SP);

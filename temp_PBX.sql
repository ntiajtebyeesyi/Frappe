

-- 1) create temp_sme_pbx_BO for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_BO` (
	`id` int(11) not null auto_increment,
	`customer_tel` varchar(255) default null,
	`pbx_status` varchar(255) default null,
	`date` datetime default null,
	primary key (`id`)
)engine=InnoDB auto_increment=1 default CHARSET=utf8mb3 collate=utf8mb3_general_ci;


-- 2) create temp_sme_pbx_SP for import the data call on pbx to check did they call by IP Phone or not
create table `temp_sme_pbx_SP` (
	`id` int(11) not null auto_increment,
	`broker_tel` varchar(255) default null,
	`pbx_status` varchar(255) default null,
	`date` datetime default null,
	primary key (`id`)
)engine=InnoDB auto_increment=1 default CHARSET=utf8mb3 collate=utf8mb3_general_ci;





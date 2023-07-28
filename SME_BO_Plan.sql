
create table `sme_org` (
	`id` int(11) not null auto_increment,
	`affiliation` varchar(255) default null,
	`director` varchar(255) default null,
	`g-dept_no` int(11) not null,
	`g-dept` varchar(255) default null,
	`dept_no` int(11) not null,
	`dept` varchar(255) default null,
	`sec_branch_no` int(11) not null,
	`sec_branch` varchar(255) default null,
	`unit_no` int(11) not null,
	`unit` varchar(255) default null,
	`m-unit_no` int(11) not null,
	`mini_unit` varchar(255) default null,
	`sales_pair` varchar(255) default null,
	`sales_cc` varchar(255) default null,
	`staff_no` varchar(255) default null,
	`staff_name` varchar(255) default null,
	`gender` varchar(255) default null,
	`former_job` varchar(255) default null,
	`hire_date` date not null,
	`title` varchar(255) default null,
	`h_b` varchar(255) default null,
	`rank` int(11) not null,
	`retirement_date` date default null,
	primary key (`id`)
) engine=InnoDB auto_increment=1 default charset=utf8;


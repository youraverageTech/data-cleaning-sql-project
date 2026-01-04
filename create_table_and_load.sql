DROP TABLE IF EXISTS club_member_info;

CREATE TABLE club_member_info(
	id serial primary key,
	full_name text,
	age int,
	martial_status text,
	email text,
	phone text,
	full_address text,
	job_title text,
	membership_date text
);

\COPY club_member_info (full_name,age,martial_status,email,phone,full_address,job_title,membership_date) FROM 'C:/Users/Alfarel/Documents/Project/Data Cleaning Project/club_member_info.csv' DELIMITER ',' CSV HEADER;
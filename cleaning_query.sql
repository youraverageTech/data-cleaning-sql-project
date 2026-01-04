-- query first 10 rows for information
select *
from club_member_info
limit 10;

-- cleaning column full_name and create column first_name and last_name
create or replace view fn_clean as
with fn1 as (
	select
		id,
		lower(trim(full_name)) as full_name
	from club_member_info
), fn2 as(
	select 
		id,
		regexp_replace(full_name, '[?./,]', '', 'g') as full_name
	from fn1
), fn3 as (
	select
		id,
		full_name,
		split_part(full_name, ' ', 1) as first_name,
		trim(substring(full_name from position(' ' in full_name) + 1)) as last_name
	from fn2
)
select * from fn3;

-- cleaning column age
select min(age), max(age)

from club_member_info;

with ag as (
	select
		id,
		substring(age::text from 1 for 2)::int as age
	from club_member_info
)
select min(age), max(age) from ag;

-- seperating address into street_address, city, state
with fa as (
	select 
		id,
		split_part(full_address, ',', 1) as street_address,
		split_part(full_address, ',', 2) as city,
		split_part(full_address, ',', 3) as state,
		replace(full_address, ',', ', ') as full_address
	from club_member_info
)
select * from fa;

-- combining all cleaned column
drop table if exists transformed_club_member_info;
create table transformed_club_member_info as
select
	cm.id,
	fn_clean.full_name,
	fn_clean.first_name,
	fn_clean.last_name,
	substring(age::text from 1 for 2)::int as age,
	martial_status,
	email,
	phone,
	split_part(full_address, ',', 1) as street_address,
	split_part(full_address, ',', 2) as city,
	split_part(full_address, ',', 3) as state,
	replace(full_address, ',', ', ') as full_address,
	job_title,
	to_date(membership_date, 'MM/DD/YYYY') as membership_date
from club_member_info as cm
join fn_clean
on cm.id = fn_clean.id;

-- cleaning duplicate value
-- email is must unique
select * from transformed_club_member_info;

select email, count(*)
from transformed_club_member_info
group by email;

select *
from transformed_club_member_info
where email in (
	select email
	from transformed_club_member_info
	group by email
	having count(*) > 1
);

delete from transformed_club_member_info
where id in (
	select id
	from (
		select
			id,
			row_number() over(partition by email order by id) as rn
		from transformed_club_member_info
		) t
	where rn > 1
);

-- convert empty fields to null
CREATE OR REPLACE FUNCTION clean_to_null(input_text TEXT)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
AS $$
    SELECT
        CASE
            WHEN input_text IS NULL THEN NULL
            WHEN TRIM(LOWER(input_text)) IN (
                '', '-', '--', 'n/a', 'na', 'null', 'none'
            ) THEN NULL
            ELSE TRIM(input_text)
        END;
$$;

select
	id,
	clean_to_null(full_name) as full_name,
	clean_to_null(first_name) as first_name,
	clean_to_null(last_name) as last_name,
	clean_to_null(age::text)::int as age,
	clean_to_null(martial_status) as martial_status,
	clean_to_null(email) as email,
	clean_to_null(phone) as phone,
	clean_to_null(street_address) as street_address,
	clean_to_null(city) as city,
	clean_to_null(state) as state,
	clean_to_null(full_address) as full_address,
	clean_to_null(job_title) as job_title,
	clean_to_null(membership_date::text)::date as membership_date
from transformed_club_member_info;

-- create column is_active_membership
-- active membership is where all membership_date > year 2000
with is_active as (
	select
		id,
		membership_date,
		case
			when membership_date < '2000-01-01' then 'No'
			else 'Yes'
		end as is_active_membership
	from transformed_club_member_info
)
select
	tc.*,
	ia.is_active_membership
from transformed_club_member_info as tc
join is_active as ia
on tc.id = ia.id;

-- create table cleaned_club_member_info
drop table if exists cleaned_club_member_info;
create table cleaned_club_member_info as
with is_active as (
	select
		id,
		membership_date,
		case
			when membership_date < '2000-01-01' then 'No'
			else 'Yes'
		end as is_active_membership
	from transformed_club_member_info
)
select
	tc.*,
	ia.is_active_membership
from transformed_club_member_info as tc
join is_active as ia
on tc.id = ia.id;

select * from cleaned_club_member_info;
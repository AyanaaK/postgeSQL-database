drop table if exists humans;

create table humans
(
    id         serial8,
    first_name varchar(30)                      not null,
    birthdate  date                             not null,
    position   varchar(50) default 'Unemployed' not null,
    income     int4        default 0            not null,
    primary key (id)
);

insert into humans (first_name, birthdate, position, income)
values ('Mark', '1992-05-03', 'Developer', 2800),
       ('Bill', '2002-09-19', 'Designer', 2200);

insert into humans (first_name, birthdate)
values ('Jeff', '1995-02-11'),
       ('John', '1988-08-28');

insert into humans (first_name, birthdate, position, income)
values ('Nick', '1998-10-11', 'Manager', 2500);

update humans
set position = 'Developer',
    income   = 3300
where id = 4;

-- delete
-- from humans
-- where position = 'Developer';

select h.*
from humans h
where h.birthdate >= '1995-01-01'
  and h.birthdate < '2000-01-01';

select h.*
from humans h
where h.birthdate between '1995-01-01' and '1999-01-01';

select concat('Human #', h.id), h.*
from humans h
where h.position = 'Developer'
   or h.position = 'Designer';

select h.*
from humans h
where h.position in ('Developer', 'Designer');

select h.*
from humans h
where h.first_name like 'J%';

select h.*
from humans h
where h.position != 'Unemployed'
order by h.position desc, h.income desc;

select h.position
from humans h
group by h.position;

select count(h.id)
from humans h;

select sum(h.income)
from humans h;

select max(h.birthdate) youngest
from humans h;

select min(h.birthdate) oldest
from humans h;

select avg(h.income)
from humans h;

select h.position, count(h.id) count
from humans h
where h.position != 'Unemployed'
group by h.position
order by count desc, h.position;
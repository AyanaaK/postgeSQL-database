drop table if exists humans;
drop table if exists human_data;


create table humans
(
    id       serial8,
    username varchar(20)  not null,
    password varchar(200) not null,
    primary key (id)
);

create table human_data
(
    id              serial8,
    human_id        int8        not null,
    document_number varchar(12) not null,
    first_name      varchar(30) not null,
    last_name       varchar(30) not null,
    birthdate       date        not null,
    primary key (id),
    unique (human_id),
    foreign key (human_id) references humans (id)
);

insert into humans(username, password)
values ('mark_22', 'Mark123#Abc'),
       ('bill.g', 'Bill$Gates#123');

insert into human_data (human_id, document_number, first_name, last_name, birthdate)
values (2, 'UK224491345', 'Bill', 'Gates', '1984-04-17'),
       (1, 'US76381243', 'Mark', 'Miller', '1992-02-22');
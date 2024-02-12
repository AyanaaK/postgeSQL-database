-- Схема для хранения товаров и характеристик товаров специфических для каждой
-- отдельно взятой категории.

-- В схеме должна быть возможность хранения категорий у каждой из которых может
-- быть свой перечень характеристик, например категория `Процессоры` с
-- характеристиками `Производитель`, `Количество ядер`, `Сокет` или категория
-- `Мониторы` с характеристиками `Производитель`, `Диагональ`, `Матрица`,
-- `Разрешение`.

-- Процессоры      -> Intel Core I9 9900 -> AMD Ryzen R7 7700
-- Производитель   -> Intel              -> AMD
-- Количество ядер -> 8                  -> 12
-- Сокет           -> 1250               -> AM4

-- Мониторы      -> Samsung SU556270 -> AOC Z215S659
-- Производитель -> Samsung          -> AOC
-- Диагональ     -> 27               -> 21.5
-- Матрица       -> TN               -> AH-IPS
-- Разрешение    -> 2560*1440        -> 1920*1080

drop table if exists categories, characteristics, products, product_characteristics;

create table categories
(
    id   serial8,
    name varchar(30) not null,
    primary key (id),
    unique (name)
);

create table characteristics
(
    id          serial8,
    category_id int8,
    name        varchar(50) not null,
    primary key (id),
    foreign key (category_id) references categories (id),
    unique (category_id, name)
);

insert into characteristics (name, category_id)
values ('Производитель', 1),
       ('Количество ядер', 1),
       ('Сокет', 1),
       ('Производитель', 2),
       ('Диагональ', 2),
       ('Матрица', 2),
       ('Разрешение', 2);

insert into categories (name)
values ('Процессоры'),
       ('Мониторы');

create table products
(
    id          serial8,
    category_id int8, --одна категория к нескольким продуктам
    name        varchar(50) not null,
    price       int8        not null,
    primary key (id),
    foreign key (category_id) references categories (id),
    unique (name)
);

create table product_characteristics
(
    id                 serial8,
    product_id         int8         not null,
    characteristics_id int8         not null,
    primary key (id),
    unique (product_id, characteristics_id),
    foreign key (product_id) references products (id),
    foreign key (characteristics_id) references characteristics (id),
    value              varchar(100) not null
);

insert into products(category_id, name, price)
values (1, 'Intel Core I9 9900', 500000),
       (1, 'AMD Ryzen R7 7700', 450000),
       (2, 'Samsung SU556270', 250000),
       (2, 'AOC Z215S659', 158888);

insert into product_characteristics(product_id, characteristics_id, value)
values (2, 8, 'Intel'),
       (3, 8, 'AMD'),
       (4, 11, 'Samsung'),
       (5, 11, 'AOC'),
       (2, 9, '8'),
       (3, 9, '12'),
       (2, 10, '1250'),
       (3, 10, 'AM4'),
       (4, 12, '27'),
       (5, 12, '21.5'),
       (4, 13, 'TN'),
       (5, 13, 'AH-IPS'),
       (4, 14, '2560*1440'),
       (5, 14, '1920*1080');

select c.name, ch.name, pc.value, p.name
from categories c
         join characteristics ch on c.id = ch.category_id
         join product_characteristics pc on ch.id = pc.characteristics_id
         join products p on c.id = p.category_id and pc.product_id = p.id
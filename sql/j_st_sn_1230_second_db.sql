-- В реляционных базах данных важнейшей особенностью является построение связей
-- между таблицами, связью называется ситуация при которой запись одной таблицы
-- ссылается на запись другой таблицы. Связи между таблицами реализуются через
-- внешние ключи. Внешний ключ - поле в таблице значение которого ссылается на
-- имеющуюся информацию другой таблицы, именно при помощи внешних ключей
-- строются любые типы связей. На внешний ключ так же как и на первичный
-- накладываются некоторые ограничения:
-- 1) Тип данных внешнего ключа должен полностью соответствовать типу данных
-- того поля на которое он ссылается.
-- 2) Внешний ключ может ссылаться только на уникальное поле другой таблицы
-- (зачастую ссылка делается на первичный ключ), иначе не получилось бы
-- детализировать запись.
-- 3) Значением внешнего ключа может быть только фактически существующая
-- информация той таблицы на которую он ссылается.

-- Возможные типы связей между таблицами:

-- 1) Один к одному - тип связи при котором на одну запись первой таблицы
-- приходится одна запись другой таблицы. При построении типа связи один к
-- одному внешний ключ может располагаться в любой из таблиц, но при этом важно
-- чтобы он был уникальным.

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
    unique (human_id)
--     foreign key (human_id) references humans (id)
);

insert into humans (username, password)
values ('mark_22', 'Mark123#Abc'),
       ('bill.g', 'Bill$Gates#123'),
       ('jeff_b_13', 'AquaMarineAbc');

insert into human_data (human_id, document_number, first_name, last_name, birthdate)
values (2, 'UK224491345', 'Bill', 'Gates', '1984-04-17'),
       (1, 'US876381243', 'Mark', 'Miller', '1992-02-22');

insert into human_data (human_id, document_number, first_name, last_name, birthdate)
values (22, 'abc', 'abc', 'abc', '1984-04-03');

-- При добавлении дополнительных таблиц в select запрос при помощи конструкции
-- join мы оперируем двумя дополнительными понятиями:
-- 1) Левая таблица - таблица либо несколько таблиц которые структурно
-- находятся до подключаемой таблицы.
-- 2) Правая таблица - дополнительная таблица подключаемая через join.

-- Конструкция join бывает разных типов:
-- 1) `inner` (по умолчанию) - включает запись левой и правой таблицы в
-- результат при условии что сопоставление в конструкции on было произведено с
-- результатом true.
-- 2) `left` - включает запись левой таблицы в результат даже если
-- сопоставление в конструкции on было произведено с результатом false.
-- 3) `right` - включает запись правой таблицы в результат даже если
-- сопоставление в конструкции on было произведено с результатом false.

select h.id,
       h.username,
       hd.document_number,
       hd.first_name,
       hd.last_name
from humans h
         left join human_data hd on h.id = hd.human_id
order by h.id;

-- 2) Один ко многим - тип связи при котором на одну запись первой таблицы
-- приходится несколько записей второй таблицы. При построении связи один ко
-- многим внешний ключ должен находится в таблице записей которой будет много,
-- при этом важно чтобы внешний ключ не был уникальным.

-- Категории (название)
-- Товары (название, стоимость)

create table categories
(
    id   serial8,
    name varchar(40) not null,
    primary key (id)
);

create table products
(
    id          serial8,
    category_id int8        not null,
    name        varchar(70) not null,
    price       int4        not null,
    primary key (id),
    foreign key (category_id) references categories (id)
);

insert into categories (name)
values ('Smartphones'),
       ('Headphones');

insert into products (category_id, name, price)
values (1, 'Apple IPhone 13', 435000),
       (2, 'Samsung Galaxy Buds 2', 119000),
       (1, 'Samsung Galaxy S22', 399000),
       (1, 'Xiaomi MI13', 336000),
       (2, 'Apple AirPods Max', 366000);

-- Написать запрос для вывода следующей информации обо всех товарах: id товара,
-- название категории, название товара, стоимость товара.

-- 3) Много ко многим - тип связи при котором на множество записей первой
-- таблицы приходится множество записей второй таблицы. При построении связи
-- много ко многим необходимо создать новую промежуточную таблицу состоящую из
-- внешних ключей ссылающихся на связываемые таблицы.

-- Категории, Товары
-- Какой тип связи: один ко многим

-- Заказы, Товары
-- Какой тип связи: много ко многим

-- Вопросы для проверки типа связи:
-- * Может ли в одном заказе быть несколько товаров? да.
-- * Может ли один товар находится в нескольких заказах? да.

create table orders
(
    id          serial8,
    discount_id int8,
    status      varchar(30) not null,
    first_name  varchar(30) not null,
    primary key (id),
    foreign key (discount_id) references discounts (id)
);

insert into orders (status, first_name)
values ('Delivered', 'Mark'),
       ('Ordered', 'Bill');

create table order_products
(
    order_id   int8 not null,
    product_id int8 not null,
    primary key (order_id, product_id),
    foreign key (order_id) references orders (id),
    foreign key (product_id) references products (id)
);

insert into order_products(order_id, product_id)
values (1, 1),
       (1, 5),
       (2, 2),
       (2, 3),
       (2, 5);

-- Вывести следующие данные о каждом заказе:
-- 1) id заказа.
-- 2) Статус заказа.
-- 3) Имя покупателя.
-- 4) Количество товаров в заказе.
-- 5) Общая стоимость заказа (всех товаров входящих в заказ).


create table discounts
(
    id         serial8,
    percentage int4 not null,
    primary key (id)
);

insert into discounts(id, percentage)
values (1, 10),
       (2, 20);

insert into orders(id, discount_id, status, first_name)
values (3, 1, 'Delivered', 'Adel');

select o.id,
       o.status,
       o.first_name,
       count(op.product_id),
       sum(p.price) sum((p.price) * (100 - d.id) / 100)
from orders o
    join order_products op
on o.id = op.order_id
    join products p on p.id = op.product_id
    left join discounts d on o.discount_id = d.id
group by o.id
order by o.id;






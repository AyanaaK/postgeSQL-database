-- Таблица - конечная точка хранения информации на сервере базы данных то есть
-- любая информация хранимая на сервере должна быть привязана к таблице.
-- Таблицы состоят из полей (столбцы) и записей (ряды). Поля таблицы и их типы
-- данных определяются при создании таблицы (запрос create table), в качестве
-- типа данных для поля можно выбрать любой из доступных на сервере базы
-- данных, сами типы данных и их названия могут отличаться для каждой отдельно
-- взятой базы данных.

-- Базовые типы данных доступные для использования в PostgreSQL:

-- * `int2` (smallint) - аналог типа short.
-- * `int4` (int, mediumint) - аналог типа int.
-- * `int8` (bigint) - аналог типа long.

-- * `float` - аналог типа float.
-- * `double` - аналог типа double.
-- * `decimal` - аналог типа BigDecimal.

-- * `bool` (boolean) - аналог типа boolean.

-- Типы varchar и text являются аналогами типа String с одинаковым предельным
-- количеством символов.
-- * `varchar(n)` - аналог типа String с возможностью определения n аргумента
-- который позволяет задать максимальное количество символов для значения.
-- * `text` - аналог типа String без возможности ограничения максимального
-- количества символов.

-- `date` - аналог типа LocalDate в формате 2021-08-23.
-- `time` - аналог типа LocalTime в формате 22:05.
-- `timestamp` - аналог типа LocalDateTime в формате 2021-08-23 22:05.

-- Любое поле таблицы по умолчанию является не обязательным для заполнения то
-- есть если явно не определить значение поля, будет применено null либо
-- значение определённое при помощи конструкции default.

-- `not null` - конструкция применяемая к полю и делающая значение null для
-- него недопустимым. Грубо говоря данная конструкция делает поле обязательным
-- для заполнения.

-- `default` - конструкция позволяющая определить значение по умолчанию
-- записываемое в поле при отсутствии явно указанного значения.

-- Первичный ключ - поле таблицы по которому будет идентифицироваться каждая
-- отдельно взятая запись этой таблицы. На первичный ключ накладываются
-- следующие ограничения:
-- 1) Значением первичного ключа не может быть null то есть по умолчанию
-- применена конструкции not null и её запись не имеет смысла для первичного
-- ключа.
-- 2) Значением первичного ключа является уникальным в контексте таблицы и не
-- может повторятся для двух записей этой таблицы.

-- Существует несколько типов данных группы serial которые являются
-- автозаполняемыми аналогами типов группы int. Типы группы serial генерируют
-- порядковое целочисленное значение для поля при добавлении записи.
-- * `serial2` - автозаполняемый аналог типа int2.
-- * `serial4` - автозаполняемый аналог типа int4.
-- * `serial8` - автозаполняемый аналог типа int8.

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

-- alter table humans
--     alter column first_name set not null;
--
-- alter table humans
--     alter column first_name set default null;
--
-- alter table humans
--     add column x timestamp default now();

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

-- `select` - запрос предназначенный для выборки информации с сервера базы
-- данных (в том числе с таблиц). select запрос является сложным и состоит из
-- большого количества составных конструкции способных влиять на его результат.
-- 1) `select <значения|поля|*>` - в данной секции select запроса определяется
-- информация которую необходимо получить в результате. Можно указать как сами
-- значения, так и поля таблицы значение которых необходимо получить (работает
-- только при наличии в запросе конструкции from). Если необходимо вытянуть
-- значения всех полей таблицы можно записать *.
-- 2) `from <таблица> <псевдоним>` - в данной секции определяется базовая
-- таблица из которой необходимо выбрать информацию. Для более удобное
-- взаимодействия с таблицей можно определить псевдоним (алиас), короткое
-- наименование используемое вместо полного названия таблицы.
-- 3) `join <таблица> <псевдоним> on <условие>` - конструкция при помощи
-- которой в запрос можно добавить дополнительную таблицу по заданному условию.
-- На каждую запись исходной таблицы будет подключена одна либо несколько
-- записей дополнительной таблицы.
-- 4) `where <условия>` - секция запроса в которой записываются условия для
-- фильтрации записей в результате. При записи нескольких условий они должны
-- быть связаны при помощи операторов and (аналог &&) или or (||).
-- 5) `group by <поля>` - секция запроса позволяющая сгруппировать результат по
-- заданному поля либо нескольким полям. При использовании группировки по полю
-- каждое уникальное значение заданного поле выносится в отдельную группу
-- (запись). Выбрать в запросе можно будет данные только тех полей которые
-- участвовали в группировке.
-- 6) `order by <поля> <направления>` - секция запроса позволяющая определить
-- поле либо несколько полей по которым необходимо произвести сортировку
-- результата. Для каждого поля можно определить одно из возможных направлений
-- сортировки: asc (по возрастанию), desc (по убыванию).

-- При записи условий могут использоваться следующие операторы сравнения:
-- * `>` (больше).
-- * `<` (меньше).
-- * `>=` (больше или равно).
-- * `<=` (меньше или равно).
-- * `=` (равно).
-- * `!=` (не равно).

-- Получить всех людей с датой рождения между 1995-01-01 и 1999-12-31.

select h.*
from humans h
where h.birthdate >= '1995-01-01'
  and h.birthdate < '2000-01-01';

select h.*
from humans h
where h.birthdate between '1995-01-01' and '1999-12-31';

-- Получить всех людей с должностью Developer или Designer.

select h.*
from humans h
where h.position = 'Developer'
   or h.position = 'Designer';

select h.*
from humans h
where h.position in ('Developer', 'Designer');

-- `like` - конструкция позволяющая сопоставить значение с заданным шаблоном
-- записанным по определённым правилам. Символ % в шаблоне означает любое
-- количество любых символов (аналог .* в регулярных выражениях).
-- * `h.first_name like 'a%'` - имена должны начинаться на a (аналог метода
-- startsWith()).
-- * `h.first_name like '%a'` - имена должны заканчиваться на a (аналог метода
-- endsWith()).
-- * `h.first_name like '%a%'` - имена должны содержать в себе a (аналог метода
-- contains()).

select h.*
from humans h
where h.first_name like 'J%';

select h.*
from humans h
where h.position != 'Unemployed'
order by h.position, h.income desc;

-- Агрегатные функции - функции применяемые на набор данных с целью получения
-- единственного результирующего значения. При использовании агрегатных функций
-- вместе с конструкцией group by функция будет применена к каждой группе по
-- отдельности, а не к общему результирующему набору данных то есть для каждой
-- группы агрегатная функция даст свой результат.
-- * `count(...)` - возвращает количество записей по заданному полю (желательно
-- уникальному и ещё лучше если первичному ключу).
-- * `sum(...)` - возвращает сумму значений по заданному числовому полю (все
-- типы int, float, double и decimal).
-- * `max(...)` - возвращает наибольшее значение по заданному полю любого типа.
-- * `min(...)` - возвращает наименьшее значение по заданному полю любого типа.
-- * `avg(...)` - возвращает среднее значение по заданному числовому полю (все
-- типы int, float, double и decimal).

select count(h.id) count,
       sum(h.income)    total,
       max(h.birthdate) youngest,
       min(h.birthdate) oldest,
       avg(h.income)    average
from humans h;

select h.position, count(h.id) count
from humans h
where h.position != 'Unemployed'
group by h.position
order by count desc, h.position;








create table users
(
    id         serial8,
    login      varchar(20)  not null,
    password   varchar(200) not null,
    first_name varchar(30)  not null,
    last_name  varchar(30)  not null,
    primary key (id)
);

create table categories
(
    id            serial8,
    category_name varchar(50) not null,
    primary key (id)
);

create table articles
(
    id           serial8,
    category_id  int8         not null,
    author_id    int8         not null,
    title        varchar(300) not null,
    content      text         not null,
    status       boolean,
    created_date date,
    primary key (id),
    foreign key (category_id) references categories (id),
    foreign key (author_id) references users (id)
);

create table comments
(
    id           serial8,
    article_id   int8 not null,
    user_id      int8 not null,
    content      text not null,
    primary key (id),
    created_date date,
    foreign key (article_id) references articles (id),
    foreign key (user_id) references users (id)
);

insert into users(login, password, first_name, last_name)
values ('tima234', 'Temirlan#949', 'Temirlan', 'Abdraimov'),
       ('alinusha', 'asaprocky7@2', 'Alina', 'Ayapbergenova');

insert into users(login, password, first_name, last_name)
values ('eldoskld', 'aidtopgg00', 'Eldos', 'Kaldybayev');

insert into users(login, password, first_name, last_name)
values ('amina#1', 'aminaaaa999', 'Amina', 'Ashimova');

insert into categories(category_name)
values ('Sport'),
       ('Beauty');

insert into articles(category_id, author_id, title, content, status, created_date)
values (1, 1, 'Importance of Football',
        'Football is an important game from the point of view of the spectator as well as the player.',
        true, '2022-01-28'),
       (2, 2, 'The biggest 2023 beauty trends',
        'Twinkling, metallic lids, bold lip shades, barely-there brows, and layers of blush.',
        true, '2023-04-22');

insert into articles(category_id, author_id, title, content, status, created_date)
values (1, 3, 'What is cybersport?', 'In recent years, cybersport has been rising ' ||
                                     'in its popularity, but many people still wonder what is cybersport? ' ||
                                     'In short, cybersport is a competition in computer games that ' ||
                                     'has turned into a multibillion-dollar sport. Similar to traditional ' ||
                                     'sport, cybersports can be of two types - team where there are two ' ||
                                     'or more teams competing, and individual where each player plays for ' ||
                                     'himself or herself.', false, '2020-08-15');

insert into articles(category_id, author_id, title, content, status, created_date)
values (1, 3, 'Cybersports: How Gamers Become Professionals?', 'A lot depends on your reaction speed and ' ||
                                                               'how you play through the beginning of the ' ||
                                                               'game. It is also important to keep your ' ||
                                                               'team''s morale high. To hone our skills, ' ||
                                                               'we conduct team training sessions, and ' ||
                                                               'only play online. Also, one can practice ' ||
                                                               'at amateur tournaments that are held at ' ||
                                                               'special clubs.', true, '2021-01-05'),
       (2, 2, 'How to Find Your SIGNATURE SCENT', 'Step 1: Decide what you’re looking for.' ||
                                                  'Step 2: Start testing.' ||
                                                  'Step 3: Narrow it down.' ||
                                                  'Step 4: Pick the one that speaks to you.', true, '2018-05-25');



insert into comments(article_id, user_id, content, created_date)
values (1, 2, 'What a great piece of article!', '2023-05-22'),
       (2, 1, 'Good job!', '2023-07-04');

select concat(u.first_name, ' ', u.last_name) fullname, count(a.id) articles_count
from users u
         left join articles a on u.id = a.author_id
group by u.id
order by u.id;
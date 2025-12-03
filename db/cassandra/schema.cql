-- KEYSPACE
CREATE KEYSPACE IF NOT EXISTS imdb
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

USE imdb;

-- DROP TABLES (brak CASCADE w Cassandrze)
DROP TABLE IF EXISTS title_genres;
DROP TABLE IF EXISTS episodes;
DROP TABLE IF EXISTS principals;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS aka_titles;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS titles;

-- T A B L E S

CREATE TABLE titles (
    tconst          text PRIMARY KEY,
    title_type      text,
    primary_title   text,
    original_title  text,
    is_adult        boolean,
    start_year      int,
    end_year        int,
    runtime_minutes int
);

CREATE TABLE aka_titles (
    title_id          text,
    ordering          int,
    aka_title         text,
    region            text,
    language          text,
    types             text,
    attributes        text,
    is_original_title boolean,
    PRIMARY KEY (title_id, ordering)
);

CREATE TABLE ratings (
    title_id       text PRIMARY KEY,
    average_rating float,
    num_votes      int
);

CREATE TABLE people (
    nconst             text PRIMARY KEY,
    primary_name       text,
    birth_year         int,
    death_year         int,
    primary_profession text
);

CREATE TABLE principals (
    title_id   text,
    ordering   int,
    person_id  text,
    category   text,
    job        text,
    characters text,
    PRIMARY KEY (title_id, ordering)
);

CREATE TABLE episodes (
    episode_id     text,
    parent_id      text,
    season_number  int,
    episode_number int,
    PRIMARY KEY (episode_id)
);

CREATE TABLE title_genres (
    title_id text,
    genre    text,
    PRIMARY KEY (title_id, genre)
);

-- Schemat bazy IMDb dla PostgreSQL
-- 7 tabel: titles, aka_titles, ratings, people, principals, episodes, title_genres

-- Na wszelki wypadek:
DROP TABLE IF EXISTS title_genres, episodes, principals, ratings, aka_titles, people, titles CASCADE;

------------------------------------------------------------
-- 1) Tabela główna tytułów
------------------------------------------------------------

CREATE TABLE titles (
    tconst           VARCHAR(12) PRIMARY KEY,          -- np. tt0944947
    title_type       VARCHAR(32) NOT NULL,             -- movie, tvSeries, episode, ...
    primary_title    TEXT        NOT NULL,
    original_title   TEXT        NOT NULL,
    is_adult         BOOLEAN     NOT NULL,
    start_year       SMALLINT,
    end_year         SMALLINT,
    runtime_minutes  INTEGER
);

------------------------------------------------------------
-- 2) Alternatywne tytuły (aka)
------------------------------------------------------------

CREATE TABLE aka_titles (
    title_id          VARCHAR(12) NOT NULL,            -- FK -> titles.tconst
    ordering          INTEGER     NOT NULL,            -- unikalny w obrębie title_id
    aka_title         TEXT        NOT NULL,
    region            VARCHAR(8),
    language          VARCHAR(16),
    types             TEXT,
    attributes        TEXT,
    is_original_title BOOLEAN     NOT NULL,
    CONSTRAINT aka_titles_pkey PRIMARY KEY (title_id, ordering),
    CONSTRAINT aka_titles_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

------------------------------------------------------------
-- 3) Oceny tytułów
------------------------------------------------------------

CREATE TABLE ratings (
    title_id        VARCHAR(12) PRIMARY KEY,           -- FK -> titles.tconst
    average_rating  NUMERIC(3,1) NOT NULL,
    num_votes       INTEGER      NOT NULL,
    CONSTRAINT ratings_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

------------------------------------------------------------
-- 4) Osoby (aktorzy, reżyserzy, itp.)
------------------------------------------------------------

CREATE TABLE people (
    nconst              VARCHAR(12) PRIMARY KEY,       -- np. nm0000138
    primary_name        TEXT        NOT NULL,
    birth_year          SMALLINT,
    death_year          SMALLINT,
    primary_profession  TEXT                           -- CSV z IMDb (opcjonalna normalizacja)
);

------------------------------------------------------------
-- 5) Obsada / załoga (relacja tytuł–osoba)
------------------------------------------------------------

CREATE TABLE principals (
    title_id    VARCHAR(12) NOT NULL,                  -- FK -> titles.tconst
    ordering    INTEGER     NOT NULL,                  -- unikalny w obrębie tytułu
    person_id   VARCHAR(12) NOT NULL,                  -- FK -> people.nconst
    category    VARCHAR(32) NOT NULL,                  -- actor, actress, director, writer, ...
    job         TEXT,
    characters  TEXT,
    CONSTRAINT principals_pkey PRIMARY KEY (title_id, ordering),
    CONSTRAINT principals_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT principals_person_fk FOREIGN KEY (person_id)
        REFERENCES people (nconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

------------------------------------------------------------
-- 6) Odcinki (episode -> parent)
------------------------------------------------------------

CREATE TABLE episodes (
    episode_id     VARCHAR(12) PRIMARY KEY,            -- tconst epizodu
    parent_id      VARCHAR(12) NOT NULL,               -- tconst serialu / serii
    season_number  INTEGER,
    episode_number INTEGER,
    CONSTRAINT episodes_parent_fk FOREIGN KEY (parent_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT episodes_episode_fk FOREIGN KEY (episode_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

------------------------------------------------------------
-- 7) Gatunki (1 wiersz = 1 gatunek)
------------------------------------------------------------

CREATE TABLE title_genres (
    title_id  VARCHAR(12) NOT NULL,                   -- FK -> titles.tconst
    genre     VARCHAR(32) NOT NULL,
    CONSTRAINT title_genres_pkey PRIMARY KEY (title_id, genre),
    CONSTRAINT title_genres_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
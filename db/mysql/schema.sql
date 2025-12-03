DROP TABLE IF EXISTS title_genres, episodes, principals, ratings, aka_titles, people, titles;

CREATE TABLE titles (
    tconst VARCHAR(20) PRIMARY KEY,
    title_type VARCHAR(32) NOT NULL,
    primary_title TEXT NOT NULL,
    original_title TEXT NOT NULL,
    is_adult BOOL NOT NULL, -- W MySQL BOOL jest aliasem dla TINYINT(1)
    start_year SMALLINT,
    end_year SMALLINT,
    runtime_minutes INTEGER
);

CREATE TABLE aka_titles (
    title_id VARCHAR(20) NOT NULL,
    ordering INTEGER NOT NULL,
    aka_title TEXT NOT NULL,
    region VARCHAR(8),
    language VARCHAR(16),
    types TEXT,
    attributes TEXT,
    is_original_title BOOL NOT NULL,
    CONSTRAINT aka_titles_pkey PRIMARY KEY (title_id, ordering),
    CONSTRAINT aka_titles_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE ratings (
    title_id VARCHAR(20) PRIMARY KEY,
    average_rating NUMERIC(3,1) NOT NULL,
    num_votes INTEGER NOT NULL,
    CONSTRAINT ratings_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE people (
    nconst VARCHAR(20) PRIMARY KEY,
    primary_name TEXT NOT NULL,
    birth_year SMALLINT,
    death_year SMALLINT,
    primary_profession TEXT
);

CREATE TABLE principals (
    title_id VARCHAR(20) NOT NULL,
    ordering INTEGER NOT NULL,
    person_id VARCHAR(20) NOT NULL,
    category VARCHAR(32) NOT NULL,
    job TEXT,
    characters TEXT,
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

CREATE TABLE episodes (
    episode_id VARCHAR(20) PRIMARY KEY,
    parent_id VARCHAR(20) NOT NULL,
    season_number INTEGER,
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

CREATE TABLE title_genres (
    title_id VARCHAR(20) NOT NULL,
    genre VARCHAR(32) NOT NULL,
    CONSTRAINT title_genres_pkey PRIMARY KEY (title_id, genre),
    CONSTRAINT title_genres_title_fk FOREIGN KEY (title_id)
        REFERENCES titles (tconst)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
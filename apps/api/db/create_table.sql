-- Artist is a strong entity; artist_id uniquely identifies each artist.
CREATE TABLE IF NOT EXISTS Artist (
    artist_id   INTEGER         PRIMARY KEY,
    name        VARCHAR(150)    NOT NULL,
    country     VARCHAR(100),
    type        VARCHAR(50),
    image_url   TEXT
);

-- Album is a strong entity; each album must belong to one artist (1:N via artist_id).

CREATE TABLE IF NOT EXISTS Album (
    album_id        INTEGER         PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    type            VARCHAR(50),
    release_date    DATE,
    artist_id       INTEGER         NOT NULL,
    image_url       TEXT,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE NO ACTION
);

-- Song is a strong entity; each song must belong to one album (1:N via album_id).
CREATE TABLE IF NOT EXISTS Song (
    song_id         INTEGER         PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    duration        VARCHAR(10),
    album_id        INTEGER         NOT NULL,
    track_number    INTEGER,
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
        ON DELETE NO ACTION
);
 
-- User is a strong entity; each user_id uniquely identifies an app user.
CREATE TABLE IF NOT EXISTS "User" (
    user_id     INTEGER         PRIMARY KEY,
    username    VARCHAR(100)    NOT NULL,
    isAdmin     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- Credits resolves Artist<->Song M:N and stores role; composite PK prevents duplicates.
CREATE TABLE IF NOT EXISTS Credits (
    artist_id   INTEGER         NOT NULL,
    song_id     INTEGER         NOT NULL,
    role        VARCHAR(100),
    PRIMARY KEY (artist_id, song_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),
    FOREIGN KEY (song_id)   REFERENCES Song(song_id)
);

-- Review resolves User<->Song M:N and stores rating; composite PK enforces one review per pair.
CREATE TABLE IF NOT EXISTS Review (
    user_id     INTEGER         NOT NULL,
    song_id     INTEGER         NOT NULL,
    rating      INTEGER,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id)   REFERENCES "User"(user_id),
    FOREIGN KEY (song_id)   REFERENCES Song(song_id)
);
 
 
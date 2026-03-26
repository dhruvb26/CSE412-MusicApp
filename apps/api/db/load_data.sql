-- ----------------------------------------------------------------
-- Artist (strong entity)
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Artist (
    artist_id   INTEGER         PRIMARY KEY,
    name        VARCHAR(150)    NOT NULL,
    country     VARCHAR(100),
    type        VARCHAR(50)
);

-- ----------------------------------------------------------------
-- Album (strong entity + Releases merged in)
-- artist_id NOT NULL: thick arrow from Album to Releases
-- ON DELETE NO ACTION
-- ----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Album (
    album_id        INTEGER         PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    type            VARCHAR(50),
    release_date    DATE,
    artist_id       INTEGER         NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE NO ACTION
);

-- ----------------------------------------------------------------
-- Song (strong entity + Contains merged in)
-- album_id NOT NULL: thick arrow from Song to Contains
-- track_number comes from the Contains relationship
-- ON DELETE NO ACTION
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Song (
    song_id         INTEGER         PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    duration        VARCHAR(10),
    album_id        INTEGER         NOT NULL,
    track_number    INTEGER,
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
        ON DELETE NO ACTION
);
 
-- ----------------------------------------------------------------
-- User (strong entity)
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "User" (
    user_id     INTEGER         PRIMARY KEY,
    username    VARCHAR(100)    NOT NULL,
    isAdmin     BOOLEAN         NOT NULL DEFAULT FALSE
);

-- ----------------------------------------------------------------
-- Credits (M:N relationship: Artist - Song)
-- Thick line on Song side = participation constraint only (not key)
-- Still M:N so 3-table solution applies
-- PK = (artist_id, song_id), role is descriptor attribute
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Credits (
    artist_id   INTEGER         NOT NULL,
    song_id     INTEGER         NOT NULL,
    role        VARCHAR(100),
    PRIMARY KEY (artist_id, song_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),
    FOREIGN KEY (song_id)   REFERENCES Song(song_id)
);

-- ----------------------------------------------------------------
-- Review (M:N relationship: User - Song)
-- Thin lines on both sides, no arrows
-- 3-table solution: PK = (user_id, song_id), rating is descriptor
-- ----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Review (
    user_id     INTEGER         NOT NULL,
    song_id     INTEGER         NOT NULL,
    rating      INTEGER,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id)   REFERENCES "User"(user_id),
    FOREIGN KEY (song_id)   REFERENCES Song(song_id)
);
 

TRUNCATE review, credits, "User", song, album, artist RESTART IDENTITY CASCADE;

COPY artist FROM '/Users/dhruv/Desktop/one/hub/py/data/artist.csv' WITH (FORMAT csv, HEADER false);
COPY album FROM '/Users/dhruv/Desktop/one/hub/py/data/album.csv' WITH (FORMAT csv, HEADER false);
COPY song FROM '/Users/dhruv/Desktop/one/hub/py/data/song.csv' WITH (FORMAT csv, HEADER false);
COPY "User" FROM '/Users/dhruv/Desktop/one/hub/py/data/appuser.csv' WITH (FORMAT csv, HEADER false);
COPY credits FROM '/Users/dhruv/Desktop/one/hub/py/data/credits.csv' WITH (FORMAT csv, HEADER false);
COPY review FROM '/Users/dhruv/Desktop/one/hub/py/data/review.csv' WITH (FORMAT csv, HEADER false);

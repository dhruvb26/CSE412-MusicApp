TRUNCATE review, credits, "User", song, album, artist RESTART IDENTITY CASCADE;

COPY artist FROM '../data/artist.csv' WITH (FORMAT csv, HEADER false);
COPY album FROM '../data/album.csv' WITH (FORMAT csv, HEADER false);
COPY song FROM '../data/song.csv' WITH (FORMAT csv, HEADER false);
COPY "User" FROM '../data/appuser.csv' WITH (FORMAT csv, HEADER false);
COPY credits FROM '../data/credits.csv' WITH (FORMAT csv, HEADER false);
COPY review FROM '../data/review.csv' WITH (FORMAT csv, HEADER false);

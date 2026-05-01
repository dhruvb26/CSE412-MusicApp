import csv
import logging
import os
import random
import time
from logging import getLogger
from pathlib import Path

import musicbrainzngs
import spotipy
from dotenv import load_dotenv
from spotipy.oauth2 import SpotifyClientCredentials

logger = getLogger(__name__)


load_dotenv(override=True)

# Default: https://open.spotify.com/playlist/5cBwWjvGbhIwgRCoO1zShB
DEFAULT_PLAYLIST_ID = "5cBwWjvGbhIwgRCoO1zShB"


def main() -> None:
    handler = logging.StreamHandler()
    handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
    handler.addFilter(lambda record: record.levelno in (logging.INFO, logging.ERROR))
    logger.handlers.clear()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    logger.propagate = False

    client_id = os.environ.get("SPOTIFY_CLIENT_ID")
    client_secret = os.environ.get("SPOTIFY_CLIENT_SECRET")
    if not client_id or not client_secret:
        raise ValueError("Missing SPOTIFY_CLIENT_ID or SPOTIFY_CLIENT_SECRET in env")

    musicbrainzngs.set_useragent("cse412-project", "1.0", "cse412@asu.edu")

    try:
        auth = SpotifyClientCredentials(
            client_id=client_id, client_secret=client_secret
        )
        sp = spotipy.Spotify(auth_manager=auth)
    except Exception as exc:
        raise ValueError(f"Spotify auth failed: {exc}") from exc

    env_raw = (os.environ.get("SPOTIFY_PLAYLIST_ID") or "").strip()
    if env_raw.startswith("spotify:playlist:"):
        playlist_id = env_raw.split(":")[-1].split("/")[0]
    elif "open.spotify.com/playlist/" in env_raw:
        tail = env_raw.split("open.spotify.com/playlist/", 1)[1]
        playlist_id = tail.split("?")[0].split("/")[0]
    else:
        playlist_id = env_raw or DEFAULT_PLAYLIST_ID
    try:
        pl_full = sp.playlist(
            playlist_id, fields="id,name,owner.display_name,tracks.total"
        )
    except Exception as exc:
        raise RuntimeError(f"Failed to load playlist: {exc}") from exc
    playlist_id = pl_full["id"]
    pl_name = pl_full.get("name") or ""
    owner = (pl_full.get("owner") or {}).get("display_name") or "Unknown"
    total_tracks = (pl_full.get("tracks") or {}).get("total", 0)
    logger.info("Playlist: %s by %s (%s tracks)", pl_name, owner, total_tracks)

    artist_by_spotify: dict[str, dict] = {}
    album_by_spotify: dict[str, dict] = {}
    album_detail_cache: dict[str, dict] = {}
    next_artist_id = 1
    next_album_id = 1
    next_song_id = 1

    def ensure_artist(sp_artist: dict) -> int | None:
        nonlocal next_artist_id
        aid = sp_artist.get("id")
        name = sp_artist.get("name")
        if not aid or not name:
            return None
        if aid not in artist_by_spotify:
            images = sp_artist.get("images") or []
            image_url = images[0]["url"] if images else ""
            artist_by_spotify[aid] = {
                "artist_id": next_artist_id,
                "name": name,
                "country": None,
                "type": "solo",
                "image_url": image_url,
                "spotify_id": aid,
            }
            next_artist_id += 1
        return artist_by_spotify[aid]["artist_id"]

    def get_album_detail(album_id: str) -> dict | None:
        if album_id in album_detail_cache:
            return album_detail_cache[album_id]
        try:
            time.sleep(0.1)
            full = sp.album(album_id)
            album_detail_cache[album_id] = full
            return full
        except Exception:
            return None

    songs: list[dict] = []
    song_seen: set[str] = set()

    offset = 0
    page_size = 100
    while True:
        try:
            page = sp.playlist_items(
                playlist_id,
                limit=page_size,
                offset=offset,
                additional_types=("track",),
            )
        except Exception as exc:
            logger.error(
                "Failed to fetch playlist page at offset %s: %s",
                offset,
                exc,
            )
            break

        batch = page.get("items") or []
        if not batch:
            break

        for item in batch:
            track = item.get("track")
            if not track:
                continue
            tid = track.get("id")
            if not tid:
                continue

            album_obj = track.get("album")
            if not album_obj:
                continue
            album_id_sp = album_obj.get("id")
            if not album_id_sp:
                continue

            artists = track.get("artists") or []
            if not artists:
                continue

            internal_artist_ids: list[int] = []
            for a in artists:
                iid = ensure_artist(a)
                if iid is None:
                    internal_artist_ids = []
                    break
                internal_artist_ids.append(iid)
            if not internal_artist_ids:
                continue

            full_album = get_album_detail(album_id_sp)
            if not full_album:
                continue

            if album_id_sp not in album_by_spotify:
                alb_artists = full_album.get("artists") or []
                if not alb_artists:
                    continue
                primary_album_artist_id = ensure_artist(alb_artists[0])
                if primary_album_artist_id is None:
                    continue
                spotify_album_type = full_album.get("album_type")
                if spotify_album_type == "album":
                    album_type = "studio"
                elif spotify_album_type == "single":
                    album_type = "single"
                elif spotify_album_type == "compilation":
                    album_type = "compilation"
                else:
                    album_type = "other"

                release_date_raw = full_album.get("release_date")
                if not release_date_raw:
                    release_date = ""
                else:
                    release_parts = release_date_raw.split("-")
                    if len(release_parts) == 1 and len(release_parts[0]) == 4:
                        release_date = f"{release_parts[0]}-01-01"
                    elif len(release_parts) == 2:
                        y, m = release_parts[0], release_parts[1].zfill(2)
                        release_date = f"{y}-{m}-01"
                    elif len(release_parts) >= 3:
                        release_date = (
                            f"{release_parts[0]}-{release_parts[1].zfill(2)}-"
                            f"{release_parts[2].zfill(2)}"
                        )
                    else:
                        release_date = release_date_raw

                alb_images = full_album.get("images") or []
                alb_image_url = alb_images[0]["url"] if alb_images else ""

                album_by_spotify[album_id_sp] = {
                    "album_id": next_album_id,
                    "title": full_album.get("name") or "",
                    "type": album_type,
                    "release_date": release_date,
                    "artist_id": primary_album_artist_id,
                    "image_url": alb_image_url,
                }
                next_album_id += 1

            album_internal_id = album_by_spotify[album_id_sp]["album_id"]

            if tid in song_seen:
                continue
            song_seen.add(tid)

            dur_ms = track.get("duration_ms") or 0
            m, s = divmod(max(0, dur_ms) // 1000, 60)
            duration_str = f"{m:d}:{s:02d}"

            songs.append(
                {
                    "song_id": next_song_id,
                    "title": track.get("name") or "",
                    "duration": duration_str,
                    "album_id": album_internal_id,
                    "track_number": track.get("track_number") or 0,
                    "artist_ids_ordered": list(internal_artist_ids),
                }
            )
            next_song_id += 1

        offset += len(batch)
        if not page.get("next"):
            break

    spotify_ids = list(artist_by_spotify.keys())
    for i in range(0, len(spotify_ids), 50):
        batch_ids = spotify_ids[i : i + 50]
        try:
            time.sleep(0.2)
            results = sp.artists(batch_ids)
            for full_art in results.get("artists") or []:
                if not full_art:
                    continue
                sid = full_art.get("id")
                if sid and sid in artist_by_spotify:
                    images = full_art.get("images") or []
                    if images and not artist_by_spotify[sid]["image_url"]:
                        artist_by_spotify[sid]["image_url"] = images[0]["url"]
        except Exception as exc:
            logger.error("Failed to fetch artist images batch: %s", exc)

    for rec in artist_by_spotify.values():
        rec["country"] = lookup_musicbrainz_country(rec["name"])
        time.sleep(0.5)

    credits_rows: list[tuple[int, int, str]] = []
    for s in songs:
        ids = s["artist_ids_ordered"]
        for idx, aid in enumerate(ids):
            role = "vocalist" if idx == 0 else "featured vocalist"
            credits_rows.append((aid, s["song_id"], role))

    appuser_rows = [(i, f"user_{i}", i == 1) for i in range(1, 11)]

    random.seed(42)
    review_rows: list[tuple[int, int, int]] = []
    seen_pairs: set[tuple[int, int]] = set()
    for s in songs:
        n_rev = random.randint(3, 5)
        added = 0
        attempts = 0
        while added < n_rev and attempts < 1000:
            attempts += 1
            uid = random.randint(1, 10)
            pair = (uid, s["song_id"])
            if pair in seen_pairs:
                continue
            seen_pairs.add(pair)
            review_rows.append((uid, s["song_id"], random.randint(1, 5)))
            added += 1

    data_dir = Path("data")
    data_dir.mkdir(parents=True, exist_ok=True)
    data_abs = os.path.abspath(str(data_dir))
    csv_outputs = [
        (
            "artist.csv",
            [
                (
                    a["artist_id"],
                    a["name"],
                    a["country"] or "Unknown",
                    a["type"],
                    a.get("image_url") or "",
                )
                for a in sorted(
                    artist_by_spotify.values(), key=lambda x: x["artist_id"]
                )
            ],
        ),
        (
            "album.csv",
            [
                (
                    a["album_id"],
                    a["title"],
                    a["type"],
                    a["release_date"],
                    a["artist_id"],
                    a.get("image_url") or "",
                )
                for a in sorted(album_by_spotify.values(), key=lambda x: x["album_id"])
            ],
        ),
        (
            "song.csv",
            [
                (
                    s["song_id"],
                    s["title"],
                    s["duration"],
                    s["album_id"],
                    s["track_number"],
                )
                for s in songs
            ],
        ),
        (
            "appuser.csv",
            [(u, un, "true" if ia else "false") for u, un, ia in appuser_rows],
        ),
        ("credits.csv", credits_rows),
        ("review.csv", review_rows),
    ]
    for name, rows in csv_outputs:
        path = data_dir / name
        with path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f, delimiter=",", quoting=csv.QUOTE_MINIMAL)
            writer.writerows(rows)

    logger.info("artists:  %s", len(artist_by_spotify))
    logger.info("albums:   %s", len(album_by_spotify))
    logger.info("songs:    %s", len(songs))
    logger.info("credits:  %s", len(credits_rows))
    logger.info("reviews:  %s", len(review_rows))
    logger.info("csv dir:  %s", data_abs)


def lookup_musicbrainz_country(name: str) -> str:
    try:
        res = musicbrainzngs.search_artists(artist=name, limit=1)
    except Exception:
        return "Unknown"
    al = (res or {}).get("artist-list") or []
    if not al:
        return "Unknown"
    art = al[0]
    country = art.get("country")
    if country:
        return country
    area = art.get("area")
    if isinstance(area, dict) and area.get("name"):
        return area["name"]
    if isinstance(area, str):
        return area
    return "Unknown"


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        logger.error("%s", exc)
        raise SystemExit(1) from exc

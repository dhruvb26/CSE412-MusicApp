from db.connection import get_conn
from fastapi import APIRouter, HTTPException, Query

router = APIRouter(prefix="/api/artists", tags=["artists"])


@router.get("")
def list_artists(search: str = Query("", description="Search by name")):
    with get_conn() as conn:
        with conn.cursor() as cur:
            if search:
                cur.execute(
                    "SELECT artist_id, name, country, type, image_url FROM artist WHERE name ILIKE %s ORDER BY name",
                    (f"%{search}%",),
                )
            else:
                cur.execute(
                    "SELECT artist_id, name, country, type, image_url FROM artist ORDER BY name"
                )
            rows = cur.fetchall()
    return [
        {
            "artist_id": r[0],
            "name": r[1],
            "country": r[2],
            "type": r[3],
            "image_url": r[4],
        }
        for r in rows
    ]


@router.get("/{artist_id}")
def get_artist(artist_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT artist_id, name, country, type, image_url FROM artist WHERE artist_id = %s",
                (artist_id,),
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(status_code=404, detail="Artist not found")

            artist = {
                "artist_id": row[0],
                "name": row[1],
                "country": row[2],
                "type": row[3],
                "image_url": row[4],
            }

            cur.execute(
                "SELECT album_id, title, type, release_date, image_url FROM album WHERE artist_id = %s ORDER BY release_date DESC",
                (artist_id,),
            )
            albums = [
                {
                    "album_id": r[0],
                    "title": r[1],
                    "type": r[2],
                    "release_date": str(r[3]) if r[3] else None,
                    "image_url": r[4],
                }
                for r in cur.fetchall()
            ]

            cur.execute(
                """SELECT DISTINCT s.song_id, s.title, s.duration, a.title as album_title, a.image_url
                   FROM credits c
                   JOIN song s ON s.song_id = c.song_id
                   JOIN album a ON a.album_id = s.album_id
                   WHERE c.artist_id = %s
                   ORDER BY s.title""",
                (artist_id,),
            )
            songs = [
                {
                    "song_id": r[0],
                    "title": r[1],
                    "duration": r[2],
                    "album_title": r[3],
                    "image_url": r[4],
                }
                for r in cur.fetchall()
            ]

    return {**artist, "albums": albums, "songs": songs}

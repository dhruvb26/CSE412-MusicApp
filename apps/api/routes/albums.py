from db.connection import get_conn
from fastapi import APIRouter, HTTPException, Query

router = APIRouter(prefix="/api/albums", tags=["albums"])


@router.get("")
def list_albums(search: str = Query("", description="Search by title")):
    with get_conn() as conn:
        with conn.cursor() as cur:
            if search:
                cur.execute(
                    """SELECT a.album_id, a.title, a.type, a.release_date,
                              ar.name as artist_name, ar.artist_id, a.image_url
                       FROM album a JOIN artist ar ON ar.artist_id = a.artist_id
                       WHERE a.title ILIKE %s
                       ORDER BY a.title""",
                    (f"%{search}%",),
                )
            else:
                cur.execute(
                    """SELECT a.album_id, a.title, a.type, a.release_date,
                              ar.name as artist_name, ar.artist_id, a.image_url
                       FROM album a JOIN artist ar ON ar.artist_id = a.artist_id
                       ORDER BY a.title"""
                )
            rows = cur.fetchall()
    return [
        {
            "album_id": r[0],
            "title": r[1],
            "type": r[2],
            "release_date": str(r[3]) if r[3] else None,
            "artist_name": r[4],
            "artist_id": r[5],
            "image_url": r[6],
        }
        for r in rows
    ]


@router.get("/{album_id}")
def get_album(album_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """SELECT a.album_id, a.title, a.type, a.release_date,
                          ar.name as artist_name, ar.artist_id, a.image_url
                   FROM album a JOIN artist ar ON ar.artist_id = a.artist_id
                   WHERE a.album_id = %s""",
                (album_id,),
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(status_code=404, detail="Album not found")

            album = {
                "album_id": row[0],
                "title": row[1],
                "type": row[2],
                "release_date": str(row[3]) if row[3] else None,
                "artist_name": row[4],
                "artist_id": row[5],
                "image_url": row[6],
            }

            cur.execute(
                """SELECT s.song_id, s.title, s.duration, s.track_number
                   FROM song s WHERE s.album_id = %s
                   ORDER BY s.track_number""",
                (album_id,),
            )
            songs = [
                {
                    "song_id": r[0],
                    "title": r[1],
                    "duration": r[2],
                    "track_number": r[3],
                }
                for r in cur.fetchall()
            ]

    return {**album, "songs": songs}

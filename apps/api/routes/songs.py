from db.connection import get_conn
from fastapi import APIRouter, HTTPException, Query

router = APIRouter(prefix="/api/songs", tags=["songs"])


@router.get("")
def list_songs(search: str = Query("", description="Search by title")):
    with get_conn() as conn:
        with conn.cursor() as cur:
            if search:
                cur.execute(
                    """SELECT s.song_id, s.title, s.duration, s.track_number,
                              a.title as album_title, a.album_id,
                              ar.name as artist_name, ar.artist_id,
                              a.image_url
                       FROM song s
                       JOIN album a ON a.album_id = s.album_id
                       JOIN artist ar ON ar.artist_id = a.artist_id
                       WHERE s.title ILIKE %s
                       ORDER BY s.title""",
                    (f"%{search}%",),
                )
            else:
                cur.execute(
                    """SELECT s.song_id, s.title, s.duration, s.track_number,
                              a.title as album_title, a.album_id,
                              ar.name as artist_name, ar.artist_id,
                              a.image_url
                       FROM song s
                       JOIN album a ON a.album_id = s.album_id
                       JOIN artist ar ON ar.artist_id = a.artist_id
                       ORDER BY s.title"""
                )
            rows = cur.fetchall()
    return [
        {
            "song_id": r[0],
            "title": r[1],
            "duration": r[2],
            "track_number": r[3],
            "album_title": r[4],
            "album_id": r[5],
            "artist_name": r[6],
            "artist_id": r[7],
            "image_url": r[8],
        }
        for r in rows
    ]


@router.get("/{song_id}")
def get_song(song_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """SELECT s.song_id, s.title, s.duration, s.track_number,
                          a.title as album_title, a.album_id,
                          ar.name as artist_name, ar.artist_id,
                          a.image_url as album_image_url, ar.image_url as artist_image_url
                   FROM song s
                   JOIN album a ON a.album_id = s.album_id
                   JOIN artist ar ON ar.artist_id = a.artist_id
                   WHERE s.song_id = %s""",
                (song_id,),
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(status_code=404, detail="Song not found")

            song = {
                "song_id": row[0],
                "title": row[1],
                "duration": row[2],
                "track_number": row[3],
                "album_title": row[4],
                "album_id": row[5],
                "artist_name": row[6],
                "artist_id": row[7],
                "image_url": row[8],
                "artist_image_url": row[9],
            }

            cur.execute(
                """SELECT ar.artist_id, ar.name, c.role, ar.image_url
                   FROM credits c JOIN artist ar ON ar.artist_id = c.artist_id
                   WHERE c.song_id = %s
                   ORDER BY c.role, ar.name""",
                (song_id,),
            )
            credits = [
                {"artist_id": r[0], "name": r[1], "role": r[2], "image_url": r[3]}
                for r in cur.fetchall()
            ]

            cur.execute(
                """SELECT r.user_id, u.username, r.rating
                   FROM review r JOIN "User" u ON u.user_id = r.user_id
                   WHERE r.song_id = %s
                   ORDER BY u.username""",
                (song_id,),
            )
            reviews = [
                {"user_id": r[0], "username": r[1], "rating": r[2]}
                for r in cur.fetchall()
            ]

            cur.execute(
                "SELECT COALESCE(AVG(rating)::numeric(3,2), 0) FROM review WHERE song_id = %s",
                (song_id,),
            )
            avg_rating = float(cur.fetchone()[0])

    return {**song, "credits": credits, "reviews": reviews, "avg_rating": avg_rating}

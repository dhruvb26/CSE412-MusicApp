from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from db.connection import get_conn

router = APIRouter(prefix="/api/users", tags=["users"])


class CreateUserBody(BaseModel):
    username: str


@router.get("")
def list_users():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                'SELECT user_id, username, isAdmin FROM "User" ORDER BY user_id'
            )
            rows = cur.fetchall()
    return [
        {"user_id": r[0], "username": r[1], "is_admin": r[2]} for r in rows
    ]

@router.get("/{user_id}")
def list_users(user_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT username FROM \"User\" WHERE user_id = %s", (user_id,))
            row = cur.fetchall()
            if not row:
                raise HTTPException(status_code=404, detail="Song not found")
            user = {"username": row[0], "user_id": user_id}
            cur.execute(
                """SELECT r.song_id, s.title, r.rating, r.comment
                   FROM review r JOIN Song s ON s.song_id = r.song_id
                   WHERE r.user_id = %s
                   ORDER BY s.title""",
                (user_id,),
            )
            reviews = [
                {"song_id": r[0], "title": r[1], "rating": r[2], "comment": r[3]}
                for r in cur.fetchall()
            ]
    return {**user, "reviews": reviews}


@router.post("")
def create_user(body: CreateUserBody):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute('SELECT COALESCE(MAX(user_id), 0) + 1 FROM "User"')
            new_id = cur.fetchone()[0]
            cur.execute(
                'INSERT INTO "User" (user_id, username, isAdmin) VALUES (%s, %s, false) RETURNING user_id, username, isAdmin',
                (new_id, body.username),
            )
            row = cur.fetchone()
            conn.commit()
    return {"user_id": row[0], "username": row[1], "is_admin": row[2]}


@router.delete("/{user_id}")
def delete_user(user_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("DELETE FROM review WHERE user_id = %s", (user_id,))
            cur.execute(
                'DELETE FROM "User" WHERE user_id = %s RETURNING user_id', (user_id,)
            )
            row = cur.fetchone()
            if not row:
                raise HTTPException(status_code=404, detail="User not found")
            conn.commit()
    return {"deleted": True, "user_id": user_id}

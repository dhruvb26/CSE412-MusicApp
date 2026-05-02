from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from db.connection import get_conn

router = APIRouter(prefix="/api/reviews", tags=["reviews"])


class CreateReviewBody(BaseModel):
    user_id: int
    song_id: int
    rating: int
    comments: str


class UpdateReviewBody(BaseModel):
    user_id: int
    song_id: int
    rating: int
    comments: str


@router.post("")
def create_review(body: CreateReviewBody):
    if body.rating < 1 or body.rating > 5:
        raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT 1 FROM review WHERE user_id = %s AND song_id = %s",
                (body.user_id, body.song_id),
            )
            if cur.fetchone():
                raise HTTPException(
                    status_code=409, detail="Review already exists for this user/song"
                )
            cur.execute(
                "INSERT INTO review (user_id, song_id, rating, comment) VALUES (%s, %s, %s,%s)",
                (body.user_id, body.song_id, body.rating, body.comments),
            )
            conn.commit()
    return {"user_id": body.user_id, "song_id": body.song_id, "rating": body.rating, "comment": body.comments}


@router.put("")
def update_review(body: UpdateReviewBody):
    if body.rating < 1 or body.rating > 5:
        raise HTTPException(status_code=400, detail="Rating must be between 1 and 5")
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE review SET rating = %s WHERE user_id = %s AND song_id = %s RETURNING user_id",
                (body.rating, body.user_id, body.song_id),
            )
            cur.execute(
                "UPDATE review SET comment = %s WHERE user_id = %s AND song_id = %s RETURNING user_id",
                (body.comments, body.user_id, body.song_id),
            )
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Review not found")
            conn.commit()
    return {"user_id": body.user_id, "song_id": body.song_id, "rating": body.rating, "comment": body.comments}


@router.delete("/{user_id}/{song_id}")
def delete_review(user_id: int, song_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "DELETE FROM review WHERE user_id = %s AND song_id = %s RETURNING user_id",
                (user_id, song_id),
            )
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Review not found")
            conn.commit()
    return {"deleted": True, "user_id": user_id, "song_id": song_id}

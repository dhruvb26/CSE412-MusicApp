from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes.albums import router as albums_router
from routes.artists import router as artists_router
from routes.reviews import router as reviews_router
from routes.songs import router as songs_router
from routes.users import router as users_router

app = FastAPI(title="Music Database API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(artists_router)
app.include_router(albums_router)
app.include_router(songs_router)
app.include_router(users_router)
app.include_router(reviews_router)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/")
def root() -> dict[str, str]:
    return {"message": "Music Database API"}

"use client";

import { Pencil, Trash2 } from "lucide-react";
import Image from "next/image";
import { useEffect, useState } from "react";
import { ThemeToggle } from "@/components/theme-toggle";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  type Album,
  type AlbumDetail,
  type Artist,
  type ArtistDetail,
  addReview,
  addUser,
  deleteReview,
  deleteUser,
  getAlbum,
  getAlbums,
  getArtist,
  getArtists,
  getSong,
  getSongs,
  getUser,
  getUsers,
  makeChange,
  type ReviewDetail,
  type Song,
  type SongDetail,
  type User,
  type UserDetail,
} from "@/lib/api";
import { cn } from "@/lib/utils";

type View = "albums" | "artists" | "songs" | "users";

function titleCase(s: string) {
  return s.replace(/_/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}
type Panel =
  | { kind: "album"; data: AlbumDetail }
  | { kind: "artist"; data: ArtistDetail }
  | { kind: "song"; data: SongDetail }
  | { kind: "user"; data: UserDetail }
  | { kind: "addUser" }
  | { kind: "editReview"; data: ReviewDetail }
  | { kind: "addReview"; data: number };

export default function Home() {
  const [view, setView] = useState<View>("albums");
  const [search, setSearch] = useState("");
  const [albums, setAlbums] = useState<Album[]>([]);
  const [artists, setArtists] = useState<Artist[]>([]);
  const [songs, setSongs] = useState<Song[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [panel, setPanel] = useState<Panel | null>(null);
  const [newUsername, setNewUsername] = useState("");
  const [selected, setSelected] = useState(1);
  const [comments, setComments] = useState("");

  useEffect(() => {
    if (view === "albums") getAlbums(search).then(setAlbums);
    else if (view === "artists") getArtists(search).then(setArtists);
    else if (view === "users") getUsers(search).then(setUsers);
    else getSongs(search).then(setSongs);
  }, [view, search]);

  useEffect(() => {
    getAlbums().then(setAlbums);
    getArtists().then(setArtists);
    getSongs().then(setSongs);
    getUsers().then(setUsers);
  }, []);

  async function openAlbum(id: number) {
    setPanel({ kind: "album", data: await getAlbum(id) });
  }
  async function openArtist(id: number) {
    setPanel({ kind: "artist", data: await getArtist(id) });
  }
  async function openSong(id: number) {
    setPanel({ kind: "song", data: await getSong(id) });
  }
  async function openUser(id: number) {
    setPanel({ kind: "user", data: await getUser(id) });
  }
  async function openAdd() {
    setPanel({ kind: "addUser" });
  }
  async function deletingUser(id: number) {
    await deleteUser(id);
    setPanel(null);
    getUsers().then(setUsers);
  }
  async function addingUser() {
    await addUser(newUsername);
    setPanel(null);
    setNewUsername("");
    getUsers().then(setUsers);
  }
  async function openEdit(x: ReviewDetail) {
    setSelected(x.rating);
    setPanel({ kind: "editReview", data: x });
  }
  async function saveChange(user: number, song: number) {
    await makeChange(selected, user, song, comments);
    setPanel(null);
    setSelected(1);
    setComments("");
  }
  async function deletingReview(song_id: number, user_id: number) {
    await deleteReview(user_id, song_id);
    setPanel(null);
  }
  async function openReviewAdd(user: number) {
    setPanel({ kind: "addReview", data: user });
  }
  async function addingReview(user: number) {
    const results = await getSongs(newUsername);
    if (!results.length) {
      setNewUsername("No songs available");
      return;
    }
    await addReview(user, results[0]?.song_id, selected, comments);
    setPanel(null);
    setSelected(1);
    setNewUsername("");
    setComments("");
  }
  return (
    <div className="h-full flex flex-col">
      <nav className="shrink-0 border-b-2 border-border/40 bg-background/95 backdrop-blur supports-backdrop-filter:bg-background/60">
        <div className="mx-auto px-3 sm:px-6 h-14 flex items-center gap-2 sm:gap-4">
          <div className="flex items-center gap-2 shrink-0">
            <h1 className="text-sm sm:text-base md:text-lg font-medium tracking-tight whitespace-nowrap">
              MusicApp
            </h1>
            <span className="text-muted-foreground hidden lg:inline whitespace-nowrap">
              by Dhruv Bansal, Marlow Odeh, & Austin Kearsley
            </span>
          </div>
          <div className="flex gap-0.5 sm:gap-1 mx-auto shrink-0">
            {(["albums", "artists", "songs", "users"] as const).map((v) => (
              <Button
                key={v}
                variant="ghost"
                size="sm"
                onClick={() => {
                  setView(v);
                  setSearch("");
                }}
                className={cn(
                  "capitalize sm:text-sm text-xs px-2 sm:px-3",
                  view === v
                    ? "text-foreground bg-muted"
                    : "text-muted-foreground/60",
                )}
              >
                {v}
              </Button>
            ))}
          </div>
          <div className="flex items-center gap-2 shrink-0">
            <Input
              placeholder="Search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-28 sm:w-44 h-8 text-xs"
            />
            <ThemeToggle />
          </div>
        </div>
      </nav>

      <div className="flex flex-1 min-h-0 relative">
        {panel && (
          <button
            type="button"
            className="fixed inset-0 z-10 bg-black/40 md:hidden"
            onClick={() => setPanel(null)}
            aria-label="Close panel"
          />
        )}
        <div
          className={cn(
            "shrink-0 overflow-y-auto border-r-2 border-border/40 transition-all bg-background",
            panel
              ? "w-72 sm:w-80 p-3 sm:p-4 absolute inset-y-0 left-0 z-20 md:relative"
              : "w-0 border-r-0 p-0",
          )}
        >
          {panel && (
            <div className="space-y-4">
              {panel.kind === "addUser" && (
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <h2 className="font-medium text-base">Create New User</h2>
                  </div>
                  <Input
                    placeholder="Enter username"
                    value={newUsername}
                    onChange={(e) => setNewUsername(e.target.value)}
                  />
                  <Button size="sm" onClick={() => addingUser()}>
                    Add User
                  </Button>
                </div>
              )}
              {panel.kind === "addReview" && (
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <h2 className="font-medium text-base">Create New Review</h2>
                  </div>
                  <Input
                    placeholder="Search for a song"
                    value={newUsername}
                    onChange={(e) => setNewUsername(e.target.value)}
                  />
                  <Input
                    placeholder="Enter comment"
                    value={comments}
                    onChange={(e) => setComments(e.target.value)}
                  />
                  <div>
                    <p className="text-xs font-medium text-muted-foreground mb-1.5">
                      Rating
                    </p>
                    <div className="flex gap-1">
                      {[1, 2, 3, 4, 5].map((n) => (
                        <Button
                          key={n}
                          variant={selected >= n ? "default" : "outline"}
                          size="sm"
                          className="w-8 h-8 p-0"
                          onClick={() => setSelected(n)}
                        >
                          {n}
                        </Button>
                      ))}
                    </div>
                  </div>
                  <Button size="sm" onClick={() => addingReview(panel.data)}>
                    Add Review
                  </Button>
                </div>
              )}
              {panel.kind === "editReview" && (
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <h2 className="font-medium text-base">Edit Review</h2>
                  </div>
                  <Input
                    placeholder="Enter comment"
                    value={comments}
                    onChange={(e) => setComments(e.target.value)}
                  />
                  <div>
                    <p className="text-xs font-medium text-muted-foreground mb-1.5">
                      Rating
                    </p>
                    <div className="flex gap-1">
                      {[1, 2, 3, 4, 5].map((n) => (
                        <Button
                          key={n}
                          variant={selected >= n ? "default" : "outline"}
                          size="sm"
                          className="w-8 h-8 p-0"
                          onClick={() => setSelected(n)}
                        >
                          {n}
                        </Button>
                      ))}
                    </div>
                  </div>
                  <Button
                    size="sm"
                    onClick={() =>
                      saveChange(panel.data.user_id, panel.data.song_id)
                    }
                  >
                    Save Change
                  </Button>
                </div>
              )}

              {panel.kind === "album" && (
                <>
                  {panel.data.image_url && (
                    <Image
                      src={panel.data.image_url}
                      alt={panel.data.title}
                      width={280}
                      height={280}
                      className="w-full aspect-square object-cover"
                    />
                  )}
                  <div>
                    <div className="flex items-center gap-2">
                      <h2 className="font-medium text-base">
                        {panel.data.title}
                      </h2>
                      <Badge variant="outline">{panel.data.type}</Badge>
                    </div>
                    <div className="flex items-center gap-1 text-sm text-muted-foreground">
                      <Button
                        variant="link"
                        size="sm"
                        className="h-auto p-0 text-muted-foreground"
                        onClick={() =>
                          openArtist(panel.data.artist_id as number)
                        }
                      >
                        {panel.data.artist_name}
                      </Button>
                      {panel.data.release_date && (
                        <span>· {panel.data.release_date.slice(0, 4)}</span>
                      )}
                    </div>
                  </div>
                  <div className="space-y-0.5">
                    {panel.data.songs.map((s) => (
                      <Button
                        key={s.song_id}
                        variant="ghost"
                        size="sm"
                        className="flex items-center gap-3 w-full justify-start h-auto py-1.5 px-2 font-normal"
                        onClick={() => openSong(s.song_id)}
                      >
                        <span className="w-5 text-right text-xs text-muted-foreground tabular-nums">
                          {s.track_number}
                        </span>
                        <span className="flex-1 text-sm truncate text-left">
                          {s.title}
                        </span>
                        <span className="text-xs text-muted-foreground tabular-nums">
                          {s.duration}
                        </span>
                      </Button>
                    ))}
                  </div>
                </>
              )}
              {panel.kind === "user" && (
                <>
                  <div>
                    <div className="flex items-center gap-2">
                      <h2 className="font-medium text-base">
                        {panel.data.username
                          ? titleCase(panel.data.username)
                          : ""}
                      </h2>
                    </div>
                    <div className="flex gap-2 mt-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => openReviewAdd(panel.data.user_id)}
                      >
                        New Review
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        className="text-red-400 border-red-400/30 hover:bg-red-400/10 hover:text-red-400"
                        onClick={() => deletingUser(panel.data.user_id)}
                      >
                        Delete User
                      </Button>
                    </div>
                  </div>

                  {panel.data.reviews.length > 0 && (
                    <div>
                      <div className="space-y-1">
                        {panel.data.reviews.map((r) => {
                          const displayName = titleCase(r.title);
                          return (
                            <div
                              key={r.song_id}
                              className="px-2 py-2 rounded-md hover:bg-muted/50"
                            >
                              <div className="flex items-center justify-between">
                                <p className="text-sm font-medium truncate flex-1">
                                  {displayName}
                                </p>
                                <div className="flex items-center gap-2 ml-2 shrink-0">
                                  <span className="flex gap-0.5">
                                    {[1, 2, 3, 4, 5].map((n) => (
                                      <span
                                        key={n}
                                        className={cn(
                                          "text-[10px]",
                                          n <= r.rating
                                            ? "text-foreground"
                                            : "text-muted-foreground/30",
                                        )}
                                      >
                                        ●
                                      </span>
                                    ))}
                                  </span>
                                  <Button
                                    variant="ghost"
                                    size="sm"
                                    className="h-6 w-6 p-0 text-muted-foreground"
                                    onClick={() =>
                                      openEdit({
                                        song_id: r.song_id,
                                        user_id: panel.data.user_id,
                                        rating: r.rating,
                                      })
                                    }
                                  >
                                    <Pencil className="w-3 h-3" />
                                  </Button>
                                  <Button
                                    variant="ghost"
                                    size="sm"
                                    className="h-6 w-6 p-0 text-red-400 hover:text-red-400 hover:bg-red-400/10"
                                    onClick={() =>
                                      deletingReview(
                                        r.song_id,
                                        panel.data.user_id,
                                      )
                                    }
                                  >
                                    <Trash2 className="w-3 h-3" />
                                  </Button>
                                </div>
                              </div>
                              {r.comment && (
                                <p className="text-xs text-muted-foreground mt-0.5 line-clamp-2">
                                  {r.comment}
                                </p>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  )}
                </>
              )}

              {panel.kind === "artist" && (
                <>
                  {panel.data.image_url && (
                    <Image
                      src={panel.data.image_url}
                      alt={panel.data.name}
                      width={280}
                      height={280}
                      className="w-full aspect-square object-cover"
                    />
                  )}
                  <div>
                    <div className="flex items-center gap-2">
                      <h2 className="font-medium text-base">
                        {panel.data.name}
                      </h2>
                      <Badge variant="outline">{panel.data.type}</Badge>
                      <Badge variant="outline">{panel.data.country}</Badge>
                    </div>
                  </div>

                  {panel.data.albums.length > 0 && (
                    <div>
                      <p className="text-xs font-medium text-muted-foreground mb-2">
                        Albums
                      </p>
                      <div className="space-y-1">
                        {panel.data.albums.map((a) => (
                          <Button
                            key={a.album_id}
                            variant="ghost"
                            size="sm"
                            className="flex items-center gap-3 w-full justify-start h-auto p-1 font-normal"
                            onClick={() => openAlbum(a.album_id)}
                          >
                            {a.image_url && (
                              <Image
                                src={a.image_url}
                                alt={a.title}
                                width={40}
                                height={40}
                                className="aspect-square object-cover"
                              />
                            )}
                            <div className="min-w-0 text-left">
                              <p className="text-sm truncate">{a.title}</p>
                              <p className="text-xs text-muted-foreground">
                                {a.release_date?.slice(0, 4)}
                              </p>
                            </div>
                          </Button>
                        ))}
                      </div>
                    </div>
                  )}

                  {panel.data.songs.length > 0 && (
                    <div>
                      <p className="text-xs font-medium text-muted-foreground mb-2">
                        Songs
                      </p>
                      <div className="space-y-0.5">
                        {panel.data.songs.map((s) => (
                          <Button
                            key={s.song_id}
                            variant="ghost"
                            size="sm"
                            className="flex items-center gap-3 w-full justify-start h-auto py-1.5 px-2 font-normal"
                            onClick={() => openSong(s.song_id)}
                          >
                            <span className="flex-1 text-sm truncate text-left">
                              {s.title}
                            </span>
                            <span className="text-xs text-muted-foreground tabular-nums">
                              {s.duration}
                            </span>
                          </Button>
                        ))}
                      </div>
                    </div>
                  )}
                </>
              )}

              {panel.kind === "song" && (
                <>
                  {panel.data.image_url && (
                    <Image
                      src={panel.data.image_url}
                      alt={panel.data.title}
                      width={280}
                      height={280}
                      className="w-full aspect-square object-cover"
                    />
                  )}
                  <div>
                    <div className="flex items-center gap-2">
                      <h2 className="font-medium text-base">
                        {panel.data.title}
                      </h2>
                      <span className="flex items-center gap-1 text-sm text-yellow-500 font-medium">
                        <svg
                          viewBox="0 0 24 24"
                          fill="currentColor"
                          className="w-3.5 h-3.5"
                          role="img"
                          aria-label="Star rating"
                        >
                          <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                        </svg>
                        {panel.data.avg_rating.toFixed(1)}
                      </span>
                    </div>
                    <Button
                      variant="link"
                      size="sm"
                      className="h-auto p-0 text-muted-foreground"
                      onClick={() => openArtist(panel.data.artist_id)}
                    >
                      {panel.data.artist_name}
                    </Button>
                    <Button
                      variant="link"
                      size="sm"
                      className="h-auto p-0 text-muted-foreground block"
                      onClick={() => openAlbum(panel.data.album_id)}
                    >
                      {panel.data.album_title}
                    </Button>
                    <div className="mt-3 space-y-1">
                      <div className="h-1 rounded-full bg-muted overflow-hidden">
                        <div className="h-full w-0 rounded-full bg-foreground" />
                      </div>
                      <div className="flex justify-between text-xs text-muted-foreground tabular-nums">
                        <span>0:00</span>
                        <span>{panel.data.duration}</span>
                      </div>
                    </div>
                  </div>

                  {panel.data.credits.length > 0 && (
                    <div>
                      <p className="text-xs font-medium text-muted-foreground mb-2">
                        Credits
                      </p>
                      <div className="space-y-1">
                        {panel.data.credits.map((c) => (
                          <Button
                            key={`${c.artist_id}-${c.role}`}
                            variant="ghost"
                            size="sm"
                            className="flex items-center justify-between w-full h-auto py-1 px-2 font-normal"
                            onClick={() => openArtist(c.artist_id)}
                          >
                            <span className="truncate text-sm">{c.name}</span>
                            <Badge variant="outline">{c.role}</Badge>
                          </Button>
                        ))}
                      </div>
                    </div>
                  )}

                  {panel.data.reviews.length > 0 && (
                    <div>
                      <p className="text-xs font-medium text-muted-foreground mb-2">
                        Reviews
                      </p>
                      <div className="space-y-2">
                        {panel.data.reviews.map((r) => {
                          const displayName = titleCase(r.username);
                          return (
                            <div
                              key={r.user_id}
                              className="flex items-center gap-2 px-2 py-1.5 rounded-md hover:bg-muted/50"
                            >
                              <div className="w-6 h-6 rounded-full shrink-0 bg-foreground" />
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-medium truncate">
                                  {displayName}
                                </p>
                                <span className="flex gap-0.5">
                                  {[1, 2, 3, 4, 5].map((n) => (
                                    <span
                                      key={n}
                                      className={cn(
                                        "text-[10px]",
                                        n <= r.rating
                                          ? "text-foreground"
                                          : "text-muted-foreground/30",
                                      )}
                                    >
                                      ●
                                    </span>
                                  ))}
                                </span>
                                {r.comment && (
                                  <p className="text-xs text-muted-foreground mt-1 line-clamp-2">
                                    {r.comment}
                                  </p>
                                )}
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  )}
                </>
              )}
            </div>
          )}
        </div>

        <div className="flex-1 min-w-0 overflow-y-auto p-3 sm:p-6">
          <div
            className={cn(
              "grid gap-3 sm:gap-4 max-w-[1400px] mx-auto",
              panel
                ? "grid-cols-1 xs:grid-cols-2 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4"
                : "grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6",
            )}
          >
            {view === "albums" &&
              albums.map((album) => (
                <button
                  key={album.album_id}
                  type="button"
                  className="group relative cursor-pointer text-left overflow-hidden"
                  onClick={() => openAlbum(album.album_id)}
                >
                  {album.image_url ? (
                    <Image
                      src={album.image_url}
                      alt={album.title}
                      width={300}
                      height={300}
                      sizes="(max-width: 640px) 50vw, (max-width: 768px) 33vw, (max-width: 1024px) 25vw, 20vw"
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2 sm:p-3">
                    <p className="text-white font-medium text-xs sm:text-sm truncate">
                      {album.title}
                    </p>
                    <p className="text-white/70 text-[10px] sm:text-xs truncate">
                      {album.artist_name}
                    </p>
                  </div>
                </button>
              ))}

            {view === "artists" &&
              artists.map((artist) => (
                <button
                  key={artist.artist_id}
                  type="button"
                  className="group relative cursor-pointer text-left overflow-hidden"
                  onClick={() => openArtist(artist.artist_id)}
                >
                  {artist.image_url ? (
                    <Image
                      src={artist.image_url}
                      alt={artist.name}
                      width={300}
                      height={300}
                      sizes="(max-width: 640px) 50vw, (max-width: 768px) 33vw, (max-width: 1024px) 25vw, 20vw"
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2 sm:p-3">
                    <p className="text-white font-medium text-xs sm:text-sm truncate">
                      {artist.name}
                    </p>
                    <p className="text-white/70 text-[10px] sm:text-xs truncate">
                      {artist.country}
                    </p>
                  </div>
                </button>
              ))}

            {view === "songs" &&
              songs.map((song) => (
                <button
                  key={song.song_id}
                  type="button"
                  className="group relative cursor-pointer text-left overflow-hidden"
                  onClick={() => openSong(song.song_id)}
                >
                  {song.image_url ? (
                    <Image
                      src={song.image_url}
                      alt={song.title}
                      width={300}
                      height={300}
                      sizes="(max-width: 640px) 50vw, (max-width: 768px) 33vw, (max-width: 1024px) 25vw, 20vw"
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2 sm:p-3">
                    <p className="text-white font-medium text-xs sm:text-sm truncate">
                      {song.title}
                    </p>
                    <p className="text-white/70 text-[10px] sm:text-xs truncate">
                      {song.artist_name}
                    </p>
                  </div>
                </button>
              ))}
            {view === "users" && (
              <>
                <div className="col-span-full flex justify-end">
                  <Button variant="outline" size="sm" onClick={() => openAdd()}>
                    New User
                  </Button>
                </div>
                {users.map((user) => (
                  <button
                    key={user.user_id}
                    type="button"
                    className="group relative cursor-pointer text-left rounded-md border border-muted bg-muted/30 p-4 hover:bg-muted/60 transition-colors"
                    onClick={() => openUser(user.user_id)}
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-foreground shrink-0" />
                      <div className="min-w-0">
                        <p className="text-sm font-medium truncate">
                          {titleCase(user.username)}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {user.isadmin ? "Admin" : "User"}
                        </p>
                      </div>
                    </div>
                  </button>
                ))}
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

"use client";

import Image from "next/image";
import { useEffect, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  type Album,
  type AlbumDetail,
  type Artist,
  type ArtistDetail,
  getAlbum,
  getAlbums,
  getArtist,
  getArtists,
  getSong,
  getSongs,
  type Song,
  type SongDetail,
} from "@/lib/api";
import { cn } from "@/lib/utils";

type View = "albums" | "artists" | "songs";
type Panel =
  | { kind: "album"; data: AlbumDetail }
  | { kind: "artist"; data: ArtistDetail }
  | { kind: "song"; data: SongDetail };

export default function Home() {
  const [view, setView] = useState<View>("albums");
  const [search, setSearch] = useState("");
  const [albums, setAlbums] = useState<Album[]>([]);
  const [artists, setArtists] = useState<Artist[]>([]);
  const [songs, setSongs] = useState<Song[]>([]);
  const [panel, setPanel] = useState<Panel | null>(null);

  useEffect(() => {
    if (view === "albums") getAlbums(search).then(setAlbums);
    else if (view === "artists") getArtists(search).then(setArtists);
    else getSongs(search).then(setSongs);
  }, [view, search]);

  useEffect(() => {
    getAlbums().then(setAlbums);
    getArtists().then(setArtists);
    getSongs().then(setSongs);
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

  return (
    <div className="h-full flex flex-col">
      <div className="flex gap-6 flex-1 min-h-0">
        <div
          className={cn(
            "shrink-0 overflow-y-auto border-r pr-4 transition-all",
            panel ? "w-80" : "w-0 border-r-0 pr-0",
          )}
        >
          {panel && (
            <div className="space-y-4">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setPanel(null)}
              >
                Close
              </Button>

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
                      <h2 className="font-bold text-lg">{panel.data.title}</h2>
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
                      <h2 className="font-bold text-lg">{panel.data.name}</h2>
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
                    <h2 className="font-bold text-lg">{panel.data.title}</h2>
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
                          const displayName = r.username
                            .replace(/_/g, " ")
                            .replace(/\b\w/g, (c) => c.toUpperCase());
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

        <div className="flex-1 min-w-0 overflow-y-auto space-y-4">
          <div className="flex items-center justify-between sticky top-0 bg-background z-10 pb-2 px-2">
            <div className="flex gap-4 text-sm">
              {(["albums", "artists", "songs"] as const).map((v) => (
                <Button
                  key={v}
                  variant="ghost"
                  size="sm"
                  onClick={() => {
                    setView(v);
                    setSearch("");
                  }}
                  className={cn(
                    "capitalize",
                    view === v ? "text-foreground" : "text-muted-foreground/60",
                  )}
                >
                  {v}
                </Button>
              ))}
            </div>
            <Input
              placeholder="Search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-48"
            />
          </div>

          <div
            className={cn(
              "grid gap-4",
              panel
                ? "grid-cols-2 sm:grid-cols-3 md:grid-cols-3 lg:grid-cols-4"
                : "grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5",
            )}
          >
            {view === "albums" &&
              albums.map((album) => (
                <button
                  key={album.album_id}
                  type="button"
                  className="group relative cursor-pointer text-left"
                  onClick={() => openAlbum(album.album_id)}
                >
                  {album.image_url ? (
                    <Image
                      src={album.image_url}
                      alt={album.title}
                      width={300}
                      height={300}
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-3">
                    <p className="text-white font-semibold text-sm truncate">
                      {album.title}
                    </p>
                    <p className="text-white/70 text-xs truncate">
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
                  className="group relative cursor-pointer text-left"
                  onClick={() => openArtist(artist.artist_id)}
                >
                  {artist.image_url ? (
                    <Image
                      src={artist.image_url}
                      alt={artist.name}
                      width={300}
                      height={300}
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-3">
                    <p className="text-white font-semibold text-sm truncate">
                      {artist.name}
                    </p>
                    <p className="text-white/70 text-xs truncate">
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
                  className="group relative cursor-pointer text-left"
                  onClick={() => openSong(song.song_id)}
                >
                  {song.image_url ? (
                    <Image
                      src={song.image_url}
                      alt={song.title}
                      width={300}
                      height={300}
                      priority
                      className="w-full aspect-square object-cover"
                    />
                  ) : (
                    <div className="w-full aspect-square bg-muted" />
                  )}
                  <div className="absolute inset-0 bg-black/60 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-3">
                    <p className="text-white font-semibold text-sm truncate">
                      {song.title}
                    </p>
                    <p className="text-white/70 text-xs truncate">
                      {song.artist_name}
                    </p>
                  </div>
                </button>
              ))}
          </div>
        </div>
      </div>
    </div>
  );
}

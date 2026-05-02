import axios from "axios";

const api = axios.create({
  baseURL: "http://localhost:8000/api",
});

export interface Artist {
  artist_id: number;
  name: string;
  country: string;
  type: string;
  image_url: string | null;
}

export interface ArtistDetail extends Artist {
  albums: (Album & { image_url: string | null })[];
  songs: {
    song_id: number;
    title: string;
    duration: string;
    album_title: string;
    image_url: string | null;
  }[];
}

export interface Album {
  album_id: number;
  title: string;
  type: string;
  release_date: string | null;
  artist_name?: string;
  artist_id?: number;
  image_url?: string | null;
}

export interface AlbumDetail extends Album {
  artist_name: string;
  artist_id: number;
  image_url: string | null;
  songs: {
    song_id: number;
    title: string;
    duration: string;
    track_number: number;
  }[];
}

export interface Song {
  song_id: number;
  title: string;
  duration: string;
  track_number: number;
  album_title: string;
  album_id: number;
  artist_name: string;
  artist_id: number;
  image_url: string | null;
}

export interface SongDetail extends Song {
  artist_image_url: string | null;
  credits: {
    artist_id: number;
    name: string;
    role: string;
    image_url: string | null;
  }[];
  reviews: {
	  user_id: number;
	  username: string;
	  rating: number;
	  comment?: string | null;
	}[];
  avg_rating: number;
}

export interface User {
  user_id: number;
  username: string;
  isadmin: boolean;
}

export interface UserDetail extends User {
  username: string | null;
  user_id: number;
  reviews: { song_id: number; title: string; rating: number; comment?: string | null;}[];
}

export interface ReviewDetail {
  song_id: number;
  user_id: number;
  rating: number;
}

export async function getArtists(search = "") {
  const { data } = await api.get<Artist[]>("/artists", { params: { search } });
  return data;
}

export async function getArtist(id: number) {
  const { data } = await api.get<ArtistDetail>(`/artists/${id}`);
  return data;
}

export async function getAlbums(search = "") {
  const { data } = await api.get<Album[]>("/albums", { params: { search } });
  return data;
}

export async function getAlbum(id: number) {
  const { data } = await api.get<AlbumDetail>(`/albums/${id}`);
  return data;
}

export async function getSongs(search = "") {
  const { data } = await api.get<Song[]>("/songs", { params: { search } });
  return data;
}

export async function getSong(id: number) {
  const { data } = await api.get<SongDetail>(`/songs/${id}`);
  return data;
}

export async function getUsers(search = "") {
  const { data } = await api.get<Users[]>("/users", { params: { search } });
  return data;
}

export async function getUser(id: number) {
  const { data } = await api.get<UserDetail>(`/users/${id}`);
  return data;
}

export async function deleteUser(id: number) {
  const { data } = await api.delete<>(`/users/${id}`);
  return data;
}

export async function addUser(username: string) {
  const { data } = await api.post<>(`/users`, {
    username
  });
  return data;
}

export async function makeChange(rating: number, user: number, song: number, comment: string) {
  const { data } = await api.put<>(`/reviews`, {
    user_id: user,
    song_id: song,
    rating: rating,
    comments: comment,
  });
  return data;
}

export async function deleteReview(user: number, song: number) {
  const { data } = await api.delete<>(`/reviews/${user}/${song}`);
  return data;
}
export async function addReview(user: number, song: number, rating: number, comment: string) {
  const { data } = await api.post<>(`/reviews`, {
    user_id: user,
    song_id: song,
    rating: rating,
    comments: comment,
  });
  return data;
}


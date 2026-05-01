# CSE 412 Music Database App

**Team 24** — Dhruv Bansal, Marlow Odeh, & Austin Kearsley

A music information database that lets users browse artists, albums, songs, credits, and reviews. Built with Next.js, FastAPI, and PostgreSQL.

## Prerequisites

- [Bun](https://bun.sh)
- [uv](https://docs.astral.sh/uv/)
- [Docker](https://www.docker.com/) (for PostgreSQL)

## Quick Start

```bash
# 1. Install JS dependencies
bun install

# 2. Start PostgreSQL
docker compose up -d

# 3. Load data into the database (from apps/api)
cd apps/api
uv run scripts/load_csv_to_postgres.py

# 4. Start both the API and web app
cd ../..
bunx turbo dev
```

The web app runs at [http://localhost:3000](http://localhost:3000) and the API at [http://localhost:8000](http://localhost:8000).

## Project Structure

- `apps/web` — Next.js frontend
- `apps/api` — FastAPI backend with PostgreSQL

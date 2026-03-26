# API

This package contains the Fast API application for the project. It also contains the scripts to fetch data from Spotify and load it into the PostgreSQL database.

<p align="center">
  <img src="./assets/er_diagram.png" alt="ER Diagram" width="600" />
</p>

## Run locally

Run these commands from the api directory.

```bash
# Get data
uv run scripts/get_data.py

# Load data
uv run scripts/load_csv_to_postgres.py

# Run the API
uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

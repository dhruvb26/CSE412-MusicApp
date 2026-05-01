import logging
import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

logger = logging.getLogger(__name__)

load_dotenv(override=True)


def _configure_logging() -> None:
    handler = logging.StreamHandler()
    handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
    handler.addFilter(lambda record: record.levelno in (logging.INFO, logging.ERROR))
    logger.handlers.clear()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    logger.propagate = False


def _connect():
    database_url = os.getenv("DATABASE_URL")

    return psycopg2.connect(database_url)


def main() -> None:
    _configure_logging()

    api_root = Path(__file__).resolve().parent.parent
    ddl_path = api_root / "db" / "create_table.sql"
    data_dir = api_root / "data"

    try:
        ddl_sql = ddl_path.read_text(encoding="utf-8")
    except OSError as exc:
        raise RuntimeError(f"Could not read {ddl_path}: {exc}") from exc

    csv_mappings = [
        ("artist", "artist.csv"),
        ("album", "album.csv"),
        ("song", "song.csv"),
        ('"User"', "appuser.csv"),
        ("credits", "credits.csv"),
        ("review", "review.csv"),
    ]

    for _, csv_name in csv_mappings:
        csv_path = data_dir / csv_name
        if not csv_path.exists():
            raise RuntimeError(f"Missing CSV file: {csv_path}")

    with _connect() as conn:
        with conn.cursor() as cur:
            cur.execute(
                'DROP TABLE IF EXISTS review, credits, "User", song, album, artist CASCADE'
            )
            cur.execute(ddl_sql)

            for table, csv_name in csv_mappings:
                csv_path = data_dir / csv_name
                with csv_path.open("r", encoding="utf-8") as f:
                    cur.copy_expert(
                        f"COPY {table} FROM STDIN WITH (FORMAT csv, HEADER false)",
                        f,
                    )

    logger.info("Loaded CSV data into Postgres from %s", data_dir)


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        logger.error("%s", exc)
        raise SystemExit(1) from exc

import os

import psycopg2
from dotenv import load_dotenv

load_dotenv(override=True)


def get_conn():
    return psycopg2.connect(os.getenv("DATABASE_URL"))

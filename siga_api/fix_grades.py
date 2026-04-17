from sqlalchemy import text
from database import engine

with engine.connect() as conn:
    conn.execute(text("ALTER TABLE grades ADD COLUMN IF NOT EXISTS periodo_cerrado BOOLEAN DEFAULT FALSE"))
    conn.execute(text("ALTER TABLE grades ALTER COLUMN nota_final DROP NOT NULL"))
    conn.commit()
    print("Listo!")
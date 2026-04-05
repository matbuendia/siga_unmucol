from fastapi import FastAPI
from database import engine, Base
from routers import auth, users

Base.metadata.create_all(bind=engine)

app = FastAPI(title="SIGA UNMUCOL API")

app.include_router(auth.router)
app.include_router(users.router)

@app.get("/")
def root():
    return {"mensaje": "API SIGA UNMUCOL funcionando"}
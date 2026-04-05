from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from passlib.context import CryptContext
from database import get_db
from models import User
import uuid

router = APIRouter(prefix="/users", tags=["users"])
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class UserCreate(BaseModel):
    email: str
    password: str
    nombre: str
    rol: str

@router.get("/")
def listar_usuarios(db: Session = Depends(get_db)):
    usuarios = db.query(User).all()
    return [
        {
            "id": str(u.id),
            "email": u.email,
            "nombre": u.nombre,
            "rol": u.rol,
            "activo": u.activo
        }
        for u in usuarios
    ]

@router.get("/estudiantes")
def listar_estudiantes(db: Session = Depends(get_db)):
    estudiantes = db.query(User).filter(User.rol == "student").all()
    return [
        {
            "id": str(u.id),
            "email": u.email,
            "nombre": u.nombre,
            "activo": u.activo
        }
        for u in estudiantes
    ]

@router.post("/")
def crear_usuario(data: UserCreate, db: Session = Depends(get_db)):
    existe = db.query(User).filter(User.email == data.email).first()
    if existe:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")
    nuevo = User(
        id=uuid.uuid4(),
        email=data.email,
        hashed_password=pwd_context.hash(data.password),
        nombre=data.nombre,
        rol=data.rol,
        activo=True
    )
    db.add(nuevo)
    db.commit()
    db.refresh(nuevo)
    return {"mensaje": "Usuario creado", "id": str(nuevo.id)}
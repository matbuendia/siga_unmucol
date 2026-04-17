from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User, Event, Enrollment, Course, Subject

router = APIRouter(prefix="/events", tags=["events"])

@router.get("/student/{student_id}")
def get_events_by_student(student_id: str, db: Session = Depends(get_db)):
    # Verificar que el estudiante existe
    student = db.query(User).filter(User.id == student_id, User.rol == "student").first()
    if not student:
        raise HTTPException(status_code=404, detail="Estudiante no encontrado")

    # Eventos globales (sin curso)
    eventos_globales = db.query(Event).filter(Event.course_id == None).all()

    # Cursos del estudiante
    enrollments = db.query(Enrollment).filter(Enrollment.student_id == student_id).all()
    course_ids = [e.course_id for e in enrollments]

    # Eventos de sus cursos
    eventos_cursos = db.query(Event).filter(Event.course_id.in_(course_ids)).all() if course_ids else []

    todos = eventos_globales + eventos_cursos

    resultado = []
    for evento in todos:
        curso_nombre = None
        if evento.course_id:
            course = db.query(Course).filter(Course.id == evento.course_id).first()
            if course:
                subject = db.query(Subject).filter(Subject.id == course.subject_id).first()
                curso_nombre = subject.nombre if subject else None

        resultado.append({
            "id": str(evento.id),
            "titulo": evento.titulo,
            "contenido": evento.contenido,
            "fecha": str(evento.fecha),
            "tipo": "global" if evento.course_id is None else "curso",
            "curso": curso_nombre,
        })

    # Ordenar por fecha
    resultado.sort(key=lambda x: x["fecha"])

    return resultado
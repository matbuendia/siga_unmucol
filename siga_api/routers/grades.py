from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User, Subject, Course, Enrollment, Grade, GradeActivity

router = APIRouter(prefix="/grades", tags=["grades"])

def calcular_promedio(actividades: list) -> float | None:
    if not actividades:
        return None

    pesos = {"quiz": 0.20, "examen": 0.40, "taller": 0.10, "otra": 0.10}
    conteo = {"quiz": 0, "examen": 0, "taller": 0, "otra": 0}
    sumas =  {"quiz": 0.0, "examen": 0.0, "taller": 0.0, "otra": 0.0}

    for act in actividades:
        tipo = act.tipo if act.tipo in pesos else "otra"
        conteo[tipo] += 1
        sumas[tipo] += float(act.valor)

    total = 0.0
    peso_acumulado = 0.0

    for tipo, peso in pesos.items():
        if conteo[tipo] > 0:
            promedio_tipo = sumas[tipo] / conteo[tipo]
            total += promedio_tipo * peso
            peso_acumulado += peso

    if peso_acumulado == 0:
        return None

    # Ajustar al 100% si no están todos los tipos registrados aún
    return round(total / peso_acumulado, 2)

@router.get("/student/{student_id}")
def get_grades_by_student(student_id: str, db: Session = Depends(get_db)):
    # Verificar que el estudiante existe
    student = db.query(User).filter(User.id == student_id, User.rol == "student").first()
    if not student:
        raise HTTPException(status_code=404, detail="Estudiante no encontrado")

    # Buscar todas las inscripciones del estudiante
    enrollments = db.query(Enrollment).filter(Enrollment.student_id == student_id).all()

    resultado = []

    for enrollment in enrollments:
        # Obtener el curso y la materia
        course = db.query(Course).filter(Course.id == enrollment.course_id).first()
        subject = db.query(Subject).filter(Subject.id == course.subject_id).first()
        teacher = db.query(User).filter(User.id == course.teacher_id).first()

        periodos = []

        for num_periodo in [1, 2, 3]:
            # Obtener actividades de ese periodo
            actividades = db.query(GradeActivity).filter(
                GradeActivity.enrollment_id == enrollment.id,
                GradeActivity.periodo == num_periodo
            ).all()

            # Calcular promedio ponderado
            nota_periodo = calcular_promedio(actividades)

            # Ver si el periodo está cerrado
            grade = db.query(Grade).filter(
                Grade.enrollment_id == enrollment.id,
                Grade.periodo == num_periodo
            ).first()

            cerrado = grade.periodo_cerrado if grade else False
            nota_final_periodo = float(grade.nota_final) if (grade and grade.nota_final) else nota_periodo

            periodos.append({
                "periodo": num_periodo,
                "nota": round(nota_final_periodo, 2) if nota_final_periodo else None,
                "cerrado": cerrado,
                "actividades": [
                    {
                        "tipo": a.tipo,
                        "descripcion": a.descripcion,
                        "valor": float(a.valor)
                    }
                    for a in actividades
                ]
            })

        # Nota final de la materia: promedio de los 3 periodos cerrados
        notas_cerradas = [p["nota"] for p in periodos if p["cerrado"] and p["nota"] is not None]
        nota_final_materia = round(sum(notas_cerradas) / len(notas_cerradas), 2) if notas_cerradas else None

        resultado.append({
            "materia": subject.nombre,
            "profesor": teacher.nombre if teacher else "Sin asignar",
            "periodos": periodos,
            "nota_final": nota_final_materia
        })

    return {
        "estudiante": student.nombre,
        "materias": resultado
    }

@router.post("/seed-test")
def seed_test_data(db: Session = Depends(get_db)):
    import uuid
    from datetime import date
    from models import Event

    student_id = "cd6c4ef5-508b-4546-96bf-77dd09b2220e"

    # Materias
    matematicas = Subject(id=uuid.uuid4(), nombre="Matemáticas", descripcion="Álgebra y geometría")
    lenguaje = Subject(id=uuid.uuid4(), nombre="Lenguaje", descripcion="Comprensión lectora")
    ciencias = Subject(id=uuid.uuid4(), nombre="Ciencias Naturales", descripcion="Biología y química")
    db.add_all([matematicas, lenguaje, ciencias])
    db.flush()

    # Cursos
    curso_mat = Course(id=uuid.uuid4(), subject_id=matematicas.id, teacher_id=None, seccion="A", año=2025)
    curso_len = Course(id=uuid.uuid4(), subject_id=lenguaje.id, teacher_id=None, seccion="A", año=2025)
    curso_cie = Course(id=uuid.uuid4(), subject_id=ciencias.id, teacher_id=None, seccion="A", año=2025)
    db.add_all([curso_mat, curso_len, curso_cie])
    db.flush()

    # Inscripciones
    enroll_mat = Enrollment(id=uuid.uuid4(), student_id=student_id, course_id=curso_mat.id, fecha_inscripcion=date.today())
    enroll_len = Enrollment(id=uuid.uuid4(), student_id=student_id, course_id=curso_len.id, fecha_inscripcion=date.today())
    enroll_cie = Enrollment(id=uuid.uuid4(), student_id=student_id, course_id=curso_cie.id, fecha_inscripcion=date.today())
    db.add_all([enroll_mat, enroll_len, enroll_cie])
    db.flush()

    # Actividades y grades — Matemáticas
    for enroll, actividades_p1, actividades_p2, actividades_p3 in [
        (
            enroll_mat,
            [("taller","Taller 1",4.8),("quiz","Quiz 1",4.0),("taller","Taller 2",3.9),("otra","Exposición",4.5),("quiz","Quiz 2",3.5),("examen","Examen final",4.2)],
            [("taller","Taller 1",3.5),("quiz","Quiz 1",3.8),("taller","Taller 2",4.0),("otra","Participación",3.5),("quiz","Quiz 2",4.2),("examen","Examen final",3.9)],
            [("taller","Taller 1",4.5),("quiz","Quiz 1",4.8),("taller","Taller 2",4.2),("otra","Trabajo grupal",4.0),("quiz","Quiz 2",3.9),("examen","Examen final",4.5)],
        ),
        (
            enroll_len,
            [("taller","Taller 1",4.5),("quiz","Quiz 1",4.8),("taller","Taller 2",4.2),("otra","Exposición oral",5.0),("quiz","Quiz 2",4.5),("examen","Examen final",4.7)],
            [("taller","Taller 1",4.0),("quiz","Quiz 1",4.2),("taller","Taller 2",4.5),("otra","Debate",4.8),("quiz","Quiz 2",4.3),("examen","Examen final",4.5)],
            [("taller","Taller 1",3.8),("quiz","Quiz 1",4.0),("taller","Taller 2",3.9),("otra","Ensayo",4.2),("quiz","Quiz 2",4.1),("examen","Examen final",4.0)],
        ),
        (
            enroll_cie,
            [("taller","Taller 1",3.0),("quiz","Quiz 1",2.8),("taller","Taller 2",3.2),("otra","Laboratorio",3.5),("quiz","Quiz 2",3.0),("examen","Examen final",2.9)],
            [("taller","Taller 1",3.5),("quiz","Quiz 1",3.8),("taller","Taller 2",3.2),("otra","Informe",3.0),("quiz","Quiz 2",3.5),("examen","Examen final",3.3)],
            [("taller","Taller 1",4.0),("quiz","Quiz 1",3.9),("taller","Taller 2",4.1),("otra","Proyecto",4.5),("quiz","Quiz 2",4.0),("examen","Examen final",4.2)],
        ),
    ]:
        for periodo, actividades in [(1, actividades_p1), (2, actividades_p2), (3, actividades_p3)]:
            for tipo, desc, valor in actividades:
                db.add(GradeActivity(
                    id=uuid.uuid4(),
                    enrollment_id=enroll.id,
                    periodo=periodo,
                    tipo=tipo,
                    descripcion=desc,
                    valor=valor
                ))
            # Cerrar periodos 1 y 2
            if periodo < 3:
                notas = [v for _, _, v in actividades]
                nota_calculada = round(sum(notas) / len(notas), 2)
                db.add(Grade(
                    id=uuid.uuid4(),
                    enrollment_id=enroll.id,
                    periodo=periodo,
                    nota_final=nota_calculada,
                    periodo_cerrado=True
                ))

    db.flush()

    # Eventos
    hoy = date.today()
    eventos = [
        Event(id=uuid.uuid4(), created_by=None, course_id=None, titulo="Reunión de padres", contenido="Mañana a las 8am en el auditorio principal", fecha=hoy),
        Event(id=uuid.uuid4(), created_by=None, course_id=None, titulo="Día del estudiante", contenido="No hay clases, celebración en el patio central", fecha=date(hoy.year, hoy.month, hoy.day + 5)),
        Event(id=uuid.uuid4(), created_by=None, course_id=curso_mat.id, titulo="Entrega taller de matemáticas", contenido="Traer el taller resuelto en físico", fecha=date(hoy.year, hoy.month, hoy.day + 2)),
        Event(id=uuid.uuid4(), created_by=None, course_id=curso_len.id, titulo="Quiz de lenguaje", contenido="Repasar capítulos 3 y 4 del libro", fecha=date(hoy.year, hoy.month, hoy.day + 2)),
        Event(id=uuid.uuid4(), created_by=None, course_id=curso_cie.id, titulo="Entrega informe de laboratorio", contenido="Presentar informe del experimento de la semana pasada", fecha=date(hoy.year, hoy.month, hoy.day + 7)),
    ]
    db.add_all(eventos)
    db.commit()
    return {"mensaje": "Datos de prueba creados"}
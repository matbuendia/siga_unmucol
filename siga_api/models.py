from sqlalchemy import Column, String, Boolean, Integer, Date, DateTime, Numeric, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from database import Base
import uuid

class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String, unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    nombre = Column(String, nullable=False)
    rol = Column(String, nullable=False)
    activo = Column(Boolean, default=True)

class Subject(Base):
    __tablename__ = "subjects"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    nombre = Column(String, nullable=False)
    descripcion = Column(Text, nullable=True)

class Course(Base):
    __tablename__ = "courses"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    subject_id = Column(UUID(as_uuid=True), ForeignKey("subjects.id"))
    teacher_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    seccion = Column(String, nullable=False)
    año = Column(Integer, nullable=False)

class Enrollment(Base):
    __tablename__ = "enrollments"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    student_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.id"))
    fecha_inscripcion = Column(Date, nullable=False)

class Grade(Base):
    __tablename__ = "grades"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    enrollment_id = Column(UUID(as_uuid=True), ForeignKey("enrollments.id"))
    periodo = Column(Integer, nullable=False)
    nota_final = Column(Numeric(3, 1), nullable=False)

class Event(Base):
    __tablename__ = "events"
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    course_id = Column(UUID(as_uuid=True), ForeignKey("courses.id"), nullable=True)
    titulo = Column(String, nullable=False)
    contenido = Column(Text, nullable=False)
    fecha = Column(Date, nullable=False)
    created_at = Column(DateTime, server_default=func.now())
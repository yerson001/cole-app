# Colecheck API — Módulo Padre

## Base URL

| Entorno | URL |
|---------|-----|
| Producción | `https://backend.colecheck.com` |
| Demo | `https://demo.backend.colecheck.com` |
| Local | `https://backend.colecheck.com` |

## Headers comunes

| Header | Valor | Descripción |
|--------|-------|-------------|
| `tenant-id` | `ie-guillermo` (ejemplo) | Subdominio del colegio, se obtiene de la URL |
| `Authorization` | `Bearer <access_token>` | JWT obtenido del login |
| `Content-Type` | `application/json` | Solo en POST/PATCH con body |

## Almacenamiento

- `access_token` → cookie `access_token`
- `role` → `localStorage` (`PARENT`)
- `profile_id` → `sessionStorage` (ID del perfil del padre)

---

## 1. Autenticación

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 1 | POST | `/auth/login` | Login con DNI + password | `{ documentNumber, password }` |
| 2 | GET | `/tenants/exist?tenant-id={id}` | Verifica si un tenant (colegio) existe | — |
| 3 | PATCH | `/users/token/{userId}` | Actualiza token FCM para notificaciones push | `{ token }` |
| 4 | PATCH | `/users/{userId}/app-installed` | Marca PWA como instalada | `{ is_app_installed: boolean }` |
| 5 | PATCH | `/users/{userId}/notifications-enabled` | Actualiza preferencia de notificaciones | `{ notifications_enabled: boolean }` |

---

## 2. Dashboard / Inicio

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 6 | GET | `/parents/get-students-by-parent/{parentId}` | Obtiene todos los hijos vinculados al padre | Path: `parentId` |
| 7 | GET | `/attendance/day-report?date=...&branchId=...&studentId=...` | Asistencia del día para un estudiante | Query: `date`, `branchId`, `studentId` |

---

## 3. Asistencia

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 8 | GET | `/attendance/day-report?date=...&branchId=...&studentId=...` | Asistencia diaria por estudiante | Query: `date`, `branchId`, `studentId` |
| 9 | GET | `/attendance/in-range?startDate=...&endDate=...&search=&branchId=...&studentId=...` | Asistencia en rango de fechas | Query: `startDate`, `endDate`, `search`, `branchId`, `studentId` |
| 10 | PATCH | `/attendance/update-check-in/{attendanceId}` | Actualiza/sobreescribe un check-in | Path: `attendanceId` |
| 11 | POST | `/attendance/check-in` | Marca entrada de estudiante | `{ studentId, date, time, branchId }` |
| 12 | POST | `/attendance/check-out` | Marca salida de estudiante | `{ studentId, date, time, branchId }` |

### Justificaciones

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 13 | POST | `/justifications` | Crear justificación de inasistencia | `{ attendanceId, reason, description }` |
| 14 | GET | `/justifications/attendance/{attendanceId}` | Obtener justificación por attendanceId | Path: `attendanceId` |
| 15 | PATCH | `/justifications/{id}` | Actualizar justificación | Path: `id`, Body: `{ reason, description }` |

---

## 4. Horario

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 16 | GET | `/schedule/section/{sectionId}` | Obtener horario por sección | Path: `sectionId` |

---

## 5. Calificaciones

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 17 | GET | `/student-assessment/by-student/{studentId}` | Obtener notas/ evaluaciones de un estudiante | Path: `studentId` |

---

## 6. Agenda / Comunicados

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 18 | GET | `/virtual-agenda/parent/{parentId}?startDate=...&endDate=...` | Agenda virtual del padre (todos sus hijos) | Path: `parentId`, Query: `startDate`, `endDate` |
| 19 | GET | `/virtual-agenda/student/{studentId}?startDate=...&endDate=...` | Agenda virtual de un estudiante específico | Path: `studentId`, Query: `startDate`, `endDate` |
| 20 | PATCH | `/virtual-agenda/items/{id}/read` | Marcar item de agenda como leído | Path: `id` |
| 21 | GET | `/announcements/{id}` | Detalle de un comunicado | Path: `id` |
| 22 | GET | `/student-observations/{id}` | Detalle de una observación/reprimenda | Path: `id` |
| 23 | GET | `/homework/{id}` | Detalle de una tarea | Path: `id` |

---

## 7. Tesorería

### Pensiones

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 24 | GET | `/student-fees/student/{studentId}` | Obtener pensiones de un estudiante | Path: `studentId` |
| 25 | GET | `/monthly-payments/student/{studentId}` | Historial de pagos de un estudiante | Path: `studentId` |
| 26 | POST | `/monthly-payments` | Registrar pago de pensión | `{ studentId, amount, date, method }` |

### Cuotas

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 27 | GET | `/payments` | Obtener todas las cuotas | Header: `tenant-id` |
| 28 | GET | `/payments/student/{studentId}` | Obtener cuotas de un estudiante | Path: `studentId` |
| 29 | GET | `/payments/{feeId}` | Obtener cuota por ID | Path: `feeId` |
| 30 | PATCH | `/payments/{feeId}/items/{itemId}` | Marcar item de cuota como pagado | Path: `feeId`, `itemId`, Body: `{ isPaid: true }` |

---

## 8. Reuniones

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 31 | GET | `/parent-meeting-attendance/get-all-by-parent/{parentId}` | Obtener asistencias a reuniones del padre | Path: `parentId` |
| 32 | POST | `/parent-meeting-attendance/check-in-by-parent` | Auto check-in del padre a una reunión | `{ meetingId, parentId }` |
| 33 | POST | `/parent-meeting-attendance/check-out-by-parent` | Auto check-out del padre de una reunión | `{ meetingId, parentId }` |

---

## 9. Perfil

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 34 | GET | `/users/{userId}` | Obtener datos del perfil del usuario | Path: `userId` |
| 35 | PATCH | `/users/{userId}/change-password` | Cambiar contraseña | Path: `userId`, Body: `{ newPassword }` |

---

## 10. Fotocheck

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 36 | GET | `/branch/{branchId}` | Obtener información del colegio (usado en vista de fotocheck) | Path: `branchId` |

---

## 11. Datos estáticos (niveles, grados, secciones)

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 37 | GET | `/level` | Obtener niveles educativos |
| 38 | GET | `/degree` | Obtener grados |
| 39 | GET | `/degree/getByLevelId/{levelId}` | Obtener grados por nivel |
| 40 | GET | `/section/getByDegreeId/{degreeId}` | Obtener secciones por grado |

---

## 12. Estudiantes (búsqueda y asignación)

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 41 | GET | `/students/by-id/{id}` | Obtener estudiante por ID | Path: `id` |
| 42 | GET | `/students/search?query={query}` | Buscar estudiantes por texto | Query: `query` |
| 43 | POST | `/students/assign-parent` | Asignar padre a estudiante | `{ studentId, parentId }` |
| 44 | DELETE | `/students/{studentId}/parents/{parentId}` | Desasignar padre de estudiante | Path: `studentId`, `parentId` |
| 45 | GET | `/students/get-parents-by-student/{id}` | Obtener padres de un estudiante | Path: `id` |

---

## 13. Matrículas (búsqueda de estudiantes sin padre)

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 46 | GET | `/enrollments_v2/branch/{branchId}/search?query=...&year=...&status=...` | Buscar estudiantes matriculados | Path: `branchId`, Query: `query`, `year`, `status` |
| 47 | GET | `/enrollments/branch/{branchId}/without-parents?year=...&whatsapp=...` | Estudiantes sin padre vinculado por WhatsApp | Path: `branchId`, Query: `year`, `whatsapp` |

---

## 14. Padres (CRUD)

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 48 | POST | `/parents/create` | Crear nuevo padre | `{ branchId, sex, person: { name, lastName, email, document_number, documentType } }` |
| 49 | GET | `/parents/by-id/{id}` | Obtener padre por ID | — |
| 50 | PATCH | `/parents/update/{id}` | Actualizar datos del padre | `{ branchId, sex, person: { name, lastName, email }, status }` |
| 51 | GET | `/parents/get-students-by-parent/{parentId}` | Obtener hijos de un padre | — |
| 52 | GET | `/parents/search?query={query}` | Buscar padres por texto | — |
| 53 | GET | `/parents/filter/data-students?levelId=&degreeId=&sectionId=` | Filtrar padres por nivel/grado/sección | — |

---

## 15. Contacto

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 54 | POST | `/contact-info/create` | Crear información de contacto del padre | `{ phone, email, parentId }` |
| 55 | PATCH | `/contact-info/{contactInfoId}` | Actualizar información de contacto | `{ phone, email }` |

---

## 16. WhatsApp

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 56 | POST | `/whatsapp/send-welcome-message` | Enviar mensaje de bienvenida |
| 57 | POST | `/whatsapp/send-register` | Enviar link de registro |
| 58 | POST | `/whatsapp/msg-new-number` | Notificar nuevo número |
| 59 | POST | `/whatsapp/send-credentials` | Enviar credenciales de acceso |

---

## Resumen

| Categoría | Cantidad endpoints |
|-----------|-------------------|
| Autenticación | 5 |
| Dashboard / Inicio | 2 |
| Asistencia | 8 |
| Horario | 1 |
| Calificaciones | 1 |
| Agenda / Comunicados | 6 |
| Tesorería | 7 |
| Reuniones | 3 |
| Perfil | 2 |
| Fotocheck | 1 |
| Datos estáticos | 4 |
| Estudiantes | 5 |
| Matrículas | 2 |
| Padres (CRUD) | 6 |
| Contacto | 2 |
| WhatsApp | 4 |
| **Total** | **59** |

---

*Documentación generada a partir de colecheck-frontend v0.2.0 — Rama `deploy`*

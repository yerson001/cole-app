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

---

## 3. Asistencia

### Asistencia Diaria

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 7 | GET | `/attendance/day-report?date=...&branchId=...&studentId=...` | Reporte de asistencia del día por estudiante | Query: `date`, `branchId`, `studentId` |
| 8 | POST | `/attendance/check-in` | Marcar entrada de estudiante | `{ studentId, date, time, branchId }` |
| 9 | POST | `/attendance/check-out` | Marcar salida de estudiante | `{ studentId, date, time, branchId }` |

### Asistencia General

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 10 | GET | `/attendance/in-range?startDate=...&endDate=...&search=&branchId=...&studentId=...` | Asistencia en rango de fechas (vista mensual) | Query: `startDate`, `endDate`, `search`, `branchId`, `studentId` |
| 11 | PATCH | `/attendance/update-check-in/{attendanceId}` | Actualizar/sobreescribir un check-in | Path: `attendanceId` |

### Justificaciones

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 12 | POST | `/justifications` | Crear justificación de inasistencia | `{ attendanceId, reason, description }` |
| 13 | GET | `/justifications/attendance/{attendanceId}` | Obtener justificación por attendanceId | Path: `attendanceId` |
| 14 | PATCH | `/justifications/{id}` | Actualizar justificación | Path: `id`, Body: `{ reason, description }` |

---

## 4. Horario

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 15 | GET | `/schedule/section/{sectionId}` | Obtener horario por sección | Path: `sectionId` |

---

## 5. Calificaciones

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 16 | GET | `/student-assessment/by-student/{studentId}` | Obtener notas/evaluaciones de un estudiante | Path: `studentId` |

---

## 6. Agenda / Comunicados

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 17 | GET | `/virtual-agenda/parent/{parentId}?startDate=...&endDate=...` | Agenda virtual del padre (todos sus hijos) | Path: `parentId`, Query: `startDate`, `endDate` |
| 18 | GET | `/virtual-agenda/student/{studentId}?startDate=...&endDate=...` | Agenda virtual de un estudiante específico | Path: `studentId`, Query: `startDate`, `endDate` |
| 19 | PATCH | `/virtual-agenda/items/{id}/read` | Marcar item de agenda como leído | Path: `id` |
| 20 | GET | `/announcements/{id}` | Detalle de un comunicado | Path: `id` |
| 21 | GET | `/student-observations/{id}` | Detalle de una observación/reprimenda | Path: `id` |
| 22 | GET | `/homework/{id}` | Detalle de una tarea | Path: `id` |

---

## 7. Tesorería

### Pensiones

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 23 | GET | `/student-fees/student/{studentId}` | Obtener pensiones de un estudiante | Path: `studentId` |
| 24 | GET | `/monthly-payments/student/{studentId}` | Historial de pagos de un estudiante | Path: `studentId` |
| 25 | POST | `/monthly-payments` | Registrar pago de pensión | `{ studentId, amount, date, method }` |

### Cuotas

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 26 | GET | `/payments` | Obtener todas las cuotas | Header: `tenant-id` |
| 27 | GET | `/payments/student/{studentId}` | Obtener cuotas de un estudiante | Path: `studentId` |
| 28 | GET | `/payments/{feeId}` | Obtener cuota por ID | Path: `feeId` |
| 29 | PATCH | `/payments/{feeId}/items/{itemId}` | Marcar item de cuota como pagado | Path: `feeId`, `itemId`, Body: `{ isPaid: true }` |

---

## 8. Reuniones

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 30 | GET | `/parent-meeting-attendance/get-all-by-parent/{parentId}` | Obtener asistencias a reuniones del padre | Path: `parentId` |
| 31 | POST | `/parent-meeting-attendance/check-in-by-parent` | Auto check-in del padre a una reunión | `{ meetingId, parentId }` |
| 32 | POST | `/parent-meeting-attendance/check-out-by-parent` | Auto check-out del padre de una reunión | `{ meetingId, parentId }` |

---

## 9. Perfil

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 33 | GET | `/users/{userId}` | Obtener datos del perfil del usuario | Path: `userId` |
| 34 | PATCH | `/users/{userId}/change-password` | Cambiar contraseña | Path: `userId`, Body: `{ newPassword }` |

---

## 10. Fotocheck

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 35 | GET | `/branch/{branchId}` | Obtener información del colegio (usado en vista de fotocheck) | Path: `branchId` |

---

## 11. Datos estáticos (niveles, grados, secciones)

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 36 | GET | `/level` | Obtener niveles educativos |
| 37 | GET | `/degree` | Obtener grados |
| 38 | GET | `/degree/getByLevelId/{levelId}` | Obtener grados por nivel |
| 39 | GET | `/section/getByDegreeId/{degreeId}` | Obtener secciones por grado |

---

## 12. Estudiantes (búsqueda y asignación)

| # | Método | Endpoint | Descripción | Parámetros / Body |
|---|--------|----------|-------------|-------------------|
| 40 | GET | `/students/by-id/{id}` | Obtener estudiante por ID | Path: `id` |
| 41 | GET | `/students/search?query={query}` | Buscar estudiantes por texto | Query: `query` |
| 42 | POST | `/students/assign-parent` | Asignar padre a estudiante | `{ studentId, parentId }` |
| 43 | DELETE | `/students/{studentId}/parents/{parentId}` | Desasignar padre de estudiante | Path: `studentId`, `parentId` |
| 44 | GET | `/students/get-parents-by-student/{id}` | Obtener padres de un estudiante | Path: `id` |

---

## 13. Matrículas (búsqueda de estudiantes sin padre)

| # | Método | Endpoint | Descripción | Parámetros |
|---|--------|----------|-------------|------------|
| 45 | GET | `/enrollments_v2/branch/{branchId}/search?query=...&year=...&status=...` | Buscar estudiantes matriculados | Path: `branchId`, Query: `query`, `year`, `status` |
| 46 | GET | `/enrollments/branch/{branchId}/without-parents?year=...&whatsapp=...` | Estudiantes sin padre vinculado por WhatsApp | Path: `branchId`, Query: `year`, `whatsapp` |

---

## 14. Padres (CRUD)

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 47 | POST | `/parents/create` | Crear nuevo padre | `{ branchId, sex, person: { name, lastName, email, document_number, documentType } }` |
| 48 | GET | `/parents/by-id/{id}` | Obtener padre por ID | — |
| 49 | PATCH | `/parents/update/{id}` | Actualizar datos del padre | `{ branchId, sex, person: { name, lastName, email }, status }` |
| 50 | GET | `/parents/get-students-by-parent/{parentId}` | Obtener hijos de un padre | — |
| 51 | GET | `/parents/search?query={query}` | Buscar padres por texto | — |
| 52 | GET | `/parents/filter/data-students?levelId=&degreeId=&sectionId=` | Filtrar padres por nivel/grado/sección | — |

---

## 15. Contacto

| # | Método | Endpoint | Descripción | Body |
|---|--------|----------|-------------|------|
| 53 | POST | `/contact-info/create` | Crear información de contacto del padre | `{ phone, email, parentId }` |
| 54 | PATCH | `/contact-info/{contactInfoId}` | Actualizar información de contacto | `{ phone, email }` |

---

## 16. WhatsApp

| # | Método | Endpoint | Descripción |
|---|--------|----------|-------------|
| 55 | POST | `/whatsapp/send-welcome-message` | Enviar mensaje de bienvenida |
| 56 | POST | `/whatsapp/send-register` | Enviar link de registro |
| 57 | POST | `/whatsapp/msg-new-number` | Notificar nuevo número |
| 58 | POST | `/whatsapp/send-credentials` | Enviar credenciales de acceso |

---

## Resumen

| Categoría | Cantidad endpoints |
|-----------|-------------------|
| Autenticación | 5 |
| Dashboard / Inicio | 1 |
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
| **Total** | **58** |

---

*Documentación generada a partir de colecheck-frontend v2.0.0 — Rama `deploy`*

Ahora sí, con branchId=1 confirmado, aquí tienes los curls:
1. Asistencia de CARLOS GUSTAVO (id: 30):
curl "https://demo.backend.colecheck.com/attendance/day-report?date=2026-07-23&branchId=1&studentId=30" \
  -H "tenant-id: ie-guillermo"
2. Asistencia de FRANKYE RICARDO (id: 287):
curl "https://demo.backend.colecheck.com/attendance/day-report?date=2026-07-23&branchId=1&studentId=287" \
  -H "tenant-id: ie-guillermo"
El endpoint es /attendance/day-report con parámetros date, branchId y studentId.
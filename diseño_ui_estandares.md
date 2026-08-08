# Mobile App Design Standards (Skill Completo)

Contenido íntegro del skill `awesome-skills/mobile-app-design` (SKILL.md + los 7 references/), adaptado de React Native a Flutter.

---

## 1. Convenciones de Plataforma

### iOS (HIG)
- **Navegación**: Back arriba-izquierda, acción principal arriba-derecha.
- **Tab bar** abajo con 3-5 items (en Flutter: `BottomNavigationBar`).
- **Large titles** para jerarquía (34pt, colapsan al hacer scroll).
- **Fuente**: San Francisco (sistema por defecto).
- **Haptic feedback** para confirmaciones (`HapticFeedback`).
- **Gestos swipe** para navegar/retroceder.

### Android (Material Design)
- **Navegación**: Back arriba-izquierda o botón de sistema, menú overflow (⋮) arriba-derecha.
- **Bottom navigation** o **drawer** (5+ secciones).
- **FAB** para acción primaria (`FloatingActionButton`).
- **Fuente**: Roboto (por defecto en Material).
- **Ripple** como feedback táctil (Flutter: `InkWell`/`InkResponse`).

### Cross-platform
- Usar `Theme.of(context).platform` para diferencias de comportamiento.
- Respetar convenciones de navegación del sistema (back button).
- Probar en iOS y Android reales.
- **Always diferente**: patrones de navegación, comportamiento del back, System UI.
- **Puede unificarse**: colores de marca, cards, listas, tipografía con fuente de marca.

---

## 2. Touch Targets y Espaciado (OBLIGATORIO)

| Plataforma | Mínimo |
|---|---|
| iOS | 44 × 44 pt |
| Android | 48 × 48 dp |

- **Espaciado entre targets**: mínimo 8dp/pt (12-16pt para acciones destructivas).
- Acciones primarias más grandes (FAB 56dp).
- `IconButton` en Flutter mide 48×48 por defecto ✅.
- Si el icono visual es <48px, ampliar área táctil con `Padding`/`Constraints` o `InkResponse` con `customBorder` más grande. NUNCA hit area <48px.
- `visualDensity: compact` o `MaterialTapTargetSize.shrinkWrap` reducen el área táctil → evitar en controles críticos.
- List items: mínimo 56dp alto (Android), 44pt (iOS).
- Checkbox/radio: 40dp mínimo; switches: ~51-52×31-32.
- Icon buttons: icono 40dp + touch 48dp.

**Errores comunes**: targets pequeños, targets muy juntos, acciones destructivas sin separar.

---

## 3. Tipografía

- **Body text**: mínimo 16sp (14sp absoluto).
- **Labels/captions**: mínimo 11-12pt.
- **Escala consistente** (12/14/16/20/24/32).
- **Jerarquía** por tamaño, peso y color.
- **Dynamic Type**: en Flutter usar `textScaler` del tema; probar a 200% (AX5). El layout debe adaptarse sin truncar ni scroll horizontal.
- **Line length**: 40-60 caracteres óptimo, 75 máx.
- **Line height**: 1.5× el font size para body, 1.2× para headlines.
- **Evitar MAYÚSCULAS** en body; ok en labels cortos con letterSpacing.
- **Peso**: usar bold/medium para énfasis, no solo tamaño. Evitar itálicas en bloques largos.

### Escala Material 3
```
Display:  57/45/36sp  ·  Headline: 32/28/24sp
Title:    22/16/14sp  ·  Body: 16/14/12sp
Label:    14/12/11sp
```

### Escala iOS
```
Large Title: 34 · Title 1: 28 · Title 2: 22 · Title 3: 20
Headline: 17 (semibold) · Body: 17 · Callout: 16 · Subheadline: 15
Footnote: 13 · Caption 1: 12 · Caption 2: 11
```

---

## 4. Color y Contraste (WCAG 2.1 AA)

| Elemento | Ratio mínimo |
|---|---|
| Texto normal (<18pt) | **4.5:1** |
| Texto grande (≥18pt o ≥14pt bold) | **3:1** |
| UI components / bordes | **3:1** |
| Focus indicators | **3:1** |

- **No usar solo color**: acompañar con iconos, labels, patrones (✅ icono check + texto; ❌ solo fondo verde).
- **Soporte daltonismo** (deuteranopia/protanopia/tritanopia/monocromía): no rojo/verde como único diferenciador.
- **Dark mode**: probar todas las pantallas; no invertir colores a ciegas; mantener contraste; usar surface elevada para capas.
- Errores comunes: texto gris sobre blanco, placeholders claros, texto disabled muy claro, acciones secundarias con poco contraste.
- Material: texto primario 87% opacidad (claro), secundario 60%, disabled 38%.

---

## 5. Accesibilidad (accessibility-checklist.md)

### Screen readers (VoiceOver / TalkBack)
- **Todo elemento interactivo** necesita label (Flutter: `Semantics`, `Tooltip`, `semanticsLabel`).
- Label = QUÉ es el elemento; Hint = QUÉ HACE. No incluir el tipo ("botón", "imagen") en el label.
- **No repetir el tipo**: el rol ya lo dice.
- Iconos decorativos: `ExcludeSemantics` / `importantForAccessibility: no`.
- **Anunciar cambios dinámicos** (async load, submit, agregar/quitar items, errores): `SemanticsService.announce(...)`.
- Agrupar elementos relacionados.

### Focus management
- Orden lógico de lectura (top→bottom, left→right).
- Foco visible (indicador ≥3:1).
- `FocusTraversalGroup` / `TraversalEdgeBehavior` para orden personalizado.
- Evitar focus traps (poder navegar fuera).
- Al abrir modal, foco va al contenido nuevo; al cerrar, vuelve al trigger.

### Reduce motion
- `MediaQuery.disableAnimationsOf(context)` → fade corto en vez de animaciones largas.
- Evitar parallax, movimientos de área grande, animaciones rápidas/pulsantes, 3D simulado, auto-play.
- **Prevención de epilepsia**: nada parpadea >3 veces/segundo; warning en video con flashes.

### Forms
- Inputs con label persistente (no solo placeholder).
- Teclado correcto: `TextInputType.emailAddress`, `phone`, `url`, etc.
- Errores claros, con sugerencia, al lado del campo, **preservando input del usuario**.
- Errores: no solo color → icono + texto. Real-time validation anunciada.
- Campos requeridos marcados; instrucciones antes del input; auto-complete donde aplique.

### Imágenes y media
- Imágenes informativas con alt text; decorativas marcadas como decorativas.
- Video con captions; audio con transcripción; alt text incluye nombre de la empresa en logos.
- No auto-play con sonido (o <3s) sin control de pause.

### Tamaño de switches
- Toggle ≥51×31 pt; checkbox/radio 40×40 dp.

---

## 6. Rendimiento (performance-patterns.md)

- **Listas largas**: `ListView.builder` / `GridView.builder` (NO `Column` con miles de hijos).
- **`const` widgets** donde no haya estado.
- **`itemExtent`/`prototypeItem`** en listas homogéneas para saltar medición.
- **`RepaintBoundary`** en widgets que se repintan seguido.
- **Imágenes**: `cacheWidth`/`cacheHeight`, placeholders (`loadingBuilder`), estados de error, prefetch.
- **Animaciones a 60fps**: animar `transform`/`opacity`, no `width`/`height` (evita layout en cada frame).
- **Evitar rebuilds**: `BlocBuilder` con `buildWhen`, `select`, widgets memoizados.
- **No computar en `build()`** cosas pesadas → state getters / memoizar.
- **Overdraw**: no anidar containers con color innecesario.
- **Estado derivado**: computar en render, no guardarlo (evita re-renders y bugs de sync).
- **Async**: cancelar/limpiar al desmontar (bloc lo hace); evitar leaks.
- **Caché de red**: cachear respuestas, offline-first para features críticos, batch de requests.

---

## 7. Navegación y Componentes

- **Consistencia**: mismo patrón de navegación en toda la app.
- **Back correcto**: `Navigator.pop()` / back del sistema, nunca "exit app".
- **Cards**: radio 12dp, elevación sutil, padding 16.
- **Botones**: filled=primaria (pocas por pantalla), outlined=secundaria, text=terciaria. Altura 40dp+.
- **Labels de botones**: verbos específicos ("Eliminar foto" no "Eliminar"), Title Case (iOS), concisos.
- **Snackbar**: 1-2 líneas, acción opcional en mayúsculas cortas, auto-dismiss 4-10s, sobre FAB.
- **Diálogos**: título = pregunta clara, contenido = contexto (no repetir título), 1-2 botones (Dismiss/Confirm), dismissible con back.
- **Bottom sheets**: Standard (no modal) vs Modal (bloquea). Estados: collapsed/half/expanded/hidden.
- **Chips**: Assist / Filter (estados activo-inactivo) / Input (tags) / Suggestion.
- **FAB**: una por pantalla, acciones constructivas (crear, agregar), abajo-derecha a 16dp, sobre bottom nav, consistente. No destructivo, no para navegar.

### Top App Bar
- Icono de navegación (izq), título, 0-3 acciones (der), overflow.
- Alturas: 56dp móvil / 64dp tablet; large title colapsa al scroll.

### Navigation Drawer
- 5+ destinos top-level, agrupar relacionados, resaltar activo, header con branding, cerrar al seleccionar.

---

## 8. Estados de carga y feedback

- **Skeleton screens** para contenido; indicador de progreso para ops >1s.
- **Optimistic UI**: mostrar la acción inmediatamente.
- **Feedback táctil <100ms** para toda interacción.
- **Prevenir layout shift** durante carga (reservar espacio).
- Debounce de inputs rápidos.
- Launch: pantalla inicial acorde, contenido inmediato, <400ms ideal.

---

## 9. Errores comunes a evitar (common-mistakes.md)

### Visual
- ❌ Color como única señal → ✅ color + icono + texto
- ❌ Texto <11pt
- ❌ Contraste <4.5:1 para texto
- ❌ Touch targets <44pt/48dp
- ❌ Line height sin especificar → ✅ 1.5×

### Screen reader
- ❌ Labels faltantes en botones/imágenes
- ❌ Incluir el tipo en el label ("botón", "imagen")
- ❌ Campos sin label
- ❌ No anunciar cambios dinámicos

### Interaction
- ❌ Interacciones basadas en tiempo sin alternativa
- ❌ Gestos como única forma de acción
- ❌ Auto-play sin controles
- ❌ Foco de teclado no visible

### Content
- ❌ Imágenes sin alt text
- ❌ Video sin captions
- ❌ Audio sin transcripción
- ❌ Contenido parpadeante >3/s

### Forms
- ❌ Keyboard type incorrecto → ✅ `emailAddress`/`phone`/`url`
- ❌ Solo placeholder como label → ✅ label persistente
- ❌ Error genérico ("Error") → ✅ específico + sugerencia + inline

### Performance
- ❌ ScrollView con listas largas → ✅ `ListView.builder`
- ❌ Funciones creadas en cada build → ✅ closures estables
- ❌ No limpiar listeners/timers → ✅ cleanup
- ❌ Imágenes full-res → ✅ redimensionar + placeholder

---

## 10. Design System

### Consistencia visual
- [ ] Paleta unificada (primary, secondary, accent, neutrals)
- [ ] Escala tipográfica definida
- [ ] Sistema de espaciado (grid 8pt)
- [ ] Biblioteca de componentes documentada
- [ ] Iconos consistentes en estilo y tamaño

### Consistencia de comportamiento
- [ ] Patrones de navegación unificados
- [ ] Acciones de botones predecibles
- [ ] Validación de formularios consistente
- [ ] Manejo de errores estandarizado
- [ ] Estados de carga uniformes

---

## 11. Material Design — Elevación, Grid y Motion (android-guidelines.md)

### Elevación
- **Elevación define importancia**: surfaces con sombra crean jerarquía; luz desde arriba.
- Cards: resting **1dp**, raised **8dp**, máx **24dp**.
- Tipos de card: Elevated (sombra), Filled (tinte sin sombra), Outlined (borde sin sombra).
- En Flutter: `Material(elevation: ...)`, `Card(elevation: ...)`.

### Grid 8dp
- Columnas: móvil **4**, tablet **8**, desktop **12**.
- Márgenes/gutters: móvil **16dp**, tablet **24dp**.
- Todo espaciado en múltiplos de 8dp: 4/8/16/24/32.
- Iconografía alineada a grid de 4dp.
- iOS: márgenes de pantalla 16pt (iPhone) / 20pt (iPad); entre secciones 35-44pt; entre elementos 8-12pt.

### Roles de color Material You
- **Primary**, **Secondary**, **Tertiary**, **Error**, **Surface**, **Outline**.
- Variantes por rol: `Primary`/`OnPrimary`/`PrimaryContainer`/`OnPrimaryContainer`.
- En Flutter: `ColorScheme` expone `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`.

### Motion — duraciones
| Tipo | Duración |
|---|---|
| Small (fades, iconos) | 100–200ms |
| Medium (transiciones de pantalla) | 200–300ms |
| Long (transformaciones grandes) | 300–500ms |
| iOS | 300-400ms spring |

### Motion — easing
```
Standard:    cubic-bezier(0.4, 0.0, 0.2, 1)  → mayoría de transiciones
Emphasized:  cubic-bezier(0.2, 0.0, 0, 1)    → entradas importantes, hero
Deceleration:cubic-bezier(0.0, 0.0, 0.2, 1)  → elementos que salen
Acceleration:cubic-bezier(0.4, 0.0, 1, 1)    → elementos que salen permanentemente
```
En Flutter: `Curves.easeInOut`, `Curves.easeOutCubic`, `Curves.easeIn`, `CurvedAnimation`.

### Transiciones
- **Container Transform**: elemento se expande para llenar la pantalla.
- **Shared Axis**: relaciones espaciales entre pantallas (X/Y/Z).
- **Fade Through**: pantallas sin relación, cross-fade con pausa al medio.
- **Fade**: componentes pequeños.

---

## 12. Gestos y diálogos

- **Tap**: interacción principal. **Swipe**: navegar, revelar acciones, dismiss. **Pinch**: zoom. **Pan**: arrastrar. **Long press**: context menu (iOS 13+).
- **Back swipe (iOS)**: borde izquierdo — no sobreescribir gestos del sistema, dar alternativa con botón.
- Diálogos iOS: modal centrado redondeado, título bold centrado, botones Cancel (izq) / Confirm (der).
- Diálogos Android: dialog elevado, título medium left-aligned, botones right-aligned.
- Pull-to-refresh: ambas plataformas.

---

## 13. Quick Reference

| Regla | Valor |
|---|---|
| Touch target iOS | 44×44pt |
| Touch target Android | 48×48dp |
| Body text | 16sp mín (14sp absoluto) |
| Labels | 11pt mín |
| Contraste texto | 4.5:1 |
| Contraste texto grande | 3:1 |
| Contraste componentes | 3:1 |
| Feedback táctil | <100ms |
| Animaciones | 60fps |
| Spacing entre targets | 8dp mín |
| Line height body | 1.5× |
| Card elevation | 1dp rest / 8dp raised |
| FAB | 56dp |
| iOS nav | Back sup-izq, acción sup-der, tabs abajo |
| Android nav | Back sup-izq, menu sup-der, FAB abajo-der |
| Skeleton/loader | ops >1s |
| Launch | <400ms ideal |

---

## 14. Workflow de revisión (del SKILL.md)

Al revisar diseños o implementaciones, en este orden:
1. Convenciones de plataforma (iOS vs Android).
2. Touch targets (44pt/48dp mínimo).
3. Contraste de color (WCAG AA).
4. Labels de accesibilidad.
5. Consistencia con el design system.
6. Consideraciones de rendimiento.

---

*Fuente: https://github.com/awesome-skills/mobile-app-design (SKILL.md + references/{ios-guidelines, android-guidelines, accessibility-checklist, platform-differences, common-mistakes, performance-patterns, ui-libraries}.md). Adaptado de React Native a Flutter.*

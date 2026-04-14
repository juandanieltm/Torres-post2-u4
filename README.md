# Torres-post2-u4

## Descripción

Laboratorio 2 de la Unidad 4 — **Macros con Parámetros y Control de Flujo**.

Este proyecto demuestra el uso avanzado de NASM en entorno DOS de 16 bits, con énfasis en:

- Definición e invocación de **macros sin parámetros** (`fin_dos`, `nueva_linea`, `leer_char`)
- **Macros con parámetros** (`print_str`, `print_char`, `repetir_str`, `print_digito`)
- Uso de **etiquetas locales** con el prefijo `%%` para evitar colisiones entre expansiones
- **Organización modular**: biblioteca de macros en archivo separado (`macros.asm`) incluido con `%include`
- **Bucle con LOOP**: procedimiento `sumar_serie` que calcula 1+2+…+N
- **Control de flujo condicional**: procedimiento `comparar_e_imprimir` usando `CMP`, `JG` y `JE`
- Interacción entre procedimientos (`CALL`/`RET`) y preservación de registros

---

## Estructura del repositorio

```
Torres-post2-u4\
├── macros.asm            ← biblioteca de macros reutilizables
├── programa2.asm         ← programa principal (incluye macros.asm)
├── README.md             ← este archivo
├── COMMITS.sh            ← comandos git listos para copiar/pegar
└── capturas\
    ├── compilacion.png   ← compilación y listado .lst exitosos
    └── ejecucion.png     ← salida completa del programa en DOSBox
```

---

## Prerrequisitos

| Herramienta | Versión mínima | Descripción |
|-------------|----------------|-------------|
| [DOSBox](https://www.dosbox.com/) | 0.74+ | Emulador de entorno DOS de 16 bits |
| [NASM](https://www.nasm.us/) | 2.14+ | Ensamblador (Netwide Assembler) |
| [ALINK](http://alink.sourceforge.net/) | 1.6+ | Enlazador compatible con formato OMF |

### Estructura en la carpeta de trabajo (host)

```
Torres-post2-u4\
├── nasm.exe
├── alink.exe
├── macros.asm
├── programa2.asm
└── capturas\
```

---

## Compilación y Ejecución

### 1. Montar la carpeta en DOSBox

```dosbox
mount C C:\ruta\a\Torres-post2-u4
C:
```

### 2. Ensamblar (con listado de expansión de macros)

```dosbox
nasm -f obj programa2.asm -o programa2.obj -l programa2.lst
```

El archivo `programa2.lst` muestra el código máquina generado y **la expansión de cada macro** invocada, lo que permite verificar que `print_str`, `repetir_str` y `fin_dos` se expanden correctamente.

### 3. Enlazar

```dosbox
alink programa2.obj -oEXE -o programa2.exe -entry main
```

### 4. Ejecutar

```dosbox
programa2.exe
```

---

## Salida esperada

```
=== Macros y Control de Flujo ===
------------------------------------
[Linea A] Primera impresion
[Linea A] Primera impresion
[Linea A] Primera impresion
[Linea B] Segunda impresion
[Linea B] Segunda impresion
------------------------------------
Suma 1+2+3 = 6
------------------------------------
-- Comparacion 9 vs 4 --
El valor mayor es: 9
------------------------------------
-- Comparacion 5 vs 5 --
Los valores son iguales.
------------------------------------
Fin del programa.
```

---

## Descripción técnica

### Macros (`macros.asm`)

| Macro | Parámetros | Función |
|-------|-----------|---------|
| `fin_dos` | 0 | Termina el proceso con `INT 21h` función `4Ch` |
| `nueva_linea` | 0 | Imprime CR+LF con función `02h` |
| `print_str` | 1 — dirección de cadena | Imprime cadena `$`-terminada con función `09h` |
| `print_char` | 1 — valor ASCII | Imprime un carácter con función `02h` |
| `leer_char` | 0 | Lee carácter sin eco con función `07h` (resultado en `AL`) |
| `repetir_str` | 2 — cadena, N | Imprime la cadena N veces usando `LOOP` con etiqueta `%%ciclo` |
| `print_digito` | 0 | Convierte nibble bajo de `AL` a ASCII e imprime |

### Procedimientos

**`sumar_serie`**
- Entrada: `CX = N`
- Salida: `AX = 1+2+…+N`
- Usa `LOOP` para decrementar `CX`; preserva `CX` con `push`/`pop`

**`comparar_e_imprimir`**
- Entrada: `AX` = valor 1, `BX` = valor 2 (ambos 0–9)
- Usa `CMP` → `JE` → `JG` para tres ramas: `BX mayor`, `AX mayor`, `iguales`
- Preserva `AX` y `BX` mediante variables en `.bss`

---

## Historial de Commits

| # | Mensaje | Contenido |
|---|---------|-----------|
| 1 | `Inicializar repositorio laboratorio Post2 U4` | README, .gitignore |
| 2 | `Agregar biblioteca de macros y programa base con repetir_str` | macros.asm, programa2.asm (secciones y macros) |
| 3 | `Implementar sumar_serie y comparar_e_imprimir con CMP/JG/JE` | programa2.asm final, capturas |

---

## Capturas de Pantalla

- `capturas/compilacion.png` — DOSBox mostrando `nasm` y `alink` sin errores, y el archivo `.lst` generado
- `capturas/ejecucion.png` — DOSBox mostrando la salida completa de `programa2.exe`

---

## Autor

Laboratorio desarrollado para la asignatura **Arquitectura de Computadores** — Unidad 4, Post2.

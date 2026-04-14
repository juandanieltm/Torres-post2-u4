; ============================================================
; macros.asm — Biblioteca de macros utilitarias DOS
; Laboratorio Post2 Unidad 4 — Arquitectura de Computadores
; Incluir con: %include "macros.asm"
; ============================================================

; ── Macro: terminar programa DOS con código de salida 0 ─────
%macro fin_dos 0
    mov ax, 4C00h
    int 21h
%endmacro

; ── Macro: imprimir nueva línea (CR + LF) ───────────────────
%macro nueva_linea 0
    mov ah, 02h
    mov dl, 0Dh         ; CR
    int 21h
    mov dl, 0Ah         ; LF
    int 21h
%endmacro

; ── Macro: imprimir cadena terminada en "$" ─────────────────
; %1 = etiqueta de la cadena
%macro print_str 1
    mov ah, 09h
    mov dx, %1
    int 21h
%endmacro

; ── Macro: imprimir un carácter único ───────────────────────
; %1 = valor ASCII (inmediato o registro byte)
%macro print_char 1
    mov ah, 02h
    mov dl, %1
    int 21h
%endmacro

; ── Macro: leer un carácter desde teclado (sin eco) ─────────
; Resultado queda en AL
%macro leer_char 0
    mov ah, 07h
    int 21h
%endmacro

; ── Macro: imprimir cadena N veces ──────────────────────────
; %1 = etiqueta de la cadena
; %2 = número de repeticiones (inmediato numérico)
%macro repetir_str 2
    mov cx, %2          ; CX = contador de repeticiones
%%ciclo:                ; %% → etiqueta local única por expansión
    mov ah, 09h
    mov dx, %1
    int 21h
    loop %%ciclo        ; CX--; si CX != 0, repetir
%endmacro

; ── Macro: imprimir dígito decimal (0-9) desde AL ───────────
; Convierte el nibble bajo de AL a su carácter ASCII y lo imprime
%macro print_digito 0
    push ax             ; preservar AX
    and al, 0Fh         ; asegurar nibble bajo (0–9)
    add al, 30h         ; convertir a ASCII: 0→'0', 9→'9'
    mov ah, 02h
    mov dl, al
    int 21h
    pop ax              ; restaurar AX
%endmacro

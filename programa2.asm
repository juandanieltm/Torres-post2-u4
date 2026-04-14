; ============================================================
; programa2.asm — Laboratorio Post2 Unidad 4
; Arquitectura de Computadores
;
; Propósito: demostrar el uso de macros con parámetros,
;            bucles con LOOP (sumar_serie) y control de flujo
;            condicional con CMP / JG / JE (comparar_e_imprimir).
;
; Ensamblador: NASM 2.14+   (formato OMF para DOS de 16 bits)
; Enlazador:   ALINK
; Entorno:     DOSBox 0.74+
;
; Compilación:
;   nasm -f obj programa2.asm -o programa2.obj -l programa2.lst
;   alink programa2.obj -oEXE -o programa2.exe -entry main
; ============================================================

%include "macros.asm"       ; incluir biblioteca de macros utilitarias

; ── Datos inicializados (.data) ─────────────────────────────
section .data

    titulo      db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    separador   db "------------------------------------", 0Dh, 0Ah, 24h
    linea_a     db "[Linea A] Primera impresion",        0Dh, 0Ah, 24h
    linea_b     db "[Linea B] Segunda impresion",        0Dh, 0Ah, 24h

    msg_suma    db "Suma 1+2+3 = ",        24h
    msg_mayor   db "El valor mayor es: ",  24h
    msg_iguales db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_comp1   db "-- Comparacion 9 vs 4 --", 0Dh, 0Ah, 24h
    msg_comp2   db "-- Comparacion 5 vs 5 --", 0Dh, 0Ah, 24h
    msg_fin     db "Fin del programa.",    0Dh, 0Ah, 24h

; ── Datos no inicializados (.bss) ───────────────────────────
section .bss

    valor_a     resw 1      ; almacena AX para comparar_e_imprimir
    valor_b     resw 1      ; almacena BX para comparar_e_imprimir

; ── Código ejecutable (.text) ───────────────────────────────
section .text

global main

; ============================================================
; MAIN — punto de entrada
; ============================================================
main:
    mov ax, @data
    mov ds, ax              ; DS apunta a la seccion .data

    ; ── 1. Encabezado ──────────────────────────────────────
    print_str titulo
    print_str separador

    ; ── 2. Demostracion de repetir_str ─────────────────────
    repetir_str linea_a, 3  ; imprime linea_a exactamente 3 veces
    repetir_str linea_b, 2  ; imprime linea_b exactamente 2 veces
    print_str separador

    ; ── 3. Suma acumulativa 1+2+3 = 6 ─────────────────────
    print_str msg_suma
    mov cx, 3               ; N = 3  →  1+2+3 = 6
    call sumar_serie        ; resultado: AX = 6
    print_digito            ; imprime nibble bajo de AX → '6'
    nueva_linea
    print_str separador

    ; ── 4. Comparar 9 vs 4 → mayor es 9 ───────────────────
    print_str msg_comp1
    mov ax, 9
    mov bx, 4
    call comparar_e_imprimir
    print_str separador

    ; ── 5. Comparar 5 vs 5 → iguales ───────────────────────
    print_str msg_comp2
    mov ax, 5
    mov bx, 5
    call comparar_e_imprimir
    print_str separador

    ; ── 6. Mensaje de fin y salida ─────────────────────────
    print_str msg_fin
    fin_dos                 ; macro: mov ax,4C00h / int 21h

; ============================================================
; PROCEDIMIENTO: sumar_serie
; Calcula 1 + 2 + 3 + ... + N usando LOOP como contador.
; Entrada:  CX = N
; Salida:   AX = suma total
; Preserva: CX (restaurado con push/pop)
; ============================================================
sumar_serie:
    push cx                 ; preservar CX (LOOP lo decrementa)
    xor ax, ax              ; AX = 0  (acumulador)
.paso:
    add ax, cx              ; AX += CX  →  suma N + (N-1) + ... + 1
    loop .paso              ; CX--; si CX != 0, continuar
    pop cx                  ; restaurar valor original de CX
    ret

; ============================================================
; PROCEDIMIENTO: comparar_e_imprimir
; Compara AX y BX e imprime cual es mayor o si son iguales.
; Entrada:  AX = primer valor, BX = segundo valor (0-9 c/u)
; Salida:   pantalla
; Preserva: AX, BX (guardados en .bss y restaurados al final)
; ============================================================
comparar_e_imprimir:
    mov [valor_a], ax       ; guardar AX en memoria
    mov [valor_b], bx       ; guardar BX en memoria

    cmp ax, bx              ; actualiza flags: AX - BX (no modifica operandos)
    je  .son_iguales        ; ZF=1  →  AX == BX
    jg  .ax_mayor           ; SF=OF y ZF=0  →  AX > BX (con signo)

    ; ── Caso: BX es mayor ──────────────────────────────────
    print_str msg_mayor
    mov ax, [valor_b]       ; AL = valor de BX
    print_digito            ; imprime digito
    nueva_linea
    jmp .fin_comp

.ax_mayor:
    ; ── Caso: AX es mayor ──────────────────────────────────
    print_str msg_mayor
    mov ax, [valor_a]       ; AL = valor de AX
    print_digito            ; imprime digito
    nueva_linea
    jmp .fin_comp

.son_iguales:
    ; ── Caso: AX == BX ─────────────────────────────────────
    print_str msg_iguales

.fin_comp:
    mov ax, [valor_a]       ; restaurar AX
    mov bx, [valor_b]       ; restaurar BX
    ret

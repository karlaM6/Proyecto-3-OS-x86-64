; kernel.asm
;

org 0x500

;******************************************
; Definición de funciones
;******************************************

; Función para obtener un carácter desde el teclado
get_char:
    mov ah, 0
    int 16h
    movzx eax, al
    ret

; Función para imprimir una cadena de caracteres
print_string:
    mov ah, 0x0e
    mov si, 0  ; Inicializar el índice del puntero a la cadena
.print_loop:
    lodsb      ; Cargar el byte apuntado por SI en AL y aumentar SI
    cmp al, 0  ; ¿Es el final de la cadena (carácter nulo)?
    je .done   ; Si es así, salimos del bucle
    int 0x10   ; Llamada a la interrupción 0x10 para imprimir el carácter
    jmp .print_loop  ; Volver al inicio del bucle
.done:
    ret

; Función para escribir por pantalla un mensaje
print_message:
    mov ah, 0x0e
    mov al, [si] ; Corrected line
    int 0x10
    ret

; Función para leer una cadena de caracteres por pantalla
read_string:
    mov si, message
    mov cx, 32
    .loop:
        call get_char
        cmp al, 0x0d
        je .end
        mov [si], al
        inc si
        loop .loop
    .end:
    mov byte [si], 0x00

    ret

; Función para desplegar un menú de dos opciones
display_menu:
    mov si, menu
    .loop:
        call print_string
        call get_char
        cmp al, '1'
        je .read
        cmp al, '2'
        je .write
        cmp al, 'q'
        je .exit
        jmp .loop
    .read:
        call read_string
        jmp .print
    .write:
        call print_string
        jmp .loop
    .print:
        call print_string
        jmp .loop
    .exit:
        ret

;******************************************
; Funciones principales
;******************************************

; Mensaje a mostrar
message db 32 dup(0) ; Cambiado para permitir almacenar más caracteres

; Menú de opciones
menu db "1. Leer", 0x0d, 0x0a
     db "2. Escribir", 0x0d, 0x0a
     db "q. Salir", 0x0d, 0x0a
;******************************************


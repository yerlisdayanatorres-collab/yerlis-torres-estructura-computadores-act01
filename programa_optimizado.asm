# Laboratorio: Estructura de Computadores
# Actividad: Optimización de Pipeline en Procesadores MIPS
# Objetivo: Calcular Y[i] = A * X[i] + B e identificar riesgos de datos.

.data
    vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8
    vector_y: .space 32          # Espacio para 8 enteros (8 * 4 bytes)
    const_a:  .word 3
    const_b:  .word 5
    tamano:   .word 8

.text
.globl main

main:
    # --- InicializaciÃ³n ---
    la $s0, vector_x      # DirecciÃ³n base de X
    la $s1, vector_y      # DirecciÃ³n base de Y
    lw $t0, const_a       # Cargar constante A
    lw $t1, const_b       # Cargar constante B
    lw $t2, tamano        # Cargar el tamaÃ±o del vector
    li $t3, 0             # Ã?ndice i = 0

loop:
    beq  $t3, $t2, fin        # Si i==N → fin

    sll  $t4, $t3, 2          # t4 = i*4
    addu $t5, $s0, $t4        # t5 = &X[i]

    lw   $t6, 0($t5)          # X[i] (productor)
    # Instrucción INDEPENDIENTE para ocultar latencia del lw:
    addu $t9, $s1, $t4        # t9 = &Y[i]

    mul  $t7, $t6, $t0        # t7 = X[i]*A
    # Otra INDEPENDIENTE para separar mul→addu:
    addi $t3, $t3, 1          # i++

    addu $t8, $t7, $t1        # t8 = X[i]*A + B
    sw   $t8, 0($t9)          # Y[i] = t8
    j    loop

fin:
    # --- FinalizaciÃ³n del programa ---
    li $v0, 10            # Syscall para terminar ejecuciÃ³n
    syscall

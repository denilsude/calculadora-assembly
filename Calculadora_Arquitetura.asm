;Disciplina: Arquitetura de Computadores - PUCGO 2024
;Aluno(s): Denilson Oliveira da Silva
;Curso: Ciência da Computação
;Trabalho: Fazer uma calculadora que soma, subtrai, multiplica e divide. O usuário vai informar dois números e a operação que deseja realizar (usando os caracteres +,-,*,/). Ao término da operação, deverá ser opcional ao usuário realizar uma nova operação ou sair do programa.


global main

section .data ;Declaração de Constantes
    fmt db "%lf", 0
    fmtChar db "%*c%c", 0

    msg1 db "Insira o Primeiro Número: ", 0
    msg2 db "Insira o Segundo Número: ", 0
    msg3 db "Insira o Operador: ", 0

    msgEnd db "Código Encerrado! Operador Vazio.", 10, 0

    msgResult db "Resultado: %.4lf", 10, 10, 0

    msgOperador db "Insira um Operador Válido!", 10, 10, 0

    msgMenu db "*** Calculadora Básica - Linguagem de Montagem (NASM) ***", 10, 0
    msgMenu2 db " -> Operações:", 10, "     * :Multiplicação", 10, "     + :Soma", 10, "     - :Subtração", 10, "     / :Divisão", 10, 10, 0

section .bss ; Declaração de Variáveis
    num resq 1
    num2 resq 1
    op resb 4

section .text ; Secção de Texto

main: ; Função Principal

menu_msg:
    mov rdi, msgMenu
    call print_string

menu_op:
    mov rdi, msgMenu2
    call print_string

ler_op1:
    mov rdi, msg1
    call print_string
    call read_double
    movsd xmmword [num], xmm0

ler_operador:
    mov rdi, msg3
    call print_string
    call read_char
    mov byte [op], al

    mov ebx, 10        ; Verifica se o operador é Enter
    cmp byte [op], bl
    je fim

ler_op2:
    mov rdi, msg2
    call print_string
    call read_double
    movsd xmmword [num2], xmm0

def_operador:      ;Função para definir o operador
    movq xmm0, qword [num]
    
    mov bl, '+'
    cmp byte [op], bl
    je adicao

    mov bl, '-'
    cmp byte [op], bl
    je subtracao

    mov bl, '*'
    cmp byte [op], bl
    je multiplicacao

    mov bl, '/'
    cmp byte [op], bl
    je divisao

    jmp novo_operador ;Caso o operador digitado nao exista
    
subtracao:      ;Funcao de Subtracao
    subsd xmm0, [num2]
    jmp exibir

adicao:         ;Funcao de Adicao
    addsd xmm0, [num2]
    jmp exibir

multiplicacao:  ;Funcao de Multiplicacao
    mulsd xmm0, [num2]
    jmp exibir

divisao:        ;Funcao de Divisao
    divsd xmm0, [num2]
    jmp exibir

novo_operador: ;Mensagem para inserir um novo operador e jump para operador
    mov rdi, msgOperador
    call print_string

    jmp ler_operador ; Volta para o operador

exibir:         ;Funcao para exibir resultado  
    movq [num], xmm0  
    mov rdi, msgResult
    call print_string
    jmp ler_operador

fim:            ;Funcao para encerrar o código
    mov rdi, msgEnd
    call print_string
    ret

print_string:
    ; Função para imprimir strings
    mov rax, 0x1
    mov rsi, rdi
    mov rdx, 0
    ; Calcula o tamanho da string
    xor rcx, rcx
    while_char:
        cmp byte [rsi + rcx], 0
        je end_while
        inc rcx
        jmp while_char
    end_while:
    ; Atualiza o tamanho
    mov rdx, rcx
    ; Chama a syscall write
    mov rax, 0x1
    mov rdi, 0x1
    syscall
    ret

read_double:
    ; Função para ler um double
    mov rax, 0x0
    mov rdi, 0x0
    mov rsi, rsp
    mov rdx, 0x20
    syscall
    movq xmm0, [rsp]
    add rsp, 0x20
    ret

read_char:
    ; Função para ler um caractere
    mov rax, 0x0
    mov rdi, 0x0
    mov rsi, rsp
    mov rdx, 0x1
    syscall
    mov al, byte [rsp]
    add rsp, 0x1
    ret

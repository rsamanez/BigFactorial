; Exercise
;=================================================================================================
;Calculate factorial up to 40000
;
; Algorithm
;multiply(a[1..p], b[1..q], base)                            // Operands containing rightmost digits at index 1
;  product = [1..p+q]                                        // Allocate space for result
;  for b_i = 1 to q                                          // for all digits in b
;    carry = 0
;    for a_i = 1 to p                                        // for all digits in a
;      product[a_i + b_i - 1] += carry + a[a_i] * b[b_i]
;      carry = product[a_i + b_i - 1] / base
;      product[a_i + b_i - 1] = product[a_i + b_i - 1] mod base
;    product[b_i + p] = carry                               // last digit comes from final carry
;  return product
;
;=================================================================================================
; Compile with:
;     nasm -f elf64 -o bigFactorialNumber64.o bigFactorialNumber64.asm
; Link with:
;     ld -m elf_x86_64 -o bigFactorialNumber64 bigFactorialNumber64.o
; Run with:
;     ./bigFactorialNumber64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================

global _start

%include 'basicFunctions.asm'


section .data
 buff1: times 400000 db '-'
 buff2: times 8 db '-'
 result: times 400004 db 0
 printable: times 400000 db 0
 carry: db 0
 msg1: db "Factorial of [",0
 msg2: db "]=",0

section .text

getSize:            ; buffer RSI   return size in RBX
    mov rbx,-1
.getSizex0:
    inc rbx
    cmp byte[rsi+rbx],'-'
    jnz .getSizex0
    ret

resetResult:
    push rbx
    mov rbx,0
.resetloopx1:
    mov byte[result+rbx],0
    inc rbx
    cmp rbx,40004
    jnz .resetloopx1
    pop rbx
    ret

 _start:

;   move to buffer in inverse order
    mov byte[buff1],1
    mov byte[buff2],2

.nextNumber:
    mov rsi,buff1
    call getSize
    mov r8,rbx          ;  R8 = q
    mov rsi,buff2
    call getSize
    mov r9,rbx          ;  R9 = p

    mov rdx,0           ;  $i=0
.forA:
    mov byte[carry],0               ; carry = 0
    mov rcx,0           ;  $j=0
.forB:
    mov al,byte[buff1+rdx]          ;  $a[$i]
    mov bl,byte[buff2+rcx]          ;  $b[$j]
    mul bl                          ; al = al * bl
    add al,byte[carry]              ; al = al + carry
    add byte[result+rcx+rdx],al     ; $result[$j+$i] = $result[$j+$i] + $carry + $b[$j]*$a[$i];
    mov bl,10
    mov ah,0
    mov al,byte[result+rcx+rdx]
    div bl                          ; AX/bl ==>  AL=Quotient, AH=Remainder
    mov byte[carry],al              ; $carry = intdiv ( $result[$j+$i],10);
    mov byte[result+rcx+rdx],ah     ; $result[$j+$i] = $result[$j+$i] % 10;
    inc rcx
    cmp rcx,r9
    jnz .forB
    mov byte[result+rdx+r9],al    ; $result[$i+p] = $carry;
    inc rdx
    cmp rdx,r8
    jnz .forA

    push r9
    mov rax,r9
    add rax,rdx
    mov r9,rax
    mov r10,rax
    mov rbx,0
.loopx1:
    mov al,byte[result+rbx]
    mov byte[buff1+rbx],al          ; moving result to buffer1
    add al,48
    dec r10
    mov byte[printable+r10],al
    inc rbx
    cmp rbx,r9
    jnz .loopx1

    pop r9
    mov r8,0
    mov rcx,0
    mov rbx,1

                            ; Convert buff2 a NUMERO
.loopx2:
    mov rax,0
    mov al,byte[buff2+rcx]
    mul rbx                 ; RDX:RAX = RAX * RBX
    add r8,rax
    mov rax,rbx
    mov rbx,10
    mul rbx                 ; RDX:RAX = RBX * 10
    mov rbx,rax
    inc rcx
    cmp rcx,r9
    jnz .loopx2
    inc r8                  
    cmp r8,40002
    jz _end              ; END where R8=10002 ==> Factorial of 40000
                         ; load buff2 with the new number
    mov rcx,0
    mov rax,r8
    mov rbx,10
.loopx3:
    mov rdx,0
    div rbx
    mov byte[buff2+rcx],dl
    inc rcx
    cmp rax,0
    jnz .loopx3
    call resetResult

    ; print the results on screen
    mov rsi,msg1
    call print
    mov rax,r8
    dec rax
    call printnumber
    mov rsi,msg2
    call println

    mov rsi,printable
    mov rax,0
.loopx6:
    cmp byte[rsi+rax],'0'
    jnz .loopx5
    inc rax
    jmp .loopx6
.loopx5:
    add rsi,rax
    call println
    call printnewline
    jmp .nextNumber

_end:

    call exit

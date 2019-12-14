; A list of basic functions to print and scan
; numbers and strings
; how to use this file:
;   %include 'basicFunctions.asm'
;==============================================================================
; Author : Rommel Samanez 
;==============================================================================
section .data
  newline: db 0ah,0
  buffer: times 100 db 0

;==============================================================================
  ; strlen usage
  ;  mov rsi,message
  ;  call strlen
  ;  RETURN rdx : string length
  ;------------------------------------------------------------------------------
  strlen:
    	mov rdx,0
        .stradd:
    	cmp byte[rsi+rdx],0
    	jz .strend
    	inc rdx
    	jmp .stradd
        .strend:
    	ret
  ;------------------------------------------------------------------------------
  ;  print usage
  ;	mov rsi,message  - message end  in 0
  ;	call print
  ;------------------------------------------------------------------------------
  print:
  	push rax
  	push rdi
  	push rdx
  	call strlen
  	mov rax,1
  	mov rdi,1
  	syscall
  	pop rdx
  	pop rdi
  	pop rax
  	ret
  ;------------------------------------------------------------------------------
  ;   println usage
  ;	mov rsi,message - message end in 0
  ;	call println
  ;------------------------------------------------------------------------------
  println:
  	call print
  	push rsi
  	mov rsi,newline
  	call print
  	pop rsi
  	ret
  ;-----------------------------------------------------------------------------
  printnewline:
    push rsi
    mov rsi,newline
    call print
    pop rsi
    ret
  ;-----------------------------------------------------------------------------
  ;    printnumber  usage
  ;	 mov rax,number
  ;  call printnumber
  ;------------------------------------------------------------------------------
  printnumber:
  	push rbx
  	push rsi
  	mov rbx,21
  	call numbertobuff
  	mov rsi,buffer
  .pnfl03:
  	cmp byte[rsi],32
  	jnz .pnfl04
  	inc rsi
  	jmp .pnfl03
  .pnfl04:
  	call print
  	pop rsi
  	pop rbx
  	ret
  ;------------------------------------------------------------------------------
  ;   printnumberf usage
  ;       mov rax,number to print
  ;       mov rbx,length   length to print filled with spaces in the left
  ;       call printnumberf
  ;------------------------------------------------------------------------------
  printnumberf:
  	push rsi
  	call numbertobuff
  	mov rsi,buffer
  	call println
  	pop rsi
  	ret
  ;------------------------------------------------------------------------------
  numbertobuff:
  	push rcx
  	push rdx
    mov rcx,0ah
  	mov byte[buffer+rbx+1],0
  .pnfl01:
  	dec rbx
    mov rdx,0
    div rcx         ; RDX:RAX / RCX  -->  Q=RAX  R=RDX
    add rdx,48
    cmp rax,0
    jnz .pnfl02
    cmp rdx,48
    jnz .pnfl02
    mov rdx,32
  .pnfl02:
  	mov byte[buffer+rbx],dl
    cmp rbx,0
    jnz .pnfl01
  	pop rdx
  	pop rcx
  	ret
  ;------------------------------------------------------------------------------
  ; bufftonumber usage
  ; call scanf
  ; call bufftonumber
  ; RETURN readed number on RAX
  ;------------------------------------------------------------------------------
  bufftonumber:
  	push rcx
  	push rbx
  	push rdx
  	push rdi
  	mov rbx,0   ; looking for the end
  .buffx1:
  	mov cl,byte[buffer+rbx]
  	cmp cl,0ah
  	jz  .buffx2
  	inc rbx
  	jmp .buffx1
  .buffx2:
  	mov rdi,0
  	mov rcx,1
  .buffx3:
  	mov rax,0
  	mov al,byte[buffer+rbx-1]
  	sub al,48                      ; subtract ASCII of 0
  	mov rdx,0
  	mul rcx
  	add rdi,rax
  	mov rdx,0
  	mov rax,10
  	mul rcx
  	mov rcx,rax
  	dec rbx
  	jnz .buffx3
  	mov rax,rdi
  	pop rdi
  	pop rdx
  	pop rbx
  	pop rcx
  	ret

  ;------------------------------------------------------------------------------
  ; exit the Program
  ; call exit
  ;------------------------------------------------------------------------------
  exit:
  	mov rax,60
  	mov rdi,0
  	syscall
  ;------------------------------------------------------------------------------
  ;  scanf usage
  ;  call scanf
  ; RETURN the readed string in the buffer memory variable
  ;------------------------------------------------------------------------------
  scanf:
  	push rax
  	push rdi
  	push rdx
  	mov rax,0
  	mov rdi,1
  	mov rsi,buffer
  	mov rdx,100      ;  max 100 characters string
  	syscall
  	pop rdx
  	pop rdi
  	pop rax
  	ret
  ;------------------------------------------------------------------------------

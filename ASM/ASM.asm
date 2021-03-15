.586
.model flat, stdcall
includelib StandartLib.lib
includelib kernel32.lib
includelib libucrt.lib

ExitProcess PROTO : DWORD
copystr PROTO : DWORD, : DWORD
joinst PROTO : DWORD, : DWORD
outstr PROTO : DWORD
outint PROTO : SDWORD 
.stack 4096
.const
	overflow db 'ERROR: VARIABLE OVERFLOW', 0 
	null_division db 'ERROR: DIVISION BY ZERO', 0
	L1 SDWORD -7
	L2 SDWORD 3
	L3 SDWORD 1
	L4 BYTE "hello ", 0
	L5 BYTE "world ", 0
	L6 SDWORD 45
	L7 SDWORD 15
	L8 SDWORD 5
	L9 SDWORD 122
	L10 BYTE "hi", 0
.data
	Funcz SDWORD 0
	headx SDWORD 0
	heady SDWORD 0
	headg SDWORD 0
	headm BYTE 255 DUP(0)
	headn BYTE 255 DUP(0)
	headq BYTE 255 DUP(0)
.code

Func_proc PROC, Funcx : SDWORD, Funcy : SDWORD
	push Funcx
	push L1
	push Funcy
	pop eax
	pop ebx
	add eax, ebx
	jo EXIT_OVERFLOW
	push eax
	pop eax
	pop ebx
	imul eax, ebx
	jo EXIT_OVERFLOW
	push eax
	push L2
	pop ebx
	pop eax
	test ebx,ebx
	jz EXIT_DIV_ON_NULL
	cdq
	idiv ebx
	push edx
	pop Funcz
	push Funcz

	jmp EXIT
	EXIT_DIV_ON_NULL:
	push offset null_division
	call outstr
	push - 1
	call ExitProcess

	EXIT_OVERFLOW:
	push offset overflow
	call outstr
	push - 2
	call ExitProcess

	EXIT:
	pop eax
	ret 8

	push 0
	call ExitProcess

Func_proc ENDP

main PROC
	push L3
	pop headg
	push offset L4
	push offset headm
	call copystr

	push offset L5
	push offset headn
	call copystr

	CYCLE: 
	push headx
	push L7
	pop eax
	pop ebx
	add eax, ebx
	jo EXIT_OVERFLOW
	push eax
	pop headx
	cmp eax,L6 
	je NEXT
	loop CYCLE
	NEXT:
	push headx
	call outint

	push L9
	push L8
	call Func_proc
	push eax
	call outint

	push offset L10
	call outstr

	push offset headm
	push offset headn
	call joinst
	push eax
	push offset headq
	call copystr

	push offset headq
	call outstr

	push offset headn
	push offset headm
	call joinst
	jo EXIT_OVERFLOW
	push eax
	push offset headq
	call copystr

	push offset headq
	call outstr


	jmp EXIT
	EXIT_DIV_ON_NULL:
	push offset null_division
	call outstr
	push - 1
	call ExitProcess

	EXIT_OVERFLOW:
	push offset overflow
	call outstr
	push - 2
	call ExitProcess

	EXIT:
	pop eax
	ret 0

	push 0
	call ExitProcess

main ENDP
end main
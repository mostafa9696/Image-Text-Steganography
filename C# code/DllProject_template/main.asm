include irvine32.inc

.data
MAX_BUFFER_SIZE EQU 27000000
Buffer BYTE MAX_BUFFER_SIZE DUP(?)
Acual_Buffer_Size DWORD ?
FileHandle HANDLE ?

.code


;================================================================
; Read The Image From The File Write It Into The Buffer
; Receives : The Offset Of The Path
; Returns  : 0 In EBX If File has Read Successfully else
;			 Returns 1. 
;================================================================
FillBuffer PROC Path:PTR DWORD
	PUSH EDX 

	MOV EDX , Path
	CALL OpenInputFile  ;Open File For Reading
	CMP EAX , INVALID_HANDLE_VALUE
	JE Error

	MOV FileHandle , EAX
	MOV EDX , Offset Buffer
	MOV ECX , MAX_BUFFER_SIZE
	CALL ReadFromFile
	JC CLOSE   ; Didn't Read Successfully 
	MOV Acual_Buffer_Size , EAX   ; Number Of Bytes Readed Successfully Into The Buffer


	CLOSE:
		MOV EAX,FileHandle
		CALL CloseFile
		JNC EndSuccessfully

	Error:
		MOV EBX , 1
		JMP ENDPROGRAM

	EndSuccessfully:
		MOV EBX , 0

	ENDPROGRAM:

	POP EDX
	RET
FillBuffer ENDP

;Write your functions here
;Do not forget to modify main.def file accordingly 


; DllMain is required for any DLL
DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD 

mov eax, 1		; Return true to caller. 
ret 				
DllMain ENDP

END DllMain

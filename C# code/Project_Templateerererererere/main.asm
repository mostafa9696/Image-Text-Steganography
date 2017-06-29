
INCLUDE Irvine32.inc
.data
MAX_BUFFER_SIZE = 999999
BufferSTR byte MAX_BUFFER_SIZE DUP(?)
BufferINT DWord MAX_BUFFER_SIZE DUP(?) 
Acual_Buffer_SizeSTR DWORD ?
Acual_Buffer_SizeINT DWORD ?
Bytes_Written DWORD ?
FileHandle HANDLE ?
PathRead Byte "C:\Users\ibrahim\Desktop\ImagePixels2.txt" , 0
PathWrite Byte "C:\Users\ibrahim\Desktop\ImagePixels3.txt" , 0

MyString byte "This Is My String" , 0
Key byte 01101100b 


.code
main PROC
	
	;Comment #     ;Reading From File And Converting Char Array To Integer Array
	MOV EBX , 1
	CALL FillBuffer

	MOV ESI , Offset BufferSTR
	MOV EDI , Offset BufferINT
	MOV ECX , Acual_Buffer_SizeSTR
	CALL Convert_Char_To_Integer
	MOV EAX , EBX 
	CALL WriteDec
	CALL CRLF

	MOV ESI , Offset BufferINT
	MOV ECX , Acual_Buffer_SizeINT
	L2:
		MOV EAX , [ESI]
		CALL WriteDec
		ADD ESI , 4
		CALL CRLF
	LOOP L2

	MOV EAX ,  Acual_Buffer_SizeINT
	CALL WriteDec
	CALL CRLF
	
		;#


		;Comment !
	MOV EDX , Offset PathWrite
	CALL CreateOutPutFile
	CMP EAX , INVALID_HANDLE_VALUE
	JE Error
	MOV FileHandle , EAX

	MOV EAX , FileHandle
	MOV EDX , Offset BufferINT
	MOV ECX , Acual_Buffer_SizeINT
	CALL WriteToFile
	JC Error
	MOV Bytes_Written , EAX
	MOV EAX , Bytes_Written
	CALL WriteDec
	JMP Success

	Error:
		CALL WriteWindowsMsg
	Success:
	;!
	exit
main ENDP






;================================================================
; Read The Image From The File Write It Into The Buffer
; Receives : The Offset Of The Path
; Returns  : 0 In EBX If File has Read Successfully else
;			 Returns 1. 
;================================================================
FillBuffer PROC 
	PUSH EDX 

	MOV EDX , Offset PathRead
	CALL OpenInputFile  ;Open File For Reading
	CMP EAX , INVALID_HANDLE_VALUE
	JE Error

	MOV FileHandle , EAX
	MOV EDX , Offset BufferSTR
	MOV ECX , MAX_BUFFER_SIZE
	CALL ReadFromFile
	JC CLOSE   ; Didn't Read Successfully 
	MOV Acual_Buffer_SizeSTR , EAX   ; Number Of Bytes Readed Successfully Into The Buffer


	CLOSE:
		MOV EAX,FileHandle
		CALL CloseFile
		JNC EndSuccessfully

	Error:
		MOV EBX , 1
		CALL WriteWindowsMsg
		JMP ENDPROGRAM

	EndSuccessfully:
		MOV EBX , 0

	ENDPROGRAM:

	POP EDX
	RET
FillBuffer ENDP




;================================================================
; Convert From Char Array To Integer Array
; Receives : ESI The Offset Of The Char Array
;			 EDI The Offset Of The Integer Array
;			 ECX The Number Of Chars
; Returns  : EBX The Acual Number Of Numbers 
;			 The Array Converted To Integers
;================================================================
Convert_Char_To_Integer PROC
	MOV EBX , 0
	MOV EDX , 0	

	L1:
	MOV AL , [ESI] ;Takes The Char From Char Array
	CMP AL , 10  ;Indicates If The Char is \n NewLine
	JNE LastNum
	JMP NewLine
	ADD ESI , 1

	LastNum:
		CMP AL , 13  ;Indicates If The Char is End of The Line
		JE ENDLOP    ; Don't Append On The Number
		PUSH ECX            ; Save ECX Value Inside The Stack
		MOV ECX , 0			; Clear ECX
		MOV CL , AL			;
		SUB CL , '0'		;  {{
		MOV AX , DX			;
		MOV DX , 10			;	Convert Char To Int and Append On EDX
		MUL DX				;
		ADD EAX ,ECX		;                 }}
		MOV EDX , EAX		; MOV The Number From EAX To EDX
		POP ECX				; Return ECX Value From The Stack
		JMP ENDLOP
	NewLine:
		MOV [EDI] , EDX		; MOV The Whole Number To EDI 
		MOV EDX , 0			; Clear EDX
		INC EBX
		ADD EDI , 4
	ENDLOP:
	INC ESI
LOOP L1

MOV Acual_Buffer_SizeINT , EBX

	RET
Convert_Char_To_Integer ENDP




;==========================================================
; Encrypt The Message With XOR Cipher Scheme
; Receives : ESI Has The Offset Of Message
;			 ECX The Message Length
;==========================================================
Encrypt PROC uses ESI ECX
	L1:
		MOV AL , [ESI];	 {{
		CMP AL , ' ';
		JE Skip;
		XOR AL , Key;		Encrypting
		MOV [ESI] , AL;
		Skip:;
		INC ESI;
	LOOP L1;										}}
	
	RET
Encrypt ENDP



;==========================================================
; Decrypt The Message With XOR Cipher Scheme
; Receives : ESI Has The Offset Of Message
;			 ECX The Message Length
;==========================================================
Decrypt PROC uses ESI ECX
	L2:
		MOV AL , [ESI];			{{
		CMP AL , ' ';
		JE Skip2;
		XOR AL , Key;				Decrypting
		MOV [ESI] , AL;
		Skip2:;
		INC ESI;									}}
	LOOP L2;

	RET
Decrypt ENDP
END main
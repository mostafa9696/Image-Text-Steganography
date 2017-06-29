
INCLUDE Irvine32.inc
.data
MAX_BUFFER_SIZE = 99999
BufferSTR byte MAX_BUFFER_SIZE DUP(?)
BufferINT DWord MAX_BUFFER_SIZE DUP(?)
BufferSTRFile DWORD MAX_BUFFER_SIZE DUP('0') 
Acual_Buffer_SizeSTR DWORD ?
Acual_Buffer_SizeINT DWORD ?
Acual_Buffer_SizeSTRFile DWORD ?
Bytes_Written DWORD	?
FileHandle HANDLE ?
PathRead Byte "E:\iti\read.txt" , 0
PathWrite Byte "E:\iti\write.txt" , 0
StringMsg byte 1002 DUP(?)
STmenu byte  "To hide messsage press 1 ,,,,, To retrive message press 2 ,,,, To exit press 3",0
hided byte  "The message hide successfuly .",0
messageOUT byte  "Enter the message wich you want to hide : ",0
messageHide byte 100 dup(?),0
HideLentgh dword ?
ActualSize dword ?
ans byte 8 dup(?)

DigitsChar Byte 4 DUP('0')

Key byte 01101100b 

.code
main PROC
	menuLabe:
	call crlf
	mov edx , offset STmenu
	call writestring 
	call crlf
	call readint
	cmp eax,2
	je retrive
	cmp eax,1
	je hideL
	jne outprograme
	hideL:
	MOV EBX , 1
	CALL FillBufferFirst
	jmp menuLabe
	retrive:
	CALL FillBufferSecond
	jmp menuLabe

	outprograme:
	exit
main ENDP


;--------------------------------------------------------
;================================================================
; Read The Image From The File Write It Into The Buffer
; Receives : The Offset Of The Path
; Returns  : 0 In EAX If File has Read Successfully else
;			 Returns 1. 
;================================================================
FillBufferFirst PROC 
	PUSHAD
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
		MOV EAX , 1
		JMP Errorrr

	EndSuccessfully:
		MOV EAX , 0

	ENDPROGRAM:

	POP EDX

	PUSH EAX
	;Converting Char Buffer To Integer
	MOV ESI , Offset BufferSTR
	MOV EDI , Offset BufferINT
	MOV ECX , Acual_Buffer_SizeSTR
	CALL Convert_Char_To_Integer
	;Converting Char Buffer To Integer

	POP EAX

	;Hide My String in the BufferINT
	
	MOV ESI , 8
	CALL HideMessage
	;Hide My String in the BufferINT


	;Converting BufferINT To String
	mov ebx,8
	MOV ECX , Acual_Buffer_SizeINT
	MOV ESI , Offset BufferINT
	MOV EDI , Offset BufferSTRFile
	MOV EAX , HideLentgh
	MOV ECX , Acual_Buffer_SizeINT
	MOV EBX , 8
	MUL EBX
	
	
	;====================================
		

		PUSH ECX
		PUSH EDI
		PUSH EAX
		MOV ECX , 4
		MOV EDI , Offset DigitsChar
		ADD EDI , 3
		MOV AL , 32     ; space char ' '
		MOV [EDI] , AL
		DEC EDI
		POP EAX

		L2:
			CMP EAX , 0
			JE ENDLOP
			MOV EBX , 10
			CDQ
			DIV EBX
			ADD DL , '0'
			MOV [EDI] , DL
			DEC EDI
			JMP Cont
			ENDLOP:
				MOV ECX , 1
			Cont:
		LOOP L2
		
		MOV EDI , Offset DigitsChar
		MOV EAX , [EDI]
		POP EDI
		MOV [EDI] , EAX
		ADD EDI , 4

		; Clear Digits Char
		PUSH EDI
		MOV EDI , Offset DigitsChar
		MOV ECX , 4				
		L3:
			MOV AL , '0'
			MOV [EDI] , AL
			INC EDI
		LOOP L3
		POP EDI
		; Clear Digits Char

		
		POP ECX
	;================================
	
	ADD EDI , 4
	CALL Convert_To_String
	;Converting BufferINT To String


	;Write To File
	MOV EDX ,  Offset PathWrite
	CALL CreateOutPutFile
	CMP EAX , INVALID_HANDLE_VALUE
	JE Errorrr
	MOV FileHandle , EAX
	MOV EAX , Acual_Buffer_SizeINT
	MOV EBX , 4
	MUL EBX 
	MOV Acual_Buffer_SizeSTRFile , EAX
	MOV EAX , FileHandle
	MOV EDX , Offset BufferSTRFile
	MOV ECX , Acual_Buffer_SizeSTRFile
	CALL WriteToFile
	JC Errorrr
	MOV Bytes_Written , EAX
	MOV EAX , Bytes_Written
	;CALL WriteDec
	JMP Success

	

	Success:
	MOV EAX , FileHandle
	CALL CloseFile
	;Write To File

	Errorrr:
	 CALL CloseFile

	POPAD
	RET
FillBufferFirst ENDP





;================================================================
; Hide Message Inside the Buffer
; Receives : String To hide
;		   : ECX Size of the String
;================================================================

	HideMessage PROC uses ESI EDI ECX
	
	mov edx , offset messageOUT
	call writestring
	call crlf
	mov edx , offset messageHide
	mov ecx,lengthof messageHide
	call readstring
	mov edi,offset messageHide
	     ; htsht3'l lma hima y read el length bta3 el string mn el file
	mov HideLentgh , eax
	mov ecx,eax
		L2:					; loop on each char in input string to hide it in 8 elements of array
			PUSH ECX
			MOV AL,[EDI]  ; character that will hide
			MOV ECX,8

			L:					; loop on 8 elements of array to hide char bits in LSB of element
				CLC
				SHL AL,1
				JC ONEC
				MOV EDX,BufferINT[ESI]
				AND EDX,11111110b
				MOV BufferINT[ESI],EDX
				JMP cont
				onec:
				MOV EDX,BufferINT[ESI]
				OR edx,00000001b
				MOV BufferINT[ESI],EDX
				cont:
				ADD ESI,4
			LOOP L

			INC EDI     ; get next char
			POP ECX
		LOOP L2
		mov edx ,offset hided
		call writestring 
		call crlf
		RET
	HideMessage ENDP





;================================================================
; Read The Image From The File Write It Into The Buffer
; Receiv	es : The Offset Of The Path
; Returns  : 0 In EAX If File has Read Successfully else
;			 Returns 1. 
;================================================================
FillBufferSecond PROC 
	PUSHAD
	PUSH EDX 

	MOV EDX , Offset PathWrite
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
		MOV EAX , 1
		JMP ENDPROGRAM

	EndSuccessfully:
		MOV EAX , 0

		PUSH ESI
		PUSH ECX
		;Convert BufferSTR Has The Msg To Integer
		MOV ESI , Offset BufferSTR
		MOV EDI , Offset BufferINT
		
		MOV ECX , Acual_Buffer_SizeSTR
		CALL Convert_Char_To_IntegerSEC
		
		;Convert BufferSTR Has The Msg To Integer
		POP ECX
		POP ESI
		
		;Retrive Message Encrypted Into The Buffer
		CALL RetriveMessage
		;Retrive Message Encrypted Into The Buffer

		PUSH ESI
		PUSH ECX
		;Show BufferINT
		;MOV ESI , Offset BufferINT
		;MOV ECX , Acual_Buffer_SizeINT
		;CALL ShowArray
		;Show BufferINT
		POP ECX
		POP ESI

	ENDPROGRAM:

	POP EDX
	POPAD
	RET
FillBufferSecond ENDP





;================================================================
; Retrive Message From the Buffer
; Receives : 
;		   : ECX Size of the String
;================================================================
RetriveMessage PROC uses ECX EBX EDI ESI

	
		mov eax , ActualSize
		;call writeint
		mov ecx,8
		div ecx
	    MOV ECX , eax
		MOV EBX , 12
		MOV EDI , 0
		MOV ESI , Offset StringMsg
		 
		L3:					; LOOP TO TAKE EACH CHAR FROM 8 ELEMENTS
		PUSH ECX
		MOV ECX , 8
		MOV EDI , 0 
		PUSH EAX
		LL:				; loop on 8 elements to take LSB from each element
			MOV EAX , 0
			MOV EAX , BufferINT[EBX]
			SHR EAX , 1
			JC YES
			MOV ans[EDI] , '0'   ; ans represent binary of char
			JMP cont2
			YES:
			MOV ans[EDI] , '1'
			cont2:
			RCL EAX , 1  ; back the element to its original value after make change (shr) to it
			MOV BufferINT[EBX] , EAX
			ADD EBX , 4
			INC EDI
		LOOP LL
		POP EAX
		MOV ECX , 8
		MOV EDI , 7
		MOV DL , 1   
		MOV AL , 0   ; DECIMAL REPRESENT OF CHAR A -> 97 

		LQ:											; LOOP CONVERT BINARY REPRESENT TO ASCII TO GET CHAR
			CMP ans[EDI],'1'
			JE EQL
			JMP CONT3
			EQL:
			ADD AL , DL
			CONT3:
			SHL DL,1
			DEC EDI
		LOOP LQ
		
		CALL WriteChar
		MOV [ESI] , AL
		
		ADD ESI , 1
		POP ECX
	LOOP L3	
		RET
	RetriveMessage ENDP





;================================================================
; Convert From Char Array To Integer Array
; Receives : ESI The Offset Of The Char Array
;			 EDI The Offset Of The Integer Array
;			 ECX The Number Of Chars
; Returns  : EBX The Acual Number Of Numbers 
;			 The Array Converted To Integers
;================================================================
Convert_Char_To_IntegerSEC PROC
	MOV EBX , 0
	MOV EDX , 0	

	L1:
	MOV AL , [ESI] ;Takes The Char From Char Array
	CMP AL , ' '  ;Indicates If The Char is space
	JE NewNUMB

	CMP AL , 10 ;Indicates If The Char is NewLine \n
	JE NewNUMB

	CMP AL , 13  ;Indicates If The Char is End of The Line
	JE ENDLOP

	;ADD ESI , 1

	LastNum:
		    ; Don't Append On The Number
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

	NewNUMB:
		MOV [EDI] , EDX		; MOV The Whole Number To EDI 
		MOV EDX , 0			; Clear EDX
		INC EBX
		ADD EDI , 4
	ENDLOP:
	INC ESI
LOOP L1

MOV Acual_Buffer_SizeINT , EBX
mov edi,offset BufferINT
mov eax,[edi]
mov ActualSize , eax
	RET
Convert_Char_To_IntegerSEC ENDP
;--------------------------------------------------------

;================================================================
; Convert Integer Array to String Array
; Receives : ESI The Offset Of The BufferINT
;		   : ECX Size of the array 
;================================================================
Convert_To_String PROC uses ESI  ECX 

	
	L1:
		PUSH ECX
		PUSH EDI
		MOV ECX , 4
		MOV EDI , Offset DigitsChar
		ADD EDI , 3
		MOV AL , 32     ; space char ' '
		MOV [EDI] , AL
		MOV EAX , [ESI]
		DEC EDI

		L2:
			CMP EAX , 0
			JE ENDLOP
			MOV EBX , 10
			CDQ
			DIV EBX
			ADD DL , '0'
			MOV [EDI] , DL
			DEC EDI
			JMP Cont
			ENDLOP:
				MOV ECX , 1
			Cont:
		LOOP L2
		
		MOV EDI , Offset DigitsChar
		MOV EAX , [EDI]
		POP EDI
		MOV [EDI] , EAX
		ADD EDI , 4
		ADD ESI , 4

		; Clear Digits Char
		PUSH EDI
		MOV EDI , Offset DigitsChar
		MOV ECX , 4				
		L3:
			MOV AL , '0'
			MOV [EDI] , AL
			INC EDI
		LOOP L3
		POP EDI
		; Clear Digits Char

		
		POP ECX
	LOOP L1
	RET
Convert_To_String ENDP


;================================================================
; Shows Array Element
; Receives : ESI The Offset Of The Path
;		   : ECX Size of the array 
;================================================================
ShowArray PROC uses ESI ECX
	L2:
		MOV EAX , [ESI]
		CALL WriteDec
		ADD ESI , type BufferINT
		CALL CRLF
	LOOP L2
	RET
ShowArray ENDP


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
	;ADD ESI , 1

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
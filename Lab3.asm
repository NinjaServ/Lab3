Title Lab 3: String Swapping

;	*************************************************
;	* Name: Seth Urbach								*
;	* Lab Exercise: Lab #3							*
;	* Date Started: July 8, 2002					*
;	* Date Last Modified: July 12, 2002 - 2:00 PM	*
;	* Date Due: July 12, 2002						*
;	*												*
;	* Program Description:							*
;	*	This lab prompts the user to enter in two 	*
;	*	different strings. Then the strings are  	*
;	*	swapped with each other in memoryusing the 	* 
;   *	student designed function strSwap. Then the *
;	*	two swapped strings are printed out to the	*
;	*	user										*
;	*************************************************

.model small
	CR		equ	0dh
	LF		equ	0ah
	string	equ	[bp+4]

.stack 100h

.data
	ustring1	db	100 dup(0)			; String variables
	ustring2	db	100 dup(0)
	storstr		db	100 dup(0)			; String save and store inbetween
	storstr2	db	100 dup(0)
	prompt		db	"Enter in your string: " ,CR, LF, 0
	msg1		db	"This program swaps strings." ,CR, LF, 0
	msg2		db	"The strings are swapped. " ,CR, LF, 0
	msg3		db	"The first string now contains : " ,CR,LF,0
	msg4		db	"The second string now contains: " ,CR,LF,0

.code

Start:
	mov		AX, @data
	mov		ds, AX

PrtDisp:
	call	NewLines			; Displays a new line
	push	offset msg1			; Stores the message location on the stack
	call	PUTSTR				; Displays program description string
	add		sp, 02				; Restore stack
	call	NewLines			; Displays a new line

GetStrs:
	push	offset prompt		; Stores the message location on the stack
	call	PUTSTR				; Displays input prompt
	add		sp, 02				; Restore stack	
	push	offset ustring1		; saves address of the first string variable
	call	GETSTR				; fills the first string variable
	add		sp, 02				; Restore stack
	call	NewLines			; Prints two lines
	push	offset prompt		; Stores the input prompt's location on the stack
	call	PUTSTR				; Displays input prompt
	add		sp, 02					
	push	offset ustring2		; saves address of the 2nd string variable
	call	GETSTR				; fills the second string variable
	add		sp, 02				

SwpStart:
	push	offset ustring2		; saves the address of the string variables
	push	offset ustring1
	call	strSwap				; swaps the locations, in memory, of the strings that are in
								;		 the variables: the intended procedure for the lab
	push	offset msg2			; Stores the "swithched" message location on the stack
	call	PUTSTR				; Prints the message to the screen
	add		sp, 02				

SwapPrt:
	call	NewLines			; Prints two new lines
	push	offset msg3			; Stores the "first string" message location on the stack
	call	PUTSTR				; Prints message to the screen 
	add		sp, 02
	push	offset ustring1		; saves address of the first string variable
	call	PUTSTR				; Prints contents of first string variable: 
								;		the second string
	add		sp, 02
	call	NewLines			; Prints two new lines
	push	offset msg4			; Stores the "second string" message location on the stack
	call	PUTSTR				; Prints the message
	add		sp, 02
	push	offset ustring2		; saves address of the second string variable
	call	PUTSTR				; prints contents of the 2nd variable: the 1st string
	add		sp, 02

Finished:
	mov ax, 4C00h			;terminate program with 00h in
	int 21h					;	AL as the "return code"






;------------------------------------------------------------
; strSwap -  Takes the two strings stored on the stack and 
;				swappes thier places in memory: The 1st 
;				string goes to the second address and the 
;				2nd string goes to the first address.
; entry condition:  1st string address held in first
;                   argument on stack, and 2nd string
;                   address in second argument on stack
; exit condition:  1st output string stored at address in
;                  first argument and  2nd output string stored 
;					at address in 2nd argument on stack
;
;------------------------------------------------------------

strSwap proc near

	push	bp						; save all regiseters
	mov		bp, sp
	push	SI
	push	DI
	push	bx
	push	ax
	push	dx
	push	cx

	mov		SI, [bp+4]				; address of first string
	mov		DI, [bp+6]				; address of second string
	mov		CX, 00					; initialize CX for counting
	mov		BX, offset storstr		; save the address of the first temporary storage
									;		variable

SwapCopy:
	cmp		byte ptr [SI], 0		; End of string?
	je		SwapNext				; if end, move on to SwapNext
	mov		DX, [SI]				; store character in 1st string to DX
	mov		byte ptr [BX], dl		; store the character into storage variable
	inc		SI						; go to next char
	inc		BX						; go to next address
	inc		CX						; increment the count
	jmp		SwapCopy				; start Swapcopy again

SwapNext:
	sub		BX, CX					; go to original offset of variable
	mov		BX, offset storstr2		; save the address of the 2nd temporary storage
									;		variable
	mov		CX, 00h					; initialize CX for counting

SwapCopy2:
	cmp		byte ptr [DI], 0		; End of 2nd string?
	je		Swap1					; continue on	
	mov		DX, [DI]				; store character in 2nd string to DX
	mov		byte ptr [BX], dl		; store the character into storage variable
	inc		DI						; got to next char in string
	inc		BX						; go to next address
	inc		CX						; increment the count
	jmp		SwapCopy2				; start SwapCopy2 again

Swap1:
	sub		BX, CX					; go to original offset of variable
	mov		BX, offset storstr		; save the address of the 2nd temporary storage
									;		variable
	mov		DI, [bp+6]				; save address of the 2nd string

SwapLoop:
	cmp		byte ptr [BX], 0		; End of string?
	je		Swap2					; go on to Swap2
	mov		DX, [BX]				; store character in 1st storage variable to DX
	mov		byte ptr [DI], dl		; store the character into 2nd string
	inc		BX						; go to next char
	inc		DI						; go to next address
	jmp		SwapLoop				; start again
		
Swap2:
	mov		byte ptr [DI], 0		; null termination
	mov		BX, offset storstr2		; store second storage var address
	mov		SI, [bp+4]				; store first string address

SwapLoop2:
	cmp		byte ptr [BX], 0		; End of string?
	je		SwapEnd					; go on to end of proc
	mov		DX, [BX]				; store character in 2nd storage variable to DX
	mov		byte ptr [SI], dl		; store the character into 1st string
	inc		BX						; go to next char
	inc		SI						; go to next address
	jmp		SwapLoop2				; start again

SwapEnd:
	mov		byte ptr [SI], 0		; null termination of string
	pop cx							; restore registers
	pop dx
	pop ax
	pop bx
	pop	SI
	pop	DI
	pop bp
	ret								; go back to call

strSwap endp
	



;------------------------------------------------------------
; NewLines - prints two new lines to the screen; uses
;          DOS int 21h, function 2, to output lines 
; entry condition:  none
; exit condition:  entered string null terminated and stored
;                  at specified address 
;

NewLines proc near
	mov ah, 02h				; print two newlines (i.e. CR + LF + LF)
	mov dl, CR					
	int 21h
	mov dl, LF
	int 21h
	int 21h
	ret
	
NewLines endp


;------------------------------------------------------------
; getstr - read ASCII char string from console keyboard; uses
;          DOS int 21h, function 1, to read chars & echo them
;          to screen
; entry condition:  output ASCII string address held in
;                   argument on stack
; exit condition:  entered string null terminated and stored
;                  at specified address 
;

getstr proc near
	push bp
	mov bp, sp
	push bx
	push ax
	push dx

	mov bx, string			; address of output string [bp+4]
	mov ah, 01h				; use function 1 of INT 21h

GetLoop:
	int 21h 				; wait for char from keyboard
	cmp al, CR				; end of input? (char = CR)
	je	GetEnd
	mov [bx],al 			; save char in string
	inc bx					; point to next char position
	jmp GetLoop

GetEnd:
	mov byte ptr [bx], 0	; CR is converted to null
	mov ah, 02h				; print a newline (i.e. CR + LF)
	mov dl, CR					
	int 21h
	mov dl, LF
	int 21h
	
	pop dx
	pop ax
	pop bx
	pop bp
	ret

getstr endp


;------------------------------------------------------------
; putstr - write ASCIIZ char string to console screen; uses
;          DOS int 21h, function 2, to send chars to screen
; entry condition:  input ASCIIZ string address held in
;                   argument on stack
; exit condition:  none 
;

putstr proc near

	push bp
	mov bp, sp
	push bx
	push ax
	push dx

	mov bx, string			; address of input string [bp+4]
	mov ah, 2

PrtLoop:
	cmp byte ptr [bx], 0	; end of string?
	je PrtEnd
	mov dl, byte ptr [bx]	; grab char from string
	int 21h 				; send to screen
	inc bx					; next char
	jmp PrtLoop

PrtEnd:
	pop dx
	pop ax
	pop bx
	pop bp
	ret

putstr endp


end Start

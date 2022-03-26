section .data	
	board db "........."
	player db 1
	newline db 0xA
	clear db 27,"[H",27,"[2J"
section .bss
	pos resb 1
section .text
	global _start
_start:
	push ecx
	mov eax, 4 			; write
	mov ebx, 1			; stdout
	mov ecx, clear			; clear screen code
	mov edx, 7			; write 7 bytes
	int 0x80			; syscall
	mov al, byte [player]		; move player into al
	xor al, 1			; al = !al
	mov [player], al		; move al back into player
	xor ecx, ecx			; zero ecx for print loop
	mov esi, board			; move board into esi for print loop
print:
	push ecx
	mov eax, 4			; write
	mov ecx, esi			; write board
	mov edx, 3			; write 3 bytes
	int 0x80			; syscall
	mov eax, 4			; write
	mov ecx, newline		; write newline
	mov edx, 1			; write 1 byte
	int 0x80			; syscall
	pop ecx	
	inc ecx				; increment loop counter
	add esi, 3			; point esi at the next 3 bytes of board
	cmp ecx, 3			; if ecx < 3
	jl print			; jump to print
	mov eax, 4			; write
	mov ecx, newline		; write newline
	int 0x80			; syscall
	mov eax, 3			; read
	mov ebx, 2			; stdin
	mov ecx, pos			; read into pos
	mov edx, 2			; read 1 byte for pos and 1 byte for the `ENTER` key
	int 0x80			; syscall
	mov al, [pos]			; mov pos into al
	sub al, 49			; subtract 49 from al to change it from ascii to its value - 1
	mov bl, [player]		; move player into bl
	add bl, 49			; add 49 to bl to change it into ascii value + 1
	mov [board + eax], bl		; move bl into chosen board position
	xor ecx, ecx			; zero ecx for checkh loop
	mov esi, board			; move board into esi for checkh loop
checkh:
	mov al, esi[0]			; move esi[0] into al
	add al, esi[1]			; al += esi[1]
	add al, esi[2]			; al += esi[2]
	call checkwin			; check for three in a row
	add esi, 3			; point esi to the next three bytes in board
	inc ecx				; increment loop counter
	cmp ecx, 3			; if ecx < 3
	jl checkh			; jump to checkh
	xor ecx, ecx			; zero ecx for checkv loop
checkv:
	mov al, board[ecx + 0]		; move board[ecx + 0] into al
	add al, board[ecx + 3]		; al += board[ecx + 3]
	add al, board[ecx + 6]		; al += board[ecx + 6]
	call checkwin			; check for three in a row
	inc ecx				; increment loop counter
	cmp ecx, 3			; if ecx < 3
	jl checkv			; jump to checkv
	mov al, board[0]		; move board[0] into al (start of first diagonal check)
	add al, board[4]		; al += board[4]
	add al, board[8]		; al += board[8]
	call checkwin			; check for three in a row
	mov al, board[2]		; move board[2] into al (start of second diagonal check)
	add al, board[4]		; al += board[4]
	add al, board[6]		; al += board[6]
	call checkwin			; check for three in a row
	pop ecx	
	inc ecx				; increment loop counter
	cmp ecx, 9			; if ecx < 9
	jl _start			; jump to _start (gameloop)
exit:	
	mov eax, 1			; sysexit
	xor ebx, ebx			; zero ebx
	int 0x80			; syscall
checkwin:
	cmp al, 147			; if al == 147
	je exit				; exit
	cmp al, 150			; if al == 150
	je exit				; exit
	ret 				; 147 is ascii 1 + 1 + 1 and 150 is ascii 2 + 2 + 2

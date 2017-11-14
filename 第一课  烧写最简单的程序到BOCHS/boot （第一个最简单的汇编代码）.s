
BOOTSEG=0X07C0
entry start
start:
	jmpi  go,BOOTSEG
go:     mov   ax,cs
	mov   ds,ax
	mov   es,ax
        mov   [msgl+17],ah
	mov   cx,#20
	mov   dx,#0x1004
	mov   bx,#0x000c
	mov   bp,#msgl
	mov   ax,#0x1301
	int   0x10
loop1: jmp  loop1
msgl:  	.ascii "Loading system ..."
        .byte 13,10
.org 510               #vim -b  the program  you compile 
       .word 0xAA55    #type :%!xxd  at the end of file 
                       #you can see 0xAA55 at 0x210+ 14 15 



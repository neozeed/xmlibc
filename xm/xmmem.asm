		.386
		include	xmhd.inc
_DATA		segment	para public USE16 'DATA'

_DATA		ends
;
		public	a20_on, a20_off
;
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA

;

;	validate a20 line
;

IF PCAT
		%OUT  " Creating PC/AT version "
kbd_mode	= 64h
kbd_data	= 60h

wait_empty_dis	proc	near
		cli
wait_empty:
		push	ax
		push	cx
		xor	cx,cx
.still_full:
		in	al,kbd_mode
		test	al,2
		loopnz	.still_full
		pop	cx
		pop	ax
		ret
		endp
		
a20_on		proc	near
		push	ax
		mov	ah, 0dfh
a20_set		label	near
		push	cx
		call	wait_empty
		jnz	.forgive
		mov	al, 0d1h
		call	wait_empty_dis
		jnz	.forgive
		out	kbd_mode, al		; 64h
		mov	al, ah
		call	wait_empty
		out	kbd_data, al		; 60h
		mov	al, 0ffh
		call	wait_empty
		out	kbd_mode, al		; 64h
.kbd_end:		
		in	al, kbd_mode
		test	al, 2
		loopnz	.kbd_end
		mov	bx,1010h
.forgive:
		pop	cx
		pop	ax	
		ret
a20_off		label	near	
		push	ax
		mov	al, 0ddh
		jmp	a20_set
		endp
ENDIF
IF  FMR70
a20_on		proc	near
		push	ax
		mov	al, 00110000b
		out	20h, al
		pop	ax
		ret
		endp
a20_off		proc	near
		push	ax
		mov	al, 0
		out	20h, al
		pop	ax
		ret
		endp
ENDIF		

_TEXT		ends
		end	

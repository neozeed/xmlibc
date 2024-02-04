		.386
	public	Code0, getcode
_DATA		segment	para public USE16 'DATA'
instruct	macro	n,l,s
code&n		db	&n
		db	&l
		dw	offset &s
		endm
x = 0
	rept	6
		instruct	%x,1,s_add
x = x+1
	endm
		instruct	6,1,s_push
		instruct	7,1,s_pop
x = 8
	rept	6
		instruct	%x,1,s_or
x = x+1
	endm
		instruct	0eh,1,s_push
		instruct	0fh,2,s_non
x = 10h
	rept	6
		instruct	%x,1,s_adc
x = x+1
	endm
		instruct	16h,1,s_push
		instruct	17h,1,s_pop
x = 18h
	rept	6
		instruct	%x,1,s_sbb
x = x+1
	endm
		instruct	1eh,1,s_push
		instruct	1fh,1,s_pop
x = 20h
	rept	6
		instruct	%x,1,s_and
x = x+1
	endm
		instruct	26h,1,s_es
		instruct	27h,1,s_daa
x = 28h
	rept	6
		instruct	%x,1,s_sub
x = x+1
	endm
		instruct	2eh,1,s_cs
		instruct	2fh,1,s_das
x = 30h
	rept	6
		instruct	%x,1,s_xor
x = x+1
	endm
		instruct	36h,1,s_ss
		instruct	37h,1,s_aaa
x = 38h
	rept	6
		instruct	%x,1,s_cmp
x = x+1
	endm
		instruct	3eh,1,s_cs
		instruct	3fh,1,s_aas
x = 40h
	rept	8		
		instruct	%x,1,s_inc
x = x+1
	endm	
x = 48h
	rept	8		
		instruct	%x,1,s_dec
x = x+1
	endm	
x = 50h
	rept	8		
		instruct	%x,1,s_push
x = x+1
	endm	
	rept	8		
		instruct	%x,1,s_pop
x = x+1
	endm
x = 60h	
		instruct	60h,1,s_pusha
		instruct	61h,1,s_popa
		instruct	62h,1,s_bound
		instruct	63h,1,s_arpl
		instruct	64h,1,s_fs
		instruct	65h,1,s_gs
		instruct	66h,1,s_size
		instruct	67h,1,s_addr
		instruct	68h,1,s_push
		instruct	69h,1,s_imul
		instruct	6ah,1,s_push
		instruct	6bh,1,s_imul
		instruct	6ch,1,s_ins
		instruct	6dh,1,s_ins
		instruct	6eh,1,s_outs
		instruct	6fh,1,s_outs
x = 70h
	rept 16		
		instruct	%x, 3,s_jc
x = x+1
	endm
	rept 4
		instruct	%x,1,s_qqq
x = x+1
	endm
		instruct	84h,1,s_test
		instruct	85h,1,s_test
		instruct	86h,1,s_xchg
		instruct	87h,1,s_xchg
x = 88h
	rept 5
		instruct	%x,1,s_mov
x = x+1	
	endm	
		instruct	8dh,1,s_lea
		instruct	8eh,1,s_mov
		instruct	8fh,1,s_pop
		instruct	90h,1,s_nop
x = 91h
	rept 7
		instruct	%x,1,s_xchg
x = x+1
	endm
		instruct	98h,1,s_cbw
		instruct	99h,1,s_cwd
		instruct	9ah,1,s_call
		instruct	9bh,1,s_wait
		instruct	9ch,1,s_pushf
		instruct	9dh,1,s_popf
		instruct	9eh,1,s_sahf
		instruct	9fh,1,s_lahf
x = 0a0h
	rept 4		
		instruct	%x,1,s_mov
x = x+1
	endm			
		instruct	0a4h,1,s_movs
		instruct	0a5h,1,s_movs
		instruct	0a6h,1,s_cmps
		instruct	0a7h,1,s_cmps
		instruct	0a8h,1,s_test
		instruct	0a9h,1,s_test
		instruct	0aah,1,s_stos
		instruct	0abh,1,s_stos
		instruct	0ach,1,s_lods
		instruct	0adh,1,s_lods
		instruct	0aeh,1,s_scas
		instruct	0afh,1,s_scas
x = 0b0h
	rept 16
		instruct	%x ,1, s_mov
x = x+1
	endm
		instruct	0c0h,1,s_non		
		instruct	0c1h,1,s_shr		
		instruct	0c2h,1,s_ret
		instruct	0c3h,1,s_ret
		instruct	0c4h,1,s_les
		instruct	0c5h,1,s_lds
		instruct	0c6h,1,s_mov
		instruct	0c7h,1,s_mov
		instruct	0c8h,1,s_enter
		instruct	0c9h,1,s_leave
		instruct	0cah,1,s_ret
		instruct	0cbh,1,s_ret
		instruct	0cch,1,s_int
		instruct	0cdh,2,s_int
		instruct	0ceh,1,s_int
		instruct	0cfh,1,s_iret
		instruct	0d0h,1,s_shr
		instruct	0d1h,1,s_shr
		instruct	0d2h,1,s_shr
		instruct	0d3h,1,s_shr
		instruct	0d4h,1,s_aam
		instruct	0d5h,1,s_aad
		instruct	0d6h,1,s_non
		instruct	0d7h,1,s_xlat
x = 0d8h
	rept	8
		instruct	 %x, 1,s_esc
x = x+1
	endm
		instruct	0e0h,1,s_loop
		instruct	0e1h,1,s_loop
		instruct	0e2h,1,s_loop
		instruct	0e3h,1,s_jcxz
		instruct	0e4h,1,s_in
		instruct	0e5h,1,s_in
		instruct	0e6h,1,s_out
		instruct	0e7h,1,s_out
		instruct	0e8h,1,s_call
		instruct	0e9h,1,s_jmp
		instruct	0eah,1,s_jmp
		instruct	0ebh,1,s_jmp
		instruct	0ech,1,s_in
		instruct	0edh,1,s_in
		instruct	0eeh,1,s_out
		instruct	0efh,1,s_out
		instruct	0f0h,1,s_lock
		instruct	0f1h,1,s_non
		instruct	0f2h,1,s_rep
		instruct	0f3h,1,s_rep
		instruct	0f4h,1,s_hlt
		instruct	0f5h,1,s_cmc
		instruct	0f6h,1,s_non
		instruct	0f7h,1,s_non
		instruct	0f8h,1,s_clc
		instruct	0f9h,1,s_stc
		instruct	0fah,1,s_cli
		instruct	0fbh,1,s_sti
		instruct	0fch,1,s_cld
		instruct	0fdh,1,s_std
		instruct	0feh,1,s_non
		instruct	0ffh,1,s_non
	
$instructions	label	byte
s_non		db	'**',0,0
s_add		db	'add',0
s_sub		db	'sub',0
s_sbb		db	'sbb',0
s_and		db	'and',0
s_cmp		db	'cmp',0
s_or		db	'or',0
s_xor		db	'xor',0
s_mul		db	'mul',0
s_pop		db	'pop',0
s_push		db	'push',0
s_adc		db	'adc',0
s_inc		db	'inc',0
s_dec		db	'dec',0
s_cs		db	'cs:',0
s_ds		db	'db:',0
s_es		db	'es:',0
s_fs		db	'fs:',0
s_gs		db	'gs:',0
s_ss		db	'ss:',0
s_das		db	'das',0
s_daa		db	'daa',0
s_aas		db	'aas',0
s_aaa		db	'daa',0
s_jmp		db	'jmp',0
s_jcc		db	'jc*',0
s_mov		db	'mov',0
s_call		db	'call',0
s_in		db	'in',0
s_out		db	'out',0
s_cwd		db	'cwd',0
s_cbw		db	'cbw',0
s_imul		db	'imul',0
s_idiv		db	'idiv',0
s_lea		db	'lea',0
s_outs		db	'outs',0
s_ins		db	'ins',0
s_wait		db	'wait',0
s_test		db	'test',0
s_pushf		db	'pushf',0
s_popf		db	'popf',0
s_pusha		db	'pusha',0
s_popa		db	'popa',0
s_ret		db	'ret',0
s_iret		db	'iret',0
s_stos		db	'stos',0
s_movs		db	'movs',0
s_scas		db	'scas',0
s_cmps		db	'cmps',0
s_lods		db	'lods',0
s_sahf		db	'sahf',0
s_lahf		db	'lahf',0
s_xchg		db	'xchg',0
s_loop		db	'loop',0
s_rep		db	'rep ',0
s_jcxz		db	'jcxz',0
s_hlt		db	'hlt',0
s_cmc		db	'cmc',0
s_xlat		db	'xlat',0
s_aam		db	'aam',0
s_aad		db	'aad',0
s_lfs		db	'lfs',0
s_lgs		db	'lgs',0
s_les		db	'les',0
s_lds		db	'lds',0
s_lss		db	'lss',0
s_bt		db	'bt',0
s_btr		db	'btr',0
s_shld		db	'shld',0
s_shrd		db	'shrd',0
s_lar		db	'lar',0
s_movzx		db	'movzx',0
s_movsx		db	'movsx',0
s_leave		db	'leave',0
s_enter		db	'enter',0
s_esc		db	'esc',0
s_lock		db	'lock',0
s_qqq		db	'???',0
s_jc		db	'jc',0
s_clc		db	'clc',0
s_cli		db	'cli',0
s_stc		db	'stc',0
s_sti		db	'sti',0
s_std		db	'std',0
s_cld		db	'cld',0
s_int		db	'int',0
s_shr		db	'shr',0
s_nop		db	'nop',0
s_size		db	'd16 ',0
s_addr		db	'a16 ',0
s_bound		db	'bound',0
s_arpl		db	'arpl',0

_DATA		ends
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
;
; return short disassemble code
; entry  eax : instruction code, order al, ah, ...
; exit   si -> nemonic string
;
getcode		proc	near
		push	ebx
		movzx	ebx, al
		movzx	edx, word ptr code0[ebx*4+2]
		pop	ebx
		ret
		endp
_TEXT		ends
		end	
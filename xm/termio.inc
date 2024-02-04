NCC		equ	8

termio		struc
c_iflag		dw	?
c_oflag		dw	?
c_cflag		dw	?
c_lflag		dw	?
c_line		db	?
c_vintr		db	?
c_vquit		db	?
c_verase	db	?
c_veof		db	?
c_veol		db	?
c_veol2		db	?
c_vmin		db	?
c_vtime		db	?
c_vswtch	db	?
termio		ends

TCGETA		equ	5401h

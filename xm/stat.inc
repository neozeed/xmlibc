stat		struc
st_dev		dw	?
st_ino		dw	?
st_nlink	dw	?
st_uid		dw	?
st_gid		dw	?
st_mode		dw	?
st_rdev		dw	?
st_size		dd	?
st_atime	dd	?
st_mtime	dd	?
st_ctime	dd	?
stat		ends

S_IFFMT		equ	0170000q
S_IFDIR		equ	0040000q
S_IFCHR		equ	0020000q
S_IFBLK		equ	0060000q
S_IFREG		equ	0100000q
S_IFNAM		equ	0050000q

S_INSEM		equ	     01q
S_INSHD		equ	     02q
S_ISUID		equ	  04000q
S_ISGID		equ	  02000q
S_ISVTX		equ	  01000q
S_IREAD		equ	  00400q
S_IWRITE	equ	  00200q
S_IEXEC		equ	  00100q
S_ENFMT		equ	  S_ISGID
S_IRWXU		equ	  00700q
S_IRUSR		equ	  00400q
S_IWUSR		equ	  00200q
S_IXUSR		equ	  00100q
S_IRWXG		equ	  00070q
S_IRGRP		equ	  00040q
S_IWGRP		equ	  00020q
S_IXGRP		equ	  00010q
S_IRWXO		equ	  00007q
S_IROTH		equ	  00004q
S_IWOTH		equ	  00002q
S_IXOTH		equ	  00001q


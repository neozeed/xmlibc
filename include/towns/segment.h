/*
	Copyright (c) 1990 by Keisuke Yoshida

	File name: segment.h
	Language:  Gcc
*/

typedef unsigned int longword;

void		_memcpyfar (longword, longword, longword, longword, longword);
unsigned int	_peek_byte (longword, longword);
unsigned int	_peek_word (longword, longword);
unsigned int	_peek_longword (longword, longword);
void		_poke_byte (longword, longword, unsigned int);
void		_poke_word (longword, longword, unsigned int);
void		_poke_longword (longword, longword, unsigned int);


/* GDT */
#define GSEG_SYSTEM_LDT		0x0028
#define GSEG_LDT		0x0030
#define GSEG_GDT		0x0038
#define GSEG_PHISICAL		0x0040
#define GSEG_IDT		0x0050
#define GSEG_MSDOS		0x0060

/* GDT for TOWNS */
#define GSEG_SYS_ROM_CODE	0x0100
#define GSEG_SYS_ROM_DATA	0x0108
#define GSEG_TBIOS_CODE		0x0110
#define GSEG_TBIOS_DATA		0x0118
#define GSEG_VRAM_16K_32K	0x0120
#define GSEG_VRAM_256		0x0128
#define GSEG_SPRITE_PATTERN	0x0130
#define GSEG_KANJI_FONT		0x0138
#define GSEG_WAVE_MEMORY	0x0140
#define GSEG_OS_ROM		0x0148

/* LDT */
#define LSEG_PSP		0x0004
#define LSEG_CODE_READ_ONLY	0x000c
#define LSEG_CODE_READ_WRITE	0x0014
#define LSEG_VRAM		0x001c
#define LSEG_PSP2		0x0024
#define LSEG_ENVIRONMENT	0x002c
#define LSEG_LOW_MEMORY		0x0034

/* LDT for TOWNS */
#define LSEG_VRAM_16K_32K	0x0104
#define LSEG_VRAM_256		0x010c
#define LSEG_SPRITE		0x0114


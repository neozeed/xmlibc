/*

		Copyright (c) 1990  Keisuke Yoshida.

*/
/*
	Version:	Inline library V0.12alpha
*/
#ifndef EXTENDER_H
#define EXTENDER_H 1

extern int  _dos_errno;
extern int  _dos_errclass;
extern int  _dos_errsugested;
extern int  _dos_errlocus;

struct _allocation_table_information {
	int  nsectors;	/* # of sectors per cluster */
	char *fat_id;	/* pointer to FAT ID byte */
	int  nbytes;	/* # of bytes per sector */
	int  nclusters;	/* # of sectors per disk */
};

struct _system_date {
	int  dayofweek;
	int  year;
	int  month;
	int  day;
};

struct _set_system_date {
	short  year;
	char  month;
	char  day;
};

struct _system_time {
	int  hours;
	int  minutes;
	int  seconds;
	int  subsecs;
};

struct _set_system_time {
	char  hours;
	char  minutes;
	char  seconds;
	char  subsecs;
};

struct _file_date_time {
	unsigned int seconds	: 5;
	unsigned int minutes	: 6;
	unsigned int hours	: 5;
	unsigned int day	: 5;
	unsigned int month	: 4;
	unsigned int year	: 7;
};

struct _version_info {
	int  major_version;
	int  minor_version;
	union {
		int	version;
		char	version_string[4];
	} extender;
};

struct _disk_space {
	int  nsectors;		/* # of sectors per cluster */
	int  free_clusters;	/* # of free cluster per disk */
	int  nbytes;		/* # of bytes per sector */
	int  nclusters;		/* # of clusters per disk */
};

static __inline__ void
_dos_terminate()
{
	asm volatile("
	movb %0,%%ah
	int $0x21"
	: /* no output */
	: "i"(0x00)
	: "ax");
}

static __inline__ int
_dos_keyboard_input()
{
	int  c;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r" (c)
	: "i"(0x01)
	: "ax");

	return c;
}

static __inline__ void
_dos_display_output(int c)
{
	asm volatile("
	movb %0,%%dl
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) c), "i"(0x02)
	: "ax", "dx");
}

static __inline__ int
_dos_aux_input()
{
	int c;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(c)
	: "i"(0x03)
	: "ax");

	return c;
}

static __inline__ void
_dos_aux_output(int c)
{
	asm volatile("
	movb %0,%%dl
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) c), "i"(0x04)
	: "ax", "dx");
}

static __inline__ void
_dos_printer_output(int c)
{
	asm volatile("
	movb %0,%%dl
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) c), "i"(0x05)
	: "ax", "dx");
}

static __inline__ int
_dos_direct_console_input()
{
	int  c;

	asm volatile("
	movb %1,%%dl
	movb %2,%%ah
	int $0x21
	jnz 0f
	movl %3,%0
	jmp 1f
0:
	movzbl %%al,%0
1:"
	: "=r"(c)
	: "i"(0xff), "i"(0x06), "i"(-1)
	: "ax", "dx");

	return c;
}

static __inline__ void
_dos_direct_console_output(int c)
{
	asm volatile("
	movb %0,%%dl
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) c), "i"(0x06)
	: "ax", "dx");
}

static __inline__ int
_dos_direct_console_input_without_echo()
{
	int  c;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(c)
	: "i"(0x07)
	: "ax");

	return c;
}

static __inline__ int
_dos_keyboard_input_without_echo()
{
	int c;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(c)
	: "i"(0x08)
	: "ax");

	return c;
}

static __inline__ void
_dos_print_string(const char *string)
{
	/* If you need to set %ds, insert here. */
	asm volatile("
	movl %0,%%edx
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"(string), "i"(0x09)
	: "ax", "dx");
}

static __inline__ void
_dos_buffered_keyboard_input(char *buffer)
{
	/* If you need to set %ds, insert here. */
	asm volatile("
	movl %0,%%edx
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"(buffer), "i"(0x0a)
	: "ax", "dx");
}

static __inline__ int
_dos_check_standard_input_status()
{
	int  result;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(result)
	: "i"(0x0b)
	: "ax");

	return result;
}

static __inline__ int
_dos_clear_keyboard_buffer(int function, char *buffer)
{
	int  c;
	int  request;

	switch (function) {
	  case 0x01:
		request = 0x0c01;	break;
	  case 0x06:
		request = 0x0c06;	break;
	  case 0x07:
		request = 0x0c07;	break;
	  case 0x08:
		request = 0x0c08;	break;

	  case 0x0a:
		asm volatile("
		movl %0,%%edx
		movw %1,%%ax
		int $0x21"
		: /* no output */
		: "g"(buffer), "i"(0x0c0a)
		: "ax", "dx");

		return 0;

	  default:
		return -1;
	}

	asm volatile("
	movb %1,%%al
	movb %2,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(c)
	: "g"((unsigned char) request), "i"(0x0c)
	: "ax");

	return c;
}

static __inline__ void
_dos_disk_reset()
{
	asm volatile("
	movb %0,%%ah
	int $0x21"
	: /* no output */
	: "i"(0x0d)
	: "ax");
}

static __inline__ int
_dos_select_disk(int drive)
{
	int logical_drives;

	asm volatile("
	movb %1,%%dl
	movb %2,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(logical_drives)
	: "g"((unsigned char) drive), "i"(0x0e)
	: "ax", "dx");

	return logical_drives;
}

static __inline__ int
_dos_get_default_disk_number()
{
	int number;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(number)
	: "i"(0x19)
	: "ax");

	return number;
}

static __inline__ void
_dos_set_disk_transfer_area_address(char *buffer)
{
	/* %ds is currest %ds */
	asm volatile("
	movl %0,%%edx
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"(buffer), "i"(0x1a)
	: "ax", "dx");
}

static __inline__ struct _allocation_table_information
_dos_allocation_table_information()
{
	struct _allocation_table_information  info;

	asm volatile("
	movb %4,%%ah
	int $0x21
	movzbl %%al,%0
	movl %%ebx,%1
	movzwl %%cx,%2
	movzwl %%dx,%3"
	:"=r"(info.nsectors), "=r"(info.fat_id),
	 "=r"(info.nbytes),   "=r"(info.nclusters)
	: "i"(0x1b)
	: "ax", "bx", "cx", "dx");

	return info;
}

static __inline__ struct _allocation_table_information
_dos_allocation_table_information_for_special_device(int drive)
{
	struct _allocation_table_information  info;

	asm volatile("
	movb %4,%%dl
	movb %5,%%ah
	int $0x21
	movzbl %%al,%0
	movl %%ebx,%1
	movzwl %%cx,%2
	movzwl %%dx,%3"
	: "=r"(info.nsectors), "=r"(info.fat_id),
	  "=r"(info.nbytes),   "=r"(info.nclusters)
	: "g"((unsigned char) drive), "i"(0x1c)
	: "ax", "bx", "cx", "dx");

	return info;
}

static __inline__ int
_dos_set_interrupt_vector()
{
	/* not use this */
}

static __inline__ int
_dos_create_psp()
{
	/* dos extender not supported */
}

static __inline__ struct _system_date
_dos_get_current_date()
{
	struct _system_date date;

	asm volatile("
	movb %4,%%ah
	int $0x21
	movzbl %%al,%0
	movzwl %%cx,%1
	movzbl %%dh,%2
	movzbl %%dl,%3"
	: "=r"(date.dayofweek), "=r"(date.year),
	  "=r"(date.month),     "=r"(date.day)
	: "i"(0x2a)
	: "ax", "cx", "dx");

	return date;
}

static __inline__ int
_dos_set_current_date(struct _set_system_date date)
{
	int  result;
	unsigned short year  = (unsigned short) date.year;
	unsigned char  month = (unsigned short) date.month;
	unsigned char  day   = (unsigned short) date.day;

	asm volatile("
	movw %1,%%cx
	movb %2,%%dh
	movb %3,%%dl
	movb %4,%%ah
	int $0x21
	movsbl %%al,%0"
	: "=r"(result)
	: "g"(year), "g"(month), "g"(day), "i"(0x2b)
	: "ax", "cx", "dx");

	return result;
}

static __inline__ struct _system_time
_dos_get_current_time()
{
	struct _system_time time;

	asm volatile("
	movb %4,%%ah
	int $0x21
	movzbl %%ch,%0
	movzbl %%cl,%1
	movzbl %%dh,%2
	movzbl %%dl,%3"
	: "=r"(time.hours),   "=r"(time.minutes),
	  "=r"(time.seconds), "=r"(time.subsecs)
	: "i"(0x2c)
	: "ax", "cx", "dx");

	return time;
}

static __inline__ int
_dos_set_current_time(struct _set_system_time time)
{
	int  result;
	unsigned char hours   = (unsigned char) time.hours;
	unsigned char minutes = (unsigned char) time.minutes;
	unsigned char seconds = (unsigned char) time.seconds;
	unsigned char subsecs = (unsigned char) time.subsecs;

	asm volatile("
	movb %3,%%dh
	movb %4,%%dl
	movb %1,%%ch
	movb %2,%%cl
	movb %5,%%ah
	int $0x21
	movsbl %%al,%0"
	: "=r"(result)
	: "g"(hours), "g"(minutes), "g"(seconds), "g"(subsecs), "i"(0x2d)
	: "ax", "cx", "dx");

	return result;
}

static __inline__ int
_dos_set_verify_flag(int flag)
{
	if (!((flag == 0x00) || (flag == 0x01))) return -1;

	asm volatile("
	movb %0,%%al
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) flag), "i"(0x2e)
	: "ax");

	return 0;
}

static __inline__ char *
_dos_get_disk_transfer_area_address()
{
	char *dta;

	/* %es is ignored */
	asm volatile("
	movb %1,%%ah
	int $0x21
	movl %%ebx,%0"
	: "=r"(dta)
	: "i"(0x2f)
	: "ax", "bx");

	return dta;
}

static __inline__ struct _version_info
_dos_get_dos_version()
{
	char phar[5];
	struct _version_info info;

	phar[0] = 'P';
	phar[1] = 'H';
	phar[2] = 'A';
	phar[3] = 'R';
	phar[4] = '\0';

	asm volatile("
	movl %3,%%ebx
	movb %4,%%ah
	int $0x21
	movzbl %%al,%0
	movzbl %%ah,%1
	movl %%ebx,%2"
	: "=r"(info.major_version),
	  "=r"(info.minor_version),
	  "=r"(info.extender.version)
	: "g"(phar), "i"(0x30)
	: "ax", "bx", "cx", "dx");

	return info;
}

static __inline__ void
_dos_terminate_but_stay_resident(int status)
{
	asm volatile("
	movb %0,%%al
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) status), "i"(0x31)
	: "ax");
}

static __inline__ char *
_dos_get_drive_parameter_block(int drive)
{
	int  result;
	char *parameter_block;

	asm volatile("
	movb %2,%%dl
	movb %3,%%ah
	int $0x21
	movsbl %%al,%0
	movl %%ebx,%1"
	: "=r"(result), "=r"(parameter_block)
	: "g"((unsigned char) drive), "i"(0x32)
	: "ax", "bx", "cx");

	if (result) return  0;

	return  parameter_block;
}

static __inline__ int
_dos_get_extended_control_break_checking()
{
	int flag;

	asm volatile("
	movw %1,%%ax
	int $0x21
	movzbl %%dl,%0"
	: "=r"(flag)
	: "i"(0x3300)
	: "ax", "dx");

	return flag;
}

static __inline__ void
_dos_set_extended_control_break_checking(int flag)
{
	asm volatile("
	movb %0,%%dl
	movw %1,%%ax
	int $0x21"
	: /* no output */
	: "g"((unsigned char) flag), "i"(0x3301)
	: "ax", "dx");
}

static __inline__ struct _disk_space
_dos_get_disk_space(int drive)
{
	struct _disk_space info;

	asm volatile("
	movb %4,%%dl
	movb %5,%%ah
	int $0x21
	movzwl %%ax,%0
	movzwl %%bx,%1
	movzwl %%cx,%2
	movzwl %%dx,%3"
	: "=r"(info.nsectors), "=r"(info.free_clusters),
	  "=r"(info.nbytes),   "=r"(info.nclusters)
	: "g"((unsigned char) drive), "i"(0x36)
	: "ax","bx","cx","dx");

	return info;
}

static __inline__ int
_dos_get_switch()
{
	int  flag;
	int  result;

	asm volatile("
	movw %2,%%ax
	int $0x21
	movzbl %%dl,%0
	movzbl %%al,%1"
	: "=r"(flag), "=r"(result)
	: "i"(0x3700)
	: "ax", "dx");

	if (result) return -1;

	return flag;
}

static __inline__ int
_dos_set_switch(int flag)
{
	int  result;

	asm volatile("
	movb %1,%%dl
	movw %2,%%ax
	int $0x21
	movsbl %%al,%0"
	: "=r"(result)
	: "g"((unsigned char) flag), "i"(0x3701)
	: "ax", "dx");

	return result;
}

static __inline__ int
_dos_get_country_dependent_infomation(int country, char *buffer)
{
	int  result;
	int  _al, _bx;

	if (country < 255) {
		_al = country;
		_bx = 0;
	} else {
		_al = 0xff;
		_bx = country;
	}
	asm volatile("
	movl %2,%%edx
	movw %3,%%bx
	movb %4,%%al
	movb %5,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(buffer),
	  "g"((unsigned short) _bx),
	  "g"((unsigned char) _al),
	  "i"(0x38)
	: "ax", "bx", "dx");

	return  result;
}

static __inline__ int
_dos_set_country_dependent_infomation(int country)
{
	int  result;
	int  _al, _bx;

	if (country < 255) {
		_al = country;
		_bx = 0;
	} else {
		_al = 0xff;
		_bx = country;
	}
	asm volatile("
	movl %2,%%edx
	movw %3,%%bx
	movb %4,%%al
	movb %5,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "i"(0xffffffff),
	  "g"((unsigned short) _bx),
	  "g"((unsigned char) _al),
	  "i"(0x38)
	: "ax", "bx", "dx");

	return  result;
}

static __inline__ int
_dos_mkdir(char *path)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "i"(0x39)
	: "ax", "dx");

	return  result;
}

static __inline__ int
_dos_rmdir(char *path)
{
	register int  result;

	asm volatile("
	movl %2,%%edx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "i"(0x3a)
	: "ax", "dx");

	return  result;
}

static __inline__ int
_dos_chdir(char *path)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "i"(0x3b)
	: "ax", "dx");

	return  result;
}

static __inline__ int
_dos_creat(char *path, int attributes)
{
	int result;

	asm volatile("
	movw %2,%%cx
	movl %3,%%edx
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) attributes), "g"(path), "i"(0x3c)
	: "ax", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_open(char *path, int attributes)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movb %3,%%al
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "g"((unsigned char) attributes), "i"(0x3d)
	: "ax", "dx");

	return  result;
}

static __inline__ int
_dos_close(int handle)
{
	register int  result;

	asm volatile("
	movw %2,%%bx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "i"(0x3e)
	: "ax", "bx");

	return  result;
}

static __inline__ int
_dos_read(int handle, char *buffer, int nbytes)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movl %3,%%ecx
	movl %4,%%edx
	movb %5,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl %%eax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"(nbytes), "g"(buffer), "i"(0x3f)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_write(int handle, const char *buffer, int nbytes)
{
	register int  result;

	asm volatile("
	movw %2,%%bx
	movl %3,%%ecx
	movl %4,%%edx
	movb %5,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl %%eax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"(nbytes), "g"(buffer), "i"(0x40)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_unlink(char *path)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "i"(0x41)
	: "ax", "dx");

	return  result;
}

static __inline__ long
_dos_lseek(int fd, long offset, int whence)
{
	long position;
	int  high = ((unsigned long) offset) >> 16;
	int  low  = ((unsigned long) offset) & 0xffff;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movw %4,%%dx
	movb %5,%%al
	movb %6,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
	shll $16,%%edx
	addl %%edx,%1
1:"
	: "=r"(_dos_errno), "=r"(position)
	: "g"((unsigned short) fd),
	  "g"((unsigned short) high),
	  "g"((unsigned short) low),
	  "g"((unsigned char) whence),
	  "i"(0x42)
	: "ax", "bx", "cx", "dx");

	return position;
}

static __inline__ int
_dos_get_file_attributes(char *path)
{
	int result;

	asm volatile("
	movl %2,%%edx
	movw %3,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "i"(0x4300)
	: "ax", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_set_file_attributes(char *path, int attributes)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movw %3,%%cx
	movw %4,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "g"((unsigned short) attributes), "i"(0x4301)
	: "ax", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_get_device_infomation(int handle)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl %%edx,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "i"(0x4400)
	: "ax", "bx", "dx");

	return  result;
}

static __inline__ int
_dos_set_device_infomation(int handle, int info)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%dx
	movw %4,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl   $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"((unsigned short) info), "i"(0x4401)
	: "ax", "bx", "dx");

	return  result;
}

static __inline__ int
_dos_read_character_device_control_string(int handle, char *buffer, int nbytes)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movl %4,%%edx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"((unsigned short) nbytes),
	  "g"(buffer), "i"(0x4402)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_write_character_device_control_string(int handle, char *buffer, int nbytes)
{
	int result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movl %4,%%edx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"((unsigned short) nbytes),
	  "g"(buffer), "i"(0x4403)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_read_block_device_control_string(int device, char *buffer, int nbytes)
{
	int  result;

	asm volatile("
	movb %2,%%bl
	movw %3,%%cx
	movl %4,%%edx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned char) device), "g"((unsigned short) nbytes),
	  "g"(buffer), "i"(0x4404)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_write_block_device_control_string(int device, char *buffer, int nbytes)
{
	int  result;

	asm volatile("
	movb %2,%%bl
	movw %3,%%cx
	movl %4,%%edx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned char) device), "g"((unsigned short) nbytes),
	  "g"(buffer), "i"(0x4405)
	: "ax", "bx", "cx", "dx");

	return  result;
}

static __inline__ int
_dos_get_input_status(int handle)
{
	int  result;

	asm volatile("
	movw %1,%%bx
	movw %2,%%ax
	int $0x21
	movzbl %%al,%0"
	: "=r"(result)
	: "g"((unsigned short) handle), "i"(0x4406)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_get_output_status(int handle)
{
	int  result;

	asm volatile("
	movw %1,%%bx
	movw %2,%%ax
	int $0x21
	movzbl %%al,%0"
	: "=r"(result)
	: "g"((unsigned short) handle), "i"(0x4407)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_block_device_changeable(char drive)
{
	int  result;

	asm volatile("
	movb %1,%%bl
	movw %2,%%ax
	int $0x21
	movzwl %%ax,%0"
	: "=r"(result)
	: "g"((unsigned char) drive), "i"(0x4408)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_block_device_local(int drive)
{
	int  result;

	asm volatile("
	movb %1,%%bl
	movw %2,%%ax
	int $0x21
	movzwl %%dx,%0"
	: "=r"(result)
	: "g"((unsigned char) drive), "i"(0x4409)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_handle_local(int handle)
{
	int  result;

	asm volatile("
	movw %1,%%bx
	movw %2,%%ax
	int $0x21
	movzwl %%dx,%0"
	: "=r"(result)
	: "g"((unsigned short) handle), "i"(0x440a)
	: "ax", "bx", "dx");

	return result;
}

static __inline__ int
_dos_sharing_entry_count(int handle, int delay, int retry)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movw %4,%%dx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "g"((unsigned short) delay),
	  "g"((unsigned short) retry), "i"(0x440b)
	: "ax", "bx", "cx", "dx");

	return result;
}

static __inline__ int
_dos_dup(int handle)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "i"(0x45)
	: "ax","bx");

	return result;
}

static __inline__ int
_dos_dup2(int oldhandle, int newhandle)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movw %4,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%0
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) oldhandle), "g"((unsigned short) newhandle),
	  "i"(0x46)
	: "ax", "bx", "cx");

	return result;
}

static __inline__ int
_dos_get_current_directory(int drive, char *buffer)
{
	int  result;

	asm volatile("
	movb %2,%%dl
	movl %3,%%esi
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned char) drive), "g"(buffer), "i"(0x47)
	: "ax", "dx", "si");

	return result;
}

static __inline__ int
_dos_allocate_memory(int npages)
{
	int  result;

	asm volatile("
	movl %2,%%ebx
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(npages), "i"(0x48)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_free_memory(int segment)
{
	int  result;

	asm volatile("
	pushl %%es
	pushl %2
	popl %%es
	movb %3,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:
	popl %%es"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(segment), "i"(0x49)
	: "ax");

	return result;
}

static __inline__ int
_dos_adjust_memory_block_size(int segment, int npages)
{
	int  result;

	asm volatile("
	pushl %%es
	pushl %2
	popl %%es
	movl %3,%%ebx
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl %%ebx,%1
	jmp 1f
0:
	movl $0,%1
1:
	popl %%es"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(segment), "g"(npages), "i"(0x4a)
	: "ax", "bx");

	return result;
}

static __inline__ int
_dos_exec(char *parameter, char *program)
{
	int  result;

	asm volatile("
	movl %2,%%ebx
	movl %3,%%edx
	movw %4,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(parameter), "g"(program), "i"(0x4b00)
	: "ax");

	return result;
}

static __inline__ void
_dos_exit(int status)
{
	asm volatile("
	movb %0,%%al
	movb %1,%%ah
	int $0x21"
	: /* no output */
	: "g"((unsigned char) status), "i"(0x4c)
	: "ax");
}

static __inline__ int
_dos_wait()
{
	int  result;
	asm volatile("
	movb %1,%%ah
	int $0x21
	movzwl %%ax,%0"
	: "=r"(result)
	: "i"(0x4d)
	: "ax");

	return result;
}

static __inline__ int
_dos_find_dirst(char *path, int attributes)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movw %3,%%cx
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "g"((unsigned short) attributes), "i"(0x4e)
	: "ax", "cx", "dx");

	return result;
}

static __inline__ int
_dos_find_next()
{
	int  result;

	asm volatile("
	movb %2,%%ah
	int $0x21
	jnc j0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "i"(0x4f)
	: "ax");

	return result;
}

static __inline__ int
_dos_get_verify_flag()
{
	int  flag;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzbl %%al,%0"
	: "=r"(flag)
	: "i"(0x54)
	: "ax");

	return flag;
}

static __inline__ int
_dos_rename(char *oldname, char *newname)
{
	int  result;

	asm volatile("
	movl %2,%%edx
	movl %3,%%edi
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(oldname), "g"(newname), "i"(0x56)
	: "ax", "dx", "di");

	return result;
}

static __inline__ struct _file_date_time
_dos_get_file_date_time(int handle)
{
	int  result;

	union {
		struct _file_date_time  time;
		unsigned long int       longword;
	} result1;

	asm volatile("
	movw %2,%%bx
	movw %3,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%cx,%1
	shll $16,%%edx
	addl %%edx,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle), "i"(0x5700)
	: "ax", "bx", "cx", "dx");

	result1.longword = result;

	return result1.time;
}

static __inline__ int
_dos_set_file_date_time(int handle, struct _file_date_time datetime)
{
	int result;
	int time;
	int date;
	union {
		struct _file_date_time  time;
		unsigned long int       longword;
	} datetime1;

	datetime1.time = datetime;
	time = ((unsigned int) datetime1.longword >> 16) & 0xffff;
	date = ((unsigned int) datetime1.longword)       & 0xffff;

	asm volatile("
	movw %2,%%bx
	movw %3,%%cx
	movw %4,%%dx
	movw %5,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) handle),
	  "g"((unsigned short) time),  "g"((unsigned short) date),
	  "i"(0x5701)
	: "ax", "bx", "cx", "dx");

	return result;
}

static __inline__ int
_dos_get_memory_allocation_strategy()
{
	int result;

	asm volatile("
	movw %2,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "i"(0x5800)
	: "ax");

	return result;
}

static __inline__ int
_dos_set_memory_allocation_strategy(int strategy)
{
	int  result;

	asm volatile("
	movw %2,%%bx
	movw %3,%%ax
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movl $0,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"((unsigned short) strategy), "i"(0x5801)
	: "ax", "bx");

	return result;
}

static __inline__ void
_dos_get_extended_error_code()
{
	asm volatile("
	movw $0,%%bx
	movb %4,%%ah
	int $0x21
	movzwl %%ax,%0
	movzbl %%bh,%1
	movzbl %%bl,%2
	movzbl %%ch,%3"
	: "=r"(_dos_errno),	  "=r"(_dos_errclass),
	  "=r"(_dos_errsugested), "=r"(_dos_errlocus)
	: "i"(0x59)
	: "ax","bx","cx","dx","si","di","bp");
}

static __inline__ int
_dos_creat_uniq_file(char *path, int attributes)
{
	int result;

	asm volatile("
	movl %2,%%edx
	movw %3,%%cx
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g" (path), "g"((unsigned short) attributes), "i"(0x5a)
	: "ax", "cx", "dx");

	return result;
}

static __inline__ int
_dos_creat_new_file(char *path, int attributes)
{
	int result;

	asm volatile("
	movl %2,%%edx
	movw %3,%%cx
	movb %4,%%ah
	int $0x21
	jnc 0f
	movzwl %%ax,%0
	movl $-1,%1
	jmp 1f
0:
	movzwl %%ax,%1
1:"
	: "=r"(_dos_errno), "=r"(result)
	: "g"(path), "g"((unsigned short) attributes), "i"(0x5b)
	: "ax", "cx", "dx");

	return result;
}

/*
static __inline__ int _dos_lock_file(int handle, int offset, int size);
static __inline__ int _dos_unlock_file(int handle, int offset, int size);
*/

static __inline__ int
_dos_get_psp_address()
{
	int  segment;

	asm volatile("
	movb %1,%%ah
	int $0x21
	movzwl %%bx,%0"
	: "=r"(segment)
	: "i"(0x62)
	: "ax", "bx");

	return segment;
}

#endif

_memtest1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "memtest starting\n");
  11:	68 0b 08 00 00       	push   $0x80b
  16:	6a 01                	push   $0x1
  18:	e8 73 04 00 00       	call   490 <printf>
	mem();
  1d:	e8 0e 00 00 00       	call   30 <mem>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <mem>:
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	56                   	push   %esi
  35:	53                   	push   %ebx
  36:	83 ec 14             	sub    $0x14,%esp
	printf(1, "mem test\n");
  39:	68 e8 07 00 00       	push   $0x7e8
  3e:	6a 01                	push   $0x1
  40:	e8 4b 04 00 00       	call   490 <printf>
	m1 = malloc(4096);
  45:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  4c:	e8 9f 06 00 00       	call   6f0 <malloc>
	if (m1 == 0)
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	74 30                	je     88 <mem+0x58>
  58:	89 c6                	mov    %eax,%esi
  5a:	89 c3                	mov    %eax,%ebx
	uint count = 0;
  5c:	31 ff                	xor    %edi,%edi
  5e:	eb 14                	jmp    74 <mem+0x44>
		((int*)m1)[2] = count++;
  60:	8d 57 01             	lea    0x1(%edi),%edx
		*(char**)m1 = m2;
  63:	89 03                	mov    %eax,(%ebx)
		((int*)m1)[2] = count++;
  65:	89 7b 08             	mov    %edi,0x8(%ebx)
  68:	89 c3                	mov    %eax,%ebx
	while (cur < TOTAL_MEMORY) {
  6a:	81 fa 60 02 00 00    	cmp    $0x260,%edx
  70:	74 2a                	je     9c <mem+0x6c>
  72:	89 d7                	mov    %edx,%edi
		m2 = malloc(4096);
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	68 00 10 00 00       	push   $0x1000
  7c:	e8 6f 06 00 00       	call   6f0 <malloc>
		if (m2 == 0)
  81:	83 c4 10             	add    $0x10,%esp
  84:	85 c0                	test   %eax,%eax
  86:	75 d8                	jne    60 <mem+0x30>
	printf(1, "test failed!\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 fd 07 00 00       	push   $0x7fd
  90:	6a 01                	push   $0x1
  92:	e8 f9 03 00 00       	call   490 <printf>
	exit();
  97:	e8 96 02 00 00       	call   332 <exit>
	((int*)m1)[2] = count;
  9c:	c7 40 08 60 02 00 00 	movl   $0x260,0x8(%eax)
		if (((int*)m1)[2] != count)
  a3:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
  a7:	75 df                	jne    88 <mem+0x58>
	count = 0;
  a9:	31 c0                	xor    %eax,%eax
  ab:	eb 05                	jmp    b2 <mem+0x82>
		if (((int*)m1)[2] != count)
  ad:	39 46 08             	cmp    %eax,0x8(%esi)
  b0:	75 d6                	jne    88 <mem+0x58>
		count++;
  b2:	83 c0 01             	add    $0x1,%eax
		m1 = *(char**)m1;
  b5:	8b 36                	mov    (%esi),%esi
	while (count != total_count) {
  b7:	3d 60 02 00 00       	cmp    $0x260,%eax
  bc:	75 ef                	jne    ad <mem+0x7d>
	printf(1, "mem ok %d\n", bstat());
  be:	e8 0f 03 00 00       	call   3d2 <bstat>
  c3:	52                   	push   %edx
  c4:	50                   	push   %eax
  c5:	68 f2 07 00 00       	push   $0x7f2
  ca:	6a 01                	push   $0x1
  cc:	e8 bf 03 00 00       	call   490 <printf>
	exit();
  d1:	e8 5c 02 00 00       	call   332 <exit>
  d6:	66 90                	xchg   %ax,%ax
  d8:	66 90                	xchg   %ax,%ax
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 c2                	mov    %eax,%edx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f0:	83 c1 01             	add    $0x1,%ecx
  f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f7:	83 c2 01             	add    $0x1,%edx
  fa:	84 db                	test   %bl,%bl
  fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  ff:	75 ef                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
 101:	5b                   	pop    %ebx
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	0f b6 19             	movzbl (%ecx),%ebx
 120:	84 c0                	test   %al,%al
 122:	75 1c                	jne    140 <strcmp+0x30>
 124:	eb 2a                	jmp    150 <strcmp+0x40>
 126:	8d 76 00             	lea    0x0(%esi),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 130:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 133:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 136:	83 c1 01             	add    $0x1,%ecx
 139:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 13c:	84 c0                	test   %al,%al
 13e:	74 10                	je     150 <strcmp+0x40>
 140:	38 d8                	cmp    %bl,%al
 142:	74 ec                	je     130 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 144:	29 d8                	sub    %ebx,%eax
}
 146:	5b                   	pop    %ebx
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 152:	29 d8                	sub    %ebx,%eax
}
 154:	5b                   	pop    %ebx
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 d2                	xor    %edx,%edx
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c2 01             	add    $0x1,%edx
 173:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 177:	89 d0                	mov    %edx,%eax
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	5f                   	pop    %edi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	89 f6                	mov    %esi,%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	74 1d                	je     1de <strchr+0x2e>
    if(*s == c)
 1c1:	38 d3                	cmp    %dl,%bl
 1c3:	89 d9                	mov    %ebx,%ecx
 1c5:	75 0d                	jne    1d4 <strchr+0x24>
 1c7:	eb 17                	jmp    1e0 <strchr+0x30>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	38 ca                	cmp    %cl,%dl
 1d2:	74 0c                	je     1e0 <strchr+0x30>
  for(; *s; s++)
 1d4:	83 c0 01             	add    $0x1,%eax
 1d7:	0f b6 10             	movzbl (%eax),%edx
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strchr+0x20>
      return (char*)s;
  return 0;
 1de:	31 c0                	xor    %eax,%eax
}
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	31 f6                	xor    %esi,%esi
 1f8:	89 f3                	mov    %esi,%ebx
{
 1fa:	83 ec 1c             	sub    $0x1c,%esp
 1fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 200:	eb 2f                	jmp    231 <gets+0x41>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 208:	8d 45 e7             	lea    -0x19(%ebp),%eax
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	6a 01                	push   $0x1
 210:	50                   	push   %eax
 211:	6a 00                	push   $0x0
 213:	e8 32 01 00 00       	call   34a <read>
    if(cc < 1)
 218:	83 c4 10             	add    $0x10,%esp
 21b:	85 c0                	test   %eax,%eax
 21d:	7e 1c                	jle    23b <gets+0x4b>
      break;
    buf[i++] = c;
 21f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 223:	83 c7 01             	add    $0x1,%edi
 226:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 229:	3c 0a                	cmp    $0xa,%al
 22b:	74 23                	je     250 <gets+0x60>
 22d:	3c 0d                	cmp    $0xd,%al
 22f:	74 1f                	je     250 <gets+0x60>
  for(i=0; i+1 < max; ){
 231:	83 c3 01             	add    $0x1,%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	89 fe                	mov    %edi,%esi
 239:	7c cd                	jl     208 <gets+0x18>
 23b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 240:	c6 03 00             	movb   $0x0,(%ebx)
}
 243:	8d 65 f4             	lea    -0xc(%ebp),%esp
 246:	5b                   	pop    %ebx
 247:	5e                   	pop    %esi
 248:	5f                   	pop    %edi
 249:	5d                   	pop    %ebp
 24a:	c3                   	ret    
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	8b 75 08             	mov    0x8(%ebp),%esi
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 de                	add    %ebx,%esi
 258:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 25a:	c6 03 00             	movb   $0x0,(%ebx)
}
 25d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5f                   	pop    %edi
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    
 265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <stat>:

int
stat(char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 275:	83 ec 08             	sub    $0x8,%esp
 278:	6a 00                	push   $0x0
 27a:	ff 75 08             	pushl  0x8(%ebp)
 27d:	e8 f0 00 00 00       	call   372 <open>
  if(fd < 0)
 282:	83 c4 10             	add    $0x10,%esp
 285:	85 c0                	test   %eax,%eax
 287:	78 27                	js     2b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	ff 75 0c             	pushl  0xc(%ebp)
 28f:	89 c3                	mov    %eax,%ebx
 291:	50                   	push   %eax
 292:	e8 f3 00 00 00       	call   38a <fstat>
  close(fd);
 297:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 29a:	89 c6                	mov    %eax,%esi
  close(fd);
 29c:	e8 b9 00 00 00       	call   35a <close>
  return r;
 2a1:	83 c4 10             	add    $0x10,%esp
}
 2a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a7:	89 f0                	mov    %esi,%eax
 2a9:	5b                   	pop    %ebx
 2aa:	5e                   	pop    %esi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2b5:	eb ed                	jmp    2a4 <stat+0x34>
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	0f be 11             	movsbl (%ecx),%edx
 2ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 2cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2d4:	77 1f                	ja     2f5 <atoi+0x35>
 2d6:	8d 76 00             	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2e3:	83 c1 01             	add    $0x1,%ecx
 2e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2ea:	0f be 11             	movsbl (%ecx),%edx
 2ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2f0:	80 fb 09             	cmp    $0x9,%bl
 2f3:	76 eb                	jbe    2e0 <atoi+0x20>
  return n;
}
 2f5:	5b                   	pop    %ebx
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    
 2f8:	90                   	nop
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
 305:	8b 5d 10             	mov    0x10(%ebp),%ebx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 db                	test   %ebx,%ebx
 310:	7e 14                	jle    326 <memmove+0x26>
 312:	31 d2                	xor    %edx,%edx
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 318:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 31c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 31f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 322:	39 d3                	cmp    %edx,%ebx
 324:	75 f2                	jne    318 <memmove+0x18>
  return vdst;
}
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    

0000032a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32a:	b8 01 00 00 00       	mov    $0x1,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <exit>:
SYSCALL(exit)
 332:	b8 02 00 00 00       	mov    $0x2,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <wait>:
SYSCALL(wait)
 33a:	b8 03 00 00 00       	mov    $0x3,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <pipe>:
SYSCALL(pipe)
 342:	b8 04 00 00 00       	mov    $0x4,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <read>:
SYSCALL(read)
 34a:	b8 05 00 00 00       	mov    $0x5,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <write>:
SYSCALL(write)
 352:	b8 10 00 00 00       	mov    $0x10,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <close>:
SYSCALL(close)
 35a:	b8 15 00 00 00       	mov    $0x15,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <kill>:
SYSCALL(kill)
 362:	b8 06 00 00 00       	mov    $0x6,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <exec>:
SYSCALL(exec)
 36a:	b8 07 00 00 00       	mov    $0x7,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <open>:
SYSCALL(open)
 372:	b8 0f 00 00 00       	mov    $0xf,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mknod>:
SYSCALL(mknod)
 37a:	b8 11 00 00 00       	mov    $0x11,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <unlink>:
SYSCALL(unlink)
 382:	b8 12 00 00 00       	mov    $0x12,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <fstat>:
SYSCALL(fstat)
 38a:	b8 08 00 00 00       	mov    $0x8,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <link>:
SYSCALL(link)
 392:	b8 13 00 00 00       	mov    $0x13,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mkdir>:
SYSCALL(mkdir)
 39a:	b8 14 00 00 00       	mov    $0x14,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <chdir>:
SYSCALL(chdir)
 3a2:	b8 09 00 00 00       	mov    $0x9,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <dup>:
SYSCALL(dup)
 3aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getpid>:
SYSCALL(getpid)
 3b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sbrk>:
SYSCALL(sbrk)
 3ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sleep>:
SYSCALL(sleep)
 3c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <uptime>:
SYSCALL(uptime)
 3ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <bstat>:
SYSCALL(bstat)
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <swap>:
SYSCALL(swap)
 3da:	b8 17 00 00 00       	mov    $0x17,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    
 3e2:	66 90                	xchg   %ax,%ax
 3e4:	66 90                	xchg   %ax,%ax
 3e6:	66 90                	xchg   %ax,%ax
 3e8:	66 90                	xchg   %ax,%ax
 3ea:	66 90                	xchg   %ax,%ax
 3ec:	66 90                	xchg   %ax,%ax
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f9:	85 d2                	test   %edx,%edx
{
 3fb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3fe:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 400:	79 76                	jns    478 <printint+0x88>
 402:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 406:	74 70                	je     478 <printint+0x88>
    x = -xx;
 408:	f7 d8                	neg    %eax
    neg = 1;
 40a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 411:	31 f6                	xor    %esi,%esi
 413:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 416:	eb 0a                	jmp    422 <printint+0x32>
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 420:	89 fe                	mov    %edi,%esi
 422:	31 d2                	xor    %edx,%edx
 424:	8d 7e 01             	lea    0x1(%esi),%edi
 427:	f7 f1                	div    %ecx
 429:	0f b6 92 3c 08 00 00 	movzbl 0x83c(%edx),%edx
  }while((x /= base) != 0);
 430:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 432:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 435:	75 e9                	jne    420 <printint+0x30>
  if(neg)
 437:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 43a:	85 c0                	test   %eax,%eax
 43c:	74 08                	je     446 <printint+0x56>
    buf[i++] = '-';
 43e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 443:	8d 7e 02             	lea    0x2(%esi),%edi
 446:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 44a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 453:	83 ec 04             	sub    $0x4,%esp
 456:	83 ee 01             	sub    $0x1,%esi
 459:	6a 01                	push   $0x1
 45b:	53                   	push   %ebx
 45c:	57                   	push   %edi
 45d:	88 45 d7             	mov    %al,-0x29(%ebp)
 460:	e8 ed fe ff ff       	call   352 <write>

  while(--i >= 0)
 465:	83 c4 10             	add    $0x10,%esp
 468:	39 de                	cmp    %ebx,%esi
 46a:	75 e4                	jne    450 <printint+0x60>
    putc(fd, buf[i]);
}
 46c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46f:	5b                   	pop    %ebx
 470:	5e                   	pop    %esi
 471:	5f                   	pop    %edi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 478:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 47f:	eb 90                	jmp    411 <printint+0x21>
 481:	eb 0d                	jmp    490 <printf>
 483:	90                   	nop
 484:	90                   	nop
 485:	90                   	nop
 486:	90                   	nop
 487:	90                   	nop
 488:	90                   	nop
 489:	90                   	nop
 48a:	90                   	nop
 48b:	90                   	nop
 48c:	90                   	nop
 48d:	90                   	nop
 48e:	90                   	nop
 48f:	90                   	nop

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 75 0c             	mov    0xc(%ebp),%esi
 49c:	0f b6 1e             	movzbl (%esi),%ebx
 49f:	84 db                	test   %bl,%bl
 4a1:	0f 84 b3 00 00 00    	je     55a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 45 10             	lea    0x10(%ebp),%eax
 4aa:	83 c6 01             	add    $0x1,%esi
  state = 0;
 4ad:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 4af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b2:	eb 2f                	jmp    4e3 <printf+0x53>
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	0f 84 a7 00 00 00    	je     568 <printf+0xd8>
  write(fd, &c, 1);
 4c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4ca:	6a 01                	push   $0x1
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 7d fe ff ff       	call   352 <write>
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4db:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4df:	84 db                	test   %bl,%bl
 4e1:	74 77                	je     55a <printf+0xca>
    if(state == 0){
 4e3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4e5:	0f be cb             	movsbl %bl,%ecx
 4e8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4eb:	74 cb                	je     4b8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ed:	83 ff 25             	cmp    $0x25,%edi
 4f0:	75 e6                	jne    4d8 <printf+0x48>
      if(c == 'd'){
 4f2:	83 f8 64             	cmp    $0x64,%eax
 4f5:	0f 84 05 01 00 00    	je     600 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4fb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 501:	83 f9 70             	cmp    $0x70,%ecx
 504:	74 72                	je     578 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 506:	83 f8 73             	cmp    $0x73,%eax
 509:	0f 84 99 00 00 00    	je     5a8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50f:	83 f8 63             	cmp    $0x63,%eax
 512:	0f 84 08 01 00 00    	je     620 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	0f 84 ef 00 00 00    	je     610 <printf+0x180>
  write(fd, &c, 1);
 521:	8d 45 e7             	lea    -0x19(%ebp),%eax
 524:	83 ec 04             	sub    $0x4,%esp
 527:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 52b:	6a 01                	push   $0x1
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 1c fe ff ff       	call   352 <write>
 536:	83 c4 0c             	add    $0xc,%esp
 539:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 53c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 53f:	6a 01                	push   $0x1
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 54a:	e8 03 fe ff ff       	call   352 <write>
  for(i = 0; fmt[i]; i++){
 54f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 553:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 556:	84 db                	test   %bl,%bl
 558:	75 89                	jne    4e3 <printf+0x53>
    }
  }
}
 55a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55d:	5b                   	pop    %ebx
 55e:	5e                   	pop    %esi
 55f:	5f                   	pop    %edi
 560:	5d                   	pop    %ebp
 561:	c3                   	ret    
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 568:	bf 25 00 00 00       	mov    $0x25,%edi
 56d:	e9 66 ff ff ff       	jmp    4d8 <printf+0x48>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 578:	83 ec 0c             	sub    $0xc,%esp
 57b:	b9 10 00 00 00       	mov    $0x10,%ecx
 580:	6a 00                	push   $0x0
 582:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	8b 17                	mov    (%edi),%edx
 58a:	e8 61 fe ff ff       	call   3f0 <printint>
        ap++;
 58f:	89 f8                	mov    %edi,%eax
 591:	83 c4 10             	add    $0x10,%esp
      state = 0;
 594:	31 ff                	xor    %edi,%edi
        ap++;
 596:	83 c0 04             	add    $0x4,%eax
 599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 59c:	e9 37 ff ff ff       	jmp    4d8 <printf+0x48>
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5ab:	8b 08                	mov    (%eax),%ecx
        ap++;
 5ad:	83 c0 04             	add    $0x4,%eax
 5b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5b3:	85 c9                	test   %ecx,%ecx
 5b5:	0f 84 8e 00 00 00    	je     649 <printf+0x1b9>
        while(*s != 0){
 5bb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5be:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5c0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5c2:	84 c0                	test   %al,%al
 5c4:	0f 84 0e ff ff ff    	je     4d8 <printf+0x48>
 5ca:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5cd:	89 de                	mov    %ebx,%esi
 5cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5d2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5d5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5d8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5db:	83 c6 01             	add    $0x1,%esi
 5de:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5e1:	6a 01                	push   $0x1
 5e3:	57                   	push   %edi
 5e4:	53                   	push   %ebx
 5e5:	e8 68 fd ff ff       	call   352 <write>
        while(*s != 0){
 5ea:	0f b6 06             	movzbl (%esi),%eax
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	84 c0                	test   %al,%al
 5f2:	75 e4                	jne    5d8 <printf+0x148>
 5f4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5f7:	31 ff                	xor    %edi,%edi
 5f9:	e9 da fe ff ff       	jmp    4d8 <printf+0x48>
 5fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	e9 73 ff ff ff       	jmp    582 <printf+0xf2>
 60f:	90                   	nop
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 616:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 619:	6a 01                	push   $0x1
 61b:	e9 21 ff ff ff       	jmp    541 <printf+0xb1>
        putc(fd, *ap);
 620:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 626:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 628:	6a 01                	push   $0x1
        ap++;
 62a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 62d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 630:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 16 fd ff ff       	call   352 <write>
        ap++;
 63c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 63f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 642:	31 ff                	xor    %edi,%edi
 644:	e9 8f fe ff ff       	jmp    4d8 <printf+0x48>
          s = "(null)";
 649:	bb 33 08 00 00       	mov    $0x833,%ebx
        while(*s != 0){
 64e:	b8 28 00 00 00       	mov    $0x28,%eax
 653:	e9 72 ff ff ff       	jmp    5ca <printf+0x13a>
 658:	66 90                	xchg   %ax,%ax
 65a:	66 90                	xchg   %ax,%ax
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 20 0b 00 00       	mov    0xb20,%eax
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 678:	39 c8                	cmp    %ecx,%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	73 32                	jae    6b0 <free+0x50>
 67e:	39 d1                	cmp    %edx,%ecx
 680:	72 04                	jb     686 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 682:	39 d0                	cmp    %edx,%eax
 684:	72 32                	jb     6b8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 686:	8b 73 fc             	mov    -0x4(%ebx),%esi
 689:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68c:	39 fa                	cmp    %edi,%edx
 68e:	74 30                	je     6c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 690:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 693:	8b 50 04             	mov    0x4(%eax),%edx
 696:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 699:	39 f1                	cmp    %esi,%ecx
 69b:	74 3a                	je     6d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 69d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 69f:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 6a4:	5b                   	pop    %ebx
 6a5:	5e                   	pop    %esi
 6a6:	5f                   	pop    %edi
 6a7:	5d                   	pop    %ebp
 6a8:	c3                   	ret    
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 04                	jb     6b8 <free+0x58>
 6b4:	39 d1                	cmp    %edx,%ecx
 6b6:	72 ce                	jb     686 <free+0x26>
{
 6b8:	89 d0                	mov    %edx,%eax
 6ba:	eb bc                	jmp    678 <free+0x18>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6c0:	03 72 04             	add    0x4(%edx),%esi
 6c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 12                	mov    (%edx),%edx
 6ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6cd:	8b 50 04             	mov    0x4(%eax),%edx
 6d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d3:	39 f1                	cmp    %esi,%ecx
 6d5:	75 c6                	jne    69d <free+0x3d>
    p->s.size += bp->s.size;
 6d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6da:	a3 20 0b 00 00       	mov    %eax,0xb20
    p->s.size += bp->s.size;
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e5:	89 10                	mov    %edx,(%eax)
}
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6fc:	8b 15 20 0b 00 00    	mov    0xb20,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8d 78 07             	lea    0x7(%eax),%edi
 705:	c1 ef 03             	shr    $0x3,%edi
 708:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 70b:	85 d2                	test   %edx,%edx
 70d:	0f 84 9d 00 00 00    	je     7b0 <malloc+0xc0>
 713:	8b 02                	mov    (%edx),%eax
 715:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 718:	39 cf                	cmp    %ecx,%edi
 71a:	76 6c                	jbe    788 <malloc+0x98>
 71c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 722:	bb 00 10 00 00       	mov    $0x1000,%ebx
 727:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 72a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 731:	eb 0e                	jmp    741 <malloc+0x51>
 733:	90                   	nop
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 738:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 73a:	8b 48 04             	mov    0x4(%eax),%ecx
 73d:	39 f9                	cmp    %edi,%ecx
 73f:	73 47                	jae    788 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 741:	39 05 20 0b 00 00    	cmp    %eax,0xb20
 747:	89 c2                	mov    %eax,%edx
 749:	75 ed                	jne    738 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 74b:	83 ec 0c             	sub    $0xc,%esp
 74e:	56                   	push   %esi
 74f:	e8 66 fc ff ff       	call   3ba <sbrk>
  if(p == (char*)-1)
 754:	83 c4 10             	add    $0x10,%esp
 757:	83 f8 ff             	cmp    $0xffffffff,%eax
 75a:	74 1c                	je     778 <malloc+0x88>
  hp->s.size = nu;
 75c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 75f:	83 ec 0c             	sub    $0xc,%esp
 762:	83 c0 08             	add    $0x8,%eax
 765:	50                   	push   %eax
 766:	e8 f5 fe ff ff       	call   660 <free>
  return freep;
 76b:	8b 15 20 0b 00 00    	mov    0xb20,%edx
      if((p = morecore(nunits)) == 0)
 771:	83 c4 10             	add    $0x10,%esp
 774:	85 d2                	test   %edx,%edx
 776:	75 c0                	jne    738 <malloc+0x48>
        return 0;
  }
}
 778:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 77b:	31 c0                	xor    %eax,%eax
}
 77d:	5b                   	pop    %ebx
 77e:	5e                   	pop    %esi
 77f:	5f                   	pop    %edi
 780:	5d                   	pop    %ebp
 781:	c3                   	ret    
 782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 788:	39 cf                	cmp    %ecx,%edi
 78a:	74 54                	je     7e0 <malloc+0xf0>
        p->s.size -= nunits;
 78c:	29 f9                	sub    %edi,%ecx
 78e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 791:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 794:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 797:	89 15 20 0b 00 00    	mov    %edx,0xb20
}
 79d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7a0:	83 c0 08             	add    $0x8,%eax
}
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    
 7a8:	90                   	nop
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 7b0:	c7 05 20 0b 00 00 24 	movl   $0xb24,0xb20
 7b7:	0b 00 00 
 7ba:	c7 05 24 0b 00 00 24 	movl   $0xb24,0xb24
 7c1:	0b 00 00 
    base.s.size = 0;
 7c4:	b8 24 0b 00 00       	mov    $0xb24,%eax
 7c9:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 7d0:	00 00 00 
 7d3:	e9 44 ff ff ff       	jmp    71c <malloc+0x2c>
 7d8:	90                   	nop
 7d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7e0:	8b 08                	mov    (%eax),%ecx
 7e2:	89 0a                	mov    %ecx,(%edx)
 7e4:	eb b1                	jmp    797 <malloc+0xa7>

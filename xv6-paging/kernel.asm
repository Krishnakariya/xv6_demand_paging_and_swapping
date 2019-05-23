
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 31 10 80       	mov    $0x80103150,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 75 10 80       	push   $0x801075a0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 15 44 00 00       	call   80104470 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 75 10 80       	push   $0x801075a7
80100097:	50                   	push   %eax
80100098:	e8 c3 42 00 00       	call   80104360 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 77 44 00 00       	call   80104560 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 19 45 00 00       	call   80104680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 42 00 00       	call   801043a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 4d 22 00 00       	call   801023d0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 75 10 80       	push   $0x801075ae
80100198:	e8 f3 02 00 00       	call   80100490 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 42 00 00       	call   80104440 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 07 22 00 00       	jmp    801023d0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 75 10 80       	push   $0x801075bf
801001d1:	e8 ba 02 00 00       	call   80100490 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 42 00 00       	call   80104440 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");
	
  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 41 00 00       	call   80104400 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 50 43 00 00       	call   80104560 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 1f 44 00 00       	jmp    80104680 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 75 10 80       	push   $0x801075c6
80100269:	e8 22 02 00 00       	call   80100490 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <write_page_to_disk>:
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 75 0c             	mov    0xc(%ebp),%esi
8010027c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010027f:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80100285:	89 f7                	mov    %esi,%edi
80100287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010028a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100290:	e8 bb 2b 00 00       	call   80102e50 <begin_op>
    b = bread(dev,blk+i);
80100295:	83 ec 08             	sub    $0x8,%esp
80100298:	53                   	push   %ebx
80100299:	ff 75 08             	pushl  0x8(%ebp)
8010029c:	e8 2f fe ff ff       	call   801000d0 <bread>
801002a1:	83 c4 10             	add    $0x10,%esp
801002a4:	89 c6                	mov    %eax,%esi
    for (int j = 0; j < BSIZE; ++j)
801002a6:	31 d2                	xor    %edx,%edx
801002a8:	90                   	nop
801002a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      b->data[j] = pgptr[j+512*i];
801002b0:	0f b6 04 17          	movzbl (%edi,%edx,1),%eax
801002b4:	88 44 16 5c          	mov    %al,0x5c(%esi,%edx,1)
    for (int j = 0; j < BSIZE; ++j)
801002b8:	83 c2 01             	add    $0x1,%edx
801002bb:	81 fa 00 02 00 00    	cmp    $0x200,%edx
801002c1:	75 ed                	jne    801002b0 <write_page_to_disk+0x40>
    log_write(b);
801002c3:	83 ec 0c             	sub    $0xc,%esp
801002c6:	83 c3 01             	add    $0x1,%ebx
801002c9:	81 c7 00 02 00 00    	add    $0x200,%edi
801002cf:	56                   	push   %esi
801002d0:	e8 4b 2d 00 00       	call   80103020 <log_write>
    brelse(b);
801002d5:	89 34 24             	mov    %esi,(%esp)
801002d8:	e8 03 ff ff ff       	call   801001e0 <brelse>
    end_op();
801002dd:	e8 de 2b 00 00       	call   80102ec0 <end_op>
  for (int i = 0; i < 8 ; ++i)
801002e2:	83 c4 10             	add    $0x10,%esp
801002e5:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801002e8:	75 a6                	jne    80100290 <write_page_to_disk+0x20>
}
801002ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ed:	5b                   	pop    %ebx
801002ee:	5e                   	pop    %esi
801002ef:	5f                   	pop    %edi
801002f0:	5d                   	pop    %ebp
801002f1:	c3                   	ret    
801002f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100300 <read_page_from_disk>:
{
80100300:	55                   	push   %ebp
80100301:	89 e5                	mov    %esp,%ebp
80100303:	57                   	push   %edi
80100304:	56                   	push   %esi
80100305:	53                   	push   %ebx
80100306:	83 ec 1c             	sub    $0x1c,%esp
80100309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010030c:	8b 75 10             	mov    0x10(%ebp),%esi
8010030f:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
80100315:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100318:	90                   	nop
80100319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    b = bread(dev,blk+i);
80100320:	83 ec 08             	sub    $0x8,%esp
80100323:	56                   	push   %esi
80100324:	ff 75 08             	pushl  0x8(%ebp)
80100327:	83 c6 01             	add    $0x1,%esi
8010032a:	e8 a1 fd ff ff       	call   801000d0 <bread>
8010032f:	89 c7                	mov    %eax,%edi
    memmove(pgptr+512*i,b->data,512); // may create problem!
80100331:	8d 40 5c             	lea    0x5c(%eax),%eax
80100334:	83 c4 0c             	add    $0xc,%esp
80100337:	68 00 02 00 00       	push   $0x200
8010033c:	50                   	push   %eax
8010033d:	53                   	push   %ebx
8010033e:	81 c3 00 02 00 00    	add    $0x200,%ebx
80100344:	e8 47 44 00 00       	call   80104790 <memmove>
    brelse(b);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 8f fe ff ff       	call   801001e0 <brelse>
  for (int i = 0; i < 8 ; ++i)
80100351:	83 c4 10             	add    $0x10,%esp
80100354:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100357:	75 c7                	jne    80100320 <read_page_from_disk+0x20>
}
80100359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010035c:	5b                   	pop    %ebx
8010035d:	5e                   	pop    %esi
8010035e:	5f                   	pop    %edi
8010035f:	5d                   	pop    %ebp
80100360:	c3                   	ret    
80100361:	66 90                	xchg   %ax,%ax
80100363:	66 90                	xchg   %ax,%ax
80100365:	66 90                	xchg   %ax,%ax
80100367:	66 90                	xchg   %ax,%ax
80100369:	66 90                	xchg   %ax,%ax
8010036b:	66 90                	xchg   %ax,%ax
8010036d:	66 90                	xchg   %ax,%ax
8010036f:	90                   	nop

80100370 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	57                   	push   %edi
80100374:	56                   	push   %esi
80100375:	53                   	push   %ebx
80100376:	83 ec 28             	sub    $0x28,%esp
80100379:	8b 7d 08             	mov    0x8(%ebp),%edi
8010037c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010037f:	57                   	push   %edi
80100380:	e8 9b 16 00 00       	call   80101a20 <iunlock>
  target = n;
  acquire(&cons.lock);
80100385:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010038c:	e8 cf 41 00 00       	call   80104560 <acquire>
  while(n > 0){
80100391:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	31 c0                	xor    %eax,%eax
80100399:	85 db                	test   %ebx,%ebx
8010039b:	0f 8e a1 00 00 00    	jle    80100442 <consoleread+0xd2>
    while(input.r == input.w){
801003a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801003a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
801003ad:	74 2c                	je     801003db <consoleread+0x6b>
801003af:	eb 5f                	jmp    80100410 <consoleread+0xa0>
801003b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003b8:	83 ec 08             	sub    $0x8,%esp
801003bb:	68 20 a5 10 80       	push   $0x8010a520
801003c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801003c5:	e8 36 3c 00 00       	call   80104000 <sleep>
    while(input.r == input.w){
801003ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801003d0:	83 c4 10             	add    $0x10,%esp
801003d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801003d9:	75 35                	jne    80100410 <consoleread+0xa0>
      if(myproc()->killed){
801003db:	e8 b0 36 00 00       	call   80103a90 <myproc>
801003e0:	8b 40 24             	mov    0x24(%eax),%eax
801003e3:	85 c0                	test   %eax,%eax
801003e5:	74 d1                	je     801003b8 <consoleread+0x48>
        release(&cons.lock);
801003e7:	83 ec 0c             	sub    $0xc,%esp
801003ea:	68 20 a5 10 80       	push   $0x8010a520
801003ef:	e8 8c 42 00 00       	call   80104680 <release>
        ilock(ip);
801003f4:	89 3c 24             	mov    %edi,(%esp)
801003f7:	e8 44 15 00 00       	call   80101940 <ilock>
        return -1;
801003fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801003ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100402:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100407:	5b                   	pop    %ebx
80100408:	5e                   	pop    %esi
80100409:	5f                   	pop    %edi
8010040a:	5d                   	pop    %ebp
8010040b:	c3                   	ret    
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100410:	8d 42 01             	lea    0x1(%edx),%eax
80100413:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100418:	89 d0                	mov    %edx,%eax
8010041a:	83 e0 7f             	and    $0x7f,%eax
8010041d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
    if(c == C('D')){  // EOF
80100424:	83 f8 04             	cmp    $0x4,%eax
80100427:	74 3f                	je     80100468 <consoleread+0xf8>
    *dst++ = c;
80100429:	83 c6 01             	add    $0x1,%esi
    --n;
8010042c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010042f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100432:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100435:	74 43                	je     8010047a <consoleread+0x10a>
  while(n > 0){
80100437:	85 db                	test   %ebx,%ebx
80100439:	0f 85 62 ff ff ff    	jne    801003a1 <consoleread+0x31>
8010043f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100442:	83 ec 0c             	sub    $0xc,%esp
80100445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100448:	68 20 a5 10 80       	push   $0x8010a520
8010044d:	e8 2e 42 00 00       	call   80104680 <release>
  ilock(ip);
80100452:	89 3c 24             	mov    %edi,(%esp)
80100455:	e8 e6 14 00 00       	call   80101940 <ilock>
  return target - n;
8010045a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010045d:	83 c4 10             	add    $0x10,%esp
}
80100460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100463:	5b                   	pop    %ebx
80100464:	5e                   	pop    %esi
80100465:	5f                   	pop    %edi
80100466:	5d                   	pop    %ebp
80100467:	c3                   	ret    
80100468:	8b 45 10             	mov    0x10(%ebp),%eax
8010046b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010046d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100470:	73 d0                	jae    80100442 <consoleread+0xd2>
        input.r--;
80100472:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100478:	eb c8                	jmp    80100442 <consoleread+0xd2>
8010047a:	8b 45 10             	mov    0x10(%ebp),%eax
8010047d:	29 d8                	sub    %ebx,%eax
8010047f:	eb c1                	jmp    80100442 <consoleread+0xd2>
80100481:	eb 0d                	jmp    80100490 <panic>
80100483:	90                   	nop
80100484:	90                   	nop
80100485:	90                   	nop
80100486:	90                   	nop
80100487:	90                   	nop
80100488:	90                   	nop
80100489:	90                   	nop
8010048a:	90                   	nop
8010048b:	90                   	nop
8010048c:	90                   	nop
8010048d:	90                   	nop
8010048e:	90                   	nop
8010048f:	90                   	nop

80100490 <panic>:
{
80100490:	55                   	push   %ebp
80100491:	89 e5                	mov    %esp,%ebp
80100493:	56                   	push   %esi
80100494:	53                   	push   %ebx
80100495:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100498:	fa                   	cli    
  cons.locking = 0;
80100499:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801004a0:	00 00 00 
  getcallerpcs(&s, pcs);
801004a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801004a9:	e8 32 25 00 00       	call   801029e0 <lapicid>
801004ae:	83 ec 08             	sub    $0x8,%esp
801004b1:	50                   	push   %eax
801004b2:	68 cd 75 10 80       	push   $0x801075cd
801004b7:	e8 a4 02 00 00       	call   80100760 <cprintf>
  cprintf(s);
801004bc:	58                   	pop    %eax
801004bd:	ff 75 08             	pushl  0x8(%ebp)
801004c0:	e8 9b 02 00 00       	call   80100760 <cprintf>
  cprintf("\n");
801004c5:	c7 04 24 e2 7e 10 80 	movl   $0x80107ee2,(%esp)
801004cc:	e8 8f 02 00 00       	call   80100760 <cprintf>
  getcallerpcs(&s, pcs);
801004d1:	5a                   	pop    %edx
801004d2:	8d 45 08             	lea    0x8(%ebp),%eax
801004d5:	59                   	pop    %ecx
801004d6:	53                   	push   %ebx
801004d7:	50                   	push   %eax
801004d8:	e8 b3 3f 00 00       	call   80104490 <getcallerpcs>
801004dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004e0:	83 ec 08             	sub    $0x8,%esp
801004e3:	ff 33                	pushl  (%ebx)
801004e5:	83 c3 04             	add    $0x4,%ebx
801004e8:	68 e1 75 10 80       	push   $0x801075e1
801004ed:	e8 6e 02 00 00       	call   80100760 <cprintf>
  for(i=0; i<10; i++)
801004f2:	83 c4 10             	add    $0x10,%esp
801004f5:	39 f3                	cmp    %esi,%ebx
801004f7:	75 e7                	jne    801004e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100500:	00 00 00 
80100503:	eb fe                	jmp    80100503 <panic+0x73>
80100505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100510 <consputc>:
  if(panicked){
80100510:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100516:	85 c9                	test   %ecx,%ecx
80100518:	74 06                	je     80100520 <consputc+0x10>
8010051a:	fa                   	cli    
8010051b:	eb fe                	jmp    8010051b <consputc+0xb>
8010051d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100520:	55                   	push   %ebp
80100521:	89 e5                	mov    %esp,%ebp
80100523:	57                   	push   %edi
80100524:	56                   	push   %esi
80100525:	53                   	push   %ebx
80100526:	89 c6                	mov    %eax,%esi
80100528:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010052b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100530:	0f 84 b1 00 00 00    	je     801005e7 <consputc+0xd7>
    uartputc(c);
80100536:	83 ec 0c             	sub    $0xc,%esp
80100539:	50                   	push   %eax
8010053a:	e8 91 5a 00 00       	call   80105fd0 <uartputc>
8010053f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100542:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100547:	b8 0e 00 00 00       	mov    $0xe,%eax
8010054c:	89 da                	mov    %ebx,%edx
8010054e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010054f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100554:	89 ca                	mov    %ecx,%edx
80100556:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100557:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010055a:	89 da                	mov    %ebx,%edx
8010055c:	c1 e0 08             	shl    $0x8,%eax
8010055f:	89 c7                	mov    %eax,%edi
80100561:	b8 0f 00 00 00       	mov    $0xf,%eax
80100566:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100567:	89 ca                	mov    %ecx,%edx
80100569:	ec                   	in     (%dx),%al
8010056a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010056d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010056f:	83 fe 0a             	cmp    $0xa,%esi
80100572:	0f 84 f3 00 00 00    	je     8010066b <consputc+0x15b>
  else if(c == BACKSPACE){
80100578:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010057e:	0f 84 d7 00 00 00    	je     8010065b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100584:	89 f0                	mov    %esi,%eax
80100586:	0f b6 c0             	movzbl %al,%eax
80100589:	80 cc 07             	or     $0x7,%ah
8010058c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100593:	80 
80100594:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100597:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010059d:	0f 8f ab 00 00 00    	jg     8010064e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801005a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801005a9:	7f 66                	jg     80100611 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801005b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005b5:	89 f2                	mov    %esi,%edx
801005b7:	ee                   	out    %al,(%dx)
801005b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801005bd:	89 d8                	mov    %ebx,%eax
801005bf:	c1 f8 08             	sar    $0x8,%eax
801005c2:	89 ca                	mov    %ecx,%edx
801005c4:	ee                   	out    %al,(%dx)
801005c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801005ca:	89 f2                	mov    %esi,%edx
801005cc:	ee                   	out    %al,(%dx)
801005cd:	89 d8                	mov    %ebx,%eax
801005cf:	89 ca                	mov    %ecx,%edx
801005d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801005d2:	b8 20 07 00 00       	mov    $0x720,%eax
801005d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005de:	80 
}
801005df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005e2:	5b                   	pop    %ebx
801005e3:	5e                   	pop    %esi
801005e4:	5f                   	pop    %edi
801005e5:	5d                   	pop    %ebp
801005e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005e7:	83 ec 0c             	sub    $0xc,%esp
801005ea:	6a 08                	push   $0x8
801005ec:	e8 df 59 00 00       	call   80105fd0 <uartputc>
801005f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005f8:	e8 d3 59 00 00       	call   80105fd0 <uartputc>
801005fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100604:	e8 c7 59 00 00       	call   80105fd0 <uartputc>
80100609:	83 c4 10             	add    $0x10,%esp
8010060c:	e9 31 ff ff ff       	jmp    80100542 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100611:	52                   	push   %edx
80100612:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100617:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010061a:	68 a0 80 0b 80       	push   $0x800b80a0
8010061f:	68 00 80 0b 80       	push   $0x800b8000
80100624:	e8 67 41 00 00       	call   80104790 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100629:	b8 80 07 00 00       	mov    $0x780,%eax
8010062e:	83 c4 0c             	add    $0xc,%esp
80100631:	29 d8                	sub    %ebx,%eax
80100633:	01 c0                	add    %eax,%eax
80100635:	50                   	push   %eax
80100636:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100639:	6a 00                	push   $0x0
8010063b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100640:	50                   	push   %eax
80100641:	e8 9a 40 00 00       	call   801046e0 <memset>
80100646:	83 c4 10             	add    $0x10,%esp
80100649:	e9 5d ff ff ff       	jmp    801005ab <consputc+0x9b>
    panic("pos under/overflow");
8010064e:	83 ec 0c             	sub    $0xc,%esp
80100651:	68 e5 75 10 80       	push   $0x801075e5
80100656:	e8 35 fe ff ff       	call   80100490 <panic>
    if(pos > 0) --pos;
8010065b:	85 db                	test   %ebx,%ebx
8010065d:	0f 84 48 ff ff ff    	je     801005ab <consputc+0x9b>
80100663:	83 eb 01             	sub    $0x1,%ebx
80100666:	e9 2c ff ff ff       	jmp    80100597 <consputc+0x87>
    pos += 80 - pos%80;
8010066b:	89 d8                	mov    %ebx,%eax
8010066d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100672:	99                   	cltd   
80100673:	f7 f9                	idiv   %ecx
80100675:	29 d1                	sub    %edx,%ecx
80100677:	01 cb                	add    %ecx,%ebx
80100679:	e9 19 ff ff ff       	jmp    80100597 <consputc+0x87>
8010067e:	66 90                	xchg   %ax,%ax

80100680 <printint>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	89 d3                	mov    %edx,%ebx
80100688:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010068b:	85 c9                	test   %ecx,%ecx
{
8010068d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100690:	74 04                	je     80100696 <printint+0x16>
80100692:	85 c0                	test   %eax,%eax
80100694:	78 5a                	js     801006f0 <printint+0x70>
    x = xx;
80100696:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010069d:	31 c9                	xor    %ecx,%ecx
8010069f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801006a2:	eb 06                	jmp    801006aa <printint+0x2a>
801006a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801006a8:	89 f9                	mov    %edi,%ecx
801006aa:	31 d2                	xor    %edx,%edx
801006ac:	8d 79 01             	lea    0x1(%ecx),%edi
801006af:	f7 f3                	div    %ebx
801006b1:	0f b6 92 10 76 10 80 	movzbl -0x7fef89f0(%edx),%edx
  }while((x /= base) != 0);
801006b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801006ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801006bd:	75 e9                	jne    801006a8 <printint+0x28>
  if(sign)
801006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006c2:	85 c0                	test   %eax,%eax
801006c4:	74 08                	je     801006ce <printint+0x4e>
    buf[i++] = '-';
801006c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006cb:	8d 79 02             	lea    0x2(%ecx),%edi
801006ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801006d8:	0f be 03             	movsbl (%ebx),%eax
801006db:	83 eb 01             	sub    $0x1,%ebx
801006de:	e8 2d fe ff ff       	call   80100510 <consputc>
  while(--i >= 0)
801006e3:	39 f3                	cmp    %esi,%ebx
801006e5:	75 f1                	jne    801006d8 <printint+0x58>
}
801006e7:	83 c4 2c             	add    $0x2c,%esp
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop
    x = -xx;
801006f0:	f7 d8                	neg    %eax
801006f2:	eb a9                	jmp    8010069d <printint+0x1d>
801006f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100700 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 18             	sub    $0x18,%esp
80100709:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010070c:	ff 75 08             	pushl  0x8(%ebp)
8010070f:	e8 0c 13 00 00       	call   80101a20 <iunlock>
  acquire(&cons.lock);
80100714:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010071b:	e8 40 3e 00 00       	call   80104560 <acquire>
  for(i = 0; i < n; i++)
80100720:	83 c4 10             	add    $0x10,%esp
80100723:	85 f6                	test   %esi,%esi
80100725:	7e 18                	jle    8010073f <consolewrite+0x3f>
80100727:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010072a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010072d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100730:	0f b6 07             	movzbl (%edi),%eax
80100733:	83 c7 01             	add    $0x1,%edi
80100736:	e8 d5 fd ff ff       	call   80100510 <consputc>
  for(i = 0; i < n; i++)
8010073b:	39 fb                	cmp    %edi,%ebx
8010073d:	75 f1                	jne    80100730 <consolewrite+0x30>
  release(&cons.lock);
8010073f:	83 ec 0c             	sub    $0xc,%esp
80100742:	68 20 a5 10 80       	push   $0x8010a520
80100747:	e8 34 3f 00 00       	call   80104680 <release>
  ilock(ip);
8010074c:	58                   	pop    %eax
8010074d:	ff 75 08             	pushl  0x8(%ebp)
80100750:	e8 eb 11 00 00       	call   80101940 <ilock>

  return n;
}
80100755:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100758:	89 f0                	mov    %esi,%eax
8010075a:	5b                   	pop    %ebx
8010075b:	5e                   	pop    %esi
8010075c:	5f                   	pop    %edi
8010075d:	5d                   	pop    %ebp
8010075e:	c3                   	ret    
8010075f:	90                   	nop

80100760 <cprintf>:
{
80100760:	55                   	push   %ebp
80100761:	89 e5                	mov    %esp,%ebp
80100763:	57                   	push   %edi
80100764:	56                   	push   %esi
80100765:	53                   	push   %ebx
80100766:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100769:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010076e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100770:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100773:	0f 85 6f 01 00 00    	jne    801008e8 <cprintf+0x188>
  if (fmt == 0)
80100779:	8b 45 08             	mov    0x8(%ebp),%eax
8010077c:	85 c0                	test   %eax,%eax
8010077e:	89 c7                	mov    %eax,%edi
80100780:	0f 84 77 01 00 00    	je     801008fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100786:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100789:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010078e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100791:	85 c0                	test   %eax,%eax
80100793:	75 56                	jne    801007eb <cprintf+0x8b>
80100795:	eb 79                	jmp    80100810 <cprintf+0xb0>
80100797:	89 f6                	mov    %esi,%esi
80100799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801007a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801007a3:	85 d2                	test   %edx,%edx
801007a5:	74 69                	je     80100810 <cprintf+0xb0>
801007a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801007aa:	83 fa 70             	cmp    $0x70,%edx
801007ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007b0:	0f 84 84 00 00 00    	je     8010083a <cprintf+0xda>
801007b6:	7f 78                	jg     80100830 <cprintf+0xd0>
801007b8:	83 fa 25             	cmp    $0x25,%edx
801007bb:	0f 84 ff 00 00 00    	je     801008c0 <cprintf+0x160>
801007c1:	83 fa 64             	cmp    $0x64,%edx
801007c4:	0f 85 8e 00 00 00    	jne    80100858 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801007ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007d2:	8d 48 04             	lea    0x4(%eax),%ecx
801007d5:	8b 00                	mov    (%eax),%eax
801007d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007da:	b9 01 00 00 00       	mov    $0x1,%ecx
801007df:	e8 9c fe ff ff       	call   80100680 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e4:	0f b6 06             	movzbl (%esi),%eax
801007e7:	85 c0                	test   %eax,%eax
801007e9:	74 25                	je     80100810 <cprintf+0xb0>
801007eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801007ee:	83 f8 25             	cmp    $0x25,%eax
801007f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801007f4:	74 aa                	je     801007a0 <cprintf+0x40>
801007f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801007f9:	e8 12 fd ff ff       	call   80100510 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100801:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100804:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100806:	85 c0                	test   %eax,%eax
80100808:	75 e1                	jne    801007eb <cprintf+0x8b>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100810:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100813:	85 c0                	test   %eax,%eax
80100815:	74 10                	je     80100827 <cprintf+0xc7>
    release(&cons.lock);
80100817:	83 ec 0c             	sub    $0xc,%esp
8010081a:	68 20 a5 10 80       	push   $0x8010a520
8010081f:	e8 5c 3e 00 00       	call   80104680 <release>
80100824:	83 c4 10             	add    $0x10,%esp
}
80100827:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010082a:	5b                   	pop    %ebx
8010082b:	5e                   	pop    %esi
8010082c:	5f                   	pop    %edi
8010082d:	5d                   	pop    %ebp
8010082e:	c3                   	ret    
8010082f:	90                   	nop
    switch(c){
80100830:	83 fa 73             	cmp    $0x73,%edx
80100833:	74 43                	je     80100878 <cprintf+0x118>
80100835:	83 fa 78             	cmp    $0x78,%edx
80100838:	75 1e                	jne    80100858 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010083a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010083d:	ba 10 00 00 00       	mov    $0x10,%edx
80100842:	8d 48 04             	lea    0x4(%eax),%ecx
80100845:	8b 00                	mov    (%eax),%eax
80100847:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010084a:	31 c9                	xor    %ecx,%ecx
8010084c:	e8 2f fe ff ff       	call   80100680 <printint>
      break;
80100851:	eb 91                	jmp    801007e4 <cprintf+0x84>
80100853:	90                   	nop
80100854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100858:	b8 25 00 00 00       	mov    $0x25,%eax
8010085d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100860:	e8 ab fc ff ff       	call   80100510 <consputc>
      consputc(c);
80100865:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100868:	89 d0                	mov    %edx,%eax
8010086a:	e8 a1 fc ff ff       	call   80100510 <consputc>
      break;
8010086f:	e9 70 ff ff ff       	jmp    801007e4 <cprintf+0x84>
80100874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010087b:	8b 10                	mov    (%eax),%edx
8010087d:	8d 48 04             	lea    0x4(%eax),%ecx
80100880:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100883:	85 d2                	test   %edx,%edx
80100885:	74 49                	je     801008d0 <cprintf+0x170>
      for(; *s; s++)
80100887:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010088a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010088d:	84 c0                	test   %al,%al
8010088f:	0f 84 4f ff ff ff    	je     801007e4 <cprintf+0x84>
80100895:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100898:	89 d3                	mov    %edx,%ebx
8010089a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801008a3:	e8 68 fc ff ff       	call   80100510 <consputc>
      for(; *s; s++)
801008a8:	0f be 03             	movsbl (%ebx),%eax
801008ab:	84 c0                	test   %al,%al
801008ad:	75 f1                	jne    801008a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008b8:	e9 27 ff ff ff       	jmp    801007e4 <cprintf+0x84>
801008bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801008c0:	b8 25 00 00 00       	mov    $0x25,%eax
801008c5:	e8 46 fc ff ff       	call   80100510 <consputc>
      break;
801008ca:	e9 15 ff ff ff       	jmp    801007e4 <cprintf+0x84>
801008cf:	90                   	nop
        s = "(null)";
801008d0:	ba f8 75 10 80       	mov    $0x801075f8,%edx
      for(; *s; s++)
801008d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008d8:	b8 28 00 00 00       	mov    $0x28,%eax
801008dd:	89 d3                	mov    %edx,%ebx
801008df:	eb bf                	jmp    801008a0 <cprintf+0x140>
801008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801008e8:	83 ec 0c             	sub    $0xc,%esp
801008eb:	68 20 a5 10 80       	push   $0x8010a520
801008f0:	e8 6b 3c 00 00       	call   80104560 <acquire>
801008f5:	83 c4 10             	add    $0x10,%esp
801008f8:	e9 7c fe ff ff       	jmp    80100779 <cprintf+0x19>
    panic("null fmt");
801008fd:	83 ec 0c             	sub    $0xc,%esp
80100900:	68 ff 75 10 80       	push   $0x801075ff
80100905:	e8 86 fb ff ff       	call   80100490 <panic>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100910 <consoleintr>:
{
80100910:	55                   	push   %ebp
80100911:	89 e5                	mov    %esp,%ebp
80100913:	57                   	push   %edi
80100914:	56                   	push   %esi
80100915:	53                   	push   %ebx
  int c, doprocdump = 0;
80100916:	31 f6                	xor    %esi,%esi
{
80100918:	83 ec 18             	sub    $0x18,%esp
8010091b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010091e:	68 20 a5 10 80       	push   $0x8010a520
80100923:	e8 38 3c 00 00       	call   80104560 <acquire>
  while((c = getc()) >= 0){
80100928:	83 c4 10             	add    $0x10,%esp
8010092b:	90                   	nop
8010092c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100930:	ff d3                	call   *%ebx
80100932:	85 c0                	test   %eax,%eax
80100934:	89 c7                	mov    %eax,%edi
80100936:	78 48                	js     80100980 <consoleintr+0x70>
    switch(c){
80100938:	83 ff 10             	cmp    $0x10,%edi
8010093b:	0f 84 e7 00 00 00    	je     80100a28 <consoleintr+0x118>
80100941:	7e 5d                	jle    801009a0 <consoleintr+0x90>
80100943:	83 ff 15             	cmp    $0x15,%edi
80100946:	0f 84 ec 00 00 00    	je     80100a38 <consoleintr+0x128>
8010094c:	83 ff 7f             	cmp    $0x7f,%edi
8010094f:	75 54                	jne    801009a5 <consoleintr+0x95>
      if(input.e != input.w){
80100951:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100956:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010095c:	74 d2                	je     80100930 <consoleintr+0x20>
        input.e--;
8010095e:	83 e8 01             	sub    $0x1,%eax
80100961:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100966:	b8 00 01 00 00       	mov    $0x100,%eax
8010096b:	e8 a0 fb ff ff       	call   80100510 <consputc>
  while((c = getc()) >= 0){
80100970:	ff d3                	call   *%ebx
80100972:	85 c0                	test   %eax,%eax
80100974:	89 c7                	mov    %eax,%edi
80100976:	79 c0                	jns    80100938 <consoleintr+0x28>
80100978:	90                   	nop
80100979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100980:	83 ec 0c             	sub    $0xc,%esp
80100983:	68 20 a5 10 80       	push   $0x8010a520
80100988:	e8 f3 3c 00 00       	call   80104680 <release>
  if(doprocdump) {
8010098d:	83 c4 10             	add    $0x10,%esp
80100990:	85 f6                	test   %esi,%esi
80100992:	0f 85 f8 00 00 00    	jne    80100a90 <consoleintr+0x180>
}
80100998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010099b:	5b                   	pop    %ebx
8010099c:	5e                   	pop    %esi
8010099d:	5f                   	pop    %edi
8010099e:	5d                   	pop    %ebp
8010099f:	c3                   	ret    
    switch(c){
801009a0:	83 ff 08             	cmp    $0x8,%edi
801009a3:	74 ac                	je     80100951 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a5:	85 ff                	test   %edi,%edi
801009a7:	74 87                	je     80100930 <consoleintr+0x20>
801009a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801009ae:	89 c2                	mov    %eax,%edx
801009b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801009b6:	83 fa 7f             	cmp    $0x7f,%edx
801009b9:	0f 87 71 ff ff ff    	ja     80100930 <consoleintr+0x20>
801009bf:	8d 50 01             	lea    0x1(%eax),%edx
801009c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801009ce:	0f 84 cc 00 00 00    	je     80100aa0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801009d4:	89 f9                	mov    %edi,%ecx
801009d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801009dc:	89 f8                	mov    %edi,%eax
801009de:	e8 2d fb ff ff       	call   80100510 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009e3:	83 ff 0a             	cmp    $0xa,%edi
801009e6:	0f 84 c5 00 00 00    	je     80100ab1 <consoleintr+0x1a1>
801009ec:	83 ff 04             	cmp    $0x4,%edi
801009ef:	0f 84 bc 00 00 00    	je     80100ab1 <consoleintr+0x1a1>
801009f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801009fa:	83 e8 80             	sub    $0xffffff80,%eax
801009fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100a03:	0f 85 27 ff ff ff    	jne    80100930 <consoleintr+0x20>
          wakeup(&input.r);
80100a09:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a0c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100a11:	68 c0 ff 10 80       	push   $0x8010ffc0
80100a16:	e8 a5 37 00 00       	call   801041c0 <wakeup>
80100a1b:	83 c4 10             	add    $0x10,%esp
80100a1e:	e9 0d ff ff ff       	jmp    80100930 <consoleintr+0x20>
80100a23:	90                   	nop
80100a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100a28:	be 01 00 00 00       	mov    $0x1,%esi
80100a2d:	e9 fe fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100a38:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100a3d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100a43:	75 2b                	jne    80100a70 <consoleintr+0x160>
80100a45:	e9 e6 fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100a50:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100a55:	b8 00 01 00 00       	mov    $0x100,%eax
80100a5a:	e8 b1 fa ff ff       	call   80100510 <consputc>
      while(input.e != input.w &&
80100a5f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100a64:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100a6a:	0f 84 c0 fe ff ff    	je     80100930 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a70:	83 e8 01             	sub    $0x1,%eax
80100a73:	89 c2                	mov    %eax,%edx
80100a75:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a78:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100a7f:	75 cf                	jne    80100a50 <consoleintr+0x140>
80100a81:	e9 aa fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a86:	8d 76 00             	lea    0x0(%esi),%esi
80100a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a93:	5b                   	pop    %ebx
80100a94:	5e                   	pop    %esi
80100a95:	5f                   	pop    %edi
80100a96:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a97:	e9 04 38 00 00       	jmp    801042a0 <procdump>
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100aa0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100aa7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100aac:	e8 5f fa ff ff       	call   80100510 <consputc>
80100ab1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100ab6:	e9 4e ff ff ff       	jmp    80100a09 <consoleintr+0xf9>
80100abb:	90                   	nop
80100abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ac0 <consoleinit>:

void
consoleinit(void)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ac6:	68 08 76 10 80       	push   $0x80107608
80100acb:	68 20 a5 10 80       	push   $0x8010a520
80100ad0:	e8 9b 39 00 00       	call   80104470 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad5:	58                   	pop    %eax
80100ad6:	5a                   	pop    %edx
80100ad7:	6a 00                	push   $0x0
80100ad9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100adb:	c7 05 8c 09 11 80 00 	movl   $0x80100700,0x8011098c
80100ae2:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae5:	c7 05 88 09 11 80 70 	movl   $0x80100370,0x80110988
80100aec:	03 10 80 
  cons.locking = 1;
80100aef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100af6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af9:	e8 82 1a 00 00       	call   80102580 <ioapicenable>
}
80100afe:	83 c4 10             	add    $0x10,%esp
80100b01:	c9                   	leave  
80100b02:	c3                   	ret    
80100b03:	66 90                	xchg   %ax,%ax
80100b05:	66 90                	xchg   %ax,%ax
80100b07:	66 90                	xchg   %ax,%ax
80100b09:	66 90                	xchg   %ax,%ax
80100b0b:	66 90                	xchg   %ax,%ax
80100b0d:	66 90                	xchg   %ax,%ax
80100b0f:	90                   	nop

80100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 6f 2f 00 00       	call   80103a90 <myproc>
80100b21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100b27:	e8 24 23 00 00       	call   80102e50 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 69 16 00 00       	call   801021a0 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 91 01 00 00    	je     80100cd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c3                	mov    %eax,%ebx
80100b47:	50                   	push   %eax
80100b48:	e8 f3 0d 00 00       	call   80101940 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	53                   	push   %ebx
80100b59:	e8 c2 10 00 00       	call   80101c20 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	74 22                	je     80100b88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 61 10 00 00       	call   80101bd0 <iunlockput>
    end_op();
80100b6f:	e8 4c 23 00 00       	call   80102ec0 <end_op>
80100b74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b7f:	5b                   	pop    %ebx
80100b80:	5e                   	pop    %esi
80100b81:	5f                   	pop    %edi
80100b82:	5d                   	pop    %ebp
80100b83:	c3                   	ret    
80100b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b8f:	45 4c 46 
80100b92:	75 d2                	jne    80100b66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b94:	e8 07 68 00 00       	call   801073a0 <setupkvm>
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	74 c3                	je     80100b66 <exec+0x56>
  sz = 0;
80100ba3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bac:	00 
80100bad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100bb3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bb9:	0f 84 8c 02 00 00    	je     80100e4b <exec+0x33b>
80100bbf:	31 f6                	xor    %esi,%esi
80100bc1:	eb 7f                	jmp    80100c42 <exec+0x132>
80100bc3:	90                   	nop
80100bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bc8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bcf:	75 63                	jne    80100c34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100bd1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bd7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bdd:	0f 82 86 00 00 00    	jb     80100c69 <exec+0x159>
80100be3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100be9:	72 7e                	jb     80100c69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100beb:	83 ec 04             	sub    $0x4,%esp
80100bee:	50                   	push   %eax
80100bef:	57                   	push   %edi
80100bf0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf6:	e8 45 63 00 00       	call   80106f40 <allocuvm>
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	85 c0                	test   %eax,%eax
80100c00:	89 c7                	mov    %eax,%edi
80100c02:	74 65                	je     80100c69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100c04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c0f:	75 58                	jne    80100c69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c11:	83 ec 0c             	sub    $0xc,%esp
80100c14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c20:	53                   	push   %ebx
80100c21:	50                   	push   %eax
80100c22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c28:	e8 53 62 00 00       	call   80106e80 <loaduvm>
80100c2d:	83 c4 20             	add    $0x20,%esp
80100c30:	85 c0                	test   %eax,%eax
80100c32:	78 35                	js     80100c69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c3b:	83 c6 01             	add    $0x1,%esi
80100c3e:	39 f0                	cmp    %esi,%eax
80100c40:	7e 3d                	jle    80100c7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c42:	89 f0                	mov    %esi,%eax
80100c44:	6a 20                	push   $0x20
80100c46:	c1 e0 05             	shl    $0x5,%eax
80100c49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100c4f:	50                   	push   %eax
80100c50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c56:	50                   	push   %eax
80100c57:	53                   	push   %ebx
80100c58:	e8 c3 0f 00 00       	call   80101c20 <readi>
80100c5d:	83 c4 10             	add    $0x10,%esp
80100c60:	83 f8 20             	cmp    $0x20,%eax
80100c63:	0f 84 5f ff ff ff    	je     80100bc8 <exec+0xb8>
    freevm(pgdir);
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c72:	e8 a9 66 00 00       	call   80107320 <freevm>
80100c77:	83 c4 10             	add    $0x10,%esp
80100c7a:	e9 e7 fe ff ff       	jmp    80100b66 <exec+0x56>
80100c7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c91:	83 ec 0c             	sub    $0xc,%esp
80100c94:	53                   	push   %ebx
80100c95:	e8 36 0f 00 00       	call   80101bd0 <iunlockput>
  end_op();
80100c9a:	e8 21 22 00 00       	call   80102ec0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9f:	83 c4 0c             	add    $0xc,%esp
80100ca2:	56                   	push   %esi
80100ca3:	57                   	push   %edi
80100ca4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100caa:	e8 91 62 00 00       	call   80106f40 <allocuvm>
80100caf:	83 c4 10             	add    $0x10,%esp
80100cb2:	85 c0                	test   %eax,%eax
80100cb4:	89 c6                	mov    %eax,%esi
80100cb6:	75 3a                	jne    80100cf2 <exec+0x1e2>
    freevm(pgdir);
80100cb8:	83 ec 0c             	sub    $0xc,%esp
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc1:	e8 5a 66 00 00       	call   80107320 <freevm>
80100cc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cce:	e9 a9 fe ff ff       	jmp    80100b7c <exec+0x6c>
    end_op();
80100cd3:	e8 e8 21 00 00       	call   80102ec0 <end_op>
    cprintf("exec: fail\n");
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	68 21 76 10 80       	push   $0x80107621
80100ce0:	e8 7b fa ff ff       	call   80100760 <cprintf>
    return -1;
80100ce5:	83 c4 10             	add    $0x10,%esp
80100ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ced:	e9 8a fe ff ff       	jmp    80100b7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100cf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100cfb:	31 ff                	xor    %edi,%edi
80100cfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cff:	50                   	push   %eax
80100d00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d06:	e8 25 64 00 00       	call   80107130 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d0e:	83 c4 10             	add    $0x10,%esp
80100d11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d17:	8b 00                	mov    (%eax),%eax
80100d19:	85 c0                	test   %eax,%eax
80100d1b:	74 70                	je     80100d8d <exec+0x27d>
80100d1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d29:	eb 0a                	jmp    80100d35 <exec+0x225>
80100d2b:	90                   	nop
80100d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100d30:	83 ff 20             	cmp    $0x20,%edi
80100d33:	74 83                	je     80100cb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	83 ec 0c             	sub    $0xc,%esp
80100d38:	50                   	push   %eax
80100d39:	e8 c2 3b 00 00       	call   80104900 <strlen>
80100d3e:	f7 d0                	not    %eax
80100d40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d4c:	e8 af 3b 00 00       	call   80104900 <strlen>
80100d51:	83 c0 01             	add    $0x1,%eax
80100d54:	50                   	push   %eax
80100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d5b:	53                   	push   %ebx
80100d5c:	56                   	push   %esi
80100d5d:	e8 5e 64 00 00       	call   801071c0 <copyout>
80100d62:	83 c4 20             	add    $0x20,%esp
80100d65:	85 c0                	test   %eax,%eax
80100d67:	0f 88 4b ff ff ff    	js     80100cb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d83:	85 c0                	test   %eax,%eax
80100d85:	75 a9                	jne    80100d30 <exec+0x220>
80100d87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100da1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100da8:	ff ff ff 
  ustack[1] = argc;
80100dab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100db3:	83 c0 0c             	add    $0xc,%eax
80100db6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db8:	50                   	push   %eax
80100db9:	52                   	push   %edx
80100dba:	53                   	push   %ebx
80100dbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc7:	e8 f4 63 00 00       	call   801071c0 <copyout>
80100dcc:	83 c4 10             	add    $0x10,%esp
80100dcf:	85 c0                	test   %eax,%eax
80100dd1:	0f 88 e1 fe ff ff    	js     80100cb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dda:	0f b6 00             	movzbl (%eax),%eax
80100ddd:	84 c0                	test   %al,%al
80100ddf:	74 17                	je     80100df8 <exec+0x2e8>
80100de1:	8b 55 08             	mov    0x8(%ebp),%edx
80100de4:	89 d1                	mov    %edx,%ecx
80100de6:	83 c1 01             	add    $0x1,%ecx
80100de9:	3c 2f                	cmp    $0x2f,%al
80100deb:	0f b6 01             	movzbl (%ecx),%eax
80100dee:	0f 44 d1             	cmove  %ecx,%edx
80100df1:	84 c0                	test   %al,%al
80100df3:	75 f1                	jne    80100de6 <exec+0x2d6>
80100df5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100df8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100dfe:	50                   	push   %eax
80100dff:	6a 10                	push   $0x10
80100e01:	ff 75 08             	pushl  0x8(%ebp)
80100e04:	89 f8                	mov    %edi,%eax
80100e06:	83 c0 6c             	add    $0x6c,%eax
80100e09:	50                   	push   %eax
80100e0a:	e8 b1 3a 00 00       	call   801048c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100e0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100e15:	89 f9                	mov    %edi,%ecx
80100e17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100e1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100e1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100e1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100e22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100e2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e31:	89 0c 24             	mov    %ecx,(%esp)
80100e34:	e8 b7 5e 00 00       	call   80106cf0 <switchuvm>
  freevm(oldpgdir);
80100e39:	89 3c 24             	mov    %edi,(%esp)
80100e3c:	e8 df 64 00 00       	call   80107320 <freevm>
  return 0;
80100e41:	83 c4 10             	add    $0x10,%esp
80100e44:	31 c0                	xor    %eax,%eax
80100e46:	e9 31 fd ff ff       	jmp    80100b7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100e50:	e9 3c fe ff ff       	jmp    80100c91 <exec+0x181>
80100e55:	66 90                	xchg   %ax,%ax
80100e57:	66 90                	xchg   %ax,%ax
80100e59:	66 90                	xchg   %ax,%ax
80100e5b:	66 90                	xchg   %ax,%ax
80100e5d:	66 90                	xchg   %ax,%ax
80100e5f:	90                   	nop

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 2d 76 10 80       	push   $0x8010762d
80100e6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e70:	e8 fb 35 00 00       	call   80104470 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave  
80100e79:	c3                   	ret    
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e91:	e8 ca 36 00 00       	call   80104560 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	90                   	nop
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100ea9:	73 25                	jae    80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100ec1:	e8 ba 37 00 00       	call   80104680 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave  
80100ecf:	c3                   	ret    
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 e0 ff 10 80       	push   $0x8010ffe0
80100eda:	e8 a1 37 00 00       	call   80104680 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave  
80100ee8:	c3                   	ret    
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100eff:	e8 5c 36 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100f1c:	e8 5f 37 00 00       	call   80104680 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 34 76 10 80       	push   $0x80107634
80100f30:	e8 5b f5 ff ff       	call   80100490 <panic>
80100f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100f51:	e8 0a 36 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100f56:	8b 43 04             	mov    0x4(%ebx),%eax
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 c0                	test   %eax,%eax
80100f5e:	0f 8e 9b 00 00 00    	jle    80100fff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 e8 01             	sub    $0x1,%eax
80100f67:	85 c0                	test   %eax,%eax
80100f69:	89 43 04             	mov    %eax,0x4(%ebx)
80100f6c:	74 1a                	je     80100f88 <fileclose+0x48>
    release(&ftable.lock);
80100f6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f78:	5b                   	pop    %ebx
80100f79:	5e                   	pop    %esi
80100f7a:	5f                   	pop    %edi
80100f7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7c:	e9 ff 36 00 00       	jmp    80104680 <release>
80100f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fa0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa8:	e8 d3 36 00 00       	call   80104680 <release>
  if(ff.type == FD_PIPE)
80100fad:	83 c4 10             	add    $0x10,%esp
80100fb0:	83 ff 01             	cmp    $0x1,%edi
80100fb3:	74 13                	je     80100fc8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100fb5:	83 ff 02             	cmp    $0x2,%edi
80100fb8:	74 26                	je     80100fe0 <fileclose+0xa0>
}
80100fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbd:	5b                   	pop    %ebx
80100fbe:	5e                   	pop    %esi
80100fbf:	5f                   	pop    %edi
80100fc0:	5d                   	pop    %ebp
80100fc1:	c3                   	ret    
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100fc8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fcc:	83 ec 08             	sub    $0x8,%esp
80100fcf:	53                   	push   %ebx
80100fd0:	56                   	push   %esi
80100fd1:	e8 2a 26 00 00       	call   80103600 <pipeclose>
80100fd6:	83 c4 10             	add    $0x10,%esp
80100fd9:	eb df                	jmp    80100fba <fileclose+0x7a>
80100fdb:	90                   	nop
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe0:	e8 6b 1e 00 00       	call   80102e50 <begin_op>
    iput(ff.ip);
80100fe5:	83 ec 0c             	sub    $0xc,%esp
80100fe8:	ff 75 e0             	pushl  -0x20(%ebp)
80100feb:	e8 80 0a 00 00       	call   80101a70 <iput>
    end_op();
80100ff0:	83 c4 10             	add    $0x10,%esp
}
80100ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff6:	5b                   	pop    %ebx
80100ff7:	5e                   	pop    %esi
80100ff8:	5f                   	pop    %edi
80100ff9:	5d                   	pop    %ebp
    end_op();
80100ffa:	e9 c1 1e 00 00       	jmp    80102ec0 <end_op>
    panic("fileclose");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 3c 76 10 80       	push   $0x8010763c
80101007:	e8 84 f4 ff ff       	call   80100490 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	53                   	push   %ebx
80101014:	83 ec 04             	sub    $0x4,%esp
80101017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010101a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010101d:	75 31                	jne    80101050 <filestat+0x40>
    ilock(f->ip);
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	ff 73 10             	pushl  0x10(%ebx)
80101025:	e8 16 09 00 00       	call   80101940 <ilock>
    stati(f->ip, st);
8010102a:	58                   	pop    %eax
8010102b:	5a                   	pop    %edx
8010102c:	ff 75 0c             	pushl  0xc(%ebp)
8010102f:	ff 73 10             	pushl  0x10(%ebx)
80101032:	e8 b9 0b 00 00       	call   80101bf0 <stati>
    iunlock(f->ip);
80101037:	59                   	pop    %ecx
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 e0 09 00 00       	call   80101a20 <iunlock>
    return 0;
80101040:	83 c4 10             	add    $0x10,%esp
80101043:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101048:	c9                   	leave  
80101049:	c3                   	ret    
8010104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101055:	eb ee                	jmp    80101045 <filestat+0x35>
80101057:	89 f6                	mov    %esi,%esi
80101059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101060 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 0c             	sub    $0xc,%esp
80101069:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010106c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010106f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101072:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101076:	74 60                	je     801010d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101078:	8b 03                	mov    (%ebx),%eax
8010107a:	83 f8 01             	cmp    $0x1,%eax
8010107d:	74 41                	je     801010c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010107f:	83 f8 02             	cmp    $0x2,%eax
80101082:	75 5b                	jne    801010df <fileread+0x7f>
    ilock(f->ip);
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	ff 73 10             	pushl  0x10(%ebx)
8010108a:	e8 b1 08 00 00       	call   80101940 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010108f:	57                   	push   %edi
80101090:	ff 73 14             	pushl  0x14(%ebx)
80101093:	56                   	push   %esi
80101094:	ff 73 10             	pushl  0x10(%ebx)
80101097:	e8 84 0b 00 00       	call   80101c20 <readi>
8010109c:	83 c4 20             	add    $0x20,%esp
8010109f:	85 c0                	test   %eax,%eax
801010a1:	89 c6                	mov    %eax,%esi
801010a3:	7e 03                	jle    801010a8 <fileread+0x48>
      f->off += r;
801010a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff 73 10             	pushl  0x10(%ebx)
801010ae:	e8 6d 09 00 00       	call   80101a20 <iunlock>
    return r;
801010b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b9:	89 f0                	mov    %esi,%eax
801010bb:	5b                   	pop    %ebx
801010bc:	5e                   	pop    %esi
801010bd:	5f                   	pop    %edi
801010be:	5d                   	pop    %ebp
801010bf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	5b                   	pop    %ebx
801010ca:	5e                   	pop    %esi
801010cb:	5f                   	pop    %edi
801010cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010cd:	e9 de 26 00 00       	jmp    801037b0 <piperead>
801010d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010dd:	eb d7                	jmp    801010b6 <fileread+0x56>
  panic("fileread");
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	68 46 76 10 80       	push   $0x80107646
801010e7:	e8 a4 f3 ff ff       	call   80100490 <panic>
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 1c             	sub    $0x1c,%esp
801010f9:	8b 75 08             	mov    0x8(%ebp),%esi
801010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010ff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101103:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101106:	8b 45 10             	mov    0x10(%ebp),%eax
80101109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010110c:	0f 84 aa 00 00 00    	je     801011bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101112:	8b 06                	mov    (%esi),%eax
80101114:	83 f8 01             	cmp    $0x1,%eax
80101117:	0f 84 c3 00 00 00    	je     801011e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010111d:	83 f8 02             	cmp    $0x2,%eax
80101120:	0f 85 d9 00 00 00    	jne    801011ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101129:	31 ff                	xor    %edi,%edi
    while(i < n){
8010112b:	85 c0                	test   %eax,%eax
8010112d:	7f 34                	jg     80101163 <filewrite+0x73>
8010112f:	e9 9c 00 00 00       	jmp    801011d0 <filewrite+0xe0>
80101134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101138:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
8010113e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101141:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101144:	e8 d7 08 00 00       	call   80101a20 <iunlock>
      end_op();
80101149:	e8 72 1d 00 00       	call   80102ec0 <end_op>
8010114e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101151:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101154:	39 c3                	cmp    %eax,%ebx
80101156:	0f 85 96 00 00 00    	jne    801011f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010115c:	01 df                	add    %ebx,%edi
    while(i < n){
8010115e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101161:	7e 6d                	jle    801011d0 <filewrite+0xe0>
      int n1 = n - i;
80101163:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101166:	b8 00 06 00 00       	mov    $0x600,%eax
8010116b:	29 fb                	sub    %edi,%ebx
8010116d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101173:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101176:	e8 d5 1c 00 00       	call   80102e50 <begin_op>
      ilock(f->ip);
8010117b:	83 ec 0c             	sub    $0xc,%esp
8010117e:	ff 76 10             	pushl  0x10(%esi)
80101181:	e8 ba 07 00 00       	call   80101940 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	53                   	push   %ebx
8010118a:	ff 76 14             	pushl  0x14(%esi)
8010118d:	01 f8                	add    %edi,%eax
8010118f:	50                   	push   %eax
80101190:	ff 76 10             	pushl  0x10(%esi)
80101193:	e8 88 0b 00 00       	call   80101d20 <writei>
80101198:	83 c4 20             	add    $0x20,%esp
8010119b:	85 c0                	test   %eax,%eax
8010119d:	7f 99                	jg     80101138 <filewrite+0x48>
      iunlock(f->ip);
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	ff 76 10             	pushl  0x10(%esi)
801011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011a8:	e8 73 08 00 00       	call   80101a20 <iunlock>
      end_op();
801011ad:	e8 0e 1d 00 00       	call   80102ec0 <end_op>
      if(r < 0)
801011b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b5:	83 c4 10             	add    $0x10,%esp
801011b8:	85 c0                	test   %eax,%eax
801011ba:	74 98                	je     80101154 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801011bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801011c4:	89 f8                	mov    %edi,%eax
801011c6:	5b                   	pop    %ebx
801011c7:	5e                   	pop    %esi
801011c8:	5f                   	pop    %edi
801011c9:	5d                   	pop    %ebp
801011ca:	c3                   	ret    
801011cb:	90                   	nop
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801011d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011d3:	75 e7                	jne    801011bc <filewrite+0xcc>
}
801011d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d8:	89 f8                	mov    %edi,%eax
801011da:	5b                   	pop    %ebx
801011db:	5e                   	pop    %esi
801011dc:	5f                   	pop    %edi
801011dd:	5d                   	pop    %ebp
801011de:	c3                   	ret    
801011df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801011e0:	8b 46 0c             	mov    0xc(%esi),%eax
801011e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e9:	5b                   	pop    %ebx
801011ea:	5e                   	pop    %esi
801011eb:	5f                   	pop    %edi
801011ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011ed:	e9 ae 24 00 00       	jmp    801036a0 <pipewrite>
        panic("short filewrite");
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	68 4f 76 10 80       	push   $0x8010764f
801011fa:	e8 91 f2 ff ff       	call   80100490 <panic>
  panic("filewrite");
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	68 55 76 10 80       	push   $0x80107655
80101207:	e8 84 f2 ff ff       	call   80100490 <panic>
8010120c:	66 90                	xchg   %ax,%ax
8010120e:	66 90                	xchg   %ax,%ax

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010121f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 87 00 00 00    	je     801012b1 <balloc+0xa1>
8010122a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101231:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101234:	83 ec 08             	sub    $0x8,%esp
80101237:	89 f0                	mov    %esi,%eax
80101239:	c1 f8 0c             	sar    $0xc,%eax
8010123c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101242:	50                   	push   %eax
80101243:	ff 75 d8             	pushl  -0x28(%ebp)
80101246:	e8 85 ee ff ff       	call   801000d0 <bread>
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101259:	31 c0                	xor    %eax,%eax
8010125b:	eb 2f                	jmp    8010128c <balloc+0x7c>
8010125d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101265:	bb 01 00 00 00       	mov    $0x1,%ebx
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101279:	85 df                	test   %ebx,%edi
8010127b:	89 fa                	mov    %edi,%edx
8010127d:	74 41                	je     801012c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 05                	je     80101291 <balloc+0x81>
8010128c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010128f:	77 cf                	ja     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101291:	83 ec 0c             	sub    $0xc,%esp
80101294:	ff 75 e4             	pushl  -0x1c(%ebp)
80101297:	e8 44 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012a3:	83 c4 10             	add    $0x10,%esp
801012a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012a9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801012af:	77 80                	ja     80101231 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 5f 76 10 80       	push   $0x8010765f
801012b9:	e8 d2 f1 ff ff       	call   80100490 <panic>
801012be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012c6:	09 da                	or     %ebx,%edx
801012c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012cc:	57                   	push   %edi
801012cd:	e8 4e 1d 00 00       	call   80103020 <log_write>
        brelse(bp);
801012d2:	89 3c 24             	mov    %edi,(%esp)
801012d5:	e8 06 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801012da:	58                   	pop    %eax
801012db:	5a                   	pop    %edx
801012dc:	56                   	push   %esi
801012dd:	ff 75 d8             	pushl  -0x28(%ebp)
801012e0:	e8 eb ed ff ff       	call   801000d0 <bread>
801012e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ea:	83 c4 0c             	add    $0xc,%esp
801012ed:	68 00 02 00 00       	push   $0x200
801012f2:	6a 00                	push   $0x0
801012f4:	50                   	push   %eax
801012f5:	e8 e6 33 00 00       	call   801046e0 <memset>
  log_write(bp);
801012fa:	89 1c 24             	mov    %ebx,(%esp)
801012fd:	e8 1e 1d 00 00       	call   80103020 <log_write>
  brelse(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 d6 ee ff ff       	call   801001e0 <brelse>
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 f0                	mov    %esi,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010131a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101328:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 00 0a 11 80       	push   $0x80110a00
8010133a:	e8 21 32 00 00       	call   80104560 <acquire>
8010133f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101345:	eb 17                	jmp    8010135e <iget+0x3e>
80101347:	89 f6                	mov    %esi,%esi
80101349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101350:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101356:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010135c:	73 22                	jae    80101380 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010135e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101361:	85 c9                	test   %ecx,%ecx
80101363:	7e 04                	jle    80101369 <iget+0x49>
80101365:	39 3b                	cmp    %edi,(%ebx)
80101367:	74 4f                	je     801013b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 f6                	test   %esi,%esi
8010136b:	75 e3                	jne    80101350 <iget+0x30>
8010136d:	85 c9                	test   %ecx,%ecx
8010136f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101372:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101378:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010137e:	72 de                	jb     8010135e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101380:	85 f6                	test   %esi,%esi
80101382:	74 5b                	je     801013df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101384:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101387:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101389:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010138c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101393:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010139a:	68 00 0a 11 80       	push   $0x80110a00
8010139f:	e8 dc 32 00 00       	call   80104680 <release>

  return ip;
801013a4:	83 c4 10             	add    $0x10,%esp
}
801013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013aa:	89 f0                	mov    %esi,%eax
801013ac:	5b                   	pop    %ebx
801013ad:	5e                   	pop    %esi
801013ae:	5f                   	pop    %edi
801013af:	5d                   	pop    %ebp
801013b0:	c3                   	ret    
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013bb:	75 ac                	jne    80101369 <iget+0x49>
      release(&icache.lock);
801013bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013c5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801013ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013cd:	e8 ae 32 00 00       	call   80104680 <release>
      return ip;
801013d2:	83 c4 10             	add    $0x10,%esp
}
801013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d8:	89 f0                	mov    %esi,%eax
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
    panic("iget: no inodes");
801013df:	83 ec 0c             	sub    $0xc,%esp
801013e2:	68 75 76 10 80       	push   $0x80107675
801013e7:	e8 a4 f0 ff ff       	call   80100490 <panic>
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	56                   	push   %esi
801013f5:	53                   	push   %ebx
801013f6:	89 c6                	mov    %eax,%esi
801013f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013fb:	83 fa 0b             	cmp    $0xb,%edx
801013fe:	77 18                	ja     80101418 <bmap+0x28>
80101400:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101403:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101406:	85 db                	test   %ebx,%ebx
80101408:	74 76                	je     80101480 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140d:	89 d8                	mov    %ebx,%eax
8010140f:	5b                   	pop    %ebx
80101410:	5e                   	pop    %esi
80101411:	5f                   	pop    %edi
80101412:	5d                   	pop    %ebp
80101413:	c3                   	ret    
80101414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101418:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010141b:	83 fb 7f             	cmp    $0x7f,%ebx
8010141e:	0f 87 90 00 00 00    	ja     801014b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101424:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010142a:	8b 00                	mov    (%eax),%eax
8010142c:	85 d2                	test   %edx,%edx
8010142e:	74 70                	je     801014a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101430:	83 ec 08             	sub    $0x8,%esp
80101433:	52                   	push   %edx
80101434:	50                   	push   %eax
80101435:	e8 96 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010143a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010143e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101441:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101443:	8b 1a                	mov    (%edx),%ebx
80101445:	85 db                	test   %ebx,%ebx
80101447:	75 1d                	jne    80101466 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101449:	8b 06                	mov    (%esi),%eax
8010144b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010144e:	e8 bd fd ff ff       	call   80101210 <balloc>
80101453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101456:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101459:	89 c3                	mov    %eax,%ebx
8010145b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010145d:	57                   	push   %edi
8010145e:	e8 bd 1b 00 00       	call   80103020 <log_write>
80101463:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101466:	83 ec 0c             	sub    $0xc,%esp
80101469:	57                   	push   %edi
8010146a:	e8 71 ed ff ff       	call   801001e0 <brelse>
8010146f:	83 c4 10             	add    $0x10,%esp
}
80101472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101475:	89 d8                	mov    %ebx,%eax
80101477:	5b                   	pop    %ebx
80101478:	5e                   	pop    %esi
80101479:	5f                   	pop    %edi
8010147a:	5d                   	pop    %ebp
8010147b:	c3                   	ret    
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101480:	8b 00                	mov    (%eax),%eax
80101482:	e8 89 fd ff ff       	call   80101210 <balloc>
80101487:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010148a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010148d:	89 c3                	mov    %eax,%ebx
}
8010148f:	89 d8                	mov    %ebx,%eax
80101491:	5b                   	pop    %ebx
80101492:	5e                   	pop    %esi
80101493:	5f                   	pop    %edi
80101494:	5d                   	pop    %ebp
80101495:	c3                   	ret    
80101496:	8d 76 00             	lea    0x0(%esi),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a0:	e8 6b fd ff ff       	call   80101210 <balloc>
801014a5:	89 c2                	mov    %eax,%edx
801014a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014ad:	8b 06                	mov    (%esi),%eax
801014af:	e9 7c ff ff ff       	jmp    80101430 <bmap+0x40>
  panic("bmap: out of range");
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	68 85 76 10 80       	push   $0x80107685
801014bc:	e8 cf ef ff ff       	call   80100490 <panic>
801014c1:	eb 0d                	jmp    801014d0 <readsb>
801014c3:	90                   	nop
801014c4:	90                   	nop
801014c5:	90                   	nop
801014c6:	90                   	nop
801014c7:	90                   	nop
801014c8:	90                   	nop
801014c9:	90                   	nop
801014ca:	90                   	nop
801014cb:	90                   	nop
801014cc:	90                   	nop
801014cd:	90                   	nop
801014ce:	90                   	nop
801014cf:	90                   	nop

801014d0 <readsb>:
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	56                   	push   %esi
801014d4:	53                   	push   %ebx
801014d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014d8:	83 ec 08             	sub    $0x8,%esp
801014db:	6a 01                	push   $0x1
801014dd:	ff 75 08             	pushl  0x8(%ebp)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
801014e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ea:	83 c4 0c             	add    $0xc,%esp
801014ed:	6a 1c                	push   $0x1c
801014ef:	50                   	push   %eax
801014f0:	56                   	push   %esi
801014f1:	e8 9a 32 00 00       	call   80104790 <memmove>
  brelse(bp);
801014f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014f9:	83 c4 10             	add    $0x10,%esp
}
801014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5d                   	pop    %ebp
  brelse(bp);
80101502:	e9 d9 ec ff ff       	jmp    801001e0 <brelse>
80101507:	89 f6                	mov    %esi,%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <bfree>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	56                   	push   %esi
80101514:	53                   	push   %ebx
80101515:	89 d3                	mov    %edx,%ebx
80101517:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101519:	83 ec 08             	sub    $0x8,%esp
8010151c:	68 e0 09 11 80       	push   $0x801109e0
80101521:	50                   	push   %eax
80101522:	e8 a9 ff ff ff       	call   801014d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101527:	58                   	pop    %eax
80101528:	5a                   	pop    %edx
80101529:	89 da                	mov    %ebx,%edx
8010152b:	c1 ea 0c             	shr    $0xc,%edx
8010152e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101534:	52                   	push   %edx
80101535:	56                   	push   %esi
80101536:	e8 95 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010153b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010153d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101540:	ba 01 00 00 00       	mov    $0x1,%edx
80101545:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101548:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010154e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101551:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101553:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101558:	85 d1                	test   %edx,%ecx
8010155a:	74 25                	je     80101581 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010155c:	f7 d2                	not    %edx
8010155e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101563:	21 ca                	and    %ecx,%edx
80101565:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101569:	56                   	push   %esi
8010156a:	e8 b1 1a 00 00       	call   80103020 <log_write>
  brelse(bp);
8010156f:	89 34 24             	mov    %esi,(%esp)
80101572:	e8 69 ec ff ff       	call   801001e0 <brelse>
}
80101577:	83 c4 10             	add    $0x10,%esp
8010157a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010157d:	5b                   	pop    %ebx
8010157e:	5e                   	pop    %esi
8010157f:	5d                   	pop    %ebp
80101580:	c3                   	ret    
    panic("freeing free block");
80101581:	83 ec 0c             	sub    $0xc,%esp
80101584:	68 98 76 10 80       	push   $0x80107698
80101589:	e8 02 ef ff ff       	call   80100490 <panic>
8010158e:	66 90                	xchg   %ax,%ax

80101590 <balloc_page>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101599:	a1 e0 09 11 80       	mov    0x801109e0,%eax
8010159e:	85 c0                	test   %eax,%eax
801015a0:	74 6b                	je     8010160d <balloc_page+0x7d>
801015a2:	31 f6                	xor    %esi,%esi
   begin_op();
801015a4:	e8 a7 18 00 00       	call   80102e50 <begin_op>
    bp = bread(dev, BBLOCK(b, sb));
801015a9:	89 f0                	mov    %esi,%eax
801015ab:	83 ec 08             	sub    $0x8,%esp
801015ae:	89 f3                	mov    %esi,%ebx
801015b0:	c1 f8 0c             	sar    $0xc,%eax
801015b3:	03 05 f8 09 11 80    	add    0x801109f8,%eax
801015b9:	50                   	push   %eax
801015ba:	ff 75 08             	pushl  0x8(%ebp)
801015bd:	e8 0e eb ff ff       	call   801000d0 <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi+=8){
801015c2:	8b 3d e0 09 11 80    	mov    0x801109e0,%edi
801015c8:	83 c4 10             	add    $0x10,%esp
801015cb:	31 c9                	xor    %ecx,%ecx
801015cd:	eb 1b                	jmp    801015ea <balloc_page+0x5a>
801015cf:	90                   	nop
 	    if(bp->data[bi/8] == 0){  // Are 8 contiguous blocks free?
801015d0:	89 ca                	mov    %ecx,%edx
801015d2:	c1 fa 03             	sar    $0x3,%edx
801015d5:	80 7c 10 5c 00       	cmpb   $0x0,0x5c(%eax,%edx,1)
801015da:	74 44                	je     80101620 <balloc_page+0x90>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi+=8){
801015dc:	83 c1 08             	add    $0x8,%ecx
801015df:	83 c3 08             	add    $0x8,%ebx
801015e2:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
801015e8:	74 04                	je     801015ee <balloc_page+0x5e>
801015ea:	39 df                	cmp    %ebx,%edi
801015ec:	77 e2                	ja     801015d0 <balloc_page+0x40>
    brelse(bp);
801015ee:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
801015f1:	81 c6 00 10 00 00    	add    $0x1000,%esi
    brelse(bp);
801015f7:	50                   	push   %eax
801015f8:	e8 e3 eb ff ff       	call   801001e0 <brelse>
    end_op();
801015fd:	e8 be 18 00 00       	call   80102ec0 <end_op>
  for(b = 0; b < sb.size; b += BPB){
80101602:	83 c4 10             	add    $0x10,%esp
80101605:	39 35 e0 09 11 80    	cmp    %esi,0x801109e0
8010160b:	77 97                	ja     801015a4 <balloc_page+0x14>
  panic("balloc: out of blocks");
8010160d:	83 ec 0c             	sub    $0xc,%esp
80101610:	68 5f 76 10 80       	push   $0x8010765f
80101615:	e8 76 ee ff ff       	call   80100490 <panic>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bwrite(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= 15;  // Mark 8 blocks contiguous in use.
80101623:	c6 44 10 5c 0f       	movb   $0xf,0x5c(%eax,%edx,1)
80101628:	89 c7                	mov    %eax,%edi
        bwrite(bp);
8010162a:	50                   	push   %eax
8010162b:	e8 70 eb ff ff       	call   801001a0 <bwrite>
        log_write(bp);
80101630:	89 3c 24             	mov    %edi,(%esp)
80101633:	e8 e8 19 00 00       	call   80103020 <log_write>
80101638:	8d 43 08             	lea    0x8(%ebx),%eax
8010163b:	8b 75 08             	mov    0x8(%ebp),%esi
8010163e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
80101644:	89 df                	mov    %ebx,%edi
80101646:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80101649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		  bpp = bread(dev, b+bi+ii);
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	83 c7 01             	add    $0x1,%edi
80101658:	e8 73 ea ff ff       	call   801000d0 <bread>
8010165d:	89 c3                	mov    %eax,%ebx
		  memset(bpp->data, 0, BSIZE);
8010165f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101662:	83 c4 0c             	add    $0xc,%esp
80101665:	68 00 02 00 00       	push   $0x200
8010166a:	6a 00                	push   $0x0
8010166c:	50                   	push   %eax
8010166d:	e8 6e 30 00 00       	call   801046e0 <memset>
		  log_write(bpp);
80101672:	89 1c 24             	mov    %ebx,(%esp)
80101675:	e8 a6 19 00 00       	call   80103020 <log_write>
		  brelse(bpp); 
8010167a:	89 1c 24             	mov    %ebx,(%esp)
8010167d:	e8 5e eb ff ff       	call   801001e0 <brelse>
        for (ii=0; ii<8; ii++)
80101682:	83 c4 10             	add    $0x10,%esp
80101685:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101688:	75 c6                	jne    80101650 <balloc_page+0xc0>
8010168a:	8b 7d e0             	mov    -0x20(%ebp),%edi
        brelse(bp);
8010168d:	83 ec 0c             	sub    $0xc,%esp
80101690:	8b 5d dc             	mov    -0x24(%ebp),%ebx
        numallocblocks+=1;
80101693:	83 05 5c a5 10 80 01 	addl   $0x1,0x8010a55c
        brelse(bp);
8010169a:	57                   	push   %edi
8010169b:	e8 40 eb ff ff       	call   801001e0 <brelse>
        end_op();
801016a0:	e8 1b 18 00 00       	call   80102ec0 <end_op>
}
801016a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a8:	89 d8                	mov    %ebx,%eax
801016aa:	5b                   	pop    %ebx
801016ab:	5e                   	pop    %esi
801016ac:	5f                   	pop    %edi
801016ad:	5d                   	pop    %ebp
801016ae:	c3                   	ret    
801016af:	90                   	nop

801016b0 <bfree_page>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 75 08             	mov    0x8(%ebp),%esi
801016b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  readsb(dev, &sb);
801016bb:	83 ec 08             	sub    $0x8,%esp
801016be:	68 e0 09 11 80       	push   $0x801109e0
801016c3:	56                   	push   %esi
801016c4:	e8 07 fe ff ff       	call   801014d0 <readsb>
  begin_op();
801016c9:	e8 82 17 00 00       	call   80102e50 <begin_op>
  bp = bread(dev, BBLOCK(b, sb));
801016ce:	58                   	pop    %eax
801016cf:	89 d8                	mov    %ebx,%eax
  if((bp->data[bi/8] & m) == 0)
801016d1:	c1 fb 03             	sar    $0x3,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801016d4:	c1 e8 0c             	shr    $0xc,%eax
801016d7:	03 05 f8 09 11 80    	add    0x801109f8,%eax
  if((bp->data[bi/8] & m) == 0)
801016dd:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801016e3:	5a                   	pop    %edx
801016e4:	50                   	push   %eax
801016e5:	56                   	push   %esi
801016e6:	e8 e5 e9 ff ff       	call   801000d0 <bread>
801016eb:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
801016ed:	0f b6 44 18 5c       	movzbl 0x5c(%eax,%ebx,1),%eax
801016f2:	83 c4 10             	add    $0x10,%esp
801016f5:	a8 0f                	test   $0xf,%al
801016f7:	74 2d                	je     80101726 <bfree_page+0x76>
  log_write(bp);
801016f9:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801016fc:	83 e0 f0             	and    $0xfffffff0,%eax
801016ff:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101703:	56                   	push   %esi
80101704:	e8 17 19 00 00       	call   80103020 <log_write>
  brelse(bp);
80101709:	89 34 24             	mov    %esi,(%esp)
8010170c:	e8 cf ea ff ff       	call   801001e0 <brelse>
  numallocblocks-=1;
80101711:	83 2d 5c a5 10 80 01 	subl   $0x1,0x8010a55c
  end_op();
80101718:	83 c4 10             	add    $0x10,%esp
}
8010171b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171e:	5b                   	pop    %ebx
8010171f:	5e                   	pop    %esi
80101720:	5d                   	pop    %ebp
  end_op();
80101721:	e9 9a 17 00 00       	jmp    80102ec0 <end_op>
    panic("freeing free 8 blocks(page)");
80101726:	83 ec 0c             	sub    $0xc,%esp
80101729:	68 ab 76 10 80       	push   $0x801076ab
8010172e:	e8 5d ed ff ff       	call   80100490 <panic>
80101733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101740 <iinit>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
80101744:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101749:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010174c:	68 c7 76 10 80       	push   $0x801076c7
80101751:	68 00 0a 11 80       	push   $0x80110a00
80101756:	e8 15 2d 00 00       	call   80104470 <initlock>
8010175b:	83 c4 10             	add    $0x10,%esp
8010175e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101760:	83 ec 08             	sub    $0x8,%esp
80101763:	68 ce 76 10 80       	push   $0x801076ce
80101768:	53                   	push   %ebx
80101769:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010176f:	e8 ec 2b 00 00       	call   80104360 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101774:	83 c4 10             	add    $0x10,%esp
80101777:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010177d:	75 e1                	jne    80101760 <iinit+0x20>
  readsb(dev, &sb);
8010177f:	83 ec 08             	sub    $0x8,%esp
80101782:	68 e0 09 11 80       	push   $0x801109e0
80101787:	ff 75 08             	pushl  0x8(%ebp)
8010178a:	e8 41 fd ff ff       	call   801014d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010178f:	ff 35 f8 09 11 80    	pushl  0x801109f8
80101795:	ff 35 f4 09 11 80    	pushl  0x801109f4
8010179b:	ff 35 f0 09 11 80    	pushl  0x801109f0
801017a1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801017a7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801017ad:	ff 35 e4 09 11 80    	pushl  0x801109e4
801017b3:	ff 35 e0 09 11 80    	pushl  0x801109e0
801017b9:	68 34 77 10 80       	push   $0x80107734
801017be:	e8 9d ef ff ff       	call   80100760 <cprintf>
}
801017c3:	83 c4 30             	add    $0x30,%esp
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave  
801017ca:	c3                   	ret    
801017cb:	90                   	nop
801017cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017d0 <ialloc>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017d9:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
801017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801017e3:	8b 75 08             	mov    0x8(%ebp),%esi
801017e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017e9:	0f 86 91 00 00 00    	jbe    80101880 <ialloc+0xb0>
801017ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801017f4:	eb 21                	jmp    80101817 <ialloc+0x47>
801017f6:	8d 76 00             	lea    0x0(%esi),%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101800:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101803:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101806:	57                   	push   %edi
80101807:	e8 d4 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010180c:	83 c4 10             	add    $0x10,%esp
8010180f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101815:	76 69                	jbe    80101880 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101817:	89 d8                	mov    %ebx,%eax
80101819:	83 ec 08             	sub    $0x8,%esp
8010181c:	c1 e8 03             	shr    $0x3,%eax
8010181f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101825:	50                   	push   %eax
80101826:	56                   	push   %esi
80101827:	e8 a4 e8 ff ff       	call   801000d0 <bread>
8010182c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010182e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101830:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101833:	83 e0 07             	and    $0x7,%eax
80101836:	c1 e0 06             	shl    $0x6,%eax
80101839:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010183d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101841:	75 bd                	jne    80101800 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101843:	83 ec 04             	sub    $0x4,%esp
80101846:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101849:	6a 40                	push   $0x40
8010184b:	6a 00                	push   $0x0
8010184d:	51                   	push   %ecx
8010184e:	e8 8d 2e 00 00       	call   801046e0 <memset>
      dip->type = type;
80101853:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101857:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010185a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010185d:	89 3c 24             	mov    %edi,(%esp)
80101860:	e8 bb 17 00 00       	call   80103020 <log_write>
      brelse(bp);
80101865:	89 3c 24             	mov    %edi,(%esp)
80101868:	e8 73 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010186d:	83 c4 10             	add    $0x10,%esp
}
80101870:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101873:	89 da                	mov    %ebx,%edx
80101875:	89 f0                	mov    %esi,%eax
}
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5f                   	pop    %edi
8010187a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010187b:	e9 a0 fa ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101880:	83 ec 0c             	sub    $0xc,%esp
80101883:	68 d4 76 10 80       	push   $0x801076d4
80101888:	e8 03 ec ff ff       	call   80100490 <panic>
8010188d:	8d 76 00             	lea    0x0(%esi),%esi

80101890 <iupdate>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101898:	83 ec 08             	sub    $0x8,%esp
8010189b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010189e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018a1:	c1 e8 03             	shr    $0x3,%eax
801018a4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801018aa:	50                   	push   %eax
801018ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801018ae:	e8 1d e8 ff ff       	call   801000d0 <bread>
801018b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801018b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018bf:	83 e0 07             	and    $0x7,%eax
801018c2:	c1 e0 06             	shl    $0x6,%eax
801018c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ed:	6a 34                	push   $0x34
801018ef:	53                   	push   %ebx
801018f0:	50                   	push   %eax
801018f1:	e8 9a 2e 00 00       	call   80104790 <memmove>
  log_write(bp);
801018f6:	89 34 24             	mov    %esi,(%esp)
801018f9:	e8 22 17 00 00       	call   80103020 <log_write>
  brelse(bp);
801018fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101901:	83 c4 10             	add    $0x10,%esp
}
80101904:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101907:	5b                   	pop    %ebx
80101908:	5e                   	pop    %esi
80101909:	5d                   	pop    %ebp
  brelse(bp);
8010190a:	e9 d1 e8 ff ff       	jmp    801001e0 <brelse>
8010190f:	90                   	nop

80101910 <idup>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010191a:	68 00 0a 11 80       	push   $0x80110a00
8010191f:	e8 3c 2c 00 00       	call   80104560 <acquire>
  ip->ref++;
80101924:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101928:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010192f:	e8 4c 2d 00 00       	call   80104680 <release>
}
80101934:	89 d8                	mov    %ebx,%eax
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <ilock>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	56                   	push   %esi
80101944:	53                   	push   %ebx
80101945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101948:	85 db                	test   %ebx,%ebx
8010194a:	0f 84 b7 00 00 00    	je     80101a07 <ilock+0xc7>
80101950:	8b 53 08             	mov    0x8(%ebx),%edx
80101953:	85 d2                	test   %edx,%edx
80101955:	0f 8e ac 00 00 00    	jle    80101a07 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010195b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010195e:	83 ec 0c             	sub    $0xc,%esp
80101961:	50                   	push   %eax
80101962:	e8 39 2a 00 00       	call   801043a0 <acquiresleep>
  if(ip->valid == 0){
80101967:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010196a:	83 c4 10             	add    $0x10,%esp
8010196d:	85 c0                	test   %eax,%eax
8010196f:	74 0f                	je     80101980 <ilock+0x40>
}
80101971:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101974:	5b                   	pop    %ebx
80101975:	5e                   	pop    %esi
80101976:	5d                   	pop    %ebp
80101977:	c3                   	ret    
80101978:	90                   	nop
80101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101980:	8b 43 04             	mov    0x4(%ebx),%eax
80101983:	83 ec 08             	sub    $0x8,%esp
80101986:	c1 e8 03             	shr    $0x3,%eax
80101989:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010198f:	50                   	push   %eax
80101990:	ff 33                	pushl  (%ebx)
80101992:	e8 39 e7 ff ff       	call   801000d0 <bread>
80101997:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101999:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010199c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010199f:	83 e0 07             	and    $0x7,%eax
801019a2:	c1 e0 06             	shl    $0x6,%eax
801019a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019a9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019ac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019d1:	6a 34                	push   $0x34
801019d3:	50                   	push   %eax
801019d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019d7:	50                   	push   %eax
801019d8:	e8 b3 2d 00 00       	call   80104790 <memmove>
    brelse(bp);
801019dd:	89 34 24             	mov    %esi,(%esp)
801019e0:	e8 fb e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801019e5:	83 c4 10             	add    $0x10,%esp
801019e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801019f4:	0f 85 77 ff ff ff    	jne    80101971 <ilock+0x31>
      panic("ilock: no type");
801019fa:	83 ec 0c             	sub    $0xc,%esp
801019fd:	68 ec 76 10 80       	push   $0x801076ec
80101a02:	e8 89 ea ff ff       	call   80100490 <panic>
    panic("ilock");
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 e6 76 10 80       	push   $0x801076e6
80101a0f:	e8 7c ea ff ff       	call   80100490 <panic>
80101a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a20 <iunlock>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	74 28                	je     80101a54 <iunlock+0x34>
80101a2c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a2f:	83 ec 0c             	sub    $0xc,%esp
80101a32:	56                   	push   %esi
80101a33:	e8 08 2a 00 00       	call   80104440 <holdingsleep>
80101a38:	83 c4 10             	add    $0x10,%esp
80101a3b:	85 c0                	test   %eax,%eax
80101a3d:	74 15                	je     80101a54 <iunlock+0x34>
80101a3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a42:	85 c0                	test   %eax,%eax
80101a44:	7e 0e                	jle    80101a54 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a4c:	5b                   	pop    %ebx
80101a4d:	5e                   	pop    %esi
80101a4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a4f:	e9 ac 29 00 00       	jmp    80104400 <releasesleep>
    panic("iunlock");
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	68 fb 76 10 80       	push   $0x801076fb
80101a5c:	e8 2f ea ff ff       	call   80100490 <panic>
80101a61:	eb 0d                	jmp    80101a70 <iput>
80101a63:	90                   	nop
80101a64:	90                   	nop
80101a65:	90                   	nop
80101a66:	90                   	nop
80101a67:	90                   	nop
80101a68:	90                   	nop
80101a69:	90                   	nop
80101a6a:	90                   	nop
80101a6b:	90                   	nop
80101a6c:	90                   	nop
80101a6d:	90                   	nop
80101a6e:	90                   	nop
80101a6f:	90                   	nop

80101a70 <iput>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 28             	sub    $0x28,%esp
80101a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a7f:	57                   	push   %edi
80101a80:	e8 1b 29 00 00       	call   801043a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	85 d2                	test   %edx,%edx
80101a8d:	74 07                	je     80101a96 <iput+0x26>
80101a8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a94:	74 32                	je     80101ac8 <iput+0x58>
  releasesleep(&ip->lock);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	57                   	push   %edi
80101a9a:	e8 61 29 00 00       	call   80104400 <releasesleep>
  acquire(&icache.lock);
80101a9f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101aa6:	e8 b5 2a 00 00       	call   80104560 <acquire>
  ip->ref--;
80101aab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5f                   	pop    %edi
80101abf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ac0:	e9 bb 2b 00 00       	jmp    80104680 <release>
80101ac5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ac8:	83 ec 0c             	sub    $0xc,%esp
80101acb:	68 00 0a 11 80       	push   $0x80110a00
80101ad0:	e8 8b 2a 00 00       	call   80104560 <acquire>
    int r = ip->ref;
80101ad5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ad8:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101adf:	e8 9c 2b 00 00       	call   80104680 <release>
    if(r == 1){
80101ae4:	83 c4 10             	add    $0x10,%esp
80101ae7:	83 fe 01             	cmp    $0x1,%esi
80101aea:	75 aa                	jne    80101a96 <iput+0x26>
80101aec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101af2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101af5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101af8:	89 cf                	mov    %ecx,%edi
80101afa:	eb 0b                	jmp    80101b07 <iput+0x97>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b00:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b03:	39 fe                	cmp    %edi,%esi
80101b05:	74 19                	je     80101b20 <iput+0xb0>
    if(ip->addrs[i]){
80101b07:	8b 16                	mov    (%esi),%edx
80101b09:	85 d2                	test   %edx,%edx
80101b0b:	74 f3                	je     80101b00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b0d:	8b 03                	mov    (%ebx),%eax
80101b0f:	e8 fc f9 ff ff       	call   80101510 <bfree>
      ip->addrs[i] = 0;
80101b14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b1a:	eb e4                	jmp    80101b00 <iput+0x90>
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b29:	85 c0                	test   %eax,%eax
80101b2b:	75 33                	jne    80101b60 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b37:	53                   	push   %ebx
80101b38:	e8 53 fd ff ff       	call   80101890 <iupdate>
      ip->type = 0;
80101b3d:	31 c0                	xor    %eax,%eax
80101b3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b43:	89 1c 24             	mov    %ebx,(%esp)
80101b46:	e8 45 fd ff ff       	call   80101890 <iupdate>
      ip->valid = 0;
80101b4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b52:	83 c4 10             	add    $0x10,%esp
80101b55:	e9 3c ff ff ff       	jmp    80101a96 <iput+0x26>
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b60:	83 ec 08             	sub    $0x8,%esp
80101b63:	50                   	push   %eax
80101b64:	ff 33                	pushl  (%ebx)
80101b66:	e8 65 e5 ff ff       	call   801000d0 <bread>
80101b6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b71:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b77:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b7a:	83 c4 10             	add    $0x10,%esp
80101b7d:	89 cf                	mov    %ecx,%edi
80101b7f:	eb 0e                	jmp    80101b8f <iput+0x11f>
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b88:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b8b:	39 fe                	cmp    %edi,%esi
80101b8d:	74 0f                	je     80101b9e <iput+0x12e>
      if(a[j])
80101b8f:	8b 16                	mov    (%esi),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 f3                	je     80101b88 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b95:	8b 03                	mov    (%ebx),%eax
80101b97:	e8 74 f9 ff ff       	call   80101510 <bfree>
80101b9c:	eb ea                	jmp    80101b88 <iput+0x118>
    brelse(bp);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ba4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ba7:	e8 34 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bb2:	8b 03                	mov    (%ebx),%eax
80101bb4:	e8 57 f9 ff ff       	call   80101510 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bb9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101bc0:	00 00 00 
80101bc3:	83 c4 10             	add    $0x10,%esp
80101bc6:	e9 62 ff ff ff       	jmp    80101b2d <iput+0xbd>
80101bcb:	90                   	nop
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bd0 <iunlockput>:
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	53                   	push   %ebx
80101bd4:	83 ec 10             	sub    $0x10,%esp
80101bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bda:	53                   	push   %ebx
80101bdb:	e8 40 fe ff ff       	call   80101a20 <iunlock>
  iput(ip);
80101be0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101be3:	83 c4 10             	add    $0x10,%esp
}
80101be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101be9:	c9                   	leave  
  iput(ip);
80101bea:	e9 81 fe ff ff       	jmp    80101a70 <iput>
80101bef:	90                   	nop

80101bf0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	8b 55 08             	mov    0x8(%ebp),%edx
80101bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bf9:	8b 0a                	mov    (%edx),%ecx
80101bfb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bfe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c13:	8b 52 58             	mov    0x58(%edx),%edx
80101c16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c43:	0f 84 a7 00 00 00    	je     80101cf0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4c:	8b 40 58             	mov    0x58(%eax),%eax
80101c4f:	39 c6                	cmp    %eax,%esi
80101c51:	0f 87 ba 00 00 00    	ja     80101d11 <readi+0xf1>
80101c57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c5a:	89 f9                	mov    %edi,%ecx
80101c5c:	01 f1                	add    %esi,%ecx
80101c5e:	0f 82 ad 00 00 00    	jb     80101d11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c64:	89 c2                	mov    %eax,%edx
80101c66:	29 f2                	sub    %esi,%edx
80101c68:	39 c8                	cmp    %ecx,%eax
80101c6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c6d:	31 ff                	xor    %edi,%edi
80101c6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c74:	74 6c                	je     80101ce2 <readi+0xc2>
80101c76:	8d 76 00             	lea    0x0(%esi),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c83:	89 f2                	mov    %esi,%edx
80101c85:	c1 ea 09             	shr    $0x9,%edx
80101c88:	89 d8                	mov    %ebx,%eax
80101c8a:	e8 61 f7 ff ff       	call   801013f0 <bmap>
80101c8f:	83 ec 08             	sub    $0x8,%esp
80101c92:	50                   	push   %eax
80101c93:	ff 33                	pushl  (%ebx)
80101c95:	e8 36 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9f:	89 f0                	mov    %esi,%eax
80101ca1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cab:	83 c4 0c             	add    $0xc,%esp
80101cae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cb0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101cb4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb7:	29 fb                	sub    %edi,%ebx
80101cb9:	39 d9                	cmp    %ebx,%ecx
80101cbb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cbe:	53                   	push   %ebx
80101cbf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101cc2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101cc7:	e8 c4 2a 00 00       	call   80104790 <memmove>
    brelse(bp);
80101ccc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ccf:	89 14 24             	mov    %edx,(%esp)
80101cd2:	e8 09 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ce0:	77 9e                	ja     80101c80 <readi+0x60>
  }
  return n;
80101ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce8:	5b                   	pop    %ebx
80101ce9:	5e                   	pop    %esi
80101cea:	5f                   	pop    %edi
80101ceb:	5d                   	pop    %ebp
80101cec:	c3                   	ret    
80101ced:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 17                	ja     80101d11 <readi+0xf1>
80101cfa:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 0c                	je     80101d11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d0f:	ff e0                	jmp    *%eax
      return -1;
80101d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d16:	eb cd                	jmp    80101ce5 <readi+0xc5>
80101d18:	90                   	nop
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d43:	0f 84 b7 00 00 00    	je     80101e00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d4f:	0f 82 eb 00 00 00    	jb     80101e40 <writei+0x120>
80101d55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d58:	31 d2                	xor    %edx,%edx
80101d5a:	89 f8                	mov    %edi,%eax
80101d5c:	01 f0                	add    %esi,%eax
80101d5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d66:	0f 87 d4 00 00 00    	ja     80101e40 <writei+0x120>
80101d6c:	85 d2                	test   %edx,%edx
80101d6e:	0f 85 cc 00 00 00    	jne    80101e40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d74:	85 ff                	test   %edi,%edi
80101d76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d7d:	74 72                	je     80101df1 <writei+0xd1>
80101d7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d83:	89 f2                	mov    %esi,%edx
80101d85:	c1 ea 09             	shr    $0x9,%edx
80101d88:	89 f8                	mov    %edi,%eax
80101d8a:	e8 61 f6 ff ff       	call   801013f0 <bmap>
80101d8f:	83 ec 08             	sub    $0x8,%esp
80101d92:	50                   	push   %eax
80101d93:	ff 37                	pushl  (%edi)
80101d95:	e8 36 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101da0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101da2:	89 f0                	mov    %esi,%eax
80101da4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101da9:	83 c4 0c             	add    $0xc,%esp
80101dac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101db1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101db3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101db7:	39 d9                	cmp    %ebx,%ecx
80101db9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dbc:	53                   	push   %ebx
80101dbd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dc0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101dc2:	50                   	push   %eax
80101dc3:	e8 c8 29 00 00       	call   80104790 <memmove>
    log_write(bp);
80101dc8:	89 3c 24             	mov    %edi,(%esp)
80101dcb:	e8 50 12 00 00       	call   80103020 <log_write>
    brelse(bp);
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	e8 08 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ddb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dde:	83 c4 10             	add    $0x10,%esp
80101de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101de7:	77 97                	ja     80101d80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dec:	3b 70 58             	cmp    0x58(%eax),%esi
80101def:	77 37                	ja     80101e28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df7:	5b                   	pop    %ebx
80101df8:	5e                   	pop    %esi
80101df9:	5f                   	pop    %edi
80101dfa:	5d                   	pop    %ebp
80101dfb:	c3                   	ret    
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e04:	66 83 f8 09          	cmp    $0x9,%ax
80101e08:	77 36                	ja     80101e40 <writei+0x120>
80101e0a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101e11:	85 c0                	test   %eax,%eax
80101e13:	74 2b                	je     80101e40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e1f:	ff e0                	jmp    *%eax
80101e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e31:	50                   	push   %eax
80101e32:	e8 59 fa ff ff       	call   80101890 <iupdate>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb b5                	jmp    80101df1 <writei+0xd1>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e45:	eb ad                	jmp    80101df4 <writei+0xd4>
80101e47:	89 f6                	mov    %esi,%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e56:	6a 0e                	push   $0xe
80101e58:	ff 75 0c             	pushl  0xc(%ebp)
80101e5b:	ff 75 08             	pushl  0x8(%ebp)
80101e5e:	e8 9d 29 00 00       	call   80104800 <strncmp>
}
80101e63:	c9                   	leave  
80101e64:	c3                   	ret    
80101e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 1c             	sub    $0x1c,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e81:	0f 85 85 00 00 00    	jne    80101f0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e87:	8b 53 58             	mov    0x58(%ebx),%edx
80101e8a:	31 ff                	xor    %edi,%edi
80101e8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8f:	85 d2                	test   %edx,%edx
80101e91:	74 3e                	je     80101ed1 <dirlookup+0x61>
80101e93:	90                   	nop
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 7e fd ff ff       	call   80101c20 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 55                	jne    80101eff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	74 18                	je     80101ec9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	50                   	push   %eax
80101eba:	ff 75 0c             	pushl  0xc(%ebp)
80101ebd:	e8 3e 29 00 00       	call   80104800 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	85 c0                	test   %eax,%eax
80101ec7:	74 17                	je     80101ee0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ec9:	83 c7 10             	add    $0x10,%edi
80101ecc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ecf:	72 c7                	jb     80101e98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ed4:	31 c0                	xor    %eax,%eax
}
80101ed6:	5b                   	pop    %ebx
80101ed7:	5e                   	pop    %esi
80101ed8:	5f                   	pop    %edi
80101ed9:	5d                   	pop    %ebp
80101eda:	c3                   	ret    
80101edb:	90                   	nop
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee3:	85 c0                	test   %eax,%eax
80101ee5:	74 05                	je     80101eec <dirlookup+0x7c>
        *poff = off;
80101ee7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101eec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ef0:	8b 03                	mov    (%ebx),%eax
80101ef2:	e8 29 f4 ff ff       	call   80101320 <iget>
}
80101ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efa:	5b                   	pop    %ebx
80101efb:	5e                   	pop    %esi
80101efc:	5f                   	pop    %edi
80101efd:	5d                   	pop    %ebp
80101efe:	c3                   	ret    
      panic("dirlookup read");
80101eff:	83 ec 0c             	sub    $0xc,%esp
80101f02:	68 15 77 10 80       	push   $0x80107715
80101f07:	e8 84 e5 ff ff       	call   80100490 <panic>
    panic("dirlookup not DIR");
80101f0c:	83 ec 0c             	sub    $0xc,%esp
80101f0f:	68 03 77 10 80       	push   $0x80107703
80101f14:	e8 77 e5 ff ff       	call   80100490 <panic>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	89 cf                	mov    %ecx,%edi
80101f28:	89 c3                	mov    %eax,%ebx
80101f2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f33:	0f 84 67 01 00 00    	je     801020a0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f39:	e8 52 1b 00 00       	call   80103a90 <myproc>
  acquire(&icache.lock);
80101f3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f44:	68 00 0a 11 80       	push   $0x80110a00
80101f49:	e8 12 26 00 00       	call   80104560 <acquire>
  ip->ref++;
80101f4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f52:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101f59:	e8 22 27 00 00       	call   80104680 <release>
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	eb 08                	jmp    80101f6b <namex+0x4b>
80101f63:	90                   	nop
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	0f b6 03             	movzbl (%ebx),%eax
80101f6e:	3c 2f                	cmp    $0x2f,%al
80101f70:	74 f6                	je     80101f68 <namex+0x48>
  if(*path == 0)
80101f72:	84 c0                	test   %al,%al
80101f74:	0f 84 ee 00 00 00    	je     80102068 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f7a:	0f b6 03             	movzbl (%ebx),%eax
80101f7d:	3c 2f                	cmp    $0x2f,%al
80101f7f:	0f 84 b3 00 00 00    	je     80102038 <namex+0x118>
80101f85:	84 c0                	test   %al,%al
80101f87:	89 da                	mov    %ebx,%edx
80101f89:	75 09                	jne    80101f94 <namex+0x74>
80101f8b:	e9 a8 00 00 00       	jmp    80102038 <namex+0x118>
80101f90:	84 c0                	test   %al,%al
80101f92:	74 0a                	je     80101f9e <namex+0x7e>
    path++;
80101f94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f97:	0f b6 02             	movzbl (%edx),%eax
80101f9a:	3c 2f                	cmp    $0x2f,%al
80101f9c:	75 f2                	jne    80101f90 <namex+0x70>
80101f9e:	89 d1                	mov    %edx,%ecx
80101fa0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101fa2:	83 f9 0d             	cmp    $0xd,%ecx
80101fa5:	0f 8e 91 00 00 00    	jle    8010203c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101fab:	83 ec 04             	sub    $0x4,%esp
80101fae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fb1:	6a 0e                	push   $0xe
80101fb3:	53                   	push   %ebx
80101fb4:	57                   	push   %edi
80101fb5:	e8 d6 27 00 00       	call   80104790 <memmove>
    path++;
80101fba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101fbd:	83 c4 10             	add    $0x10,%esp
    path++;
80101fc0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fc5:	75 11                	jne    80101fd8 <namex+0xb8>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101fd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fd6:	74 f8                	je     80101fd0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	56                   	push   %esi
80101fdc:	e8 5f f9 ff ff       	call   80101940 <ilock>
    if(ip->type != T_DIR){
80101fe1:	83 c4 10             	add    $0x10,%esp
80101fe4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fe9:	0f 85 91 00 00 00    	jne    80102080 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ff2:	85 d2                	test   %edx,%edx
80101ff4:	74 09                	je     80101fff <namex+0xdf>
80101ff6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ff9:	0f 84 b7 00 00 00    	je     801020b6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fff:	83 ec 04             	sub    $0x4,%esp
80102002:	6a 00                	push   $0x0
80102004:	57                   	push   %edi
80102005:	56                   	push   %esi
80102006:	e8 65 fe ff ff       	call   80101e70 <dirlookup>
8010200b:	83 c4 10             	add    $0x10,%esp
8010200e:	85 c0                	test   %eax,%eax
80102010:	74 6e                	je     80102080 <namex+0x160>
  iunlock(ip);
80102012:	83 ec 0c             	sub    $0xc,%esp
80102015:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102018:	56                   	push   %esi
80102019:	e8 02 fa ff ff       	call   80101a20 <iunlock>
  iput(ip);
8010201e:	89 34 24             	mov    %esi,(%esp)
80102021:	e8 4a fa ff ff       	call   80101a70 <iput>
80102026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	89 c6                	mov    %eax,%esi
8010202e:	e9 38 ff ff ff       	jmp    80101f6b <namex+0x4b>
80102033:	90                   	nop
80102034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102038:	89 da                	mov    %ebx,%edx
8010203a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010203c:	83 ec 04             	sub    $0x4,%esp
8010203f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102042:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102045:	51                   	push   %ecx
80102046:	53                   	push   %ebx
80102047:	57                   	push   %edi
80102048:	e8 43 27 00 00       	call   80104790 <memmove>
    name[len] = 0;
8010204d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102050:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102053:	83 c4 10             	add    $0x10,%esp
80102056:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010205a:	89 d3                	mov    %edx,%ebx
8010205c:	e9 61 ff ff ff       	jmp    80101fc2 <namex+0xa2>
80102061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010206b:	85 c0                	test   %eax,%eax
8010206d:	75 5d                	jne    801020cc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010206f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102072:	89 f0                	mov    %esi,%eax
80102074:	5b                   	pop    %ebx
80102075:	5e                   	pop    %esi
80102076:	5f                   	pop    %edi
80102077:	5d                   	pop    %ebp
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102080:	83 ec 0c             	sub    $0xc,%esp
80102083:	56                   	push   %esi
80102084:	e8 97 f9 ff ff       	call   80101a20 <iunlock>
  iput(ip);
80102089:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010208c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010208e:	e8 dd f9 ff ff       	call   80101a70 <iput>
      return 0;
80102093:	83 c4 10             	add    $0x10,%esp
}
80102096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102099:	89 f0                	mov    %esi,%eax
8010209b:	5b                   	pop    %ebx
8010209c:	5e                   	pop    %esi
8010209d:	5f                   	pop    %edi
8010209e:	5d                   	pop    %ebp
8010209f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020a0:	ba 01 00 00 00       	mov    $0x1,%edx
801020a5:	b8 01 00 00 00       	mov    $0x1,%eax
801020aa:	e8 71 f2 ff ff       	call   80101320 <iget>
801020af:	89 c6                	mov    %eax,%esi
801020b1:	e9 b5 fe ff ff       	jmp    80101f6b <namex+0x4b>
      iunlock(ip);
801020b6:	83 ec 0c             	sub    $0xc,%esp
801020b9:	56                   	push   %esi
801020ba:	e8 61 f9 ff ff       	call   80101a20 <iunlock>
      return ip;
801020bf:	83 c4 10             	add    $0x10,%esp
}
801020c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c5:	89 f0                	mov    %esi,%eax
801020c7:	5b                   	pop    %ebx
801020c8:	5e                   	pop    %esi
801020c9:	5f                   	pop    %edi
801020ca:	5d                   	pop    %ebp
801020cb:	c3                   	ret    
    iput(ip);
801020cc:	83 ec 0c             	sub    $0xc,%esp
801020cf:	56                   	push   %esi
    return 0;
801020d0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020d2:	e8 99 f9 ff ff       	call   80101a70 <iput>
    return 0;
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	eb 93                	jmp    8010206f <namex+0x14f>
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <dirlink>:
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 20             	sub    $0x20,%esp
801020e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020ec:	6a 00                	push   $0x0
801020ee:	ff 75 0c             	pushl  0xc(%ebp)
801020f1:	53                   	push   %ebx
801020f2:	e8 79 fd ff ff       	call   80101e70 <dirlookup>
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	85 c0                	test   %eax,%eax
801020fc:	75 67                	jne    80102165 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102101:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102104:	85 ff                	test   %edi,%edi
80102106:	74 29                	je     80102131 <dirlink+0x51>
80102108:	31 ff                	xor    %edi,%edi
8010210a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010210d:	eb 09                	jmp    80102118 <dirlink+0x38>
8010210f:	90                   	nop
80102110:	83 c7 10             	add    $0x10,%edi
80102113:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102116:	73 19                	jae    80102131 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102118:	6a 10                	push   $0x10
8010211a:	57                   	push   %edi
8010211b:	56                   	push   %esi
8010211c:	53                   	push   %ebx
8010211d:	e8 fe fa ff ff       	call   80101c20 <readi>
80102122:	83 c4 10             	add    $0x10,%esp
80102125:	83 f8 10             	cmp    $0x10,%eax
80102128:	75 4e                	jne    80102178 <dirlink+0x98>
    if(de.inum == 0)
8010212a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010212f:	75 df                	jne    80102110 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102131:	8d 45 da             	lea    -0x26(%ebp),%eax
80102134:	83 ec 04             	sub    $0x4,%esp
80102137:	6a 0e                	push   $0xe
80102139:	ff 75 0c             	pushl  0xc(%ebp)
8010213c:	50                   	push   %eax
8010213d:	e8 1e 27 00 00       	call   80104860 <strncpy>
  de.inum = inum;
80102142:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102145:	6a 10                	push   $0x10
80102147:	57                   	push   %edi
80102148:	56                   	push   %esi
80102149:	53                   	push   %ebx
  de.inum = inum;
8010214a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010214e:	e8 cd fb ff ff       	call   80101d20 <writei>
80102153:	83 c4 20             	add    $0x20,%esp
80102156:	83 f8 10             	cmp    $0x10,%eax
80102159:	75 2a                	jne    80102185 <dirlink+0xa5>
  return 0;
8010215b:	31 c0                	xor    %eax,%eax
}
8010215d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102160:	5b                   	pop    %ebx
80102161:	5e                   	pop    %esi
80102162:	5f                   	pop    %edi
80102163:	5d                   	pop    %ebp
80102164:	c3                   	ret    
    iput(ip);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	50                   	push   %eax
80102169:	e8 02 f9 ff ff       	call   80101a70 <iput>
    return -1;
8010216e:	83 c4 10             	add    $0x10,%esp
80102171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102176:	eb e5                	jmp    8010215d <dirlink+0x7d>
      panic("dirlink read");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 24 77 10 80       	push   $0x80107724
80102180:	e8 0b e3 ff ff       	call   80100490 <panic>
    panic("dirlink");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 26 7d 10 80       	push   $0x80107d26
8010218d:	e8 fe e2 ff ff       	call   80100490 <panic>
80102192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <namei>:

struct inode*
namei(char *path)
{
801021a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021a1:	31 d2                	xor    %edx,%edx
{
801021a3:	89 e5                	mov    %esp,%ebp
801021a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021a8:	8b 45 08             	mov    0x8(%ebp),%eax
801021ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021ae:	e8 6d fd ff ff       	call   80101f20 <namex>
}
801021b3:	c9                   	leave  
801021b4:	c3                   	ret    
801021b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021c0:	55                   	push   %ebp
  return namex(path, 1, name);
801021c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021cf:	e9 4c fd ff ff       	jmp    80101f20 <namex>
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021e0:	55                   	push   %ebp
  if(b == 0)
801021e1:	85 c0                	test   %eax,%eax
{
801021e3:	89 e5                	mov    %esp,%ebp
801021e5:	56                   	push   %esi
801021e6:	53                   	push   %ebx
  if(b == 0)
801021e7:	0f 84 af 00 00 00    	je     8010229c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021ed:	8b 58 08             	mov    0x8(%eax),%ebx
801021f0:	89 c6                	mov    %eax,%esi
801021f2:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
801021f8:	0f 87 91 00 00 00    	ja     8010228f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fe:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102208:	89 ca                	mov    %ecx,%edx
8010220a:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010220b:	83 e0 c0             	and    $0xffffffc0,%eax
8010220e:	3c 40                	cmp    $0x40,%al
80102210:	75 f6                	jne    80102208 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102212:	31 c0                	xor    %eax,%eax
80102214:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102219:	ee                   	out    %al,(%dx)
8010221a:	b8 01 00 00 00       	mov    $0x1,%eax
8010221f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102224:	ee                   	out    %al,(%dx)
80102225:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010222a:	89 d8                	mov    %ebx,%eax
8010222c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010222d:	89 d8                	mov    %ebx,%eax
8010222f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102234:	c1 f8 08             	sar    $0x8,%eax
80102237:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80102238:	89 d8                	mov    %ebx,%eax
8010223a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010223f:	c1 f8 10             	sar    $0x10,%eax
80102242:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102243:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102247:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224c:	c1 e0 04             	shl    $0x4,%eax
8010224f:	83 e0 10             	and    $0x10,%eax
80102252:	83 c8 e0             	or     $0xffffffe0,%eax
80102255:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102256:	f6 06 04             	testb  $0x4,(%esi)
80102259:	75 15                	jne    80102270 <idestart+0x90>
8010225b:	b8 20 00 00 00       	mov    $0x20,%eax
80102260:	89 ca                	mov    %ecx,%edx
80102262:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102266:	5b                   	pop    %ebx
80102267:	5e                   	pop    %esi
80102268:	5d                   	pop    %ebp
80102269:	c3                   	ret    
8010226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102270:	b8 30 00 00 00       	mov    $0x30,%eax
80102275:	89 ca                	mov    %ecx,%edx
80102277:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102278:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010227d:	83 c6 5c             	add    $0x5c,%esi
80102280:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102285:	fc                   	cld    
80102286:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102288:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010228b:	5b                   	pop    %ebx
8010228c:	5e                   	pop    %esi
8010228d:	5d                   	pop    %ebp
8010228e:	c3                   	ret    
    panic("incorrect blockno");
8010228f:	83 ec 0c             	sub    $0xc,%esp
80102292:	68 90 77 10 80       	push   $0x80107790
80102297:	e8 f4 e1 ff ff       	call   80100490 <panic>
    panic("idestart");
8010229c:	83 ec 0c             	sub    $0xc,%esp
8010229f:	68 87 77 10 80       	push   $0x80107787
801022a4:	e8 e7 e1 ff ff       	call   80100490 <panic>
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideinit>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022b6:	68 a2 77 10 80       	push   $0x801077a2
801022bb:	68 80 a5 10 80       	push   $0x8010a580
801022c0:	e8 ab 21 00 00       	call   80104470 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022c5:	58                   	pop    %eax
801022c6:	a1 20 2d 11 80       	mov    0x80112d20,%eax
801022cb:	5a                   	pop    %edx
801022cc:	83 e8 01             	sub    $0x1,%eax
801022cf:	50                   	push   %eax
801022d0:	6a 0e                	push   $0xe
801022d2:	e8 a9 02 00 00       	call   80102580 <ioapicenable>
801022d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	83 e0 c0             	and    $0xffffffc0,%eax
801022e4:	3c 40                	cmp    $0x40,%al
801022e6:	75 f8                	jne    801022e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f2:	ee                   	out    %al,(%dx)
801022f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022fd:	eb 06                	jmp    80102305 <ideinit+0x55>
801022ff:	90                   	nop
  for(i=0; i<1000; i++){
80102300:	83 e9 01             	sub    $0x1,%ecx
80102303:	74 0f                	je     80102314 <ideinit+0x64>
80102305:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102306:	84 c0                	test   %al,%al
80102308:	74 f6                	je     80102300 <ideinit+0x50>
      havedisk1 = 1;
8010230a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102311:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102314:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102319:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010231e:	ee                   	out    %al,(%dx)
}
8010231f:	c9                   	leave  
80102320:	c3                   	ret    
80102321:	eb 0d                	jmp    80102330 <ideintr>
80102323:	90                   	nop
80102324:	90                   	nop
80102325:	90                   	nop
80102326:	90                   	nop
80102327:	90                   	nop
80102328:	90                   	nop
80102329:	90                   	nop
8010232a:	90                   	nop
8010232b:	90                   	nop
8010232c:	90                   	nop
8010232d:	90                   	nop
8010232e:	90                   	nop
8010232f:	90                   	nop

80102330 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102339:	68 80 a5 10 80       	push   $0x8010a580
8010233e:	e8 1d 22 00 00       	call   80104560 <acquire>

  if((b = idequeue) == 0){
80102343:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 db                	test   %ebx,%ebx
8010234e:	74 67                	je     801023b7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102350:	8b 43 58             	mov    0x58(%ebx),%eax
80102353:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102358:	8b 3b                	mov    (%ebx),%edi
8010235a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102360:	75 31                	jne    80102393 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102362:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102367:	89 f6                	mov    %esi,%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102370:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102371:	89 c6                	mov    %eax,%esi
80102373:	83 e6 c0             	and    $0xffffffc0,%esi
80102376:	89 f1                	mov    %esi,%ecx
80102378:	80 f9 40             	cmp    $0x40,%cl
8010237b:	75 f3                	jne    80102370 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010237d:	a8 21                	test   $0x21,%al
8010237f:	75 12                	jne    80102393 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102381:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102384:	b9 80 00 00 00       	mov    $0x80,%ecx
80102389:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010238e:	fc                   	cld    
8010238f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102391:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102393:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102396:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102399:	89 f9                	mov    %edi,%ecx
8010239b:	83 c9 02             	or     $0x2,%ecx
8010239e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801023a0:	53                   	push   %ebx
801023a1:	e8 1a 1e 00 00       	call   801041c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023a6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801023ab:	83 c4 10             	add    $0x10,%esp
801023ae:	85 c0                	test   %eax,%eax
801023b0:	74 05                	je     801023b7 <ideintr+0x87>
    idestart(idequeue);
801023b2:	e8 29 fe ff ff       	call   801021e0 <idestart>
    release(&idelock);
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 80 a5 10 80       	push   $0x8010a580
801023bf:	e8 bc 22 00 00       	call   80104680 <release>

  release(&idelock);
}
801023c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c7:	5b                   	pop    %ebx
801023c8:	5e                   	pop    %esi
801023c9:	5f                   	pop    %edi
801023ca:	5d                   	pop    %ebp
801023cb:	c3                   	ret    
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 10             	sub    $0x10,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023da:	8d 43 0c             	lea    0xc(%ebx),%eax
801023dd:	50                   	push   %eax
801023de:	e8 5d 20 00 00       	call   80104440 <holdingsleep>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	85 c0                	test   %eax,%eax
801023e8:	0f 84 c6 00 00 00    	je     801024b4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 e0 06             	and    $0x6,%eax
801023f3:	83 f8 02             	cmp    $0x2,%eax
801023f6:	0f 84 ab 00 00 00    	je     801024a7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023fc:	8b 53 04             	mov    0x4(%ebx),%edx
801023ff:	85 d2                	test   %edx,%edx
80102401:	74 0d                	je     80102410 <iderw+0x40>
80102403:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102408:	85 c0                	test   %eax,%eax
8010240a:	0f 84 b1 00 00 00    	je     801024c1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	68 80 a5 10 80       	push   $0x8010a580
80102418:	e8 43 21 00 00       	call   80104560 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102423:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102426:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010242d:	85 d2                	test   %edx,%edx
8010242f:	75 09                	jne    8010243a <iderw+0x6a>
80102431:	eb 6d                	jmp    801024a0 <iderw+0xd0>
80102433:	90                   	nop
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 c2                	mov    %eax,%edx
8010243a:	8b 42 58             	mov    0x58(%edx),%eax
8010243d:	85 c0                	test   %eax,%eax
8010243f:	75 f7                	jne    80102438 <iderw+0x68>
80102441:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102444:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102446:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010244c:	74 42                	je     80102490 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 e0 06             	and    $0x6,%eax
80102453:	83 f8 02             	cmp    $0x2,%eax
80102456:	74 23                	je     8010247b <iderw+0xab>
80102458:	90                   	nop
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102460:	83 ec 08             	sub    $0x8,%esp
80102463:	68 80 a5 10 80       	push   $0x8010a580
80102468:	53                   	push   %ebx
80102469:	e8 92 1b 00 00       	call   80104000 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010246e:	8b 03                	mov    (%ebx),%eax
80102470:	83 c4 10             	add    $0x10,%esp
80102473:	83 e0 06             	and    $0x6,%eax
80102476:	83 f8 02             	cmp    $0x2,%eax
80102479:	75 e5                	jne    80102460 <iderw+0x90>
  }


  release(&idelock);
8010247b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102485:	c9                   	leave  
  release(&idelock);
80102486:	e9 f5 21 00 00       	jmp    80104680 <release>
8010248b:	90                   	nop
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102490:	89 d8                	mov    %ebx,%eax
80102492:	e8 49 fd ff ff       	call   801021e0 <idestart>
80102497:	eb b5                	jmp    8010244e <iderw+0x7e>
80102499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024a0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801024a5:	eb 9d                	jmp    80102444 <iderw+0x74>
    panic("iderw: nothing to do");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 bc 77 10 80       	push   $0x801077bc
801024af:	e8 dc df ff ff       	call   80100490 <panic>
    panic("iderw: buf not locked");
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	68 a6 77 10 80       	push   $0x801077a6
801024bc:	e8 cf df ff ff       	call   80100490 <panic>
    panic("iderw: ide disk 1 not present");
801024c1:	83 ec 0c             	sub    $0xc,%esp
801024c4:	68 d1 77 10 80       	push   $0x801077d1
801024c9:	e8 c2 df ff ff       	call   80100490 <panic>
801024ce:	66 90                	xchg   %ax,%ax

801024d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024d1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801024d8:	00 c0 fe 
{
801024db:	89 e5                	mov    %esp,%ebp
801024dd:	56                   	push   %esi
801024de:	53                   	push   %ebx
  ioapic->reg = reg;
801024df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024e6:	00 00 00 
  return ioapic->data;
801024e9:	a1 54 26 11 80       	mov    0x80112654,%eax
801024ee:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801024f7:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024fd:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102504:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102507:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010250a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010250d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102510:	39 c2                	cmp    %eax,%edx
80102512:	74 16                	je     8010252a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102514:	83 ec 0c             	sub    $0xc,%esp
80102517:	68 f0 77 10 80       	push   $0x801077f0
8010251c:	e8 3f e2 ff ff       	call   80100760 <cprintf>
80102521:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102527:	83 c4 10             	add    $0x10,%esp
8010252a:	83 c3 21             	add    $0x21,%ebx
{
8010252d:	ba 10 00 00 00       	mov    $0x10,%edx
80102532:	b8 20 00 00 00       	mov    $0x20,%eax
80102537:	89 f6                	mov    %esi,%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102540:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102542:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102548:	89 c6                	mov    %eax,%esi
8010254a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102550:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102553:	89 71 10             	mov    %esi,0x10(%ecx)
80102556:	8d 72 01             	lea    0x1(%edx),%esi
80102559:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010255c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010255e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102560:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102566:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010256d:	75 d1                	jne    80102540 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010256f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102572:	5b                   	pop    %ebx
80102573:	5e                   	pop    %esi
80102574:	5d                   	pop    %ebp
80102575:	c3                   	ret    
80102576:	8d 76 00             	lea    0x0(%esi),%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102580:	55                   	push   %ebp
  ioapic->reg = reg;
80102581:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010258c:	8d 50 20             	lea    0x20(%eax),%edx
8010258f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102593:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102595:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010259e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
801025c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025d0:	75 70                	jne    80102642 <kfree+0x82>
801025d2:	81 fb c8 54 11 80    	cmp    $0x801154c8,%ebx
801025d8:	72 68                	jb     80102642 <kfree+0x82>
801025da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025e0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801025e5:	77 5b                	ja     80102642 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025e7:	83 ec 04             	sub    $0x4,%esp
801025ea:	68 00 10 00 00       	push   $0x1000
801025ef:	6a 01                	push   $0x1
801025f1:	53                   	push   %ebx
801025f2:	e8 e9 20 00 00       	call   801046e0 <memset>

  if(kmem.use_lock)
801025f7:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	85 d2                	test   %edx,%edx
80102602:	75 2c                	jne    80102630 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102604:	a1 98 26 11 80       	mov    0x80112698,%eax
80102609:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010260b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102610:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102616:	85 c0                	test   %eax,%eax
80102618:	75 06                	jne    80102620 <kfree+0x60>
    release(&kmem.lock);
}
8010261a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261d:	c9                   	leave  
8010261e:	c3                   	ret    
8010261f:	90                   	nop
    release(&kmem.lock);
80102620:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010262a:	c9                   	leave  
    release(&kmem.lock);
8010262b:	e9 50 20 00 00       	jmp    80104680 <release>
    acquire(&kmem.lock);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 60 26 11 80       	push   $0x80112660
80102638:	e8 23 1f 00 00       	call   80104560 <acquire>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	eb c2                	jmp    80102604 <kfree+0x44>
    panic("kfree");
80102642:	83 ec 0c             	sub    $0xc,%esp
80102645:	68 22 78 10 80       	push   $0x80107822
8010264a:	e8 41 de ff ff       	call   80100490 <panic>
8010264f:	90                   	nop

80102650 <freerange>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	56                   	push   %esi
80102654:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102655:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102658:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010265b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102661:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102667:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266d:	39 de                	cmp    %ebx,%esi
8010266f:	72 23                	jb     80102694 <freerange+0x44>
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102678:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010267e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102681:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102687:	50                   	push   %eax
80102688:	e8 33 ff ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
80102690:	39 f3                	cmp    %esi,%ebx
80102692:	76 e4                	jbe    80102678 <freerange+0x28>
}
80102694:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102697:	5b                   	pop    %ebx
80102698:	5e                   	pop    %esi
80102699:	5d                   	pop    %ebp
8010269a:	c3                   	ret    
8010269b:	90                   	nop
8010269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026a0 <kinit1>:
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
801026a4:	53                   	push   %ebx
801026a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026a8:	83 ec 08             	sub    $0x8,%esp
801026ab:	68 28 78 10 80       	push   $0x80107828
801026b0:	68 60 26 11 80       	push   $0x80112660
801026b5:	e8 b6 1d 00 00       	call   80104470 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026c0:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801026c7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dc:	39 de                	cmp    %ebx,%esi
801026de:	72 1c                	jb     801026fc <kinit1+0x5c>
    kfree(p);
801026e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026e6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026ef:	50                   	push   %eax
801026f0:	e8 cb fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f5:	83 c4 10             	add    $0x10,%esp
801026f8:	39 de                	cmp    %ebx,%esi
801026fa:	73 e4                	jae    801026e0 <kinit1+0x40>
}
801026fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ff:	5b                   	pop    %ebx
80102700:	5e                   	pop    %esi
80102701:	5d                   	pop    %ebp
80102702:	c3                   	ret    
80102703:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <kinit2>:
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	56                   	push   %esi
80102714:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102715:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102718:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010271b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102721:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102727:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010272d:	39 de                	cmp    %ebx,%esi
8010272f:	72 23                	jb     80102754 <kinit2+0x44>
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102738:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010273e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102741:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102747:	50                   	push   %eax
80102748:	e8 73 fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	39 de                	cmp    %ebx,%esi
80102752:	73 e4                	jae    80102738 <kinit2+0x28>
  kmem.use_lock = 1;
80102754:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010275b:	00 00 00 
}
8010275e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102761:	5b                   	pop    %ebx
80102762:	5e                   	pop    %esi
80102763:	5d                   	pop    %ebp
80102764:	c3                   	ret    
80102765:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102770:	a1 94 26 11 80       	mov    0x80112694,%eax
80102775:	85 c0                	test   %eax,%eax
80102777:	75 1f                	jne    80102798 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102779:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010277e:	85 c0                	test   %eax,%eax
80102780:	74 0e                	je     80102790 <kalloc+0x20>
    kmem.freelist = r->next;
80102782:	8b 10                	mov    (%eax),%edx
80102784:	89 15 98 26 11 80    	mov    %edx,0x80112698
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102790:	f3 c3                	repz ret 
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102798:	55                   	push   %ebp
80102799:	89 e5                	mov    %esp,%ebp
8010279b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010279e:	68 60 26 11 80       	push   $0x80112660
801027a3:	e8 b8 1d 00 00       	call   80104560 <acquire>
  r = kmem.freelist;
801027a8:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801027b6:	85 c0                	test   %eax,%eax
801027b8:	74 08                	je     801027c2 <kalloc+0x52>
    kmem.freelist = r->next;
801027ba:	8b 08                	mov    (%eax),%ecx
801027bc:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
801027c2:	85 d2                	test   %edx,%edx
801027c4:	74 16                	je     801027dc <kalloc+0x6c>
    release(&kmem.lock);
801027c6:	83 ec 0c             	sub    $0xc,%esp
801027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027cc:	68 60 26 11 80       	push   $0x80112660
801027d1:	e8 aa 1e 00 00       	call   80104680 <release>
  return (char*)r;
801027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027d9:	83 c4 10             	add    $0x10,%esp
}
801027dc:	c9                   	leave  
801027dd:	c3                   	ret    
801027de:	66 90                	xchg   %ax,%ax

801027e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e0:	ba 64 00 00 00       	mov    $0x64,%edx
801027e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027e6:	a8 01                	test   $0x1,%al
801027e8:	0f 84 c2 00 00 00    	je     801028b0 <kbdgetc+0xd0>
801027ee:	ba 60 00 00 00       	mov    $0x60,%edx
801027f3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801027f4:	0f b6 d0             	movzbl %al,%edx
801027f7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801027fd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102803:	0f 84 7f 00 00 00    	je     80102888 <kbdgetc+0xa8>
{
80102809:	55                   	push   %ebp
8010280a:	89 e5                	mov    %esp,%ebp
8010280c:	53                   	push   %ebx
8010280d:	89 cb                	mov    %ecx,%ebx
8010280f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102812:	84 c0                	test   %al,%al
80102814:	78 4a                	js     80102860 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102816:	85 db                	test   %ebx,%ebx
80102818:	74 09                	je     80102823 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010281a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010281d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102820:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102823:	0f b6 82 60 79 10 80 	movzbl -0x7fef86a0(%edx),%eax
8010282a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010282c:	0f b6 82 60 78 10 80 	movzbl -0x7fef87a0(%edx),%eax
80102833:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102835:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102837:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010283d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102840:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102843:	8b 04 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%eax
8010284a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010284e:	74 31                	je     80102881 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102850:	8d 50 9f             	lea    -0x61(%eax),%edx
80102853:	83 fa 19             	cmp    $0x19,%edx
80102856:	77 40                	ja     80102898 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102858:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010285b:	5b                   	pop    %ebx
8010285c:	5d                   	pop    %ebp
8010285d:	c3                   	ret    
8010285e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102860:	83 e0 7f             	and    $0x7f,%eax
80102863:	85 db                	test   %ebx,%ebx
80102865:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102868:	0f b6 82 60 79 10 80 	movzbl -0x7fef86a0(%edx),%eax
8010286f:	83 c8 40             	or     $0x40,%eax
80102872:	0f b6 c0             	movzbl %al,%eax
80102875:	f7 d0                	not    %eax
80102877:	21 c1                	and    %eax,%ecx
    return 0;
80102879:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010287b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102881:	5b                   	pop    %ebx
80102882:	5d                   	pop    %ebp
80102883:	c3                   	ret    
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102888:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010288b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010288d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102893:	c3                   	ret    
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102898:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010289b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010289e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010289f:	83 f9 1a             	cmp    $0x1a,%ecx
801028a2:	0f 42 c2             	cmovb  %edx,%eax
}
801028a5:	5d                   	pop    %ebp
801028a6:	c3                   	ret    
801028a7:	89 f6                	mov    %esi,%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801028b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028b5:	c3                   	ret    
801028b6:	8d 76 00             	lea    0x0(%esi),%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028c0 <kbdintr>:

void
kbdintr(void)
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028c6:	68 e0 27 10 80       	push   $0x801027e0
801028cb:	e8 40 e0 ff ff       	call   80100910 <consoleintr>
}
801028d0:	83 c4 10             	add    $0x10,%esp
801028d3:	c9                   	leave  
801028d4:	c3                   	ret    
801028d5:	66 90                	xchg   %ax,%ax
801028d7:	66 90                	xchg   %ax,%ax
801028d9:	66 90                	xchg   %ax,%ax
801028db:	66 90                	xchg   %ax,%ax
801028dd:	66 90                	xchg   %ax,%ax
801028df:	90                   	nop

801028e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028e0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
801028e5:	55                   	push   %ebp
801028e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801028e8:	85 c0                	test   %eax,%eax
801028ea:	0f 84 c8 00 00 00    	je     801029b8 <lapicinit+0xd8>
  lapic[index] = value;
801028f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102911:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102917:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010291e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102921:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102924:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010292b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102931:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102938:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010293b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010293e:	8b 50 30             	mov    0x30(%eax),%edx
80102941:	c1 ea 10             	shr    $0x10,%edx
80102944:	80 fa 03             	cmp    $0x3,%dl
80102947:	77 77                	ja     801029c0 <lapicinit+0xe0>
  lapic[index] = value;
80102949:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102953:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102956:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010295d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102963:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010296a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102970:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102977:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102984:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102991:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102994:	8b 50 20             	mov    0x20(%eax),%edx
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029a6:	80 e6 10             	and    $0x10,%dh
801029a9:	75 f5                	jne    801029a0 <lapicinit+0xc0>
  lapic[index] = value;
801029ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029b8:	5d                   	pop    %ebp
801029b9:	c3                   	ret    
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801029c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ca:	8b 50 20             	mov    0x20(%eax),%edx
801029cd:	e9 77 ff ff ff       	jmp    80102949 <lapicinit+0x69>
801029d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029e0:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
{
801029e6:	55                   	push   %ebp
801029e7:	31 c0                	xor    %eax,%eax
801029e9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801029eb:	85 d2                	test   %edx,%edx
801029ed:	74 06                	je     801029f5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801029ef:	8b 42 20             	mov    0x20(%edx),%eax
801029f2:	c1 e8 18             	shr    $0x18,%eax
}
801029f5:	5d                   	pop    %ebp
801029f6:	c3                   	ret    
801029f7:	89 f6                	mov    %esi,%esi
801029f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a00:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102a05:	55                   	push   %ebp
80102a06:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102a08:	85 c0                	test   %eax,%eax
80102a0a:	74 0d                	je     80102a19 <lapiceoi+0x19>
  lapic[index] = value;
80102a0c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a13:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a16:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    
80102a1b:	90                   	nop
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
}
80102a23:	5d                   	pop    %ebp
80102a24:	c3                   	ret    
80102a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a36:	ba 70 00 00 00       	mov    $0x70,%edx
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	53                   	push   %ebx
80102a3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a44:	ee                   	out    %al,(%dx)
80102a45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a5d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a60:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a63:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a6e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102a73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aba:	5b                   	pop    %ebx
80102abb:	5d                   	pop    %ebp
80102abc:	c3                   	ret    
80102abd:	8d 76 00             	lea    0x0(%esi),%esi

80102ac0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102ac0:	55                   	push   %ebp
80102ac1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ac6:	ba 70 00 00 00       	mov    $0x70,%edx
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	57                   	push   %edi
80102ace:	56                   	push   %esi
80102acf:	53                   	push   %ebx
80102ad0:	83 ec 4c             	sub    $0x4c,%esp
80102ad3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ae2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ae5:	8d 76 00             	lea    0x0(%esi),%esi
80102ae8:	31 c0                	xor    %eax,%eax
80102aea:	89 da                	mov    %ebx,%edx
80102aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aed:	b9 71 00 00 00       	mov    $0x71,%ecx
80102af2:	89 ca                	mov    %ecx,%edx
80102af4:	ec                   	in     (%dx),%al
80102af5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af8:	89 da                	mov    %ebx,%edx
80102afa:	b8 02 00 00 00       	mov    $0x2,%eax
80102aff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b00:	89 ca                	mov    %ecx,%edx
80102b02:	ec                   	in     (%dx),%al
80102b03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
80102b11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 da                	mov    %ebx,%edx
80102b16:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 ca                	mov    %ecx,%edx
80102b1e:	ec                   	in     (%dx),%al
80102b1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	89 da                	mov    %ebx,%edx
80102b24:	b8 08 00 00 00       	mov    $0x8,%eax
80102b29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2a:	89 ca                	mov    %ecx,%edx
80102b2c:	ec                   	in     (%dx),%al
80102b2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2f:	89 da                	mov    %ebx,%edx
80102b31:	b8 09 00 00 00       	mov    $0x9,%eax
80102b36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b37:	89 ca                	mov    %ecx,%edx
80102b39:	ec                   	in     (%dx),%al
80102b3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3c:	89 da                	mov    %ebx,%edx
80102b3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	89 ca                	mov    %ecx,%edx
80102b46:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b47:	84 c0                	test   %al,%al
80102b49:	78 9d                	js     80102ae8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b4f:	89 fa                	mov    %edi,%edx
80102b51:	0f b6 fa             	movzbl %dl,%edi
80102b54:	89 f2                	mov    %esi,%edx
80102b56:	0f b6 f2             	movzbl %dl,%esi
80102b59:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b61:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b64:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b68:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b6b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b79:	31 c0                	xor    %eax,%eax
80102b7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7c:	89 ca                	mov    %ecx,%edx
80102b7e:	ec                   	in     (%dx),%al
80102b7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b82:	89 da                	mov    %ebx,%edx
80102b84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b87:	b8 02 00 00 00       	mov    $0x2,%eax
80102b8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8d:	89 ca                	mov    %ecx,%edx
80102b8f:	ec                   	in     (%dx),%al
80102b90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b93:	89 da                	mov    %ebx,%edx
80102b95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b98:	b8 04 00 00 00       	mov    $0x4,%eax
80102b9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9e:	89 ca                	mov    %ecx,%edx
80102ba0:	ec                   	in     (%dx),%al
80102ba1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba4:	89 da                	mov    %ebx,%edx
80102ba6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ba9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102baf:	89 ca                	mov    %ecx,%edx
80102bb1:	ec                   	in     (%dx),%al
80102bb2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb5:	89 da                	mov    %ebx,%edx
80102bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bba:	b8 08 00 00 00       	mov    $0x8,%eax
80102bbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
80102bc3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc6:	89 da                	mov    %ebx,%edx
80102bc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bcb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bd0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd1:	89 ca                	mov    %ecx,%edx
80102bd3:	ec                   	in     (%dx),%al
80102bd4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bd7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bdd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102be0:	6a 18                	push   $0x18
80102be2:	50                   	push   %eax
80102be3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102be6:	50                   	push   %eax
80102be7:	e8 44 1b 00 00       	call   80104730 <memcmp>
80102bec:	83 c4 10             	add    $0x10,%esp
80102bef:	85 c0                	test   %eax,%eax
80102bf1:	0f 85 f1 fe ff ff    	jne    80102ae8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bf7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bfb:	75 78                	jne    80102c75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c00:	89 c2                	mov    %eax,%edx
80102c02:	83 e0 0f             	and    $0xf,%eax
80102c05:	c1 ea 04             	shr    $0x4,%edx
80102c08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c14:	89 c2                	mov    %eax,%edx
80102c16:	83 e0 0f             	and    $0xf,%eax
80102c19:	c1 ea 04             	shr    $0x4,%edx
80102c1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c28:	89 c2                	mov    %eax,%edx
80102c2a:	83 e0 0f             	and    $0xf,%eax
80102c2d:	c1 ea 04             	shr    $0x4,%edx
80102c30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c3c:	89 c2                	mov    %eax,%edx
80102c3e:	83 e0 0f             	and    $0xf,%eax
80102c41:	c1 ea 04             	shr    $0x4,%edx
80102c44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c50:	89 c2                	mov    %eax,%edx
80102c52:	83 e0 0f             	and    $0xf,%eax
80102c55:	c1 ea 04             	shr    $0x4,%edx
80102c58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c64:	89 c2                	mov    %eax,%edx
80102c66:	83 e0 0f             	and    $0xf,%eax
80102c69:	c1 ea 04             	shr    $0x4,%edx
80102c6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c75:	8b 75 08             	mov    0x8(%ebp),%esi
80102c78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c7b:	89 06                	mov    %eax,(%esi)
80102c7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c80:	89 46 04             	mov    %eax,0x4(%esi)
80102c83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c86:	89 46 08             	mov    %eax,0x8(%esi)
80102c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c92:	89 46 10             	mov    %eax,0x10(%esi)
80102c95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ca5:	5b                   	pop    %ebx
80102ca6:	5e                   	pop    %esi
80102ca7:	5f                   	pop    %edi
80102ca8:	5d                   	pop    %ebp
80102ca9:	c3                   	ret    
80102caa:	66 90                	xchg   %ax,%ax
80102cac:	66 90                	xchg   %ax,%ax
80102cae:	66 90                	xchg   %ax,%ax

80102cb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102cb6:	85 c9                	test   %ecx,%ecx
80102cb8:	0f 8e 8a 00 00 00    	jle    80102d48 <install_trans+0x98>
{
80102cbe:	55                   	push   %ebp
80102cbf:	89 e5                	mov    %esp,%ebp
80102cc1:	57                   	push   %edi
80102cc2:	56                   	push   %esi
80102cc3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102cc4:	31 db                	xor    %ebx,%ebx
{
80102cc6:	83 ec 0c             	sub    $0xc,%esp
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cd0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cd5:	83 ec 08             	sub    $0x8,%esp
80102cd8:	01 d8                	add    %ebx,%eax
80102cda:	83 c0 01             	add    $0x1,%eax
80102cdd:	50                   	push   %eax
80102cde:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
80102ce9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ceb:	58                   	pop    %eax
80102cec:	5a                   	pop    %edx
80102ced:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102cf4:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cfa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cfd:	e8 ce d3 ff ff       	call   801000d0 <bread>
80102d02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d07:	83 c4 0c             	add    $0xc,%esp
80102d0a:	68 00 02 00 00       	push   $0x200
80102d0f:	50                   	push   %eax
80102d10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d13:	50                   	push   %eax
80102d14:	e8 77 1a 00 00       	call   80104790 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d19:	89 34 24             	mov    %esi,(%esp)
80102d1c:	e8 7f d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102d21:	89 3c 24             	mov    %edi,(%esp)
80102d24:	e8 b7 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102d29:	89 34 24             	mov    %esi,(%esp)
80102d2c:	e8 af d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d31:	83 c4 10             	add    $0x10,%esp
80102d34:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102d3a:	7f 94                	jg     80102cd0 <install_trans+0x20>
  }
}
80102d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3f:	5b                   	pop    %ebx
80102d40:	5e                   	pop    %esi
80102d41:	5f                   	pop    %edi
80102d42:	5d                   	pop    %ebp
80102d43:	c3                   	ret    
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d48:	f3 c3                	repz ret 
80102d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	56                   	push   %esi
80102d54:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102d55:	83 ec 08             	sub    $0x8,%esp
80102d58:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102d5e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102d64:	e8 67 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d69:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d6f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d72:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102d74:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102d76:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d79:	7e 16                	jle    80102d91 <write_head+0x41>
80102d7b:	c1 e3 02             	shl    $0x2,%ebx
80102d7e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102d80:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102d86:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102d8a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102d8d:	39 da                	cmp    %ebx,%edx
80102d8f:	75 ef                	jne    80102d80 <write_head+0x30>
  }
  bwrite(buf);
80102d91:	83 ec 0c             	sub    $0xc,%esp
80102d94:	56                   	push   %esi
80102d95:	e8 06 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d9a:	89 34 24             	mov    %esi,(%esp)
80102d9d:	e8 3e d4 ff ff       	call   801001e0 <brelse>
}
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102da8:	5b                   	pop    %ebx
80102da9:	5e                   	pop    %esi
80102daa:	5d                   	pop    %ebp
80102dab:	c3                   	ret    
80102dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102db0 <initlog>:
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 2c             	sub    $0x2c,%esp
80102db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dba:	68 60 7a 10 80       	push   $0x80107a60
80102dbf:	68 a0 26 11 80       	push   $0x801126a0
80102dc4:	e8 a7 16 00 00       	call   80104470 <initlock>
  readsb(dev, &sb);
80102dc9:	58                   	pop    %eax
80102dca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dcd:	5a                   	pop    %edx
80102dce:	50                   	push   %eax
80102dcf:	53                   	push   %ebx
80102dd0:	e8 fb e6 ff ff       	call   801014d0 <readsb>
  log.size = sb.nlog;
80102dd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	59                   	pop    %ecx
  log.dev = dev;
80102ddc:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102de2:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102de8:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 db d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102df5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102df8:	83 c4 10             	add    $0x10,%esp
80102dfb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102dfd:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e03:	7e 1c                	jle    80102e21 <initlog+0x71>
80102e05:	c1 e3 02             	shl    $0x2,%ebx
80102e08:	31 d2                	xor    %edx,%edx
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e14:	83 c2 04             	add    $0x4,%edx
80102e17:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e1d:	39 d3                	cmp    %edx,%ebx
80102e1f:	75 ef                	jne    80102e10 <initlog+0x60>
  brelse(buf);
80102e21:	83 ec 0c             	sub    $0xc,%esp
80102e24:	50                   	push   %eax
80102e25:	e8 b6 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e2a:	e8 81 fe ff ff       	call   80102cb0 <install_trans>
  log.lh.n = 0;
80102e2f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e36:	00 00 00 
  write_head(); // clear the log
80102e39:	e8 12 ff ff ff       	call   80102d50 <write_head>
}
80102e3e:	83 c4 10             	add    $0x10,%esp
80102e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e44:	c9                   	leave  
80102e45:	c3                   	ret    
80102e46:	8d 76 00             	lea    0x0(%esi),%esi
80102e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e56:	68 a0 26 11 80       	push   $0x801126a0
80102e5b:	e8 00 17 00 00       	call   80104560 <acquire>
80102e60:	83 c4 10             	add    $0x10,%esp
80102e63:	eb 18                	jmp    80102e7d <begin_op+0x2d>
80102e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e68:	83 ec 08             	sub    $0x8,%esp
80102e6b:	68 a0 26 11 80       	push   $0x801126a0
80102e70:	68 a0 26 11 80       	push   $0x801126a0
80102e75:	e8 86 11 00 00       	call   80104000 <sleep>
80102e7a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e7d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e82:	85 c0                	test   %eax,%eax
80102e84:	75 e2                	jne    80102e68 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e86:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e8b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e91:	83 c0 01             	add    $0x1,%eax
80102e94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e9a:	83 fa 1e             	cmp    $0x1e,%edx
80102e9d:	7f c9                	jg     80102e68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e9f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ea2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ea7:	68 a0 26 11 80       	push   $0x801126a0
80102eac:	e8 cf 17 00 00       	call   80104680 <release>
      break;
    }
  }
}
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	c9                   	leave  
80102eb5:	c3                   	ret    
80102eb6:	8d 76 00             	lea    0x0(%esi),%esi
80102eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ec0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	57                   	push   %edi
80102ec4:	56                   	push   %esi
80102ec5:	53                   	push   %ebx
80102ec6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ec9:	68 a0 26 11 80       	push   $0x801126a0
80102ece:	e8 8d 16 00 00       	call   80104560 <acquire>
  log.outstanding -= 1;
80102ed3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102ed8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102ede:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ee1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ee4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ee6:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102eec:	0f 85 1a 01 00 00    	jne    8010300c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ef2:	85 db                	test   %ebx,%ebx
80102ef4:	0f 85 ee 00 00 00    	jne    80102fe8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102efa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102efd:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f04:	00 00 00 
  release(&log.lock);
80102f07:	68 a0 26 11 80       	push   $0x801126a0
80102f0c:	e8 6f 17 00 00       	call   80104680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f11:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102f17:	83 c4 10             	add    $0x10,%esp
80102f1a:	85 c9                	test   %ecx,%ecx
80102f1c:	0f 8e 85 00 00 00    	jle    80102fa7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f22:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f27:	83 ec 08             	sub    $0x8,%esp
80102f2a:	01 d8                	add    %ebx,%eax
80102f2c:	83 c0 01             	add    $0x1,%eax
80102f2f:	50                   	push   %eax
80102f30:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102f36:	e8 95 d1 ff ff       	call   801000d0 <bread>
80102f3b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f3d:	58                   	pop    %eax
80102f3e:	5a                   	pop    %edx
80102f3f:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102f46:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f4c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4f:	e8 7c d1 ff ff       	call   801000d0 <bread>
80102f54:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f56:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f59:	83 c4 0c             	add    $0xc,%esp
80102f5c:	68 00 02 00 00       	push   $0x200
80102f61:	50                   	push   %eax
80102f62:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f65:	50                   	push   %eax
80102f66:	e8 25 18 00 00       	call   80104790 <memmove>
    bwrite(to);  // write the log
80102f6b:	89 34 24             	mov    %esi,(%esp)
80102f6e:	e8 2d d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102f73:	89 3c 24             	mov    %edi,(%esp)
80102f76:	e8 65 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102f7b:	89 34 24             	mov    %esi,(%esp)
80102f7e:	e8 5d d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f83:	83 c4 10             	add    $0x10,%esp
80102f86:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f8c:	7c 94                	jl     80102f22 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f8e:	e8 bd fd ff ff       	call   80102d50 <write_head>
    install_trans(); // Now install writes to home locations
80102f93:	e8 18 fd ff ff       	call   80102cb0 <install_trans>
    log.lh.n = 0;
80102f98:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f9f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fa2:	e8 a9 fd ff ff       	call   80102d50 <write_head>
    acquire(&log.lock);
80102fa7:	83 ec 0c             	sub    $0xc,%esp
80102faa:	68 a0 26 11 80       	push   $0x801126a0
80102faf:	e8 ac 15 00 00       	call   80104560 <acquire>
    wakeup(&log);
80102fb4:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102fbb:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102fc2:	00 00 00 
    wakeup(&log);
80102fc5:	e8 f6 11 00 00       	call   801041c0 <wakeup>
    release(&log.lock);
80102fca:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102fd1:	e8 aa 16 00 00       	call   80104680 <release>
80102fd6:	83 c4 10             	add    $0x10,%esp
}
80102fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdc:	5b                   	pop    %ebx
80102fdd:	5e                   	pop    %esi
80102fde:	5f                   	pop    %edi
80102fdf:	5d                   	pop    %ebp
80102fe0:	c3                   	ret    
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102fe8:	83 ec 0c             	sub    $0xc,%esp
80102feb:	68 a0 26 11 80       	push   $0x801126a0
80102ff0:	e8 cb 11 00 00       	call   801041c0 <wakeup>
  release(&log.lock);
80102ff5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ffc:	e8 7f 16 00 00       	call   80104680 <release>
80103001:	83 c4 10             	add    $0x10,%esp
}
80103004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103007:	5b                   	pop    %ebx
80103008:	5e                   	pop    %esi
80103009:	5f                   	pop    %edi
8010300a:	5d                   	pop    %ebp
8010300b:	c3                   	ret    
    panic("log.committing");
8010300c:	83 ec 0c             	sub    $0xc,%esp
8010300f:	68 64 7a 10 80       	push   $0x80107a64
80103014:	e8 77 d4 ff ff       	call   80100490 <panic>
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103020 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103027:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010302d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103030:	83 fa 1d             	cmp    $0x1d,%edx
80103033:	0f 8f 9d 00 00 00    	jg     801030d6 <log_write+0xb6>
80103039:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010303e:	83 e8 01             	sub    $0x1,%eax
80103041:	39 c2                	cmp    %eax,%edx
80103043:	0f 8d 8d 00 00 00    	jge    801030d6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103049:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010304e:	85 c0                	test   %eax,%eax
80103050:	0f 8e 8d 00 00 00    	jle    801030e3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103056:	83 ec 0c             	sub    $0xc,%esp
80103059:	68 a0 26 11 80       	push   $0x801126a0
8010305e:	e8 fd 14 00 00       	call   80104560 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103063:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103069:	83 c4 10             	add    $0x10,%esp
8010306c:	83 f9 00             	cmp    $0x0,%ecx
8010306f:	7e 57                	jle    801030c8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103071:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103074:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103076:	3b 15 ec 26 11 80    	cmp    0x801126ec,%edx
8010307c:	75 0b                	jne    80103089 <log_write+0x69>
8010307e:	eb 38                	jmp    801030b8 <log_write+0x98>
80103080:	39 14 85 ec 26 11 80 	cmp    %edx,-0x7feed914(,%eax,4)
80103087:	74 2f                	je     801030b8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103089:	83 c0 01             	add    $0x1,%eax
8010308c:	39 c1                	cmp    %eax,%ecx
8010308e:	75 f0                	jne    80103080 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103090:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103097:	83 c0 01             	add    $0x1,%eax
8010309a:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
8010309f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801030a2:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801030a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030ac:	c9                   	leave  
  release(&log.lock);
801030ad:	e9 ce 15 00 00       	jmp    80104680 <release>
801030b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030b8:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
801030bf:	eb de                	jmp    8010309f <log_write+0x7f>
801030c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c8:	8b 43 08             	mov    0x8(%ebx),%eax
801030cb:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
801030d0:	75 cd                	jne    8010309f <log_write+0x7f>
801030d2:	31 c0                	xor    %eax,%eax
801030d4:	eb c1                	jmp    80103097 <log_write+0x77>
    panic("too big a transaction");
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	68 73 7a 10 80       	push   $0x80107a73
801030de:	e8 ad d3 ff ff       	call   80100490 <panic>
    panic("log_write outside of trans");
801030e3:	83 ec 0c             	sub    $0xc,%esp
801030e6:	68 89 7a 10 80       	push   $0x80107a89
801030eb:	e8 a0 d3 ff ff       	call   80100490 <panic>

801030f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030f7:	e8 74 09 00 00       	call   80103a70 <cpuid>
801030fc:	89 c3                	mov    %eax,%ebx
801030fe:	e8 6d 09 00 00       	call   80103a70 <cpuid>
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	53                   	push   %ebx
80103107:	50                   	push   %eax
80103108:	68 a4 7a 10 80       	push   $0x80107aa4
8010310d:	e8 4e d6 ff ff       	call   80100760 <cprintf>
  idtinit();       // load idt register
80103112:	e8 a9 28 00 00       	call   801059c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103117:	e8 d4 08 00 00       	call   801039f0 <mycpu>
8010311c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010311e:	b8 01 00 00 00       	mov    $0x1,%eax
80103123:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010312a:	e8 f1 0b 00 00       	call   80103d20 <scheduler>
8010312f:	90                   	nop

80103130 <mpenter>:
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103136:	e8 95 3b 00 00       	call   80106cd0 <switchkvm>
  seginit();
8010313b:	e8 00 3b 00 00       	call   80106c40 <seginit>
  lapicinit();
80103140:	e8 9b f7 ff ff       	call   801028e0 <lapicinit>
  mpmain();
80103145:	e8 a6 ff ff ff       	call   801030f0 <mpmain>
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <main>:
{
80103150:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103154:	83 e4 f0             	and    $0xfffffff0,%esp
80103157:	ff 71 fc             	pushl  -0x4(%ecx)
8010315a:	55                   	push   %ebp
8010315b:	89 e5                	mov    %esp,%ebp
8010315d:	53                   	push   %ebx
8010315e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010315f:	83 ec 08             	sub    $0x8,%esp
80103162:	68 00 00 40 80       	push   $0x80400000
80103167:	68 c8 54 11 80       	push   $0x801154c8
8010316c:	e8 2f f5 ff ff       	call   801026a0 <kinit1>
  kvmalloc();      // kernel page table
80103171:	e8 aa 42 00 00       	call   80107420 <kvmalloc>
  mpinit();        // detect other processors
80103176:	e8 75 01 00 00       	call   801032f0 <mpinit>
  lapicinit();     // interrupt controller
8010317b:	e8 60 f7 ff ff       	call   801028e0 <lapicinit>
  seginit();       // segment descriptors
80103180:	e8 bb 3a 00 00       	call   80106c40 <seginit>
  picinit();       // disable pic
80103185:	e8 46 03 00 00       	call   801034d0 <picinit>
  ioapicinit();    // another interrupt controller
8010318a:	e8 41 f3 ff ff       	call   801024d0 <ioapicinit>
  consoleinit();   // console hardware
8010318f:	e8 2c d9 ff ff       	call   80100ac0 <consoleinit>
  uartinit();      // serial port
80103194:	e8 77 2d 00 00       	call   80105f10 <uartinit>
  pinit();         // process table
80103199:	e8 32 08 00 00       	call   801039d0 <pinit>
  tvinit();        // trap vectors
8010319e:	e8 9d 27 00 00       	call   80105940 <tvinit>
  binit();         // buffer cache
801031a3:	e8 98 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031a8:	e8 b3 dc ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801031ad:	e8 fe f0 ff ff       	call   801022b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031b2:	83 c4 0c             	add    $0xc,%esp
801031b5:	68 8a 00 00 00       	push   $0x8a
801031ba:	68 8c a4 10 80       	push   $0x8010a48c
801031bf:	68 00 70 00 80       	push   $0x80007000
801031c4:	e8 c7 15 00 00       	call   80104790 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031c9:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
801031d0:	00 00 00 
801031d3:	83 c4 10             	add    $0x10,%esp
801031d6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801031db:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801031e0:	76 71                	jbe    80103253 <main+0x103>
801031e2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801031e7:	89 f6                	mov    %esi,%esi
801031e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801031f0:	e8 fb 07 00 00       	call   801039f0 <mycpu>
801031f5:	39 d8                	cmp    %ebx,%eax
801031f7:	74 41                	je     8010323a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031f9:	e8 72 f5 ff ff       	call   80102770 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801031fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103203:	c7 05 f8 6f 00 80 30 	movl   $0x80103130,0x80006ff8
8010320a:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010320d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103214:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103217:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010321c:	0f b6 03             	movzbl (%ebx),%eax
8010321f:	83 ec 08             	sub    $0x8,%esp
80103222:	68 00 70 00 00       	push   $0x7000
80103227:	50                   	push   %eax
80103228:	e8 03 f8 ff ff       	call   80102a30 <lapicstartap>
8010322d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103230:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103236:	85 c0                	test   %eax,%eax
80103238:	74 f6                	je     80103230 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010323a:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103241:	00 00 00 
80103244:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010324a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010324f:	39 c3                	cmp    %eax,%ebx
80103251:	72 9d                	jb     801031f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103253:	83 ec 08             	sub    $0x8,%esp
80103256:	68 00 00 40 80       	push   $0x80400000
8010325b:	68 00 00 40 80       	push   $0x80400000
80103260:	e8 ab f4 ff ff       	call   80102710 <kinit2>
  userinit();      // first user process
80103265:	e8 56 08 00 00       	call   80103ac0 <userinit>
  mpmain();        // finish this processor's setup
8010326a:	e8 81 fe ff ff       	call   801030f0 <mpmain>
8010326f:	90                   	nop

80103270 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103275:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010327b:	53                   	push   %ebx
  e = addr+len;
8010327c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010327f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103282:	39 de                	cmp    %ebx,%esi
80103284:	72 10                	jb     80103296 <mpsearch1+0x26>
80103286:	eb 50                	jmp    801032d8 <mpsearch1+0x68>
80103288:	90                   	nop
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	39 fb                	cmp    %edi,%ebx
80103292:	89 fe                	mov    %edi,%esi
80103294:	76 42                	jbe    801032d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103296:	83 ec 04             	sub    $0x4,%esp
80103299:	8d 7e 10             	lea    0x10(%esi),%edi
8010329c:	6a 04                	push   $0x4
8010329e:	68 b8 7a 10 80       	push   $0x80107ab8
801032a3:	56                   	push   %esi
801032a4:	e8 87 14 00 00       	call   80104730 <memcmp>
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	85 c0                	test   %eax,%eax
801032ae:	75 e0                	jne    80103290 <mpsearch1+0x20>
801032b0:	89 f1                	mov    %esi,%ecx
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 11             	movzbl (%ecx),%edx
801032bb:	83 c1 01             	add    $0x1,%ecx
801032be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801032c0:	39 f9                	cmp    %edi,%ecx
801032c2:	75 f4                	jne    801032b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c4:	84 c0                	test   %al,%al
801032c6:	75 c8                	jne    80103290 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032cb:	89 f0                	mov    %esi,%eax
801032cd:	5b                   	pop    %ebx
801032ce:	5e                   	pop    %esi
801032cf:	5f                   	pop    %edi
801032d0:	5d                   	pop    %ebp
801032d1:	c3                   	ret    
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032db:	31 f6                	xor    %esi,%esi
}
801032dd:	89 f0                	mov    %esi,%eax
801032df:	5b                   	pop    %ebx
801032e0:	5e                   	pop    %esi
801032e1:	5f                   	pop    %edi
801032e2:	5d                   	pop    %ebp
801032e3:	c3                   	ret    
801032e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801032f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103300:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103307:	c1 e0 08             	shl    $0x8,%eax
8010330a:	09 d0                	or     %edx,%eax
8010330c:	c1 e0 04             	shl    $0x4,%eax
8010330f:	85 c0                	test   %eax,%eax
80103311:	75 1b                	jne    8010332e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103313:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010331a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103321:	c1 e0 08             	shl    $0x8,%eax
80103324:	09 d0                	or     %edx,%eax
80103326:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103329:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010332e:	ba 00 04 00 00       	mov    $0x400,%edx
80103333:	e8 38 ff ff ff       	call   80103270 <mpsearch1>
80103338:	85 c0                	test   %eax,%eax
8010333a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010333d:	0f 84 3d 01 00 00    	je     80103480 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103346:	8b 58 04             	mov    0x4(%eax),%ebx
80103349:	85 db                	test   %ebx,%ebx
8010334b:	0f 84 4f 01 00 00    	je     801034a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103351:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103357:	83 ec 04             	sub    $0x4,%esp
8010335a:	6a 04                	push   $0x4
8010335c:	68 d5 7a 10 80       	push   $0x80107ad5
80103361:	56                   	push   %esi
80103362:	e8 c9 13 00 00       	call   80104730 <memcmp>
80103367:	83 c4 10             	add    $0x10,%esp
8010336a:	85 c0                	test   %eax,%eax
8010336c:	0f 85 2e 01 00 00    	jne    801034a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103372:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103379:	3c 01                	cmp    $0x1,%al
8010337b:	0f 95 c2             	setne  %dl
8010337e:	3c 04                	cmp    $0x4,%al
80103380:	0f 95 c0             	setne  %al
80103383:	20 c2                	and    %al,%dl
80103385:	0f 85 15 01 00 00    	jne    801034a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010338b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103392:	66 85 ff             	test   %di,%di
80103395:	74 1a                	je     801033b1 <mpinit+0xc1>
80103397:	89 f0                	mov    %esi,%eax
80103399:	01 f7                	add    %esi,%edi
  sum = 0;
8010339b:	31 d2                	xor    %edx,%edx
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033a0:	0f b6 08             	movzbl (%eax),%ecx
801033a3:	83 c0 01             	add    $0x1,%eax
801033a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033a8:	39 c7                	cmp    %eax,%edi
801033aa:	75 f4                	jne    801033a0 <mpinit+0xb0>
801033ac:	84 d2                	test   %dl,%dl
801033ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801033b1:	85 f6                	test   %esi,%esi
801033b3:	0f 84 e7 00 00 00    	je     801034a0 <mpinit+0x1b0>
801033b9:	84 d2                	test   %dl,%dl
801033bb:	0f 85 df 00 00 00    	jne    801034a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801033c7:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801033d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801033d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033de:	01 d6                	add    %edx,%esi
801033e0:	39 c6                	cmp    %eax,%esi
801033e2:	76 23                	jbe    80103407 <mpinit+0x117>
    switch(*p){
801033e4:	0f b6 10             	movzbl (%eax),%edx
801033e7:	80 fa 04             	cmp    $0x4,%dl
801033ea:	0f 87 ca 00 00 00    	ja     801034ba <mpinit+0x1ca>
801033f0:	ff 24 95 fc 7a 10 80 	jmp    *-0x7fef8504(,%edx,4)
801033f7:	89 f6                	mov    %esi,%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103400:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103403:	39 c6                	cmp    %eax,%esi
80103405:	77 dd                	ja     801033e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103407:	85 db                	test   %ebx,%ebx
80103409:	0f 84 9e 00 00 00    	je     801034ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010340f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103412:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103416:	74 15                	je     8010342d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103418:	b8 70 00 00 00       	mov    $0x70,%eax
8010341d:	ba 22 00 00 00       	mov    $0x22,%edx
80103422:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103423:	ba 23 00 00 00       	mov    $0x23,%edx
80103428:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103429:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010342c:	ee                   	out    %al,(%dx)
  }
}
8010342d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103430:	5b                   	pop    %ebx
80103431:	5e                   	pop    %esi
80103432:	5f                   	pop    %edi
80103433:	5d                   	pop    %ebp
80103434:	c3                   	ret    
80103435:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103438:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
8010343e:	83 f9 07             	cmp    $0x7,%ecx
80103441:	7f 19                	jg     8010345c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103443:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103447:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010344d:	83 c1 01             	add    $0x1,%ecx
80103450:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103456:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
8010345c:	83 c0 14             	add    $0x14,%eax
      continue;
8010345f:	e9 7c ff ff ff       	jmp    801033e0 <mpinit+0xf0>
80103464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103468:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010346c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010346f:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
80103475:	e9 66 ff ff ff       	jmp    801033e0 <mpinit+0xf0>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103480:	ba 00 00 01 00       	mov    $0x10000,%edx
80103485:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010348a:	e8 e1 fd ff ff       	call   80103270 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010348f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103494:	0f 85 a9 fe ff ff    	jne    80103343 <mpinit+0x53>
8010349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 bd 7a 10 80       	push   $0x80107abd
801034a8:	e8 e3 cf ff ff       	call   80100490 <panic>
    panic("Didn't find a suitable machine");
801034ad:	83 ec 0c             	sub    $0xc,%esp
801034b0:	68 dc 7a 10 80       	push   $0x80107adc
801034b5:	e8 d6 cf ff ff       	call   80100490 <panic>
      ismp = 0;
801034ba:	31 db                	xor    %ebx,%ebx
801034bc:	e9 26 ff ff ff       	jmp    801033e7 <mpinit+0xf7>
801034c1:	66 90                	xchg   %ax,%ax
801034c3:	66 90                	xchg   %ax,%ax
801034c5:	66 90                	xchg   %ax,%ax
801034c7:	66 90                	xchg   %ax,%ax
801034c9:	66 90                	xchg   %ax,%ax
801034cb:	66 90                	xchg   %ax,%ax
801034cd:	66 90                	xchg   %ax,%ax
801034cf:	90                   	nop

801034d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801034d0:	55                   	push   %ebp
801034d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034d6:	ba 21 00 00 00       	mov    $0x21,%edx
801034db:	89 e5                	mov    %esp,%ebp
801034dd:	ee                   	out    %al,(%dx)
801034de:	ba a1 00 00 00       	mov    $0xa1,%edx
801034e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034e4:	5d                   	pop    %ebp
801034e5:	c3                   	ret    
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	66 90                	xchg   %ax,%ax
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103505:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010350b:	e8 70 d9 ff ff       	call   80100e80 <filealloc>
80103510:	85 c0                	test   %eax,%eax
80103512:	89 03                	mov    %eax,(%ebx)
80103514:	74 22                	je     80103538 <pipealloc+0x48>
80103516:	e8 65 d9 ff ff       	call   80100e80 <filealloc>
8010351b:	85 c0                	test   %eax,%eax
8010351d:	89 06                	mov    %eax,(%esi)
8010351f:	74 3f                	je     80103560 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103521:	e8 4a f2 ff ff       	call   80102770 <kalloc>
80103526:	85 c0                	test   %eax,%eax
80103528:	89 c7                	mov    %eax,%edi
8010352a:	75 54                	jne    80103580 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010352c:	8b 03                	mov    (%ebx),%eax
8010352e:	85 c0                	test   %eax,%eax
80103530:	75 34                	jne    80103566 <pipealloc+0x76>
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	74 0c                	je     8010354a <pipealloc+0x5a>
    fileclose(*f1);
8010353e:	83 ec 0c             	sub    $0xc,%esp
80103541:	50                   	push   %eax
80103542:	e8 f9 d9 ff ff       	call   80100f40 <fileclose>
80103547:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010354a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010354d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103552:	5b                   	pop    %ebx
80103553:	5e                   	pop    %esi
80103554:	5f                   	pop    %edi
80103555:	5d                   	pop    %ebp
80103556:	c3                   	ret    
80103557:	89 f6                	mov    %esi,%esi
80103559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103560:	8b 03                	mov    (%ebx),%eax
80103562:	85 c0                	test   %eax,%eax
80103564:	74 e4                	je     8010354a <pipealloc+0x5a>
    fileclose(*f0);
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	50                   	push   %eax
8010356a:	e8 d1 d9 ff ff       	call   80100f40 <fileclose>
  if(*f1)
8010356f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103571:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103574:	85 c0                	test   %eax,%eax
80103576:	75 c6                	jne    8010353e <pipealloc+0x4e>
80103578:	eb d0                	jmp    8010354a <pipealloc+0x5a>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103580:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103583:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010358a:	00 00 00 
  p->writeopen = 1;
8010358d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103594:	00 00 00 
  p->nwrite = 0;
80103597:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010359e:	00 00 00 
  p->nread = 0;
801035a1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035a8:	00 00 00 
  initlock(&p->lock, "pipe");
801035ab:	68 10 7b 10 80       	push   $0x80107b10
801035b0:	50                   	push   %eax
801035b1:	e8 ba 0e 00 00       	call   80104470 <initlock>
  (*f0)->type = FD_PIPE;
801035b6:	8b 03                	mov    (%ebx),%eax
  return 0;
801035b8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c1:	8b 03                	mov    (%ebx),%eax
801035c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035c7:	8b 03                	mov    (%ebx),%eax
801035c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035cd:	8b 03                	mov    (%ebx),%eax
801035cf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035d2:	8b 06                	mov    (%esi),%eax
801035d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e0:	8b 06                	mov    (%esi),%eax
801035e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035e6:	8b 06                	mov    (%esi),%eax
801035e8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801035eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ee:	31 c0                	xor    %eax,%eax
}
801035f0:	5b                   	pop    %ebx
801035f1:	5e                   	pop    %esi
801035f2:	5f                   	pop    %edi
801035f3:	5d                   	pop    %ebp
801035f4:	c3                   	ret    
801035f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103600 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx
80103605:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103608:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	53                   	push   %ebx
8010360f:	e8 4c 0f 00 00       	call   80104560 <acquire>
  if(writable){
80103614:	83 c4 10             	add    $0x10,%esp
80103617:	85 f6                	test   %esi,%esi
80103619:	74 45                	je     80103660 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010361b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103621:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103624:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010362b:	00 00 00 
    wakeup(&p->nread);
8010362e:	50                   	push   %eax
8010362f:	e8 8c 0b 00 00       	call   801041c0 <wakeup>
80103634:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103637:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010363d:	85 d2                	test   %edx,%edx
8010363f:	75 0a                	jne    8010364b <pipeclose+0x4b>
80103641:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103647:	85 c0                	test   %eax,%eax
80103649:	74 35                	je     80103680 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010364b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010364e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103651:	5b                   	pop    %ebx
80103652:	5e                   	pop    %esi
80103653:	5d                   	pop    %ebp
    release(&p->lock);
80103654:	e9 27 10 00 00       	jmp    80104680 <release>
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103660:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103666:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103669:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103670:	00 00 00 
    wakeup(&p->nwrite);
80103673:	50                   	push   %eax
80103674:	e8 47 0b 00 00       	call   801041c0 <wakeup>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	eb b9                	jmp    80103637 <pipeclose+0x37>
8010367e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	53                   	push   %ebx
80103684:	e8 f7 0f 00 00       	call   80104680 <release>
    kfree((char*)p);
80103689:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010368c:	83 c4 10             	add    $0x10,%esp
}
8010368f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103692:	5b                   	pop    %ebx
80103693:	5e                   	pop    %esi
80103694:	5d                   	pop    %ebp
    kfree((char*)p);
80103695:	e9 26 ef ff ff       	jmp    801025c0 <kfree>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 28             	sub    $0x28,%esp
801036a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ac:	53                   	push   %ebx
801036ad:	e8 ae 0e 00 00       	call   80104560 <acquire>
  for(i = 0; i < n; i++){
801036b2:	8b 45 10             	mov    0x10(%ebp),%eax
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	85 c0                	test   %eax,%eax
801036ba:	0f 8e c9 00 00 00    	jle    80103789 <pipewrite+0xe9>
801036c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036d2:	03 4d 10             	add    0x10(%ebp),%ecx
801036d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801036de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801036e4:	39 d0                	cmp    %edx,%eax
801036e6:	75 71                	jne    80103759 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801036e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ee:	85 c0                	test   %eax,%eax
801036f0:	74 4e                	je     80103740 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801036f8:	eb 3a                	jmp    80103734 <pipewrite+0x94>
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	57                   	push   %edi
80103704:	e8 b7 0a 00 00       	call   801041c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103709:	5a                   	pop    %edx
8010370a:	59                   	pop    %ecx
8010370b:	53                   	push   %ebx
8010370c:	56                   	push   %esi
8010370d:	e8 ee 08 00 00       	call   80104000 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103712:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103718:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010371e:	83 c4 10             	add    $0x10,%esp
80103721:	05 00 02 00 00       	add    $0x200,%eax
80103726:	39 c2                	cmp    %eax,%edx
80103728:	75 36                	jne    80103760 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010372a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103730:	85 c0                	test   %eax,%eax
80103732:	74 0c                	je     80103740 <pipewrite+0xa0>
80103734:	e8 57 03 00 00       	call   80103a90 <myproc>
80103739:	8b 40 24             	mov    0x24(%eax),%eax
8010373c:	85 c0                	test   %eax,%eax
8010373e:	74 c0                	je     80103700 <pipewrite+0x60>
        release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 37 0f 00 00       	call   80104680 <release>
        return -1;
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103754:	5b                   	pop    %ebx
80103755:	5e                   	pop    %esi
80103756:	5f                   	pop    %edi
80103757:	5d                   	pop    %ebp
80103758:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103759:	89 c2                	mov    %eax,%edx
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103760:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103763:	8d 42 01             	lea    0x1(%edx),%eax
80103766:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010376c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103772:	83 c6 01             	add    $0x1,%esi
80103775:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103779:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010377c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010377f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103783:	0f 85 4f ff ff ff    	jne    801036d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103789:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010378f:	83 ec 0c             	sub    $0xc,%esp
80103792:	50                   	push   %eax
80103793:	e8 28 0a 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
80103798:	89 1c 24             	mov    %ebx,(%esp)
8010379b:	e8 e0 0e 00 00       	call   80104680 <release>
  return n;
801037a0:	83 c4 10             	add    $0x10,%esp
801037a3:	8b 45 10             	mov    0x10(%ebp),%eax
801037a6:	eb a9                	jmp    80103751 <pipewrite+0xb1>
801037a8:	90                   	nop
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 18             	sub    $0x18,%esp
801037b9:	8b 75 08             	mov    0x8(%ebp),%esi
801037bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037bf:	56                   	push   %esi
801037c0:	e8 9b 0d 00 00       	call   80104560 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037d4:	75 6a                	jne    80103840 <piperead+0x90>
801037d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801037dc:	85 db                	test   %ebx,%ebx
801037de:	0f 84 c4 00 00 00    	je     801038a8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037ea:	eb 2d                	jmp    80103819 <piperead+0x69>
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	e8 06 08 00 00       	call   80104000 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fa:	83 c4 10             	add    $0x10,%esp
801037fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103803:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103809:	75 35                	jne    80103840 <piperead+0x90>
8010380b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103811:	85 d2                	test   %edx,%edx
80103813:	0f 84 8f 00 00 00    	je     801038a8 <piperead+0xf8>
    if(myproc()->killed){
80103819:	e8 72 02 00 00       	call   80103a90 <myproc>
8010381e:	8b 48 24             	mov    0x24(%eax),%ecx
80103821:	85 c9                	test   %ecx,%ecx
80103823:	74 cb                	je     801037f0 <piperead+0x40>
      release(&p->lock);
80103825:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103828:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010382d:	56                   	push   %esi
8010382e:	e8 4d 0e 00 00       	call   80104680 <release>
      return -1;
80103833:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103839:	89 d8                	mov    %ebx,%eax
8010383b:	5b                   	pop    %ebx
8010383c:	5e                   	pop    %esi
8010383d:	5f                   	pop    %edi
8010383e:	5d                   	pop    %ebp
8010383f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103840:	8b 45 10             	mov    0x10(%ebp),%eax
80103843:	85 c0                	test   %eax,%eax
80103845:	7e 61                	jle    801038a8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103847:	31 db                	xor    %ebx,%ebx
80103849:	eb 13                	jmp    8010385e <piperead+0xae>
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103850:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103856:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010385c:	74 1f                	je     8010387d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010385e:	8d 41 01             	lea    0x1(%ecx),%eax
80103861:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103867:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010386d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103872:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103875:	83 c3 01             	add    $0x1,%ebx
80103878:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010387b:	75 d3                	jne    80103850 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103883:	83 ec 0c             	sub    $0xc,%esp
80103886:	50                   	push   %eax
80103887:	e8 34 09 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
8010388c:	89 34 24             	mov    %esi,(%esp)
8010388f:	e8 ec 0d 00 00       	call   80104680 <release>
  return i;
80103894:	83 c4 10             	add    $0x10,%esp
}
80103897:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010389a:	89 d8                	mov    %ebx,%eax
8010389c:	5b                   	pop    %ebx
8010389d:	5e                   	pop    %esi
8010389e:	5f                   	pop    %edi
8010389f:	5d                   	pop    %ebp
801038a0:	c3                   	ret    
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a8:	31 db                	xor    %ebx,%ebx
801038aa:	eb d1                	jmp    8010387d <piperead+0xcd>
801038ac:	66 90                	xchg   %ax,%ax
801038ae:	66 90                	xchg   %ax,%ax

801038b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038b4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801038b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038bc:	68 40 2d 11 80       	push   $0x80112d40
801038c1:	e8 9a 0c 00 00       	call   80104560 <acquire>
801038c6:	83 c4 10             	add    $0x10,%esp
801038c9:	eb 10                	jmp    801038db <allocproc+0x2b>
801038cb:	90                   	nop
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038d0:	83 c3 7c             	add    $0x7c,%ebx
801038d3:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801038d9:	73 75                	jae    80103950 <allocproc+0xa0>
    if(p->state == UNUSED)
801038db:	8b 43 0c             	mov    0xc(%ebx),%eax
801038de:	85 c0                	test   %eax,%eax
801038e0:	75 ee                	jne    801038d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801038e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038f1:	8d 50 01             	lea    0x1(%eax),%edx
801038f4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801038f7:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
801038fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103902:	e8 79 0d 00 00       	call   80104680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103907:	e8 64 ee ff ff       	call   80102770 <kalloc>
8010390c:	83 c4 10             	add    $0x10,%esp
8010390f:	85 c0                	test   %eax,%eax
80103911:	89 43 08             	mov    %eax,0x8(%ebx)
80103914:	74 53                	je     80103969 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103916:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010391c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010391f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103924:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103927:	c7 40 14 32 59 10 80 	movl   $0x80105932,0x14(%eax)
  p->context = (struct context*)sp;
8010392e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103931:	6a 14                	push   $0x14
80103933:	6a 00                	push   $0x0
80103935:	50                   	push   %eax
80103936:	e8 a5 0d 00 00       	call   801046e0 <memset>
  p->context->eip = (uint)forkret;
8010393b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010393e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103941:	c7 40 10 80 39 10 80 	movl   $0x80103980,0x10(%eax)
}
80103948:	89 d8                	mov    %ebx,%eax
8010394a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010394d:	c9                   	leave  
8010394e:	c3                   	ret    
8010394f:	90                   	nop
  release(&ptable.lock);
80103950:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103953:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103955:	68 40 2d 11 80       	push   $0x80112d40
8010395a:	e8 21 0d 00 00       	call   80104680 <release>
}
8010395f:	89 d8                	mov    %ebx,%eax
  return 0;
80103961:	83 c4 10             	add    $0x10,%esp
}
80103964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103967:	c9                   	leave  
80103968:	c3                   	ret    
    p->state = UNUSED;
80103969:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103970:	31 db                	xor    %ebx,%ebx
80103972:	eb d4                	jmp    80103948 <allocproc+0x98>
80103974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010397a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103980 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103986:	68 40 2d 11 80       	push   $0x80112d40
8010398b:	e8 f0 0c 00 00       	call   80104680 <release>

  if (first) {
80103990:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	85 c0                	test   %eax,%eax
8010399a:	75 04                	jne    801039a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010399c:	c9                   	leave  
8010399d:	c3                   	ret    
8010399e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801039a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801039a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039aa:	00 00 00 
    iinit(ROOTDEV);
801039ad:	6a 01                	push   $0x1
801039af:	e8 8c dd ff ff       	call   80101740 <iinit>
    initlog(ROOTDEV);
801039b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039bb:	e8 f0 f3 ff ff       	call   80102db0 <initlog>
801039c0:	83 c4 10             	add    $0x10,%esp
}
801039c3:	c9                   	leave  
801039c4:	c3                   	ret    
801039c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039d0 <pinit>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039d6:	68 15 7b 10 80       	push   $0x80107b15
801039db:	68 40 2d 11 80       	push   $0x80112d40
801039e0:	e8 8b 0a 00 00       	call   80104470 <initlock>
}
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	c9                   	leave  
801039e9:	c3                   	ret    
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039f0 <mycpu>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039f5:	9c                   	pushf  
801039f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039f7:	f6 c4 02             	test   $0x2,%ah
801039fa:	75 5e                	jne    80103a5a <mycpu+0x6a>
  apicid = lapicid();
801039fc:	e8 df ef ff ff       	call   801029e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a01:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
80103a07:	85 f6                	test   %esi,%esi
80103a09:	7e 42                	jle    80103a4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a0b:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103a12:	39 d0                	cmp    %edx,%eax
80103a14:	74 30                	je     80103a46 <mycpu+0x56>
80103a16:	b9 50 28 11 80       	mov    $0x80112850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a1b:	31 d2                	xor    %edx,%edx
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
80103a20:	83 c2 01             	add    $0x1,%edx
80103a23:	39 f2                	cmp    %esi,%edx
80103a25:	74 26                	je     80103a4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a27:	0f b6 19             	movzbl (%ecx),%ebx
80103a2a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a30:	39 c3                	cmp    %eax,%ebx
80103a32:	75 ec                	jne    80103a20 <mycpu+0x30>
80103a34:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a3a:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
80103a45:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a46:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
      return &cpus[i];
80103a4b:	eb f2                	jmp    80103a3f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 1c 7b 10 80       	push   $0x80107b1c
80103a55:	e8 36 ca ff ff       	call   80100490 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	68 f8 7b 10 80       	push   $0x80107bf8
80103a62:	e8 29 ca ff ff       	call   80100490 <panic>
80103a67:	89 f6                	mov    %esi,%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <cpuid>:
cpuid() {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a76:	e8 75 ff ff ff       	call   801039f0 <mycpu>
80103a7b:	2d a0 27 11 80       	sub    $0x801127a0,%eax
}
80103a80:	c9                   	leave  
  return mycpu()-cpus;
80103a81:	c1 f8 04             	sar    $0x4,%eax
80103a84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a8a:	c3                   	ret    
80103a8b:	90                   	nop
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <myproc>:
myproc(void) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a97:	e8 84 0a 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103a9c:	e8 4f ff ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103aa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa7:	e8 74 0b 00 00       	call   80104620 <popcli>
}
80103aac:	83 c4 04             	add    $0x4,%esp
80103aaf:	89 d8                	mov    %ebx,%eax
80103ab1:	5b                   	pop    %ebx
80103ab2:	5d                   	pop    %ebp
80103ab3:	c3                   	ret    
80103ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ac0 <userinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ac7:	e8 e4 fd ff ff       	call   801038b0 <allocproc>
80103acc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ace:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103ad3:	e8 c8 38 00 00       	call   801073a0 <setupkvm>
80103ad8:	85 c0                	test   %eax,%eax
80103ada:	89 43 04             	mov    %eax,0x4(%ebx)
80103add:	0f 84 bd 00 00 00    	je     80103ba0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ae3:	83 ec 04             	sub    $0x4,%esp
80103ae6:	68 2c 00 00 00       	push   $0x2c
80103aeb:	68 60 a4 10 80       	push   $0x8010a460
80103af0:	50                   	push   %eax
80103af1:	e8 0a 33 00 00       	call   80106e00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103af6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103af9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aff:	6a 4c                	push   $0x4c
80103b01:	6a 00                	push   $0x0
80103b03:	ff 73 18             	pushl  0x18(%ebx)
80103b06:	e8 d5 0b 00 00       	call   801046e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b13:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b18:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b26:	8b 43 18             	mov    0x18(%ebx),%eax
80103b29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b31:	8b 43 18             	mov    0x18(%ebx),%eax
80103b34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b50:	8b 43 18             	mov    0x18(%ebx),%eax
80103b53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b5d:	6a 10                	push   $0x10
80103b5f:	68 45 7b 10 80       	push   $0x80107b45
80103b64:	50                   	push   %eax
80103b65:	e8 56 0d 00 00       	call   801048c0 <safestrcpy>
  p->cwd = namei("/");
80103b6a:	c7 04 24 4e 7b 10 80 	movl   $0x80107b4e,(%esp)
80103b71:	e8 2a e6 ff ff       	call   801021a0 <namei>
80103b76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b79:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b80:	e8 db 09 00 00       	call   80104560 <acquire>
  p->state = RUNNABLE;
80103b85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b8c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b93:	e8 e8 0a 00 00       	call   80104680 <release>
}
80103b98:	83 c4 10             	add    $0x10,%esp
80103b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b9e:	c9                   	leave  
80103b9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 2c 7b 10 80       	push   $0x80107b2c
80103ba8:	e8 e3 c8 ff ff       	call   80100490 <panic>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi

80103bb0 <growproc>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103bb8:	e8 63 09 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103bbd:	e8 2e fe ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103bc2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103bc8:	e8 53 0a 00 00       	call   80104620 <popcli>
  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103bcd:	85 db                	test   %ebx,%ebx
80103bcf:	78 1f                	js     80103bf0 <growproc+0x40>
80103bd1:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103bd7:	77 17                	ja     80103bf0 <growproc+0x40>
80103bd9:	03 1e                	add    (%esi),%ebx
80103bdb:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103be1:	77 0d                	ja     80103bf0 <growproc+0x40>
  curproc->sz += n;
80103be3:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103be5:	31 c0                	xor    %eax,%eax
}
80103be7:	5b                   	pop    %ebx
80103be8:	5e                   	pop    %esi
80103be9:	5d                   	pop    %ebp
80103bea:	c3                   	ret    
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  return -1;
80103bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bf5:	eb f0                	jmp    80103be7 <growproc+0x37>
80103bf7:	89 f6                	mov    %esi,%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <fork>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c09:	e8 12 09 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103c0e:	e8 dd fd ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103c13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c19:	e8 02 0a 00 00       	call   80104620 <popcli>
  if((np = allocproc()) == 0){
80103c1e:	e8 8d fc ff ff       	call   801038b0 <allocproc>
80103c23:	85 c0                	test   %eax,%eax
80103c25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c28:	0f 84 b7 00 00 00    	je     80103ce5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c2e:	83 ec 08             	sub    $0x8,%esp
80103c31:	ff 33                	pushl  (%ebx)
80103c33:	ff 73 04             	pushl  0x4(%ebx)
80103c36:	89 c7                	mov    %eax,%edi
80103c38:	e8 03 38 00 00       	call   80107440 <copyuvm>
80103c3d:	83 c4 10             	add    $0x10,%esp
80103c40:	85 c0                	test   %eax,%eax
80103c42:	89 47 04             	mov    %eax,0x4(%edi)
80103c45:	0f 84 a1 00 00 00    	je     80103cec <fork+0xec>
  np->sz = curproc->sz;
80103c4b:	8b 03                	mov    (%ebx),%eax
80103c4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c50:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c52:	89 59 14             	mov    %ebx,0x14(%ecx)
80103c55:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c57:	8b 79 18             	mov    0x18(%ecx),%edi
80103c5a:	8b 73 18             	mov    0x18(%ebx),%esi
80103c5d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c66:	8b 40 18             	mov    0x18(%eax),%eax
80103c69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c74:	85 c0                	test   %eax,%eax
80103c76:	74 13                	je     80103c8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c78:	83 ec 0c             	sub    $0xc,%esp
80103c7b:	50                   	push   %eax
80103c7c:	e8 6f d2 ff ff       	call   80100ef0 <filedup>
80103c81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c84:	83 c4 10             	add    $0x10,%esp
80103c87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c8b:	83 c6 01             	add    $0x1,%esi
80103c8e:	83 fe 10             	cmp    $0x10,%esi
80103c91:	75 dd                	jne    80103c70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c93:	83 ec 0c             	sub    $0xc,%esp
80103c96:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c9c:	e8 6f dc ff ff       	call   80101910 <idup>
80103ca1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ca4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ca7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103caa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cad:	6a 10                	push   $0x10
80103caf:	53                   	push   %ebx
80103cb0:	50                   	push   %eax
80103cb1:	e8 0a 0c 00 00       	call   801048c0 <safestrcpy>
  pid = np->pid;
80103cb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cb9:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103cc0:	e8 9b 08 00 00       	call   80104560 <acquire>
  np->state = RUNNABLE;
80103cc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103ccc:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103cd3:	e8 a8 09 00 00       	call   80104680 <release>
  return pid;
80103cd8:	83 c4 10             	add    $0x10,%esp
}
80103cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cde:	89 d8                	mov    %ebx,%eax
80103ce0:	5b                   	pop    %ebx
80103ce1:	5e                   	pop    %esi
80103ce2:	5f                   	pop    %edi
80103ce3:	5d                   	pop    %ebp
80103ce4:	c3                   	ret    
    return -1;
80103ce5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cea:	eb ef                	jmp    80103cdb <fork+0xdb>
    kfree(np->kstack);
80103cec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cef:	83 ec 0c             	sub    $0xc,%esp
80103cf2:	ff 73 08             	pushl  0x8(%ebx)
80103cf5:	e8 c6 e8 ff ff       	call   801025c0 <kfree>
    np->kstack = 0;
80103cfa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d01:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d10:	eb c9                	jmp    80103cdb <fork+0xdb>
80103d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d20 <scheduler>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d29:	e8 c2 fc ff ff       	call   801039f0 <mycpu>
80103d2e:	8d 78 04             	lea    0x4(%eax),%edi
80103d31:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d33:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d3a:	00 00 00 
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d40:	fb                   	sti    
    acquire(&ptable.lock);
80103d41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d44:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103d49:	68 40 2d 11 80       	push   $0x80112d40
80103d4e:	e8 0d 08 00 00       	call   80104560 <acquire>
80103d53:	83 c4 10             	add    $0x10,%esp
80103d56:	8d 76 00             	lea    0x0(%esi),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103d60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d64:	75 33                	jne    80103d99 <scheduler+0x79>
      switchuvm(p);
80103d66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d6f:	53                   	push   %ebx
80103d70:	e8 7b 2f 00 00       	call   80106cf0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d75:	58                   	pop    %eax
80103d76:	5a                   	pop    %edx
80103d77:	ff 73 1c             	pushl  0x1c(%ebx)
80103d7a:	57                   	push   %edi
      p->state = RUNNING;
80103d7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d82:	e8 94 0b 00 00       	call   8010491b <swtch>
      switchkvm();
80103d87:	e8 44 2f 00 00       	call   80106cd0 <switchkvm>
      c->proc = 0;
80103d8c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d93:	00 00 00 
80103d96:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d99:	83 c3 7c             	add    $0x7c,%ebx
80103d9c:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103da2:	72 bc                	jb     80103d60 <scheduler+0x40>
    release(&ptable.lock);
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 40 2d 11 80       	push   $0x80112d40
80103dac:	e8 cf 08 00 00       	call   80104680 <release>
    sti();
80103db1:	83 c4 10             	add    $0x10,%esp
80103db4:	eb 8a                	jmp    80103d40 <scheduler+0x20>
80103db6:	8d 76 00             	lea    0x0(%esi),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <sched>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
  pushcli();
80103dc5:	e8 56 07 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103dca:	e8 21 fc ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103dcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd5:	e8 46 08 00 00       	call   80104620 <popcli>
  if(!holding(&ptable.lock))
80103dda:	83 ec 0c             	sub    $0xc,%esp
80103ddd:	68 40 2d 11 80       	push   $0x80112d40
80103de2:	e8 f9 06 00 00       	call   801044e0 <holding>
80103de7:	83 c4 10             	add    $0x10,%esp
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 4f                	je     80103e3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dee:	e8 fd fb ff ff       	call   801039f0 <mycpu>
80103df3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dfa:	75 68                	jne    80103e64 <sched+0xa4>
  if(p->state == RUNNING)
80103dfc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e00:	74 55                	je     80103e57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e02:	9c                   	pushf  
80103e03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e04:	f6 c4 02             	test   $0x2,%ah
80103e07:	75 41                	jne    80103e4a <sched+0x8a>
  intena = mycpu()->intena;
80103e09:	e8 e2 fb ff ff       	call   801039f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e17:	e8 d4 fb ff ff       	call   801039f0 <mycpu>
80103e1c:	83 ec 08             	sub    $0x8,%esp
80103e1f:	ff 70 04             	pushl  0x4(%eax)
80103e22:	53                   	push   %ebx
80103e23:	e8 f3 0a 00 00       	call   8010491b <swtch>
  mycpu()->intena = intena;
80103e28:	e8 c3 fb ff ff       	call   801039f0 <mycpu>
}
80103e2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e39:	5b                   	pop    %ebx
80103e3a:	5e                   	pop    %esi
80103e3b:	5d                   	pop    %ebp
80103e3c:	c3                   	ret    
    panic("sched ptable.lock");
80103e3d:	83 ec 0c             	sub    $0xc,%esp
80103e40:	68 50 7b 10 80       	push   $0x80107b50
80103e45:	e8 46 c6 ff ff       	call   80100490 <panic>
    panic("sched interruptible");
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 7c 7b 10 80       	push   $0x80107b7c
80103e52:	e8 39 c6 ff ff       	call   80100490 <panic>
    panic("sched running");
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 6e 7b 10 80       	push   $0x80107b6e
80103e5f:	e8 2c c6 ff ff       	call   80100490 <panic>
    panic("sched locks");
80103e64:	83 ec 0c             	sub    $0xc,%esp
80103e67:	68 62 7b 10 80       	push   $0x80107b62
80103e6c:	e8 1f c6 ff ff       	call   80100490 <panic>
80103e71:	eb 0d                	jmp    80103e80 <exit>
80103e73:	90                   	nop
80103e74:	90                   	nop
80103e75:	90                   	nop
80103e76:	90                   	nop
80103e77:	90                   	nop
80103e78:	90                   	nop
80103e79:	90                   	nop
80103e7a:	90                   	nop
80103e7b:	90                   	nop
80103e7c:	90                   	nop
80103e7d:	90                   	nop
80103e7e:	90                   	nop
80103e7f:	90                   	nop

80103e80 <exit>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e89:	e8 92 06 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103e8e:	e8 5d fb ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103e93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e99:	e8 82 07 00 00       	call   80104620 <popcli>
  if(curproc == initproc)
80103e9e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ea4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ea7:	8d 7e 68             	lea    0x68(%esi),%edi
80103eaa:	0f 84 e7 00 00 00    	je     80103f97 <exit+0x117>
    if(curproc->ofile[fd]){
80103eb0:	8b 03                	mov    (%ebx),%eax
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	74 12                	je     80103ec8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103eb6:	83 ec 0c             	sub    $0xc,%esp
80103eb9:	50                   	push   %eax
80103eba:	e8 81 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103ebf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ec5:	83 c4 10             	add    $0x10,%esp
80103ec8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103ecb:	39 fb                	cmp    %edi,%ebx
80103ecd:	75 e1                	jne    80103eb0 <exit+0x30>
  begin_op();
80103ecf:	e8 7c ef ff ff       	call   80102e50 <begin_op>
  iput(curproc->cwd);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	ff 76 68             	pushl  0x68(%esi)
80103eda:	e8 91 db ff ff       	call   80101a70 <iput>
  end_op();
80103edf:	e8 dc ef ff ff       	call   80102ec0 <end_op>
  curproc->cwd = 0;
80103ee4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103eeb:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ef2:	e8 69 06 00 00       	call   80104560 <acquire>
  wakeup1(curproc->parent);
80103ef7:	8b 56 14             	mov    0x14(%esi),%edx
80103efa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efd:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103f02:	eb 0e                	jmp    80103f12 <exit+0x92>
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f08:	83 c0 7c             	add    $0x7c,%eax
80103f0b:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103f10:	73 1c                	jae    80103f2e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103f12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f16:	75 f0                	jne    80103f08 <exit+0x88>
80103f18:	3b 50 20             	cmp    0x20(%eax),%edx
80103f1b:	75 eb                	jne    80103f08 <exit+0x88>
      p->state = RUNNABLE;
80103f1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f24:	83 c0 7c             	add    $0x7c,%eax
80103f27:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103f2c:	72 e4                	jb     80103f12 <exit+0x92>
      p->parent = initproc;
80103f2e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f34:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103f39:	eb 10                	jmp    80103f4b <exit+0xcb>
80103f3b:	90                   	nop
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f40:	83 c2 7c             	add    $0x7c,%edx
80103f43:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
80103f49:	73 33                	jae    80103f7e <exit+0xfe>
    if(p->parent == curproc){
80103f4b:	39 72 14             	cmp    %esi,0x14(%edx)
80103f4e:	75 f0                	jne    80103f40 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f50:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f54:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f57:	75 e7                	jne    80103f40 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f59:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103f5e:	eb 0a                	jmp    80103f6a <exit+0xea>
80103f60:	83 c0 7c             	add    $0x7c,%eax
80103f63:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80103f68:	73 d6                	jae    80103f40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f6e:	75 f0                	jne    80103f60 <exit+0xe0>
80103f70:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f73:	75 eb                	jne    80103f60 <exit+0xe0>
      p->state = RUNNABLE;
80103f75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f7c:	eb e2                	jmp    80103f60 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f7e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f85:	e8 36 fe ff ff       	call   80103dc0 <sched>
  panic("zombie exit");
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 9d 7b 10 80       	push   $0x80107b9d
80103f92:	e8 f9 c4 ff ff       	call   80100490 <panic>
    panic("init exiting");
80103f97:	83 ec 0c             	sub    $0xc,%esp
80103f9a:	68 90 7b 10 80       	push   $0x80107b90
80103f9f:	e8 ec c4 ff ff       	call   80100490 <panic>
80103fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103fb0 <yield>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103fb7:	68 40 2d 11 80       	push   $0x80112d40
80103fbc:	e8 9f 05 00 00       	call   80104560 <acquire>
  pushcli();
80103fc1:	e8 5a 05 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103fc6:	e8 25 fa ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80103fcb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd1:	e8 4a 06 00 00       	call   80104620 <popcli>
  myproc()->state = RUNNABLE;
80103fd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103fdd:	e8 de fd ff ff       	call   80103dc0 <sched>
  release(&ptable.lock);
80103fe2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103fe9:	e8 92 06 00 00       	call   80104680 <release>
}
80103fee:	83 c4 10             	add    $0x10,%esp
80103ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff4:	c9                   	leave  
80103ff5:	c3                   	ret    
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <sleep>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	8b 7d 08             	mov    0x8(%ebp),%edi
8010400c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010400f:	e8 0c 05 00 00       	call   80104520 <pushcli>
  c = mycpu();
80104014:	e8 d7 f9 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
80104019:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010401f:	e8 fc 05 00 00       	call   80104620 <popcli>
  if(p == 0)
80104024:	85 db                	test   %ebx,%ebx
80104026:	0f 84 87 00 00 00    	je     801040b3 <sleep+0xb3>
  if(lk == 0)
8010402c:	85 f6                	test   %esi,%esi
8010402e:	74 76                	je     801040a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104030:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80104036:	74 50                	je     80104088 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	68 40 2d 11 80       	push   $0x80112d40
80104040:	e8 1b 05 00 00       	call   80104560 <acquire>
    release(lk);
80104045:	89 34 24             	mov    %esi,(%esp)
80104048:	e8 33 06 00 00       	call   80104680 <release>
  p->chan = chan;
8010404d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104050:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104057:	e8 64 fd ff ff       	call   80103dc0 <sched>
  p->chan = 0;
8010405c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104063:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010406a:	e8 11 06 00 00       	call   80104680 <release>
    acquire(lk);
8010406f:	89 75 08             	mov    %esi,0x8(%ebp)
80104072:	83 c4 10             	add    $0x10,%esp
}
80104075:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104078:	5b                   	pop    %ebx
80104079:	5e                   	pop    %esi
8010407a:	5f                   	pop    %edi
8010407b:	5d                   	pop    %ebp
    acquire(lk);
8010407c:	e9 df 04 00 00       	jmp    80104560 <acquire>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104088:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010408b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104092:	e8 29 fd ff ff       	call   80103dc0 <sched>
  p->chan = 0;
80104097:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010409e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a1:	5b                   	pop    %ebx
801040a2:	5e                   	pop    %esi
801040a3:	5f                   	pop    %edi
801040a4:	5d                   	pop    %ebp
801040a5:	c3                   	ret    
    panic("sleep without lk");
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	68 af 7b 10 80       	push   $0x80107baf
801040ae:	e8 dd c3 ff ff       	call   80100490 <panic>
    panic("sleep");
801040b3:	83 ec 0c             	sub    $0xc,%esp
801040b6:	68 a9 7b 10 80       	push   $0x80107ba9
801040bb:	e8 d0 c3 ff ff       	call   80100490 <panic>

801040c0 <wait>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040c9:	e8 52 04 00 00       	call   80104520 <pushcli>
  c = mycpu();
801040ce:	e8 1d f9 ff ff       	call   801039f0 <mycpu>
  p = c->proc;
801040d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040d9:	e8 42 05 00 00       	call   80104620 <popcli>
  acquire(&ptable.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	68 40 2d 11 80       	push   $0x80112d40
801040e6:	e8 75 04 00 00       	call   80104560 <acquire>
801040eb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ee:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f0:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
801040f5:	eb 14                	jmp    8010410b <wait+0x4b>
801040f7:	89 f6                	mov    %esi,%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104100:	83 c3 7c             	add    $0x7c,%ebx
80104103:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80104109:	73 1b                	jae    80104126 <wait+0x66>
      if(p->parent != curproc)
8010410b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010410e:	75 f0                	jne    80104100 <wait+0x40>
      if(p->state == ZOMBIE){
80104110:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104114:	74 32                	je     80104148 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104116:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104119:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411e:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80104124:	72 e5                	jb     8010410b <wait+0x4b>
    if(!havekids || curproc->killed){
80104126:	85 c0                	test   %eax,%eax
80104128:	74 7e                	je     801041a8 <wait+0xe8>
8010412a:	8b 46 24             	mov    0x24(%esi),%eax
8010412d:	85 c0                	test   %eax,%eax
8010412f:	75 77                	jne    801041a8 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104131:	83 ec 08             	sub    $0x8,%esp
80104134:	68 40 2d 11 80       	push   $0x80112d40
80104139:	56                   	push   %esi
8010413a:	e8 c1 fe ff ff       	call   80104000 <sleep>
    havekids = 0;
8010413f:	83 c4 10             	add    $0x10,%esp
80104142:	eb aa                	jmp    801040ee <wait+0x2e>
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010414e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104151:	e8 6a e4 ff ff       	call   801025c0 <kfree>
        pgdir = p->pgdir;
80104156:	8b 7b 04             	mov    0x4(%ebx),%edi
        release(&ptable.lock);
80104159:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        p->kstack = 0;
80104160:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pgdir = 0;
80104167:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
8010416e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104175:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010417c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104180:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104187:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010418e:	e8 ed 04 00 00       	call   80104680 <release>
        freevm(pgdir);
80104193:	89 3c 24             	mov    %edi,(%esp)
80104196:	e8 85 31 00 00       	call   80107320 <freevm>
        return pid;
8010419b:	83 c4 10             	add    $0x10,%esp
}
8010419e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a1:	89 f0                	mov    %esi,%eax
801041a3:	5b                   	pop    %ebx
801041a4:	5e                   	pop    %esi
801041a5:	5f                   	pop    %edi
801041a6:	5d                   	pop    %ebp
801041a7:	c3                   	ret    
      release(&ptable.lock);
801041a8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041b0:	68 40 2d 11 80       	push   $0x80112d40
801041b5:	e8 c6 04 00 00       	call   80104680 <release>
      return -1;
801041ba:	83 c4 10             	add    $0x10,%esp
801041bd:	eb df                	jmp    8010419e <wait+0xde>
801041bf:	90                   	nop

801041c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ca:	68 40 2d 11 80       	push   $0x80112d40
801041cf:	e8 8c 03 00 00       	call   80104560 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801041dc:	eb 0c                	jmp    801041ea <wakeup+0x2a>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	83 c0 7c             	add    $0x7c,%eax
801041e3:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801041e8:	73 1c                	jae    80104206 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ee:	75 f0                	jne    801041e0 <wakeup+0x20>
801041f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041f3:	75 eb                	jne    801041e0 <wakeup+0x20>
      p->state = RUNNABLE;
801041f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fc:	83 c0 7c             	add    $0x7c,%eax
801041ff:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104204:	72 e4                	jb     801041ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104206:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
8010420d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104210:	c9                   	leave  
  release(&ptable.lock);
80104211:	e9 6a 04 00 00       	jmp    80104680 <release>
80104216:	8d 76 00             	lea    0x0(%esi),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010422a:	68 40 2d 11 80       	push   $0x80112d40
8010422f:	e8 2c 03 00 00       	call   80104560 <acquire>
80104234:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104237:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010423c:	eb 0c                	jmp    8010424a <kill+0x2a>
8010423e:	66 90                	xchg   %ax,%ax
80104240:	83 c0 7c             	add    $0x7c,%eax
80104243:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104248:	73 36                	jae    80104280 <kill+0x60>
    if(p->pid == pid){
8010424a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010424d:	75 f1                	jne    80104240 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010424f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104253:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010425a:	75 07                	jne    80104263 <kill+0x43>
        p->state = RUNNABLE;
8010425c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	68 40 2d 11 80       	push   $0x80112d40
8010426b:	e8 10 04 00 00       	call   80104680 <release>
      return 0;
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104278:	c9                   	leave  
80104279:	c3                   	ret    
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	68 40 2d 11 80       	push   $0x80112d40
80104288:	e8 f3 03 00 00       	call   80104680 <release>
  return -1;
8010428d:	83 c4 10             	add    $0x10,%esp
80104290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104298:	c9                   	leave  
80104299:	c3                   	ret    
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a9:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801042ae:	83 ec 3c             	sub    $0x3c,%esp
801042b1:	eb 24                	jmp    801042d7 <procdump+0x37>
801042b3:	90                   	nop
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 e2 7e 10 80       	push   $0x80107ee2
801042c0:	e8 9b c4 ff ff       	call   80100760 <cprintf>
801042c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c8:	83 c3 7c             	add    $0x7c,%ebx
801042cb:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801042d1:	0f 83 81 00 00 00    	jae    80104358 <procdump+0xb8>
    if(p->state == UNUSED)
801042d7:	8b 43 0c             	mov    0xc(%ebx),%eax
801042da:	85 c0                	test   %eax,%eax
801042dc:	74 ea                	je     801042c8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042de:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801042e1:	ba c0 7b 10 80       	mov    $0x80107bc0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042e6:	77 11                	ja     801042f9 <procdump+0x59>
801042e8:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
      state = "???";
801042ef:	b8 c0 7b 10 80       	mov    $0x80107bc0,%eax
801042f4:	85 d2                	test   %edx,%edx
801042f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042fc:	50                   	push   %eax
801042fd:	52                   	push   %edx
801042fe:	ff 73 10             	pushl  0x10(%ebx)
80104301:	68 c4 7b 10 80       	push   $0x80107bc4
80104306:	e8 55 c4 ff ff       	call   80100760 <cprintf>
    if(p->state == SLEEPING){
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104312:	75 a4                	jne    801042b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104314:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104317:	83 ec 08             	sub    $0x8,%esp
8010431a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010431d:	50                   	push   %eax
8010431e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104321:	8b 40 0c             	mov    0xc(%eax),%eax
80104324:	83 c0 08             	add    $0x8,%eax
80104327:	50                   	push   %eax
80104328:	e8 63 01 00 00       	call   80104490 <getcallerpcs>
8010432d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104330:	8b 17                	mov    (%edi),%edx
80104332:	85 d2                	test   %edx,%edx
80104334:	74 82                	je     801042b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104336:	83 ec 08             	sub    $0x8,%esp
80104339:	83 c7 04             	add    $0x4,%edi
8010433c:	52                   	push   %edx
8010433d:	68 e1 75 10 80       	push   $0x801075e1
80104342:	e8 19 c4 ff ff       	call   80100760 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104347:	83 c4 10             	add    $0x10,%esp
8010434a:	39 fe                	cmp    %edi,%esi
8010434c:	75 e2                	jne    80104330 <procdump+0x90>
8010434e:	e9 65 ff ff ff       	jmp    801042b8 <procdump+0x18>
80104353:	90                   	nop
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104358:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435b:	5b                   	pop    %ebx
8010435c:	5e                   	pop    %esi
8010435d:	5f                   	pop    %edi
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

80104360 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010436a:	68 38 7c 10 80       	push   $0x80107c38
8010436f:	8d 43 04             	lea    0x4(%ebx),%eax
80104372:	50                   	push   %eax
80104373:	e8 f8 00 00 00       	call   80104470 <initlock>
  lk->name = name;
80104378:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010437b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104381:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104384:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010438b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010438e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104391:	c9                   	leave  
80104392:	c3                   	ret    
80104393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	8d 73 04             	lea    0x4(%ebx),%esi
801043ae:	56                   	push   %esi
801043af:	e8 ac 01 00 00       	call   80104560 <acquire>
  while (lk->locked) {
801043b4:	8b 13                	mov    (%ebx),%edx
801043b6:	83 c4 10             	add    $0x10,%esp
801043b9:	85 d2                	test   %edx,%edx
801043bb:	74 16                	je     801043d3 <acquiresleep+0x33>
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043c0:	83 ec 08             	sub    $0x8,%esp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	e8 36 fc ff ff       	call   80104000 <sleep>
  while (lk->locked) {
801043ca:	8b 03                	mov    (%ebx),%eax
801043cc:	83 c4 10             	add    $0x10,%esp
801043cf:	85 c0                	test   %eax,%eax
801043d1:	75 ed                	jne    801043c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043d9:	e8 b2 f6 ff ff       	call   80103a90 <myproc>
801043de:	8b 40 10             	mov    0x10(%eax),%eax
801043e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ea:	5b                   	pop    %ebx
801043eb:	5e                   	pop    %esi
801043ec:	5d                   	pop    %ebp
  release(&lk->lk);
801043ed:	e9 8e 02 00 00       	jmp    80104680 <release>
801043f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	8d 73 04             	lea    0x4(%ebx),%esi
8010440e:	56                   	push   %esi
8010440f:	e8 4c 01 00 00       	call   80104560 <acquire>
  lk->locked = 0;
80104414:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010441a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104421:	89 1c 24             	mov    %ebx,(%esp)
80104424:	e8 97 fd ff ff       	call   801041c0 <wakeup>
  release(&lk->lk);
80104429:	89 75 08             	mov    %esi,0x8(%ebp)
8010442c:	83 c4 10             	add    $0x10,%esp
}
8010442f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104432:	5b                   	pop    %ebx
80104433:	5e                   	pop    %esi
80104434:	5d                   	pop    %ebp
  release(&lk->lk);
80104435:	e9 46 02 00 00       	jmp    80104680 <release>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010444e:	53                   	push   %ebx
8010444f:	e8 0c 01 00 00       	call   80104560 <acquire>
  r = lk->locked;
80104454:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104456:	89 1c 24             	mov    %ebx,(%esp)
80104459:	e8 22 02 00 00       	call   80104680 <release>
  return r;
}
8010445e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104461:	89 f0                	mov    %esi,%eax
80104463:	5b                   	pop    %ebx
80104464:	5e                   	pop    %esi
80104465:	5d                   	pop    %ebp
80104466:	c3                   	ret    
80104467:	66 90                	xchg   %ax,%ax
80104469:	66 90                	xchg   %ax,%ax
8010446b:	66 90                	xchg   %ax,%ax
8010446d:	66 90                	xchg   %ax,%ax
8010446f:	90                   	nop

80104470 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104476:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010447f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret    
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104490:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104491:	31 d2                	xor    %edx,%edx
{
80104493:	89 e5                	mov    %esp,%ebp
80104495:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104496:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104499:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010449c:	83 e8 08             	sub    $0x8,%eax
8010449f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ac:	77 1a                	ja     801044c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ae:	8b 58 04             	mov    0x4(%eax),%ebx
801044b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044b9:	83 fa 0a             	cmp    $0xa,%edx
801044bc:	75 e2                	jne    801044a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044be:	5b                   	pop    %ebx
801044bf:	5d                   	pop    %ebp
801044c0:	c3                   	ret    
801044c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044cb:	83 c1 28             	add    $0x28,%ecx
801044ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801044d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801044d9:	39 c1                	cmp    %eax,%ecx
801044db:	75 f3                	jne    801044d0 <getcallerpcs+0x40>
}
801044dd:	5b                   	pop    %ebx
801044de:	5d                   	pop    %ebp
801044df:	c3                   	ret    

801044e0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 04             	sub    $0x4,%esp
801044e7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801044ea:	8b 02                	mov    (%edx),%eax
801044ec:	85 c0                	test   %eax,%eax
801044ee:	75 10                	jne    80104500 <holding+0x20>
}
801044f0:	83 c4 04             	add    $0x4,%esp
801044f3:	31 c0                	xor    %eax,%eax
801044f5:	5b                   	pop    %ebx
801044f6:	5d                   	pop    %ebp
801044f7:	c3                   	ret    
801044f8:	90                   	nop
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104500:	8b 5a 08             	mov    0x8(%edx),%ebx
80104503:	e8 e8 f4 ff ff       	call   801039f0 <mycpu>
80104508:	39 c3                	cmp    %eax,%ebx
8010450a:	0f 94 c0             	sete   %al
}
8010450d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104510:	0f b6 c0             	movzbl %al,%eax
}
80104513:	5b                   	pop    %ebx
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	8d 76 00             	lea    0x0(%esi),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
80104527:	9c                   	pushf  
80104528:	5b                   	pop    %ebx
  asm volatile("cli");
80104529:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010452a:	e8 c1 f4 ff ff       	call   801039f0 <mycpu>
8010452f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104535:	85 c0                	test   %eax,%eax
80104537:	75 11                	jne    8010454a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104539:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010453f:	e8 ac f4 ff ff       	call   801039f0 <mycpu>
80104544:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010454a:	e8 a1 f4 ff ff       	call   801039f0 <mycpu>
8010454f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104556:	83 c4 04             	add    $0x4,%esp
80104559:	5b                   	pop    %ebx
8010455a:	5d                   	pop    %ebp
8010455b:	c3                   	ret    
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <acquire>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104565:	e8 b6 ff ff ff       	call   80104520 <pushcli>
  if(holding(lk))
8010456a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010456d:	8b 03                	mov    (%ebx),%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	0f 85 81 00 00 00    	jne    801045f8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104577:	ba 01 00 00 00       	mov    $0x1,%edx
8010457c:	eb 05                	jmp    80104583 <acquire+0x23>
8010457e:	66 90                	xchg   %ax,%ax
80104580:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104583:	89 d0                	mov    %edx,%eax
80104585:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104588:	85 c0                	test   %eax,%eax
8010458a:	75 f4                	jne    80104580 <acquire+0x20>
  __sync_synchronize();
8010458c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104591:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104594:	e8 57 f4 ff ff       	call   801039f0 <mycpu>
  for(i = 0; i < 10; i++){
80104599:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010459b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010459e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045a1:	89 e8                	mov    %ebp,%eax
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045a8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045b4:	77 1a                	ja     801045d0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801045b6:	8b 58 04             	mov    0x4(%eax),%ebx
801045b9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045bc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045c1:	83 fa 0a             	cmp    $0xa,%edx
801045c4:	75 e2                	jne    801045a8 <acquire+0x48>
}
801045c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c9:	5b                   	pop    %ebx
801045ca:	5e                   	pop    %esi
801045cb:	5d                   	pop    %ebp
801045cc:	c3                   	ret    
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045d3:	83 c1 28             	add    $0x28,%ecx
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801045e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045e9:	39 c8                	cmp    %ecx,%eax
801045eb:	75 f3                	jne    801045e0 <acquire+0x80>
}
801045ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f0:	5b                   	pop    %ebx
801045f1:	5e                   	pop    %esi
801045f2:	5d                   	pop    %ebp
801045f3:	c3                   	ret    
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801045f8:	8b 73 08             	mov    0x8(%ebx),%esi
801045fb:	e8 f0 f3 ff ff       	call   801039f0 <mycpu>
80104600:	39 c6                	cmp    %eax,%esi
80104602:	0f 85 6f ff ff ff    	jne    80104577 <acquire+0x17>
    panic("acquire");
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	68 43 7c 10 80       	push   $0x80107c43
80104610:	e8 7b be ff ff       	call   80100490 <panic>
80104615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <popcli>:

void
popcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf  
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 35                	jne    80104662 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010462d:	e8 be f3 ff ff       	call   801039f0 <mycpu>
80104632:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104639:	78 34                	js     8010466f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010463b:	e8 b0 f3 ff ff       	call   801039f0 <mycpu>
80104640:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104646:	85 d2                	test   %edx,%edx
80104648:	74 06                	je     80104650 <popcli+0x30>
    sti();
}
8010464a:	c9                   	leave  
8010464b:	c3                   	ret    
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104650:	e8 9b f3 ff ff       	call   801039f0 <mycpu>
80104655:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 eb                	je     8010464a <popcli+0x2a>
  asm volatile("sti");
8010465f:	fb                   	sti    
}
80104660:	c9                   	leave  
80104661:	c3                   	ret    
    panic("popcli - interruptible");
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	68 4b 7c 10 80       	push   $0x80107c4b
8010466a:	e8 21 be ff ff       	call   80100490 <panic>
    panic("popcli");
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	68 62 7c 10 80       	push   $0x80107c62
80104677:	e8 14 be ff ff       	call   80100490 <panic>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <release>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104688:	8b 03                	mov    (%ebx),%eax
8010468a:	85 c0                	test   %eax,%eax
8010468c:	74 0c                	je     8010469a <release+0x1a>
8010468e:	8b 73 08             	mov    0x8(%ebx),%esi
80104691:	e8 5a f3 ff ff       	call   801039f0 <mycpu>
80104696:	39 c6                	cmp    %eax,%esi
80104698:	74 16                	je     801046b0 <release+0x30>
    panic("release");
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	68 69 7c 10 80       	push   $0x80107c69
801046a2:	e8 e9 bd ff ff       	call   80100490 <panic>
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801046b0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046b7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046be:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046cc:	5b                   	pop    %ebx
801046cd:	5e                   	pop    %esi
801046ce:	5d                   	pop    %ebp
  popcli();
801046cf:	e9 4c ff ff ff       	jmp    80104620 <popcli>
801046d4:	66 90                	xchg   %ax,%ax
801046d6:	66 90                	xchg   %ax,%ax
801046d8:	66 90                	xchg   %ax,%ax
801046da:	66 90                	xchg   %ax,%ax
801046dc:	66 90                	xchg   %ax,%ax
801046de:	66 90                	xchg   %ax,%ax

801046e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	53                   	push   %ebx
801046e5:	8b 55 08             	mov    0x8(%ebp),%edx
801046e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046eb:	f6 c2 03             	test   $0x3,%dl
801046ee:	75 05                	jne    801046f5 <memset+0x15>
801046f0:	f6 c1 03             	test   $0x3,%cl
801046f3:	74 13                	je     80104708 <memset+0x28>
  asm volatile("cld; rep stosb" :
801046f5:	89 d7                	mov    %edx,%edi
801046f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801046fa:	fc                   	cld    
801046fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046fd:	5b                   	pop    %ebx
801046fe:	89 d0                	mov    %edx,%eax
80104700:	5f                   	pop    %edi
80104701:	5d                   	pop    %ebp
80104702:	c3                   	ret    
80104703:	90                   	nop
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104708:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010470c:	c1 e9 02             	shr    $0x2,%ecx
8010470f:	89 f8                	mov    %edi,%eax
80104711:	89 fb                	mov    %edi,%ebx
80104713:	c1 e0 18             	shl    $0x18,%eax
80104716:	c1 e3 10             	shl    $0x10,%ebx
80104719:	09 d8                	or     %ebx,%eax
8010471b:	09 f8                	or     %edi,%eax
8010471d:	c1 e7 08             	shl    $0x8,%edi
80104720:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104722:	89 d7                	mov    %edx,%edi
80104724:	fc                   	cld    
80104725:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104727:	5b                   	pop    %ebx
80104728:	89 d0                	mov    %edx,%eax
8010472a:	5f                   	pop    %edi
8010472b:	5d                   	pop    %ebp
8010472c:	c3                   	ret    
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
80104736:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104739:	8b 75 08             	mov    0x8(%ebp),%esi
8010473c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010473f:	85 db                	test   %ebx,%ebx
80104741:	74 29                	je     8010476c <memcmp+0x3c>
    if(*s1 != *s2)
80104743:	0f b6 16             	movzbl (%esi),%edx
80104746:	0f b6 0f             	movzbl (%edi),%ecx
80104749:	38 d1                	cmp    %dl,%cl
8010474b:	75 2b                	jne    80104778 <memcmp+0x48>
8010474d:	b8 01 00 00 00       	mov    $0x1,%eax
80104752:	eb 14                	jmp    80104768 <memcmp+0x38>
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104758:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010475c:	83 c0 01             	add    $0x1,%eax
8010475f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104764:	38 ca                	cmp    %cl,%dl
80104766:	75 10                	jne    80104778 <memcmp+0x48>
  while(n-- > 0){
80104768:	39 d8                	cmp    %ebx,%eax
8010476a:	75 ec                	jne    80104758 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010476c:	5b                   	pop    %ebx
  return 0;
8010476d:	31 c0                	xor    %eax,%eax
}
8010476f:	5e                   	pop    %esi
80104770:	5f                   	pop    %edi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	90                   	nop
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104778:	0f b6 c2             	movzbl %dl,%eax
}
8010477b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010477c:	29 c8                	sub    %ecx,%eax
}
8010477e:	5e                   	pop    %esi
8010477f:	5f                   	pop    %edi
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret    
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 45 08             	mov    0x8(%ebp),%eax
80104798:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010479b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010479e:	39 c3                	cmp    %eax,%ebx
801047a0:	73 26                	jae    801047c8 <memmove+0x38>
801047a2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047a5:	39 c8                	cmp    %ecx,%eax
801047a7:	73 1f                	jae    801047c8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047a9:	85 f6                	test   %esi,%esi
801047ab:	8d 56 ff             	lea    -0x1(%esi),%edx
801047ae:	74 0f                	je     801047bf <memmove+0x2f>
      *--d = *--s;
801047b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047b7:	83 ea 01             	sub    $0x1,%edx
801047ba:	83 fa ff             	cmp    $0xffffffff,%edx
801047bd:	75 f1                	jne    801047b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047bf:	5b                   	pop    %ebx
801047c0:	5e                   	pop    %esi
801047c1:	5d                   	pop    %ebp
801047c2:	c3                   	ret    
801047c3:	90                   	nop
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801047c8:	31 d2                	xor    %edx,%edx
801047ca:	85 f6                	test   %esi,%esi
801047cc:	74 f1                	je     801047bf <memmove+0x2f>
801047ce:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801047d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801047d7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801047da:	39 d6                	cmp    %edx,%esi
801047dc:	75 f2                	jne    801047d0 <memmove+0x40>
}
801047de:	5b                   	pop    %ebx
801047df:	5e                   	pop    %esi
801047e0:	5d                   	pop    %ebp
801047e1:	c3                   	ret    
801047e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801047f3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801047f4:	eb 9a                	jmp    80104790 <memmove>
801047f6:	8d 76 00             	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	8b 7d 10             	mov    0x10(%ebp),%edi
80104808:	53                   	push   %ebx
80104809:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010480c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010480f:	85 ff                	test   %edi,%edi
80104811:	74 2f                	je     80104842 <strncmp+0x42>
80104813:	0f b6 01             	movzbl (%ecx),%eax
80104816:	0f b6 1e             	movzbl (%esi),%ebx
80104819:	84 c0                	test   %al,%al
8010481b:	74 37                	je     80104854 <strncmp+0x54>
8010481d:	38 c3                	cmp    %al,%bl
8010481f:	75 33                	jne    80104854 <strncmp+0x54>
80104821:	01 f7                	add    %esi,%edi
80104823:	eb 13                	jmp    80104838 <strncmp+0x38>
80104825:	8d 76 00             	lea    0x0(%esi),%esi
80104828:	0f b6 01             	movzbl (%ecx),%eax
8010482b:	84 c0                	test   %al,%al
8010482d:	74 21                	je     80104850 <strncmp+0x50>
8010482f:	0f b6 1a             	movzbl (%edx),%ebx
80104832:	89 d6                	mov    %edx,%esi
80104834:	38 d8                	cmp    %bl,%al
80104836:	75 1c                	jne    80104854 <strncmp+0x54>
    n--, p++, q++;
80104838:	8d 56 01             	lea    0x1(%esi),%edx
8010483b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010483e:	39 fa                	cmp    %edi,%edx
80104840:	75 e6                	jne    80104828 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104842:	5b                   	pop    %ebx
    return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	5e                   	pop    %esi
80104846:	5f                   	pop    %edi
80104847:	5d                   	pop    %ebp
80104848:	c3                   	ret    
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104850:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104854:	29 d8                	sub    %ebx,%eax
}
80104856:	5b                   	pop    %ebx
80104857:	5e                   	pop    %esi
80104858:	5f                   	pop    %edi
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    
8010485b:	90                   	nop
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 45 08             	mov    0x8(%ebp),%eax
80104868:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010486b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010486e:	89 c2                	mov    %eax,%edx
80104870:	eb 19                	jmp    8010488b <strncpy+0x2b>
80104872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104878:	83 c3 01             	add    $0x1,%ebx
8010487b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010487f:	83 c2 01             	add    $0x1,%edx
80104882:	84 c9                	test   %cl,%cl
80104884:	88 4a ff             	mov    %cl,-0x1(%edx)
80104887:	74 09                	je     80104892 <strncpy+0x32>
80104889:	89 f1                	mov    %esi,%ecx
8010488b:	85 c9                	test   %ecx,%ecx
8010488d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104890:	7f e6                	jg     80104878 <strncpy+0x18>
    ;
  while(n-- > 0)
80104892:	31 c9                	xor    %ecx,%ecx
80104894:	85 f6                	test   %esi,%esi
80104896:	7e 17                	jle    801048af <strncpy+0x4f>
80104898:	90                   	nop
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048a0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048a4:	89 f3                	mov    %esi,%ebx
801048a6:	83 c1 01             	add    $0x1,%ecx
801048a9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048ab:	85 db                	test   %ebx,%ebx
801048ad:	7f f1                	jg     801048a0 <strncpy+0x40>
  return os;
}
801048af:	5b                   	pop    %ebx
801048b0:	5e                   	pop    %esi
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    
801048b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048c8:	8b 45 08             	mov    0x8(%ebp),%eax
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801048ce:	85 c9                	test   %ecx,%ecx
801048d0:	7e 26                	jle    801048f8 <safestrcpy+0x38>
801048d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801048d6:	89 c1                	mov    %eax,%ecx
801048d8:	eb 17                	jmp    801048f1 <safestrcpy+0x31>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048e0:	83 c2 01             	add    $0x1,%edx
801048e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801048e7:	83 c1 01             	add    $0x1,%ecx
801048ea:	84 db                	test   %bl,%bl
801048ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801048ef:	74 04                	je     801048f5 <safestrcpy+0x35>
801048f1:	39 f2                	cmp    %esi,%edx
801048f3:	75 eb                	jne    801048e0 <safestrcpy+0x20>
    ;
  *s = 0;
801048f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5d                   	pop    %ebp
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <strlen>:

int
strlen(const char *s)
{
80104900:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104901:	31 c0                	xor    %eax,%eax
{
80104903:	89 e5                	mov    %esp,%ebp
80104905:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104908:	80 3a 00             	cmpb   $0x0,(%edx)
8010490b:	74 0c                	je     80104919 <strlen+0x19>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104917:	75 f7                	jne    80104910 <strlen+0x10>
    ;
  return n;
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    

8010491b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010491b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010491f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104923:	55                   	push   %ebp
  pushl %ebx
80104924:	53                   	push   %ebx
  pushl %esi
80104925:	56                   	push   %esi
  pushl %edi
80104926:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104927:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104929:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010492b:	5f                   	pop    %edi
  popl %esi
8010492c:	5e                   	pop    %esi
  popl %ebx
8010492d:	5b                   	pop    %ebx
  popl %ebp
8010492e:	5d                   	pop    %ebp
  ret
8010492f:	c3                   	ret    

80104930 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010493a:	e8 51 f1 ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010493f:	8b 00                	mov    (%eax),%eax
80104941:	39 d8                	cmp    %ebx,%eax
80104943:	76 1b                	jbe    80104960 <fetchint+0x30>
80104945:	8d 53 04             	lea    0x4(%ebx),%edx
80104948:	39 d0                	cmp    %edx,%eax
8010494a:	72 14                	jb     80104960 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010494c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010494f:	8b 13                	mov    (%ebx),%edx
80104951:	89 10                	mov    %edx,(%eax)
  return 0;
80104953:	31 c0                	xor    %eax,%eax
}
80104955:	83 c4 04             	add    $0x4,%esp
80104958:	5b                   	pop    %ebx
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	90                   	nop
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104965:	eb ee                	jmp    80104955 <fetchint+0x25>
80104967:	89 f6                	mov    %esi,%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104970 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010497a:	e8 11 f1 ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz)
8010497f:	39 18                	cmp    %ebx,(%eax)
80104981:	76 29                	jbe    801049ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104983:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104986:	89 da                	mov    %ebx,%edx
80104988:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010498a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010498c:	39 c3                	cmp    %eax,%ebx
8010498e:	73 1c                	jae    801049ac <fetchstr+0x3c>
    if(*s == 0)
80104990:	80 3b 00             	cmpb   $0x0,(%ebx)
80104993:	75 10                	jne    801049a5 <fetchstr+0x35>
80104995:	eb 39                	jmp    801049d0 <fetchstr+0x60>
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049a0:	80 3a 00             	cmpb   $0x0,(%edx)
801049a3:	74 1b                	je     801049c0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049a5:	83 c2 01             	add    $0x1,%edx
801049a8:	39 d0                	cmp    %edx,%eax
801049aa:	77 f4                	ja     801049a0 <fetchstr+0x30>
    return -1;
801049ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049b1:	83 c4 04             	add    $0x4,%esp
801049b4:	5b                   	pop    %ebx
801049b5:	5d                   	pop    %ebp
801049b6:	c3                   	ret    
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049c0:	83 c4 04             	add    $0x4,%esp
801049c3:	89 d0                	mov    %edx,%eax
801049c5:	29 d8                	sub    %ebx,%eax
801049c7:	5b                   	pop    %ebx
801049c8:	5d                   	pop    %ebp
801049c9:	c3                   	ret    
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801049d0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801049d2:	eb dd                	jmp    801049b1 <fetchstr+0x41>
801049d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e5:	e8 a6 f0 ff ff       	call   80103a90 <myproc>
801049ea:	8b 40 18             	mov    0x18(%eax),%eax
801049ed:	8b 55 08             	mov    0x8(%ebp),%edx
801049f0:	8b 40 44             	mov    0x44(%eax),%eax
801049f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049f6:	e8 95 f0 ff ff       	call   80103a90 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049fb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049fd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a00:	39 c6                	cmp    %eax,%esi
80104a02:	73 1c                	jae    80104a20 <argint+0x40>
80104a04:	8d 53 08             	lea    0x8(%ebx),%edx
80104a07:	39 d0                	cmp    %edx,%eax
80104a09:	72 15                	jb     80104a20 <argint+0x40>
  *ip = *(int*)(addr);
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a11:	89 10                	mov    %edx,(%eax)
  return 0;
80104a13:	31 c0                	xor    %eax,%eax
}
80104a15:	5b                   	pop    %ebx
80104a16:	5e                   	pop    %esi
80104a17:	5d                   	pop    %ebp
80104a18:	c3                   	ret    
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a25:	eb ee                	jmp    80104a15 <argint+0x35>
80104a27:	89 f6                	mov    %esi,%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	83 ec 10             	sub    $0x10,%esp
80104a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a3b:	e8 50 f0 ff ff       	call   80103a90 <myproc>
80104a40:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a45:	83 ec 08             	sub    $0x8,%esp
80104a48:	50                   	push   %eax
80104a49:	ff 75 08             	pushl  0x8(%ebp)
80104a4c:	e8 8f ff ff ff       	call   801049e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a51:	83 c4 10             	add    $0x10,%esp
80104a54:	85 c0                	test   %eax,%eax
80104a56:	78 28                	js     80104a80 <argptr+0x50>
80104a58:	85 db                	test   %ebx,%ebx
80104a5a:	78 24                	js     80104a80 <argptr+0x50>
80104a5c:	8b 16                	mov    (%esi),%edx
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	39 c2                	cmp    %eax,%edx
80104a63:	76 1b                	jbe    80104a80 <argptr+0x50>
80104a65:	01 c3                	add    %eax,%ebx
80104a67:	39 da                	cmp    %ebx,%edx
80104a69:	72 15                	jb     80104a80 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a6e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a70:	31 c0                	xor    %eax,%eax
}
80104a72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a75:	5b                   	pop    %ebx
80104a76:	5e                   	pop    %esi
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret    
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a85:	eb eb                	jmp    80104a72 <argptr+0x42>
80104a87:	89 f6                	mov    %esi,%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a99:	50                   	push   %eax
80104a9a:	ff 75 08             	pushl  0x8(%ebp)
80104a9d:	e8 3e ff ff ff       	call   801049e0 <argint>
80104aa2:	83 c4 10             	add    $0x10,%esp
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	78 17                	js     80104ac0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104aa9:	83 ec 08             	sub    $0x8,%esp
80104aac:	ff 75 0c             	pushl  0xc(%ebp)
80104aaf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ab2:	e8 b9 fe ff ff       	call   80104970 <fetchstr>
80104ab7:	83 c4 10             	add    $0x10,%esp
}
80104aba:	c9                   	leave  
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ac5:	c9                   	leave  
80104ac6:	c3                   	ret    
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ad7:	e8 b4 ef ff ff       	call   80103a90 <myproc>
80104adc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ade:	8b 40 18             	mov    0x18(%eax),%eax
80104ae1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ae4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ae7:	83 fa 16             	cmp    $0x16,%edx
80104aea:	77 1c                	ja     80104b08 <syscall+0x38>
80104aec:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
80104af3:	85 d2                	test   %edx,%edx
80104af5:	74 11                	je     80104b08 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104af7:	ff d2                	call   *%edx
80104af9:	8b 53 18             	mov    0x18(%ebx),%edx
80104afc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b08:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b09:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b0c:	50                   	push   %eax
80104b0d:	ff 73 10             	pushl  0x10(%ebx)
80104b10:	68 71 7c 10 80       	push   $0x80107c71
80104b15:	e8 46 bc ff ff       	call   80100760 <cprintf>
    curproc->tf->eax = -1;
80104b1a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	56                   	push   %esi
80104b35:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b36:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104b39:	83 ec 44             	sub    $0x44,%esp
80104b3c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b42:	56                   	push   %esi
80104b43:	50                   	push   %eax
{
80104b44:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b47:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b4a:	e8 71 d6 ff ff       	call   801021c0 <nameiparent>
80104b4f:	83 c4 10             	add    $0x10,%esp
80104b52:	85 c0                	test   %eax,%eax
80104b54:	0f 84 46 01 00 00    	je     80104ca0 <create+0x170>
    return 0;
  ilock(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	89 c3                	mov    %eax,%ebx
80104b5f:	50                   	push   %eax
80104b60:	e8 db cd ff ff       	call   80101940 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b65:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b68:	83 c4 0c             	add    $0xc,%esp
80104b6b:	50                   	push   %eax
80104b6c:	56                   	push   %esi
80104b6d:	53                   	push   %ebx
80104b6e:	e8 fd d2 ff ff       	call   80101e70 <dirlookup>
80104b73:	83 c4 10             	add    $0x10,%esp
80104b76:	85 c0                	test   %eax,%eax
80104b78:	89 c7                	mov    %eax,%edi
80104b7a:	74 34                	je     80104bb0 <create+0x80>
    iunlockput(dp);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	53                   	push   %ebx
80104b80:	e8 4b d0 ff ff       	call   80101bd0 <iunlockput>
    ilock(ip);
80104b85:	89 3c 24             	mov    %edi,(%esp)
80104b88:	e8 b3 cd ff ff       	call   80101940 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b95:	0f 85 95 00 00 00    	jne    80104c30 <create+0x100>
80104b9b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104ba0:	0f 85 8a 00 00 00    	jne    80104c30 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba9:	89 f8                	mov    %edi,%eax
80104bab:	5b                   	pop    %ebx
80104bac:	5e                   	pop    %esi
80104bad:	5f                   	pop    %edi
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	pushl  (%ebx)
80104bba:	e8 11 cc ff ff       	call   801017d0 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	85 c0                	test   %eax,%eax
80104bc4:	89 c7                	mov    %eax,%edi
80104bc6:	0f 84 e8 00 00 00    	je     80104cb4 <create+0x184>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 6b cd ff ff       	call   80101940 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104bd9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104bdd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104be1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104bee:	89 3c 24             	mov    %edi,(%esp)
80104bf1:	e8 9a cc ff ff       	call   80101890 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bfe:	74 50                	je     80104c50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 77 04             	pushl  0x4(%edi)
80104c06:	56                   	push   %esi
80104c07:	53                   	push   %ebx
80104c08:	e8 d3 d4 ff ff       	call   801020e0 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	0f 88 8f 00 00 00    	js     80104ca7 <create+0x177>
  iunlockput(dp);
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	53                   	push   %ebx
80104c1c:	e8 af cf ff ff       	call   80101bd0 <iunlockput>
  return ip;
80104c21:	83 c4 10             	add    $0x10,%esp
}
80104c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c27:	89 f8                	mov    %edi,%eax
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5f                   	pop    %edi
80104c2c:	5d                   	pop    %ebp
80104c2d:	c3                   	ret    
80104c2e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104c30:	83 ec 0c             	sub    $0xc,%esp
80104c33:	57                   	push   %edi
    return 0;
80104c34:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c36:	e8 95 cf ff ff       	call   80101bd0 <iunlockput>
    return 0;
80104c3b:	83 c4 10             	add    $0x10,%esp
}
80104c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c41:	89 f8                	mov    %edi,%eax
80104c43:	5b                   	pop    %ebx
80104c44:	5e                   	pop    %esi
80104c45:	5f                   	pop    %edi
80104c46:	5d                   	pop    %ebp
80104c47:	c3                   	ret    
80104c48:	90                   	nop
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c50:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c55:	83 ec 0c             	sub    $0xc,%esp
80104c58:	53                   	push   %ebx
80104c59:	e8 32 cc ff ff       	call   80101890 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c5e:	83 c4 0c             	add    $0xc,%esp
80104c61:	ff 77 04             	pushl  0x4(%edi)
80104c64:	68 1c 7d 10 80       	push   $0x80107d1c
80104c69:	57                   	push   %edi
80104c6a:	e8 71 d4 ff ff       	call   801020e0 <dirlink>
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	85 c0                	test   %eax,%eax
80104c74:	78 1c                	js     80104c92 <create+0x162>
80104c76:	83 ec 04             	sub    $0x4,%esp
80104c79:	ff 73 04             	pushl  0x4(%ebx)
80104c7c:	68 1b 7d 10 80       	push   $0x80107d1b
80104c81:	57                   	push   %edi
80104c82:	e8 59 d4 ff ff       	call   801020e0 <dirlink>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	0f 89 6e ff ff ff    	jns    80104c00 <create+0xd0>
      panic("create dots");
80104c92:	83 ec 0c             	sub    $0xc,%esp
80104c95:	68 0f 7d 10 80       	push   $0x80107d0f
80104c9a:	e8 f1 b7 ff ff       	call   80100490 <panic>
80104c9f:	90                   	nop
    return 0;
80104ca0:	31 ff                	xor    %edi,%edi
80104ca2:	e9 ff fe ff ff       	jmp    80104ba6 <create+0x76>
    panic("create: dirlink");
80104ca7:	83 ec 0c             	sub    $0xc,%esp
80104caa:	68 1e 7d 10 80       	push   $0x80107d1e
80104caf:	e8 dc b7 ff ff       	call   80100490 <panic>
    panic("create: ialloc");
80104cb4:	83 ec 0c             	sub    $0xc,%esp
80104cb7:	68 00 7d 10 80       	push   $0x80107d00
80104cbc:	e8 cf b7 ff ff       	call   80100490 <panic>
80104cc1:	eb 0d                	jmp    80104cd0 <argfd.constprop.0>
80104cc3:	90                   	nop
80104cc4:	90                   	nop
80104cc5:	90                   	nop
80104cc6:	90                   	nop
80104cc7:	90                   	nop
80104cc8:	90                   	nop
80104cc9:	90                   	nop
80104cca:	90                   	nop
80104ccb:	90                   	nop
80104ccc:	90                   	nop
80104ccd:	90                   	nop
80104cce:	90                   	nop
80104ccf:	90                   	nop

80104cd0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cda:	89 d6                	mov    %edx,%esi
80104cdc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cdf:	50                   	push   %eax
80104ce0:	6a 00                	push   $0x0
80104ce2:	e8 f9 fc ff ff       	call   801049e0 <argint>
80104ce7:	83 c4 10             	add    $0x10,%esp
80104cea:	85 c0                	test   %eax,%eax
80104cec:	78 2a                	js     80104d18 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cf2:	77 24                	ja     80104d18 <argfd.constprop.0+0x48>
80104cf4:	e8 97 ed ff ff       	call   80103a90 <myproc>
80104cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cfc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d00:	85 c0                	test   %eax,%eax
80104d02:	74 14                	je     80104d18 <argfd.constprop.0+0x48>
  if(pfd)
80104d04:	85 db                	test   %ebx,%ebx
80104d06:	74 02                	je     80104d0a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d08:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d0a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d0c:	31 c0                	xor    %eax,%eax
}
80104d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d11:	5b                   	pop    %ebx
80104d12:	5e                   	pop    %esi
80104d13:	5d                   	pop    %ebp
80104d14:	c3                   	ret    
80104d15:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d1d:	eb ef                	jmp    80104d0e <argfd.constprop.0+0x3e>
80104d1f:	90                   	nop

80104d20 <sys_dup>:
{
80104d20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d21:	31 c0                	xor    %eax,%eax
{
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	56                   	push   %esi
80104d26:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d27:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d2a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d2d:	e8 9e ff ff ff       	call   80104cd0 <argfd.constprop.0>
80104d32:	85 c0                	test   %eax,%eax
80104d34:	78 42                	js     80104d78 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104d36:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d39:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d3b:	e8 50 ed ff ff       	call   80103a90 <myproc>
80104d40:	eb 0e                	jmp    80104d50 <sys_dup+0x30>
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d48:	83 c3 01             	add    $0x1,%ebx
80104d4b:	83 fb 10             	cmp    $0x10,%ebx
80104d4e:	74 28                	je     80104d78 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d54:	85 d2                	test   %edx,%edx
80104d56:	75 f0                	jne    80104d48 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d58:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d62:	e8 89 c1 ff ff       	call   80100ef0 <filedup>
  return fd;
80104d67:	83 c4 10             	add    $0x10,%esp
}
80104d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d6d:	89 d8                	mov    %ebx,%eax
80104d6f:	5b                   	pop    %ebx
80104d70:	5e                   	pop    %esi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	90                   	nop
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d80:	89 d8                	mov    %ebx,%eax
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d 76 00             	lea    0x0(%esi),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <sys_read>:
{
80104d90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d91:	31 c0                	xor    %eax,%eax
{
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d9b:	e8 30 ff ff ff       	call   80104cd0 <argfd.constprop.0>
80104da0:	85 c0                	test   %eax,%eax
80104da2:	78 4c                	js     80104df0 <sys_read+0x60>
80104da4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104da7:	83 ec 08             	sub    $0x8,%esp
80104daa:	50                   	push   %eax
80104dab:	6a 02                	push   $0x2
80104dad:	e8 2e fc ff ff       	call   801049e0 <argint>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	85 c0                	test   %eax,%eax
80104db7:	78 37                	js     80104df0 <sys_read+0x60>
80104db9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dbc:	83 ec 04             	sub    $0x4,%esp
80104dbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104dc2:	50                   	push   %eax
80104dc3:	6a 01                	push   $0x1
80104dc5:	e8 66 fc ff ff       	call   80104a30 <argptr>
80104dca:	83 c4 10             	add    $0x10,%esp
80104dcd:	85 c0                	test   %eax,%eax
80104dcf:	78 1f                	js     80104df0 <sys_read+0x60>
  return fileread(f, p, n);
80104dd1:	83 ec 04             	sub    $0x4,%esp
80104dd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dda:	ff 75 ec             	pushl  -0x14(%ebp)
80104ddd:	e8 7e c2 ff ff       	call   80101060 <fileread>
80104de2:	83 c4 10             	add    $0x10,%esp
}
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_write>:
{
80104e00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e01:	31 c0                	xor    %eax,%eax
{
80104e03:	89 e5                	mov    %esp,%ebp
80104e05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e0b:	e8 c0 fe ff ff       	call   80104cd0 <argfd.constprop.0>
80104e10:	85 c0                	test   %eax,%eax
80104e12:	78 4c                	js     80104e60 <sys_write+0x60>
80104e14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e17:	83 ec 08             	sub    $0x8,%esp
80104e1a:	50                   	push   %eax
80104e1b:	6a 02                	push   $0x2
80104e1d:	e8 be fb ff ff       	call   801049e0 <argint>
80104e22:	83 c4 10             	add    $0x10,%esp
80104e25:	85 c0                	test   %eax,%eax
80104e27:	78 37                	js     80104e60 <sys_write+0x60>
80104e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e2c:	83 ec 04             	sub    $0x4,%esp
80104e2f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e32:	50                   	push   %eax
80104e33:	6a 01                	push   $0x1
80104e35:	e8 f6 fb ff ff       	call   80104a30 <argptr>
80104e3a:	83 c4 10             	add    $0x10,%esp
80104e3d:	85 c0                	test   %eax,%eax
80104e3f:	78 1f                	js     80104e60 <sys_write+0x60>
  return filewrite(f, p, n);
80104e41:	83 ec 04             	sub    $0x4,%esp
80104e44:	ff 75 f0             	pushl  -0x10(%ebp)
80104e47:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e4d:	e8 9e c2 ff ff       	call   801010f0 <filewrite>
80104e52:	83 c4 10             	add    $0x10,%esp
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_close>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e76:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e7c:	e8 4f fe ff ff       	call   80104cd0 <argfd.constprop.0>
80104e81:	85 c0                	test   %eax,%eax
80104e83:	78 2b                	js     80104eb0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e85:	e8 06 ec ff ff       	call   80103a90 <myproc>
80104e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e8d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e90:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e97:	00 
  fileclose(f);
80104e98:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9b:	e8 a0 c0 ff ff       	call   80100f40 <fileclose>
  return 0;
80104ea0:	83 c4 10             	add    $0x10,%esp
80104ea3:	31 c0                	xor    %eax,%eax
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_fstat>:
{
80104ec0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ec8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ecb:	e8 00 fe ff ff       	call   80104cd0 <argfd.constprop.0>
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 2c                	js     80104f00 <sys_fstat+0x40>
80104ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed7:	83 ec 04             	sub    $0x4,%esp
80104eda:	6a 14                	push   $0x14
80104edc:	50                   	push   %eax
80104edd:	6a 01                	push   $0x1
80104edf:	e8 4c fb ff ff       	call   80104a30 <argptr>
80104ee4:	83 c4 10             	add    $0x10,%esp
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	78 15                	js     80104f00 <sys_fstat+0x40>
  return filestat(f, st);
80104eeb:	83 ec 08             	sub    $0x8,%esp
80104eee:	ff 75 f4             	pushl  -0xc(%ebp)
80104ef1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ef4:	e8 17 c1 ff ff       	call   80101010 <filestat>
80104ef9:	83 c4 10             	add    $0x10,%esp
}
80104efc:	c9                   	leave  
80104efd:	c3                   	ret    
80104efe:	66 90                	xchg   %ax,%ax
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_link>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f16:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f19:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f1c:	50                   	push   %eax
80104f1d:	6a 00                	push   $0x0
80104f1f:	e8 6c fb ff ff       	call   80104a90 <argstr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 fb 00 00 00    	js     8010502a <sys_link+0x11a>
80104f2f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f32:	83 ec 08             	sub    $0x8,%esp
80104f35:	50                   	push   %eax
80104f36:	6a 01                	push   $0x1
80104f38:	e8 53 fb ff ff       	call   80104a90 <argstr>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	0f 88 e2 00 00 00    	js     8010502a <sys_link+0x11a>
  begin_op();
80104f48:	e8 03 df ff ff       	call   80102e50 <begin_op>
  if((ip = namei(old)) == 0){
80104f4d:	83 ec 0c             	sub    $0xc,%esp
80104f50:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f53:	e8 48 d2 ff ff       	call   801021a0 <namei>
80104f58:	83 c4 10             	add    $0x10,%esp
80104f5b:	85 c0                	test   %eax,%eax
80104f5d:	89 c3                	mov    %eax,%ebx
80104f5f:	0f 84 ea 00 00 00    	je     8010504f <sys_link+0x13f>
  ilock(ip);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	50                   	push   %eax
80104f69:	e8 d2 c9 ff ff       	call   80101940 <ilock>
  if(ip->type == T_DIR){
80104f6e:	83 c4 10             	add    $0x10,%esp
80104f71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f76:	0f 84 bb 00 00 00    	je     80105037 <sys_link+0x127>
  ip->nlink++;
80104f7c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f81:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104f84:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f87:	53                   	push   %ebx
80104f88:	e8 03 c9 ff ff       	call   80101890 <iupdate>
  iunlock(ip);
80104f8d:	89 1c 24             	mov    %ebx,(%esp)
80104f90:	e8 8b ca ff ff       	call   80101a20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f95:	58                   	pop    %eax
80104f96:	5a                   	pop    %edx
80104f97:	57                   	push   %edi
80104f98:	ff 75 d0             	pushl  -0x30(%ebp)
80104f9b:	e8 20 d2 ff ff       	call   801021c0 <nameiparent>
80104fa0:	83 c4 10             	add    $0x10,%esp
80104fa3:	85 c0                	test   %eax,%eax
80104fa5:	89 c6                	mov    %eax,%esi
80104fa7:	74 5b                	je     80105004 <sys_link+0xf4>
  ilock(dp);
80104fa9:	83 ec 0c             	sub    $0xc,%esp
80104fac:	50                   	push   %eax
80104fad:	e8 8e c9 ff ff       	call   80101940 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	8b 03                	mov    (%ebx),%eax
80104fb7:	39 06                	cmp    %eax,(%esi)
80104fb9:	75 3d                	jne    80104ff8 <sys_link+0xe8>
80104fbb:	83 ec 04             	sub    $0x4,%esp
80104fbe:	ff 73 04             	pushl  0x4(%ebx)
80104fc1:	57                   	push   %edi
80104fc2:	56                   	push   %esi
80104fc3:	e8 18 d1 ff ff       	call   801020e0 <dirlink>
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	78 29                	js     80104ff8 <sys_link+0xe8>
  iunlockput(dp);
80104fcf:	83 ec 0c             	sub    $0xc,%esp
80104fd2:	56                   	push   %esi
80104fd3:	e8 f8 cb ff ff       	call   80101bd0 <iunlockput>
  iput(ip);
80104fd8:	89 1c 24             	mov    %ebx,(%esp)
80104fdb:	e8 90 ca ff ff       	call   80101a70 <iput>
  end_op();
80104fe0:	e8 db de ff ff       	call   80102ec0 <end_op>
  return 0;
80104fe5:	83 c4 10             	add    $0x10,%esp
80104fe8:	31 c0                	xor    %eax,%eax
}
80104fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fed:	5b                   	pop    %ebx
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret    
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	56                   	push   %esi
80104ffc:	e8 cf cb ff ff       	call   80101bd0 <iunlockput>
    goto bad;
80105001:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	53                   	push   %ebx
80105008:	e8 33 c9 ff ff       	call   80101940 <ilock>
  ip->nlink--;
8010500d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105012:	89 1c 24             	mov    %ebx,(%esp)
80105015:	e8 76 c8 ff ff       	call   80101890 <iupdate>
  iunlockput(ip);
8010501a:	89 1c 24             	mov    %ebx,(%esp)
8010501d:	e8 ae cb ff ff       	call   80101bd0 <iunlockput>
  end_op();
80105022:	e8 99 de ff ff       	call   80102ec0 <end_op>
  return -1;
80105027:	83 c4 10             	add    $0x10,%esp
}
8010502a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010502d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105032:	5b                   	pop    %ebx
80105033:	5e                   	pop    %esi
80105034:	5f                   	pop    %edi
80105035:	5d                   	pop    %ebp
80105036:	c3                   	ret    
    iunlockput(ip);
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	53                   	push   %ebx
8010503b:	e8 90 cb ff ff       	call   80101bd0 <iunlockput>
    end_op();
80105040:	e8 7b de ff ff       	call   80102ec0 <end_op>
    return -1;
80105045:	83 c4 10             	add    $0x10,%esp
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb 9b                	jmp    80104fea <sys_link+0xda>
    end_op();
8010504f:	e8 6c de ff ff       	call   80102ec0 <end_op>
    return -1;
80105054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105059:	eb 8f                	jmp    80104fea <sys_link+0xda>
8010505b:	90                   	nop
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <sys_unlink>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105066:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105069:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 1c fa ff ff       	call   80104a90 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 77 01 00 00    	js     801051f6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010507f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105082:	e8 c9 dd ff ff       	call   80102e50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105087:	83 ec 08             	sub    $0x8,%esp
8010508a:	53                   	push   %ebx
8010508b:	ff 75 c0             	pushl  -0x40(%ebp)
8010508e:	e8 2d d1 ff ff       	call   801021c0 <nameiparent>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	89 c6                	mov    %eax,%esi
8010509a:	0f 84 60 01 00 00    	je     80105200 <sys_unlink+0x1a0>
  ilock(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	50                   	push   %eax
801050a4:	e8 97 c8 ff ff       	call   80101940 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050a9:	58                   	pop    %eax
801050aa:	5a                   	pop    %edx
801050ab:	68 1c 7d 10 80       	push   $0x80107d1c
801050b0:	53                   	push   %ebx
801050b1:	e8 9a cd ff ff       	call   80101e50 <namecmp>
801050b6:	83 c4 10             	add    $0x10,%esp
801050b9:	85 c0                	test   %eax,%eax
801050bb:	0f 84 03 01 00 00    	je     801051c4 <sys_unlink+0x164>
801050c1:	83 ec 08             	sub    $0x8,%esp
801050c4:	68 1b 7d 10 80       	push   $0x80107d1b
801050c9:	53                   	push   %ebx
801050ca:	e8 81 cd ff ff       	call   80101e50 <namecmp>
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	85 c0                	test   %eax,%eax
801050d4:	0f 84 ea 00 00 00    	je     801051c4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050dd:	83 ec 04             	sub    $0x4,%esp
801050e0:	50                   	push   %eax
801050e1:	53                   	push   %ebx
801050e2:	56                   	push   %esi
801050e3:	e8 88 cd ff ff       	call   80101e70 <dirlookup>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c3                	mov    %eax,%ebx
801050ef:	0f 84 cf 00 00 00    	je     801051c4 <sys_unlink+0x164>
  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 42 c8 ff ff       	call   80101940 <ilock>
  if(ip->nlink < 1)
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105106:	0f 8e 10 01 00 00    	jle    8010521c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010510c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105111:	74 6d                	je     80105180 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105113:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105116:	83 ec 04             	sub    $0x4,%esp
80105119:	6a 10                	push   $0x10
8010511b:	6a 00                	push   $0x0
8010511d:	50                   	push   %eax
8010511e:	e8 bd f5 ff ff       	call   801046e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105123:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105126:	6a 10                	push   $0x10
80105128:	ff 75 c4             	pushl  -0x3c(%ebp)
8010512b:	50                   	push   %eax
8010512c:	56                   	push   %esi
8010512d:	e8 ee cb ff ff       	call   80101d20 <writei>
80105132:	83 c4 20             	add    $0x20,%esp
80105135:	83 f8 10             	cmp    $0x10,%eax
80105138:	0f 85 eb 00 00 00    	jne    80105229 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010513e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105143:	0f 84 97 00 00 00    	je     801051e0 <sys_unlink+0x180>
  iunlockput(dp);
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	56                   	push   %esi
8010514d:	e8 7e ca ff ff       	call   80101bd0 <iunlockput>
  ip->nlink--;
80105152:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105157:	89 1c 24             	mov    %ebx,(%esp)
8010515a:	e8 31 c7 ff ff       	call   80101890 <iupdate>
  iunlockput(ip);
8010515f:	89 1c 24             	mov    %ebx,(%esp)
80105162:	e8 69 ca ff ff       	call   80101bd0 <iunlockput>
  end_op();
80105167:	e8 54 dd ff ff       	call   80102ec0 <end_op>
  return 0;
8010516c:	83 c4 10             	add    $0x10,%esp
8010516f:	31 c0                	xor    %eax,%eax
}
80105171:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105174:	5b                   	pop    %ebx
80105175:	5e                   	pop    %esi
80105176:	5f                   	pop    %edi
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret    
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105180:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105184:	76 8d                	jbe    80105113 <sys_unlink+0xb3>
80105186:	bf 20 00 00 00       	mov    $0x20,%edi
8010518b:	eb 0f                	jmp    8010519c <sys_unlink+0x13c>
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
80105190:	83 c7 10             	add    $0x10,%edi
80105193:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105196:	0f 83 77 ff ff ff    	jae    80105113 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010519c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010519f:	6a 10                	push   $0x10
801051a1:	57                   	push   %edi
801051a2:	50                   	push   %eax
801051a3:	53                   	push   %ebx
801051a4:	e8 77 ca ff ff       	call   80101c20 <readi>
801051a9:	83 c4 10             	add    $0x10,%esp
801051ac:	83 f8 10             	cmp    $0x10,%eax
801051af:	75 5e                	jne    8010520f <sys_unlink+0x1af>
    if(de.inum != 0)
801051b1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051b6:	74 d8                	je     80105190 <sys_unlink+0x130>
    iunlockput(ip);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	53                   	push   %ebx
801051bc:	e8 0f ca ff ff       	call   80101bd0 <iunlockput>
    goto bad;
801051c1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	56                   	push   %esi
801051c8:	e8 03 ca ff ff       	call   80101bd0 <iunlockput>
  end_op();
801051cd:	e8 ee dc ff ff       	call   80102ec0 <end_op>
  return -1;
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051da:	eb 95                	jmp    80105171 <sys_unlink+0x111>
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801051e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051e5:	83 ec 0c             	sub    $0xc,%esp
801051e8:	56                   	push   %esi
801051e9:	e8 a2 c6 ff ff       	call   80101890 <iupdate>
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	e9 53 ff ff ff       	jmp    80105149 <sys_unlink+0xe9>
    return -1;
801051f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fb:	e9 71 ff ff ff       	jmp    80105171 <sys_unlink+0x111>
    end_op();
80105200:	e8 bb dc ff ff       	call   80102ec0 <end_op>
    return -1;
80105205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520a:	e9 62 ff ff ff       	jmp    80105171 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	68 40 7d 10 80       	push   $0x80107d40
80105217:	e8 74 b2 ff ff       	call   80100490 <panic>
    panic("unlink: nlink < 1");
8010521c:	83 ec 0c             	sub    $0xc,%esp
8010521f:	68 2e 7d 10 80       	push   $0x80107d2e
80105224:	e8 67 b2 ff ff       	call   80100490 <panic>
    panic("unlink: writei");
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	68 52 7d 10 80       	push   $0x80107d52
80105231:	e8 5a b2 ff ff       	call   80100490 <panic>
80105236:	8d 76 00             	lea    0x0(%esi),%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_open>:

int
sys_open(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
80105245:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105246:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105249:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 3c f8 ff ff       	call   80104a90 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 1d 01 00 00    	js     8010537c <sys_open+0x13c>
8010525f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105262:	83 ec 08             	sub    $0x8,%esp
80105265:	50                   	push   %eax
80105266:	6a 01                	push   $0x1
80105268:	e8 73 f7 ff ff       	call   801049e0 <argint>
8010526d:	83 c4 10             	add    $0x10,%esp
80105270:	85 c0                	test   %eax,%eax
80105272:	0f 88 04 01 00 00    	js     8010537c <sys_open+0x13c>
    return -1;

  begin_op();
80105278:	e8 d3 db ff ff       	call   80102e50 <begin_op>

  if(omode & O_CREATE){
8010527d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105281:	0f 85 a9 00 00 00    	jne    80105330 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	ff 75 e0             	pushl  -0x20(%ebp)
8010528d:	e8 0e cf ff ff       	call   801021a0 <namei>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	89 c6                	mov    %eax,%esi
80105299:	0f 84 b2 00 00 00    	je     80105351 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	50                   	push   %eax
801052a3:	e8 98 c6 ff ff       	call   80101940 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052b0:	0f 84 aa 00 00 00    	je     80105360 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052b6:	e8 c5 bb ff ff       	call   80100e80 <filealloc>
801052bb:	85 c0                	test   %eax,%eax
801052bd:	89 c7                	mov    %eax,%edi
801052bf:	0f 84 a6 00 00 00    	je     8010536b <sys_open+0x12b>
  struct proc *curproc = myproc();
801052c5:	e8 c6 e7 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ca:	31 db                	xor    %ebx,%ebx
801052cc:	eb 0e                	jmp    801052dc <sys_open+0x9c>
801052ce:	66 90                	xchg   %ax,%ax
801052d0:	83 c3 01             	add    $0x1,%ebx
801052d3:	83 fb 10             	cmp    $0x10,%ebx
801052d6:	0f 84 ac 00 00 00    	je     80105388 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801052dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052e0:	85 d2                	test   %edx,%edx
801052e2:	75 ec                	jne    801052d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052eb:	56                   	push   %esi
801052ec:	e8 2f c7 ff ff       	call   80101a20 <iunlock>
  end_op();
801052f1:	e8 ca db ff ff       	call   80102ec0 <end_op>

  f->type = FD_INODE;
801052f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105302:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105305:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010530c:	89 d0                	mov    %edx,%eax
8010530e:	f7 d0                	not    %eax
80105310:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105313:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105316:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105319:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010531d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105320:	89 d8                	mov    %ebx,%eax
80105322:	5b                   	pop    %ebx
80105323:	5e                   	pop    %esi
80105324:	5f                   	pop    %edi
80105325:	5d                   	pop    %ebp
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105336:	31 c9                	xor    %ecx,%ecx
80105338:	6a 00                	push   $0x0
8010533a:	ba 02 00 00 00       	mov    $0x2,%edx
8010533f:	e8 ec f7 ff ff       	call   80104b30 <create>
    if(ip == 0){
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105349:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010534b:	0f 85 65 ff ff ff    	jne    801052b6 <sys_open+0x76>
      end_op();
80105351:	e8 6a db ff ff       	call   80102ec0 <end_op>
      return -1;
80105356:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010535b:	eb c0                	jmp    8010531d <sys_open+0xdd>
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105363:	85 c9                	test   %ecx,%ecx
80105365:	0f 84 4b ff ff ff    	je     801052b6 <sys_open+0x76>
    iunlockput(ip);
8010536b:	83 ec 0c             	sub    $0xc,%esp
8010536e:	56                   	push   %esi
8010536f:	e8 5c c8 ff ff       	call   80101bd0 <iunlockput>
    end_op();
80105374:	e8 47 db ff ff       	call   80102ec0 <end_op>
    return -1;
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105381:	eb 9a                	jmp    8010531d <sys_open+0xdd>
80105383:	90                   	nop
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	57                   	push   %edi
8010538c:	e8 af bb ff ff       	call   80100f40 <fileclose>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	eb d5                	jmp    8010536b <sys_open+0x12b>
80105396:	8d 76 00             	lea    0x0(%esi),%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053a6:	e8 a5 da ff ff       	call   80102e50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ae:	83 ec 08             	sub    $0x8,%esp
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 d7 f6 ff ff       	call   80104a90 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 30                	js     801053f0 <sys_mkdir+0x50>
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	31 c9                	xor    %ecx,%ecx
801053c8:	6a 00                	push   $0x0
801053ca:	ba 01 00 00 00       	mov    $0x1,%edx
801053cf:	e8 5c f7 ff ff       	call   80104b30 <create>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	74 15                	je     801053f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	50                   	push   %eax
801053df:	e8 ec c7 ff ff       	call   80101bd0 <iunlockput>
  end_op();
801053e4:	e8 d7 da ff ff       	call   80102ec0 <end_op>
  return 0;
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	31 c0                	xor    %eax,%eax
}
801053ee:	c9                   	leave  
801053ef:	c3                   	ret    
    end_op();
801053f0:	e8 cb da ff ff       	call   80102ec0 <end_op>
    return -1;
801053f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_mknod>:

int
sys_mknod(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105406:	e8 45 da ff ff       	call   80102e50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010540b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010540e:	83 ec 08             	sub    $0x8,%esp
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 77 f6 ff ff       	call   80104a90 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 60                	js     80105480 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105420:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105423:	83 ec 08             	sub    $0x8,%esp
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 b2 f5 ff ff       	call   801049e0 <argint>
  if((argstr(0, &path)) < 0 ||
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 4b                	js     80105480 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105435:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105438:	83 ec 08             	sub    $0x8,%esp
8010543b:	50                   	push   %eax
8010543c:	6a 02                	push   $0x2
8010543e:	e8 9d f5 ff ff       	call   801049e0 <argint>
     argint(1, &major) < 0 ||
80105443:	83 c4 10             	add    $0x10,%esp
80105446:	85 c0                	test   %eax,%eax
80105448:	78 36                	js     80105480 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010544a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010544e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105451:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105455:	ba 03 00 00 00       	mov    $0x3,%edx
8010545a:	50                   	push   %eax
8010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010545e:	e8 cd f6 ff ff       	call   80104b30 <create>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	74 16                	je     80105480 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	50                   	push   %eax
8010546e:	e8 5d c7 ff ff       	call   80101bd0 <iunlockput>
  end_op();
80105473:	e8 48 da ff ff       	call   80102ec0 <end_op>
  return 0;
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	31 c0                	xor    %eax,%eax
}
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop
    end_op();
80105480:	e8 3b da ff ff       	call   80102ec0 <end_op>
    return -1;
80105485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_chdir>:

int
sys_chdir(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105498:	e8 f3 e5 ff ff       	call   80103a90 <myproc>
8010549d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010549f:	e8 ac d9 ff ff       	call   80102e50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a7:	83 ec 08             	sub    $0x8,%esp
801054aa:	50                   	push   %eax
801054ab:	6a 00                	push   $0x0
801054ad:	e8 de f5 ff ff       	call   80104a90 <argstr>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 77                	js     80105530 <sys_chdir+0xa0>
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	ff 75 f4             	pushl  -0xc(%ebp)
801054bf:	e8 dc cc ff ff       	call   801021a0 <namei>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	89 c3                	mov    %eax,%ebx
801054cb:	74 63                	je     80105530 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	50                   	push   %eax
801054d1:	e8 6a c4 ff ff       	call   80101940 <ilock>
  if(ip->type != T_DIR){
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054de:	75 30                	jne    80105510 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 37 c5 ff ff       	call   80101a20 <iunlock>
  iput(curproc->cwd);
801054e9:	58                   	pop    %eax
801054ea:	ff 76 68             	pushl  0x68(%esi)
801054ed:	e8 7e c5 ff ff       	call   80101a70 <iput>
  end_op();
801054f2:	e8 c9 d9 ff ff       	call   80102ec0 <end_op>
  curproc->cwd = ip;
801054f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	31 c0                	xor    %eax,%eax
}
801054ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105502:	5b                   	pop    %ebx
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d 76 00             	lea    0x0(%esi),%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	53                   	push   %ebx
80105514:	e8 b7 c6 ff ff       	call   80101bd0 <iunlockput>
    end_op();
80105519:	e8 a2 d9 ff ff       	call   80102ec0 <end_op>
    return -1;
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105526:	eb d7                	jmp    801054ff <sys_chdir+0x6f>
80105528:	90                   	nop
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105530:	e8 8b d9 ff ff       	call   80102ec0 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553a:	eb c3                	jmp    801054ff <sys_chdir+0x6f>
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_exec>:

int
sys_exec(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105546:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010554c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105552:	50                   	push   %eax
80105553:	6a 00                	push   $0x0
80105555:	e8 36 f5 ff ff       	call   80104a90 <argstr>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 88 87 00 00 00    	js     801055ec <sys_exec+0xac>
80105565:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	50                   	push   %eax
8010556f:	6a 01                	push   $0x1
80105571:	e8 6a f4 ff ff       	call   801049e0 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 6f                	js     801055ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010557d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105583:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105586:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105588:	68 80 00 00 00       	push   $0x80
8010558d:	6a 00                	push   $0x0
8010558f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105595:	50                   	push   %eax
80105596:	e8 45 f1 ff ff       	call   801046e0 <memset>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	eb 2c                	jmp    801055cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801055a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055a6:	85 c0                	test   %eax,%eax
801055a8:	74 56                	je     80105600 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055b6:	52                   	push   %edx
801055b7:	50                   	push   %eax
801055b8:	e8 b3 f3 ff ff       	call   80104970 <fetchstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 28                	js     801055ec <sys_exec+0xac>
  for(i=0;; i++){
801055c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055c7:	83 fb 20             	cmp    $0x20,%ebx
801055ca:	74 20                	je     801055ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055d9:	83 ec 08             	sub    $0x8,%esp
801055dc:	57                   	push   %edi
801055dd:	01 f0                	add    %esi,%eax
801055df:	50                   	push   %eax
801055e0:	e8 4b f3 ff ff       	call   80104930 <fetchint>
801055e5:	83 c4 10             	add    $0x10,%esp
801055e8:	85 c0                	test   %eax,%eax
801055ea:	79 b4                	jns    801055a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105600:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105606:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105609:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105610:	00 00 00 00 
  return exec(path, argv);
80105614:	50                   	push   %eax
80105615:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010561b:	e8 f0 b4 ff ff       	call   80100b10 <exec>
80105620:	83 c4 10             	add    $0x10,%esp
}
80105623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105626:	5b                   	pop    %ebx
80105627:	5e                   	pop    %esi
80105628:	5f                   	pop    %edi
80105629:	5d                   	pop    %ebp
8010562a:	c3                   	ret    
8010562b:	90                   	nop
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_pipe>:

int
sys_pipe(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105636:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105639:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010563c:	6a 08                	push   $0x8
8010563e:	50                   	push   %eax
8010563f:	6a 00                	push   $0x0
80105641:	e8 ea f3 ff ff       	call   80104a30 <argptr>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	0f 88 ae 00 00 00    	js     801056ff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105651:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105654:	83 ec 08             	sub    $0x8,%esp
80105657:	50                   	push   %eax
80105658:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010565b:	50                   	push   %eax
8010565c:	e8 8f de ff ff       	call   801034f0 <pipealloc>
80105661:	83 c4 10             	add    $0x10,%esp
80105664:	85 c0                	test   %eax,%eax
80105666:	0f 88 93 00 00 00    	js     801056ff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010566c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010566f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105671:	e8 1a e4 ff ff       	call   80103a90 <myproc>
80105676:	eb 10                	jmp    80105688 <sys_pipe+0x58>
80105678:	90                   	nop
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105680:	83 c3 01             	add    $0x1,%ebx
80105683:	83 fb 10             	cmp    $0x10,%ebx
80105686:	74 60                	je     801056e8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105688:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010568c:	85 f6                	test   %esi,%esi
8010568e:	75 f0                	jne    80105680 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105690:	8d 73 08             	lea    0x8(%ebx),%esi
80105693:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105697:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010569a:	e8 f1 e3 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010569f:	31 d2                	xor    %edx,%edx
801056a1:	eb 0d                	jmp    801056b0 <sys_pipe+0x80>
801056a3:	90                   	nop
801056a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056a8:	83 c2 01             	add    $0x1,%edx
801056ab:	83 fa 10             	cmp    $0x10,%edx
801056ae:	74 28                	je     801056d8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801056b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056b4:	85 c9                	test   %ecx,%ecx
801056b6:	75 f0                	jne    801056a8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801056b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056c7:	31 c0                	xor    %eax,%eax
}
801056c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056cc:	5b                   	pop    %ebx
801056cd:	5e                   	pop    %esi
801056ce:	5f                   	pop    %edi
801056cf:	5d                   	pop    %ebp
801056d0:	c3                   	ret    
801056d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801056d8:	e8 b3 e3 ff ff       	call   80103a90 <myproc>
801056dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056e4:	00 
801056e5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801056e8:	83 ec 0c             	sub    $0xc,%esp
801056eb:	ff 75 e0             	pushl  -0x20(%ebp)
801056ee:	e8 4d b8 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
801056f3:	58                   	pop    %eax
801056f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801056f7:	e8 44 b8 ff ff       	call   80100f40 <fileclose>
    return -1;
801056fc:	83 c4 10             	add    $0x10,%esp
801056ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105704:	eb c3                	jmp    801056c9 <sys_pipe+0x99>
80105706:	8d 76 00             	lea    0x0(%esi),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_bstat>:

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
80105710:	55                   	push   %ebp
	return numallocblocks;
}
80105711:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
{
80105716:	89 e5                	mov    %esp,%ebp
}
80105718:	5d                   	pop    %ebp
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int*)&addr) < 0)
80105726:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105729:	50                   	push   %eax
8010572a:	6a 00                	push   $0x0
8010572c:	e8 af f2 ff ff       	call   801049e0 <argint>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	85 c0                	test   %eax,%eax
80105736:	78 28                	js     80105760 <sys_swap+0x40>
    return -1;
  // swap addr
  pde_t * pgdir = myproc()->pgdir;
80105738:	e8 53 e3 ff ff       	call   80103a90 <myproc>
  pte_t * pte = uva2pte(pgdir, addr);
8010573d:	83 ec 08             	sub    $0x8,%esp
80105740:	ff 75 f4             	pushl  -0xc(%ebp)
80105743:	ff 70 04             	pushl  0x4(%eax)
80105746:	e8 55 1a 00 00       	call   801071a0 <uva2pte>
  swap_page_from_pte(pte);
8010574b:	89 04 24             	mov    %eax,(%esp)
8010574e:	e8 0d 05 00 00       	call   80105c60 <swap_page_from_pte>
  // we have not done any serious checks on user-pointer addr.
  return 0;
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	31 c0                	xor    %eax,%eax
}
80105758:	c9                   	leave  
80105759:	c3                   	ret    
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	66 90                	xchg   %ax,%ax
80105769:	66 90                	xchg   %ax,%ax
8010576b:	66 90                	xchg   %ax,%ax
8010576d:	66 90                	xchg   %ax,%ax
8010576f:	90                   	nop

80105770 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105773:	5d                   	pop    %ebp
  return fork();
80105774:	e9 87 e4 ff ff       	jmp    80103c00 <fork>
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exit>:

int
sys_exit(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  exit();
80105786:	e8 f5 e6 ff ff       	call   80103e80 <exit>
  return 0;  // not reached
}
8010578b:	31 c0                	xor    %eax,%eax
8010578d:	c9                   	leave  
8010578e:	c3                   	ret    
8010578f:	90                   	nop

80105790 <sys_wait>:

int
sys_wait(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105793:	5d                   	pop    %ebp
  return wait();
80105794:	e9 27 e9 ff ff       	jmp    801040c0 <wait>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_kill>:

int
sys_kill(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 00                	push   $0x0
801057ac:	e8 2f f2 ff ff       	call   801049e0 <argint>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	78 18                	js     801057d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057b8:	83 ec 0c             	sub    $0xc,%esp
801057bb:	ff 75 f4             	pushl  -0xc(%ebp)
801057be:	e8 5d ea ff ff       	call   80104220 <kill>
801057c3:	83 c4 10             	add    $0x10,%esp
}
801057c6:	c9                   	leave  
801057c7:	c3                   	ret    
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d5:	c9                   	leave  
801057d6:	c3                   	ret    
801057d7:	89 f6                	mov    %esi,%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057e0 <sys_getpid>:

int
sys_getpid(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057e6:	e8 a5 e2 ff ff       	call   80103a90 <myproc>
801057eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 de f1 ff ff       	call   801049e0 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	78 27                	js     80105830 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105809:	e8 82 e2 ff ff       	call   80103a90 <myproc>
  if(growproc(n) < 0)
8010580e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105811:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105813:	ff 75 f4             	pushl  -0xc(%ebp)
80105816:	e8 95 e3 ff ff       	call   80103bb0 <growproc>
8010581b:	83 c4 10             	add    $0x10,%esp
8010581e:	85 c0                	test   %eax,%eax
80105820:	78 0e                	js     80105830 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105822:	89 d8                	mov    %ebx,%eax
80105824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105827:	c9                   	leave  
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105830:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105835:	eb eb                	jmp    80105822 <sys_sbrk+0x32>
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_sleep>:

int
sys_sleep(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105847:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010584a:	50                   	push   %eax
8010584b:	6a 00                	push   $0x0
8010584d:	e8 8e f1 ff ff       	call   801049e0 <argint>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	0f 88 8a 00 00 00    	js     801058e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 80 4c 11 80       	push   $0x80114c80
80105865:	e8 f6 ec ff ff       	call   80104560 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010586a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010586d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105870:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  while(ticks - ticks0 < n){
80105876:	85 d2                	test   %edx,%edx
80105878:	75 27                	jne    801058a1 <sys_sleep+0x61>
8010587a:	eb 54                	jmp    801058d0 <sys_sleep+0x90>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	68 80 4c 11 80       	push   $0x80114c80
80105888:	68 c0 54 11 80       	push   $0x801154c0
8010588d:	e8 6e e7 ff ff       	call   80104000 <sleep>
  while(ticks - ticks0 < n){
80105892:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	29 d8                	sub    %ebx,%eax
8010589c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010589f:	73 2f                	jae    801058d0 <sys_sleep+0x90>
    if(myproc()->killed){
801058a1:	e8 ea e1 ff ff       	call   80103a90 <myproc>
801058a6:	8b 40 24             	mov    0x24(%eax),%eax
801058a9:	85 c0                	test   %eax,%eax
801058ab:	74 d3                	je     80105880 <sys_sleep+0x40>
      release(&tickslock);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	68 80 4c 11 80       	push   $0x80114c80
801058b5:	e8 c6 ed ff ff       	call   80104680 <release>
      return -1;
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801058c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	68 80 4c 11 80       	push   $0x80114c80
801058d8:	e8 a3 ed ff ff       	call   80104680 <release>
  return 0;
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	31 c0                	xor    %eax,%eax
}
801058e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
    return -1;
801058e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ec:	eb f4                	jmp    801058e2 <sys_sleep+0xa2>
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
801058f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058f7:	68 80 4c 11 80       	push   $0x80114c80
801058fc:	e8 5f ec ff ff       	call   80104560 <acquire>
  xticks = ticks;
80105901:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  release(&tickslock);
80105907:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
8010590e:	e8 6d ed ff ff       	call   80104680 <release>
  return xticks;
}
80105913:	89 d8                	mov    %ebx,%eax
80105915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105918:	c9                   	leave  
80105919:	c3                   	ret    

8010591a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010591a:	1e                   	push   %ds
  pushl %es
8010591b:	06                   	push   %es
  pushl %fs
8010591c:	0f a0                	push   %fs
  pushl %gs
8010591e:	0f a8                	push   %gs
  pushal
80105920:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105921:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105925:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105927:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105929:	54                   	push   %esp
  call trap
8010592a:	e8 c1 00 00 00       	call   801059f0 <trap>
  addl $4, %esp
8010592f:	83 c4 04             	add    $0x4,%esp

80105932 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105932:	61                   	popa   
  popl %gs
80105933:	0f a9                	pop    %gs
  popl %fs
80105935:	0f a1                	pop    %fs
  popl %es
80105937:	07                   	pop    %es
  popl %ds
80105938:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105939:	83 c4 08             	add    $0x8,%esp
  iret
8010593c:	cf                   	iret   
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105940:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	90                   	nop
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105950:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105957:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
8010595e:	08 00 00 8e 
80105962:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105969:	80 
8010596a:	c1 ea 10             	shr    $0x10,%edx
8010596d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105974:	80 
  for(i = 0; i < 256; i++)
80105975:	83 c0 01             	add    $0x1,%eax
80105978:	3d 00 01 00 00       	cmp    $0x100,%eax
8010597d:	75 d1                	jne    80105950 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010597f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105984:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105987:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
8010598e:	00 00 ef 
  initlock(&tickslock, "time");
80105991:	68 61 7d 10 80       	push   $0x80107d61
80105996:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010599b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
801059a1:	c1 e8 10             	shr    $0x10,%eax
801059a4:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
801059aa:	e8 c1 ea ff ff       	call   80104470 <initlock>
}
801059af:	83 c4 10             	add    $0x10,%esp
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059c0 <idtinit>:

void
idtinit(void)
{
801059c0:	55                   	push   %ebp
  pd[0] = size-1;
801059c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059c6:	89 e5                	mov    %esp,%ebp
801059c8:	83 ec 10             	sub    $0x10,%esp
801059cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059cf:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
801059d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059d8:	c1 e8 10             	shr    $0x10,%eax
801059db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	83 ec 1c             	sub    $0x1c,%esp
801059f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059fc:	8b 47 30             	mov    0x30(%edi),%eax
801059ff:	83 f8 40             	cmp    $0x40,%eax
80105a02:	0f 84 f0 00 00 00    	je     80105af8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a08:	83 e8 0e             	sub    $0xe,%eax
80105a0b:	83 f8 31             	cmp    $0x31,%eax
80105a0e:	77 10                	ja     80105a20 <trap+0x30>
80105a10:	ff 24 85 08 7e 10 80 	jmp    *-0x7fef81f8(,%eax,4)
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a20:	e8 6b e0 ff ff       	call   80103a90 <myproc>
80105a25:	85 c0                	test   %eax,%eax
80105a27:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a2a:	0f 84 04 02 00 00    	je     80105c34 <trap+0x244>
80105a30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a34:	0f 84 fa 01 00 00    	je     80105c34 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a3a:	0f 20 d1             	mov    %cr2,%ecx
80105a3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a40:	e8 2b e0 ff ff       	call   80103a70 <cpuid>
80105a45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a48:	8b 47 34             	mov    0x34(%edi),%eax
80105a4b:	8b 77 30             	mov    0x30(%edi),%esi
80105a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a51:	e8 3a e0 ff ff       	call   80103a90 <myproc>
80105a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a59:	e8 32 e0 ff ff       	call   80103a90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a64:	51                   	push   %ecx
80105a65:	53                   	push   %ebx
80105a66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a6e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a71:	52                   	push   %edx
80105a72:	ff 70 10             	pushl  0x10(%eax)
80105a75:	68 c4 7d 10 80       	push   $0x80107dc4
80105a7a:	e8 e1 ac ff ff       	call   80100760 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a7f:	83 c4 20             	add    $0x20,%esp
80105a82:	e8 09 e0 ff ff       	call   80103a90 <myproc>
80105a87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a8e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a90:	e8 fb df ff ff       	call   80103a90 <myproc>
80105a95:	85 c0                	test   %eax,%eax
80105a97:	74 1d                	je     80105ab6 <trap+0xc6>
80105a99:	e8 f2 df ff ff       	call   80103a90 <myproc>
80105a9e:	8b 50 24             	mov    0x24(%eax),%edx
80105aa1:	85 d2                	test   %edx,%edx
80105aa3:	74 11                	je     80105ab6 <trap+0xc6>
80105aa5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105aa9:	83 e0 03             	and    $0x3,%eax
80105aac:	66 83 f8 03          	cmp    $0x3,%ax
80105ab0:	0f 84 3a 01 00 00    	je     80105bf0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ab6:	e8 d5 df ff ff       	call   80103a90 <myproc>
80105abb:	85 c0                	test   %eax,%eax
80105abd:	74 0b                	je     80105aca <trap+0xda>
80105abf:	e8 cc df ff ff       	call   80103a90 <myproc>
80105ac4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ac8:	74 66                	je     80105b30 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aca:	e8 c1 df ff ff       	call   80103a90 <myproc>
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	74 19                	je     80105aec <trap+0xfc>
80105ad3:	e8 b8 df ff ff       	call   80103a90 <myproc>
80105ad8:	8b 40 24             	mov    0x24(%eax),%eax
80105adb:	85 c0                	test   %eax,%eax
80105add:	74 0d                	je     80105aec <trap+0xfc>
80105adf:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ae3:	83 e0 03             	and    $0x3,%eax
80105ae6:	66 83 f8 03          	cmp    $0x3,%ax
80105aea:	74 35                	je     80105b21 <trap+0x131>
    exit();
}
80105aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aef:	5b                   	pop    %ebx
80105af0:	5e                   	pop    %esi
80105af1:	5f                   	pop    %edi
80105af2:	5d                   	pop    %ebp
80105af3:	c3                   	ret    
80105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105af8:	e8 93 df ff ff       	call   80103a90 <myproc>
80105afd:	8b 58 24             	mov    0x24(%eax),%ebx
80105b00:	85 db                	test   %ebx,%ebx
80105b02:	0f 85 d8 00 00 00    	jne    80105be0 <trap+0x1f0>
    myproc()->tf = tf;
80105b08:	e8 83 df ff ff       	call   80103a90 <myproc>
80105b0d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105b10:	e8 bb ef ff ff       	call   80104ad0 <syscall>
    if(myproc()->killed)
80105b15:	e8 76 df ff ff       	call   80103a90 <myproc>
80105b1a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b1d:	85 c9                	test   %ecx,%ecx
80105b1f:	74 cb                	je     80105aec <trap+0xfc>
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	5b                   	pop    %ebx
80105b25:	5e                   	pop    %esi
80105b26:	5f                   	pop    %edi
80105b27:	5d                   	pop    %ebp
      exit();
80105b28:	e9 53 e3 ff ff       	jmp    80103e80 <exit>
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b30:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b34:	75 94                	jne    80105aca <trap+0xda>
    yield();
80105b36:	e8 75 e4 ff ff       	call   80103fb0 <yield>
80105b3b:	eb 8d                	jmp    80105aca <trap+0xda>
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
  	handle_pgfault();
80105b40:	e8 cb 02 00 00       	call   80105e10 <handle_pgfault>
  	break;
80105b45:	e9 46 ff ff ff       	jmp    80105a90 <trap+0xa0>
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b50:	e8 1b df ff ff       	call   80103a70 <cpuid>
80105b55:	85 c0                	test   %eax,%eax
80105b57:	0f 84 a3 00 00 00    	je     80105c00 <trap+0x210>
    lapiceoi();
80105b5d:	e8 9e ce ff ff       	call   80102a00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b62:	e8 29 df ff ff       	call   80103a90 <myproc>
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 85 2a ff ff ff    	jne    80105a99 <trap+0xa9>
80105b6f:	e9 42 ff ff ff       	jmp    80105ab6 <trap+0xc6>
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b78:	e8 43 cd ff ff       	call   801028c0 <kbdintr>
    lapiceoi();
80105b7d:	e8 7e ce ff ff       	call   80102a00 <lapiceoi>
    break;
80105b82:	e9 09 ff ff ff       	jmp    80105a90 <trap+0xa0>
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105b90:	e8 6b 04 00 00       	call   80106000 <uartintr>
    lapiceoi();
80105b95:	e8 66 ce ff ff       	call   80102a00 <lapiceoi>
    break;
80105b9a:	e9 f1 fe ff ff       	jmp    80105a90 <trap+0xa0>
80105b9f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ba0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ba4:	8b 77 38             	mov    0x38(%edi),%esi
80105ba7:	e8 c4 de ff ff       	call   80103a70 <cpuid>
80105bac:	56                   	push   %esi
80105bad:	53                   	push   %ebx
80105bae:	50                   	push   %eax
80105baf:	68 6c 7d 10 80       	push   $0x80107d6c
80105bb4:	e8 a7 ab ff ff       	call   80100760 <cprintf>
    lapiceoi();
80105bb9:	e8 42 ce ff ff       	call   80102a00 <lapiceoi>
    break;
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	e9 ca fe ff ff       	jmp    80105a90 <trap+0xa0>
80105bc6:	8d 76 00             	lea    0x0(%esi),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105bd0:	e8 5b c7 ff ff       	call   80102330 <ideintr>
80105bd5:	eb 86                	jmp    80105b5d <trap+0x16d>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105be0:	e8 9b e2 ff ff       	call   80103e80 <exit>
80105be5:	e9 1e ff ff ff       	jmp    80105b08 <trap+0x118>
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105bf0:	e8 8b e2 ff ff       	call   80103e80 <exit>
80105bf5:	e9 bc fe ff ff       	jmp    80105ab6 <trap+0xc6>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	68 80 4c 11 80       	push   $0x80114c80
80105c08:	e8 53 e9 ff ff       	call   80104560 <acquire>
      wakeup(&ticks);
80105c0d:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
      ticks++;
80105c14:	83 05 c0 54 11 80 01 	addl   $0x1,0x801154c0
      wakeup(&ticks);
80105c1b:	e8 a0 e5 ff ff       	call   801041c0 <wakeup>
      release(&tickslock);
80105c20:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105c27:	e8 54 ea ff ff       	call   80104680 <release>
80105c2c:	83 c4 10             	add    $0x10,%esp
80105c2f:	e9 29 ff ff ff       	jmp    80105b5d <trap+0x16d>
80105c34:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c37:	e8 34 de ff ff       	call   80103a70 <cpuid>
80105c3c:	83 ec 0c             	sub    $0xc,%esp
80105c3f:	56                   	push   %esi
80105c40:	53                   	push   %ebx
80105c41:	50                   	push   %eax
80105c42:	ff 77 30             	pushl  0x30(%edi)
80105c45:	68 90 7d 10 80       	push   $0x80107d90
80105c4a:	e8 11 ab ff ff       	call   80100760 <cprintf>
      panic("trap");
80105c4f:	83 c4 14             	add    $0x14,%esp
80105c52:	68 66 7d 10 80       	push   $0x80107d66
80105c57:	e8 34 a8 ff ff       	call   80100490 <panic>
80105c5c:	66 90                	xchg   %ax,%ax
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <swap_page_from_pte>:
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 18             	sub    $0x18,%esp
80105c69:	8b 75 08             	mov    0x8(%ebp),%esi
	//cprintf("in: swap_page_from_pte\n");
	//cprintf("bp before\n");
	uint block_page = balloc_page(ROOTDEV);
80105c6c:	6a 01                	push   $0x1
80105c6e:	e8 1d b9 ff ff       	call   80101590 <balloc_page>
	//cprintf("bp after\n");
	char * pte_page = (char * ) ((*pte) & 0xfffff000);
80105c73:	8b 1e                	mov    (%esi),%ebx
	//cprintf("wptd before\n");
	write_page_to_disk(ROOTDEV, P2V(pte_page), block_page);
80105c75:	83 c4 0c             	add    $0xc,%esp
	uint block_page = balloc_page(ROOTDEV);
80105c78:	89 c7                	mov    %eax,%edi
	write_page_to_disk(ROOTDEV, P2V(pte_page), block_page);
80105c7a:	50                   	push   %eax
	//cprintf("wptf after\n");
	block_page = block_page << 12;
80105c7b:	c1 e7 0c             	shl    $0xc,%edi
	char * pte_page = (char * ) ((*pte) & 0xfffff000);
80105c7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	write_page_to_disk(ROOTDEV, P2V(pte_page), block_page);
80105c84:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80105c8a:	53                   	push   %ebx
80105c8b:	6a 01                	push   $0x1
80105c8d:	e8 de a5 ff ff       	call   80100270 <write_page_to_disk>
	*pte = (*pte & 0x00000fff) | block_page | PTE_SW;	//maybe up or down thiws line
80105c92:	8b 06                	mov    (%esi),%eax
80105c94:	25 fe 0f 00 00       	and    $0xffe,%eax
	*pte = (*pte) & (~PTE_P);
80105c99:	09 f8                	or     %edi,%eax
80105c9b:	80 cc 02             	or     $0x2,%ah
80105c9e:	89 06                	mov    %eax,(%esi)
	//cprintf("PTE in swap_page_from_pte: %x",(*pte));

	//cprintf("brfore kree\n");
	kfree(P2V(pte_page));
80105ca0:	89 1c 24             	mov    %ebx,(%esp)
80105ca3:	e8 18 c9 ff ff       	call   801025c0 <kfree>
	//cprintf("after kfree\n");
	switchuvm(myproc());
80105ca8:	e8 e3 dd ff ff       	call   80103a90 <myproc>
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	89 45 08             	mov    %eax,0x8(%ebp)
//	cprintf("out: swap_page_from_pte\n");
}
80105cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb6:	5b                   	pop    %ebx
80105cb7:	5e                   	pop    %esi
80105cb8:	5f                   	pop    %edi
80105cb9:	5d                   	pop    %ebp
	switchuvm(myproc());
80105cba:	e9 31 10 00 00       	jmp    80106cf0 <switchuvm>
80105cbf:	90                   	nop

80105cc0 <swap_page>:

/* Select a victim and swap the contents to the disk.
 */
int
swap_page(pde_t *pgdir)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
80105cc4:	83 ec 04             	sub    $0x4,%esp
80105cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
//	cprintf("in: swap_page\n");
	//1	iterate over all user pages and find a page whose access bit is not set.
	//2 if no such page is found then reset the access bit of any 1 user page.
	//3 repeat 1
	pte_t * victim;
	while ((victim = select_a_victim(pgdir))==0)
80105cca:	eb 10                	jmp    80105cdc <swap_page+0x1c>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	{
		//cprintf("while of swap_page\n");
		clearaccessbit(pgdir);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	53                   	push   %ebx
80105cd4:	e8 d7 13 00 00       	call   801070b0 <clearaccessbit>
80105cd9:	83 c4 10             	add    $0x10,%esp
	while ((victim = select_a_victim(pgdir))==0)
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	53                   	push   %ebx
80105ce0:	e8 8b 13 00 00       	call   80107070 <select_a_victim>
80105ce5:	83 c4 10             	add    $0x10,%esp
80105ce8:	85 c0                	test   %eax,%eax
80105cea:	74 e4                	je     80105cd0 <swap_page+0x10>
	}
	//cprintf("swapping");
	swap_page_from_pte(victim);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	50                   	push   %eax
80105cf0:	e8 6b ff ff ff       	call   80105c60 <swap_page_from_pte>

	//panic("swap_page is not implemented");
	return 1;
}
80105cf5:	b8 01 00 00 00       	mov    $0x1,%eax
80105cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cfd:	c9                   	leave  
80105cfe:	c3                   	ret    
80105cff:	90                   	nop

80105d00 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	83 ec 0c             	sub    $0xc,%esp
80105d09:	8b 75 08             	mov    0x8(%ebp),%esi
80105d0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	//cprintf("in: map_address\n");
	char * kpage;
	//count+=1;
	while ((kpage = kalloc()) == 0)
80105d0f:	e8 5c ca ff ff       	call   80102770 <kalloc>
80105d14:	85 c0                	test   %eax,%eax
80105d16:	89 c3                	mov    %eax,%ebx
80105d18:	74 4e                	je     80105d68 <map_address+0x68>
		swap_page(pgdir); // what to do of return value, always return 1?
		continue;
		//cprintf("%d\n",count );
		//panic("out of physical pages");
	}
	memset((void *)kpage, 0, PGSIZE);
80105d1a:	83 ec 04             	sub    $0x4,%esp
	//mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
	//allocuserpage(pgdir, (void*)addr, 4096, V2P(kpage), PTE_P | PTE_W | PTE_U ); // what flags to put?
	

	//error prone:
	uint phy_addr = (uint) V2P(kpage);
80105d1d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
	memset((void *)kpage, 0, PGSIZE);
80105d23:	68 00 10 00 00       	push   $0x1000
80105d28:	6a 00                	push   $0x0
80105d2a:	50                   	push   %eax
80105d2b:	e8 b0 e9 ff ff       	call   801046e0 <memset>
	pte_t * pte = uva2pte_1(pgdir,addr);
80105d30:	58                   	pop    %eax
80105d31:	5a                   	pop    %edx
80105d32:	57                   	push   %edi
80105d33:	56                   	push   %esi
80105d34:	e8 47 15 00 00       	call   80107280 <uva2pte_1>
	*pte =  phy_addr | ((*pte)&0x00000fff) | PTE_P | PTE_W | PTE_U;
80105d39:	8b 10                	mov    (%eax),%edx
80105d3b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80105d41:	09 da                	or     %ebx,%edx
	*pte = *pte & (~PTE_SW);
80105d43:	80 e6 fd             	and    $0xfd,%dh
80105d46:	83 ca 07             	or     $0x7,%edx
80105d49:	89 10                	mov    %edx,(%eax)
	//cprintf("pte in map_address: %x\n",(uint)(*pte));

	switchuvm(myproc());
80105d4b:	e8 40 dd ff ff       	call   80103a90 <myproc>
80105d50:	83 c4 10             	add    $0x10,%esp
80105d53:	89 45 08             	mov    %eax,0x8(%ebp)
	//panic("map_address is not implemented");
	//cprintf("out: map_address\n");
}
80105d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d59:	5b                   	pop    %ebx
80105d5a:	5e                   	pop    %esi
80105d5b:	5f                   	pop    %edi
80105d5c:	5d                   	pop    %ebp
	switchuvm(myproc());
80105d5d:	e9 8e 0f 00 00       	jmp    80106cf0 <switchuvm>
80105d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		swap_page(pgdir); // what to do of return value, always return 1?
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	56                   	push   %esi
80105d6c:	e8 4f ff ff ff       	call   80105cc0 <swap_page>
		continue;
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	eb 99                	jmp    80105d0f <map_address+0xf>
80105d76:	8d 76 00             	lea    0x0(%esi),%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d80 <get_page_from_disk>:
	}
	
}

void get_page_from_disk(pde_t* pgdir, uint addr)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	57                   	push   %edi
80105d84:	56                   	push   %esi
80105d85:	53                   	push   %ebx
80105d86:	83 ec 24             	sub    $0x24,%esp
80105d89:	8b 75 08             	mov    0x8(%ebp),%esi
80105d8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	//cprintf("in: get_page_from_disk\n");
	int bno = getswappedblk(pgdir, addr);
80105d8f:	57                   	push   %edi
80105d90:	56                   	push   %esi
80105d91:	e8 6a 13 00 00       	call   80107100 <getswappedblk>
	char * kpage;
	while ((kpage = kalloc()) == 0)
80105d96:	83 c4 10             	add    $0x10,%esp
	int bno = getswappedblk(pgdir, addr);
80105d99:	89 c3                	mov    %eax,%ebx
	while ((kpage = kalloc()) == 0)
80105d9b:	e8 d0 c9 ff ff       	call   80102770 <kalloc>
80105da0:	85 c0                	test   %eax,%eax
80105da2:	74 5c                	je     80105e00 <get_page_from_disk+0x80>
		swap_page(pgdir); // what to do of return value, always return 1?
		continue;
		//cprintf("%d\n",count );
		//panic("out of physical pages");
	}
	read_page_from_disk(ROOTDEV, (char*) (kpage), bno);
80105da4:	83 ec 04             	sub    $0x4,%esp
80105da7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105daa:	53                   	push   %ebx
80105dab:	50                   	push   %eax
80105dac:	6a 01                	push   $0x1
80105dae:	e8 4d a5 ff ff       	call   80100300 <read_page_from_disk>
	
	

	//allocuserpage(pgdir, (void*)addr, 4096, V2P(kpage), PTE_P | PTE_W | PTE_U ); : protection fault dega!
	pte_t * pte = uva2pte(pgdir,addr);
80105db3:	58                   	pop    %eax
80105db4:	5a                   	pop    %edx
80105db5:	57                   	push   %edi
80105db6:	56                   	push   %esi
80105db7:	e8 e4 13 00 00       	call   801071a0 <uva2pte>
	//cprintf("pte in get_page_from_disk1: %x\n",(uint)(*pte));
	uint phy_addr = (uint) V2P(kpage);
80105dbc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	
	*pte =  phy_addr | ((*pte)&0x00000fff) | PTE_P;
80105dbf:	8b 10                	mov    (%eax),%edx
	uint phy_addr = (uint) V2P(kpage);
80105dc1:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
	*pte =  phy_addr | ((*pte)&0x00000fff) | PTE_P;
80105dc7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80105dcd:	09 ca                	or     %ecx,%edx
	*pte = *pte & (~PTE_SW);
80105dcf:	80 e6 fd             	and    $0xfd,%dh
80105dd2:	83 ca 01             	or     $0x1,%edx
80105dd5:	89 10                	mov    %edx,(%eax)
	
	//cprintf("pte in get_page_from_disk: %x\n",(uint)(*pte));

	bfree_page(ROOTDEV, bno);
80105dd7:	59                   	pop    %ecx
80105dd8:	5e                   	pop    %esi
80105dd9:	53                   	push   %ebx
80105dda:	6a 01                	push   $0x1
80105ddc:	e8 cf b8 ff ff       	call   801016b0 <bfree_page>
	switchuvm(myproc());
80105de1:	e8 aa dc ff ff       	call   80103a90 <myproc>
80105de6:	83 c4 10             	add    $0x10,%esp
80105de9:	89 45 08             	mov    %eax,0x8(%ebp)
80105dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105def:	5b                   	pop    %ebx
80105df0:	5e                   	pop    %esi
80105df1:	5f                   	pop    %edi
80105df2:	5d                   	pop    %ebp
	switchuvm(myproc());
80105df3:	e9 f8 0e 00 00       	jmp    80106cf0 <switchuvm>
80105df8:	90                   	nop
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		swap_page(pgdir); // what to do of return value, always return 1?
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	56                   	push   %esi
80105e04:	e8 b7 fe ff ff       	call   80105cc0 <swap_page>
		continue;
80105e09:	83 c4 10             	add    $0x10,%esp
80105e0c:	eb 8d                	jmp    80105d9b <get_page_from_disk+0x1b>
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <handle_pgfault>:
{
80105e10:	55                   	push   %ebp
	count+=1;
80105e11:	83 05 bc a5 10 80 01 	addl   $0x1,0x8010a5bc
{
80105e18:	89 e5                	mov    %esp,%ebp
80105e1a:	56                   	push   %esi
80105e1b:	53                   	push   %ebx
	struct proc *curproc = myproc();
80105e1c:	e8 6f dc ff ff       	call   80103a90 <myproc>
	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105e21:	0f 20 d3             	mov    %cr2,%ebx
	pde_t * cpgdir = curproc->pgdir;
80105e24:	8b 70 04             	mov    0x4(%eax),%esi
	pte_t * pte = uva2pte(cpgdir, addr);
80105e27:	83 ec 08             	sub    $0x8,%esp
	addr &= ~0xfff;
80105e2a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	pte_t * pte = uva2pte(cpgdir, addr);
80105e30:	53                   	push   %ebx
80105e31:	56                   	push   %esi
80105e32:	e8 69 13 00 00       	call   801071a0 <uva2pte>
	if ((*pte & PTE_P) == PTE_P)
80105e37:	8b 00                	mov    (%eax),%eax
80105e39:	83 c4 10             	add    $0x10,%esp
80105e3c:	a8 01                	test   $0x1,%al
80105e3e:	75 38                	jne    80105e78 <handle_pgfault+0x68>
	else if ((*pte & PTE_SW) == PTE_SW)
80105e40:	f6 c4 02             	test   $0x2,%ah
80105e43:	75 1b                	jne    80105e60 <handle_pgfault+0x50>
		map_address(cpgdir , addr);	
80105e45:	83 ec 08             	sub    $0x8,%esp
80105e48:	53                   	push   %ebx
80105e49:	56                   	push   %esi
80105e4a:	e8 b1 fe ff ff       	call   80105d00 <map_address>
80105e4f:	83 c4 10             	add    $0x10,%esp
}
80105e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e55:	5b                   	pop    %ebx
80105e56:	5e                   	pop    %esi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		get_page_from_disk(cpgdir,addr);
80105e60:	83 ec 08             	sub    $0x8,%esp
80105e63:	53                   	push   %ebx
80105e64:	56                   	push   %esi
80105e65:	e8 16 ff ff ff       	call   80105d80 <get_page_from_disk>
80105e6a:	83 c4 10             	add    $0x10,%esp
}
80105e6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e70:	5b                   	pop    %ebx
80105e71:	5e                   	pop    %esi
80105e72:	5d                   	pop    %ebp
80105e73:	c3                   	ret    
80105e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("kya karein?");
80105e78:	83 ec 0c             	sub    $0xc,%esp
80105e7b:	68 d0 7e 10 80       	push   $0x80107ed0
80105e80:	e8 db a8 ff ff       	call   80100760 <cprintf>
80105e85:	83 c4 10             	add    $0x10,%esp
}
80105e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e8b:	5b                   	pop    %ebx
80105e8c:	5e                   	pop    %esi
80105e8d:	5d                   	pop    %ebp
80105e8e:	c3                   	ret    
80105e8f:	90                   	nop

80105e90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e90:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105e95:	55                   	push   %ebp
80105e96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	74 1c                	je     80105eb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ea1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ea2:	a8 01                	test   $0x1,%al
80105ea4:	74 12                	je     80105eb8 <uartgetc+0x28>
80105ea6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105eac:	0f b6 c0             	movzbl %al,%eax
}
80105eaf:	5d                   	pop    %ebp
80105eb0:	c3                   	ret    
80105eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ebd:	5d                   	pop    %ebp
80105ebe:	c3                   	ret    
80105ebf:	90                   	nop

80105ec0 <uartputc.part.0>:
uartputc(int c)
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	57                   	push   %edi
80105ec4:	56                   	push   %esi
80105ec5:	53                   	push   %ebx
80105ec6:	89 c7                	mov    %eax,%edi
80105ec8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ecd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ed2:	83 ec 0c             	sub    $0xc,%esp
80105ed5:	eb 1b                	jmp    80105ef2 <uartputc.part.0+0x32>
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	6a 0a                	push   $0xa
80105ee5:	e8 36 cb ff ff       	call   80102a20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	83 eb 01             	sub    $0x1,%ebx
80105ef0:	74 07                	je     80105ef9 <uartputc.part.0+0x39>
80105ef2:	89 f2                	mov    %esi,%edx
80105ef4:	ec                   	in     (%dx),%al
80105ef5:	a8 20                	test   $0x20,%al
80105ef7:	74 e7                	je     80105ee0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105efe:	89 f8                	mov    %edi,%eax
80105f00:	ee                   	out    %al,(%dx)
}
80105f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f04:	5b                   	pop    %ebx
80105f05:	5e                   	pop    %esi
80105f06:	5f                   	pop    %edi
80105f07:	5d                   	pop    %ebp
80105f08:	c3                   	ret    
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <uartinit>:
{
80105f10:	55                   	push   %ebp
80105f11:	31 c9                	xor    %ecx,%ecx
80105f13:	89 c8                	mov    %ecx,%eax
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	57                   	push   %edi
80105f18:	56                   	push   %esi
80105f19:	53                   	push   %ebx
80105f1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f1f:	89 da                	mov    %ebx,%edx
80105f21:	83 ec 0c             	sub    $0xc,%esp
80105f24:	ee                   	out    %al,(%dx)
80105f25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f2f:	89 fa                	mov    %edi,%edx
80105f31:	ee                   	out    %al,(%dx)
80105f32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3c:	ee                   	out    %al,(%dx)
80105f3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f42:	89 c8                	mov    %ecx,%eax
80105f44:	89 f2                	mov    %esi,%edx
80105f46:	ee                   	out    %al,(%dx)
80105f47:	b8 03 00 00 00       	mov    $0x3,%eax
80105f4c:	89 fa                	mov    %edi,%edx
80105f4e:	ee                   	out    %al,(%dx)
80105f4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f54:	89 c8                	mov    %ecx,%eax
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 01 00 00 00       	mov    $0x1,%eax
80105f5c:	89 f2                	mov    %esi,%edx
80105f5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f65:	3c ff                	cmp    $0xff,%al
80105f67:	74 5a                	je     80105fc3 <uartinit+0xb3>
  uart = 1;
80105f69:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105f70:	00 00 00 
80105f73:	89 da                	mov    %ebx,%edx
80105f75:	ec                   	in     (%dx),%al
80105f76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f7f:	bb dc 7e 10 80       	mov    $0x80107edc,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f84:	6a 00                	push   $0x0
80105f86:	6a 04                	push   $0x4
80105f88:	e8 f3 c5 ff ff       	call   80102580 <ioapicenable>
80105f8d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f90:	b8 78 00 00 00       	mov    $0x78,%eax
80105f95:	eb 13                	jmp    80105faa <uartinit+0x9a>
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fa0:	83 c3 01             	add    $0x1,%ebx
80105fa3:	0f be 03             	movsbl (%ebx),%eax
80105fa6:	84 c0                	test   %al,%al
80105fa8:	74 19                	je     80105fc3 <uartinit+0xb3>
  if(!uart)
80105faa:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105fb0:	85 d2                	test   %edx,%edx
80105fb2:	74 ec                	je     80105fa0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105fb4:	83 c3 01             	add    $0x1,%ebx
80105fb7:	e8 04 ff ff ff       	call   80105ec0 <uartputc.part.0>
80105fbc:	0f be 03             	movsbl (%ebx),%eax
80105fbf:	84 c0                	test   %al,%al
80105fc1:	75 e7                	jne    80105faa <uartinit+0x9a>
}
80105fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc6:	5b                   	pop    %ebx
80105fc7:	5e                   	pop    %esi
80105fc8:	5f                   	pop    %edi
80105fc9:	5d                   	pop    %ebp
80105fca:	c3                   	ret    
80105fcb:	90                   	nop
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <uartputc>:
  if(!uart)
80105fd0:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80105fd6:	55                   	push   %ebp
80105fd7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fd9:	85 d2                	test   %edx,%edx
{
80105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105fde:	74 10                	je     80105ff0 <uartputc+0x20>
}
80105fe0:	5d                   	pop    %ebp
80105fe1:	e9 da fe ff ff       	jmp    80105ec0 <uartputc.part.0>
80105fe6:	8d 76 00             	lea    0x0(%esi),%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ff0:	5d                   	pop    %ebp
80105ff1:	c3                   	ret    
80105ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106000 <uartintr>:

void
uartintr(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106006:	68 90 5e 10 80       	push   $0x80105e90
8010600b:	e8 00 a9 ff ff       	call   80100910 <consoleintr>
}
80106010:	83 c4 10             	add    $0x10,%esp
80106013:	c9                   	leave  
80106014:	c3                   	ret    

80106015 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $0
80106017:	6a 00                	push   $0x0
  jmp alltraps
80106019:	e9 fc f8 ff ff       	jmp    8010591a <alltraps>

8010601e <vector1>:
.globl vector1
vector1:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $1
80106020:	6a 01                	push   $0x1
  jmp alltraps
80106022:	e9 f3 f8 ff ff       	jmp    8010591a <alltraps>

80106027 <vector2>:
.globl vector2
vector2:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $2
80106029:	6a 02                	push   $0x2
  jmp alltraps
8010602b:	e9 ea f8 ff ff       	jmp    8010591a <alltraps>

80106030 <vector3>:
.globl vector3
vector3:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $3
80106032:	6a 03                	push   $0x3
  jmp alltraps
80106034:	e9 e1 f8 ff ff       	jmp    8010591a <alltraps>

80106039 <vector4>:
.globl vector4
vector4:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $4
8010603b:	6a 04                	push   $0x4
  jmp alltraps
8010603d:	e9 d8 f8 ff ff       	jmp    8010591a <alltraps>

80106042 <vector5>:
.globl vector5
vector5:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $5
80106044:	6a 05                	push   $0x5
  jmp alltraps
80106046:	e9 cf f8 ff ff       	jmp    8010591a <alltraps>

8010604b <vector6>:
.globl vector6
vector6:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $6
8010604d:	6a 06                	push   $0x6
  jmp alltraps
8010604f:	e9 c6 f8 ff ff       	jmp    8010591a <alltraps>

80106054 <vector7>:
.globl vector7
vector7:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $7
80106056:	6a 07                	push   $0x7
  jmp alltraps
80106058:	e9 bd f8 ff ff       	jmp    8010591a <alltraps>

8010605d <vector8>:
.globl vector8
vector8:
  pushl $8
8010605d:	6a 08                	push   $0x8
  jmp alltraps
8010605f:	e9 b6 f8 ff ff       	jmp    8010591a <alltraps>

80106064 <vector9>:
.globl vector9
vector9:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $9
80106066:	6a 09                	push   $0x9
  jmp alltraps
80106068:	e9 ad f8 ff ff       	jmp    8010591a <alltraps>

8010606d <vector10>:
.globl vector10
vector10:
  pushl $10
8010606d:	6a 0a                	push   $0xa
  jmp alltraps
8010606f:	e9 a6 f8 ff ff       	jmp    8010591a <alltraps>

80106074 <vector11>:
.globl vector11
vector11:
  pushl $11
80106074:	6a 0b                	push   $0xb
  jmp alltraps
80106076:	e9 9f f8 ff ff       	jmp    8010591a <alltraps>

8010607b <vector12>:
.globl vector12
vector12:
  pushl $12
8010607b:	6a 0c                	push   $0xc
  jmp alltraps
8010607d:	e9 98 f8 ff ff       	jmp    8010591a <alltraps>

80106082 <vector13>:
.globl vector13
vector13:
  pushl $13
80106082:	6a 0d                	push   $0xd
  jmp alltraps
80106084:	e9 91 f8 ff ff       	jmp    8010591a <alltraps>

80106089 <vector14>:
.globl vector14
vector14:
  pushl $14
80106089:	6a 0e                	push   $0xe
  jmp alltraps
8010608b:	e9 8a f8 ff ff       	jmp    8010591a <alltraps>

80106090 <vector15>:
.globl vector15
vector15:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $15
80106092:	6a 0f                	push   $0xf
  jmp alltraps
80106094:	e9 81 f8 ff ff       	jmp    8010591a <alltraps>

80106099 <vector16>:
.globl vector16
vector16:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $16
8010609b:	6a 10                	push   $0x10
  jmp alltraps
8010609d:	e9 78 f8 ff ff       	jmp    8010591a <alltraps>

801060a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060a2:	6a 11                	push   $0x11
  jmp alltraps
801060a4:	e9 71 f8 ff ff       	jmp    8010591a <alltraps>

801060a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $18
801060ab:	6a 12                	push   $0x12
  jmp alltraps
801060ad:	e9 68 f8 ff ff       	jmp    8010591a <alltraps>

801060b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $19
801060b4:	6a 13                	push   $0x13
  jmp alltraps
801060b6:	e9 5f f8 ff ff       	jmp    8010591a <alltraps>

801060bb <vector20>:
.globl vector20
vector20:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $20
801060bd:	6a 14                	push   $0x14
  jmp alltraps
801060bf:	e9 56 f8 ff ff       	jmp    8010591a <alltraps>

801060c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $21
801060c6:	6a 15                	push   $0x15
  jmp alltraps
801060c8:	e9 4d f8 ff ff       	jmp    8010591a <alltraps>

801060cd <vector22>:
.globl vector22
vector22:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $22
801060cf:	6a 16                	push   $0x16
  jmp alltraps
801060d1:	e9 44 f8 ff ff       	jmp    8010591a <alltraps>

801060d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $23
801060d8:	6a 17                	push   $0x17
  jmp alltraps
801060da:	e9 3b f8 ff ff       	jmp    8010591a <alltraps>

801060df <vector24>:
.globl vector24
vector24:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $24
801060e1:	6a 18                	push   $0x18
  jmp alltraps
801060e3:	e9 32 f8 ff ff       	jmp    8010591a <alltraps>

801060e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $25
801060ea:	6a 19                	push   $0x19
  jmp alltraps
801060ec:	e9 29 f8 ff ff       	jmp    8010591a <alltraps>

801060f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $26
801060f3:	6a 1a                	push   $0x1a
  jmp alltraps
801060f5:	e9 20 f8 ff ff       	jmp    8010591a <alltraps>

801060fa <vector27>:
.globl vector27
vector27:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $27
801060fc:	6a 1b                	push   $0x1b
  jmp alltraps
801060fe:	e9 17 f8 ff ff       	jmp    8010591a <alltraps>

80106103 <vector28>:
.globl vector28
vector28:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $28
80106105:	6a 1c                	push   $0x1c
  jmp alltraps
80106107:	e9 0e f8 ff ff       	jmp    8010591a <alltraps>

8010610c <vector29>:
.globl vector29
vector29:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $29
8010610e:	6a 1d                	push   $0x1d
  jmp alltraps
80106110:	e9 05 f8 ff ff       	jmp    8010591a <alltraps>

80106115 <vector30>:
.globl vector30
vector30:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $30
80106117:	6a 1e                	push   $0x1e
  jmp alltraps
80106119:	e9 fc f7 ff ff       	jmp    8010591a <alltraps>

8010611e <vector31>:
.globl vector31
vector31:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $31
80106120:	6a 1f                	push   $0x1f
  jmp alltraps
80106122:	e9 f3 f7 ff ff       	jmp    8010591a <alltraps>

80106127 <vector32>:
.globl vector32
vector32:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $32
80106129:	6a 20                	push   $0x20
  jmp alltraps
8010612b:	e9 ea f7 ff ff       	jmp    8010591a <alltraps>

80106130 <vector33>:
.globl vector33
vector33:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $33
80106132:	6a 21                	push   $0x21
  jmp alltraps
80106134:	e9 e1 f7 ff ff       	jmp    8010591a <alltraps>

80106139 <vector34>:
.globl vector34
vector34:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $34
8010613b:	6a 22                	push   $0x22
  jmp alltraps
8010613d:	e9 d8 f7 ff ff       	jmp    8010591a <alltraps>

80106142 <vector35>:
.globl vector35
vector35:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $35
80106144:	6a 23                	push   $0x23
  jmp alltraps
80106146:	e9 cf f7 ff ff       	jmp    8010591a <alltraps>

8010614b <vector36>:
.globl vector36
vector36:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $36
8010614d:	6a 24                	push   $0x24
  jmp alltraps
8010614f:	e9 c6 f7 ff ff       	jmp    8010591a <alltraps>

80106154 <vector37>:
.globl vector37
vector37:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $37
80106156:	6a 25                	push   $0x25
  jmp alltraps
80106158:	e9 bd f7 ff ff       	jmp    8010591a <alltraps>

8010615d <vector38>:
.globl vector38
vector38:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $38
8010615f:	6a 26                	push   $0x26
  jmp alltraps
80106161:	e9 b4 f7 ff ff       	jmp    8010591a <alltraps>

80106166 <vector39>:
.globl vector39
vector39:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $39
80106168:	6a 27                	push   $0x27
  jmp alltraps
8010616a:	e9 ab f7 ff ff       	jmp    8010591a <alltraps>

8010616f <vector40>:
.globl vector40
vector40:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $40
80106171:	6a 28                	push   $0x28
  jmp alltraps
80106173:	e9 a2 f7 ff ff       	jmp    8010591a <alltraps>

80106178 <vector41>:
.globl vector41
vector41:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $41
8010617a:	6a 29                	push   $0x29
  jmp alltraps
8010617c:	e9 99 f7 ff ff       	jmp    8010591a <alltraps>

80106181 <vector42>:
.globl vector42
vector42:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $42
80106183:	6a 2a                	push   $0x2a
  jmp alltraps
80106185:	e9 90 f7 ff ff       	jmp    8010591a <alltraps>

8010618a <vector43>:
.globl vector43
vector43:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $43
8010618c:	6a 2b                	push   $0x2b
  jmp alltraps
8010618e:	e9 87 f7 ff ff       	jmp    8010591a <alltraps>

80106193 <vector44>:
.globl vector44
vector44:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $44
80106195:	6a 2c                	push   $0x2c
  jmp alltraps
80106197:	e9 7e f7 ff ff       	jmp    8010591a <alltraps>

8010619c <vector45>:
.globl vector45
vector45:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $45
8010619e:	6a 2d                	push   $0x2d
  jmp alltraps
801061a0:	e9 75 f7 ff ff       	jmp    8010591a <alltraps>

801061a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $46
801061a7:	6a 2e                	push   $0x2e
  jmp alltraps
801061a9:	e9 6c f7 ff ff       	jmp    8010591a <alltraps>

801061ae <vector47>:
.globl vector47
vector47:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $47
801061b0:	6a 2f                	push   $0x2f
  jmp alltraps
801061b2:	e9 63 f7 ff ff       	jmp    8010591a <alltraps>

801061b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $48
801061b9:	6a 30                	push   $0x30
  jmp alltraps
801061bb:	e9 5a f7 ff ff       	jmp    8010591a <alltraps>

801061c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $49
801061c2:	6a 31                	push   $0x31
  jmp alltraps
801061c4:	e9 51 f7 ff ff       	jmp    8010591a <alltraps>

801061c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $50
801061cb:	6a 32                	push   $0x32
  jmp alltraps
801061cd:	e9 48 f7 ff ff       	jmp    8010591a <alltraps>

801061d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $51
801061d4:	6a 33                	push   $0x33
  jmp alltraps
801061d6:	e9 3f f7 ff ff       	jmp    8010591a <alltraps>

801061db <vector52>:
.globl vector52
vector52:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $52
801061dd:	6a 34                	push   $0x34
  jmp alltraps
801061df:	e9 36 f7 ff ff       	jmp    8010591a <alltraps>

801061e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $53
801061e6:	6a 35                	push   $0x35
  jmp alltraps
801061e8:	e9 2d f7 ff ff       	jmp    8010591a <alltraps>

801061ed <vector54>:
.globl vector54
vector54:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $54
801061ef:	6a 36                	push   $0x36
  jmp alltraps
801061f1:	e9 24 f7 ff ff       	jmp    8010591a <alltraps>

801061f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $55
801061f8:	6a 37                	push   $0x37
  jmp alltraps
801061fa:	e9 1b f7 ff ff       	jmp    8010591a <alltraps>

801061ff <vector56>:
.globl vector56
vector56:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $56
80106201:	6a 38                	push   $0x38
  jmp alltraps
80106203:	e9 12 f7 ff ff       	jmp    8010591a <alltraps>

80106208 <vector57>:
.globl vector57
vector57:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $57
8010620a:	6a 39                	push   $0x39
  jmp alltraps
8010620c:	e9 09 f7 ff ff       	jmp    8010591a <alltraps>

80106211 <vector58>:
.globl vector58
vector58:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $58
80106213:	6a 3a                	push   $0x3a
  jmp alltraps
80106215:	e9 00 f7 ff ff       	jmp    8010591a <alltraps>

8010621a <vector59>:
.globl vector59
vector59:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $59
8010621c:	6a 3b                	push   $0x3b
  jmp alltraps
8010621e:	e9 f7 f6 ff ff       	jmp    8010591a <alltraps>

80106223 <vector60>:
.globl vector60
vector60:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $60
80106225:	6a 3c                	push   $0x3c
  jmp alltraps
80106227:	e9 ee f6 ff ff       	jmp    8010591a <alltraps>

8010622c <vector61>:
.globl vector61
vector61:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $61
8010622e:	6a 3d                	push   $0x3d
  jmp alltraps
80106230:	e9 e5 f6 ff ff       	jmp    8010591a <alltraps>

80106235 <vector62>:
.globl vector62
vector62:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $62
80106237:	6a 3e                	push   $0x3e
  jmp alltraps
80106239:	e9 dc f6 ff ff       	jmp    8010591a <alltraps>

8010623e <vector63>:
.globl vector63
vector63:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $63
80106240:	6a 3f                	push   $0x3f
  jmp alltraps
80106242:	e9 d3 f6 ff ff       	jmp    8010591a <alltraps>

80106247 <vector64>:
.globl vector64
vector64:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $64
80106249:	6a 40                	push   $0x40
  jmp alltraps
8010624b:	e9 ca f6 ff ff       	jmp    8010591a <alltraps>

80106250 <vector65>:
.globl vector65
vector65:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $65
80106252:	6a 41                	push   $0x41
  jmp alltraps
80106254:	e9 c1 f6 ff ff       	jmp    8010591a <alltraps>

80106259 <vector66>:
.globl vector66
vector66:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $66
8010625b:	6a 42                	push   $0x42
  jmp alltraps
8010625d:	e9 b8 f6 ff ff       	jmp    8010591a <alltraps>

80106262 <vector67>:
.globl vector67
vector67:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $67
80106264:	6a 43                	push   $0x43
  jmp alltraps
80106266:	e9 af f6 ff ff       	jmp    8010591a <alltraps>

8010626b <vector68>:
.globl vector68
vector68:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $68
8010626d:	6a 44                	push   $0x44
  jmp alltraps
8010626f:	e9 a6 f6 ff ff       	jmp    8010591a <alltraps>

80106274 <vector69>:
.globl vector69
vector69:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $69
80106276:	6a 45                	push   $0x45
  jmp alltraps
80106278:	e9 9d f6 ff ff       	jmp    8010591a <alltraps>

8010627d <vector70>:
.globl vector70
vector70:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $70
8010627f:	6a 46                	push   $0x46
  jmp alltraps
80106281:	e9 94 f6 ff ff       	jmp    8010591a <alltraps>

80106286 <vector71>:
.globl vector71
vector71:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $71
80106288:	6a 47                	push   $0x47
  jmp alltraps
8010628a:	e9 8b f6 ff ff       	jmp    8010591a <alltraps>

8010628f <vector72>:
.globl vector72
vector72:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $72
80106291:	6a 48                	push   $0x48
  jmp alltraps
80106293:	e9 82 f6 ff ff       	jmp    8010591a <alltraps>

80106298 <vector73>:
.globl vector73
vector73:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $73
8010629a:	6a 49                	push   $0x49
  jmp alltraps
8010629c:	e9 79 f6 ff ff       	jmp    8010591a <alltraps>

801062a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $74
801062a3:	6a 4a                	push   $0x4a
  jmp alltraps
801062a5:	e9 70 f6 ff ff       	jmp    8010591a <alltraps>

801062aa <vector75>:
.globl vector75
vector75:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $75
801062ac:	6a 4b                	push   $0x4b
  jmp alltraps
801062ae:	e9 67 f6 ff ff       	jmp    8010591a <alltraps>

801062b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $76
801062b5:	6a 4c                	push   $0x4c
  jmp alltraps
801062b7:	e9 5e f6 ff ff       	jmp    8010591a <alltraps>

801062bc <vector77>:
.globl vector77
vector77:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $77
801062be:	6a 4d                	push   $0x4d
  jmp alltraps
801062c0:	e9 55 f6 ff ff       	jmp    8010591a <alltraps>

801062c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $78
801062c7:	6a 4e                	push   $0x4e
  jmp alltraps
801062c9:	e9 4c f6 ff ff       	jmp    8010591a <alltraps>

801062ce <vector79>:
.globl vector79
vector79:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $79
801062d0:	6a 4f                	push   $0x4f
  jmp alltraps
801062d2:	e9 43 f6 ff ff       	jmp    8010591a <alltraps>

801062d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $80
801062d9:	6a 50                	push   $0x50
  jmp alltraps
801062db:	e9 3a f6 ff ff       	jmp    8010591a <alltraps>

801062e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $81
801062e2:	6a 51                	push   $0x51
  jmp alltraps
801062e4:	e9 31 f6 ff ff       	jmp    8010591a <alltraps>

801062e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $82
801062eb:	6a 52                	push   $0x52
  jmp alltraps
801062ed:	e9 28 f6 ff ff       	jmp    8010591a <alltraps>

801062f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $83
801062f4:	6a 53                	push   $0x53
  jmp alltraps
801062f6:	e9 1f f6 ff ff       	jmp    8010591a <alltraps>

801062fb <vector84>:
.globl vector84
vector84:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $84
801062fd:	6a 54                	push   $0x54
  jmp alltraps
801062ff:	e9 16 f6 ff ff       	jmp    8010591a <alltraps>

80106304 <vector85>:
.globl vector85
vector85:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $85
80106306:	6a 55                	push   $0x55
  jmp alltraps
80106308:	e9 0d f6 ff ff       	jmp    8010591a <alltraps>

8010630d <vector86>:
.globl vector86
vector86:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $86
8010630f:	6a 56                	push   $0x56
  jmp alltraps
80106311:	e9 04 f6 ff ff       	jmp    8010591a <alltraps>

80106316 <vector87>:
.globl vector87
vector87:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $87
80106318:	6a 57                	push   $0x57
  jmp alltraps
8010631a:	e9 fb f5 ff ff       	jmp    8010591a <alltraps>

8010631f <vector88>:
.globl vector88
vector88:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $88
80106321:	6a 58                	push   $0x58
  jmp alltraps
80106323:	e9 f2 f5 ff ff       	jmp    8010591a <alltraps>

80106328 <vector89>:
.globl vector89
vector89:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $89
8010632a:	6a 59                	push   $0x59
  jmp alltraps
8010632c:	e9 e9 f5 ff ff       	jmp    8010591a <alltraps>

80106331 <vector90>:
.globl vector90
vector90:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $90
80106333:	6a 5a                	push   $0x5a
  jmp alltraps
80106335:	e9 e0 f5 ff ff       	jmp    8010591a <alltraps>

8010633a <vector91>:
.globl vector91
vector91:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $91
8010633c:	6a 5b                	push   $0x5b
  jmp alltraps
8010633e:	e9 d7 f5 ff ff       	jmp    8010591a <alltraps>

80106343 <vector92>:
.globl vector92
vector92:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $92
80106345:	6a 5c                	push   $0x5c
  jmp alltraps
80106347:	e9 ce f5 ff ff       	jmp    8010591a <alltraps>

8010634c <vector93>:
.globl vector93
vector93:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $93
8010634e:	6a 5d                	push   $0x5d
  jmp alltraps
80106350:	e9 c5 f5 ff ff       	jmp    8010591a <alltraps>

80106355 <vector94>:
.globl vector94
vector94:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $94
80106357:	6a 5e                	push   $0x5e
  jmp alltraps
80106359:	e9 bc f5 ff ff       	jmp    8010591a <alltraps>

8010635e <vector95>:
.globl vector95
vector95:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $95
80106360:	6a 5f                	push   $0x5f
  jmp alltraps
80106362:	e9 b3 f5 ff ff       	jmp    8010591a <alltraps>

80106367 <vector96>:
.globl vector96
vector96:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $96
80106369:	6a 60                	push   $0x60
  jmp alltraps
8010636b:	e9 aa f5 ff ff       	jmp    8010591a <alltraps>

80106370 <vector97>:
.globl vector97
vector97:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $97
80106372:	6a 61                	push   $0x61
  jmp alltraps
80106374:	e9 a1 f5 ff ff       	jmp    8010591a <alltraps>

80106379 <vector98>:
.globl vector98
vector98:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $98
8010637b:	6a 62                	push   $0x62
  jmp alltraps
8010637d:	e9 98 f5 ff ff       	jmp    8010591a <alltraps>

80106382 <vector99>:
.globl vector99
vector99:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $99
80106384:	6a 63                	push   $0x63
  jmp alltraps
80106386:	e9 8f f5 ff ff       	jmp    8010591a <alltraps>

8010638b <vector100>:
.globl vector100
vector100:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $100
8010638d:	6a 64                	push   $0x64
  jmp alltraps
8010638f:	e9 86 f5 ff ff       	jmp    8010591a <alltraps>

80106394 <vector101>:
.globl vector101
vector101:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $101
80106396:	6a 65                	push   $0x65
  jmp alltraps
80106398:	e9 7d f5 ff ff       	jmp    8010591a <alltraps>

8010639d <vector102>:
.globl vector102
vector102:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $102
8010639f:	6a 66                	push   $0x66
  jmp alltraps
801063a1:	e9 74 f5 ff ff       	jmp    8010591a <alltraps>

801063a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $103
801063a8:	6a 67                	push   $0x67
  jmp alltraps
801063aa:	e9 6b f5 ff ff       	jmp    8010591a <alltraps>

801063af <vector104>:
.globl vector104
vector104:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $104
801063b1:	6a 68                	push   $0x68
  jmp alltraps
801063b3:	e9 62 f5 ff ff       	jmp    8010591a <alltraps>

801063b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $105
801063ba:	6a 69                	push   $0x69
  jmp alltraps
801063bc:	e9 59 f5 ff ff       	jmp    8010591a <alltraps>

801063c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $106
801063c3:	6a 6a                	push   $0x6a
  jmp alltraps
801063c5:	e9 50 f5 ff ff       	jmp    8010591a <alltraps>

801063ca <vector107>:
.globl vector107
vector107:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $107
801063cc:	6a 6b                	push   $0x6b
  jmp alltraps
801063ce:	e9 47 f5 ff ff       	jmp    8010591a <alltraps>

801063d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $108
801063d5:	6a 6c                	push   $0x6c
  jmp alltraps
801063d7:	e9 3e f5 ff ff       	jmp    8010591a <alltraps>

801063dc <vector109>:
.globl vector109
vector109:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $109
801063de:	6a 6d                	push   $0x6d
  jmp alltraps
801063e0:	e9 35 f5 ff ff       	jmp    8010591a <alltraps>

801063e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $110
801063e7:	6a 6e                	push   $0x6e
  jmp alltraps
801063e9:	e9 2c f5 ff ff       	jmp    8010591a <alltraps>

801063ee <vector111>:
.globl vector111
vector111:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $111
801063f0:	6a 6f                	push   $0x6f
  jmp alltraps
801063f2:	e9 23 f5 ff ff       	jmp    8010591a <alltraps>

801063f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $112
801063f9:	6a 70                	push   $0x70
  jmp alltraps
801063fb:	e9 1a f5 ff ff       	jmp    8010591a <alltraps>

80106400 <vector113>:
.globl vector113
vector113:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $113
80106402:	6a 71                	push   $0x71
  jmp alltraps
80106404:	e9 11 f5 ff ff       	jmp    8010591a <alltraps>

80106409 <vector114>:
.globl vector114
vector114:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $114
8010640b:	6a 72                	push   $0x72
  jmp alltraps
8010640d:	e9 08 f5 ff ff       	jmp    8010591a <alltraps>

80106412 <vector115>:
.globl vector115
vector115:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $115
80106414:	6a 73                	push   $0x73
  jmp alltraps
80106416:	e9 ff f4 ff ff       	jmp    8010591a <alltraps>

8010641b <vector116>:
.globl vector116
vector116:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $116
8010641d:	6a 74                	push   $0x74
  jmp alltraps
8010641f:	e9 f6 f4 ff ff       	jmp    8010591a <alltraps>

80106424 <vector117>:
.globl vector117
vector117:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $117
80106426:	6a 75                	push   $0x75
  jmp alltraps
80106428:	e9 ed f4 ff ff       	jmp    8010591a <alltraps>

8010642d <vector118>:
.globl vector118
vector118:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $118
8010642f:	6a 76                	push   $0x76
  jmp alltraps
80106431:	e9 e4 f4 ff ff       	jmp    8010591a <alltraps>

80106436 <vector119>:
.globl vector119
vector119:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $119
80106438:	6a 77                	push   $0x77
  jmp alltraps
8010643a:	e9 db f4 ff ff       	jmp    8010591a <alltraps>

8010643f <vector120>:
.globl vector120
vector120:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $120
80106441:	6a 78                	push   $0x78
  jmp alltraps
80106443:	e9 d2 f4 ff ff       	jmp    8010591a <alltraps>

80106448 <vector121>:
.globl vector121
vector121:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $121
8010644a:	6a 79                	push   $0x79
  jmp alltraps
8010644c:	e9 c9 f4 ff ff       	jmp    8010591a <alltraps>

80106451 <vector122>:
.globl vector122
vector122:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $122
80106453:	6a 7a                	push   $0x7a
  jmp alltraps
80106455:	e9 c0 f4 ff ff       	jmp    8010591a <alltraps>

8010645a <vector123>:
.globl vector123
vector123:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $123
8010645c:	6a 7b                	push   $0x7b
  jmp alltraps
8010645e:	e9 b7 f4 ff ff       	jmp    8010591a <alltraps>

80106463 <vector124>:
.globl vector124
vector124:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $124
80106465:	6a 7c                	push   $0x7c
  jmp alltraps
80106467:	e9 ae f4 ff ff       	jmp    8010591a <alltraps>

8010646c <vector125>:
.globl vector125
vector125:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $125
8010646e:	6a 7d                	push   $0x7d
  jmp alltraps
80106470:	e9 a5 f4 ff ff       	jmp    8010591a <alltraps>

80106475 <vector126>:
.globl vector126
vector126:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $126
80106477:	6a 7e                	push   $0x7e
  jmp alltraps
80106479:	e9 9c f4 ff ff       	jmp    8010591a <alltraps>

8010647e <vector127>:
.globl vector127
vector127:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $127
80106480:	6a 7f                	push   $0x7f
  jmp alltraps
80106482:	e9 93 f4 ff ff       	jmp    8010591a <alltraps>

80106487 <vector128>:
.globl vector128
vector128:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $128
80106489:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010648e:	e9 87 f4 ff ff       	jmp    8010591a <alltraps>

80106493 <vector129>:
.globl vector129
vector129:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $129
80106495:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010649a:	e9 7b f4 ff ff       	jmp    8010591a <alltraps>

8010649f <vector130>:
.globl vector130
vector130:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $130
801064a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064a6:	e9 6f f4 ff ff       	jmp    8010591a <alltraps>

801064ab <vector131>:
.globl vector131
vector131:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $131
801064ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064b2:	e9 63 f4 ff ff       	jmp    8010591a <alltraps>

801064b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $132
801064b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064be:	e9 57 f4 ff ff       	jmp    8010591a <alltraps>

801064c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $133
801064c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064ca:	e9 4b f4 ff ff       	jmp    8010591a <alltraps>

801064cf <vector134>:
.globl vector134
vector134:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $134
801064d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064d6:	e9 3f f4 ff ff       	jmp    8010591a <alltraps>

801064db <vector135>:
.globl vector135
vector135:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $135
801064dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064e2:	e9 33 f4 ff ff       	jmp    8010591a <alltraps>

801064e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $136
801064e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ee:	e9 27 f4 ff ff       	jmp    8010591a <alltraps>

801064f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $137
801064f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064fa:	e9 1b f4 ff ff       	jmp    8010591a <alltraps>

801064ff <vector138>:
.globl vector138
vector138:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $138
80106501:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106506:	e9 0f f4 ff ff       	jmp    8010591a <alltraps>

8010650b <vector139>:
.globl vector139
vector139:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $139
8010650d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106512:	e9 03 f4 ff ff       	jmp    8010591a <alltraps>

80106517 <vector140>:
.globl vector140
vector140:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $140
80106519:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010651e:	e9 f7 f3 ff ff       	jmp    8010591a <alltraps>

80106523 <vector141>:
.globl vector141
vector141:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $141
80106525:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010652a:	e9 eb f3 ff ff       	jmp    8010591a <alltraps>

8010652f <vector142>:
.globl vector142
vector142:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $142
80106531:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106536:	e9 df f3 ff ff       	jmp    8010591a <alltraps>

8010653b <vector143>:
.globl vector143
vector143:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $143
8010653d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106542:	e9 d3 f3 ff ff       	jmp    8010591a <alltraps>

80106547 <vector144>:
.globl vector144
vector144:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $144
80106549:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010654e:	e9 c7 f3 ff ff       	jmp    8010591a <alltraps>

80106553 <vector145>:
.globl vector145
vector145:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $145
80106555:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010655a:	e9 bb f3 ff ff       	jmp    8010591a <alltraps>

8010655f <vector146>:
.globl vector146
vector146:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $146
80106561:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106566:	e9 af f3 ff ff       	jmp    8010591a <alltraps>

8010656b <vector147>:
.globl vector147
vector147:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $147
8010656d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106572:	e9 a3 f3 ff ff       	jmp    8010591a <alltraps>

80106577 <vector148>:
.globl vector148
vector148:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $148
80106579:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010657e:	e9 97 f3 ff ff       	jmp    8010591a <alltraps>

80106583 <vector149>:
.globl vector149
vector149:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $149
80106585:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010658a:	e9 8b f3 ff ff       	jmp    8010591a <alltraps>

8010658f <vector150>:
.globl vector150
vector150:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $150
80106591:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106596:	e9 7f f3 ff ff       	jmp    8010591a <alltraps>

8010659b <vector151>:
.globl vector151
vector151:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $151
8010659d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065a2:	e9 73 f3 ff ff       	jmp    8010591a <alltraps>

801065a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $152
801065a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ae:	e9 67 f3 ff ff       	jmp    8010591a <alltraps>

801065b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $153
801065b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ba:	e9 5b f3 ff ff       	jmp    8010591a <alltraps>

801065bf <vector154>:
.globl vector154
vector154:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $154
801065c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065c6:	e9 4f f3 ff ff       	jmp    8010591a <alltraps>

801065cb <vector155>:
.globl vector155
vector155:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $155
801065cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065d2:	e9 43 f3 ff ff       	jmp    8010591a <alltraps>

801065d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $156
801065d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065de:	e9 37 f3 ff ff       	jmp    8010591a <alltraps>

801065e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $157
801065e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ea:	e9 2b f3 ff ff       	jmp    8010591a <alltraps>

801065ef <vector158>:
.globl vector158
vector158:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $158
801065f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065f6:	e9 1f f3 ff ff       	jmp    8010591a <alltraps>

801065fb <vector159>:
.globl vector159
vector159:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $159
801065fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106602:	e9 13 f3 ff ff       	jmp    8010591a <alltraps>

80106607 <vector160>:
.globl vector160
vector160:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $160
80106609:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010660e:	e9 07 f3 ff ff       	jmp    8010591a <alltraps>

80106613 <vector161>:
.globl vector161
vector161:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $161
80106615:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010661a:	e9 fb f2 ff ff       	jmp    8010591a <alltraps>

8010661f <vector162>:
.globl vector162
vector162:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $162
80106621:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106626:	e9 ef f2 ff ff       	jmp    8010591a <alltraps>

8010662b <vector163>:
.globl vector163
vector163:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $163
8010662d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106632:	e9 e3 f2 ff ff       	jmp    8010591a <alltraps>

80106637 <vector164>:
.globl vector164
vector164:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $164
80106639:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010663e:	e9 d7 f2 ff ff       	jmp    8010591a <alltraps>

80106643 <vector165>:
.globl vector165
vector165:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $165
80106645:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010664a:	e9 cb f2 ff ff       	jmp    8010591a <alltraps>

8010664f <vector166>:
.globl vector166
vector166:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $166
80106651:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106656:	e9 bf f2 ff ff       	jmp    8010591a <alltraps>

8010665b <vector167>:
.globl vector167
vector167:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $167
8010665d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106662:	e9 b3 f2 ff ff       	jmp    8010591a <alltraps>

80106667 <vector168>:
.globl vector168
vector168:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $168
80106669:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010666e:	e9 a7 f2 ff ff       	jmp    8010591a <alltraps>

80106673 <vector169>:
.globl vector169
vector169:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $169
80106675:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010667a:	e9 9b f2 ff ff       	jmp    8010591a <alltraps>

8010667f <vector170>:
.globl vector170
vector170:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $170
80106681:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106686:	e9 8f f2 ff ff       	jmp    8010591a <alltraps>

8010668b <vector171>:
.globl vector171
vector171:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $171
8010668d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106692:	e9 83 f2 ff ff       	jmp    8010591a <alltraps>

80106697 <vector172>:
.globl vector172
vector172:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $172
80106699:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010669e:	e9 77 f2 ff ff       	jmp    8010591a <alltraps>

801066a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $173
801066a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066aa:	e9 6b f2 ff ff       	jmp    8010591a <alltraps>

801066af <vector174>:
.globl vector174
vector174:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $174
801066b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066b6:	e9 5f f2 ff ff       	jmp    8010591a <alltraps>

801066bb <vector175>:
.globl vector175
vector175:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $175
801066bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066c2:	e9 53 f2 ff ff       	jmp    8010591a <alltraps>

801066c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $176
801066c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ce:	e9 47 f2 ff ff       	jmp    8010591a <alltraps>

801066d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $177
801066d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066da:	e9 3b f2 ff ff       	jmp    8010591a <alltraps>

801066df <vector178>:
.globl vector178
vector178:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $178
801066e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066e6:	e9 2f f2 ff ff       	jmp    8010591a <alltraps>

801066eb <vector179>:
.globl vector179
vector179:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $179
801066ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066f2:	e9 23 f2 ff ff       	jmp    8010591a <alltraps>

801066f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $180
801066f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066fe:	e9 17 f2 ff ff       	jmp    8010591a <alltraps>

80106703 <vector181>:
.globl vector181
vector181:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $181
80106705:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010670a:	e9 0b f2 ff ff       	jmp    8010591a <alltraps>

8010670f <vector182>:
.globl vector182
vector182:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $182
80106711:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106716:	e9 ff f1 ff ff       	jmp    8010591a <alltraps>

8010671b <vector183>:
.globl vector183
vector183:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $183
8010671d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106722:	e9 f3 f1 ff ff       	jmp    8010591a <alltraps>

80106727 <vector184>:
.globl vector184
vector184:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $184
80106729:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010672e:	e9 e7 f1 ff ff       	jmp    8010591a <alltraps>

80106733 <vector185>:
.globl vector185
vector185:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $185
80106735:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010673a:	e9 db f1 ff ff       	jmp    8010591a <alltraps>

8010673f <vector186>:
.globl vector186
vector186:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $186
80106741:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106746:	e9 cf f1 ff ff       	jmp    8010591a <alltraps>

8010674b <vector187>:
.globl vector187
vector187:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $187
8010674d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106752:	e9 c3 f1 ff ff       	jmp    8010591a <alltraps>

80106757 <vector188>:
.globl vector188
vector188:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $188
80106759:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010675e:	e9 b7 f1 ff ff       	jmp    8010591a <alltraps>

80106763 <vector189>:
.globl vector189
vector189:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $189
80106765:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010676a:	e9 ab f1 ff ff       	jmp    8010591a <alltraps>

8010676f <vector190>:
.globl vector190
vector190:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $190
80106771:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106776:	e9 9f f1 ff ff       	jmp    8010591a <alltraps>

8010677b <vector191>:
.globl vector191
vector191:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $191
8010677d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106782:	e9 93 f1 ff ff       	jmp    8010591a <alltraps>

80106787 <vector192>:
.globl vector192
vector192:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $192
80106789:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010678e:	e9 87 f1 ff ff       	jmp    8010591a <alltraps>

80106793 <vector193>:
.globl vector193
vector193:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $193
80106795:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010679a:	e9 7b f1 ff ff       	jmp    8010591a <alltraps>

8010679f <vector194>:
.globl vector194
vector194:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $194
801067a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067a6:	e9 6f f1 ff ff       	jmp    8010591a <alltraps>

801067ab <vector195>:
.globl vector195
vector195:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $195
801067ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067b2:	e9 63 f1 ff ff       	jmp    8010591a <alltraps>

801067b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $196
801067b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067be:	e9 57 f1 ff ff       	jmp    8010591a <alltraps>

801067c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $197
801067c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067ca:	e9 4b f1 ff ff       	jmp    8010591a <alltraps>

801067cf <vector198>:
.globl vector198
vector198:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $198
801067d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067d6:	e9 3f f1 ff ff       	jmp    8010591a <alltraps>

801067db <vector199>:
.globl vector199
vector199:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $199
801067dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067e2:	e9 33 f1 ff ff       	jmp    8010591a <alltraps>

801067e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $200
801067e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ee:	e9 27 f1 ff ff       	jmp    8010591a <alltraps>

801067f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $201
801067f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067fa:	e9 1b f1 ff ff       	jmp    8010591a <alltraps>

801067ff <vector202>:
.globl vector202
vector202:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $202
80106801:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106806:	e9 0f f1 ff ff       	jmp    8010591a <alltraps>

8010680b <vector203>:
.globl vector203
vector203:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $203
8010680d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106812:	e9 03 f1 ff ff       	jmp    8010591a <alltraps>

80106817 <vector204>:
.globl vector204
vector204:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $204
80106819:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010681e:	e9 f7 f0 ff ff       	jmp    8010591a <alltraps>

80106823 <vector205>:
.globl vector205
vector205:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $205
80106825:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010682a:	e9 eb f0 ff ff       	jmp    8010591a <alltraps>

8010682f <vector206>:
.globl vector206
vector206:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $206
80106831:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106836:	e9 df f0 ff ff       	jmp    8010591a <alltraps>

8010683b <vector207>:
.globl vector207
vector207:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $207
8010683d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106842:	e9 d3 f0 ff ff       	jmp    8010591a <alltraps>

80106847 <vector208>:
.globl vector208
vector208:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $208
80106849:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010684e:	e9 c7 f0 ff ff       	jmp    8010591a <alltraps>

80106853 <vector209>:
.globl vector209
vector209:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $209
80106855:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010685a:	e9 bb f0 ff ff       	jmp    8010591a <alltraps>

8010685f <vector210>:
.globl vector210
vector210:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $210
80106861:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106866:	e9 af f0 ff ff       	jmp    8010591a <alltraps>

8010686b <vector211>:
.globl vector211
vector211:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $211
8010686d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106872:	e9 a3 f0 ff ff       	jmp    8010591a <alltraps>

80106877 <vector212>:
.globl vector212
vector212:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $212
80106879:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010687e:	e9 97 f0 ff ff       	jmp    8010591a <alltraps>

80106883 <vector213>:
.globl vector213
vector213:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $213
80106885:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010688a:	e9 8b f0 ff ff       	jmp    8010591a <alltraps>

8010688f <vector214>:
.globl vector214
vector214:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $214
80106891:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106896:	e9 7f f0 ff ff       	jmp    8010591a <alltraps>

8010689b <vector215>:
.globl vector215
vector215:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $215
8010689d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068a2:	e9 73 f0 ff ff       	jmp    8010591a <alltraps>

801068a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $216
801068a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ae:	e9 67 f0 ff ff       	jmp    8010591a <alltraps>

801068b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $217
801068b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ba:	e9 5b f0 ff ff       	jmp    8010591a <alltraps>

801068bf <vector218>:
.globl vector218
vector218:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $218
801068c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068c6:	e9 4f f0 ff ff       	jmp    8010591a <alltraps>

801068cb <vector219>:
.globl vector219
vector219:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $219
801068cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068d2:	e9 43 f0 ff ff       	jmp    8010591a <alltraps>

801068d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $220
801068d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068de:	e9 37 f0 ff ff       	jmp    8010591a <alltraps>

801068e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $221
801068e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ea:	e9 2b f0 ff ff       	jmp    8010591a <alltraps>

801068ef <vector222>:
.globl vector222
vector222:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $222
801068f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068f6:	e9 1f f0 ff ff       	jmp    8010591a <alltraps>

801068fb <vector223>:
.globl vector223
vector223:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $223
801068fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106902:	e9 13 f0 ff ff       	jmp    8010591a <alltraps>

80106907 <vector224>:
.globl vector224
vector224:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $224
80106909:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010690e:	e9 07 f0 ff ff       	jmp    8010591a <alltraps>

80106913 <vector225>:
.globl vector225
vector225:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $225
80106915:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010691a:	e9 fb ef ff ff       	jmp    8010591a <alltraps>

8010691f <vector226>:
.globl vector226
vector226:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $226
80106921:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106926:	e9 ef ef ff ff       	jmp    8010591a <alltraps>

8010692b <vector227>:
.globl vector227
vector227:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $227
8010692d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106932:	e9 e3 ef ff ff       	jmp    8010591a <alltraps>

80106937 <vector228>:
.globl vector228
vector228:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $228
80106939:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010693e:	e9 d7 ef ff ff       	jmp    8010591a <alltraps>

80106943 <vector229>:
.globl vector229
vector229:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $229
80106945:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010694a:	e9 cb ef ff ff       	jmp    8010591a <alltraps>

8010694f <vector230>:
.globl vector230
vector230:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $230
80106951:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106956:	e9 bf ef ff ff       	jmp    8010591a <alltraps>

8010695b <vector231>:
.globl vector231
vector231:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $231
8010695d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106962:	e9 b3 ef ff ff       	jmp    8010591a <alltraps>

80106967 <vector232>:
.globl vector232
vector232:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $232
80106969:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010696e:	e9 a7 ef ff ff       	jmp    8010591a <alltraps>

80106973 <vector233>:
.globl vector233
vector233:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $233
80106975:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010697a:	e9 9b ef ff ff       	jmp    8010591a <alltraps>

8010697f <vector234>:
.globl vector234
vector234:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $234
80106981:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106986:	e9 8f ef ff ff       	jmp    8010591a <alltraps>

8010698b <vector235>:
.globl vector235
vector235:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $235
8010698d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106992:	e9 83 ef ff ff       	jmp    8010591a <alltraps>

80106997 <vector236>:
.globl vector236
vector236:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $236
80106999:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010699e:	e9 77 ef ff ff       	jmp    8010591a <alltraps>

801069a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $237
801069a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069aa:	e9 6b ef ff ff       	jmp    8010591a <alltraps>

801069af <vector238>:
.globl vector238
vector238:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $238
801069b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069b6:	e9 5f ef ff ff       	jmp    8010591a <alltraps>

801069bb <vector239>:
.globl vector239
vector239:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $239
801069bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069c2:	e9 53 ef ff ff       	jmp    8010591a <alltraps>

801069c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $240
801069c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ce:	e9 47 ef ff ff       	jmp    8010591a <alltraps>

801069d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $241
801069d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069da:	e9 3b ef ff ff       	jmp    8010591a <alltraps>

801069df <vector242>:
.globl vector242
vector242:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $242
801069e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069e6:	e9 2f ef ff ff       	jmp    8010591a <alltraps>

801069eb <vector243>:
.globl vector243
vector243:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $243
801069ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069f2:	e9 23 ef ff ff       	jmp    8010591a <alltraps>

801069f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $244
801069f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069fe:	e9 17 ef ff ff       	jmp    8010591a <alltraps>

80106a03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $245
80106a05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a0a:	e9 0b ef ff ff       	jmp    8010591a <alltraps>

80106a0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $246
80106a11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a16:	e9 ff ee ff ff       	jmp    8010591a <alltraps>

80106a1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $247
80106a1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a22:	e9 f3 ee ff ff       	jmp    8010591a <alltraps>

80106a27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $248
80106a29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a2e:	e9 e7 ee ff ff       	jmp    8010591a <alltraps>

80106a33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $249
80106a35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a3a:	e9 db ee ff ff       	jmp    8010591a <alltraps>

80106a3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $250
80106a41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a46:	e9 cf ee ff ff       	jmp    8010591a <alltraps>

80106a4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $251
80106a4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a52:	e9 c3 ee ff ff       	jmp    8010591a <alltraps>

80106a57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $252
80106a59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a5e:	e9 b7 ee ff ff       	jmp    8010591a <alltraps>

80106a63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $253
80106a65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a6a:	e9 ab ee ff ff       	jmp    8010591a <alltraps>

80106a6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $254
80106a71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a76:	e9 9f ee ff ff       	jmp    8010591a <alltraps>

80106a7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $255
80106a7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a82:	e9 93 ee ff ff       	jmp    8010591a <alltraps>
80106a87:	66 90                	xchg   %ax,%ax
80106a89:	66 90                	xchg   %ax,%ax
80106a8b:	66 90                	xchg   %ax,%ax
80106a8d:	66 90                	xchg   %ax,%ax
80106a8f:	90                   	nop

80106a90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a96:	89 d3                	mov    %edx,%ebx
{
80106a98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a9a:	c1 eb 16             	shr    $0x16,%ebx
80106a9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106aa0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106aa3:	8b 06                	mov    (%esi),%eax
80106aa5:	a8 01                	test   $0x1,%al
80106aa7:	74 27                	je     80106ad0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106aa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ab4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106aba:	89 fa                	mov    %edi,%edx
80106abc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ac2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ad0:	85 c9                	test   %ecx,%ecx
80106ad2:	74 2c                	je     80106b00 <walkpgdir+0x70>
80106ad4:	e8 97 bc ff ff       	call   80102770 <kalloc>
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	89 c3                	mov    %eax,%ebx
80106add:	74 21                	je     80106b00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106adf:	83 ec 04             	sub    $0x4,%esp
80106ae2:	68 00 10 00 00       	push   $0x1000
80106ae7:	6a 00                	push   $0x0
80106ae9:	50                   	push   %eax
80106aea:	e8 f1 db ff ff       	call   801046e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106af5:	83 c4 10             	add    $0x10,%esp
80106af8:	83 c8 07             	or     $0x7,%eax
80106afb:	89 06                	mov    %eax,(%esi)
80106afd:	eb b5                	jmp    80106ab4 <walkpgdir+0x24>
80106aff:	90                   	nop
}
80106b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b03:	31 c0                	xor    %eax,%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    
80106b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b16:	89 d3                	mov    %edx,%ebx
80106b18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b1e:	83 ec 1c             	sub    $0x1c,%esp
80106b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b36:	29 df                	sub    %ebx,%edi
80106b38:	83 c8 01             	or     $0x1,%eax
80106b3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b3e:	eb 15                	jmp    80106b55 <mappages+0x45>
    if(*pte & PTE_P)
80106b40:	f6 00 01             	testb  $0x1,(%eax)
80106b43:	75 45                	jne    80106b8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b4d:	74 31                	je     80106b80 <mappages+0x70>
      break;
    a += PGSIZE;
80106b4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b5d:	89 da                	mov    %ebx,%edx
80106b5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b62:	e8 29 ff ff ff       	call   80106a90 <walkpgdir>
80106b67:	85 c0                	test   %eax,%eax
80106b69:	75 d5                	jne    80106b40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b73:	5b                   	pop    %ebx
80106b74:	5e                   	pop    %esi
80106b75:	5f                   	pop    %edi
80106b76:	5d                   	pop    %ebp
80106b77:	c3                   	ret    
80106b78:	90                   	nop
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b83:	31 c0                	xor    %eax,%eax
}
80106b85:	5b                   	pop    %ebx
80106b86:	5e                   	pop    %esi
80106b87:	5f                   	pop    %edi
80106b88:	5d                   	pop    %ebp
80106b89:	c3                   	ret    
      panic("remap");
80106b8a:	83 ec 0c             	sub    $0xc,%esp
80106b8d:	68 e4 7e 10 80       	push   $0x80107ee4
80106b92:	e8 f9 98 ff ff       	call   80100490 <panic>
80106b97:	89 f6                	mov    %esi,%esi
80106b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ba0 <deallocuvm.part.0>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ba6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106bae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bb4:	83 ec 1c             	sub    $0x1c,%esp
80106bb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bba:	39 d3                	cmp    %edx,%ebx
80106bbc:	73 66                	jae    80106c24 <deallocuvm.part.0+0x84>
80106bbe:	89 d6                	mov    %edx,%esi
80106bc0:	eb 3d                	jmp    80106bff <deallocuvm.part.0+0x5f>
80106bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106bc8:	8b 10                	mov    (%eax),%edx
80106bca:	f6 c2 01             	test   $0x1,%dl
80106bcd:	74 26                	je     80106bf5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106bcf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106bd5:	74 58                	je     80106c2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106bd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106be0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106be3:	52                   	push   %edx
80106be4:	e8 d7 b9 ff ff       	call   801025c0 <kfree>
      *pte = 0;
80106be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bec:	83 c4 10             	add    $0x10,%esp
80106bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106bf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bfb:	39 f3                	cmp    %esi,%ebx
80106bfd:	73 25                	jae    80106c24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bff:	31 c9                	xor    %ecx,%ecx
80106c01:	89 da                	mov    %ebx,%edx
80106c03:	89 f8                	mov    %edi,%eax
80106c05:	e8 86 fe ff ff       	call   80106a90 <walkpgdir>
    if(!pte)
80106c0a:	85 c0                	test   %eax,%eax
80106c0c:	75 ba                	jne    80106bc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c20:	39 f3                	cmp    %esi,%ebx
80106c22:	72 db                	jb     80106bff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c2a:	5b                   	pop    %ebx
80106c2b:	5e                   	pop    %esi
80106c2c:	5f                   	pop    %edi
80106c2d:	5d                   	pop    %ebp
80106c2e:	c3                   	ret    
        panic("kfree");
80106c2f:	83 ec 0c             	sub    $0xc,%esp
80106c32:	68 22 78 10 80       	push   $0x80107822
80106c37:	e8 54 98 ff ff       	call   80100490 <panic>
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c40 <seginit>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c46:	e8 25 ce ff ff       	call   80103a70 <cpuid>
80106c4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c5a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106c61:	ff 00 00 
80106c64:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106c6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c6e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106c75:	ff 00 00 
80106c78:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106c7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c82:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106c89:	ff 00 00 
80106c8c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106c93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c96:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106c9d:	ff 00 00 
80106ca0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106ca7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106caa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106caf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cb3:	c1 e8 10             	shr    $0x10,%eax
80106cb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cbd:	0f 01 10             	lgdtl  (%eax)
}
80106cc0:	c9                   	leave  
80106cc1:	c3                   	ret    
80106cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cd0:	a1 c4 54 11 80       	mov    0x801154c4,%eax
{
80106cd5:	55                   	push   %ebp
80106cd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cdd:	0f 22 d8             	mov    %eax,%cr3
}
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret    
80106ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <switchuvm>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 1c             	sub    $0x1c,%esp
80106cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106cfc:	85 db                	test   %ebx,%ebx
80106cfe:	0f 84 cb 00 00 00    	je     80106dcf <switchuvm+0xdf>
  if(p->kstack == 0)
80106d04:	8b 43 08             	mov    0x8(%ebx),%eax
80106d07:	85 c0                	test   %eax,%eax
80106d09:	0f 84 da 00 00 00    	je     80106de9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d12:	85 c0                	test   %eax,%eax
80106d14:	0f 84 c2 00 00 00    	je     80106ddc <switchuvm+0xec>
  pushcli();
80106d1a:	e8 01 d8 ff ff       	call   80104520 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d1f:	e8 cc cc ff ff       	call   801039f0 <mycpu>
80106d24:	89 c6                	mov    %eax,%esi
80106d26:	e8 c5 cc ff ff       	call   801039f0 <mycpu>
80106d2b:	89 c7                	mov    %eax,%edi
80106d2d:	e8 be cc ff ff       	call   801039f0 <mycpu>
80106d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d35:	83 c7 08             	add    $0x8,%edi
80106d38:	e8 b3 cc ff ff       	call   801039f0 <mycpu>
80106d3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d40:	83 c0 08             	add    $0x8,%eax
80106d43:	ba 67 00 00 00       	mov    $0x67,%edx
80106d48:	c1 e8 18             	shr    $0x18,%eax
80106d4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d64:	83 c1 08             	add    $0x8,%ecx
80106d67:	c1 e9 10             	shr    $0x10,%ecx
80106d6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106d81:	e8 6a cc ff ff       	call   801039f0 <mycpu>
80106d86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d8d:	e8 5e cc ff ff       	call   801039f0 <mycpu>
80106d92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d96:	8b 73 08             	mov    0x8(%ebx),%esi
80106d99:	e8 52 cc ff ff       	call   801039f0 <mycpu>
80106d9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106da4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106da7:	e8 44 cc ff ff       	call   801039f0 <mycpu>
80106dac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106db0:	b8 28 00 00 00       	mov    $0x28,%eax
80106db5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106db8:	8b 43 04             	mov    0x4(%ebx),%eax
80106dbb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dc0:	0f 22 d8             	mov    %eax,%cr3
}
80106dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc6:	5b                   	pop    %ebx
80106dc7:	5e                   	pop    %esi
80106dc8:	5f                   	pop    %edi
80106dc9:	5d                   	pop    %ebp
  popcli();
80106dca:	e9 51 d8 ff ff       	jmp    80104620 <popcli>
    panic("switchuvm: no process");
80106dcf:	83 ec 0c             	sub    $0xc,%esp
80106dd2:	68 ea 7e 10 80       	push   $0x80107eea
80106dd7:	e8 b4 96 ff ff       	call   80100490 <panic>
    panic("switchuvm: no pgdir");
80106ddc:	83 ec 0c             	sub    $0xc,%esp
80106ddf:	68 15 7f 10 80       	push   $0x80107f15
80106de4:	e8 a7 96 ff ff       	call   80100490 <panic>
    panic("switchuvm: no kstack");
80106de9:	83 ec 0c             	sub    $0xc,%esp
80106dec:	68 00 7f 10 80       	push   $0x80107f00
80106df1:	e8 9a 96 ff ff       	call   80100490 <panic>
80106df6:	8d 76 00             	lea    0x0(%esi),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <inituvm>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 1c             	sub    $0x1c,%esp
80106e09:	8b 75 10             	mov    0x10(%ebp),%esi
80106e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e1b:	77 49                	ja     80106e66 <inituvm+0x66>
  mem = kalloc();
80106e1d:	e8 4e b9 ff ff       	call   80102770 <kalloc>
  memset(mem, 0, PGSIZE);
80106e22:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e27:	68 00 10 00 00       	push   $0x1000
80106e2c:	6a 00                	push   $0x0
80106e2e:	50                   	push   %eax
80106e2f:	e8 ac d8 ff ff       	call   801046e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e34:	58                   	pop    %eax
80106e35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e40:	5a                   	pop    %edx
80106e41:	6a 06                	push   $0x6
80106e43:	50                   	push   %eax
80106e44:	31 d2                	xor    %edx,%edx
80106e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e49:	e8 c2 fc ff ff       	call   80106b10 <mappages>
  memmove(mem, init, sz);
80106e4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e54:	83 c4 10             	add    $0x10,%esp
80106e57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e5d:	5b                   	pop    %ebx
80106e5e:	5e                   	pop    %esi
80106e5f:	5f                   	pop    %edi
80106e60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e61:	e9 2a d9 ff ff       	jmp    80104790 <memmove>
    panic("inituvm: more than a page");
80106e66:	83 ec 0c             	sub    $0xc,%esp
80106e69:	68 29 7f 10 80       	push   $0x80107f29
80106e6e:	e8 1d 96 ff ff       	call   80100490 <panic>
80106e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e80 <loaduvm>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e90:	0f 85 91 00 00 00    	jne    80106f27 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106e96:	8b 75 18             	mov    0x18(%ebp),%esi
80106e99:	31 db                	xor    %ebx,%ebx
80106e9b:	85 f6                	test   %esi,%esi
80106e9d:	75 1a                	jne    80106eb9 <loaduvm+0x39>
80106e9f:	eb 6f                	jmp    80106f10 <loaduvm+0x90>
80106ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106eb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106eb7:	76 57                	jbe    80106f10 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebf:	31 c9                	xor    %ecx,%ecx
80106ec1:	01 da                	add    %ebx,%edx
80106ec3:	e8 c8 fb ff ff       	call   80106a90 <walkpgdir>
80106ec8:	85 c0                	test   %eax,%eax
80106eca:	74 4e                	je     80106f1a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ecc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ece:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ed1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ed6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106edb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ee1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ee4:	01 d9                	add    %ebx,%ecx
80106ee6:	05 00 00 00 80       	add    $0x80000000,%eax
80106eeb:	57                   	push   %edi
80106eec:	51                   	push   %ecx
80106eed:	50                   	push   %eax
80106eee:	ff 75 10             	pushl  0x10(%ebp)
80106ef1:	e8 2a ad ff ff       	call   80101c20 <readi>
80106ef6:	83 c4 10             	add    $0x10,%esp
80106ef9:	39 f8                	cmp    %edi,%eax
80106efb:	74 ab                	je     80106ea8 <loaduvm+0x28>
}
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f13:	31 c0                	xor    %eax,%eax
}
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f1a:	83 ec 0c             	sub    $0xc,%esp
80106f1d:	68 43 7f 10 80       	push   $0x80107f43
80106f22:	e8 69 95 ff ff       	call   80100490 <panic>
    panic("loaduvm: addr must be page aligned");
80106f27:	83 ec 0c             	sub    $0xc,%esp
80106f2a:	68 b0 7f 10 80       	push   $0x80107fb0
80106f2f:	e8 5c 95 ff ff       	call   80100490 <panic>
80106f34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f40 <allocuvm>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f49:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f4c:	85 ff                	test   %edi,%edi
80106f4e:	78 76                	js     80106fc6 <allocuvm+0x86>
  if(newsz < oldsz)
80106f50:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f53:	0f 82 7f 00 00 00    	jb     80106fd8 <allocuvm+0x98>
  a = PGROUNDUP(oldsz);
80106f59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f5c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f62:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f68:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f6b:	76 6e                	jbe    80106fdb <allocuvm+0x9b>
80106f6d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f70:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f73:	eb 3e                	jmp    80106fb3 <allocuvm+0x73>
80106f75:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106f78:	83 ec 04             	sub    $0x4,%esp
80106f7b:	68 00 10 00 00       	push   $0x1000
80106f80:	6a 00                	push   $0x0
80106f82:	50                   	push   %eax
80106f83:	e8 58 d7 ff ff       	call   801046e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f88:	58                   	pop    %eax
80106f89:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f8f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f94:	5a                   	pop    %edx
80106f95:	6a 06                	push   $0x6
80106f97:	50                   	push   %eax
80106f98:	89 da                	mov    %ebx,%edx
80106f9a:	89 f8                	mov    %edi,%eax
80106f9c:	e8 6f fb ff ff       	call   80106b10 <mappages>
80106fa1:	83 c4 10             	add    $0x10,%esp
80106fa4:	85 c0                	test   %eax,%eax
80106fa6:	78 40                	js     80106fe8 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106fa8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fae:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fb1:	76 65                	jbe    80107018 <allocuvm+0xd8>
    mem = kalloc();
80106fb3:	e8 b8 b7 ff ff       	call   80102770 <kalloc>
    if(mem == 0){
80106fb8:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106fba:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106fbc:	75 ba                	jne    80106f78 <allocuvm+0x38>
  if(newsz >= oldsz)
80106fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc1:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fc4:	77 62                	ja     80107028 <allocuvm+0xe8>
}
80106fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106fc9:	31 ff                	xor    %edi,%edi
}
80106fcb:	89 f8                	mov    %edi,%eax
80106fcd:	5b                   	pop    %ebx
80106fce:	5e                   	pop    %esi
80106fcf:	5f                   	pop    %edi
80106fd0:	5d                   	pop    %ebp
80106fd1:	c3                   	ret    
80106fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
80106fd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fde:	89 f8                	mov    %edi,%eax
80106fe0:	5b                   	pop    %ebx
80106fe1:	5e                   	pop    %esi
80106fe2:	5f                   	pop    %edi
80106fe3:	5d                   	pop    %ebp
80106fe4:	c3                   	ret    
80106fe5:	8d 76 00             	lea    0x0(%esi),%esi
  if(newsz >= oldsz)
80106fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106feb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fee:	76 0d                	jbe    80106ffd <allocuvm+0xbd>
80106ff0:	89 c1                	mov    %eax,%ecx
80106ff2:	8b 55 10             	mov    0x10(%ebp),%edx
80106ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff8:	e8 a3 fb ff ff       	call   80106ba0 <deallocuvm.part.0>
      kfree(mem);
80106ffd:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107000:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107002:	56                   	push   %esi
80107003:	e8 b8 b5 ff ff       	call   801025c0 <kfree>
      return 0;
80107008:	83 c4 10             	add    $0x10,%esp
}
8010700b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010700e:	89 f8                	mov    %edi,%eax
80107010:	5b                   	pop    %ebx
80107011:	5e                   	pop    %esi
80107012:	5f                   	pop    %edi
80107013:	5d                   	pop    %ebp
80107014:	c3                   	ret    
80107015:	8d 76 00             	lea    0x0(%esi),%esi
80107018:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010701b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010701e:	5b                   	pop    %ebx
8010701f:	89 f8                	mov    %edi,%eax
80107021:	5e                   	pop    %esi
80107022:	5f                   	pop    %edi
80107023:	5d                   	pop    %ebp
80107024:	c3                   	ret    
80107025:	8d 76 00             	lea    0x0(%esi),%esi
80107028:	89 c1                	mov    %eax,%ecx
8010702a:	8b 55 10             	mov    0x10(%ebp),%edx
8010702d:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107030:	31 ff                	xor    %edi,%edi
80107032:	e8 69 fb ff ff       	call   80106ba0 <deallocuvm.part.0>
80107037:	eb a2                	jmp    80106fdb <allocuvm+0x9b>
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107040 <deallocuvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	8b 55 0c             	mov    0xc(%ebp),%edx
80107046:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107049:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010704c:	39 d1                	cmp    %edx,%ecx
8010704e:	73 10                	jae    80107060 <deallocuvm+0x20>
}
80107050:	5d                   	pop    %ebp
80107051:	e9 4a fb ff ff       	jmp    80106ba0 <deallocuvm.part.0>
80107056:	8d 76 00             	lea    0x0(%esi),%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107060:	89 d0                	mov    %edx,%eax
80107062:	5d                   	pop    %ebp
80107063:	c3                   	ret    
80107064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010706a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107070 <select_a_victim>:
// Select a page-table entry which is mapped
// but not accessed. Notice that the user memory
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	56                   	push   %esi
80107074:	53                   	push   %ebx
80107075:	8b 75 08             	mov    0x8(%ebp),%esi
	
  uint uviraddr;
  pte_t * prob_victim;
  for (uviraddr = 10*PGSIZE; uviraddr < KERNBASE; uviraddr+=PGSIZE)
80107078:	bb 00 a0 00 00       	mov    $0xa000,%ebx
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
  return walkpgdir(pgdir, (void*)uva, 0);
80107080:	31 c9                	xor    %ecx,%ecx
80107082:	89 da                	mov    %ebx,%edx
80107084:	89 f0                	mov    %esi,%eax
80107086:	e8 05 fa ff ff       	call   80106a90 <walkpgdir>
     if (prob_victim==0)
8010708b:	85 c0                	test   %eax,%eax
8010708d:	74 0d                	je     8010709c <select_a_victim+0x2c>
     if ( (((*prob_victim) & PTE_P) == PTE_P)  &&  (((*prob_victim)&PTE_A) == 0)  &&  (((*prob_victim)&PTE_W) == PTE_W)  &&  (((*prob_victim)&PTE_U) == PTE_U) && (((*prob_victim)&PTE_FF) == 0))
8010708f:	8b 10                	mov    (%eax),%edx
80107091:	81 e2 27 04 00 00    	and    $0x427,%edx
80107097:	83 fa 07             	cmp    $0x7,%edx
8010709a:	74 0a                	je     801070a6 <select_a_victim+0x36>
  for (uviraddr = 10*PGSIZE; uviraddr < KERNBASE; uviraddr+=PGSIZE)
8010709c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070a2:	79 dc                	jns    80107080 <select_a_victim+0x10>
  return 0;
801070a4:	31 c0                	xor    %eax,%eax
}
801070a6:	5b                   	pop    %ebx
801070a7:	5e                   	pop    %esi
801070a8:	5d                   	pop    %ebp
801070a9:	c3                   	ret    
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070b0 <clearaccessbit>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	56                   	push   %esi
801070b4:	53                   	push   %ebx
801070b5:	8b 75 08             	mov    0x8(%ebp),%esi
  for (uviraddr = 10*PGSIZE; uviraddr < KERNBASE; uviraddr+=PGSIZE)
801070b8:	bb 00 a0 00 00       	mov    $0xa000,%ebx
801070bd:	8d 76 00             	lea    0x0(%esi),%esi
  return walkpgdir(pgdir, (void*)uva, 0);
801070c0:	31 c9                	xor    %ecx,%ecx
801070c2:	89 da                	mov    %ebx,%edx
801070c4:	89 f0                	mov    %esi,%eax
801070c6:	e8 c5 f9 ff ff       	call   80106a90 <walkpgdir>
     if (prob_victim==0)
801070cb:	85 c0                	test   %eax,%eax
801070cd:	74 0c                	je     801070db <clearaccessbit+0x2b>
     if ( (((*prob_victim)&PTE_P) == PTE_P) && (((*prob_victim)&PTE_A) == PTE_A) && (((*prob_victim)&PTE_W) == PTE_W)  &&  (((*prob_victim)&PTE_U) == PTE_U))
801070cf:	8b 10                	mov    (%eax),%edx
801070d1:	89 d1                	mov    %edx,%ecx
801070d3:	83 e1 27             	and    $0x27,%ecx
801070d6:	83 f9 27             	cmp    $0x27,%ecx
801070d9:	74 15                	je     801070f0 <clearaccessbit+0x40>
  for (uviraddr = 10*PGSIZE; uviraddr < KERNBASE; uviraddr+=PGSIZE)
801070db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070e1:	79 dd                	jns    801070c0 <clearaccessbit+0x10>
}
801070e3:	5b                   	pop    %ebx
801070e4:	5e                   	pop    %esi
801070e5:	5d                   	pop    %ebp
801070e6:	c3                   	ret    
801070e7:	89 f6                	mov    %esi,%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        *prob_victim &= ~PTE_A;
801070f0:	83 e2 df             	and    $0xffffffdf,%edx
801070f3:	89 10                	mov    %edx,(%eax)
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5d                   	pop    %ebp
801070f8:	c3                   	ret    
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107100 <getswappedblk>:
{
80107100:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80107101:	31 c9                	xor    %ecx,%ecx
{
80107103:	89 e5                	mov    %esp,%ebp
80107105:	83 ec 08             	sub    $0x8,%esp
  return walkpgdir(pgdir, (void*)uva, 0);
80107108:	8b 55 0c             	mov    0xc(%ebp),%edx
8010710b:	8b 45 08             	mov    0x8(%ebp),%eax
8010710e:	e8 7d f9 ff ff       	call   80106a90 <walkpgdir>
  if (((*swap_pte) & PTE_SW) == PTE_SW) // may require extra chek for swap+pte
80107113:	8b 00                	mov    (%eax),%eax
80107115:	f6 c4 02             	test   $0x2,%ah
80107118:	74 06                	je     80107120 <getswappedblk+0x20>
    int to_ret = (int) *swap_pte >> 12;
8010711a:	c1 f8 0c             	sar    $0xc,%eax
}
8010711d:	c9                   	leave  
8010711e:	c3                   	ret    
8010711f:	90                   	nop
 return -1;
80107120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107125:	c9                   	leave  
80107126:	c3                   	ret    
80107127:	89 f6                	mov    %esi,%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107130 <clearpteu>:
{
80107130:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107131:	31 c9                	xor    %ecx,%ecx
{
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107138:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713b:	8b 45 08             	mov    0x8(%ebp),%eax
8010713e:	e8 4d f9 ff ff       	call   80106a90 <walkpgdir>
  if(pte == 0)
80107143:	85 c0                	test   %eax,%eax
80107145:	74 05                	je     8010714c <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107147:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010714a:	c9                   	leave  
8010714b:	c3                   	ret    
    panic("clearpteu");
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	68 61 7f 10 80       	push   $0x80107f61
80107154:	e8 37 93 ff ff       	call   80100490 <panic>
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107160 <uva2ka>:
{
80107160:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107161:	31 c9                	xor    %ecx,%ecx
{
80107163:	89 e5                	mov    %esp,%ebp
80107165:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107168:	8b 55 0c             	mov    0xc(%ebp),%edx
8010716b:	8b 45 08             	mov    0x8(%ebp),%eax
8010716e:	e8 1d f9 ff ff       	call   80106a90 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107173:	8b 00                	mov    (%eax),%eax
}
80107175:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107176:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010717d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107180:	05 00 00 00 80       	add    $0x80000000,%eax
80107185:	83 fa 05             	cmp    $0x5,%edx
80107188:	ba 00 00 00 00       	mov    $0x0,%edx
8010718d:	0f 45 c2             	cmovne %edx,%eax
}
80107190:	c3                   	ret    
80107191:	eb 0d                	jmp    801071a0 <uva2pte>
80107193:	90                   	nop
80107194:	90                   	nop
80107195:	90                   	nop
80107196:	90                   	nop
80107197:	90                   	nop
80107198:	90                   	nop
80107199:	90                   	nop
8010719a:	90                   	nop
8010719b:	90                   	nop
8010719c:	90                   	nop
8010719d:	90                   	nop
8010719e:	90                   	nop
8010719f:	90                   	nop

801071a0 <uva2pte>:
{
801071a0:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801071a1:	31 c9                	xor    %ecx,%ecx
{
801071a3:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801071a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801071a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801071ab:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801071ac:	e9 df f8 ff ff       	jmp    80106a90 <walkpgdir>
801071b1:	eb 0d                	jmp    801071c0 <copyout>
801071b3:	90                   	nop
801071b4:	90                   	nop
801071b5:	90                   	nop
801071b6:	90                   	nop
801071b7:	90                   	nop
801071b8:	90                   	nop
801071b9:	90                   	nop
801071ba:	90                   	nop
801071bb:	90                   	nop
801071bc:	90                   	nop
801071bd:	90                   	nop
801071be:	90                   	nop
801071bf:	90                   	nop

801071c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
801071c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801071cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071d2:	85 db                	test   %ebx,%ebx
801071d4:	75 40                	jne    80107216 <copyout+0x56>
801071d6:	eb 70                	jmp    80107248 <copyout+0x88>
801071d8:	90                   	nop
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801071e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071e3:	89 f1                	mov    %esi,%ecx
801071e5:	29 d1                	sub    %edx,%ecx
801071e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801071ed:	39 d9                	cmp    %ebx,%ecx
801071ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071f2:	29 f2                	sub    %esi,%edx
801071f4:	83 ec 04             	sub    $0x4,%esp
801071f7:	01 d0                	add    %edx,%eax
801071f9:	51                   	push   %ecx
801071fa:	57                   	push   %edi
801071fb:	50                   	push   %eax
801071fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801071ff:	e8 8c d5 ff ff       	call   80104790 <memmove>
    len -= n;
    buf += n;
80107204:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107207:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010720a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107210:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107212:	29 cb                	sub    %ecx,%ebx
80107214:	74 32                	je     80107248 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107216:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107218:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010721b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010721e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107224:	56                   	push   %esi
80107225:	ff 75 08             	pushl  0x8(%ebp)
80107228:	e8 33 ff ff ff       	call   80107160 <uva2ka>
    if(pa0 == 0)
8010722d:	83 c4 10             	add    $0x10,%esp
80107230:	85 c0                	test   %eax,%eax
80107232:	75 ac                	jne    801071e0 <copyout+0x20>
  }
  return 0;
}
80107234:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010723c:	5b                   	pop    %ebx
8010723d:	5e                   	pop    %esi
8010723e:	5f                   	pop    %edi
8010723f:	5d                   	pop    %ebp
80107240:	c3                   	ret    
80107241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010724b:	31 c0                	xor    %eax,%eax
}
8010724d:	5b                   	pop    %ebx
8010724e:	5e                   	pop    %esi
8010724f:	5f                   	pop    %edi
80107250:	5d                   	pop    %ebp
80107251:	c3                   	ret    
80107252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <allocuserpage>:

int allocuserpage(pde_t *pgdir, void *va, uint size, uint pa, int perm){
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
  return mappages(pgdir, va, size, pa, perm);
80107263:	8b 4d 18             	mov    0x18(%ebp),%ecx
int allocuserpage(pde_t *pgdir, void *va, uint size, uint pa, int perm){
80107266:	8b 55 0c             	mov    0xc(%ebp),%edx
80107269:	8b 45 08             	mov    0x8(%ebp),%eax
  return mappages(pgdir, va, size, pa, perm);
8010726c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010726f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107272:	89 4d 08             	mov    %ecx,0x8(%ebp)
80107275:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
80107278:	5d                   	pop    %ebp
  return mappages(pgdir, va, size, pa, perm);
80107279:	e9 92 f8 ff ff       	jmp    80106b10 <mappages>
8010727e:	66 90                	xchg   %ax,%ax

80107280 <uva2pte_1>:
pte_t*
uva2pte_1(pde_t *pgdir, uint uva)
{
80107280:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 1);
80107281:	b9 01 00 00 00       	mov    $0x1,%ecx
{
80107286:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 1);
80107288:	8b 55 0c             	mov    0xc(%ebp),%edx
8010728b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010728e:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 1);
8010728f:	e9 fc f7 ff ff       	jmp    80106a90 <walkpgdir>
80107294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010729a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072a0 <free_swap_Space_on_exit>:

void free_swap_Space_on_exit(pde_t * pgdir)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
    int to_ret = (int) *swap_pte >> 12;
801072a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  uint uviraddr;
  pte_t * prob_victim;
  for (uviraddr = 0; uviraddr < KERNBASE; uviraddr+=PGSIZE)
801072ab:	31 db                	xor    %ebx,%ebx
{
801072ad:	83 ec 0c             	sub    $0xc,%esp
801072b0:	8b 75 08             	mov    0x8(%ebp),%esi
801072b3:	eb 0b                	jmp    801072c0 <free_swap_Space_on_exit+0x20>
801072b5:	8d 76 00             	lea    0x0(%esi),%esi
  for (uviraddr = 0; uviraddr < KERNBASE; uviraddr+=PGSIZE)
801072b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072be:	78 4b                	js     8010730b <free_swap_Space_on_exit+0x6b>
  return walkpgdir(pgdir, (void*)uva, 0);
801072c0:	31 c9                	xor    %ecx,%ecx
801072c2:	89 da                	mov    %ebx,%edx
801072c4:	89 f0                	mov    %esi,%eax
801072c6:	e8 c5 f7 ff ff       	call   80106a90 <walkpgdir>
  {
    prob_victim = uva2pte(pgdir, uviraddr);

     
     if (prob_victim==0)
801072cb:	85 c0                	test   %eax,%eax
801072cd:	74 e9                	je     801072b8 <free_swap_Space_on_exit+0x18>
     {
        continue;
     }
     if ( (((*prob_victim) & PTE_P) == 0)   &&  (((*prob_victim)&PTE_SW) == PTE_SW))
801072cf:	8b 00                	mov    (%eax),%eax
801072d1:	25 01 02 00 00       	and    $0x201,%eax
801072d6:	3d 00 02 00 00       	cmp    $0x200,%eax
801072db:	75 db                	jne    801072b8 <free_swap_Space_on_exit+0x18>
  return walkpgdir(pgdir, (void*)uva, 0);
801072dd:	31 c9                	xor    %ecx,%ecx
801072df:	89 da                	mov    %ebx,%edx
801072e1:	89 f0                	mov    %esi,%eax
801072e3:	e8 a8 f7 ff ff       	call   80106a90 <walkpgdir>
  if (((*swap_pte) & PTE_SW) == PTE_SW) // may require extra chek for swap+pte
801072e8:	8b 10                	mov    (%eax),%edx
    int to_ret = (int) *swap_pte >> 12;
801072ea:	89 d0                	mov    %edx,%eax
801072ec:	c1 f8 0c             	sar    $0xc,%eax
801072ef:	80 e6 02             	and    $0x2,%dh
801072f2:	0f 44 c7             	cmove  %edi,%eax
     {
        int bno = getswappedblk(pgdir, uviraddr);
        //cprintf("%d\n",bno);
        bfree_page(ROOTDEV, bno);
801072f5:	83 ec 08             	sub    $0x8,%esp
801072f8:	50                   	push   %eax
801072f9:	6a 01                	push   $0x1
801072fb:	e8 b0 a3 ff ff       	call   801016b0 <bfree_page>
80107300:	83 c4 10             	add    $0x10,%esp
  for (uviraddr = 0; uviraddr < KERNBASE; uviraddr+=PGSIZE)
80107303:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107309:	79 b5                	jns    801072c0 <free_swap_Space_on_exit+0x20>
     }
    
  }
}
8010730b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730e:	5b                   	pop    %ebx
8010730f:	5e                   	pop    %esi
80107310:	5f                   	pop    %edi
80107311:	5d                   	pop    %ebp
80107312:	c3                   	ret    
80107313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <freevm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
8010732c:	85 f6                	test   %esi,%esi
8010732e:	74 61                	je     80107391 <freevm+0x71>
  free_swap_Space_on_exit(pgdir);
80107330:	83 ec 0c             	sub    $0xc,%esp
80107333:	89 f3                	mov    %esi,%ebx
80107335:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010733b:	56                   	push   %esi
8010733c:	e8 5f ff ff ff       	call   801072a0 <free_swap_Space_on_exit>
80107341:	31 c9                	xor    %ecx,%ecx
80107343:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107348:	89 f0                	mov    %esi,%eax
8010734a:	e8 51 f8 ff ff       	call   80106ba0 <deallocuvm.part.0>
8010734f:	83 c4 10             	add    $0x10,%esp
80107352:	eb 0b                	jmp    8010735f <freevm+0x3f>
80107354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107358:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
8010735b:	39 fb                	cmp    %edi,%ebx
8010735d:	74 23                	je     80107382 <freevm+0x62>
    if(pgdir[i] & PTE_P){
8010735f:	8b 03                	mov    (%ebx),%eax
80107361:	a8 01                	test   $0x1,%al
80107363:	74 f3                	je     80107358 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010736a:	83 ec 0c             	sub    $0xc,%esp
8010736d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107370:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107375:	50                   	push   %eax
80107376:	e8 45 b2 ff ff       	call   801025c0 <kfree>
8010737b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010737e:	39 fb                	cmp    %edi,%ebx
80107380:	75 dd                	jne    8010735f <freevm+0x3f>
  kfree((char*)pgdir);
80107382:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107388:	5b                   	pop    %ebx
80107389:	5e                   	pop    %esi
8010738a:	5f                   	pop    %edi
8010738b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
8010738c:	e9 2f b2 ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
80107391:	83 ec 0c             	sub    $0xc,%esp
80107394:	68 6b 7f 10 80       	push   $0x80107f6b
80107399:	e8 f2 90 ff ff       	call   80100490 <panic>
8010739e:	66 90                	xchg   %ax,%ax

801073a0 <setupkvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	56                   	push   %esi
801073a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073a5:	e8 c6 b3 ff ff       	call   80102770 <kalloc>
801073aa:	85 c0                	test   %eax,%eax
801073ac:	89 c6                	mov    %eax,%esi
801073ae:	74 42                	je     801073f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073b3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801073b8:	68 00 10 00 00       	push   $0x1000
801073bd:	6a 00                	push   $0x0
801073bf:	50                   	push   %eax
801073c0:	e8 1b d3 ff ff       	call   801046e0 <memset>
801073c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073ce:	83 ec 08             	sub    $0x8,%esp
801073d1:	8b 13                	mov    (%ebx),%edx
801073d3:	ff 73 0c             	pushl  0xc(%ebx)
801073d6:	50                   	push   %eax
801073d7:	29 c1                	sub    %eax,%ecx
801073d9:	89 f0                	mov    %esi,%eax
801073db:	e8 30 f7 ff ff       	call   80106b10 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	85 c0                	test   %eax,%eax
801073e5:	78 19                	js     80107400 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e7:	83 c3 10             	add    $0x10,%ebx
801073ea:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801073f0:	75 d6                	jne    801073c8 <setupkvm+0x28>
}
801073f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073f5:	89 f0                	mov    %esi,%eax
801073f7:	5b                   	pop    %ebx
801073f8:	5e                   	pop    %esi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret    
801073fb:	90                   	nop
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	56                   	push   %esi
      return 0;
80107404:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107406:	e8 15 ff ff ff       	call   80107320 <freevm>
      return 0;
8010740b:	83 c4 10             	add    $0x10,%esp
}
8010740e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107411:	89 f0                	mov    %esi,%eax
80107413:	5b                   	pop    %ebx
80107414:	5e                   	pop    %esi
80107415:	5d                   	pop    %ebp
80107416:	c3                   	ret    
80107417:	89 f6                	mov    %esi,%esi
80107419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107420 <kvmalloc>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107426:	e8 75 ff ff ff       	call   801073a0 <setupkvm>
8010742b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	0f 22 d8             	mov    %eax,%cr3
}
80107438:	c9                   	leave  
80107439:	c3                   	ret    
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <copyuvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((d = setupkvm()) == 0) //assuming while doing setupkvm we will not run out of physical memory.
8010744c:	e8 4f ff ff ff       	call   801073a0 <setupkvm>
80107451:	85 c0                	test   %eax,%eax
80107453:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107456:	0f 84 bf 00 00 00    	je     8010751b <copyuvm+0xdb>
  for(i = 0; i < sz; i += PGSIZE){
8010745c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010745f:	85 c9                	test   %ecx,%ecx
80107461:	0f 84 b4 00 00 00    	je     8010751b <copyuvm+0xdb>
80107467:	31 f6                	xor    %esi,%esi
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107470:	31 c9                	xor    %ecx,%ecx
80107472:	89 f2                	mov    %esi,%edx
80107474:	89 f8                	mov    %edi,%eax
80107476:	e8 15 f6 ff ff       	call   80106a90 <walkpgdir>
8010747b:	85 c0                	test   %eax,%eax
8010747d:	89 c3                	mov    %eax,%ebx
8010747f:	0f 84 f3 00 00 00    	je     80107578 <copyuvm+0x138>
    if(!(*pte & PTE_P))
80107485:	8b 00                	mov    (%eax),%eax
80107487:	a8 01                	test   $0x1,%al
80107489:	0f 84 a1 00 00 00    	je     80107530 <copyuvm+0xf0>
    *pte = *pte | PTE_FF;
8010748f:	89 c2                	mov    %eax,%edx
80107491:	89 c1                	mov    %eax,%ecx
    flags = PTE_FLAGS(*pte);
80107493:	25 ff 0f 00 00       	and    $0xfff,%eax
    *pte = *pte | PTE_FF;
80107498:	80 ce 04             	or     $0x4,%dh
8010749b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    flags = PTE_FLAGS(*pte);
801074a1:	80 cc 04             	or     $0x4,%ah
    *pte = *pte | PTE_FF;
801074a4:	89 13                	mov    %edx,(%ebx)
801074a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
801074a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while ((mem = kalloc())==0)
801074ac:	eb 0e                	jmp    801074bc <copyuvm+0x7c>
801074ae:	66 90                	xchg   %ax,%ax
      swap_page(pgdir);
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	57                   	push   %edi
801074b4:	e8 07 e8 ff ff       	call   80105cc0 <swap_page>
801074b9:	83 c4 10             	add    $0x10,%esp
    while ((mem = kalloc())==0)
801074bc:	e8 af b2 ff ff       	call   80102770 <kalloc>
801074c1:	85 c0                	test   %eax,%eax
801074c3:	74 eb                	je     801074b0 <copyuvm+0x70>
801074c5:	89 c2                	mov    %eax,%edx
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074ca:	83 ec 04             	sub    $0x4,%esp
801074cd:	68 00 10 00 00       	push   $0x1000
801074d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074d5:	05 00 00 00 80       	add    $0x80000000,%eax
801074da:	50                   	push   %eax
801074db:	52                   	push   %edx
801074dc:	e8 af d2 ff ff       	call   80104790 <memmove>
    *pte = *pte & (~PTE_FF);
801074e1:	81 23 ff fb ff ff    	andl   $0xfffffbff,(%ebx)
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801074e7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074ec:	58                   	pop    %eax
801074ed:	5a                   	pop    %edx
801074ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801074f4:	ff 75 e0             	pushl  -0x20(%ebp)
801074f7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074fd:	52                   	push   %edx
801074fe:	89 f2                	mov    %esi,%edx
80107500:	e8 0b f6 ff ff       	call   80106b10 <mappages>
80107505:	83 c4 10             	add    $0x10,%esp
80107508:	85 c0                	test   %eax,%eax
8010750a:	78 4c                	js     80107558 <copyuvm+0x118>
  for(i = 0; i < sz; i += PGSIZE){
8010750c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107512:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107515:	0f 87 55 ff ff ff    	ja     80107470 <copyuvm+0x30>
}
8010751b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010751e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107521:	5b                   	pop    %ebx
80107522:	5e                   	pop    %esi
80107523:	5f                   	pop    %edi
80107524:	5d                   	pop    %ebp
80107525:	c3                   	ret    
80107526:	8d 76 00             	lea    0x0(%esi),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      get_page_from_disk(pgdir,i);      
80107530:	83 ec 08             	sub    $0x8,%esp
80107533:	56                   	push   %esi
80107534:	57                   	push   %edi
80107535:	e8 46 e8 ff ff       	call   80105d80 <get_page_from_disk>
     if(!(*pte & PTE_P))
8010753a:	8b 03                	mov    (%ebx),%eax
8010753c:	83 c4 10             	add    $0x10,%esp
8010753f:	a8 01                	test   $0x1,%al
80107541:	0f 85 48 ff ff ff    	jne    8010748f <copyuvm+0x4f>
       panic("copyuvm: page not present"); 
80107547:	83 ec 0c             	sub    $0xc,%esp
8010754a:	68 96 7f 10 80       	push   $0x80107f96
8010754f:	e8 3c 8f ff ff       	call   80100490 <panic>
80107554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(d);
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	ff 75 dc             	pushl  -0x24(%ebp)
8010755e:	e8 bd fd ff ff       	call   80107320 <freevm>
  return 0;
80107563:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010756a:	83 c4 10             	add    $0x10,%esp
}
8010756d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107570:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107573:	5b                   	pop    %ebx
80107574:	5e                   	pop    %esi
80107575:	5f                   	pop    %edi
80107576:	5d                   	pop    %ebp
80107577:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107578:	83 ec 0c             	sub    $0xc,%esp
8010757b:	68 7c 7f 10 80       	push   $0x80107f7c
80107580:	e8 0b 8f ff ff       	call   80100490 <panic>

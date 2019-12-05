
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 71 10 80       	push   $0x801071a0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 b5 43 00 00       	call   80104410 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 71 10 80       	push   $0x801071a7
80100097:	50                   	push   %eax
80100098:	e8 43 42 00 00       	call   801042e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 67 44 00 00       	call   80104550 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 a9 44 00 00       	call   80104610 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 41 00 00       	call   80104320 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 1f 00 00       	call   80102160 <iderw>
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
80100193:	68 ae 71 10 80       	push   $0x801071ae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
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
801001ae:	e8 0d 42 00 00       	call   801043c0 <holdingsleep>
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
801001c4:	e9 97 1f 00 00       	jmp    80102160 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 71 10 80       	push   $0x801071bf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
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
801001ef:	e8 cc 41 00 00       	call   801043c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 41 00 00       	call   80104380 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 40 43 00 00       	call   80104550 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 43 00 00       	jmp    80104610 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 71 10 80       	push   $0x801071c6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 bf 42 00 00       	call   80104550 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 f6 3a 00 00       	call   80103dc0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 35 00 00       	call   80103820 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 1c 43 00 00       	call   80104610 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 be 42 00 00       	call   80104610 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 71 10 80       	push   $0x801071cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 6f 7b 10 80 	movl   $0x80107b6f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 40 00 00       	call   80104430 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 71 10 80       	push   $0x801071e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 61 59 00 00       	call   80105da0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 af 58 00 00       	call   80105da0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 a3 58 00 00       	call   80105da0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 97 58 00 00       	call   80105da0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 e7 41 00 00       	call   80104710 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 1a 41 00 00       	call   80104660 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 71 10 80       	push   $0x801071e5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 72 10 80 	movzbl -0x7fef8df0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 30 3f 00 00       	call   80104550 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 c4 3f 00 00       	call   80104610 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 ec 3e 00 00       	call   80104610 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 71 10 80       	mov    $0x801071f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 5b 3d 00 00       	call   80104550 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 71 10 80       	push   $0x801071ff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 28 3d 00 00       	call   80104550 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 83 3d 00 00       	call   80104610 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 65 36 00 00       	call   80103f80 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 c4 36 00 00       	jmp    80104060 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 08 72 10 80       	push   $0x80107208
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 3b 3a 00 00       	call   80104410 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 19 00 00       	call   80102310 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 ff 2d 00 00       	call   80103820 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  struct rtcdate *time = 0;

  begin_op();
80100a27:	e8 b4 21 00 00       	call   80102be0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 e9 14 00 00       	call   80101f20 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 73 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 42 0f 00 00       	call   801019a0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 e1 0e 00 00       	call   80101950 <iunlockput>
    end_op();
80100a6f:	e8 dc 21 00 00       	call   80102c50 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 57 64 00 00       	call   80106ef0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 c9 02 00 00    	je     80100d88 <exec+0x378>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 15 62 00 00       	call   80106d10 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 23 61 00 00       	call   80106c50 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 43 0e 00 00       	call   801019a0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 f9 62 00 00       	call   80106e70 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 b6 0d 00 00       	call   80101950 <iunlockput>
  end_op();
80100b9a:	e8 b1 20 00 00       	call   80102c50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 61 61 00 00       	call   80106d10 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 aa 62 00 00       	call   80106e70 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 78 20 00 00       	call   80102c50 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 72 10 80       	push   $0x80107221
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 85 63 00 00       	call   80106f90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 42 3c 00 00       	call   80104880 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 2f 3c 00 00       	call   80104880 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 8e 64 00 00       	call   801070f0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 24 64 00 00       	call   801070f0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 31 3b 00 00       	call   80104840 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f8                	mov    %edi,%eax
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d1a:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d1c:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100d1e:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d21:	8b 40 18             	mov    0x18(%eax),%eax
80100d24:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2a:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2d:	8b 46 18             	mov    0x18(%esi),%eax
80100d30:	89 58 44             	mov    %ebx,0x44(%eax)
  cmostime(time);
80100d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80100d3a:	e8 11 1b 00 00       	call   80102850 <cmostime>
  curproc->entryTime = time;
80100d3f:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80100d46:	00 00 00 
  curproc->queueNum = 0;
80100d49:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80100d50:	00 00 00 
  curproc->cycleNum = 1;
80100d53:	c7 86 84 00 00 00 01 	movl   $0x1,0x84(%esi)
80100d5a:	00 00 00 
  curproc->ticket = 10;
80100d5d:	c7 46 7c 0a 00 00 00 	movl   $0xa,0x7c(%esi)
  curproc->remainingPriority = 10;
80100d64:	c7 86 8c 00 00 00 00 	movl   $0x41200000,0x8c(%esi)
80100d6b:	00 20 41 
  switchuvm(curproc);
80100d6e:	89 34 24             	mov    %esi,(%esp)
80100d71:	e8 4a 5d 00 00       	call   80106ac0 <switchuvm>
  freevm(oldpgdir);
80100d76:	89 3c 24             	mov    %edi,(%esp)
80100d79:	e8 f2 60 00 00       	call   80106e70 <freevm>
  return 0;
80100d7e:	83 c4 10             	add    $0x10,%esp
80100d81:	31 c0                	xor    %eax,%eax
80100d83:	e9 f4 fc ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d88:	be 00 20 00 00       	mov    $0x2000,%esi
80100d8d:	e9 ff fd ff ff       	jmp    80100b91 <exec+0x181>
80100d92:	66 90                	xchg   %ax,%ax
80100d94:	66 90                	xchg   %ax,%ax
80100d96:	66 90                	xchg   %ax,%ax
80100d98:	66 90                	xchg   %ax,%ax
80100d9a:	66 90                	xchg   %ax,%ax
80100d9c:	66 90                	xchg   %ax,%ax
80100d9e:	66 90                	xchg   %ax,%ax

80100da0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100da6:	68 2d 72 10 80       	push   $0x8010722d
80100dab:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db0:	e8 5b 36 00 00       	call   80104410 <initlock>
}
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	c9                   	leave  
80100db9:	c3                   	ret    
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100dc0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100dc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dcc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dd1:	e8 7a 37 00 00       	call   80104550 <acquire>
80100dd6:	83 c4 10             	add    $0x10,%esp
80100dd9:	eb 10                	jmp    80100deb <filealloc+0x2b>
80100ddb:	90                   	nop
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100de0:	83 c3 18             	add    $0x18,%ebx
80100de3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100de9:	73 25                	jae    80100e10 <filealloc+0x50>
    if(f->ref == 0){
80100deb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dee:	85 c0                	test   %eax,%eax
80100df0:	75 ee                	jne    80100de0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100df2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100df5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dfc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e01:	e8 0a 38 00 00       	call   80104610 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e06:	89 d8                	mov    %ebx,%eax
      return f;
80100e08:	83 c4 10             	add    $0x10,%esp
}
80100e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e0e:	c9                   	leave  
80100e0f:	c3                   	ret    
  release(&ftable.lock);
80100e10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e15:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1a:	e8 f1 37 00 00       	call   80104610 <release>
}
80100e1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e21:	83 c4 10             	add    $0x10,%esp
}
80100e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e27:	c9                   	leave  
80100e28:	c3                   	ret    
80100e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
80100e34:	83 ec 10             	sub    $0x10,%esp
80100e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e3a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e3f:	e8 0c 37 00 00       	call   80104550 <acquire>
  if(f->ref < 1)
80100e44:	8b 43 04             	mov    0x4(%ebx),%eax
80100e47:	83 c4 10             	add    $0x10,%esp
80100e4a:	85 c0                	test   %eax,%eax
80100e4c:	7e 1a                	jle    80100e68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e57:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5c:	e8 af 37 00 00       	call   80104610 <release>
  return f;
}
80100e61:	89 d8                	mov    %ebx,%eax
80100e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e66:	c9                   	leave  
80100e67:	c3                   	ret    
    panic("filedup");
80100e68:	83 ec 0c             	sub    $0xc,%esp
80100e6b:	68 34 72 10 80       	push   $0x80107234
80100e70:	e8 1b f5 ff ff       	call   80100390 <panic>
80100e75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	57                   	push   %edi
80100e84:	56                   	push   %esi
80100e85:	53                   	push   %ebx
80100e86:	83 ec 28             	sub    $0x28,%esp
80100e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e91:	e8 ba 36 00 00       	call   80104550 <acquire>
  if(f->ref < 1)
80100e96:	8b 43 04             	mov    0x4(%ebx),%eax
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	85 c0                	test   %eax,%eax
80100e9e:	0f 8e 9b 00 00 00    	jle    80100f3f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ea4:	83 e8 01             	sub    $0x1,%eax
80100ea7:	85 c0                	test   %eax,%eax
80100ea9:	89 43 04             	mov    %eax,0x4(%ebx)
80100eac:	74 1a                	je     80100ec8 <fileclose+0x48>
    release(&ftable.lock);
80100eae:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ebc:	e9 4f 37 00 00       	jmp    80104610 <release>
80100ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ec8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ecc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ece:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ed1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ed4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eda:	88 45 e7             	mov    %al,-0x19(%ebp)
80100edd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ee0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ee8:	e8 23 37 00 00       	call   80104610 <release>
  if(ff.type == FD_PIPE)
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	83 ff 01             	cmp    $0x1,%edi
80100ef3:	74 13                	je     80100f08 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ef5:	83 ff 02             	cmp    $0x2,%edi
80100ef8:	74 26                	je     80100f20 <fileclose+0xa0>
}
80100efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100efd:	5b                   	pop    %ebx
80100efe:	5e                   	pop    %esi
80100eff:	5f                   	pop    %edi
80100f00:	5d                   	pop    %ebp
80100f01:	c3                   	ret    
80100f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f08:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f0c:	83 ec 08             	sub    $0x8,%esp
80100f0f:	53                   	push   %ebx
80100f10:	56                   	push   %esi
80100f11:	e8 7a 24 00 00       	call   80103390 <pipeclose>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb df                	jmp    80100efa <fileclose+0x7a>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f20:	e8 bb 1c 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100f25:	83 ec 0c             	sub    $0xc,%esp
80100f28:	ff 75 e0             	pushl  -0x20(%ebp)
80100f2b:	e8 c0 08 00 00       	call   801017f0 <iput>
    end_op();
80100f30:	83 c4 10             	add    $0x10,%esp
}
80100f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f36:	5b                   	pop    %ebx
80100f37:	5e                   	pop    %esi
80100f38:	5f                   	pop    %edi
80100f39:	5d                   	pop    %ebp
    end_op();
80100f3a:	e9 11 1d 00 00       	jmp    80102c50 <end_op>
    panic("fileclose");
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	68 3c 72 10 80       	push   $0x8010723c
80100f47:	e8 44 f4 ff ff       	call   80100390 <panic>
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
80100f54:	83 ec 04             	sub    $0x4,%esp
80100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f5a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f5d:	75 31                	jne    80100f90 <filestat+0x40>
    ilock(f->ip);
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	ff 73 10             	pushl  0x10(%ebx)
80100f65:	e8 56 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f6a:	58                   	pop    %eax
80100f6b:	5a                   	pop    %edx
80100f6c:	ff 75 0c             	pushl  0xc(%ebp)
80100f6f:	ff 73 10             	pushl  0x10(%ebx)
80100f72:	e8 f9 09 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f77:	59                   	pop    %ecx
80100f78:	ff 73 10             	pushl  0x10(%ebx)
80100f7b:	e8 20 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f80:	83 c4 10             	add    $0x10,%esp
80100f83:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f88:	c9                   	leave  
80100f89:	c3                   	ret    
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f95:	eb ee                	jmp    80100f85 <filestat+0x35>
80100f97:	89 f6                	mov    %esi,%esi
80100f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fa0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fb6:	74 60                	je     80101018 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fb8:	8b 03                	mov    (%ebx),%eax
80100fba:	83 f8 01             	cmp    $0x1,%eax
80100fbd:	74 41                	je     80101000 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fbf:	83 f8 02             	cmp    $0x2,%eax
80100fc2:	75 5b                	jne    8010101f <fileread+0x7f>
    ilock(f->ip);
80100fc4:	83 ec 0c             	sub    $0xc,%esp
80100fc7:	ff 73 10             	pushl  0x10(%ebx)
80100fca:	e8 f1 06 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcf:	57                   	push   %edi
80100fd0:	ff 73 14             	pushl  0x14(%ebx)
80100fd3:	56                   	push   %esi
80100fd4:	ff 73 10             	pushl  0x10(%ebx)
80100fd7:	e8 c4 09 00 00       	call   801019a0 <readi>
80100fdc:	83 c4 20             	add    $0x20,%esp
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	89 c6                	mov    %eax,%esi
80100fe3:	7e 03                	jle    80100fe8 <fileread+0x48>
      f->off += r;
80100fe5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	ff 73 10             	pushl  0x10(%ebx)
80100fee:	e8 ad 07 00 00       	call   801017a0 <iunlock>
    return r;
80100ff3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	89 f0                	mov    %esi,%eax
80100ffb:	5b                   	pop    %ebx
80100ffc:	5e                   	pop    %esi
80100ffd:	5f                   	pop    %edi
80100ffe:	5d                   	pop    %ebp
80100fff:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101000:	8b 43 0c             	mov    0xc(%ebx),%eax
80101003:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101009:	5b                   	pop    %ebx
8010100a:	5e                   	pop    %esi
8010100b:	5f                   	pop    %edi
8010100c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010100d:	e9 2e 25 00 00       	jmp    80103540 <piperead>
80101012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101018:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010101d:	eb d7                	jmp    80100ff6 <fileread+0x56>
  panic("fileread");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 46 72 10 80       	push   $0x80107246
80101027:	e8 64 f3 ff ff       	call   80100390 <panic>
8010102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101030 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 1c             	sub    $0x1c,%esp
80101039:	8b 75 08             	mov    0x8(%ebp),%esi
8010103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010103f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101043:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101046:	8b 45 10             	mov    0x10(%ebp),%eax
80101049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010104c:	0f 84 aa 00 00 00    	je     801010fc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101052:	8b 06                	mov    (%esi),%eax
80101054:	83 f8 01             	cmp    $0x1,%eax
80101057:	0f 84 c3 00 00 00    	je     80101120 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105d:	83 f8 02             	cmp    $0x2,%eax
80101060:	0f 85 d9 00 00 00    	jne    8010113f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101069:	31 ff                	xor    %edi,%edi
    while(i < n){
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 34                	jg     801010a3 <filewrite+0x73>
8010106f:	e9 9c 00 00 00       	jmp    80101110 <filewrite+0xe0>
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101078:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101081:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101084:	e8 17 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101089:	e8 c2 1b 00 00       	call   80102c50 <end_op>
8010108e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101091:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101094:	39 c3                	cmp    %eax,%ebx
80101096:	0f 85 96 00 00 00    	jne    80101132 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010109c:	01 df                	add    %ebx,%edi
    while(i < n){
8010109e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010a1:	7e 6d                	jle    80101110 <filewrite+0xe0>
      int n1 = n - i;
801010a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010a6:	b8 00 06 00 00       	mov    $0x600,%eax
801010ab:	29 fb                	sub    %edi,%ebx
801010ad:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010b3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010b6:	e8 25 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
801010c1:	e8 fa 05 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c9:	53                   	push   %ebx
801010ca:	ff 76 14             	pushl  0x14(%esi)
801010cd:	01 f8                	add    %edi,%eax
801010cf:	50                   	push   %eax
801010d0:	ff 76 10             	pushl  0x10(%esi)
801010d3:	e8 c8 09 00 00       	call   80101aa0 <writei>
801010d8:	83 c4 20             	add    $0x20,%esp
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 99                	jg     80101078 <filewrite+0x48>
      iunlock(f->ip);
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	ff 76 10             	pushl  0x10(%esi)
801010e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010e8:	e8 b3 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010ed:	e8 5e 1b 00 00       	call   80102c50 <end_op>
      if(r < 0)
801010f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f5:	83 c4 10             	add    $0x10,%esp
801010f8:	85 c0                	test   %eax,%eax
801010fa:	74 98                	je     80101094 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101104:	89 f8                	mov    %edi,%eax
80101106:	5b                   	pop    %ebx
80101107:	5e                   	pop    %esi
80101108:	5f                   	pop    %edi
80101109:	5d                   	pop    %ebp
8010110a:	c3                   	ret    
8010110b:	90                   	nop
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101110:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101113:	75 e7                	jne    801010fc <filewrite+0xcc>
}
80101115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101118:	89 f8                	mov    %edi,%eax
8010111a:	5b                   	pop    %ebx
8010111b:	5e                   	pop    %esi
8010111c:	5f                   	pop    %edi
8010111d:	5d                   	pop    %ebp
8010111e:	c3                   	ret    
8010111f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101120:	8b 46 0c             	mov    0xc(%esi),%eax
80101123:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	5b                   	pop    %ebx
8010112a:	5e                   	pop    %esi
8010112b:	5f                   	pop    %edi
8010112c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010112d:	e9 fe 22 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	68 4f 72 10 80       	push   $0x8010724f
8010113a:	e8 51 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 55 72 10 80       	push   $0x80107255
80101147:	e8 44 f2 ff ff       	call   80100390 <panic>
8010114c:	66 90                	xchg   %ax,%ax
8010114e:	66 90                	xchg   %ax,%ax

80101150 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	56                   	push   %esi
80101154:	53                   	push   %ebx
80101155:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101157:	c1 ea 0c             	shr    $0xc,%edx
8010115a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101160:	83 ec 08             	sub    $0x8,%esp
80101163:	52                   	push   %edx
80101164:	50                   	push   %eax
80101165:	e8 66 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010116a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010116c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010116f:	ba 01 00 00 00       	mov    $0x1,%edx
80101174:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101177:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010117d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101180:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101182:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101187:	85 d1                	test   %edx,%ecx
80101189:	74 25                	je     801011b0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010118b:	f7 d2                	not    %edx
8010118d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101192:	21 ca                	and    %ecx,%edx
80101194:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101198:	56                   	push   %esi
80101199:	e8 12 1c 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010119e:	89 34 24             	mov    %esi,(%esp)
801011a1:	e8 3a f0 ff ff       	call   801001e0 <brelse>
}
801011a6:	83 c4 10             	add    $0x10,%esp
801011a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011ac:	5b                   	pop    %ebx
801011ad:	5e                   	pop    %esi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret    
    panic("freeing free block");
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	68 5f 72 10 80       	push   $0x8010725f
801011b8:	e8 d3 f1 ff ff       	call   80100390 <panic>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi

801011c0 <balloc>:
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	pushl  -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fe:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101215:	bb 01 00 00 00       	mov    $0x1,%ebx
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	85 df                	test   %ebx,%edi
8010122b:	89 fa                	mov    %edi,%edx
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	pushl  -0x1c(%ebp)
80101247:	e8 94 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 72 72 10 80       	push   $0x80107272
80101269:	e8 22 f1 ff ff       	call   80100390 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 2e 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	pushl  -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101297:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129a:	83 c4 0c             	add    $0xc,%esp
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 b6 33 00 00       	call   80104660 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 fe 1a 00 00       	call   80102db0 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 e0 09 11 80       	push   $0x801109e0
801012ea:	e8 61 32 00 00       	call   80104550 <acquire>
801012ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f5:	eb 17                	jmp    8010130e <iget+0x3e>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101306:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010130c:	73 22                	jae    80101330 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101311:	85 c9                	test   %ecx,%ecx
80101313:	7e 04                	jle    80101319 <iget+0x49>
80101315:	39 3b                	cmp    %edi,(%ebx)
80101317:	74 4f                	je     80101368 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e3                	jne    80101300 <iget+0x30>
8010131d:	85 c9                	test   %ecx,%ecx
8010131f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101322:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101328:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010132e:	72 de                	jb     8010130e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 5b                	je     8010138f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 e0 09 11 80       	push   $0x801109e0
8010134f:	e8 bc 32 00 00       	call   80104610 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101368:	39 53 04             	cmp    %edx,0x4(%ebx)
8010136b:	75 ac                	jne    80101319 <iget+0x49>
      release(&icache.lock);
8010136d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101370:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101373:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101375:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010137a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010137d:	e8 8e 32 00 00       	call   80104610 <release>
      return ip;
80101382:	83 c4 10             	add    $0x10,%esp
}
80101385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
    panic("iget: no inodes");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 88 72 10 80       	push   $0x80107288
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	89 c6                	mov    %eax,%esi
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	77 18                	ja     801013c8 <bmap+0x28>
801013b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013b6:	85 db                	test   %ebx,%ebx
801013b8:	74 76                	je     80101430 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013cb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ce:	0f 87 90 00 00 00    	ja     80101464 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013da:	8b 00                	mov    (%eax),%eax
801013dc:	85 d2                	test   %edx,%edx
801013de:	74 70                	je     80101450 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 e6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013f3:	8b 1a                	mov    (%edx),%ebx
801013f5:	85 db                	test   %ebx,%ebx
801013f7:	75 1d                	jne    80101416 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013f9:	8b 06                	mov    (%esi),%eax
801013fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fe:	e8 bd fd ff ff       	call   801011c0 <balloc>
80101403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101409:	89 c3                	mov    %eax,%ebx
8010140b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140d:	57                   	push   %edi
8010140e:	e8 9d 19 00 00       	call   80102db0 <log_write>
80101413:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101416:	83 ec 0c             	sub    $0xc,%esp
80101419:	57                   	push   %edi
8010141a:	e8 c1 ed ff ff       	call   801001e0 <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	89 d8                	mov    %ebx,%eax
80101427:	5b                   	pop    %ebx
80101428:	5e                   	pop    %esi
80101429:	5f                   	pop    %edi
8010142a:	5d                   	pop    %ebp
8010142b:	c3                   	ret    
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101430:	8b 00                	mov    (%eax),%eax
80101432:	e8 89 fd ff ff       	call   801011c0 <balloc>
80101437:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010143d:	89 c3                	mov    %eax,%ebx
}
8010143f:	89 d8                	mov    %ebx,%eax
80101441:	5b                   	pop    %ebx
80101442:	5e                   	pop    %esi
80101443:	5f                   	pop    %edi
80101444:	5d                   	pop    %ebp
80101445:	c3                   	ret    
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101450:	e8 6b fd ff ff       	call   801011c0 <balloc>
80101455:	89 c2                	mov    %eax,%edx
80101457:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010145d:	8b 06                	mov    (%esi),%eax
8010145f:	e9 7c ff ff ff       	jmp    801013e0 <bmap+0x40>
  panic("bmap: out of range");
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	68 98 72 10 80       	push   $0x80107298
8010146c:	e8 1f ef ff ff       	call   80100390 <panic>
80101471:	eb 0d                	jmp    80101480 <readsb>
80101473:	90                   	nop
80101474:	90                   	nop
80101475:	90                   	nop
80101476:	90                   	nop
80101477:	90                   	nop
80101478:	90                   	nop
80101479:	90                   	nop
8010147a:	90                   	nop
8010147b:	90                   	nop
8010147c:	90                   	nop
8010147d:	90                   	nop
8010147e:	90                   	nop
8010147f:	90                   	nop

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 6a 32 00 00       	call   80104710 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 ab 72 10 80       	push   $0x801072ab
801014d1:	68 e0 09 11 80       	push   $0x801109e0
801014d6:	e8 35 2f 00 00       	call   80104410 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 b2 72 10 80       	push   $0x801072b2
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 ec 2d 00 00       	call   801042e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 c0 09 11 80       	push   $0x801109c0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 71 ff ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101515:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010151b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101521:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101527:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010152d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101533:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101539:	68 18 73 10 80       	push   $0x80107318
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 8d 30 00 00       	call   80104660 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 cb 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fb:	e9 d0 fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 b8 72 10 80       	push   $0x801072b8
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 9a 30 00 00       	call   80104710 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 32 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
  brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	68 e0 09 11 80       	push   $0x801109e0
8010169f:	e8 ac 2e 00 00       	call   80104550 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016af:	e8 5c 2f 00 00       	call   80104610 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 39 2c 00 00       	call   80104320 <acquiresleep>
  if(ip->valid == 0){
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 b3 2f 00 00       	call   80104710 <memmove>
    brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
      panic("ilock: no type");
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 d0 72 10 80       	push   $0x801072d0
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 ca 72 10 80       	push   $0x801072ca
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 08 2c 00 00       	call   801043c0 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017cf:	e9 ac 2b 00 00       	jmp    80104380 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 df 72 10 80       	push   $0x801072df
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 1b 2b 00 00       	call   80104320 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
  releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 61 2b 00 00       	call   80104380 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101826:	e8 25 2d 00 00       	call   80104550 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 cb 2d 00 00       	jmp    80104610 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 e0 09 11 80       	push   $0x801109e0
80101850:	e8 fb 2c 00 00       	call   80104550 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010185f:	e8 ac 2d 00 00       	call   80104610 <release>
    if(r == 1){
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 bc f8 ff ff       	call   80101150 <bfree>
      ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
      if(a[j])
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
        bfree(ip->dev, a[j]);
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 34 f8 ff ff       	call   80101150 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
    brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 17 f8 ff ff       	call   80101150 <bfree>
    ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 91 f9 ff ff       	call   801013a0 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a47:	e8 c4 2c 00 00       	call   80104710 <memmove>
    brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
  }
  return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
      return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 91 f8 ff ff       	call   801013a0 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 c8 2b 00 00       	call   80104710 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 60 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 9d 2b 00 00       	call   80104780 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 3e 2b 00 00       	call   80104780 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
        *poff = off;
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 59 f6 ff ff       	call   801012d0 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
      panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 f9 72 10 80       	push   $0x801072f9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 e7 72 10 80       	push   $0x801072e7
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 62 1b 00 00       	call   80103820 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 e0 09 11 80       	push   $0x801109e0
80101cc9:	e8 82 28 00 00       	call   80104550 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd9:	e8 32 29 00 00       	call   80104610 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
  if(*path == 0)
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
    path++;
80101d14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 d6 29 00 00       	call   80104710 <memmove>
    path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
  iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 43 29 00 00       	call   80104710 <memmove>
    name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
      return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 a1 f4 ff ff       	call   801012d0 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
      iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
      return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
    iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
    return 0;
80101e50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 1e 29 00 00       	call   801047e0 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 08 73 10 80       	push   $0x80107308
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 2e 79 10 80       	push   $0x8010792e
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f69:	85 c0                	test   %eax,%eax
80101f6b:	0f 84 b4 00 00 00    	je     80102025 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f71:	8b 58 08             	mov    0x8(%eax),%ebx
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f7c:	0f 87 96 00 00 00    	ja     80102018 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f82:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f90:	89 ca                	mov    %ecx,%edx
80101f92:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f93:	83 e0 c0             	and    $0xffffffc0,%eax
80101f96:	3c 40                	cmp    $0x40,%al
80101f98:	75 f6                	jne    80101f90 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f9a:	31 ff                	xor    %edi,%edi
80101f9c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa1:	89 f8                	mov    %edi,%eax
80101fa3:	ee                   	out    %al,(%dx)
80101fa4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fae:	ee                   	out    %al,(%dx)
80101faf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fb4:	89 d8                	mov    %ebx,%eax
80101fb6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fb7:	89 d8                	mov    %ebx,%eax
80101fb9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fbe:	c1 f8 08             	sar    $0x8,%eax
80101fc1:	ee                   	out    %al,(%dx)
80101fc2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fc7:	89 f8                	mov    %edi,%eax
80101fc9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fce:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fd3:	c1 e0 04             	shl    $0x4,%eax
80101fd6:	83 e0 10             	and    $0x10,%eax
80101fd9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fdc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fdd:	f6 06 04             	testb  $0x4,(%esi)
80101fe0:	75 16                	jne    80101ff8 <idestart+0x98>
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	89 ca                	mov    %ecx,%edx
80101fe9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fed:	5b                   	pop    %ebx
80101fee:	5e                   	pop    %esi
80101fef:	5f                   	pop    %edi
80101ff0:	5d                   	pop    %ebp
80101ff1:	c3                   	ret    
80101ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ff8:	b8 30 00 00 00       	mov    $0x30,%eax
80101ffd:	89 ca                	mov    %ecx,%edx
80101fff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102000:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102005:	83 c6 5c             	add    $0x5c,%esi
80102008:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010200d:	fc                   	cld    
8010200e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102013:	5b                   	pop    %ebx
80102014:	5e                   	pop    %esi
80102015:	5f                   	pop    %edi
80102016:	5d                   	pop    %ebp
80102017:	c3                   	ret    
    panic("incorrect blockno");
80102018:	83 ec 0c             	sub    $0xc,%esp
8010201b:	68 74 73 10 80       	push   $0x80107374
80102020:	e8 6b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	68 6b 73 10 80       	push   $0x8010736b
8010202d:	e8 5e e3 ff ff       	call   80100390 <panic>
80102032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <ideinit>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102046:	68 86 73 10 80       	push   $0x80107386
8010204b:	68 80 a5 10 80       	push   $0x8010a580
80102050:	e8 bb 23 00 00       	call   80104410 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102055:	58                   	pop    %eax
80102056:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010205b:	5a                   	pop    %edx
8010205c:	83 e8 01             	sub    $0x1,%eax
8010205f:	50                   	push   %eax
80102060:	6a 0e                	push   $0xe
80102062:	e8 a9 02 00 00       	call   80102310 <ioapicenable>
80102067:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010206a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206f:	90                   	nop
80102070:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102071:	83 e0 c0             	and    $0xffffffc0,%eax
80102074:	3c 40                	cmp    $0x40,%al
80102076:	75 f8                	jne    80102070 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102078:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102082:	ee                   	out    %al,(%dx)
80102083:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102088:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010208d:	eb 06                	jmp    80102095 <ideinit+0x55>
8010208f:	90                   	nop
  for(i=0; i<1000; i++){
80102090:	83 e9 01             	sub    $0x1,%ecx
80102093:	74 0f                	je     801020a4 <ideinit+0x64>
80102095:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102096:	84 c0                	test   %al,%al
80102098:	74 f6                	je     80102090 <ideinit+0x50>
      havedisk1 = 1;
8010209a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ae:	ee                   	out    %al,(%dx)
}
801020af:	c9                   	leave  
801020b0:	c3                   	ret    
801020b1:	eb 0d                	jmp    801020c0 <ideintr>
801020b3:	90                   	nop
801020b4:	90                   	nop
801020b5:	90                   	nop
801020b6:	90                   	nop
801020b7:	90                   	nop
801020b8:	90                   	nop
801020b9:	90                   	nop
801020ba:	90                   	nop
801020bb:	90                   	nop
801020bc:	90                   	nop
801020bd:	90                   	nop
801020be:	90                   	nop
801020bf:	90                   	nop

801020c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020c9:	68 80 a5 10 80       	push   $0x8010a580
801020ce:	e8 7d 24 00 00       	call   80104550 <acquire>

  if((b = idequeue) == 0){
801020d3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	85 db                	test   %ebx,%ebx
801020de:	74 67                	je     80102147 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020e0:	8b 43 58             	mov    0x58(%ebx),%eax
801020e3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020e8:	8b 3b                	mov    (%ebx),%edi
801020ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020f0:	75 31                	jne    80102123 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020f7:	89 f6                	mov    %esi,%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c6                	mov    %eax,%esi
80102103:	83 e6 c0             	and    $0xffffffc0,%esi
80102106:	89 f1                	mov    %esi,%ecx
80102108:	80 f9 40             	cmp    $0x40,%cl
8010210b:	75 f3                	jne    80102100 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210d:	a8 21                	test   $0x21,%al
8010210f:	75 12                	jne    80102123 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102111:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102114:	b9 80 00 00 00       	mov    $0x80,%ecx
80102119:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211e:	fc                   	cld    
8010211f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102121:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102123:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102126:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102129:	89 f9                	mov    %edi,%ecx
8010212b:	83 c9 02             	or     $0x2,%ecx
8010212e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102130:	53                   	push   %ebx
80102131:	e8 4a 1e 00 00       	call   80103f80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102136:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	85 c0                	test   %eax,%eax
80102140:	74 05                	je     80102147 <ideintr+0x87>
    idestart(idequeue);
80102142:	e8 19 fe ff ff       	call   80101f60 <idestart>
    release(&idelock);
80102147:	83 ec 0c             	sub    $0xc,%esp
8010214a:	68 80 a5 10 80       	push   $0x8010a580
8010214f:	e8 bc 24 00 00       	call   80104610 <release>

  release(&idelock);
}
80102154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102157:	5b                   	pop    %ebx
80102158:	5e                   	pop    %esi
80102159:	5f                   	pop    %edi
8010215a:	5d                   	pop    %ebp
8010215b:	c3                   	ret    
8010215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102160 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 10             	sub    $0x10,%esp
80102167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010216a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216d:	50                   	push   %eax
8010216e:	e8 4d 22 00 00       	call   801043c0 <holdingsleep>
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	85 c0                	test   %eax,%eax
80102178:	0f 84 c6 00 00 00    	je     80102244 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 e0 06             	and    $0x6,%eax
80102183:	83 f8 02             	cmp    $0x2,%eax
80102186:	0f 84 ab 00 00 00    	je     80102237 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010218c:	8b 53 04             	mov    0x4(%ebx),%edx
8010218f:	85 d2                	test   %edx,%edx
80102191:	74 0d                	je     801021a0 <iderw+0x40>
80102193:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102198:	85 c0                	test   %eax,%eax
8010219a:	0f 84 b1 00 00 00    	je     80102251 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	68 80 a5 10 80       	push   $0x8010a580
801021a8:	e8 a3 23 00 00       	call   80104550 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bd:	85 d2                	test   %edx,%edx
801021bf:	75 09                	jne    801021ca <iderw+0x6a>
801021c1:	eb 6d                	jmp    80102230 <iderw+0xd0>
801021c3:	90                   	nop
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c8:	89 c2                	mov    %eax,%edx
801021ca:	8b 42 58             	mov    0x58(%edx),%eax
801021cd:	85 c0                	test   %eax,%eax
801021cf:	75 f7                	jne    801021c8 <iderw+0x68>
801021d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021d6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021dc:	74 42                	je     80102220 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 e0 06             	and    $0x6,%eax
801021e3:	83 f8 02             	cmp    $0x2,%eax
801021e6:	74 23                	je     8010220b <iderw+0xab>
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021f0:	83 ec 08             	sub    $0x8,%esp
801021f3:	68 80 a5 10 80       	push   $0x8010a580
801021f8:	53                   	push   %ebx
801021f9:	e8 c2 1b 00 00       	call   80103dc0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021fe:	8b 03                	mov    (%ebx),%eax
80102200:	83 c4 10             	add    $0x10,%esp
80102203:	83 e0 06             	and    $0x6,%eax
80102206:	83 f8 02             	cmp    $0x2,%eax
80102209:	75 e5                	jne    801021f0 <iderw+0x90>
  }


  release(&idelock);
8010220b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102215:	c9                   	leave  
  release(&idelock);
80102216:	e9 f5 23 00 00       	jmp    80104610 <release>
8010221b:	90                   	nop
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102220:	89 d8                	mov    %ebx,%eax
80102222:	e8 39 fd ff ff       	call   80101f60 <idestart>
80102227:	eb b5                	jmp    801021de <iderw+0x7e>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102230:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102235:	eb 9d                	jmp    801021d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 a0 73 10 80       	push   $0x801073a0
8010223f:	e8 4c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 8a 73 10 80       	push   $0x8010738a
8010224c:	e8 3f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102251:	83 ec 0c             	sub    $0xc,%esp
80102254:	68 b5 73 10 80       	push   $0x801073b5
80102259:	e8 32 e1 ff ff       	call   80100390 <panic>
8010225e:	66 90                	xchg   %ax,%ax

80102260 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102261:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
  ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
  return ioapic->data;
80102279:	a1 34 26 11 80       	mov    0x80112634,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102287:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102294:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102297:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010229a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010229d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022a0:	39 c2                	cmp    %eax,%edx
801022a2:	74 16                	je     801022ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 d4 73 10 80       	push   $0x801073d4
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	83 c3 21             	add    $0x21,%ebx
{
801022bd:	ba 10 00 00 00       	mov    $0x10,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 f6                	mov    %esi,%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022d2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022d8:	89 c6                	mov    %eax,%esi
801022da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e3:	89 71 10             	mov    %esi,0x10(%ecx)
801022e6:	8d 72 01             	lea    0x1(%edx),%esi
801022e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022f0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022fd:	75 d1                	jne    801022d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d 76 00             	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
  ioapic->reg = reg;
80102311:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010231c:	8d 50 20             	lea    0x20(%eax),%edx
8010231f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102323:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102325:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102334:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102336:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010233b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010233e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 70                	jne    801023d2 <kfree+0x82>
80102362:	81 fb a8 59 11 80    	cmp    $0x801159a8,%ebx
80102368:	72 68                	jb     801023d2 <kfree+0x82>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 5b                	ja     801023d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	68 00 10 00 00       	push   $0x1000
8010237f:	6a 01                	push   $0x1
80102381:	53                   	push   %ebx
80102382:	e8 d9 22 00 00       	call   80104660 <memset>

  if(kmem.use_lock)
80102387:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102394:	a1 78 26 11 80       	mov    0x80112678,%eax
80102399:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010239b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801023a0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023a6:	85 c0                	test   %eax,%eax
801023a8:	75 06                	jne    801023b0 <kfree+0x60>
    release(&kmem.lock);
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
801023ae:	c3                   	ret    
801023af:	90                   	nop
    release(&kmem.lock);
801023b0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
    release(&kmem.lock);
801023bb:	e9 50 22 00 00       	jmp    80104610 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 40 26 11 80       	push   $0x80112640
801023c8:	e8 83 21 00 00       	call   80104550 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 06 74 10 80       	push   $0x80107406
801023da:	e8 b1 df ff ff       	call   80100390 <panic>
801023df:	90                   	nop

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 33 ff ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 0c 74 10 80       	push   $0x8010740c
80102440:	68 40 26 11 80       	push   $0x80112640
80102445:	e8 c6 1f 00 00       	call   80104410 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102457:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 cb fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 73 fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 74 26 11 80       	mov    0x80112674,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010251a:	c3                   	ret    
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102520:	f3 c3                	repz ret 
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010252e:	68 40 26 11 80       	push   $0x80112640
80102533:	e8 18 20 00 00       	call   80104550 <acquire>
  r = kmem.freelist;
80102538:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
    kmem.freelist = r->next;
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
    release(&kmem.lock);
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 40 26 11 80       	push   $0x80112640
80102561:	e8 aa 20 00 00       	call   80104610 <release>
  return (char*)r;
80102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102569:	83 c4 10             	add    $0x10,%esp
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax

80102570 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 c2 00 00 00    	je     80102640 <kbdgetc+0xd0>
8010257e:	ba 60 00 00 00       	mov    $0x60,%edx
80102583:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102584:	0f b6 d0             	movzbl %al,%edx
80102587:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010258d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102593:	0f 84 7f 00 00 00    	je     80102618 <kbdgetc+0xa8>
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	53                   	push   %ebx
8010259d:	89 cb                	mov    %ecx,%ebx
8010259f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a2:	84 c0                	test   %al,%al
801025a4:	78 4a                	js     801025f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 09                	je     801025b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025b3:	0f b6 82 40 75 10 80 	movzbl -0x7fef8ac0(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 40 74 10 80 	movzbl -0x7fef8bc0(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025c7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 20 74 10 80 	mov    -0x7fef8be0(,%eax,4),%eax
801025da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025de:	74 31                	je     80102611 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e3:	83 fa 19             	cmp    $0x19,%edx
801025e6:	77 40                	ja     80102628 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025eb:	5b                   	pop    %ebx
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025f0:	83 e0 7f             	and    $0x7f,%eax
801025f3:	85 db                	test   %ebx,%ebx
801025f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025f8:	0f b6 82 40 75 10 80 	movzbl -0x7fef8ac0(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
    return 0;
80102609:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102611:	5b                   	pop    %ebx
80102612:	5d                   	pop    %ebp
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102618:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010261b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010261d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010262e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010262f:	83 f9 1a             	cmp    $0x1a,%ecx
80102632:	0f 42 c2             	cmovb  %edx,%eax
}
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    
80102637:	89 f6                	mov    %esi,%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102656:	68 70 25 10 80       	push   $0x80102570
8010265b:	e8 b0 e1 ff ff       	call   80100810 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>
  lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102770:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102776:	55                   	push   %ebp
80102777:	31 c0                	xor    %eax,%eax
80102779:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010277b:	85 d2                	test   %edx,%edx
8010277d:	74 06                	je     80102785 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010277f:	8b 42 20             	mov    0x20(%edx),%eax
80102782:	c1 e8 18             	shr    $0x18,%eax
}
80102785:	5d                   	pop    %ebp
80102786:	c3                   	ret    
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027c6:	ba 70 00 00 00       	mov    $0x70,%edx
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	ba 71 00 00 00       	mov    $0x71,%edx
801027df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027fe:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	b8 0b 00 00 00       	mov    $0xb,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102872:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102875:	8d 76 00             	lea    0x0(%esi),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
80102885:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	89 da                	mov    %ebx,%edx
8010288a:	b8 02 00 00 00       	mov    $0x2,%eax
8010288f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
80102893:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102896:	89 da                	mov    %ebx,%edx
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 da                	mov    %ebx,%edx
801028a6:	b8 07 00 00 00       	mov    $0x7,%eax
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 08 00 00 00       	mov    $0x8,%eax
801028b9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
801028bd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bf:	89 da                	mov    %ebx,%edx
801028c1:	b8 09 00 00 00       	mov    $0x9,%eax
801028c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c7:	89 ca                	mov    %ecx,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	89 ca                	mov    %ecx,%edx
801028d6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d7:	84 c0                	test   %al,%al
801028d9:	78 9d                	js     80102878 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028df:	89 fa                	mov    %edi,%edx
801028e1:	0f b6 fa             	movzbl %dl,%edi
801028e4:	89 f2                	mov    %esi,%edx
801028e6:	0f b6 f2             	movzbl %dl,%esi
801028e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102902:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102906:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102909:	31 c0                	xor    %eax,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
80102920:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 da                	mov    %ebx,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
80102942:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 da                	mov    %ebx,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
80102964:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	50                   	push   %eax
80102973:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102976:	50                   	push   %eax
80102977:	e8 34 1d 00 00       	call   801046b0 <memcmp>
8010297c:	83 c4 10             	add    $0x10,%esp
8010297f:	85 c0                	test   %eax,%eax
80102981:	0f 85 f1 fe ff ff    	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102987:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010298b:	75 78                	jne    80102a05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102990:	89 c2                	mov    %eax,%edx
80102992:	83 e0 0f             	and    $0xf,%eax
80102995:	c1 ea 04             	shr    $0x4,%edx
80102998:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a4:	89 c2                	mov    %eax,%edx
801029a6:	83 e0 0f             	and    $0xf,%eax
801029a9:	c1 ea 04             	shr    $0x4,%edx
801029ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	83 e0 0f             	and    $0xf,%eax
801029bd:	c1 ea 04             	shr    $0x4,%edx
801029c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	83 e0 0f             	and    $0xf,%eax
801029d1:	c1 ea 04             	shr    $0x4,%edx
801029d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	83 e0 0f             	and    $0xf,%eax
801029e5:	c1 ea 04             	shr    $0x4,%edx
801029e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f4:	89 c2                	mov    %eax,%edx
801029f6:	83 e0 0f             	and    $0xf,%eax
801029f9:	c1 ea 04             	shr    $0x4,%edx
801029fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a05:	8b 75 08             	mov    0x8(%ebp),%esi
80102a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0b:	89 06                	mov    %eax,(%esi)
80102a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a10:	89 46 04             	mov    %eax,0x4(%esi)
80102a13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a16:	89 46 08             	mov    %eax,0x8(%esi)
80102a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a22:	89 46 10             	mov    %eax,0x10(%esi)
80102a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a35:	5b                   	pop    %ebx
80102a36:	5e                   	pop    %esi
80102a37:	5f                   	pop    %edi
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 8a 00 00 00    	jle    80102ad8 <install_trans+0x98>
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	31 db                	xor    %ebx,%ebx
{
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a84:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 67 1c 00 00       	call   80104710 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	f3 c3                	repz ret 
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102aee:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b09:	7e 16                	jle    80102b21 <write_head+0x41>
80102b0b:	c1 e3 02             	shl    $0x2,%ebx
80102b0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b10:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <write_head+0x30>
  }
  bwrite(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	56                   	push   %esi
80102b25:	e8 76 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b2a:	89 34 24             	mov    %esi,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>
}
80102b32:	83 c4 10             	add    $0x10,%esp
80102b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b38:	5b                   	pop    %ebx
80102b39:	5e                   	pop    %esi
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <initlog>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b4a:	68 40 76 10 80       	push   $0x80107640
80102b4f:	68 80 26 11 80       	push   $0x80112680
80102b54:	e8 b7 18 00 00       	call   80104410 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 1b e9 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  log.dev = dev;
80102b6c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b72:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b78:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b8d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 d3                	cmp    %edx,%ebx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
}
80102bce:	83 c4 10             	add    $0x10,%esp
80102bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 80 26 11 80       	push   $0x80112680
80102beb:	e8 60 19 00 00       	call   80104550 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 80 26 11 80       	push   $0x80112680
80102c00:	68 80 26 11 80       	push   $0x80112680
80102c05:	e8 b6 11 00 00       	call   80103dc0 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c0d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c1b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c32:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c37:	68 80 26 11 80       	push   $0x80112680
80102c3c:	e8 cf 19 00 00       	call   80104610 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 80 26 11 80       	push   $0x80112680
80102c5e:	e8 ed 18 00 00       	call   80104550 <acquire>
  log.outstanding -= 1;
80102c63:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c68:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c76:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c7c:	0f 85 1a 01 00 00    	jne    80102d9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c82:	85 db                	test   %ebx,%ebx
80102c84:	0f 85 ee 00 00 00    	jne    80102d78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c8d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c94:	00 00 00 
  release(&log.lock);
80102c97:	68 80 26 11 80       	push   $0x80112680
80102c9c:	e8 6f 19 00 00       	call   80104610 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb2:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102cd6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cdf:	e8 ec d3 ff ff       	call   801000d0 <bread>
80102ce4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce9:	83 c4 0c             	add    $0xc,%esp
80102cec:	68 00 02 00 00       	push   $0x200
80102cf1:	50                   	push   %eax
80102cf2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cf5:	50                   	push   %eax
80102cf6:	e8 15 1a 00 00       	call   80104710 <memmove>
    bwrite(to);  // write the log
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 9d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d03:	89 3c 24             	mov    %edi,(%esp)
80102d06:	e8 d5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d0b:	89 34 24             	mov    %esi,(%esp)
80102d0e:	e8 cd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d28:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
    acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 80 26 11 80       	push   $0x80112680
80102d3f:	e8 0c 18 00 00       	call   80104550 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d4b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 26 12 00 00       	call   80103f80 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d61:	e8 aa 18 00 00       	call   80104610 <release>
80102d66:	83 c4 10             	add    $0x10,%esp
}
80102d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6c:	5b                   	pop    %ebx
80102d6d:	5e                   	pop    %esi
80102d6e:	5f                   	pop    %edi
80102d6f:	5d                   	pop    %ebp
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	68 80 26 11 80       	push   $0x80112680
80102d80:	e8 fb 11 00 00       	call   80103f80 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d8c:	e8 7f 18 00 00       	call   80104610 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
    panic("log.committing");
80102d9c:	83 ec 0c             	sub    $0xc,%esp
80102d9f:	68 44 76 10 80       	push   $0x80107644
80102da4:	e8 e7 d5 ff ff       	call   80100390 <panic>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 80 26 11 80       	push   $0x80112680
80102dee:	e8 5d 17 00 00       	call   80104550 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e32:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
  release(&log.lock);
80102e3d:	e9 ce 17 00 00       	jmp    80104610 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e48:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
    panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 53 76 10 80       	push   $0x80107653
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 69 76 10 80       	push   $0x80107669
80102e7b:	e8 10 d5 ff ff       	call   80100390 <panic>

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 74 09 00 00       	call   80103800 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 6d 09 00 00       	call   80103800 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 84 76 10 80       	push   $0x80107684
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 09 2b 00 00       	call   801059b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 d4 08 00 00       	call   80103780 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 21 0c 00 00       	call   80103ae0 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 d5 3b 00 00       	call   80106aa0 <switchkvm>
  seginit();
80102ecb:	e8 40 3b 00 00       	call   80106a10 <seginit>
  lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 00 40 80       	push   $0x80400000
80102ef7:	68 a8 59 11 80       	push   $0x801159a8
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102f01:	e8 6a 40 00 00       	call   80106f70 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 fb 3a 00 00       	call   80106a10 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 b7 2d 00 00       	call   80105ce0 <uartinit>
  pinit();         // process table
80102f29:	e8 32 08 00 00       	call   80103760 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 fd 29 00 00       	call   80105930 <tvinit>
  binit();         // buffer cache
80102f33:	e8 08 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f38:	e8 63 de ff ff       	call   80100da0 <fileinit>
  ideinit();       // disk 
80102f3d:	e8 fe f0 ff ff       	call   80102040 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f42:	83 c4 0c             	add    $0xc,%esp
80102f45:	68 8a 00 00 00       	push   $0x8a
80102f4a:	68 8c a4 10 80       	push   $0x8010a48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 b7 17 00 00       	call   80104710 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f59:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 80 27 11 80       	add    $0x80112780,%eax
80102f6b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f80:	e8 fb 07 00 00       	call   80103780 <mycpu>
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	74 41                	je     80102fca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f89:	e8 72 f5 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f8e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f93:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f9a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fa4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fa7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fac:	0f b6 03             	movzbl (%ebx),%eax
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 70 00 00       	push   $0x7000
80102fb7:	50                   	push   %eax
80102fb8:	e8 03 f8 ff ff       	call   801027c0 <lapicstartap>
80102fbd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 80 27 11 80       	add    $0x80112780,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 56 08 00 00       	call   80103850 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 98 76 10 80       	push   $0x80107698
80103033:	56                   	push   %esi
80103034:	e8 77 16 00 00       	call   801046b0 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 b5 76 10 80       	push   $0x801076b5
801030f1:	56                   	push   %esi
801030f2:	e8 b9 15 00 00       	call   801046b0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 dc 76 10 80 	jmp    *-0x7fef8924(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 9d 76 10 80       	push   $0x8010769d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 bc 76 10 80       	push   $0x801076bc
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 20 db ff ff       	call   80100dc0 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 15 db ff ff       	call   80100dc0 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 4a f2 ff ff       	call   80102500 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 a9 db ff ff       	call   80100e80 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 81 db ff ff       	call   80100e80 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 f0 76 10 80       	push   $0x801076f0
80103340:	50                   	push   %eax
80103341:	e8 ca 10 00 00       	call   80104410 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 ac 11 00 00       	call   80104550 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 bc 0b 00 00       	call   80103f80 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 27 12 00 00       	jmp    80104610 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 77 0b 00 00       	call   80103f80 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 f7 11 00 00       	call   80104610 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 26 ef ff ff       	jmp    80102350 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 0e 11 00 00       	call   80104550 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 e7 0a 00 00       	call   80103f80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 1e 09 00 00       	call   80103dc0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 57 03 00 00       	call   80103820 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 37 11 00 00       	call   80104610 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 58 0a 00 00       	call   80103f80 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 e0 10 00 00       	call   80104610 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 fb 0f 00 00       	call   80104550 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 36 08 00 00       	call   80103dc0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 72 02 00 00       	call   80103820 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 4d 10 00 00       	call   80104610 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 64 09 00 00       	call   80103f80 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 ec 0f 00 00       	call   80104610 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103644:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103649:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010364c:	68 20 2d 11 80       	push   $0x80112d20
80103651:	e8 fa 0e 00 00       	call   80104550 <acquire>
80103656:	83 c4 10             	add    $0x10,%esp
80103659:	eb 13                	jmp    8010366e <allocproc+0x2e>
8010365b:	90                   	nop
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103660:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103666:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010366c:	73 7a                	jae    801036e8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010366e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103671:	85 c0                	test   %eax,%eax
80103673:	75 eb                	jne    80103660 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103675:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
8010367a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010367d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103684:	8d 50 01             	lea    0x1(%eax),%edx
80103687:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010368a:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010368f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103695:	e8 76 0f 00 00       	call   80104610 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010369a:	e8 61 ee ff ff       	call   80102500 <kalloc>
8010369f:	83 c4 10             	add    $0x10,%esp
801036a2:	85 c0                	test   %eax,%eax
801036a4:	89 43 08             	mov    %eax,0x8(%ebx)
801036a7:	74 58                	je     80103701 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036af:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036b2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036b7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036ba:	c7 40 14 1f 59 10 80 	movl   $0x8010591f,0x14(%eax)
  p->context = (struct context*)sp;
801036c1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036c4:	6a 14                	push   $0x14
801036c6:	6a 00                	push   $0x0
801036c8:	50                   	push   %eax
801036c9:	e8 92 0f 00 00       	call   80104660 <memset>
  p->context->eip = (uint)forkret;
801036ce:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036d1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036d4:	c7 40 10 10 37 10 80 	movl   $0x80103710,0x10(%eax)
}
801036db:	89 d8                	mov    %ebx,%eax
801036dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036e0:	c9                   	leave  
801036e1:	c3                   	ret    
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801036e8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036eb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036ed:	68 20 2d 11 80       	push   $0x80112d20
801036f2:	e8 19 0f 00 00       	call   80104610 <release>
}
801036f7:	89 d8                	mov    %ebx,%eax
  return 0;
801036f9:	83 c4 10             	add    $0x10,%esp
}
801036fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036ff:	c9                   	leave  
80103700:	c3                   	ret    
    p->state = UNUSED;
80103701:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103708:	31 db                	xor    %ebx,%ebx
8010370a:	eb cf                	jmp    801036db <allocproc+0x9b>
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103710 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103716:	68 20 2d 11 80       	push   $0x80112d20
8010371b:	e8 f0 0e 00 00       	call   80104610 <release>

  if (first) {
80103720:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	85 c0                	test   %eax,%eax
8010372a:	75 04                	jne    80103730 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010372c:	c9                   	leave  
8010372d:	c3                   	ret    
8010372e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103730:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103733:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010373a:	00 00 00 
    iinit(ROOTDEV);
8010373d:	6a 01                	push   $0x1
8010373f:	e8 7c dd ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010374b:	e8 f0 f3 ff ff       	call   80102b40 <initlog>
80103750:	83 c4 10             	add    $0x10,%esp
}
80103753:	c9                   	leave  
80103754:	c3                   	ret    
80103755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <pinit>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103766:	68 f5 76 10 80       	push   $0x801076f5
8010376b:	68 20 2d 11 80       	push   $0x80112d20
80103770:	e8 9b 0c 00 00       	call   80104410 <initlock>
}
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	c9                   	leave  
80103779:	c3                   	ret    
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103780 <mycpu>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103785:	9c                   	pushf  
80103786:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103787:	f6 c4 02             	test   $0x2,%ah
8010378a:	75 5e                	jne    801037ea <mycpu+0x6a>
  apicid = lapicid();
8010378c:	e8 df ef ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103791:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103797:	85 f6                	test   %esi,%esi
80103799:	7e 42                	jle    801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010379b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037a2:	39 d0                	cmp    %edx,%eax
801037a4:	74 30                	je     801037d6 <mycpu+0x56>
801037a6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801037ab:	31 d2                	xor    %edx,%edx
801037ad:	8d 76 00             	lea    0x0(%esi),%esi
801037b0:	83 c2 01             	add    $0x1,%edx
801037b3:	39 f2                	cmp    %esi,%edx
801037b5:	74 26                	je     801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037b7:	0f b6 19             	movzbl (%ecx),%ebx
801037ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037c0:	39 c3                	cmp    %eax,%ebx
801037c2:	75 ec                	jne    801037b0 <mycpu+0x30>
801037c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ca:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037d2:	5b                   	pop    %ebx
801037d3:	5e                   	pop    %esi
801037d4:	5d                   	pop    %ebp
801037d5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037d6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801037db:	eb f2                	jmp    801037cf <mycpu+0x4f>
  panic("unknown apicid\n");
801037dd:	83 ec 0c             	sub    $0xc,%esp
801037e0:	68 fc 76 10 80       	push   $0x801076fc
801037e5:	e8 a6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	68 f0 77 10 80       	push   $0x801077f0
801037f2:	e8 99 cb ff ff       	call   80100390 <panic>
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <cpuid>:
cpuid() {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103806:	e8 75 ff ff ff       	call   80103780 <mycpu>
8010380b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103810:	c9                   	leave  
  return mycpu()-cpus;
80103811:	c1 f8 04             	sar    $0x4,%eax
80103814:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010381a:	c3                   	ret    
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103820 <myproc>:
myproc(void) {
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103827:	e8 54 0c 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010382c:	e8 4f ff ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103831:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103837:	e8 84 0c 00 00       	call   801044c0 <popcli>
}
8010383c:	83 c4 04             	add    $0x4,%esp
8010383f:	89 d8                	mov    %ebx,%eax
80103841:	5b                   	pop    %ebx
80103842:	5d                   	pop    %ebp
80103843:	c3                   	ret    
80103844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010384a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103850 <userinit>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103857:	e8 e4 fd ff ff       	call   80103640 <allocproc>
8010385c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010385e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103863:	e8 88 36 00 00       	call   80106ef0 <setupkvm>
80103868:	85 c0                	test   %eax,%eax
8010386a:	89 43 04             	mov    %eax,0x4(%ebx)
8010386d:	0f 84 bd 00 00 00    	je     80103930 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103873:	83 ec 04             	sub    $0x4,%esp
80103876:	68 2c 00 00 00       	push   $0x2c
8010387b:	68 60 a4 10 80       	push   $0x8010a460
80103880:	50                   	push   %eax
80103881:	e8 4a 33 00 00       	call   80106bd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103886:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103889:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010388f:	6a 4c                	push   $0x4c
80103891:	6a 00                	push   $0x0
80103893:	ff 73 18             	pushl  0x18(%ebx)
80103896:	e8 c5 0d 00 00       	call   80104660 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010389b:	8b 43 18             	mov    0x18(%ebx),%eax
8010389e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038a3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038a8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038af:	8b 43 18             	mov    0x18(%ebx),%eax
801038b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038b6:	8b 43 18             	mov    0x18(%ebx),%eax
801038b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038bd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038c1:	8b 43 18             	mov    0x18(%ebx),%eax
801038c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038c8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038cc:	8b 43 18             	mov    0x18(%ebx),%eax
801038cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038d6:	8b 43 18             	mov    0x18(%ebx),%eax
801038d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038e0:	8b 43 18             	mov    0x18(%ebx),%eax
801038e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ea:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038ed:	6a 10                	push   $0x10
801038ef:	68 25 77 10 80       	push   $0x80107725
801038f4:	50                   	push   %eax
801038f5:	e8 46 0f 00 00       	call   80104840 <safestrcpy>
  p->cwd = namei("/");
801038fa:	c7 04 24 2e 77 10 80 	movl   $0x8010772e,(%esp)
80103901:	e8 1a e6 ff ff       	call   80101f20 <namei>
80103906:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103909:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103910:	e8 3b 0c 00 00       	call   80104550 <acquire>
  p->state = RUNNABLE;
80103915:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010391c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103923:	e8 e8 0c 00 00       	call   80104610 <release>
}
80103928:	83 c4 10             	add    $0x10,%esp
8010392b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392e:	c9                   	leave  
8010392f:	c3                   	ret    
    panic("userinit: out of memory?");
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	68 0c 77 10 80       	push   $0x8010770c
80103938:	e8 53 ca ff ff       	call   80100390 <panic>
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <growproc>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103948:	e8 33 0b 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010394d:	e8 2e fe ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103952:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103958:	e8 63 0b 00 00       	call   801044c0 <popcli>
  if(n > 0){
8010395d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103960:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103962:	7f 1c                	jg     80103980 <growproc+0x40>
  } else if(n < 0){
80103964:	75 3a                	jne    801039a0 <growproc+0x60>
  switchuvm(curproc);
80103966:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103969:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010396b:	53                   	push   %ebx
8010396c:	e8 4f 31 00 00       	call   80106ac0 <switchuvm>
  return 0;
80103971:	83 c4 10             	add    $0x10,%esp
80103974:	31 c0                	xor    %eax,%eax
}
80103976:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103979:	5b                   	pop    %ebx
8010397a:	5e                   	pop    %esi
8010397b:	5d                   	pop    %ebp
8010397c:	c3                   	ret    
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103980:	83 ec 04             	sub    $0x4,%esp
80103983:	01 c6                	add    %eax,%esi
80103985:	56                   	push   %esi
80103986:	50                   	push   %eax
80103987:	ff 73 04             	pushl  0x4(%ebx)
8010398a:	e8 81 33 00 00       	call   80106d10 <allocuvm>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	85 c0                	test   %eax,%eax
80103994:	75 d0                	jne    80103966 <growproc+0x26>
      return -1;
80103996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010399b:	eb d9                	jmp    80103976 <growproc+0x36>
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039a0:	83 ec 04             	sub    $0x4,%esp
801039a3:	01 c6                	add    %eax,%esi
801039a5:	56                   	push   %esi
801039a6:	50                   	push   %eax
801039a7:	ff 73 04             	pushl  0x4(%ebx)
801039aa:	e8 91 34 00 00       	call   80106e40 <deallocuvm>
801039af:	83 c4 10             	add    $0x10,%esp
801039b2:	85 c0                	test   %eax,%eax
801039b4:	75 b0                	jne    80103966 <growproc+0x26>
801039b6:	eb de                	jmp    80103996 <growproc+0x56>
801039b8:	90                   	nop
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039c0 <fork>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801039c9:	e8 b2 0a 00 00       	call   80104480 <pushcli>
  c = mycpu();
801039ce:	e8 ad fd ff ff       	call   80103780 <mycpu>
  p = c->proc;
801039d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039d9:	e8 e2 0a 00 00       	call   801044c0 <popcli>
  if((np = allocproc()) == 0){
801039de:	e8 5d fc ff ff       	call   80103640 <allocproc>
801039e3:	85 c0                	test   %eax,%eax
801039e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039e8:	0f 84 b7 00 00 00    	je     80103aa5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039ee:	83 ec 08             	sub    $0x8,%esp
801039f1:	ff 33                	pushl  (%ebx)
801039f3:	ff 73 04             	pushl  0x4(%ebx)
801039f6:	89 c7                	mov    %eax,%edi
801039f8:	e8 c3 35 00 00       	call   80106fc0 <copyuvm>
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	85 c0                	test   %eax,%eax
80103a02:	89 47 04             	mov    %eax,0x4(%edi)
80103a05:	0f 84 a1 00 00 00    	je     80103aac <fork+0xec>
  np->sz = curproc->sz;
80103a0b:	8b 03                	mov    (%ebx),%eax
80103a0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a10:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a12:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a15:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a17:	8b 79 18             	mov    0x18(%ecx),%edi
80103a1a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a1d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a26:	8b 40 18             	mov    0x18(%eax),%eax
80103a29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a34:	85 c0                	test   %eax,%eax
80103a36:	74 13                	je     80103a4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a38:	83 ec 0c             	sub    $0xc,%esp
80103a3b:	50                   	push   %eax
80103a3c:	e8 ef d3 ff ff       	call   80100e30 <filedup>
80103a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a44:	83 c4 10             	add    $0x10,%esp
80103a47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a4b:	83 c6 01             	add    $0x1,%esi
80103a4e:	83 fe 10             	cmp    $0x10,%esi
80103a51:	75 dd                	jne    80103a30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a53:	83 ec 0c             	sub    $0xc,%esp
80103a56:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a5c:	e8 2f dc ff ff       	call   80101690 <idup>
80103a61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a6d:	6a 10                	push   $0x10
80103a6f:	53                   	push   %ebx
80103a70:	50                   	push   %eax
80103a71:	e8 ca 0d 00 00       	call   80104840 <safestrcpy>
  pid = np->pid;
80103a76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a80:	e8 cb 0a 00 00       	call   80104550 <acquire>
  np->state = RUNNABLE;
80103a85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a93:	e8 78 0b 00 00       	call   80104610 <release>
  return pid;
80103a98:	83 c4 10             	add    $0x10,%esp
}
80103a9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a9e:	89 d8                	mov    %ebx,%eax
80103aa0:	5b                   	pop    %ebx
80103aa1:	5e                   	pop    %esi
80103aa2:	5f                   	pop    %edi
80103aa3:	5d                   	pop    %ebp
80103aa4:	c3                   	ret    
    return -1;
80103aa5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103aaa:	eb ef                	jmp    80103a9b <fork+0xdb>
    kfree(np->kstack);
80103aac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103aaf:	83 ec 0c             	sub    $0xc,%esp
80103ab2:	ff 73 08             	pushl  0x8(%ebx)
80103ab5:	e8 96 e8 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
80103aba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ac1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ad0:	eb c9                	jmp    80103a9b <fork+0xdb>
80103ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ae0 <scheduler>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ae9:	e8 92 fc ff ff       	call   80103780 <mycpu>
80103aee:	8d 78 04             	lea    0x4(%eax),%edi
80103af1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103af3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103afa:	00 00 00 
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b00:	fb                   	sti    
    acquire(&ptable.lock);
80103b01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b04:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103b09:	68 20 2d 11 80       	push   $0x80112d20
80103b0e:	e8 3d 0a 00 00       	call   80104550 <acquire>
80103b13:	83 c4 10             	add    $0x10,%esp
80103b16:	8d 76 00             	lea    0x0(%esi),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103b20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b24:	75 33                	jne    80103b59 <scheduler+0x79>
      switchuvm(p);
80103b26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b2f:	53                   	push   %ebx
80103b30:	e8 8b 2f 00 00       	call   80106ac0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103b35:	58                   	pop    %eax
80103b36:	5a                   	pop    %edx
80103b37:	ff 73 1c             	pushl  0x1c(%ebx)
80103b3a:	57                   	push   %edi
      p->state = RUNNING;
80103b3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103b42:	e8 54 0d 00 00       	call   8010489b <swtch>
      switchkvm();
80103b47:	e8 54 2f 00 00       	call   80106aa0 <switchkvm>
      c->proc = 0;
80103b4c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b53:	00 00 00 
80103b56:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b59:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103b5f:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103b65:	72 b9                	jb     80103b20 <scheduler+0x40>
    release(&ptable.lock);
80103b67:	83 ec 0c             	sub    $0xc,%esp
80103b6a:	68 20 2d 11 80       	push   $0x80112d20
80103b6f:	e8 9c 0a 00 00       	call   80104610 <release>
    sti();
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	eb 87                	jmp    80103b00 <scheduler+0x20>
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b80 <sched>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
  pushcli();
80103b85:	e8 f6 08 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b8a:	e8 f1 fb ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103b8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b95:	e8 26 09 00 00       	call   801044c0 <popcli>
  if(!holding(&ptable.lock))
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	68 20 2d 11 80       	push   $0x80112d20
80103ba2:	e8 79 09 00 00       	call   80104520 <holding>
80103ba7:	83 c4 10             	add    $0x10,%esp
80103baa:	85 c0                	test   %eax,%eax
80103bac:	74 4f                	je     80103bfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103bae:	e8 cd fb ff ff       	call   80103780 <mycpu>
80103bb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bba:	75 68                	jne    80103c24 <sched+0xa4>
  if(p->state == RUNNING)
80103bbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bc0:	74 55                	je     80103c17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bc2:	9c                   	pushf  
80103bc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bc4:	f6 c4 02             	test   $0x2,%ah
80103bc7:	75 41                	jne    80103c0a <sched+0x8a>
  intena = mycpu()->intena;
80103bc9:	e8 b2 fb ff ff       	call   80103780 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103bd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bd7:	e8 a4 fb ff ff       	call   80103780 <mycpu>
80103bdc:	83 ec 08             	sub    $0x8,%esp
80103bdf:	ff 70 04             	pushl  0x4(%eax)
80103be2:	53                   	push   %ebx
80103be3:	e8 b3 0c 00 00       	call   8010489b <swtch>
  mycpu()->intena = intena;
80103be8:	e8 93 fb ff ff       	call   80103780 <mycpu>
}
80103bed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103bf0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf9:	5b                   	pop    %ebx
80103bfa:	5e                   	pop    %esi
80103bfb:	5d                   	pop    %ebp
80103bfc:	c3                   	ret    
    panic("sched ptable.lock");
80103bfd:	83 ec 0c             	sub    $0xc,%esp
80103c00:	68 30 77 10 80       	push   $0x80107730
80103c05:	e8 86 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 5c 77 10 80       	push   $0x8010775c
80103c12:	e8 79 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c17:	83 ec 0c             	sub    $0xc,%esp
80103c1a:	68 4e 77 10 80       	push   $0x8010774e
80103c1f:	e8 6c c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	68 42 77 10 80       	push   $0x80107742
80103c2c:	e8 5f c7 ff ff       	call   80100390 <panic>
80103c31:	eb 0d                	jmp    80103c40 <exit>
80103c33:	90                   	nop
80103c34:	90                   	nop
80103c35:	90                   	nop
80103c36:	90                   	nop
80103c37:	90                   	nop
80103c38:	90                   	nop
80103c39:	90                   	nop
80103c3a:	90                   	nop
80103c3b:	90                   	nop
80103c3c:	90                   	nop
80103c3d:	90                   	nop
80103c3e:	90                   	nop
80103c3f:	90                   	nop

80103c40 <exit>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c49:	e8 32 08 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103c4e:	e8 2d fb ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103c53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c59:	e8 62 08 00 00       	call   801044c0 <popcli>
  if(curproc == initproc)
80103c5e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c64:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c67:	8d 7e 68             	lea    0x68(%esi),%edi
80103c6a:	0f 84 f1 00 00 00    	je     80103d61 <exit+0x121>
    if(curproc->ofile[fd]){
80103c70:	8b 03                	mov    (%ebx),%eax
80103c72:	85 c0                	test   %eax,%eax
80103c74:	74 12                	je     80103c88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	50                   	push   %eax
80103c7a:	e8 01 d2 ff ff       	call   80100e80 <fileclose>
      curproc->ofile[fd] = 0;
80103c7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c85:	83 c4 10             	add    $0x10,%esp
80103c88:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c8b:	39 fb                	cmp    %edi,%ebx
80103c8d:	75 e1                	jne    80103c70 <exit+0x30>
  begin_op();
80103c8f:	e8 4c ef ff ff       	call   80102be0 <begin_op>
  iput(curproc->cwd);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	ff 76 68             	pushl  0x68(%esi)
80103c9a:	e8 51 db ff ff       	call   801017f0 <iput>
  end_op();
80103c9f:	e8 ac ef ff ff       	call   80102c50 <end_op>
  curproc->cwd = 0;
80103ca4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103cab:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cb2:	e8 99 08 00 00       	call   80104550 <acquire>
  wakeup1(curproc->parent);
80103cb7:	8b 56 14             	mov    0x14(%esi),%edx
80103cba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cbd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cc2:	eb 10                	jmp    80103cd4 <exit+0x94>
80103cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc8:	05 90 00 00 00       	add    $0x90,%eax
80103ccd:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103cd2:	73 1e                	jae    80103cf2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103cd4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cd8:	75 ee                	jne    80103cc8 <exit+0x88>
80103cda:	3b 50 20             	cmp    0x20(%eax),%edx
80103cdd:	75 e9                	jne    80103cc8 <exit+0x88>
      p->state = RUNNABLE;
80103cdf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce6:	05 90 00 00 00       	add    $0x90,%eax
80103ceb:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103cf0:	72 e2                	jb     80103cd4 <exit+0x94>
      p->parent = initproc;
80103cf2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103cfd:	eb 0f                	jmp    80103d0e <exit+0xce>
80103cff:	90                   	nop
80103d00:	81 c2 90 00 00 00    	add    $0x90,%edx
80103d06:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103d0c:	73 3a                	jae    80103d48 <exit+0x108>
    if(p->parent == curproc){
80103d0e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d11:	75 ed                	jne    80103d00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d1a:	75 e4                	jne    80103d00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d1c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d21:	eb 11                	jmp    80103d34 <exit+0xf4>
80103d23:	90                   	nop
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	05 90 00 00 00       	add    $0x90,%eax
80103d2d:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103d32:	73 cc                	jae    80103d00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d38:	75 ee                	jne    80103d28 <exit+0xe8>
80103d3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d3d:	75 e9                	jne    80103d28 <exit+0xe8>
      p->state = RUNNABLE;
80103d3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d46:	eb e0                	jmp    80103d28 <exit+0xe8>
  curproc->state = ZOMBIE;
80103d48:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d4f:	e8 2c fe ff ff       	call   80103b80 <sched>
  panic("zombie exit");
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	68 7d 77 10 80       	push   $0x8010777d
80103d5c:	e8 2f c6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d61:	83 ec 0c             	sub    $0xc,%esp
80103d64:	68 70 77 10 80       	push   $0x80107770
80103d69:	e8 22 c6 ff ff       	call   80100390 <panic>
80103d6e:	66 90                	xchg   %ax,%ax

80103d70 <yield>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d77:	68 20 2d 11 80       	push   $0x80112d20
80103d7c:	e8 cf 07 00 00       	call   80104550 <acquire>
  pushcli();
80103d81:	e8 fa 06 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103d86:	e8 f5 f9 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103d8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d91:	e8 2a 07 00 00       	call   801044c0 <popcli>
  myproc()->state = RUNNABLE;
80103d96:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d9d:	e8 de fd ff ff       	call   80103b80 <sched>
  release(&ptable.lock);
80103da2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da9:	e8 62 08 00 00       	call   80104610 <release>
}
80103dae:	83 c4 10             	add    $0x10,%esp
80103db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db4:	c9                   	leave  
80103db5:	c3                   	ret    
80103db6:	8d 76 00             	lea    0x0(%esi),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <sleep>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103dcf:	e8 ac 06 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103dd4:	e8 a7 f9 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103dd9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ddf:	e8 dc 06 00 00       	call   801044c0 <popcli>
  if(p == 0)
80103de4:	85 db                	test   %ebx,%ebx
80103de6:	0f 84 87 00 00 00    	je     80103e73 <sleep+0xb3>
  if(lk == 0)
80103dec:	85 f6                	test   %esi,%esi
80103dee:	74 76                	je     80103e66 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103df0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103df6:	74 50                	je     80103e48 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	68 20 2d 11 80       	push   $0x80112d20
80103e00:	e8 4b 07 00 00       	call   80104550 <acquire>
    release(lk);
80103e05:	89 34 24             	mov    %esi,(%esp)
80103e08:	e8 03 08 00 00       	call   80104610 <release>
  p->chan = chan;
80103e0d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e10:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e17:	e8 64 fd ff ff       	call   80103b80 <sched>
  p->chan = 0;
80103e1c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e2a:	e8 e1 07 00 00       	call   80104610 <release>
    acquire(lk);
80103e2f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e32:	83 c4 10             	add    $0x10,%esp
}
80103e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e38:	5b                   	pop    %ebx
80103e39:	5e                   	pop    %esi
80103e3a:	5f                   	pop    %edi
80103e3b:	5d                   	pop    %ebp
    acquire(lk);
80103e3c:	e9 0f 07 00 00       	jmp    80104550 <acquire>
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e48:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e4b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e52:	e8 29 fd ff ff       	call   80103b80 <sched>
  p->chan = 0;
80103e57:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e61:	5b                   	pop    %ebx
80103e62:	5e                   	pop    %esi
80103e63:	5f                   	pop    %edi
80103e64:	5d                   	pop    %ebp
80103e65:	c3                   	ret    
    panic("sleep without lk");
80103e66:	83 ec 0c             	sub    $0xc,%esp
80103e69:	68 8f 77 10 80       	push   $0x8010778f
80103e6e:	e8 1d c5 ff ff       	call   80100390 <panic>
    panic("sleep");
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 89 77 10 80       	push   $0x80107789
80103e7b:	e8 10 c5 ff ff       	call   80100390 <panic>

80103e80 <wait>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	56                   	push   %esi
80103e84:	53                   	push   %ebx
  pushcli();
80103e85:	e8 f6 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103e8a:	e8 f1 f8 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103e8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e95:	e8 26 06 00 00       	call   801044c0 <popcli>
  acquire(&ptable.lock);
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 20 2d 11 80       	push   $0x80112d20
80103ea2:	e8 a9 06 00 00       	call   80104550 <acquire>
80103ea7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eaa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103eb1:	eb 13                	jmp    80103ec6 <wait+0x46>
80103eb3:	90                   	nop
80103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ebe:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103ec4:	73 1e                	jae    80103ee4 <wait+0x64>
      if(p->parent != curproc)
80103ec6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ec9:	75 ed                	jne    80103eb8 <wait+0x38>
      if(p->state == ZOMBIE){
80103ecb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ecf:	74 37                	je     80103f08 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103ed7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edc:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103ee2:	72 e2                	jb     80103ec6 <wait+0x46>
    if(!havekids || curproc->killed){
80103ee4:	85 c0                	test   %eax,%eax
80103ee6:	74 76                	je     80103f5e <wait+0xde>
80103ee8:	8b 46 24             	mov    0x24(%esi),%eax
80103eeb:	85 c0                	test   %eax,%eax
80103eed:	75 6f                	jne    80103f5e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103eef:	83 ec 08             	sub    $0x8,%esp
80103ef2:	68 20 2d 11 80       	push   $0x80112d20
80103ef7:	56                   	push   %esi
80103ef8:	e8 c3 fe ff ff       	call   80103dc0 <sleep>
    havekids = 0;
80103efd:	83 c4 10             	add    $0x10,%esp
80103f00:	eb a8                	jmp    80103eaa <wait+0x2a>
80103f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f0e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f11:	e8 3a e4 ff ff       	call   80102350 <kfree>
        freevm(p->pgdir);
80103f16:	5a                   	pop    %edx
80103f17:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f21:	e8 4a 2f 00 00       	call   80106e70 <freevm>
        release(&ptable.lock);
80103f26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f2d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f34:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f3b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f3f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f46:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f4d:	e8 be 06 00 00       	call   80104610 <release>
        return pid;
80103f52:	83 c4 10             	add    $0x10,%esp
}
80103f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f58:	89 f0                	mov    %esi,%eax
80103f5a:	5b                   	pop    %ebx
80103f5b:	5e                   	pop    %esi
80103f5c:	5d                   	pop    %ebp
80103f5d:	c3                   	ret    
      release(&ptable.lock);
80103f5e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f61:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f66:	68 20 2d 11 80       	push   $0x80112d20
80103f6b:	e8 a0 06 00 00       	call   80104610 <release>
      return -1;
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	eb e0                	jmp    80103f55 <wait+0xd5>
80103f75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 10             	sub    $0x10,%esp
80103f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f8a:	68 20 2d 11 80       	push   $0x80112d20
80103f8f:	e8 bc 05 00 00       	call   80104550 <acquire>
80103f94:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f97:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f9c:	eb 0e                	jmp    80103fac <wakeup+0x2c>
80103f9e:	66 90                	xchg   %ax,%ax
80103fa0:	05 90 00 00 00       	add    $0x90,%eax
80103fa5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103faa:	73 1e                	jae    80103fca <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103fac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fb0:	75 ee                	jne    80103fa0 <wakeup+0x20>
80103fb2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fb5:	75 e9                	jne    80103fa0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fb7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fbe:	05 90 00 00 00       	add    $0x90,%eax
80103fc3:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103fc8:	72 e2                	jb     80103fac <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103fca:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd4:	c9                   	leave  
  release(&ptable.lock);
80103fd5:	e9 36 06 00 00       	jmp    80104610 <release>
80103fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fe0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 10             	sub    $0x10,%esp
80103fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103fea:	68 20 2d 11 80       	push   $0x80112d20
80103fef:	e8 5c 05 00 00       	call   80104550 <acquire>
80103ff4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ffc:	eb 0e                	jmp    8010400c <kill+0x2c>
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	05 90 00 00 00       	add    $0x90,%eax
80104005:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010400a:	73 34                	jae    80104040 <kill+0x60>
    if(p->pid == pid){
8010400c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010400f:	75 ef                	jne    80104000 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104011:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104015:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010401c:	75 07                	jne    80104025 <kill+0x45>
        p->state = RUNNABLE;
8010401e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104025:	83 ec 0c             	sub    $0xc,%esp
80104028:	68 20 2d 11 80       	push   $0x80112d20
8010402d:	e8 de 05 00 00       	call   80104610 <release>
      return 0;
80104032:	83 c4 10             	add    $0x10,%esp
80104035:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104037:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010403a:	c9                   	leave  
8010403b:	c3                   	ret    
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	68 20 2d 11 80       	push   $0x80112d20
80104048:	e8 c3 05 00 00       	call   80104610 <release>
  return -1;
8010404d:	83 c4 10             	add    $0x10,%esp
80104050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104058:	c9                   	leave  
80104059:	c3                   	ret    
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104069:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010406e:	83 ec 3c             	sub    $0x3c,%esp
80104071:	eb 27                	jmp    8010409a <procdump+0x3a>
80104073:	90                   	nop
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 6f 7b 10 80       	push   $0x80107b6f
80104080:	e8 db c5 ff ff       	call   80100660 <cprintf>
80104085:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104088:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010408e:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104094:	0f 83 86 00 00 00    	jae    80104120 <procdump+0xc0>
    if(p->state == UNUSED)
8010409a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010409d:	85 c0                	test   %eax,%eax
8010409f:	74 e7                	je     80104088 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040a1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801040a4:	ba a0 77 10 80       	mov    $0x801077a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040a9:	77 11                	ja     801040bc <procdump+0x5c>
801040ab:	8b 14 85 18 78 10 80 	mov    -0x7fef87e8(,%eax,4),%edx
      state = "???";
801040b2:	b8 a0 77 10 80       	mov    $0x801077a0,%eax
801040b7:	85 d2                	test   %edx,%edx
801040b9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040bf:	50                   	push   %eax
801040c0:	52                   	push   %edx
801040c1:	ff 73 10             	pushl  0x10(%ebx)
801040c4:	68 a4 77 10 80       	push   $0x801077a4
801040c9:	e8 92 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040ce:	83 c4 10             	add    $0x10,%esp
801040d1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040d5:	75 a1                	jne    80104078 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040d7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040da:	83 ec 08             	sub    $0x8,%esp
801040dd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040e0:	50                   	push   %eax
801040e1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801040e4:	8b 40 0c             	mov    0xc(%eax),%eax
801040e7:	83 c0 08             	add    $0x8,%eax
801040ea:	50                   	push   %eax
801040eb:	e8 40 03 00 00       	call   80104430 <getcallerpcs>
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801040f8:	8b 17                	mov    (%edi),%edx
801040fa:	85 d2                	test   %edx,%edx
801040fc:	0f 84 76 ff ff ff    	je     80104078 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104102:	83 ec 08             	sub    $0x8,%esp
80104105:	83 c7 04             	add    $0x4,%edi
80104108:	52                   	push   %edx
80104109:	68 e1 71 10 80       	push   $0x801071e1
8010410e:	e8 4d c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104113:	83 c4 10             	add    $0x10,%esp
80104116:	39 fe                	cmp    %edi,%esi
80104118:	75 de                	jne    801040f8 <procdump+0x98>
8010411a:	e9 59 ff ff ff       	jmp    80104078 <procdump+0x18>
8010411f:	90                   	nop
  }
}
80104120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104123:	5b                   	pop    %ebx
80104124:	5e                   	pop    %esi
80104125:	5f                   	pop    %edi
80104126:	5d                   	pop    %ebp
80104127:	c3                   	ret    
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <changeQueueNum>:

int
changeQueueNum(int pid , int queue)
{
80104130:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104131:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
80104136:	89 e5                	mov    %esp,%ebp
80104138:	8b 55 08             	mov    0x8(%ebp),%edx
8010413b:	eb 0f                	jmp    8010414c <changeQueueNum+0x1c>
8010413d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104140:	05 90 00 00 00       	add    $0x90,%eax
80104145:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010414a:	73 1c                	jae    80104168 <changeQueueNum+0x38>
    if (p->pid == pid) {
8010414c:	39 50 10             	cmp    %edx,0x10(%eax)
8010414f:	75 ef                	jne    80104140 <changeQueueNum+0x10>
      p->queueNum = queue;
80104151:	8b 55 0c             	mov    0xc(%ebp),%edx
80104154:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      return 1;
8010415a:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return -1;
}
8010415f:	5d                   	pop    %ebp
80104160:	c3                   	ret    
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80104168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010416d:	5d                   	pop    %ebp
8010416e:	c3                   	ret    
8010416f:	90                   	nop

80104170 <evalTicket>:

int
evalTicket(int pid, int ticket)
{
80104170:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104171:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
80104176:	89 e5                	mov    %esp,%ebp
80104178:	8b 55 08             	mov    0x8(%ebp),%edx
8010417b:	eb 0f                	jmp    8010418c <evalTicket+0x1c>
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104180:	05 90 00 00 00       	add    $0x90,%eax
80104185:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010418a:	73 14                	jae    801041a0 <evalTicket+0x30>
    if (p->pid == pid) {
8010418c:	39 50 10             	cmp    %edx,0x10(%eax)
8010418f:	75 ef                	jne    80104180 <evalTicket+0x10>
      p->ticket = ticket;
80104191:	8b 55 0c             	mov    0xc(%ebp),%edx
80104194:	89 50 7c             	mov    %edx,0x7c(%eax)
      return 1;
80104197:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return -1;
}
8010419c:	5d                   	pop    %ebp
8010419d:	c3                   	ret    
8010419e:	66 90                	xchg   %ax,%ax
  return -1;
801041a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041a5:	5d                   	pop    %ebp
801041a6:	c3                   	ret    
801041a7:	89 f6                	mov    %esi,%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <stof>:

float stof(char* s) {
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	83 ec 04             	sub    $0x4,%esp
801041b6:	8b 55 08             	mov    0x8(%ebp),%edx
  float rez = 0, fact = 1;
  if (*s == '-'){
801041b9:	0f be 02             	movsbl (%edx),%eax
801041bc:	3c 2d                	cmp    $0x2d,%al
801041be:	74 60                	je     80104220 <stof+0x70>
    s++;
    fact = -1;
  };
  for (int point_seen = 0; *s; s++){
801041c0:	84 c0                	test   %al,%al
801041c2:	d9 e8                	fld1   
801041c4:	74 69                	je     8010422f <stof+0x7f>
801041c6:	31 c9                	xor    %ecx,%ecx
801041c8:	d9 ee                	fldz   
801041ca:	eb 34                	jmp    80104200 <stof+0x50>
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*s == '.'){
      point_seen = 1; 
      continue;
    };
    int d = *s - '0';
801041d0:	83 e8 30             	sub    $0x30,%eax
    if (d >= 0 && d <= 9){
801041d3:	83 f8 09             	cmp    $0x9,%eax
801041d6:	77 1e                	ja     801041f6 <stof+0x46>
      if (point_seen) fact /= 10.0f;
801041d8:	85 c9                	test   %ecx,%ecx
801041da:	74 0a                	je     801041e6 <stof+0x36>
801041dc:	d9 c9                	fxch   %st(1)
801041de:	d8 35 30 78 10 80    	fdivs  0x80107830
801041e4:	d9 c9                	fxch   %st(1)
      rez = rez * 10.0f + (float)d;
801041e6:	d9 05 30 78 10 80    	flds   0x80107830
801041ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
801041ef:	de c9                	fmulp  %st,%st(1)
801041f1:	db 45 fc             	fildl  -0x4(%ebp)
801041f4:	de c1                	faddp  %st,%st(1)
  for (int point_seen = 0; *s; s++){
801041f6:	83 c2 01             	add    $0x1,%edx
801041f9:	0f be 02             	movsbl (%edx),%eax
801041fc:	84 c0                	test   %al,%al
801041fe:	74 13                	je     80104213 <stof+0x63>
    if (*s == '.'){
80104200:	3c 2e                	cmp    $0x2e,%al
80104202:	75 cc                	jne    801041d0 <stof+0x20>
  for (int point_seen = 0; *s; s++){
80104204:	83 c2 01             	add    $0x1,%edx
80104207:	0f be 02             	movsbl (%edx),%eax
      point_seen = 1; 
8010420a:	b9 01 00 00 00       	mov    $0x1,%ecx
  for (int point_seen = 0; *s; s++){
8010420f:	84 c0                	test   %al,%al
80104211:	75 ed                	jne    80104200 <stof+0x50>
    };
  };
  return rez * fact;
80104213:	de c9                	fmulp  %st,%st(1)
}
80104215:	c9                   	leave  
80104216:	c3                   	ret    
80104217:	89 f6                	mov    %esi,%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104220:	0f be 42 01          	movsbl 0x1(%edx),%eax
    fact = -1;
80104224:	d9 e8                	fld1   
    s++;
80104226:	83 c2 01             	add    $0x1,%edx
    fact = -1;
80104229:	d9 e0                	fchs   
  for (int point_seen = 0; *s; s++){
8010422b:	84 c0                	test   %al,%al
8010422d:	75 97                	jne    801041c6 <stof+0x16>
8010422f:	d9 ee                	fldz   
}
80104231:	c9                   	leave  
  return rez * fact;
80104232:	de c9                	fmulp  %st,%st(1)
}
80104234:	c3                   	ret    
80104235:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <evalRemainingPriority>:

int
evalRemainingPriority(int pid, char* priority)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 14             	sub    $0x14,%esp
  float kiw = 12.31;
  float pri = stof(priority);
80104247:	ff 75 0c             	pushl  0xc(%ebp)
8010424a:	e8 61 ff ff ff       	call   801041b0 <stof>
  int ki = (int) (pri * 100);
8010424f:	d9 7d f6             	fnstcw -0xa(%ebp)
  float pri = stof(priority);
80104252:	58                   	pop    %eax
  int ki = (int) (pri * 100);
80104253:	d9 05 34 78 10 80    	flds   0x80107834
80104259:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
8010425d:	d8 c9                	fmul   %st(1),%st
8010425f:	b4 0c                	mov    $0xc,%ah
80104261:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80104265:	d9 6d f4             	fldcw  -0xc(%ebp)
80104268:	db 5d f0             	fistpl -0x10(%ebp)
8010426b:	d9 6d f6             	fldcw  -0xa(%ebp)
8010426e:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  if (ki == 1231)
80104271:	81 fb cf 04 00 00    	cmp    $0x4cf,%ebx
80104277:	74 37                	je     801042b0 <evalRemainingPriority+0x70>
    cprintf("int\n");
  if (pri == kiw)
80104279:	d9 05 38 78 10 80    	flds   0x80107838
8010427f:	d9 c9                	fxch   %st(1)
80104281:	df e9                	fucomip %st(1),%st
80104283:	dd d8                	fstp   %st(0)
80104285:	7a 12                	jp     80104299 <evalRemainingPriority+0x59>
80104287:	75 10                	jne    80104299 <evalRemainingPriority+0x59>
    cprintf("float\n");
80104289:	83 ec 0c             	sub    $0xc,%esp
8010428c:	68 b2 77 10 80       	push   $0x801077b2
80104291:	e8 ca c3 ff ff       	call   80100660 <cprintf>
80104296:	83 c4 10             	add    $0x10,%esp
  cprintf("f is : %d\n", ki);
80104299:	83 ec 08             	sub    $0x8,%esp
8010429c:	53                   	push   %ebx
8010429d:	68 b9 77 10 80       	push   $0x801077b9
801042a2:	e8 b9 c3 ff ff       	call   80100660 <cprintf>
  return 0;
}
801042a7:	31 c0                	xor    %eax,%eax
801042a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ac:	c9                   	leave  
801042ad:	c3                   	ret    
801042ae:	66 90                	xchg   %ax,%ax
    cprintf("int\n");
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	d9 5d ec             	fstps  -0x14(%ebp)
801042b6:	68 ad 77 10 80       	push   $0x801077ad
801042bb:	e8 a0 c3 ff ff       	call   80100660 <cprintf>
801042c0:	83 c4 10             	add    $0x10,%esp
801042c3:	d9 45 ec             	flds   -0x14(%ebp)
801042c6:	eb b1                	jmp    80104279 <evalRemainingPriority+0x39>
801042c8:	90                   	nop
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042d0 <printInfo>:

int
printInfo(void)
{
801042d0:	55                   	push   %ebp
  return 25; //change here
}
801042d1:	b8 19 00 00 00       	mov    $0x19,%eax
{
801042d6:	89 e5                	mov    %esp,%ebp
}
801042d8:	5d                   	pop    %ebp
801042d9:	c3                   	ret    
801042da:	66 90                	xchg   %ax,%ax
801042dc:	66 90                	xchg   %ax,%ax
801042de:	66 90                	xchg   %ax,%ax

801042e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 0c             	sub    $0xc,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ea:	68 3c 78 10 80       	push   $0x8010783c
801042ef:	8d 43 04             	lea    0x4(%ebx),%eax
801042f2:	50                   	push   %eax
801042f3:	e8 18 01 00 00       	call   80104410 <initlock>
  lk->name = name;
801042f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104301:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104304:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010430b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010430e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104311:	c9                   	leave  
80104312:	c3                   	ret    
80104313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104320 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	8d 73 04             	lea    0x4(%ebx),%esi
8010432e:	56                   	push   %esi
8010432f:	e8 1c 02 00 00       	call   80104550 <acquire>
  while (lk->locked) {
80104334:	8b 13                	mov    (%ebx),%edx
80104336:	83 c4 10             	add    $0x10,%esp
80104339:	85 d2                	test   %edx,%edx
8010433b:	74 16                	je     80104353 <acquiresleep+0x33>
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104340:	83 ec 08             	sub    $0x8,%esp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	e8 76 fa ff ff       	call   80103dc0 <sleep>
  while (lk->locked) {
8010434a:	8b 03                	mov    (%ebx),%eax
8010434c:	83 c4 10             	add    $0x10,%esp
8010434f:	85 c0                	test   %eax,%eax
80104351:	75 ed                	jne    80104340 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104353:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104359:	e8 c2 f4 ff ff       	call   80103820 <myproc>
8010435e:	8b 40 10             	mov    0x10(%eax),%eax
80104361:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104364:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104367:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5d                   	pop    %ebp
  release(&lk->lk);
8010436d:	e9 9e 02 00 00       	jmp    80104610 <release>
80104372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	8d 73 04             	lea    0x4(%ebx),%esi
8010438e:	56                   	push   %esi
8010438f:	e8 bc 01 00 00       	call   80104550 <acquire>
  lk->locked = 0;
80104394:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010439a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043a1:	89 1c 24             	mov    %ebx,(%esp)
801043a4:	e8 d7 fb ff ff       	call   80103f80 <wakeup>
  release(&lk->lk);
801043a9:	89 75 08             	mov    %esi,0x8(%ebp)
801043ac:	83 c4 10             	add    $0x10,%esp
}
801043af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b2:	5b                   	pop    %ebx
801043b3:	5e                   	pop    %esi
801043b4:	5d                   	pop    %ebp
  release(&lk->lk);
801043b5:	e9 56 02 00 00       	jmp    80104610 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	53                   	push   %ebx
801043c6:	31 ff                	xor    %edi,%edi
801043c8:	83 ec 18             	sub    $0x18,%esp
801043cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043ce:	8d 73 04             	lea    0x4(%ebx),%esi
801043d1:	56                   	push   %esi
801043d2:	e8 79 01 00 00       	call   80104550 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043d7:	8b 03                	mov    (%ebx),%eax
801043d9:	83 c4 10             	add    $0x10,%esp
801043dc:	85 c0                	test   %eax,%eax
801043de:	74 13                	je     801043f3 <holdingsleep+0x33>
801043e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043e3:	e8 38 f4 ff ff       	call   80103820 <myproc>
801043e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801043eb:	0f 94 c0             	sete   %al
801043ee:	0f b6 c0             	movzbl %al,%eax
801043f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	56                   	push   %esi
801043f7:	e8 14 02 00 00       	call   80104610 <release>
  return r;
}
801043fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ff:	89 f8                	mov    %edi,%eax
80104401:	5b                   	pop    %ebx
80104402:	5e                   	pop    %esi
80104403:	5f                   	pop    %edi
80104404:	5d                   	pop    %ebp
80104405:	c3                   	ret    
80104406:	66 90                	xchg   %ax,%ax
80104408:	66 90                	xchg   %ax,%ax
8010440a:	66 90                	xchg   %ax,%ax
8010440c:	66 90                	xchg   %ax,%ax
8010440e:	66 90                	xchg   %ax,%ax

80104410 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104416:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010441f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104422:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104429:	5d                   	pop    %ebp
8010442a:	c3                   	ret    
8010442b:	90                   	nop
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104430 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104430:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104431:	31 d2                	xor    %edx,%edx
{
80104433:	89 e5                	mov    %esp,%ebp
80104435:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104436:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010443c:	83 e8 08             	sub    $0x8,%eax
8010443f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104440:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010444c:	77 1a                	ja     80104468 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010444e:	8b 58 04             	mov    0x4(%eax),%ebx
80104451:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104454:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104457:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104459:	83 fa 0a             	cmp    $0xa,%edx
8010445c:	75 e2                	jne    80104440 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010445e:	5b                   	pop    %ebx
8010445f:	5d                   	pop    %ebp
80104460:	c3                   	ret    
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104468:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010446b:	83 c1 28             	add    $0x28,%ecx
8010446e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104476:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104479:	39 c1                	cmp    %eax,%ecx
8010447b:	75 f3                	jne    80104470 <getcallerpcs+0x40>
}
8010447d:	5b                   	pop    %ebx
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	9c                   	pushf  
80104488:	5b                   	pop    %ebx
  asm volatile("cli");
80104489:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448a:	e8 f1 f2 ff ff       	call   80103780 <mycpu>
8010448f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	75 11                	jne    801044aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104499:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010449f:	e8 dc f2 ff ff       	call   80103780 <mycpu>
801044a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801044aa:	e8 d1 f2 ff ff       	call   80103780 <mycpu>
801044af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044b6:	83 c4 04             	add    $0x4,%esp
801044b9:	5b                   	pop    %ebx
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <popcli>:

void
popcli(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c6:	9c                   	pushf  
801044c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044c8:	f6 c4 02             	test   $0x2,%ah
801044cb:	75 35                	jne    80104502 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044cd:	e8 ae f2 ff ff       	call   80103780 <mycpu>
801044d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044d9:	78 34                	js     8010450f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044db:	e8 a0 f2 ff ff       	call   80103780 <mycpu>
801044e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044e6:	85 d2                	test   %edx,%edx
801044e8:	74 06                	je     801044f0 <popcli+0x30>
    sti();
}
801044ea:	c9                   	leave  
801044eb:	c3                   	ret    
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044f0:	e8 8b f2 ff ff       	call   80103780 <mycpu>
801044f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044fb:	85 c0                	test   %eax,%eax
801044fd:	74 eb                	je     801044ea <popcli+0x2a>
  asm volatile("sti");
801044ff:	fb                   	sti    
}
80104500:	c9                   	leave  
80104501:	c3                   	ret    
    panic("popcli - interruptible");
80104502:	83 ec 0c             	sub    $0xc,%esp
80104505:	68 47 78 10 80       	push   $0x80107847
8010450a:	e8 81 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010450f:	83 ec 0c             	sub    $0xc,%esp
80104512:	68 5e 78 10 80       	push   $0x8010785e
80104517:	e8 74 be ff ff       	call   80100390 <panic>
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <holding>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 75 08             	mov    0x8(%ebp),%esi
80104528:	31 db                	xor    %ebx,%ebx
  pushcli();
8010452a:	e8 51 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010452f:	8b 06                	mov    (%esi),%eax
80104531:	85 c0                	test   %eax,%eax
80104533:	74 10                	je     80104545 <holding+0x25>
80104535:	8b 5e 08             	mov    0x8(%esi),%ebx
80104538:	e8 43 f2 ff ff       	call   80103780 <mycpu>
8010453d:	39 c3                	cmp    %eax,%ebx
8010453f:	0f 94 c3             	sete   %bl
80104542:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104545:	e8 76 ff ff ff       	call   801044c0 <popcli>
}
8010454a:	89 d8                	mov    %ebx,%eax
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    

80104550 <acquire>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104555:	e8 26 ff ff ff       	call   80104480 <pushcli>
  if(holding(lk))
8010455a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	53                   	push   %ebx
80104561:	e8 ba ff ff ff       	call   80104520 <holding>
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	85 c0                	test   %eax,%eax
8010456b:	0f 85 83 00 00 00    	jne    801045f4 <acquire+0xa4>
80104571:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104573:	ba 01 00 00 00       	mov    $0x1,%edx
80104578:	eb 09                	jmp    80104583 <acquire+0x33>
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104580:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104583:	89 d0                	mov    %edx,%eax
80104585:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104588:	85 c0                	test   %eax,%eax
8010458a:	75 f4                	jne    80104580 <acquire+0x30>
  __sync_synchronize();
8010458c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104591:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104594:	e8 e7 f1 ff ff       	call   80103780 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104599:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010459c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010459f:	89 e8                	mov    %ebp,%eax
801045a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801045ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801045b4:	77 1a                	ja     801045d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801045b6:	8b 48 04             	mov    0x4(%eax),%ecx
801045b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801045bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801045bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045c1:	83 fe 0a             	cmp    $0xa,%esi
801045c4:	75 e2                	jne    801045a8 <acquire+0x58>
}
801045c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c9:	5b                   	pop    %ebx
801045ca:	5e                   	pop    %esi
801045cb:	5d                   	pop    %ebp
801045cc:	c3                   	ret    
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801045d3:	83 c2 28             	add    $0x28,%edx
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801045e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045e9:	39 d0                	cmp    %edx,%eax
801045eb:	75 f3                	jne    801045e0 <acquire+0x90>
}
801045ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f0:	5b                   	pop    %ebx
801045f1:	5e                   	pop    %esi
801045f2:	5d                   	pop    %ebp
801045f3:	c3                   	ret    
    panic("acquire");
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	68 65 78 10 80       	push   $0x80107865
801045fc:	e8 8f bd ff ff       	call   80100390 <panic>
80104601:	eb 0d                	jmp    80104610 <release>
80104603:	90                   	nop
80104604:	90                   	nop
80104605:	90                   	nop
80104606:	90                   	nop
80104607:	90                   	nop
80104608:	90                   	nop
80104609:	90                   	nop
8010460a:	90                   	nop
8010460b:	90                   	nop
8010460c:	90                   	nop
8010460d:	90                   	nop
8010460e:	90                   	nop
8010460f:	90                   	nop

80104610 <release>:
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 10             	sub    $0x10,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010461a:	53                   	push   %ebx
8010461b:	e8 00 ff ff ff       	call   80104520 <holding>
80104620:	83 c4 10             	add    $0x10,%esp
80104623:	85 c0                	test   %eax,%eax
80104625:	74 22                	je     80104649 <release+0x39>
  lk->pcs[0] = 0;
80104627:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010462e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104635:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010463a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104643:	c9                   	leave  
  popcli();
80104644:	e9 77 fe ff ff       	jmp    801044c0 <popcli>
    panic("release");
80104649:	83 ec 0c             	sub    $0xc,%esp
8010464c:	68 6d 78 10 80       	push   $0x8010786d
80104651:	e8 3a bd ff ff       	call   80100390 <panic>
80104656:	66 90                	xchg   %ax,%ax
80104658:	66 90                	xchg   %ax,%ax
8010465a:	66 90                	xchg   %ax,%ax
8010465c:	66 90                	xchg   %ax,%ax
8010465e:	66 90                	xchg   %ax,%ax

80104660 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	53                   	push   %ebx
80104665:	8b 55 08             	mov    0x8(%ebp),%edx
80104668:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010466b:	f6 c2 03             	test   $0x3,%dl
8010466e:	75 05                	jne    80104675 <memset+0x15>
80104670:	f6 c1 03             	test   $0x3,%cl
80104673:	74 13                	je     80104688 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104675:	89 d7                	mov    %edx,%edi
80104677:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467a:	fc                   	cld    
8010467b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010467d:	5b                   	pop    %ebx
8010467e:	89 d0                	mov    %edx,%eax
80104680:	5f                   	pop    %edi
80104681:	5d                   	pop    %ebp
80104682:	c3                   	ret    
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104688:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010468c:	c1 e9 02             	shr    $0x2,%ecx
8010468f:	89 f8                	mov    %edi,%eax
80104691:	89 fb                	mov    %edi,%ebx
80104693:	c1 e0 18             	shl    $0x18,%eax
80104696:	c1 e3 10             	shl    $0x10,%ebx
80104699:	09 d8                	or     %ebx,%eax
8010469b:	09 f8                	or     %edi,%eax
8010469d:	c1 e7 08             	shl    $0x8,%edi
801046a0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	fc                   	cld    
801046a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801046a7:	5b                   	pop    %ebx
801046a8:	89 d0                	mov    %edx,%eax
801046aa:	5f                   	pop    %edi
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
801046ad:	8d 76 00             	lea    0x0(%esi),%esi

801046b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046b9:	8b 75 08             	mov    0x8(%ebp),%esi
801046bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046bf:	85 db                	test   %ebx,%ebx
801046c1:	74 29                	je     801046ec <memcmp+0x3c>
    if(*s1 != *s2)
801046c3:	0f b6 16             	movzbl (%esi),%edx
801046c6:	0f b6 0f             	movzbl (%edi),%ecx
801046c9:	38 d1                	cmp    %dl,%cl
801046cb:	75 2b                	jne    801046f8 <memcmp+0x48>
801046cd:	b8 01 00 00 00       	mov    $0x1,%eax
801046d2:	eb 14                	jmp    801046e8 <memcmp+0x38>
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801046dc:	83 c0 01             	add    $0x1,%eax
801046df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801046e4:	38 ca                	cmp    %cl,%dl
801046e6:	75 10                	jne    801046f8 <memcmp+0x48>
  while(n-- > 0){
801046e8:	39 d8                	cmp    %ebx,%eax
801046ea:	75 ec                	jne    801046d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046ec:	5b                   	pop    %ebx
  return 0;
801046ed:	31 c0                	xor    %eax,%eax
}
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801046f8:	0f b6 c2             	movzbl %dl,%eax
}
801046fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801046fc:	29 c8                	sub    %ecx,%eax
}
801046fe:	5e                   	pop    %esi
801046ff:	5f                   	pop    %edi
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 45 08             	mov    0x8(%ebp),%eax
80104718:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010471b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010471e:	39 c3                	cmp    %eax,%ebx
80104720:	73 26                	jae    80104748 <memmove+0x38>
80104722:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104725:	39 c8                	cmp    %ecx,%eax
80104727:	73 1f                	jae    80104748 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104729:	85 f6                	test   %esi,%esi
8010472b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010472e:	74 0f                	je     8010473f <memmove+0x2f>
      *--d = *--s;
80104730:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104734:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104737:	83 ea 01             	sub    $0x1,%edx
8010473a:	83 fa ff             	cmp    $0xffffffff,%edx
8010473d:	75 f1                	jne    80104730 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010473f:	5b                   	pop    %ebx
80104740:	5e                   	pop    %esi
80104741:	5d                   	pop    %ebp
80104742:	c3                   	ret    
80104743:	90                   	nop
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104748:	31 d2                	xor    %edx,%edx
8010474a:	85 f6                	test   %esi,%esi
8010474c:	74 f1                	je     8010473f <memmove+0x2f>
8010474e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104750:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104754:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104757:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010475a:	39 d6                	cmp    %edx,%esi
8010475c:	75 f2                	jne    80104750 <memmove+0x40>
}
8010475e:	5b                   	pop    %ebx
8010475f:	5e                   	pop    %esi
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret    
80104762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104773:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104774:	eb 9a                	jmp    80104710 <memmove>
80104776:	8d 76 00             	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	8b 7d 10             	mov    0x10(%ebp),%edi
80104788:	53                   	push   %ebx
80104789:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010478c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010478f:	85 ff                	test   %edi,%edi
80104791:	74 2f                	je     801047c2 <strncmp+0x42>
80104793:	0f b6 01             	movzbl (%ecx),%eax
80104796:	0f b6 1e             	movzbl (%esi),%ebx
80104799:	84 c0                	test   %al,%al
8010479b:	74 37                	je     801047d4 <strncmp+0x54>
8010479d:	38 c3                	cmp    %al,%bl
8010479f:	75 33                	jne    801047d4 <strncmp+0x54>
801047a1:	01 f7                	add    %esi,%edi
801047a3:	eb 13                	jmp    801047b8 <strncmp+0x38>
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
801047a8:	0f b6 01             	movzbl (%ecx),%eax
801047ab:	84 c0                	test   %al,%al
801047ad:	74 21                	je     801047d0 <strncmp+0x50>
801047af:	0f b6 1a             	movzbl (%edx),%ebx
801047b2:	89 d6                	mov    %edx,%esi
801047b4:	38 d8                	cmp    %bl,%al
801047b6:	75 1c                	jne    801047d4 <strncmp+0x54>
    n--, p++, q++;
801047b8:	8d 56 01             	lea    0x1(%esi),%edx
801047bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047be:	39 fa                	cmp    %edi,%edx
801047c0:	75 e6                	jne    801047a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047c2:	5b                   	pop    %ebx
    return 0;
801047c3:	31 c0                	xor    %eax,%eax
}
801047c5:	5e                   	pop    %esi
801047c6:	5f                   	pop    %edi
801047c7:	5d                   	pop    %ebp
801047c8:	c3                   	ret    
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801047d4:	29 d8                	sub    %ebx,%eax
}
801047d6:	5b                   	pop    %ebx
801047d7:	5e                   	pop    %esi
801047d8:	5f                   	pop    %edi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	90                   	nop
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 45 08             	mov    0x8(%ebp),%eax
801047e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047ee:	89 c2                	mov    %eax,%edx
801047f0:	eb 19                	jmp    8010480b <strncpy+0x2b>
801047f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f8:	83 c3 01             	add    $0x1,%ebx
801047fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801047ff:	83 c2 01             	add    $0x1,%edx
80104802:	84 c9                	test   %cl,%cl
80104804:	88 4a ff             	mov    %cl,-0x1(%edx)
80104807:	74 09                	je     80104812 <strncpy+0x32>
80104809:	89 f1                	mov    %esi,%ecx
8010480b:	85 c9                	test   %ecx,%ecx
8010480d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104810:	7f e6                	jg     801047f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104812:	31 c9                	xor    %ecx,%ecx
80104814:	85 f6                	test   %esi,%esi
80104816:	7e 17                	jle    8010482f <strncpy+0x4f>
80104818:	90                   	nop
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104820:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104824:	89 f3                	mov    %esi,%ebx
80104826:	83 c1 01             	add    $0x1,%ecx
80104829:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010482b:	85 db                	test   %ebx,%ebx
8010482d:	7f f1                	jg     80104820 <strncpy+0x40>
  return os;
}
8010482f:	5b                   	pop    %ebx
80104830:	5e                   	pop    %esi
80104831:	5d                   	pop    %ebp
80104832:	c3                   	ret    
80104833:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104848:	8b 45 08             	mov    0x8(%ebp),%eax
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010484e:	85 c9                	test   %ecx,%ecx
80104850:	7e 26                	jle    80104878 <safestrcpy+0x38>
80104852:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104856:	89 c1                	mov    %eax,%ecx
80104858:	eb 17                	jmp    80104871 <safestrcpy+0x31>
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104860:	83 c2 01             	add    $0x1,%edx
80104863:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104867:	83 c1 01             	add    $0x1,%ecx
8010486a:	84 db                	test   %bl,%bl
8010486c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010486f:	74 04                	je     80104875 <safestrcpy+0x35>
80104871:	39 f2                	cmp    %esi,%edx
80104873:	75 eb                	jne    80104860 <safestrcpy+0x20>
    ;
  *s = 0;
80104875:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104878:	5b                   	pop    %ebx
80104879:	5e                   	pop    %esi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <strlen>:

int
strlen(const char *s)
{
80104880:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104881:	31 c0                	xor    %eax,%eax
{
80104883:	89 e5                	mov    %esp,%ebp
80104885:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104888:	80 3a 00             	cmpb   $0x0,(%edx)
8010488b:	74 0c                	je     80104899 <strlen+0x19>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
80104890:	83 c0 01             	add    $0x1,%eax
80104893:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104897:	75 f7                	jne    80104890 <strlen+0x10>
    ;
  return n;
}
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    

8010489b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010489b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010489f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048a3:	55                   	push   %ebp
  pushl %ebx
801048a4:	53                   	push   %ebx
  pushl %esi
801048a5:	56                   	push   %esi
  pushl %edi
801048a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048ab:	5f                   	pop    %edi
  popl %esi
801048ac:	5e                   	pop    %esi
  popl %ebx
801048ad:	5b                   	pop    %ebx
  popl %ebp
801048ae:	5d                   	pop    %ebp
  ret
801048af:	c3                   	ret    

801048b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ba:	e8 61 ef ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048bf:	8b 00                	mov    (%eax),%eax
801048c1:	39 d8                	cmp    %ebx,%eax
801048c3:	76 1b                	jbe    801048e0 <fetchint+0x30>
801048c5:	8d 53 04             	lea    0x4(%ebx),%edx
801048c8:	39 d0                	cmp    %edx,%eax
801048ca:	72 14                	jb     801048e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048cf:	8b 13                	mov    (%ebx),%edx
801048d1:	89 10                	mov    %edx,(%eax)
  return 0;
801048d3:	31 c0                	xor    %eax,%eax
}
801048d5:	83 c4 04             	add    $0x4,%esp
801048d8:	5b                   	pop    %ebx
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	90                   	nop
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e5:	eb ee                	jmp    801048d5 <fetchint+0x25>
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048fa:	e8 21 ef ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz)
801048ff:	39 18                	cmp    %ebx,(%eax)
80104901:	76 29                	jbe    8010492c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104903:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104906:	89 da                	mov    %ebx,%edx
80104908:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010490a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010490c:	39 c3                	cmp    %eax,%ebx
8010490e:	73 1c                	jae    8010492c <fetchstr+0x3c>
    if(*s == 0)
80104910:	80 3b 00             	cmpb   $0x0,(%ebx)
80104913:	75 10                	jne    80104925 <fetchstr+0x35>
80104915:	eb 39                	jmp    80104950 <fetchstr+0x60>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104920:	80 3a 00             	cmpb   $0x0,(%edx)
80104923:	74 1b                	je     80104940 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104925:	83 c2 01             	add    $0x1,%edx
80104928:	39 d0                	cmp    %edx,%eax
8010492a:	77 f4                	ja     80104920 <fetchstr+0x30>
    return -1;
8010492c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104931:	83 c4 04             	add    $0x4,%esp
80104934:	5b                   	pop    %ebx
80104935:	5d                   	pop    %ebp
80104936:	c3                   	ret    
80104937:	89 f6                	mov    %esi,%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104940:	83 c4 04             	add    $0x4,%esp
80104943:	89 d0                	mov    %edx,%eax
80104945:	29 d8                	sub    %ebx,%eax
80104947:	5b                   	pop    %ebx
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104950:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104952:	eb dd                	jmp    80104931 <fetchstr+0x41>
80104954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010495a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104960 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104965:	e8 b6 ee ff ff       	call   80103820 <myproc>
8010496a:	8b 40 18             	mov    0x18(%eax),%eax
8010496d:	8b 55 08             	mov    0x8(%ebp),%edx
80104970:	8b 40 44             	mov    0x44(%eax),%eax
80104973:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104976:	e8 a5 ee ff ff       	call   80103820 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010497b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010497d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104980:	39 c6                	cmp    %eax,%esi
80104982:	73 1c                	jae    801049a0 <argint+0x40>
80104984:	8d 53 08             	lea    0x8(%ebx),%edx
80104987:	39 d0                	cmp    %edx,%eax
80104989:	72 15                	jb     801049a0 <argint+0x40>
  *ip = *(int*)(addr);
8010498b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498e:	8b 53 04             	mov    0x4(%ebx),%edx
80104991:	89 10                	mov    %edx,(%eax)
  return 0;
80104993:	31 c0                	xor    %eax,%eax
}
80104995:	5b                   	pop    %ebx
80104996:	5e                   	pop    %esi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a5:	eb ee                	jmp    80104995 <argint+0x35>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	83 ec 10             	sub    $0x10,%esp
801049b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049bb:	e8 60 ee ff ff       	call   80103820 <myproc>
801049c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801049c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049c5:	83 ec 08             	sub    $0x8,%esp
801049c8:	50                   	push   %eax
801049c9:	ff 75 08             	pushl  0x8(%ebp)
801049cc:	e8 8f ff ff ff       	call   80104960 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	85 c0                	test   %eax,%eax
801049d6:	78 28                	js     80104a00 <argptr+0x50>
801049d8:	85 db                	test   %ebx,%ebx
801049da:	78 24                	js     80104a00 <argptr+0x50>
801049dc:	8b 16                	mov    (%esi),%edx
801049de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e1:	39 c2                	cmp    %eax,%edx
801049e3:	76 1b                	jbe    80104a00 <argptr+0x50>
801049e5:	01 c3                	add    %eax,%ebx
801049e7:	39 da                	cmp    %ebx,%edx
801049e9:	72 15                	jb     80104a00 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801049eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801049ee:	89 02                	mov    %eax,(%edx)
  return 0;
801049f0:	31 c0                	xor    %eax,%eax
}
801049f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret    
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb eb                	jmp    801049f2 <argptr+0x42>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a19:	50                   	push   %eax
80104a1a:	ff 75 08             	pushl  0x8(%ebp)
80104a1d:	e8 3e ff ff ff       	call   80104960 <argint>
80104a22:	83 c4 10             	add    $0x10,%esp
80104a25:	85 c0                	test   %eax,%eax
80104a27:	78 17                	js     80104a40 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a29:	83 ec 08             	sub    $0x8,%esp
80104a2c:	ff 75 0c             	pushl  0xc(%ebp)
80104a2f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a32:	e8 b9 fe ff ff       	call   801048f0 <fetchstr>
80104a37:	83 c4 10             	add    $0x10,%esp
}
80104a3a:	c9                   	leave  
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a45:	c9                   	leave  
80104a46:	c3                   	ret    
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <syscall>:
[SYS_printInfo] sys_printInfo,
};

void
syscall(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a57:	e8 c4 ed ff ff       	call   80103820 <myproc>
80104a5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a5e:	8b 40 18             	mov    0x18(%eax),%eax
80104a61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a67:	83 fa 18             	cmp    $0x18,%edx
80104a6a:	77 1c                	ja     80104a88 <syscall+0x38>
80104a6c:	8b 14 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%edx
80104a73:	85 d2                	test   %edx,%edx
80104a75:	74 11                	je     80104a88 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a77:	ff d2                	call   *%edx
80104a79:	8b 53 18             	mov    0x18(%ebx),%edx
80104a7c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a82:	c9                   	leave  
80104a83:	c3                   	ret    
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a88:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a89:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a8c:	50                   	push   %eax
80104a8d:	ff 73 10             	pushl  0x10(%ebx)
80104a90:	68 75 78 10 80       	push   $0x80107875
80104a95:	e8 c6 bb ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104a9a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a9d:	83 c4 10             	add    $0x10,%esp
80104aa0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aaa:	c9                   	leave  
80104aab:	c3                   	ret    
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ab6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ab9:	83 ec 34             	sub    $0x34,%esp
80104abc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104abf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ac2:	56                   	push   %esi
80104ac3:	50                   	push   %eax
{
80104ac4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ac7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104aca:	e8 71 d4 ff ff       	call   80101f40 <nameiparent>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	0f 84 46 01 00 00    	je     80104c20 <create+0x170>
    return 0;
  ilock(dp);
80104ada:	83 ec 0c             	sub    $0xc,%esp
80104add:	89 c3                	mov    %eax,%ebx
80104adf:	50                   	push   %eax
80104ae0:	e8 db cb ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ae5:	83 c4 0c             	add    $0xc,%esp
80104ae8:	6a 00                	push   $0x0
80104aea:	56                   	push   %esi
80104aeb:	53                   	push   %ebx
80104aec:	e8 ff d0 ff ff       	call   80101bf0 <dirlookup>
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	85 c0                	test   %eax,%eax
80104af6:	89 c7                	mov    %eax,%edi
80104af8:	74 36                	je     80104b30 <create+0x80>
    iunlockput(dp);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	53                   	push   %ebx
80104afe:	e8 4d ce ff ff       	call   80101950 <iunlockput>
    ilock(ip);
80104b03:	89 3c 24             	mov    %edi,(%esp)
80104b06:	e8 b5 cb ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b0b:	83 c4 10             	add    $0x10,%esp
80104b0e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b13:	0f 85 97 00 00 00    	jne    80104bb0 <create+0x100>
80104b19:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104b1e:	0f 85 8c 00 00 00    	jne    80104bb0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b27:	89 f8                	mov    %edi,%eax
80104b29:	5b                   	pop    %ebx
80104b2a:	5e                   	pop    %esi
80104b2b:	5f                   	pop    %edi
80104b2c:	5d                   	pop    %ebp
80104b2d:	c3                   	ret    
80104b2e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104b30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b34:	83 ec 08             	sub    $0x8,%esp
80104b37:	50                   	push   %eax
80104b38:	ff 33                	pushl  (%ebx)
80104b3a:	e8 11 ca ff ff       	call   80101550 <ialloc>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	85 c0                	test   %eax,%eax
80104b44:	89 c7                	mov    %eax,%edi
80104b46:	0f 84 e8 00 00 00    	je     80104c34 <create+0x184>
  ilock(ip);
80104b4c:	83 ec 0c             	sub    $0xc,%esp
80104b4f:	50                   	push   %eax
80104b50:	e8 6b cb ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104b55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b59:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104b5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104b61:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104b65:	b8 01 00 00 00       	mov    $0x1,%eax
80104b6a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104b6e:	89 3c 24             	mov    %edi,(%esp)
80104b71:	e8 9a ca ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b76:	83 c4 10             	add    $0x10,%esp
80104b79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b7e:	74 50                	je     80104bd0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b80:	83 ec 04             	sub    $0x4,%esp
80104b83:	ff 77 04             	pushl  0x4(%edi)
80104b86:	56                   	push   %esi
80104b87:	53                   	push   %ebx
80104b88:	e8 d3 d2 ff ff       	call   80101e60 <dirlink>
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	85 c0                	test   %eax,%eax
80104b92:	0f 88 8f 00 00 00    	js     80104c27 <create+0x177>
  iunlockput(dp);
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	53                   	push   %ebx
80104b9c:	e8 af cd ff ff       	call   80101950 <iunlockput>
  return ip;
80104ba1:	83 c4 10             	add    $0x10,%esp
}
80104ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba7:	89 f8                	mov    %edi,%eax
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5f                   	pop    %edi
80104bac:	5d                   	pop    %ebp
80104bad:	c3                   	ret    
80104bae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	57                   	push   %edi
    return 0;
80104bb4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104bb6:	e8 95 cd ff ff       	call   80101950 <iunlockput>
    return 0;
80104bbb:	83 c4 10             	add    $0x10,%esp
}
80104bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc1:	89 f8                	mov    %edi,%eax
80104bc3:	5b                   	pop    %ebx
80104bc4:	5e                   	pop    %esi
80104bc5:	5f                   	pop    %edi
80104bc6:	5d                   	pop    %ebp
80104bc7:	c3                   	ret    
80104bc8:	90                   	nop
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104bd0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104bd5:	83 ec 0c             	sub    $0xc,%esp
80104bd8:	53                   	push   %ebx
80104bd9:	e8 32 ca ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bde:	83 c4 0c             	add    $0xc,%esp
80104be1:	ff 77 04             	pushl  0x4(%edi)
80104be4:	68 24 79 10 80       	push   $0x80107924
80104be9:	57                   	push   %edi
80104bea:	e8 71 d2 ff ff       	call   80101e60 <dirlink>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	78 1c                	js     80104c12 <create+0x162>
80104bf6:	83 ec 04             	sub    $0x4,%esp
80104bf9:	ff 73 04             	pushl  0x4(%ebx)
80104bfc:	68 23 79 10 80       	push   $0x80107923
80104c01:	57                   	push   %edi
80104c02:	e8 59 d2 ff ff       	call   80101e60 <dirlink>
80104c07:	83 c4 10             	add    $0x10,%esp
80104c0a:	85 c0                	test   %eax,%eax
80104c0c:	0f 89 6e ff ff ff    	jns    80104b80 <create+0xd0>
      panic("create dots");
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 17 79 10 80       	push   $0x80107917
80104c1a:	e8 71 b7 ff ff       	call   80100390 <panic>
80104c1f:	90                   	nop
    return 0;
80104c20:	31 ff                	xor    %edi,%edi
80104c22:	e9 fd fe ff ff       	jmp    80104b24 <create+0x74>
    panic("create: dirlink");
80104c27:	83 ec 0c             	sub    $0xc,%esp
80104c2a:	68 26 79 10 80       	push   $0x80107926
80104c2f:	e8 5c b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	68 08 79 10 80       	push   $0x80107908
80104c3c:	e8 4f b7 ff ff       	call   80100390 <panic>
80104c41:	eb 0d                	jmp    80104c50 <argfd.constprop.0>
80104c43:	90                   	nop
80104c44:	90                   	nop
80104c45:	90                   	nop
80104c46:	90                   	nop
80104c47:	90                   	nop
80104c48:	90                   	nop
80104c49:	90                   	nop
80104c4a:	90                   	nop
80104c4b:	90                   	nop
80104c4c:	90                   	nop
80104c4d:	90                   	nop
80104c4e:	90                   	nop
80104c4f:	90                   	nop

80104c50 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c5a:	89 d6                	mov    %edx,%esi
80104c5c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c5f:	50                   	push   %eax
80104c60:	6a 00                	push   $0x0
80104c62:	e8 f9 fc ff ff       	call   80104960 <argint>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	78 2a                	js     80104c98 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c6e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c72:	77 24                	ja     80104c98 <argfd.constprop.0+0x48>
80104c74:	e8 a7 eb ff ff       	call   80103820 <myproc>
80104c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c7c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c80:	85 c0                	test   %eax,%eax
80104c82:	74 14                	je     80104c98 <argfd.constprop.0+0x48>
  if(pfd)
80104c84:	85 db                	test   %ebx,%ebx
80104c86:	74 02                	je     80104c8a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c88:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c8a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c8c:	31 c0                	xor    %eax,%eax
}
80104c8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c91:	5b                   	pop    %ebx
80104c92:	5e                   	pop    %esi
80104c93:	5d                   	pop    %ebp
80104c94:	c3                   	ret    
80104c95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9d:	eb ef                	jmp    80104c8e <argfd.constprop.0+0x3e>
80104c9f:	90                   	nop

80104ca0 <sys_dup>:
{
80104ca0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	56                   	push   %esi
80104ca6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ca7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104caa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104cad:	e8 9e ff ff ff       	call   80104c50 <argfd.constprop.0>
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	78 42                	js     80104cf8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104cb6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cb9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104cbb:	e8 60 eb ff ff       	call   80103820 <myproc>
80104cc0:	eb 0e                	jmp    80104cd0 <sys_dup+0x30>
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cc8:	83 c3 01             	add    $0x1,%ebx
80104ccb:	83 fb 10             	cmp    $0x10,%ebx
80104cce:	74 28                	je     80104cf8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104cd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cd4:	85 d2                	test   %edx,%edx
80104cd6:	75 f0                	jne    80104cc8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104cd8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ce2:	e8 49 c1 ff ff       	call   80100e30 <filedup>
  return fd;
80104ce7:	83 c4 10             	add    $0x10,%esp
}
80104cea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ced:	89 d8                	mov    %ebx,%eax
80104cef:	5b                   	pop    %ebx
80104cf0:	5e                   	pop    %esi
80104cf1:	5d                   	pop    %ebp
80104cf2:	c3                   	ret    
80104cf3:	90                   	nop
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d00:	89 d8                	mov    %ebx,%eax
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret    
80104d06:	8d 76 00             	lea    0x0(%esi),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <sys_read>:
{
80104d10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d11:	31 c0                	xor    %eax,%eax
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d1b:	e8 30 ff ff ff       	call   80104c50 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 4c                	js     80104d70 <sys_read+0x60>
80104d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d27:	83 ec 08             	sub    $0x8,%esp
80104d2a:	50                   	push   %eax
80104d2b:	6a 02                	push   $0x2
80104d2d:	e8 2e fc ff ff       	call   80104960 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 37                	js     80104d70 <sys_read+0x60>
80104d39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3c:	83 ec 04             	sub    $0x4,%esp
80104d3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d42:	50                   	push   %eax
80104d43:	6a 01                	push   $0x1
80104d45:	e8 66 fc ff ff       	call   801049b0 <argptr>
80104d4a:	83 c4 10             	add    $0x10,%esp
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	78 1f                	js     80104d70 <sys_read+0x60>
  return fileread(f, p, n);
80104d51:	83 ec 04             	sub    $0x4,%esp
80104d54:	ff 75 f0             	pushl  -0x10(%ebp)
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d5d:	e8 3e c2 ff ff       	call   80100fa0 <fileread>
80104d62:	83 c4 10             	add    $0x10,%esp
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <sys_write>:
{
80104d80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d81:	31 c0                	xor    %eax,%eax
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d8b:	e8 c0 fe ff ff       	call   80104c50 <argfd.constprop.0>
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 4c                	js     80104de0 <sys_write+0x60>
80104d94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d97:	83 ec 08             	sub    $0x8,%esp
80104d9a:	50                   	push   %eax
80104d9b:	6a 02                	push   $0x2
80104d9d:	e8 be fb ff ff       	call   80104960 <argint>
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	85 c0                	test   %eax,%eax
80104da7:	78 37                	js     80104de0 <sys_write+0x60>
80104da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dac:	83 ec 04             	sub    $0x4,%esp
80104daf:	ff 75 f0             	pushl  -0x10(%ebp)
80104db2:	50                   	push   %eax
80104db3:	6a 01                	push   $0x1
80104db5:	e8 f6 fb ff ff       	call   801049b0 <argptr>
80104dba:	83 c4 10             	add    $0x10,%esp
80104dbd:	85 c0                	test   %eax,%eax
80104dbf:	78 1f                	js     80104de0 <sys_write+0x60>
  return filewrite(f, p, n);
80104dc1:	83 ec 04             	sub    $0x4,%esp
80104dc4:	ff 75 f0             	pushl  -0x10(%ebp)
80104dc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dca:	ff 75 ec             	pushl  -0x14(%ebp)
80104dcd:	e8 5e c2 ff ff       	call   80101030 <filewrite>
80104dd2:	83 c4 10             	add    $0x10,%esp
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <sys_close>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104df6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104df9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfc:	e8 4f fe ff ff       	call   80104c50 <argfd.constprop.0>
80104e01:	85 c0                	test   %eax,%eax
80104e03:	78 2b                	js     80104e30 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e05:	e8 16 ea ff ff       	call   80103820 <myproc>
80104e0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e0d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e10:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e17:	00 
  fileclose(f);
80104e18:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1b:	e8 60 c0 ff ff       	call   80100e80 <fileclose>
  return 0;
80104e20:	83 c4 10             	add    $0x10,%esp
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <sys_fstat>:
{
80104e40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e4b:	e8 00 fe ff ff       	call   80104c50 <argfd.constprop.0>
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 2c                	js     80104e80 <sys_fstat+0x40>
80104e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e57:	83 ec 04             	sub    $0x4,%esp
80104e5a:	6a 14                	push   $0x14
80104e5c:	50                   	push   %eax
80104e5d:	6a 01                	push   $0x1
80104e5f:	e8 4c fb ff ff       	call   801049b0 <argptr>
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	85 c0                	test   %eax,%eax
80104e69:	78 15                	js     80104e80 <sys_fstat+0x40>
  return filestat(f, st);
80104e6b:	83 ec 08             	sub    $0x8,%esp
80104e6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e71:	ff 75 f0             	pushl  -0x10(%ebp)
80104e74:	e8 d7 c0 ff ff       	call   80100f50 <filestat>
80104e79:	83 c4 10             	add    $0x10,%esp
}
80104e7c:	c9                   	leave  
80104e7d:	c3                   	ret    
80104e7e:	66 90                	xchg   %ax,%ax
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_link>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	56                   	push   %esi
80104e95:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e96:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e9c:	50                   	push   %eax
80104e9d:	6a 00                	push   $0x0
80104e9f:	e8 6c fb ff ff       	call   80104a10 <argstr>
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	0f 88 fb 00 00 00    	js     80104faa <sys_link+0x11a>
80104eaf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104eb2:	83 ec 08             	sub    $0x8,%esp
80104eb5:	50                   	push   %eax
80104eb6:	6a 01                	push   $0x1
80104eb8:	e8 53 fb ff ff       	call   80104a10 <argstr>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	0f 88 e2 00 00 00    	js     80104faa <sys_link+0x11a>
  begin_op();
80104ec8:	e8 13 dd ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
80104ecd:	83 ec 0c             	sub    $0xc,%esp
80104ed0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ed3:	e8 48 d0 ff ff       	call   80101f20 <namei>
80104ed8:	83 c4 10             	add    $0x10,%esp
80104edb:	85 c0                	test   %eax,%eax
80104edd:	89 c3                	mov    %eax,%ebx
80104edf:	0f 84 ea 00 00 00    	je     80104fcf <sys_link+0x13f>
  ilock(ip);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
80104ee8:	50                   	push   %eax
80104ee9:	e8 d2 c7 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104eee:	83 c4 10             	add    $0x10,%esp
80104ef1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ef6:	0f 84 bb 00 00 00    	je     80104fb7 <sys_link+0x127>
  ip->nlink++;
80104efc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f01:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104f04:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f07:	53                   	push   %ebx
80104f08:	e8 03 c7 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
80104f0d:	89 1c 24             	mov    %ebx,(%esp)
80104f10:	e8 8b c8 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f15:	58                   	pop    %eax
80104f16:	5a                   	pop    %edx
80104f17:	57                   	push   %edi
80104f18:	ff 75 d0             	pushl  -0x30(%ebp)
80104f1b:	e8 20 d0 ff ff       	call   80101f40 <nameiparent>
80104f20:	83 c4 10             	add    $0x10,%esp
80104f23:	85 c0                	test   %eax,%eax
80104f25:	89 c6                	mov    %eax,%esi
80104f27:	74 5b                	je     80104f84 <sys_link+0xf4>
  ilock(dp);
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	50                   	push   %eax
80104f2d:	e8 8e c7 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f32:	83 c4 10             	add    $0x10,%esp
80104f35:	8b 03                	mov    (%ebx),%eax
80104f37:	39 06                	cmp    %eax,(%esi)
80104f39:	75 3d                	jne    80104f78 <sys_link+0xe8>
80104f3b:	83 ec 04             	sub    $0x4,%esp
80104f3e:	ff 73 04             	pushl  0x4(%ebx)
80104f41:	57                   	push   %edi
80104f42:	56                   	push   %esi
80104f43:	e8 18 cf ff ff       	call   80101e60 <dirlink>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	78 29                	js     80104f78 <sys_link+0xe8>
  iunlockput(dp);
80104f4f:	83 ec 0c             	sub    $0xc,%esp
80104f52:	56                   	push   %esi
80104f53:	e8 f8 c9 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80104f58:	89 1c 24             	mov    %ebx,(%esp)
80104f5b:	e8 90 c8 ff ff       	call   801017f0 <iput>
  end_op();
80104f60:	e8 eb dc ff ff       	call   80102c50 <end_op>
  return 0;
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	31 c0                	xor    %eax,%eax
}
80104f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f78:	83 ec 0c             	sub    $0xc,%esp
80104f7b:	56                   	push   %esi
80104f7c:	e8 cf c9 ff ff       	call   80101950 <iunlockput>
    goto bad;
80104f81:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	53                   	push   %ebx
80104f88:	e8 33 c7 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104f8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f92:	89 1c 24             	mov    %ebx,(%esp)
80104f95:	e8 76 c6 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80104f9a:	89 1c 24             	mov    %ebx,(%esp)
80104f9d:	e8 ae c9 ff ff       	call   80101950 <iunlockput>
  end_op();
80104fa2:	e8 a9 dc ff ff       	call   80102c50 <end_op>
  return -1;
80104fa7:	83 c4 10             	add    $0x10,%esp
}
80104faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5f                   	pop    %edi
80104fb5:	5d                   	pop    %ebp
80104fb6:	c3                   	ret    
    iunlockput(ip);
80104fb7:	83 ec 0c             	sub    $0xc,%esp
80104fba:	53                   	push   %ebx
80104fbb:	e8 90 c9 ff ff       	call   80101950 <iunlockput>
    end_op();
80104fc0:	e8 8b dc ff ff       	call   80102c50 <end_op>
    return -1;
80104fc5:	83 c4 10             	add    $0x10,%esp
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcd:	eb 9b                	jmp    80104f6a <sys_link+0xda>
    end_op();
80104fcf:	e8 7c dc ff ff       	call   80102c50 <end_op>
    return -1;
80104fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd9:	eb 8f                	jmp    80104f6a <sys_link+0xda>
80104fdb:	90                   	nop
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <sys_unlink>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
80104fe5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104fe6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104fe9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104fec:	50                   	push   %eax
80104fed:	6a 00                	push   $0x0
80104fef:	e8 1c fa ff ff       	call   80104a10 <argstr>
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	0f 88 77 01 00 00    	js     80105176 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104fff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105002:	e8 d9 db ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105007:	83 ec 08             	sub    $0x8,%esp
8010500a:	53                   	push   %ebx
8010500b:	ff 75 c0             	pushl  -0x40(%ebp)
8010500e:	e8 2d cf ff ff       	call   80101f40 <nameiparent>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	89 c6                	mov    %eax,%esi
8010501a:	0f 84 60 01 00 00    	je     80105180 <sys_unlink+0x1a0>
  ilock(dp);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	50                   	push   %eax
80105024:	e8 97 c6 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105029:	58                   	pop    %eax
8010502a:	5a                   	pop    %edx
8010502b:	68 24 79 10 80       	push   $0x80107924
80105030:	53                   	push   %ebx
80105031:	e8 9a cb ff ff       	call   80101bd0 <namecmp>
80105036:	83 c4 10             	add    $0x10,%esp
80105039:	85 c0                	test   %eax,%eax
8010503b:	0f 84 03 01 00 00    	je     80105144 <sys_unlink+0x164>
80105041:	83 ec 08             	sub    $0x8,%esp
80105044:	68 23 79 10 80       	push   $0x80107923
80105049:	53                   	push   %ebx
8010504a:	e8 81 cb ff ff       	call   80101bd0 <namecmp>
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	85 c0                	test   %eax,%eax
80105054:	0f 84 ea 00 00 00    	je     80105144 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010505a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010505d:	83 ec 04             	sub    $0x4,%esp
80105060:	50                   	push   %eax
80105061:	53                   	push   %ebx
80105062:	56                   	push   %esi
80105063:	e8 88 cb ff ff       	call   80101bf0 <dirlookup>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	89 c3                	mov    %eax,%ebx
8010506f:	0f 84 cf 00 00 00    	je     80105144 <sys_unlink+0x164>
  ilock(ip);
80105075:	83 ec 0c             	sub    $0xc,%esp
80105078:	50                   	push   %eax
80105079:	e8 42 c6 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105086:	0f 8e 10 01 00 00    	jle    8010519c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010508c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105091:	74 6d                	je     80105100 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105093:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105096:	83 ec 04             	sub    $0x4,%esp
80105099:	6a 10                	push   $0x10
8010509b:	6a 00                	push   $0x0
8010509d:	50                   	push   %eax
8010509e:	e8 bd f5 ff ff       	call   80104660 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050a6:	6a 10                	push   $0x10
801050a8:	ff 75 c4             	pushl  -0x3c(%ebp)
801050ab:	50                   	push   %eax
801050ac:	56                   	push   %esi
801050ad:	e8 ee c9 ff ff       	call   80101aa0 <writei>
801050b2:	83 c4 20             	add    $0x20,%esp
801050b5:	83 f8 10             	cmp    $0x10,%eax
801050b8:	0f 85 eb 00 00 00    	jne    801051a9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801050be:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050c3:	0f 84 97 00 00 00    	je     80105160 <sys_unlink+0x180>
  iunlockput(dp);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	56                   	push   %esi
801050cd:	e8 7e c8 ff ff       	call   80101950 <iunlockput>
  ip->nlink--;
801050d2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050d7:	89 1c 24             	mov    %ebx,(%esp)
801050da:	e8 31 c5 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801050df:	89 1c 24             	mov    %ebx,(%esp)
801050e2:	e8 69 c8 ff ff       	call   80101950 <iunlockput>
  end_op();
801050e7:	e8 64 db ff ff       	call   80102c50 <end_op>
  return 0;
801050ec:	83 c4 10             	add    $0x10,%esp
801050ef:	31 c0                	xor    %eax,%eax
}
801050f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f4:	5b                   	pop    %ebx
801050f5:	5e                   	pop    %esi
801050f6:	5f                   	pop    %edi
801050f7:	5d                   	pop    %ebp
801050f8:	c3                   	ret    
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105100:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105104:	76 8d                	jbe    80105093 <sys_unlink+0xb3>
80105106:	bf 20 00 00 00       	mov    $0x20,%edi
8010510b:	eb 0f                	jmp    8010511c <sys_unlink+0x13c>
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
80105110:	83 c7 10             	add    $0x10,%edi
80105113:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105116:	0f 83 77 ff ff ff    	jae    80105093 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010511c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010511f:	6a 10                	push   $0x10
80105121:	57                   	push   %edi
80105122:	50                   	push   %eax
80105123:	53                   	push   %ebx
80105124:	e8 77 c8 ff ff       	call   801019a0 <readi>
80105129:	83 c4 10             	add    $0x10,%esp
8010512c:	83 f8 10             	cmp    $0x10,%eax
8010512f:	75 5e                	jne    8010518f <sys_unlink+0x1af>
    if(de.inum != 0)
80105131:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105136:	74 d8                	je     80105110 <sys_unlink+0x130>
    iunlockput(ip);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	53                   	push   %ebx
8010513c:	e8 0f c8 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105141:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	56                   	push   %esi
80105148:	e8 03 c8 ff ff       	call   80101950 <iunlockput>
  end_op();
8010514d:	e8 fe da ff ff       	call   80102c50 <end_op>
  return -1;
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515a:	eb 95                	jmp    801050f1 <sys_unlink+0x111>
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105160:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	56                   	push   %esi
80105169:	e8 a2 c4 ff ff       	call   80101610 <iupdate>
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	e9 53 ff ff ff       	jmp    801050c9 <sys_unlink+0xe9>
    return -1;
80105176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517b:	e9 71 ff ff ff       	jmp    801050f1 <sys_unlink+0x111>
    end_op();
80105180:	e8 cb da ff ff       	call   80102c50 <end_op>
    return -1;
80105185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518a:	e9 62 ff ff ff       	jmp    801050f1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	68 48 79 10 80       	push   $0x80107948
80105197:	e8 f4 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	68 36 79 10 80       	push   $0x80107936
801051a4:	e8 e7 b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801051a9:	83 ec 0c             	sub    $0xc,%esp
801051ac:	68 5a 79 10 80       	push   $0x8010795a
801051b1:	e8 da b1 ff ff       	call   80100390 <panic>
801051b6:	8d 76 00             	lea    0x0(%esi),%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051c0 <sys_open>:

int
sys_open(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
801051c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801051c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 3c f8 ff ff       	call   80104a10 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 1d 01 00 00    	js     801052fc <sys_open+0x13c>
801051df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051e2:	83 ec 08             	sub    $0x8,%esp
801051e5:	50                   	push   %eax
801051e6:	6a 01                	push   $0x1
801051e8:	e8 73 f7 ff ff       	call   80104960 <argint>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	0f 88 04 01 00 00    	js     801052fc <sys_open+0x13c>
    return -1;

  begin_op();
801051f8:	e8 e3 d9 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
801051fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105201:	0f 85 a9 00 00 00    	jne    801052b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105207:	83 ec 0c             	sub    $0xc,%esp
8010520a:	ff 75 e0             	pushl  -0x20(%ebp)
8010520d:	e8 0e cd ff ff       	call   80101f20 <namei>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	89 c6                	mov    %eax,%esi
80105219:	0f 84 b2 00 00 00    	je     801052d1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	50                   	push   %eax
80105223:	e8 98 c4 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105230:	0f 84 aa 00 00 00    	je     801052e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105236:	e8 85 bb ff ff       	call   80100dc0 <filealloc>
8010523b:	85 c0                	test   %eax,%eax
8010523d:	89 c7                	mov    %eax,%edi
8010523f:	0f 84 a6 00 00 00    	je     801052eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105245:	e8 d6 e5 ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010524a:	31 db                	xor    %ebx,%ebx
8010524c:	eb 0e                	jmp    8010525c <sys_open+0x9c>
8010524e:	66 90                	xchg   %ax,%ax
80105250:	83 c3 01             	add    $0x1,%ebx
80105253:	83 fb 10             	cmp    $0x10,%ebx
80105256:	0f 84 ac 00 00 00    	je     80105308 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010525c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105260:	85 d2                	test   %edx,%edx
80105262:	75 ec                	jne    80105250 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105267:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010526b:	56                   	push   %esi
8010526c:	e8 2f c5 ff ff       	call   801017a0 <iunlock>
  end_op();
80105271:	e8 da d9 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
80105276:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010527c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010527f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105282:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105285:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010528c:	89 d0                	mov    %edx,%eax
8010528e:	f7 d0                	not    %eax
80105290:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105293:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105296:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105299:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010529d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a0:	89 d8                	mov    %ebx,%eax
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5f                   	pop    %edi
801052a5:	5d                   	pop    %ebp
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052b6:	31 c9                	xor    %ecx,%ecx
801052b8:	6a 00                	push   $0x0
801052ba:	ba 02 00 00 00       	mov    $0x2,%edx
801052bf:	e8 ec f7 ff ff       	call   80104ab0 <create>
    if(ip == 0){
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801052c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052cb:	0f 85 65 ff ff ff    	jne    80105236 <sys_open+0x76>
      end_op();
801052d1:	e8 7a d9 ff ff       	call   80102c50 <end_op>
      return -1;
801052d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052db:	eb c0                	jmp    8010529d <sys_open+0xdd>
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801052e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052e3:	85 c9                	test   %ecx,%ecx
801052e5:	0f 84 4b ff ff ff    	je     80105236 <sys_open+0x76>
    iunlockput(ip);
801052eb:	83 ec 0c             	sub    $0xc,%esp
801052ee:	56                   	push   %esi
801052ef:	e8 5c c6 ff ff       	call   80101950 <iunlockput>
    end_op();
801052f4:	e8 57 d9 ff ff       	call   80102c50 <end_op>
    return -1;
801052f9:	83 c4 10             	add    $0x10,%esp
801052fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105301:	eb 9a                	jmp    8010529d <sys_open+0xdd>
80105303:	90                   	nop
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	57                   	push   %edi
8010530c:	e8 6f bb ff ff       	call   80100e80 <fileclose>
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	eb d5                	jmp    801052eb <sys_open+0x12b>
80105316:	8d 76 00             	lea    0x0(%esi),%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_mkdir>:

int
sys_mkdir(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105326:	e8 b5 d8 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010532b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532e:	83 ec 08             	sub    $0x8,%esp
80105331:	50                   	push   %eax
80105332:	6a 00                	push   $0x0
80105334:	e8 d7 f6 ff ff       	call   80104a10 <argstr>
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	85 c0                	test   %eax,%eax
8010533e:	78 30                	js     80105370 <sys_mkdir+0x50>
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105346:	31 c9                	xor    %ecx,%ecx
80105348:	6a 00                	push   $0x0
8010534a:	ba 01 00 00 00       	mov    $0x1,%edx
8010534f:	e8 5c f7 ff ff       	call   80104ab0 <create>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	74 15                	je     80105370 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535b:	83 ec 0c             	sub    $0xc,%esp
8010535e:	50                   	push   %eax
8010535f:	e8 ec c5 ff ff       	call   80101950 <iunlockput>
  end_op();
80105364:	e8 e7 d8 ff ff       	call   80102c50 <end_op>
  return 0;
80105369:	83 c4 10             	add    $0x10,%esp
8010536c:	31 c0                	xor    %eax,%eax
}
8010536e:	c9                   	leave  
8010536f:	c3                   	ret    
    end_op();
80105370:	e8 db d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_mknod>:

int
sys_mknod(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105386:	e8 55 d8 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010538b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010538e:	83 ec 08             	sub    $0x8,%esp
80105391:	50                   	push   %eax
80105392:	6a 00                	push   $0x0
80105394:	e8 77 f6 ff ff       	call   80104a10 <argstr>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	85 c0                	test   %eax,%eax
8010539e:	78 60                	js     80105400 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053a3:	83 ec 08             	sub    $0x8,%esp
801053a6:	50                   	push   %eax
801053a7:	6a 01                	push   $0x1
801053a9:	e8 b2 f5 ff ff       	call   80104960 <argint>
  if((argstr(0, &path)) < 0 ||
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 4b                	js     80105400 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b8:	83 ec 08             	sub    $0x8,%esp
801053bb:	50                   	push   %eax
801053bc:	6a 02                	push   $0x2
801053be:	e8 9d f5 ff ff       	call   80104960 <argint>
     argint(1, &major) < 0 ||
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	78 36                	js     80105400 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801053ce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801053d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801053d5:	ba 03 00 00 00       	mov    $0x3,%edx
801053da:	50                   	push   %eax
801053db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053de:	e8 cd f6 ff ff       	call   80104ab0 <create>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 16                	je     80105400 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	50                   	push   %eax
801053ee:	e8 5d c5 ff ff       	call   80101950 <iunlockput>
  end_op();
801053f3:	e8 58 d8 ff ff       	call   80102c50 <end_op>
  return 0;
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	31 c0                	xor    %eax,%eax
}
801053fd:	c9                   	leave  
801053fe:	c3                   	ret    
801053ff:	90                   	nop
    end_op();
80105400:	e8 4b d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540a:	c9                   	leave  
8010540b:	c3                   	ret    
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_chdir>:

int
sys_chdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	56                   	push   %esi
80105414:	53                   	push   %ebx
80105415:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105418:	e8 03 e4 ff ff       	call   80103820 <myproc>
8010541d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010541f:	e8 bc d7 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105424:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105427:	83 ec 08             	sub    $0x8,%esp
8010542a:	50                   	push   %eax
8010542b:	6a 00                	push   $0x0
8010542d:	e8 de f5 ff ff       	call   80104a10 <argstr>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	78 77                	js     801054b0 <sys_chdir+0xa0>
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	ff 75 f4             	pushl  -0xc(%ebp)
8010543f:	e8 dc ca ff ff       	call   80101f20 <namei>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	89 c3                	mov    %eax,%ebx
8010544b:	74 63                	je     801054b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010544d:	83 ec 0c             	sub    $0xc,%esp
80105450:	50                   	push   %eax
80105451:	e8 6a c2 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010545e:	75 30                	jne    80105490 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	53                   	push   %ebx
80105464:	e8 37 c3 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105469:	58                   	pop    %eax
8010546a:	ff 76 68             	pushl  0x68(%esi)
8010546d:	e8 7e c3 ff ff       	call   801017f0 <iput>
  end_op();
80105472:	e8 d9 d7 ff ff       	call   80102c50 <end_op>
  curproc->cwd = ip;
80105477:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	31 c0                	xor    %eax,%eax
}
8010547f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105482:	5b                   	pop    %ebx
80105483:	5e                   	pop    %esi
80105484:	5d                   	pop    %ebp
80105485:	c3                   	ret    
80105486:	8d 76 00             	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	53                   	push   %ebx
80105494:	e8 b7 c4 ff ff       	call   80101950 <iunlockput>
    end_op();
80105499:	e8 b2 d7 ff ff       	call   80102c50 <end_op>
    return -1;
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a6:	eb d7                	jmp    8010547f <sys_chdir+0x6f>
801054a8:	90                   	nop
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801054b0:	e8 9b d7 ff ff       	call   80102c50 <end_op>
    return -1;
801054b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ba:	eb c3                	jmp    8010547f <sys_chdir+0x6f>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <sys_exec>:

int
sys_exec(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
801054c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054d2:	50                   	push   %eax
801054d3:	6a 00                	push   $0x0
801054d5:	e8 36 f5 ff ff       	call   80104a10 <argstr>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	85 c0                	test   %eax,%eax
801054df:	0f 88 87 00 00 00    	js     8010556c <sys_exec+0xac>
801054e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054eb:	83 ec 08             	sub    $0x8,%esp
801054ee:	50                   	push   %eax
801054ef:	6a 01                	push   $0x1
801054f1:	e8 6a f4 ff ff       	call   80104960 <argint>
801054f6:	83 c4 10             	add    $0x10,%esp
801054f9:	85 c0                	test   %eax,%eax
801054fb:	78 6f                	js     8010556c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105503:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105506:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105508:	68 80 00 00 00       	push   $0x80
8010550d:	6a 00                	push   $0x0
8010550f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105515:	50                   	push   %eax
80105516:	e8 45 f1 ff ff       	call   80104660 <memset>
8010551b:	83 c4 10             	add    $0x10,%esp
8010551e:	eb 2c                	jmp    8010554c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105520:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105526:	85 c0                	test   %eax,%eax
80105528:	74 56                	je     80105580 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010552a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105530:	83 ec 08             	sub    $0x8,%esp
80105533:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105536:	52                   	push   %edx
80105537:	50                   	push   %eax
80105538:	e8 b3 f3 ff ff       	call   801048f0 <fetchstr>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 28                	js     8010556c <sys_exec+0xac>
  for(i=0;; i++){
80105544:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105547:	83 fb 20             	cmp    $0x20,%ebx
8010554a:	74 20                	je     8010556c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010554c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105552:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105559:	83 ec 08             	sub    $0x8,%esp
8010555c:	57                   	push   %edi
8010555d:	01 f0                	add    %esi,%eax
8010555f:	50                   	push   %eax
80105560:	e8 4b f3 ff ff       	call   801048b0 <fetchint>
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	85 c0                	test   %eax,%eax
8010556a:	79 b4                	jns    80105520 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010556c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010556f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105574:	5b                   	pop    %ebx
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105580:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105586:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105589:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105590:	00 00 00 00 
  return exec(path, argv);
80105594:	50                   	push   %eax
80105595:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010559b:	e8 70 b4 ff ff       	call   80100a10 <exec>
801055a0:	83 c4 10             	add    $0x10,%esp
}
801055a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a6:	5b                   	pop    %ebx
801055a7:	5e                   	pop    %esi
801055a8:	5f                   	pop    %edi
801055a9:	5d                   	pop    %ebp
801055aa:	c3                   	ret    
801055ab:	90                   	nop
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_pipe>:

int
sys_pipe(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055bc:	6a 08                	push   $0x8
801055be:	50                   	push   %eax
801055bf:	6a 00                	push   $0x0
801055c1:	e8 ea f3 ff ff       	call   801049b0 <argptr>
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	85 c0                	test   %eax,%eax
801055cb:	0f 88 ae 00 00 00    	js     8010567f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055d4:	83 ec 08             	sub    $0x8,%esp
801055d7:	50                   	push   %eax
801055d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055db:	50                   	push   %eax
801055dc:	e8 9f dc ff ff       	call   80103280 <pipealloc>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	0f 88 93 00 00 00    	js     8010567f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801055ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055f1:	e8 2a e2 ff ff       	call   80103820 <myproc>
801055f6:	eb 10                	jmp    80105608 <sys_pipe+0x58>
801055f8:	90                   	nop
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105600:	83 c3 01             	add    $0x1,%ebx
80105603:	83 fb 10             	cmp    $0x10,%ebx
80105606:	74 60                	je     80105668 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105608:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010560c:	85 f6                	test   %esi,%esi
8010560e:	75 f0                	jne    80105600 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105610:	8d 73 08             	lea    0x8(%ebx),%esi
80105613:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105617:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010561a:	e8 01 e2 ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010561f:	31 d2                	xor    %edx,%edx
80105621:	eb 0d                	jmp    80105630 <sys_pipe+0x80>
80105623:	90                   	nop
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105628:	83 c2 01             	add    $0x1,%edx
8010562b:	83 fa 10             	cmp    $0x10,%edx
8010562e:	74 28                	je     80105658 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105630:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105634:	85 c9                	test   %ecx,%ecx
80105636:	75 f0                	jne    80105628 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105638:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010563c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010563f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105641:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105644:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105647:	31 c0                	xor    %eax,%eax
}
80105649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564c:	5b                   	pop    %ebx
8010564d:	5e                   	pop    %esi
8010564e:	5f                   	pop    %edi
8010564f:	5d                   	pop    %ebp
80105650:	c3                   	ret    
80105651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105658:	e8 c3 e1 ff ff       	call   80103820 <myproc>
8010565d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105664:	00 
80105665:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	ff 75 e0             	pushl  -0x20(%ebp)
8010566e:	e8 0d b8 ff ff       	call   80100e80 <fileclose>
    fileclose(wf);
80105673:	58                   	pop    %eax
80105674:	ff 75 e4             	pushl  -0x1c(%ebp)
80105677:	e8 04 b8 ff ff       	call   80100e80 <fileclose>
    return -1;
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105684:	eb c3                	jmp    80105649 <sys_pipe+0x99>
80105686:	66 90                	xchg   %ax,%ax
80105688:	66 90                	xchg   %ax,%ax
8010568a:	66 90                	xchg   %ax,%ax
8010568c:	66 90                	xchg   %ax,%ax
8010568e:	66 90                	xchg   %ax,%ax

80105690 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105693:	5d                   	pop    %ebp
  return fork();
80105694:	e9 27 e3 ff ff       	jmp    801039c0 <fork>
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_exit>:

int
sys_exit(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056a6:	e8 95 e5 ff ff       	call   80103c40 <exit>
  return 0;  // not reached
}
801056ab:	31 c0                	xor    %eax,%eax
801056ad:	c9                   	leave  
801056ae:	c3                   	ret    
801056af:	90                   	nop

801056b0 <sys_wait>:

int
sys_wait(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801056b3:	5d                   	pop    %ebp
  return wait();
801056b4:	e9 c7 e7 ff ff       	jmp    80103e80 <wait>
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_kill>:

int
sys_kill(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 00                	push   $0x0
801056cc:	e8 8f f2 ff ff       	call   80104960 <argint>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 18                	js     801056f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801056d8:	83 ec 0c             	sub    $0xc,%esp
801056db:	ff 75 f4             	pushl  -0xc(%ebp)
801056de:	e8 fd e8 ff ff       	call   80103fe0 <kill>
801056e3:	83 c4 10             	add    $0x10,%esp
}
801056e6:	c9                   	leave  
801056e7:	c3                   	ret    
801056e8:	90                   	nop
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_getpid>:

int
sys_getpid(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105706:	e8 15 e1 ff ff       	call   80103820 <myproc>
8010570b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010570e:	c9                   	leave  
8010570f:	c3                   	ret    

80105710 <sys_sbrk>:

int
sys_sbrk(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105714:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105717:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010571a:	50                   	push   %eax
8010571b:	6a 00                	push   $0x0
8010571d:	e8 3e f2 ff ff       	call   80104960 <argint>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 27                	js     80105750 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105729:	e8 f2 e0 ff ff       	call   80103820 <myproc>
  if(growproc(n) < 0)
8010572e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105731:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105733:	ff 75 f4             	pushl  -0xc(%ebp)
80105736:	e8 05 e2 ff ff       	call   80103940 <growproc>
8010573b:	83 c4 10             	add    $0x10,%esp
8010573e:	85 c0                	test   %eax,%eax
80105740:	78 0e                	js     80105750 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105742:	89 d8                	mov    %ebx,%eax
80105744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105747:	c9                   	leave  
80105748:	c3                   	ret    
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105750:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105755:	eb eb                	jmp    80105742 <sys_sbrk+0x32>
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <sys_sleep>:

int
sys_sleep(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105767:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 ee f1 ff ff       	call   80104960 <argint>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	0f 88 8a 00 00 00    	js     80105807 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010577d:	83 ec 0c             	sub    $0xc,%esp
80105780:	68 60 51 11 80       	push   $0x80115160
80105785:	e8 c6 ed ff ff       	call   80104550 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010578a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010578d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105790:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  while(ticks - ticks0 < n){
80105796:	85 d2                	test   %edx,%edx
80105798:	75 27                	jne    801057c1 <sys_sleep+0x61>
8010579a:	eb 54                	jmp    801057f0 <sys_sleep+0x90>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	68 60 51 11 80       	push   $0x80115160
801057a8:	68 a0 59 11 80       	push   $0x801159a0
801057ad:	e8 0e e6 ff ff       	call   80103dc0 <sleep>
  while(ticks - ticks0 < n){
801057b2:	a1 a0 59 11 80       	mov    0x801159a0,%eax
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	29 d8                	sub    %ebx,%eax
801057bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057bf:	73 2f                	jae    801057f0 <sys_sleep+0x90>
    if(myproc()->killed){
801057c1:	e8 5a e0 ff ff       	call   80103820 <myproc>
801057c6:	8b 40 24             	mov    0x24(%eax),%eax
801057c9:	85 c0                	test   %eax,%eax
801057cb:	74 d3                	je     801057a0 <sys_sleep+0x40>
      release(&tickslock);
801057cd:	83 ec 0c             	sub    $0xc,%esp
801057d0:	68 60 51 11 80       	push   $0x80115160
801057d5:	e8 36 ee ff ff       	call   80104610 <release>
      return -1;
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801057e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	68 60 51 11 80       	push   $0x80115160
801057f8:	e8 13 ee ff ff       	call   80104610 <release>
  return 0;
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	31 c0                	xor    %eax,%eax
}
80105802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105805:	c9                   	leave  
80105806:	c3                   	ret    
    return -1;
80105807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580c:	eb f4                	jmp    80105802 <sys_sleep+0xa2>
8010580e:	66 90                	xchg   %ax,%ax

80105810 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
80105814:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105817:	68 60 51 11 80       	push   $0x80115160
8010581c:	e8 2f ed ff ff       	call   80104550 <acquire>
  xticks = ticks;
80105821:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  release(&tickslock);
80105827:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
8010582e:	e8 dd ed ff ff       	call   80104610 <release>
  return xticks;
}
80105833:	89 d8                	mov    %ebx,%eax
80105835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105838:	c9                   	leave  
80105839:	c3                   	ret    
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <sys_changeQueueNum>:

int
sys_changeQueueNum(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 20             	sub    $0x20,%esp
  int pid, destinationQueue;
  argint(0,&pid);
80105846:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 00                	push   $0x0
8010584c:	e8 0f f1 ff ff       	call   80104960 <argint>
  argint(1,&destinationQueue);  
80105851:	58                   	pop    %eax
80105852:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105855:	5a                   	pop    %edx
80105856:	50                   	push   %eax
80105857:	6a 01                	push   $0x1
80105859:	e8 02 f1 ff ff       	call   80104960 <argint>
  
  cprintf("pid = %d des = %d\n", pid, destinationQueue);
8010585e:	83 c4 0c             	add    $0xc,%esp
80105861:	ff 75 f4             	pushl  -0xc(%ebp)
80105864:	ff 75 f0             	pushl  -0x10(%ebp)
80105867:	68 69 79 10 80       	push   $0x80107969
8010586c:	e8 ef ad ff ff       	call   80100660 <cprintf>
  return changeQueueNum(pid, destinationQueue);
80105871:	59                   	pop    %ecx
80105872:	58                   	pop    %eax
80105873:	ff 75 f4             	pushl  -0xc(%ebp)
80105876:	ff 75 f0             	pushl  -0x10(%ebp)
80105879:	e8 b2 e8 ff ff       	call   80104130 <changeQueueNum>
}
8010587e:	c9                   	leave  
8010587f:	c3                   	ret    

80105880 <sys_evalTicket>:
int
sys_evalTicket(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket;
  argint(0,&pid);
80105886:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105889:	50                   	push   %eax
8010588a:	6a 00                	push   $0x0
8010588c:	e8 cf f0 ff ff       	call   80104960 <argint>
  argint(1,&ticket);  
80105891:	58                   	pop    %eax
80105892:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105895:	5a                   	pop    %edx
80105896:	50                   	push   %eax
80105897:	6a 01                	push   $0x1
80105899:	e8 c2 f0 ff ff       	call   80104960 <argint>
  
  cprintf("pid = %d des = %d\n", pid, ticket);
8010589e:	83 c4 0c             	add    $0xc,%esp
801058a1:	ff 75 f4             	pushl  -0xc(%ebp)
801058a4:	ff 75 f0             	pushl  -0x10(%ebp)
801058a7:	68 69 79 10 80       	push   $0x80107969
801058ac:	e8 af ad ff ff       	call   80100660 <cprintf>
  return evalTicket(pid, ticket);
801058b1:	59                   	pop    %ecx
801058b2:	58                   	pop    %eax
801058b3:	ff 75 f4             	pushl  -0xc(%ebp)
801058b6:	ff 75 f0             	pushl  -0x10(%ebp)
801058b9:	e8 b2 e8 ff ff       	call   80104170 <evalTicket>
}
801058be:	c9                   	leave  
801058bf:	c3                   	ret    

801058c0 <sys_evalRemainingPriority>:
int
sys_evalRemainingPriority(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  char *priority;
  argint(0, &pid);
801058c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 00                	push   $0x0
801058cc:	e8 8f f0 ff ff       	call   80104960 <argint>
  argstr(1, &priority);  
801058d1:	58                   	pop    %eax
801058d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d5:	5a                   	pop    %edx
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 32 f1 ff ff       	call   80104a10 <argstr>

  cprintf("pid = %d des = %s\n", pid, priority);
801058de:	83 c4 0c             	add    $0xc,%esp
801058e1:	ff 75 f4             	pushl  -0xc(%ebp)
801058e4:	ff 75 f0             	pushl  -0x10(%ebp)
801058e7:	68 7c 79 10 80       	push   $0x8010797c
801058ec:	e8 6f ad ff ff       	call   80100660 <cprintf>
  return evalRemainingPriority(pid, priority);
801058f1:	59                   	pop    %ecx
801058f2:	58                   	pop    %eax
801058f3:	ff 75 f4             	pushl  -0xc(%ebp)
801058f6:	ff 75 f0             	pushl  -0x10(%ebp)
801058f9:	e8 42 e9 ff ff       	call   80104240 <evalRemainingPriority>
}
801058fe:	c9                   	leave  
801058ff:	c3                   	ret    

80105900 <sys_printInfo>:
int
sys_printInfo(void)
{
80105900:	55                   	push   %ebp
  return 0; //change here
}
80105901:	31 c0                	xor    %eax,%eax
{
80105903:	89 e5                	mov    %esp,%ebp
}
80105905:	5d                   	pop    %ebp
80105906:	c3                   	ret    

80105907 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105907:	1e                   	push   %ds
  pushl %es
80105908:	06                   	push   %es
  pushl %fs
80105909:	0f a0                	push   %fs
  pushl %gs
8010590b:	0f a8                	push   %gs
  pushal
8010590d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010590e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105912:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105914:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105916:	54                   	push   %esp
  call trap
80105917:	e8 c4 00 00 00       	call   801059e0 <trap>
  addl $4, %esp
8010591c:	83 c4 04             	add    $0x4,%esp

8010591f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010591f:	61                   	popa   
  popl %gs
80105920:	0f a9                	pop    %gs
  popl %fs
80105922:	0f a1                	pop    %fs
  popl %es
80105924:	07                   	pop    %es
  popl %ds
80105925:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105926:	83 c4 08             	add    $0x8,%esp
  iret
80105929:	cf                   	iret   
8010592a:	66 90                	xchg   %ax,%ax
8010592c:	66 90                	xchg   %ax,%ax
8010592e:	66 90                	xchg   %ax,%ax

80105930 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105930:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105931:	31 c0                	xor    %eax,%eax
{
80105933:	89 e5                	mov    %esp,%ebp
80105935:	83 ec 08             	sub    $0x8,%esp
80105938:	90                   	nop
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105940:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105947:	c7 04 c5 a2 51 11 80 	movl   $0x8e000008,-0x7feeae5e(,%eax,8)
8010594e:	08 00 00 8e 
80105952:	66 89 14 c5 a0 51 11 	mov    %dx,-0x7feeae60(,%eax,8)
80105959:	80 
8010595a:	c1 ea 10             	shr    $0x10,%edx
8010595d:	66 89 14 c5 a6 51 11 	mov    %dx,-0x7feeae5a(,%eax,8)
80105964:	80 
  for(i = 0; i < 256; i++)
80105965:	83 c0 01             	add    $0x1,%eax
80105968:	3d 00 01 00 00       	cmp    $0x100,%eax
8010596d:	75 d1                	jne    80105940 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010596f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105974:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105977:	c7 05 a2 53 11 80 08 	movl   $0xef000008,0x801153a2
8010597e:	00 00 ef 
  initlock(&tickslock, "time");
80105981:	68 8f 79 10 80       	push   $0x8010798f
80105986:	68 60 51 11 80       	push   $0x80115160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010598b:	66 a3 a0 53 11 80    	mov    %ax,0x801153a0
80105991:	c1 e8 10             	shr    $0x10,%eax
80105994:	66 a3 a6 53 11 80    	mov    %ax,0x801153a6
  initlock(&tickslock, "time");
8010599a:	e8 71 ea ff ff       	call   80104410 <initlock>
}
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	c9                   	leave  
801059a3:	c3                   	ret    
801059a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059b0 <idtinit>:

void
idtinit(void)
{
801059b0:	55                   	push   %ebp
  pd[0] = size-1;
801059b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059b6:	89 e5                	mov    %esp,%ebp
801059b8:	83 ec 10             	sub    $0x10,%esp
801059bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059bf:	b8 a0 51 11 80       	mov    $0x801151a0,%eax
801059c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059c8:	c1 e8 10             	shr    $0x10,%eax
801059cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
801059e6:	83 ec 1c             	sub    $0x1c,%esp
801059e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059ec:	8b 47 30             	mov    0x30(%edi),%eax
801059ef:	83 f8 40             	cmp    $0x40,%eax
801059f2:	0f 84 f0 00 00 00    	je     80105ae8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059f8:	83 e8 20             	sub    $0x20,%eax
801059fb:	83 f8 1f             	cmp    $0x1f,%eax
801059fe:	77 10                	ja     80105a10 <trap+0x30>
80105a00:	ff 24 85 38 7a 10 80 	jmp    *-0x7fef85c8(,%eax,4)
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a10:	e8 0b de ff ff       	call   80103820 <myproc>
80105a15:	85 c0                	test   %eax,%eax
80105a17:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a1a:	0f 84 14 02 00 00    	je     80105c34 <trap+0x254>
80105a20:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a24:	0f 84 0a 02 00 00    	je     80105c34 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a2a:	0f 20 d1             	mov    %cr2,%ecx
80105a2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a30:	e8 cb dd ff ff       	call   80103800 <cpuid>
80105a35:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a38:	8b 47 34             	mov    0x34(%edi),%eax
80105a3b:	8b 77 30             	mov    0x30(%edi),%esi
80105a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a41:	e8 da dd ff ff       	call   80103820 <myproc>
80105a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a49:	e8 d2 dd ff ff       	call   80103820 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a54:	51                   	push   %ecx
80105a55:	53                   	push   %ebx
80105a56:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a57:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a5a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a5d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a5e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a61:	52                   	push   %edx
80105a62:	ff 70 10             	pushl  0x10(%eax)
80105a65:	68 f4 79 10 80       	push   $0x801079f4
80105a6a:	e8 f1 ab ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a6f:	83 c4 20             	add    $0x20,%esp
80105a72:	e8 a9 dd ff ff       	call   80103820 <myproc>
80105a77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a7e:	e8 9d dd ff ff       	call   80103820 <myproc>
80105a83:	85 c0                	test   %eax,%eax
80105a85:	74 1d                	je     80105aa4 <trap+0xc4>
80105a87:	e8 94 dd ff ff       	call   80103820 <myproc>
80105a8c:	8b 50 24             	mov    0x24(%eax),%edx
80105a8f:	85 d2                	test   %edx,%edx
80105a91:	74 11                	je     80105aa4 <trap+0xc4>
80105a93:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a97:	83 e0 03             	and    $0x3,%eax
80105a9a:	66 83 f8 03          	cmp    $0x3,%ax
80105a9e:	0f 84 4c 01 00 00    	je     80105bf0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105aa4:	e8 77 dd ff ff       	call   80103820 <myproc>
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	74 0b                	je     80105ab8 <trap+0xd8>
80105aad:	e8 6e dd ff ff       	call   80103820 <myproc>
80105ab2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ab6:	74 68                	je     80105b20 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ab8:	e8 63 dd ff ff       	call   80103820 <myproc>
80105abd:	85 c0                	test   %eax,%eax
80105abf:	74 19                	je     80105ada <trap+0xfa>
80105ac1:	e8 5a dd ff ff       	call   80103820 <myproc>
80105ac6:	8b 40 24             	mov    0x24(%eax),%eax
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	74 0d                	je     80105ada <trap+0xfa>
80105acd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ad1:	83 e0 03             	and    $0x3,%eax
80105ad4:	66 83 f8 03          	cmp    $0x3,%ax
80105ad8:	74 37                	je     80105b11 <trap+0x131>
    exit();
}
80105ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105add:	5b                   	pop    %ebx
80105ade:	5e                   	pop    %esi
80105adf:	5f                   	pop    %edi
80105ae0:	5d                   	pop    %ebp
80105ae1:	c3                   	ret    
80105ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105ae8:	e8 33 dd ff ff       	call   80103820 <myproc>
80105aed:	8b 58 24             	mov    0x24(%eax),%ebx
80105af0:	85 db                	test   %ebx,%ebx
80105af2:	0f 85 e8 00 00 00    	jne    80105be0 <trap+0x200>
    myproc()->tf = tf;
80105af8:	e8 23 dd ff ff       	call   80103820 <myproc>
80105afd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105b00:	e8 4b ef ff ff       	call   80104a50 <syscall>
    if(myproc()->killed)
80105b05:	e8 16 dd ff ff       	call   80103820 <myproc>
80105b0a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b0d:	85 c9                	test   %ecx,%ecx
80105b0f:	74 c9                	je     80105ada <trap+0xfa>
}
80105b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b14:	5b                   	pop    %ebx
80105b15:	5e                   	pop    %esi
80105b16:	5f                   	pop    %edi
80105b17:	5d                   	pop    %ebp
      exit();
80105b18:	e9 23 e1 ff ff       	jmp    80103c40 <exit>
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105b20:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b24:	75 92                	jne    80105ab8 <trap+0xd8>
    yield();
80105b26:	e8 45 e2 ff ff       	call   80103d70 <yield>
80105b2b:	eb 8b                	jmp    80105ab8 <trap+0xd8>
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b30:	e8 cb dc ff ff       	call   80103800 <cpuid>
80105b35:	85 c0                	test   %eax,%eax
80105b37:	0f 84 c3 00 00 00    	je     80105c00 <trap+0x220>
    lapiceoi();
80105b3d:	e8 4e cc ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b42:	e8 d9 dc ff ff       	call   80103820 <myproc>
80105b47:	85 c0                	test   %eax,%eax
80105b49:	0f 85 38 ff ff ff    	jne    80105a87 <trap+0xa7>
80105b4f:	e9 50 ff ff ff       	jmp    80105aa4 <trap+0xc4>
80105b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b58:	e8 f3 ca ff ff       	call   80102650 <kbdintr>
    lapiceoi();
80105b5d:	e8 2e cc ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b62:	e8 b9 dc ff ff       	call   80103820 <myproc>
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 85 18 ff ff ff    	jne    80105a87 <trap+0xa7>
80105b6f:	e9 30 ff ff ff       	jmp    80105aa4 <trap+0xc4>
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b78:	e8 53 02 00 00       	call   80105dd0 <uartintr>
    lapiceoi();
80105b7d:	e8 0e cc ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b82:	e8 99 dc ff ff       	call   80103820 <myproc>
80105b87:	85 c0                	test   %eax,%eax
80105b89:	0f 85 f8 fe ff ff    	jne    80105a87 <trap+0xa7>
80105b8f:	e9 10 ff ff ff       	jmp    80105aa4 <trap+0xc4>
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b98:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105b9c:	8b 77 38             	mov    0x38(%edi),%esi
80105b9f:	e8 5c dc ff ff       	call   80103800 <cpuid>
80105ba4:	56                   	push   %esi
80105ba5:	53                   	push   %ebx
80105ba6:	50                   	push   %eax
80105ba7:	68 9c 79 10 80       	push   $0x8010799c
80105bac:	e8 af aa ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105bb1:	e8 da cb ff ff       	call   80102790 <lapiceoi>
    break;
80105bb6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bb9:	e8 62 dc ff ff       	call   80103820 <myproc>
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	0f 85 c1 fe ff ff    	jne    80105a87 <trap+0xa7>
80105bc6:	e9 d9 fe ff ff       	jmp    80105aa4 <trap+0xc4>
80105bcb:	90                   	nop
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105bd0:	e8 eb c4 ff ff       	call   801020c0 <ideintr>
80105bd5:	e9 63 ff ff ff       	jmp    80105b3d <trap+0x15d>
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105be0:	e8 5b e0 ff ff       	call   80103c40 <exit>
80105be5:	e9 0e ff ff ff       	jmp    80105af8 <trap+0x118>
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105bf0:	e8 4b e0 ff ff       	call   80103c40 <exit>
80105bf5:	e9 aa fe ff ff       	jmp    80105aa4 <trap+0xc4>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	68 60 51 11 80       	push   $0x80115160
80105c08:	e8 43 e9 ff ff       	call   80104550 <acquire>
      wakeup(&ticks);
80105c0d:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
      ticks++;
80105c14:	83 05 a0 59 11 80 01 	addl   $0x1,0x801159a0
      wakeup(&ticks);
80105c1b:	e8 60 e3 ff ff       	call   80103f80 <wakeup>
      release(&tickslock);
80105c20:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105c27:	e8 e4 e9 ff ff       	call   80104610 <release>
80105c2c:	83 c4 10             	add    $0x10,%esp
80105c2f:	e9 09 ff ff ff       	jmp    80105b3d <trap+0x15d>
80105c34:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c37:	e8 c4 db ff ff       	call   80103800 <cpuid>
80105c3c:	83 ec 0c             	sub    $0xc,%esp
80105c3f:	56                   	push   %esi
80105c40:	53                   	push   %ebx
80105c41:	50                   	push   %eax
80105c42:	ff 77 30             	pushl  0x30(%edi)
80105c45:	68 c0 79 10 80       	push   $0x801079c0
80105c4a:	e8 11 aa ff ff       	call   80100660 <cprintf>
      panic("trap");
80105c4f:	83 c4 14             	add    $0x14,%esp
80105c52:	68 94 79 10 80       	push   $0x80107994
80105c57:	e8 34 a7 ff ff       	call   80100390 <panic>
80105c5c:	66 90                	xchg   %ax,%ax
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c60:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105c65:	55                   	push   %ebp
80105c66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	74 1c                	je     80105c88 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c72:	a8 01                	test   $0x1,%al
80105c74:	74 12                	je     80105c88 <uartgetc+0x28>
80105c76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c7c:	0f b6 c0             	movzbl %al,%eax
}
80105c7f:	5d                   	pop    %ebp
80105c80:	c3                   	ret    
80105c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c8d:	5d                   	pop    %ebp
80105c8e:	c3                   	ret    
80105c8f:	90                   	nop

80105c90 <uartputc.part.0>:
uartputc(int c)
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	57                   	push   %edi
80105c94:	56                   	push   %esi
80105c95:	53                   	push   %ebx
80105c96:	89 c7                	mov    %eax,%edi
80105c98:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ca2:	83 ec 0c             	sub    $0xc,%esp
80105ca5:	eb 1b                	jmp    80105cc2 <uartputc.part.0+0x32>
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	6a 0a                	push   $0xa
80105cb5:	e8 f6 ca ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	83 eb 01             	sub    $0x1,%ebx
80105cc0:	74 07                	je     80105cc9 <uartputc.part.0+0x39>
80105cc2:	89 f2                	mov    %esi,%edx
80105cc4:	ec                   	in     (%dx),%al
80105cc5:	a8 20                	test   $0x20,%al
80105cc7:	74 e7                	je     80105cb0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cc9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cce:	89 f8                	mov    %edi,%eax
80105cd0:	ee                   	out    %al,(%dx)
}
80105cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd4:	5b                   	pop    %ebx
80105cd5:	5e                   	pop    %esi
80105cd6:	5f                   	pop    %edi
80105cd7:	5d                   	pop    %ebp
80105cd8:	c3                   	ret    
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <uartinit>:
{
80105ce0:	55                   	push   %ebp
80105ce1:	31 c9                	xor    %ecx,%ecx
80105ce3:	89 c8                	mov    %ecx,%eax
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	57                   	push   %edi
80105ce8:	56                   	push   %esi
80105ce9:	53                   	push   %ebx
80105cea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105cef:	89 da                	mov    %ebx,%edx
80105cf1:	83 ec 0c             	sub    $0xc,%esp
80105cf4:	ee                   	out    %al,(%dx)
80105cf5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105cfa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cff:	89 fa                	mov    %edi,%edx
80105d01:	ee                   	out    %al,(%dx)
80105d02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0c:	ee                   	out    %al,(%dx)
80105d0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d12:	89 c8                	mov    %ecx,%eax
80105d14:	89 f2                	mov    %esi,%edx
80105d16:	ee                   	out    %al,(%dx)
80105d17:	b8 03 00 00 00       	mov    $0x3,%eax
80105d1c:	89 fa                	mov    %edi,%edx
80105d1e:	ee                   	out    %al,(%dx)
80105d1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d24:	89 c8                	mov    %ecx,%eax
80105d26:	ee                   	out    %al,(%dx)
80105d27:	b8 01 00 00 00       	mov    $0x1,%eax
80105d2c:	89 f2                	mov    %esi,%edx
80105d2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d35:	3c ff                	cmp    $0xff,%al
80105d37:	74 5a                	je     80105d93 <uartinit+0xb3>
  uart = 1;
80105d39:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d40:	00 00 00 
80105d43:	89 da                	mov    %ebx,%edx
80105d45:	ec                   	in     (%dx),%al
80105d46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d4b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d4c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d4f:	bb b8 7a 10 80       	mov    $0x80107ab8,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d54:	6a 00                	push   $0x0
80105d56:	6a 04                	push   $0x4
80105d58:	e8 b3 c5 ff ff       	call   80102310 <ioapicenable>
80105d5d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d60:	b8 78 00 00 00       	mov    $0x78,%eax
80105d65:	eb 13                	jmp    80105d7a <uartinit+0x9a>
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d70:	83 c3 01             	add    $0x1,%ebx
80105d73:	0f be 03             	movsbl (%ebx),%eax
80105d76:	84 c0                	test   %al,%al
80105d78:	74 19                	je     80105d93 <uartinit+0xb3>
  if(!uart)
80105d7a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d80:	85 d2                	test   %edx,%edx
80105d82:	74 ec                	je     80105d70 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105d84:	83 c3 01             	add    $0x1,%ebx
80105d87:	e8 04 ff ff ff       	call   80105c90 <uartputc.part.0>
80105d8c:	0f be 03             	movsbl (%ebx),%eax
80105d8f:	84 c0                	test   %al,%al
80105d91:	75 e7                	jne    80105d7a <uartinit+0x9a>
}
80105d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d96:	5b                   	pop    %ebx
80105d97:	5e                   	pop    %esi
80105d98:	5f                   	pop    %edi
80105d99:	5d                   	pop    %ebp
80105d9a:	c3                   	ret    
80105d9b:	90                   	nop
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <uartputc>:
  if(!uart)
80105da0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105da6:	55                   	push   %ebp
80105da7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105da9:	85 d2                	test   %edx,%edx
{
80105dab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105dae:	74 10                	je     80105dc0 <uartputc+0x20>
}
80105db0:	5d                   	pop    %ebp
80105db1:	e9 da fe ff ff       	jmp    80105c90 <uartputc.part.0>
80105db6:	8d 76 00             	lea    0x0(%esi),%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105dc0:	5d                   	pop    %ebp
80105dc1:	c3                   	ret    
80105dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <uartintr>:

void
uartintr(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105dd6:	68 60 5c 10 80       	push   $0x80105c60
80105ddb:	e8 30 aa ff ff       	call   80100810 <consoleintr>
}
80105de0:	83 c4 10             	add    $0x10,%esp
80105de3:	c9                   	leave  
80105de4:	c3                   	ret    

80105de5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $0
80105de7:	6a 00                	push   $0x0
  jmp alltraps
80105de9:	e9 19 fb ff ff       	jmp    80105907 <alltraps>

80105dee <vector1>:
.globl vector1
vector1:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $1
80105df0:	6a 01                	push   $0x1
  jmp alltraps
80105df2:	e9 10 fb ff ff       	jmp    80105907 <alltraps>

80105df7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $2
80105df9:	6a 02                	push   $0x2
  jmp alltraps
80105dfb:	e9 07 fb ff ff       	jmp    80105907 <alltraps>

80105e00 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $3
80105e02:	6a 03                	push   $0x3
  jmp alltraps
80105e04:	e9 fe fa ff ff       	jmp    80105907 <alltraps>

80105e09 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $4
80105e0b:	6a 04                	push   $0x4
  jmp alltraps
80105e0d:	e9 f5 fa ff ff       	jmp    80105907 <alltraps>

80105e12 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $5
80105e14:	6a 05                	push   $0x5
  jmp alltraps
80105e16:	e9 ec fa ff ff       	jmp    80105907 <alltraps>

80105e1b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $6
80105e1d:	6a 06                	push   $0x6
  jmp alltraps
80105e1f:	e9 e3 fa ff ff       	jmp    80105907 <alltraps>

80105e24 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $7
80105e26:	6a 07                	push   $0x7
  jmp alltraps
80105e28:	e9 da fa ff ff       	jmp    80105907 <alltraps>

80105e2d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e2d:	6a 08                	push   $0x8
  jmp alltraps
80105e2f:	e9 d3 fa ff ff       	jmp    80105907 <alltraps>

80105e34 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $9
80105e36:	6a 09                	push   $0x9
  jmp alltraps
80105e38:	e9 ca fa ff ff       	jmp    80105907 <alltraps>

80105e3d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e3d:	6a 0a                	push   $0xa
  jmp alltraps
80105e3f:	e9 c3 fa ff ff       	jmp    80105907 <alltraps>

80105e44 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e44:	6a 0b                	push   $0xb
  jmp alltraps
80105e46:	e9 bc fa ff ff       	jmp    80105907 <alltraps>

80105e4b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e4b:	6a 0c                	push   $0xc
  jmp alltraps
80105e4d:	e9 b5 fa ff ff       	jmp    80105907 <alltraps>

80105e52 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e52:	6a 0d                	push   $0xd
  jmp alltraps
80105e54:	e9 ae fa ff ff       	jmp    80105907 <alltraps>

80105e59 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e59:	6a 0e                	push   $0xe
  jmp alltraps
80105e5b:	e9 a7 fa ff ff       	jmp    80105907 <alltraps>

80105e60 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $15
80105e62:	6a 0f                	push   $0xf
  jmp alltraps
80105e64:	e9 9e fa ff ff       	jmp    80105907 <alltraps>

80105e69 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $16
80105e6b:	6a 10                	push   $0x10
  jmp alltraps
80105e6d:	e9 95 fa ff ff       	jmp    80105907 <alltraps>

80105e72 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e72:	6a 11                	push   $0x11
  jmp alltraps
80105e74:	e9 8e fa ff ff       	jmp    80105907 <alltraps>

80105e79 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $18
80105e7b:	6a 12                	push   $0x12
  jmp alltraps
80105e7d:	e9 85 fa ff ff       	jmp    80105907 <alltraps>

80105e82 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $19
80105e84:	6a 13                	push   $0x13
  jmp alltraps
80105e86:	e9 7c fa ff ff       	jmp    80105907 <alltraps>

80105e8b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $20
80105e8d:	6a 14                	push   $0x14
  jmp alltraps
80105e8f:	e9 73 fa ff ff       	jmp    80105907 <alltraps>

80105e94 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $21
80105e96:	6a 15                	push   $0x15
  jmp alltraps
80105e98:	e9 6a fa ff ff       	jmp    80105907 <alltraps>

80105e9d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $22
80105e9f:	6a 16                	push   $0x16
  jmp alltraps
80105ea1:	e9 61 fa ff ff       	jmp    80105907 <alltraps>

80105ea6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $23
80105ea8:	6a 17                	push   $0x17
  jmp alltraps
80105eaa:	e9 58 fa ff ff       	jmp    80105907 <alltraps>

80105eaf <vector24>:
.globl vector24
vector24:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $24
80105eb1:	6a 18                	push   $0x18
  jmp alltraps
80105eb3:	e9 4f fa ff ff       	jmp    80105907 <alltraps>

80105eb8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $25
80105eba:	6a 19                	push   $0x19
  jmp alltraps
80105ebc:	e9 46 fa ff ff       	jmp    80105907 <alltraps>

80105ec1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $26
80105ec3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ec5:	e9 3d fa ff ff       	jmp    80105907 <alltraps>

80105eca <vector27>:
.globl vector27
vector27:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $27
80105ecc:	6a 1b                	push   $0x1b
  jmp alltraps
80105ece:	e9 34 fa ff ff       	jmp    80105907 <alltraps>

80105ed3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $28
80105ed5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ed7:	e9 2b fa ff ff       	jmp    80105907 <alltraps>

80105edc <vector29>:
.globl vector29
vector29:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $29
80105ede:	6a 1d                	push   $0x1d
  jmp alltraps
80105ee0:	e9 22 fa ff ff       	jmp    80105907 <alltraps>

80105ee5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $30
80105ee7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ee9:	e9 19 fa ff ff       	jmp    80105907 <alltraps>

80105eee <vector31>:
.globl vector31
vector31:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $31
80105ef0:	6a 1f                	push   $0x1f
  jmp alltraps
80105ef2:	e9 10 fa ff ff       	jmp    80105907 <alltraps>

80105ef7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $32
80105ef9:	6a 20                	push   $0x20
  jmp alltraps
80105efb:	e9 07 fa ff ff       	jmp    80105907 <alltraps>

80105f00 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $33
80105f02:	6a 21                	push   $0x21
  jmp alltraps
80105f04:	e9 fe f9 ff ff       	jmp    80105907 <alltraps>

80105f09 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $34
80105f0b:	6a 22                	push   $0x22
  jmp alltraps
80105f0d:	e9 f5 f9 ff ff       	jmp    80105907 <alltraps>

80105f12 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $35
80105f14:	6a 23                	push   $0x23
  jmp alltraps
80105f16:	e9 ec f9 ff ff       	jmp    80105907 <alltraps>

80105f1b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $36
80105f1d:	6a 24                	push   $0x24
  jmp alltraps
80105f1f:	e9 e3 f9 ff ff       	jmp    80105907 <alltraps>

80105f24 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $37
80105f26:	6a 25                	push   $0x25
  jmp alltraps
80105f28:	e9 da f9 ff ff       	jmp    80105907 <alltraps>

80105f2d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $38
80105f2f:	6a 26                	push   $0x26
  jmp alltraps
80105f31:	e9 d1 f9 ff ff       	jmp    80105907 <alltraps>

80105f36 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $39
80105f38:	6a 27                	push   $0x27
  jmp alltraps
80105f3a:	e9 c8 f9 ff ff       	jmp    80105907 <alltraps>

80105f3f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $40
80105f41:	6a 28                	push   $0x28
  jmp alltraps
80105f43:	e9 bf f9 ff ff       	jmp    80105907 <alltraps>

80105f48 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $41
80105f4a:	6a 29                	push   $0x29
  jmp alltraps
80105f4c:	e9 b6 f9 ff ff       	jmp    80105907 <alltraps>

80105f51 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $42
80105f53:	6a 2a                	push   $0x2a
  jmp alltraps
80105f55:	e9 ad f9 ff ff       	jmp    80105907 <alltraps>

80105f5a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $43
80105f5c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f5e:	e9 a4 f9 ff ff       	jmp    80105907 <alltraps>

80105f63 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $44
80105f65:	6a 2c                	push   $0x2c
  jmp alltraps
80105f67:	e9 9b f9 ff ff       	jmp    80105907 <alltraps>

80105f6c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $45
80105f6e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f70:	e9 92 f9 ff ff       	jmp    80105907 <alltraps>

80105f75 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $46
80105f77:	6a 2e                	push   $0x2e
  jmp alltraps
80105f79:	e9 89 f9 ff ff       	jmp    80105907 <alltraps>

80105f7e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $47
80105f80:	6a 2f                	push   $0x2f
  jmp alltraps
80105f82:	e9 80 f9 ff ff       	jmp    80105907 <alltraps>

80105f87 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $48
80105f89:	6a 30                	push   $0x30
  jmp alltraps
80105f8b:	e9 77 f9 ff ff       	jmp    80105907 <alltraps>

80105f90 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $49
80105f92:	6a 31                	push   $0x31
  jmp alltraps
80105f94:	e9 6e f9 ff ff       	jmp    80105907 <alltraps>

80105f99 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $50
80105f9b:	6a 32                	push   $0x32
  jmp alltraps
80105f9d:	e9 65 f9 ff ff       	jmp    80105907 <alltraps>

80105fa2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $51
80105fa4:	6a 33                	push   $0x33
  jmp alltraps
80105fa6:	e9 5c f9 ff ff       	jmp    80105907 <alltraps>

80105fab <vector52>:
.globl vector52
vector52:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $52
80105fad:	6a 34                	push   $0x34
  jmp alltraps
80105faf:	e9 53 f9 ff ff       	jmp    80105907 <alltraps>

80105fb4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $53
80105fb6:	6a 35                	push   $0x35
  jmp alltraps
80105fb8:	e9 4a f9 ff ff       	jmp    80105907 <alltraps>

80105fbd <vector54>:
.globl vector54
vector54:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $54
80105fbf:	6a 36                	push   $0x36
  jmp alltraps
80105fc1:	e9 41 f9 ff ff       	jmp    80105907 <alltraps>

80105fc6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $55
80105fc8:	6a 37                	push   $0x37
  jmp alltraps
80105fca:	e9 38 f9 ff ff       	jmp    80105907 <alltraps>

80105fcf <vector56>:
.globl vector56
vector56:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $56
80105fd1:	6a 38                	push   $0x38
  jmp alltraps
80105fd3:	e9 2f f9 ff ff       	jmp    80105907 <alltraps>

80105fd8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $57
80105fda:	6a 39                	push   $0x39
  jmp alltraps
80105fdc:	e9 26 f9 ff ff       	jmp    80105907 <alltraps>

80105fe1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $58
80105fe3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fe5:	e9 1d f9 ff ff       	jmp    80105907 <alltraps>

80105fea <vector59>:
.globl vector59
vector59:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $59
80105fec:	6a 3b                	push   $0x3b
  jmp alltraps
80105fee:	e9 14 f9 ff ff       	jmp    80105907 <alltraps>

80105ff3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $60
80105ff5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ff7:	e9 0b f9 ff ff       	jmp    80105907 <alltraps>

80105ffc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $61
80105ffe:	6a 3d                	push   $0x3d
  jmp alltraps
80106000:	e9 02 f9 ff ff       	jmp    80105907 <alltraps>

80106005 <vector62>:
.globl vector62
vector62:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $62
80106007:	6a 3e                	push   $0x3e
  jmp alltraps
80106009:	e9 f9 f8 ff ff       	jmp    80105907 <alltraps>

8010600e <vector63>:
.globl vector63
vector63:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $63
80106010:	6a 3f                	push   $0x3f
  jmp alltraps
80106012:	e9 f0 f8 ff ff       	jmp    80105907 <alltraps>

80106017 <vector64>:
.globl vector64
vector64:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $64
80106019:	6a 40                	push   $0x40
  jmp alltraps
8010601b:	e9 e7 f8 ff ff       	jmp    80105907 <alltraps>

80106020 <vector65>:
.globl vector65
vector65:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $65
80106022:	6a 41                	push   $0x41
  jmp alltraps
80106024:	e9 de f8 ff ff       	jmp    80105907 <alltraps>

80106029 <vector66>:
.globl vector66
vector66:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $66
8010602b:	6a 42                	push   $0x42
  jmp alltraps
8010602d:	e9 d5 f8 ff ff       	jmp    80105907 <alltraps>

80106032 <vector67>:
.globl vector67
vector67:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $67
80106034:	6a 43                	push   $0x43
  jmp alltraps
80106036:	e9 cc f8 ff ff       	jmp    80105907 <alltraps>

8010603b <vector68>:
.globl vector68
vector68:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $68
8010603d:	6a 44                	push   $0x44
  jmp alltraps
8010603f:	e9 c3 f8 ff ff       	jmp    80105907 <alltraps>

80106044 <vector69>:
.globl vector69
vector69:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $69
80106046:	6a 45                	push   $0x45
  jmp alltraps
80106048:	e9 ba f8 ff ff       	jmp    80105907 <alltraps>

8010604d <vector70>:
.globl vector70
vector70:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $70
8010604f:	6a 46                	push   $0x46
  jmp alltraps
80106051:	e9 b1 f8 ff ff       	jmp    80105907 <alltraps>

80106056 <vector71>:
.globl vector71
vector71:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $71
80106058:	6a 47                	push   $0x47
  jmp alltraps
8010605a:	e9 a8 f8 ff ff       	jmp    80105907 <alltraps>

8010605f <vector72>:
.globl vector72
vector72:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $72
80106061:	6a 48                	push   $0x48
  jmp alltraps
80106063:	e9 9f f8 ff ff       	jmp    80105907 <alltraps>

80106068 <vector73>:
.globl vector73
vector73:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $73
8010606a:	6a 49                	push   $0x49
  jmp alltraps
8010606c:	e9 96 f8 ff ff       	jmp    80105907 <alltraps>

80106071 <vector74>:
.globl vector74
vector74:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $74
80106073:	6a 4a                	push   $0x4a
  jmp alltraps
80106075:	e9 8d f8 ff ff       	jmp    80105907 <alltraps>

8010607a <vector75>:
.globl vector75
vector75:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $75
8010607c:	6a 4b                	push   $0x4b
  jmp alltraps
8010607e:	e9 84 f8 ff ff       	jmp    80105907 <alltraps>

80106083 <vector76>:
.globl vector76
vector76:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $76
80106085:	6a 4c                	push   $0x4c
  jmp alltraps
80106087:	e9 7b f8 ff ff       	jmp    80105907 <alltraps>

8010608c <vector77>:
.globl vector77
vector77:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $77
8010608e:	6a 4d                	push   $0x4d
  jmp alltraps
80106090:	e9 72 f8 ff ff       	jmp    80105907 <alltraps>

80106095 <vector78>:
.globl vector78
vector78:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $78
80106097:	6a 4e                	push   $0x4e
  jmp alltraps
80106099:	e9 69 f8 ff ff       	jmp    80105907 <alltraps>

8010609e <vector79>:
.globl vector79
vector79:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $79
801060a0:	6a 4f                	push   $0x4f
  jmp alltraps
801060a2:	e9 60 f8 ff ff       	jmp    80105907 <alltraps>

801060a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $80
801060a9:	6a 50                	push   $0x50
  jmp alltraps
801060ab:	e9 57 f8 ff ff       	jmp    80105907 <alltraps>

801060b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $81
801060b2:	6a 51                	push   $0x51
  jmp alltraps
801060b4:	e9 4e f8 ff ff       	jmp    80105907 <alltraps>

801060b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $82
801060bb:	6a 52                	push   $0x52
  jmp alltraps
801060bd:	e9 45 f8 ff ff       	jmp    80105907 <alltraps>

801060c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $83
801060c4:	6a 53                	push   $0x53
  jmp alltraps
801060c6:	e9 3c f8 ff ff       	jmp    80105907 <alltraps>

801060cb <vector84>:
.globl vector84
vector84:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $84
801060cd:	6a 54                	push   $0x54
  jmp alltraps
801060cf:	e9 33 f8 ff ff       	jmp    80105907 <alltraps>

801060d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $85
801060d6:	6a 55                	push   $0x55
  jmp alltraps
801060d8:	e9 2a f8 ff ff       	jmp    80105907 <alltraps>

801060dd <vector86>:
.globl vector86
vector86:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $86
801060df:	6a 56                	push   $0x56
  jmp alltraps
801060e1:	e9 21 f8 ff ff       	jmp    80105907 <alltraps>

801060e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $87
801060e8:	6a 57                	push   $0x57
  jmp alltraps
801060ea:	e9 18 f8 ff ff       	jmp    80105907 <alltraps>

801060ef <vector88>:
.globl vector88
vector88:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $88
801060f1:	6a 58                	push   $0x58
  jmp alltraps
801060f3:	e9 0f f8 ff ff       	jmp    80105907 <alltraps>

801060f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $89
801060fa:	6a 59                	push   $0x59
  jmp alltraps
801060fc:	e9 06 f8 ff ff       	jmp    80105907 <alltraps>

80106101 <vector90>:
.globl vector90
vector90:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $90
80106103:	6a 5a                	push   $0x5a
  jmp alltraps
80106105:	e9 fd f7 ff ff       	jmp    80105907 <alltraps>

8010610a <vector91>:
.globl vector91
vector91:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $91
8010610c:	6a 5b                	push   $0x5b
  jmp alltraps
8010610e:	e9 f4 f7 ff ff       	jmp    80105907 <alltraps>

80106113 <vector92>:
.globl vector92
vector92:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $92
80106115:	6a 5c                	push   $0x5c
  jmp alltraps
80106117:	e9 eb f7 ff ff       	jmp    80105907 <alltraps>

8010611c <vector93>:
.globl vector93
vector93:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $93
8010611e:	6a 5d                	push   $0x5d
  jmp alltraps
80106120:	e9 e2 f7 ff ff       	jmp    80105907 <alltraps>

80106125 <vector94>:
.globl vector94
vector94:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $94
80106127:	6a 5e                	push   $0x5e
  jmp alltraps
80106129:	e9 d9 f7 ff ff       	jmp    80105907 <alltraps>

8010612e <vector95>:
.globl vector95
vector95:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $95
80106130:	6a 5f                	push   $0x5f
  jmp alltraps
80106132:	e9 d0 f7 ff ff       	jmp    80105907 <alltraps>

80106137 <vector96>:
.globl vector96
vector96:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $96
80106139:	6a 60                	push   $0x60
  jmp alltraps
8010613b:	e9 c7 f7 ff ff       	jmp    80105907 <alltraps>

80106140 <vector97>:
.globl vector97
vector97:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $97
80106142:	6a 61                	push   $0x61
  jmp alltraps
80106144:	e9 be f7 ff ff       	jmp    80105907 <alltraps>

80106149 <vector98>:
.globl vector98
vector98:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $98
8010614b:	6a 62                	push   $0x62
  jmp alltraps
8010614d:	e9 b5 f7 ff ff       	jmp    80105907 <alltraps>

80106152 <vector99>:
.globl vector99
vector99:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $99
80106154:	6a 63                	push   $0x63
  jmp alltraps
80106156:	e9 ac f7 ff ff       	jmp    80105907 <alltraps>

8010615b <vector100>:
.globl vector100
vector100:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $100
8010615d:	6a 64                	push   $0x64
  jmp alltraps
8010615f:	e9 a3 f7 ff ff       	jmp    80105907 <alltraps>

80106164 <vector101>:
.globl vector101
vector101:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $101
80106166:	6a 65                	push   $0x65
  jmp alltraps
80106168:	e9 9a f7 ff ff       	jmp    80105907 <alltraps>

8010616d <vector102>:
.globl vector102
vector102:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $102
8010616f:	6a 66                	push   $0x66
  jmp alltraps
80106171:	e9 91 f7 ff ff       	jmp    80105907 <alltraps>

80106176 <vector103>:
.globl vector103
vector103:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $103
80106178:	6a 67                	push   $0x67
  jmp alltraps
8010617a:	e9 88 f7 ff ff       	jmp    80105907 <alltraps>

8010617f <vector104>:
.globl vector104
vector104:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $104
80106181:	6a 68                	push   $0x68
  jmp alltraps
80106183:	e9 7f f7 ff ff       	jmp    80105907 <alltraps>

80106188 <vector105>:
.globl vector105
vector105:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $105
8010618a:	6a 69                	push   $0x69
  jmp alltraps
8010618c:	e9 76 f7 ff ff       	jmp    80105907 <alltraps>

80106191 <vector106>:
.globl vector106
vector106:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $106
80106193:	6a 6a                	push   $0x6a
  jmp alltraps
80106195:	e9 6d f7 ff ff       	jmp    80105907 <alltraps>

8010619a <vector107>:
.globl vector107
vector107:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $107
8010619c:	6a 6b                	push   $0x6b
  jmp alltraps
8010619e:	e9 64 f7 ff ff       	jmp    80105907 <alltraps>

801061a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $108
801061a5:	6a 6c                	push   $0x6c
  jmp alltraps
801061a7:	e9 5b f7 ff ff       	jmp    80105907 <alltraps>

801061ac <vector109>:
.globl vector109
vector109:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $109
801061ae:	6a 6d                	push   $0x6d
  jmp alltraps
801061b0:	e9 52 f7 ff ff       	jmp    80105907 <alltraps>

801061b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $110
801061b7:	6a 6e                	push   $0x6e
  jmp alltraps
801061b9:	e9 49 f7 ff ff       	jmp    80105907 <alltraps>

801061be <vector111>:
.globl vector111
vector111:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $111
801061c0:	6a 6f                	push   $0x6f
  jmp alltraps
801061c2:	e9 40 f7 ff ff       	jmp    80105907 <alltraps>

801061c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $112
801061c9:	6a 70                	push   $0x70
  jmp alltraps
801061cb:	e9 37 f7 ff ff       	jmp    80105907 <alltraps>

801061d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $113
801061d2:	6a 71                	push   $0x71
  jmp alltraps
801061d4:	e9 2e f7 ff ff       	jmp    80105907 <alltraps>

801061d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $114
801061db:	6a 72                	push   $0x72
  jmp alltraps
801061dd:	e9 25 f7 ff ff       	jmp    80105907 <alltraps>

801061e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $115
801061e4:	6a 73                	push   $0x73
  jmp alltraps
801061e6:	e9 1c f7 ff ff       	jmp    80105907 <alltraps>

801061eb <vector116>:
.globl vector116
vector116:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $116
801061ed:	6a 74                	push   $0x74
  jmp alltraps
801061ef:	e9 13 f7 ff ff       	jmp    80105907 <alltraps>

801061f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $117
801061f6:	6a 75                	push   $0x75
  jmp alltraps
801061f8:	e9 0a f7 ff ff       	jmp    80105907 <alltraps>

801061fd <vector118>:
.globl vector118
vector118:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $118
801061ff:	6a 76                	push   $0x76
  jmp alltraps
80106201:	e9 01 f7 ff ff       	jmp    80105907 <alltraps>

80106206 <vector119>:
.globl vector119
vector119:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $119
80106208:	6a 77                	push   $0x77
  jmp alltraps
8010620a:	e9 f8 f6 ff ff       	jmp    80105907 <alltraps>

8010620f <vector120>:
.globl vector120
vector120:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $120
80106211:	6a 78                	push   $0x78
  jmp alltraps
80106213:	e9 ef f6 ff ff       	jmp    80105907 <alltraps>

80106218 <vector121>:
.globl vector121
vector121:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $121
8010621a:	6a 79                	push   $0x79
  jmp alltraps
8010621c:	e9 e6 f6 ff ff       	jmp    80105907 <alltraps>

80106221 <vector122>:
.globl vector122
vector122:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $122
80106223:	6a 7a                	push   $0x7a
  jmp alltraps
80106225:	e9 dd f6 ff ff       	jmp    80105907 <alltraps>

8010622a <vector123>:
.globl vector123
vector123:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $123
8010622c:	6a 7b                	push   $0x7b
  jmp alltraps
8010622e:	e9 d4 f6 ff ff       	jmp    80105907 <alltraps>

80106233 <vector124>:
.globl vector124
vector124:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $124
80106235:	6a 7c                	push   $0x7c
  jmp alltraps
80106237:	e9 cb f6 ff ff       	jmp    80105907 <alltraps>

8010623c <vector125>:
.globl vector125
vector125:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $125
8010623e:	6a 7d                	push   $0x7d
  jmp alltraps
80106240:	e9 c2 f6 ff ff       	jmp    80105907 <alltraps>

80106245 <vector126>:
.globl vector126
vector126:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $126
80106247:	6a 7e                	push   $0x7e
  jmp alltraps
80106249:	e9 b9 f6 ff ff       	jmp    80105907 <alltraps>

8010624e <vector127>:
.globl vector127
vector127:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $127
80106250:	6a 7f                	push   $0x7f
  jmp alltraps
80106252:	e9 b0 f6 ff ff       	jmp    80105907 <alltraps>

80106257 <vector128>:
.globl vector128
vector128:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $128
80106259:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010625e:	e9 a4 f6 ff ff       	jmp    80105907 <alltraps>

80106263 <vector129>:
.globl vector129
vector129:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $129
80106265:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010626a:	e9 98 f6 ff ff       	jmp    80105907 <alltraps>

8010626f <vector130>:
.globl vector130
vector130:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $130
80106271:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106276:	e9 8c f6 ff ff       	jmp    80105907 <alltraps>

8010627b <vector131>:
.globl vector131
vector131:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $131
8010627d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106282:	e9 80 f6 ff ff       	jmp    80105907 <alltraps>

80106287 <vector132>:
.globl vector132
vector132:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $132
80106289:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010628e:	e9 74 f6 ff ff       	jmp    80105907 <alltraps>

80106293 <vector133>:
.globl vector133
vector133:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $133
80106295:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010629a:	e9 68 f6 ff ff       	jmp    80105907 <alltraps>

8010629f <vector134>:
.globl vector134
vector134:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $134
801062a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062a6:	e9 5c f6 ff ff       	jmp    80105907 <alltraps>

801062ab <vector135>:
.globl vector135
vector135:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $135
801062ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062b2:	e9 50 f6 ff ff       	jmp    80105907 <alltraps>

801062b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $136
801062b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062be:	e9 44 f6 ff ff       	jmp    80105907 <alltraps>

801062c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $137
801062c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062ca:	e9 38 f6 ff ff       	jmp    80105907 <alltraps>

801062cf <vector138>:
.globl vector138
vector138:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $138
801062d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062d6:	e9 2c f6 ff ff       	jmp    80105907 <alltraps>

801062db <vector139>:
.globl vector139
vector139:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $139
801062dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062e2:	e9 20 f6 ff ff       	jmp    80105907 <alltraps>

801062e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $140
801062e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ee:	e9 14 f6 ff ff       	jmp    80105907 <alltraps>

801062f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $141
801062f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062fa:	e9 08 f6 ff ff       	jmp    80105907 <alltraps>

801062ff <vector142>:
.globl vector142
vector142:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $142
80106301:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106306:	e9 fc f5 ff ff       	jmp    80105907 <alltraps>

8010630b <vector143>:
.globl vector143
vector143:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $143
8010630d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106312:	e9 f0 f5 ff ff       	jmp    80105907 <alltraps>

80106317 <vector144>:
.globl vector144
vector144:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $144
80106319:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010631e:	e9 e4 f5 ff ff       	jmp    80105907 <alltraps>

80106323 <vector145>:
.globl vector145
vector145:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $145
80106325:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010632a:	e9 d8 f5 ff ff       	jmp    80105907 <alltraps>

8010632f <vector146>:
.globl vector146
vector146:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $146
80106331:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106336:	e9 cc f5 ff ff       	jmp    80105907 <alltraps>

8010633b <vector147>:
.globl vector147
vector147:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $147
8010633d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106342:	e9 c0 f5 ff ff       	jmp    80105907 <alltraps>

80106347 <vector148>:
.globl vector148
vector148:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $148
80106349:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010634e:	e9 b4 f5 ff ff       	jmp    80105907 <alltraps>

80106353 <vector149>:
.globl vector149
vector149:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $149
80106355:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010635a:	e9 a8 f5 ff ff       	jmp    80105907 <alltraps>

8010635f <vector150>:
.globl vector150
vector150:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $150
80106361:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106366:	e9 9c f5 ff ff       	jmp    80105907 <alltraps>

8010636b <vector151>:
.globl vector151
vector151:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $151
8010636d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106372:	e9 90 f5 ff ff       	jmp    80105907 <alltraps>

80106377 <vector152>:
.globl vector152
vector152:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $152
80106379:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010637e:	e9 84 f5 ff ff       	jmp    80105907 <alltraps>

80106383 <vector153>:
.globl vector153
vector153:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $153
80106385:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010638a:	e9 78 f5 ff ff       	jmp    80105907 <alltraps>

8010638f <vector154>:
.globl vector154
vector154:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $154
80106391:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106396:	e9 6c f5 ff ff       	jmp    80105907 <alltraps>

8010639b <vector155>:
.globl vector155
vector155:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $155
8010639d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063a2:	e9 60 f5 ff ff       	jmp    80105907 <alltraps>

801063a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $156
801063a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063ae:	e9 54 f5 ff ff       	jmp    80105907 <alltraps>

801063b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $157
801063b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ba:	e9 48 f5 ff ff       	jmp    80105907 <alltraps>

801063bf <vector158>:
.globl vector158
vector158:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $158
801063c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063c6:	e9 3c f5 ff ff       	jmp    80105907 <alltraps>

801063cb <vector159>:
.globl vector159
vector159:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $159
801063cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063d2:	e9 30 f5 ff ff       	jmp    80105907 <alltraps>

801063d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $160
801063d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063de:	e9 24 f5 ff ff       	jmp    80105907 <alltraps>

801063e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $161
801063e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063ea:	e9 18 f5 ff ff       	jmp    80105907 <alltraps>

801063ef <vector162>:
.globl vector162
vector162:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $162
801063f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063f6:	e9 0c f5 ff ff       	jmp    80105907 <alltraps>

801063fb <vector163>:
.globl vector163
vector163:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $163
801063fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106402:	e9 00 f5 ff ff       	jmp    80105907 <alltraps>

80106407 <vector164>:
.globl vector164
vector164:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $164
80106409:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010640e:	e9 f4 f4 ff ff       	jmp    80105907 <alltraps>

80106413 <vector165>:
.globl vector165
vector165:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $165
80106415:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010641a:	e9 e8 f4 ff ff       	jmp    80105907 <alltraps>

8010641f <vector166>:
.globl vector166
vector166:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $166
80106421:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106426:	e9 dc f4 ff ff       	jmp    80105907 <alltraps>

8010642b <vector167>:
.globl vector167
vector167:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $167
8010642d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106432:	e9 d0 f4 ff ff       	jmp    80105907 <alltraps>

80106437 <vector168>:
.globl vector168
vector168:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $168
80106439:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010643e:	e9 c4 f4 ff ff       	jmp    80105907 <alltraps>

80106443 <vector169>:
.globl vector169
vector169:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $169
80106445:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010644a:	e9 b8 f4 ff ff       	jmp    80105907 <alltraps>

8010644f <vector170>:
.globl vector170
vector170:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $170
80106451:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106456:	e9 ac f4 ff ff       	jmp    80105907 <alltraps>

8010645b <vector171>:
.globl vector171
vector171:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $171
8010645d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106462:	e9 a0 f4 ff ff       	jmp    80105907 <alltraps>

80106467 <vector172>:
.globl vector172
vector172:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $172
80106469:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010646e:	e9 94 f4 ff ff       	jmp    80105907 <alltraps>

80106473 <vector173>:
.globl vector173
vector173:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $173
80106475:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010647a:	e9 88 f4 ff ff       	jmp    80105907 <alltraps>

8010647f <vector174>:
.globl vector174
vector174:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $174
80106481:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106486:	e9 7c f4 ff ff       	jmp    80105907 <alltraps>

8010648b <vector175>:
.globl vector175
vector175:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $175
8010648d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106492:	e9 70 f4 ff ff       	jmp    80105907 <alltraps>

80106497 <vector176>:
.globl vector176
vector176:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $176
80106499:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010649e:	e9 64 f4 ff ff       	jmp    80105907 <alltraps>

801064a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $177
801064a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064aa:	e9 58 f4 ff ff       	jmp    80105907 <alltraps>

801064af <vector178>:
.globl vector178
vector178:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $178
801064b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064b6:	e9 4c f4 ff ff       	jmp    80105907 <alltraps>

801064bb <vector179>:
.globl vector179
vector179:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $179
801064bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064c2:	e9 40 f4 ff ff       	jmp    80105907 <alltraps>

801064c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $180
801064c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064ce:	e9 34 f4 ff ff       	jmp    80105907 <alltraps>

801064d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $181
801064d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064da:	e9 28 f4 ff ff       	jmp    80105907 <alltraps>

801064df <vector182>:
.globl vector182
vector182:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $182
801064e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064e6:	e9 1c f4 ff ff       	jmp    80105907 <alltraps>

801064eb <vector183>:
.globl vector183
vector183:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $183
801064ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064f2:	e9 10 f4 ff ff       	jmp    80105907 <alltraps>

801064f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $184
801064f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064fe:	e9 04 f4 ff ff       	jmp    80105907 <alltraps>

80106503 <vector185>:
.globl vector185
vector185:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $185
80106505:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010650a:	e9 f8 f3 ff ff       	jmp    80105907 <alltraps>

8010650f <vector186>:
.globl vector186
vector186:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $186
80106511:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106516:	e9 ec f3 ff ff       	jmp    80105907 <alltraps>

8010651b <vector187>:
.globl vector187
vector187:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $187
8010651d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106522:	e9 e0 f3 ff ff       	jmp    80105907 <alltraps>

80106527 <vector188>:
.globl vector188
vector188:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $188
80106529:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010652e:	e9 d4 f3 ff ff       	jmp    80105907 <alltraps>

80106533 <vector189>:
.globl vector189
vector189:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $189
80106535:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010653a:	e9 c8 f3 ff ff       	jmp    80105907 <alltraps>

8010653f <vector190>:
.globl vector190
vector190:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $190
80106541:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106546:	e9 bc f3 ff ff       	jmp    80105907 <alltraps>

8010654b <vector191>:
.globl vector191
vector191:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $191
8010654d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106552:	e9 b0 f3 ff ff       	jmp    80105907 <alltraps>

80106557 <vector192>:
.globl vector192
vector192:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $192
80106559:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010655e:	e9 a4 f3 ff ff       	jmp    80105907 <alltraps>

80106563 <vector193>:
.globl vector193
vector193:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $193
80106565:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010656a:	e9 98 f3 ff ff       	jmp    80105907 <alltraps>

8010656f <vector194>:
.globl vector194
vector194:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $194
80106571:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106576:	e9 8c f3 ff ff       	jmp    80105907 <alltraps>

8010657b <vector195>:
.globl vector195
vector195:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $195
8010657d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106582:	e9 80 f3 ff ff       	jmp    80105907 <alltraps>

80106587 <vector196>:
.globl vector196
vector196:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $196
80106589:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010658e:	e9 74 f3 ff ff       	jmp    80105907 <alltraps>

80106593 <vector197>:
.globl vector197
vector197:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $197
80106595:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010659a:	e9 68 f3 ff ff       	jmp    80105907 <alltraps>

8010659f <vector198>:
.globl vector198
vector198:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $198
801065a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065a6:	e9 5c f3 ff ff       	jmp    80105907 <alltraps>

801065ab <vector199>:
.globl vector199
vector199:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $199
801065ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065b2:	e9 50 f3 ff ff       	jmp    80105907 <alltraps>

801065b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $200
801065b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065be:	e9 44 f3 ff ff       	jmp    80105907 <alltraps>

801065c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $201
801065c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065ca:	e9 38 f3 ff ff       	jmp    80105907 <alltraps>

801065cf <vector202>:
.globl vector202
vector202:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $202
801065d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065d6:	e9 2c f3 ff ff       	jmp    80105907 <alltraps>

801065db <vector203>:
.globl vector203
vector203:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $203
801065dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065e2:	e9 20 f3 ff ff       	jmp    80105907 <alltraps>

801065e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $204
801065e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ee:	e9 14 f3 ff ff       	jmp    80105907 <alltraps>

801065f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $205
801065f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065fa:	e9 08 f3 ff ff       	jmp    80105907 <alltraps>

801065ff <vector206>:
.globl vector206
vector206:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $206
80106601:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106606:	e9 fc f2 ff ff       	jmp    80105907 <alltraps>

8010660b <vector207>:
.globl vector207
vector207:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $207
8010660d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106612:	e9 f0 f2 ff ff       	jmp    80105907 <alltraps>

80106617 <vector208>:
.globl vector208
vector208:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $208
80106619:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010661e:	e9 e4 f2 ff ff       	jmp    80105907 <alltraps>

80106623 <vector209>:
.globl vector209
vector209:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $209
80106625:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010662a:	e9 d8 f2 ff ff       	jmp    80105907 <alltraps>

8010662f <vector210>:
.globl vector210
vector210:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $210
80106631:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106636:	e9 cc f2 ff ff       	jmp    80105907 <alltraps>

8010663b <vector211>:
.globl vector211
vector211:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $211
8010663d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106642:	e9 c0 f2 ff ff       	jmp    80105907 <alltraps>

80106647 <vector212>:
.globl vector212
vector212:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $212
80106649:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010664e:	e9 b4 f2 ff ff       	jmp    80105907 <alltraps>

80106653 <vector213>:
.globl vector213
vector213:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $213
80106655:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010665a:	e9 a8 f2 ff ff       	jmp    80105907 <alltraps>

8010665f <vector214>:
.globl vector214
vector214:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $214
80106661:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106666:	e9 9c f2 ff ff       	jmp    80105907 <alltraps>

8010666b <vector215>:
.globl vector215
vector215:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $215
8010666d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106672:	e9 90 f2 ff ff       	jmp    80105907 <alltraps>

80106677 <vector216>:
.globl vector216
vector216:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $216
80106679:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010667e:	e9 84 f2 ff ff       	jmp    80105907 <alltraps>

80106683 <vector217>:
.globl vector217
vector217:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $217
80106685:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010668a:	e9 78 f2 ff ff       	jmp    80105907 <alltraps>

8010668f <vector218>:
.globl vector218
vector218:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $218
80106691:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106696:	e9 6c f2 ff ff       	jmp    80105907 <alltraps>

8010669b <vector219>:
.globl vector219
vector219:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $219
8010669d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066a2:	e9 60 f2 ff ff       	jmp    80105907 <alltraps>

801066a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $220
801066a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066ae:	e9 54 f2 ff ff       	jmp    80105907 <alltraps>

801066b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $221
801066b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ba:	e9 48 f2 ff ff       	jmp    80105907 <alltraps>

801066bf <vector222>:
.globl vector222
vector222:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $222
801066c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066c6:	e9 3c f2 ff ff       	jmp    80105907 <alltraps>

801066cb <vector223>:
.globl vector223
vector223:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $223
801066cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066d2:	e9 30 f2 ff ff       	jmp    80105907 <alltraps>

801066d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $224
801066d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066de:	e9 24 f2 ff ff       	jmp    80105907 <alltraps>

801066e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $225
801066e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066ea:	e9 18 f2 ff ff       	jmp    80105907 <alltraps>

801066ef <vector226>:
.globl vector226
vector226:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $226
801066f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066f6:	e9 0c f2 ff ff       	jmp    80105907 <alltraps>

801066fb <vector227>:
.globl vector227
vector227:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $227
801066fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106702:	e9 00 f2 ff ff       	jmp    80105907 <alltraps>

80106707 <vector228>:
.globl vector228
vector228:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $228
80106709:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010670e:	e9 f4 f1 ff ff       	jmp    80105907 <alltraps>

80106713 <vector229>:
.globl vector229
vector229:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $229
80106715:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010671a:	e9 e8 f1 ff ff       	jmp    80105907 <alltraps>

8010671f <vector230>:
.globl vector230
vector230:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $230
80106721:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106726:	e9 dc f1 ff ff       	jmp    80105907 <alltraps>

8010672b <vector231>:
.globl vector231
vector231:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $231
8010672d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106732:	e9 d0 f1 ff ff       	jmp    80105907 <alltraps>

80106737 <vector232>:
.globl vector232
vector232:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $232
80106739:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010673e:	e9 c4 f1 ff ff       	jmp    80105907 <alltraps>

80106743 <vector233>:
.globl vector233
vector233:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $233
80106745:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010674a:	e9 b8 f1 ff ff       	jmp    80105907 <alltraps>

8010674f <vector234>:
.globl vector234
vector234:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $234
80106751:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106756:	e9 ac f1 ff ff       	jmp    80105907 <alltraps>

8010675b <vector235>:
.globl vector235
vector235:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $235
8010675d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106762:	e9 a0 f1 ff ff       	jmp    80105907 <alltraps>

80106767 <vector236>:
.globl vector236
vector236:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $236
80106769:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010676e:	e9 94 f1 ff ff       	jmp    80105907 <alltraps>

80106773 <vector237>:
.globl vector237
vector237:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $237
80106775:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010677a:	e9 88 f1 ff ff       	jmp    80105907 <alltraps>

8010677f <vector238>:
.globl vector238
vector238:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $238
80106781:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106786:	e9 7c f1 ff ff       	jmp    80105907 <alltraps>

8010678b <vector239>:
.globl vector239
vector239:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $239
8010678d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106792:	e9 70 f1 ff ff       	jmp    80105907 <alltraps>

80106797 <vector240>:
.globl vector240
vector240:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $240
80106799:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010679e:	e9 64 f1 ff ff       	jmp    80105907 <alltraps>

801067a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $241
801067a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067aa:	e9 58 f1 ff ff       	jmp    80105907 <alltraps>

801067af <vector242>:
.globl vector242
vector242:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $242
801067b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067b6:	e9 4c f1 ff ff       	jmp    80105907 <alltraps>

801067bb <vector243>:
.globl vector243
vector243:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $243
801067bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067c2:	e9 40 f1 ff ff       	jmp    80105907 <alltraps>

801067c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $244
801067c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067ce:	e9 34 f1 ff ff       	jmp    80105907 <alltraps>

801067d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $245
801067d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067da:	e9 28 f1 ff ff       	jmp    80105907 <alltraps>

801067df <vector246>:
.globl vector246
vector246:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $246
801067e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067e6:	e9 1c f1 ff ff       	jmp    80105907 <alltraps>

801067eb <vector247>:
.globl vector247
vector247:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $247
801067ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067f2:	e9 10 f1 ff ff       	jmp    80105907 <alltraps>

801067f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $248
801067f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067fe:	e9 04 f1 ff ff       	jmp    80105907 <alltraps>

80106803 <vector249>:
.globl vector249
vector249:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $249
80106805:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010680a:	e9 f8 f0 ff ff       	jmp    80105907 <alltraps>

8010680f <vector250>:
.globl vector250
vector250:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $250
80106811:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106816:	e9 ec f0 ff ff       	jmp    80105907 <alltraps>

8010681b <vector251>:
.globl vector251
vector251:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $251
8010681d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106822:	e9 e0 f0 ff ff       	jmp    80105907 <alltraps>

80106827 <vector252>:
.globl vector252
vector252:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $252
80106829:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010682e:	e9 d4 f0 ff ff       	jmp    80105907 <alltraps>

80106833 <vector253>:
.globl vector253
vector253:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $253
80106835:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010683a:	e9 c8 f0 ff ff       	jmp    80105907 <alltraps>

8010683f <vector254>:
.globl vector254
vector254:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $254
80106841:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106846:	e9 bc f0 ff ff       	jmp    80105907 <alltraps>

8010684b <vector255>:
.globl vector255
vector255:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $255
8010684d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106852:	e9 b0 f0 ff ff       	jmp    80105907 <alltraps>
80106857:	66 90                	xchg   %ax,%ax
80106859:	66 90                	xchg   %ax,%ax
8010685b:	66 90                	xchg   %ax,%ax
8010685d:	66 90                	xchg   %ax,%ax
8010685f:	90                   	nop

80106860 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106866:	89 d3                	mov    %edx,%ebx
{
80106868:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010686a:	c1 eb 16             	shr    $0x16,%ebx
8010686d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106870:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106873:	8b 06                	mov    (%esi),%eax
80106875:	a8 01                	test   $0x1,%al
80106877:	74 27                	je     801068a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106879:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010687e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106884:	c1 ef 0a             	shr    $0xa,%edi
}
80106887:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010688a:	89 fa                	mov    %edi,%edx
8010688c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106892:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106895:	5b                   	pop    %ebx
80106896:	5e                   	pop    %esi
80106897:	5f                   	pop    %edi
80106898:	5d                   	pop    %ebp
80106899:	c3                   	ret    
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068a0:	85 c9                	test   %ecx,%ecx
801068a2:	74 2c                	je     801068d0 <walkpgdir+0x70>
801068a4:	e8 57 bc ff ff       	call   80102500 <kalloc>
801068a9:	85 c0                	test   %eax,%eax
801068ab:	89 c3                	mov    %eax,%ebx
801068ad:	74 21                	je     801068d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801068af:	83 ec 04             	sub    $0x4,%esp
801068b2:	68 00 10 00 00       	push   $0x1000
801068b7:	6a 00                	push   $0x0
801068b9:	50                   	push   %eax
801068ba:	e8 a1 dd ff ff       	call   80104660 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068c5:	83 c4 10             	add    $0x10,%esp
801068c8:	83 c8 07             	or     $0x7,%eax
801068cb:	89 06                	mov    %eax,(%esi)
801068cd:	eb b5                	jmp    80106884 <walkpgdir+0x24>
801068cf:	90                   	nop
}
801068d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801068d3:	31 c0                	xor    %eax,%eax
}
801068d5:	5b                   	pop    %ebx
801068d6:	5e                   	pop    %esi
801068d7:	5f                   	pop    %edi
801068d8:	5d                   	pop    %ebp
801068d9:	c3                   	ret    
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068e6:	89 d3                	mov    %edx,%ebx
801068e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068ee:	83 ec 1c             	sub    $0x1c,%esp
801068f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801068fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106900:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106903:	8b 45 0c             	mov    0xc(%ebp),%eax
80106906:	29 df                	sub    %ebx,%edi
80106908:	83 c8 01             	or     $0x1,%eax
8010690b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010690e:	eb 15                	jmp    80106925 <mappages+0x45>
    if(*pte & PTE_P)
80106910:	f6 00 01             	testb  $0x1,(%eax)
80106913:	75 45                	jne    8010695a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106915:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106918:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010691b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010691d:	74 31                	je     80106950 <mappages+0x70>
      break;
    a += PGSIZE;
8010691f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106928:	b9 01 00 00 00       	mov    $0x1,%ecx
8010692d:	89 da                	mov    %ebx,%edx
8010692f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106932:	e8 29 ff ff ff       	call   80106860 <walkpgdir>
80106937:	85 c0                	test   %eax,%eax
80106939:	75 d5                	jne    80106910 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010693b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010693e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106943:	5b                   	pop    %ebx
80106944:	5e                   	pop    %esi
80106945:	5f                   	pop    %edi
80106946:	5d                   	pop    %ebp
80106947:	c3                   	ret    
80106948:	90                   	nop
80106949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106953:	31 c0                	xor    %eax,%eax
}
80106955:	5b                   	pop    %ebx
80106956:	5e                   	pop    %esi
80106957:	5f                   	pop    %edi
80106958:	5d                   	pop    %ebp
80106959:	c3                   	ret    
      panic("remap");
8010695a:	83 ec 0c             	sub    $0xc,%esp
8010695d:	68 c0 7a 10 80       	push   $0x80107ac0
80106962:	e8 29 9a ff ff       	call   80100390 <panic>
80106967:	89 f6                	mov    %esi,%esi
80106969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106970 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106976:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010697c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010697e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106984:	83 ec 1c             	sub    $0x1c,%esp
80106987:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010698a:	39 d3                	cmp    %edx,%ebx
8010698c:	73 66                	jae    801069f4 <deallocuvm.part.0+0x84>
8010698e:	89 d6                	mov    %edx,%esi
80106990:	eb 3d                	jmp    801069cf <deallocuvm.part.0+0x5f>
80106992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106998:	8b 10                	mov    (%eax),%edx
8010699a:	f6 c2 01             	test   $0x1,%dl
8010699d:	74 26                	je     801069c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010699f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069a5:	74 58                	je     801069ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801069a7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801069b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801069b3:	52                   	push   %edx
801069b4:	e8 97 b9 ff ff       	call   80102350 <kfree>
      *pte = 0;
801069b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069bc:	83 c4 10             	add    $0x10,%esp
801069bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801069c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069cb:	39 f3                	cmp    %esi,%ebx
801069cd:	73 25                	jae    801069f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801069cf:	31 c9                	xor    %ecx,%ecx
801069d1:	89 da                	mov    %ebx,%edx
801069d3:	89 f8                	mov    %edi,%eax
801069d5:	e8 86 fe ff ff       	call   80106860 <walkpgdir>
    if(!pte)
801069da:	85 c0                	test   %eax,%eax
801069dc:	75 ba                	jne    80106998 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801069e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069f0:	39 f3                	cmp    %esi,%ebx
801069f2:	72 db                	jb     801069cf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801069f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069fa:	5b                   	pop    %ebx
801069fb:	5e                   	pop    %esi
801069fc:	5f                   	pop    %edi
801069fd:	5d                   	pop    %ebp
801069fe:	c3                   	ret    
        panic("kfree");
801069ff:	83 ec 0c             	sub    $0xc,%esp
80106a02:	68 06 74 10 80       	push   $0x80107406
80106a07:	e8 84 99 ff ff       	call   80100390 <panic>
80106a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a10 <seginit>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a16:	e8 e5 cd ff ff       	call   80103800 <cpuid>
80106a1b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106a21:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a26:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a2a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106a31:	ff 00 00 
80106a34:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106a3b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a3e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106a45:	ff 00 00 
80106a48:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a4f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a52:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a59:	ff 00 00 
80106a5c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106a63:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a66:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106a6d:	ff 00 00 
80106a70:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a77:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a7a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106a7f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a83:	c1 e8 10             	shr    $0x10,%eax
80106a86:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a8a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a8d:	0f 01 10             	lgdtl  (%eax)
}
80106a90:	c9                   	leave  
80106a91:	c3                   	ret    
80106a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106aa0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106aa0:	a1 a4 59 11 80       	mov    0x801159a4,%eax
{
80106aa5:	55                   	push   %ebp
80106aa6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106aa8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aad:	0f 22 d8             	mov    %eax,%cr3
}
80106ab0:	5d                   	pop    %ebp
80106ab1:	c3                   	ret    
80106ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ac0 <switchuvm>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 1c             	sub    $0x1c,%esp
80106ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106acc:	85 db                	test   %ebx,%ebx
80106ace:	0f 84 cb 00 00 00    	je     80106b9f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ad4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ad7:	85 c0                	test   %eax,%eax
80106ad9:	0f 84 da 00 00 00    	je     80106bb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106adf:	8b 43 04             	mov    0x4(%ebx),%eax
80106ae2:	85 c0                	test   %eax,%eax
80106ae4:	0f 84 c2 00 00 00    	je     80106bac <switchuvm+0xec>
  pushcli();
80106aea:	e8 91 d9 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aef:	e8 8c cc ff ff       	call   80103780 <mycpu>
80106af4:	89 c6                	mov    %eax,%esi
80106af6:	e8 85 cc ff ff       	call   80103780 <mycpu>
80106afb:	89 c7                	mov    %eax,%edi
80106afd:	e8 7e cc ff ff       	call   80103780 <mycpu>
80106b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b05:	83 c7 08             	add    $0x8,%edi
80106b08:	e8 73 cc ff ff       	call   80103780 <mycpu>
80106b0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b10:	83 c0 08             	add    $0x8,%eax
80106b13:	ba 67 00 00 00       	mov    $0x67,%edx
80106b18:	c1 e8 18             	shr    $0x18,%eax
80106b1b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106b22:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b29:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b2f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b34:	83 c1 08             	add    $0x8,%ecx
80106b37:	c1 e9 10             	shr    $0x10,%ecx
80106b3a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b45:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b4c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106b51:	e8 2a cc ff ff       	call   80103780 <mycpu>
80106b56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b5d:	e8 1e cc ff ff       	call   80103780 <mycpu>
80106b62:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b66:	8b 73 08             	mov    0x8(%ebx),%esi
80106b69:	e8 12 cc ff ff       	call   80103780 <mycpu>
80106b6e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106b74:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b77:	e8 04 cc ff ff       	call   80103780 <mycpu>
80106b7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b80:	b8 28 00 00 00       	mov    $0x28,%eax
80106b85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b88:	8b 43 04             	mov    0x4(%ebx),%eax
80106b8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b90:	0f 22 d8             	mov    %eax,%cr3
}
80106b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b96:	5b                   	pop    %ebx
80106b97:	5e                   	pop    %esi
80106b98:	5f                   	pop    %edi
80106b99:	5d                   	pop    %ebp
  popcli();
80106b9a:	e9 21 d9 ff ff       	jmp    801044c0 <popcli>
    panic("switchuvm: no process");
80106b9f:	83 ec 0c             	sub    $0xc,%esp
80106ba2:	68 c6 7a 10 80       	push   $0x80107ac6
80106ba7:	e8 e4 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106bac:	83 ec 0c             	sub    $0xc,%esp
80106baf:	68 f1 7a 10 80       	push   $0x80107af1
80106bb4:	e8 d7 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106bb9:	83 ec 0c             	sub    $0xc,%esp
80106bbc:	68 dc 7a 10 80       	push   $0x80107adc
80106bc1:	e8 ca 97 ff ff       	call   80100390 <panic>
80106bc6:	8d 76 00             	lea    0x0(%esi),%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <inituvm>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	83 ec 1c             	sub    $0x1c,%esp
80106bd9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bdc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bdf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106be2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106be8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106beb:	77 49                	ja     80106c36 <inituvm+0x66>
  mem = kalloc();
80106bed:	e8 0e b9 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80106bf2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106bf5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bf7:	68 00 10 00 00       	push   $0x1000
80106bfc:	6a 00                	push   $0x0
80106bfe:	50                   	push   %eax
80106bff:	e8 5c da ff ff       	call   80104660 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c04:	58                   	pop    %eax
80106c05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c10:	5a                   	pop    %edx
80106c11:	6a 06                	push   $0x6
80106c13:	50                   	push   %eax
80106c14:	31 d2                	xor    %edx,%edx
80106c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c19:	e8 c2 fc ff ff       	call   801068e0 <mappages>
  memmove(mem, init, sz);
80106c1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106c21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c24:	83 c4 10             	add    $0x10,%esp
80106c27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c2d:	5b                   	pop    %ebx
80106c2e:	5e                   	pop    %esi
80106c2f:	5f                   	pop    %edi
80106c30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c31:	e9 da da ff ff       	jmp    80104710 <memmove>
    panic("inituvm: more than a page");
80106c36:	83 ec 0c             	sub    $0xc,%esp
80106c39:	68 05 7b 10 80       	push   $0x80107b05
80106c3e:	e8 4d 97 ff ff       	call   80100390 <panic>
80106c43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <loaduvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c60:	0f 85 91 00 00 00    	jne    80106cf7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106c66:	8b 75 18             	mov    0x18(%ebp),%esi
80106c69:	31 db                	xor    %ebx,%ebx
80106c6b:	85 f6                	test   %esi,%esi
80106c6d:	75 1a                	jne    80106c89 <loaduvm+0x39>
80106c6f:	eb 6f                	jmp    80106ce0 <loaduvm+0x90>
80106c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c87:	76 57                	jbe    80106ce0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8f:	31 c9                	xor    %ecx,%ecx
80106c91:	01 da                	add    %ebx,%edx
80106c93:	e8 c8 fb ff ff       	call   80106860 <walkpgdir>
80106c98:	85 c0                	test   %eax,%eax
80106c9a:	74 4e                	je     80106cea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106c9c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ca1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ca6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106cb1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cb4:	01 d9                	add    %ebx,%ecx
80106cb6:	05 00 00 00 80       	add    $0x80000000,%eax
80106cbb:	57                   	push   %edi
80106cbc:	51                   	push   %ecx
80106cbd:	50                   	push   %eax
80106cbe:	ff 75 10             	pushl  0x10(%ebp)
80106cc1:	e8 da ac ff ff       	call   801019a0 <readi>
80106cc6:	83 c4 10             	add    $0x10,%esp
80106cc9:	39 f8                	cmp    %edi,%eax
80106ccb:	74 ab                	je     80106c78 <loaduvm+0x28>
}
80106ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
80106cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ce3:	31 c0                	xor    %eax,%eax
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106cea:	83 ec 0c             	sub    $0xc,%esp
80106ced:	68 1f 7b 10 80       	push   $0x80107b1f
80106cf2:	e8 99 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106cf7:	83 ec 0c             	sub    $0xc,%esp
80106cfa:	68 c0 7b 10 80       	push   $0x80107bc0
80106cff:	e8 8c 96 ff ff       	call   80100390 <panic>
80106d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d10 <allocuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d19:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d1c:	85 ff                	test   %edi,%edi
80106d1e:	0f 88 8e 00 00 00    	js     80106db2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106d24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d27:	0f 82 93 00 00 00    	jb     80106dc0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d3c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d3f:	0f 86 7e 00 00 00    	jbe    80106dc3 <allocuvm+0xb3>
80106d45:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d4b:	eb 42                	jmp    80106d8f <allocuvm+0x7f>
80106d4d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106d50:	83 ec 04             	sub    $0x4,%esp
80106d53:	68 00 10 00 00       	push   $0x1000
80106d58:	6a 00                	push   $0x0
80106d5a:	50                   	push   %eax
80106d5b:	e8 00 d9 ff ff       	call   80104660 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d60:	58                   	pop    %eax
80106d61:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d67:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d6c:	5a                   	pop    %edx
80106d6d:	6a 06                	push   $0x6
80106d6f:	50                   	push   %eax
80106d70:	89 da                	mov    %ebx,%edx
80106d72:	89 f8                	mov    %edi,%eax
80106d74:	e8 67 fb ff ff       	call   801068e0 <mappages>
80106d79:	83 c4 10             	add    $0x10,%esp
80106d7c:	85 c0                	test   %eax,%eax
80106d7e:	78 50                	js     80106dd0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106d80:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d86:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d89:	0f 86 81 00 00 00    	jbe    80106e10 <allocuvm+0x100>
    mem = kalloc();
80106d8f:	e8 6c b7 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80106d94:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106d96:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106d98:	75 b6                	jne    80106d50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d9a:	83 ec 0c             	sub    $0xc,%esp
80106d9d:	68 3d 7b 10 80       	push   $0x80107b3d
80106da2:	e8 b9 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106da7:	83 c4 10             	add    $0x10,%esp
80106daa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dad:	39 45 10             	cmp    %eax,0x10(%ebp)
80106db0:	77 6e                	ja     80106e20 <allocuvm+0x110>
}
80106db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106db5:	31 ff                	xor    %edi,%edi
}
80106db7:	89 f8                	mov    %edi,%eax
80106db9:	5b                   	pop    %ebx
80106dba:	5e                   	pop    %esi
80106dbb:	5f                   	pop    %edi
80106dbc:	5d                   	pop    %ebp
80106dbd:	c3                   	ret    
80106dbe:	66 90                	xchg   %ax,%ax
    return oldsz;
80106dc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc6:	89 f8                	mov    %edi,%eax
80106dc8:	5b                   	pop    %ebx
80106dc9:	5e                   	pop    %esi
80106dca:	5f                   	pop    %edi
80106dcb:	5d                   	pop    %ebp
80106dcc:	c3                   	ret    
80106dcd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106dd0:	83 ec 0c             	sub    $0xc,%esp
80106dd3:	68 55 7b 10 80       	push   $0x80107b55
80106dd8:	e8 83 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106ddd:	83 c4 10             	add    $0x10,%esp
80106de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106de6:	76 0d                	jbe    80106df5 <allocuvm+0xe5>
80106de8:	89 c1                	mov    %eax,%ecx
80106dea:	8b 55 10             	mov    0x10(%ebp),%edx
80106ded:	8b 45 08             	mov    0x8(%ebp),%eax
80106df0:	e8 7b fb ff ff       	call   80106970 <deallocuvm.part.0>
      kfree(mem);
80106df5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106df8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106dfa:	56                   	push   %esi
80106dfb:	e8 50 b5 ff ff       	call   80102350 <kfree>
      return 0;
80106e00:	83 c4 10             	add    $0x10,%esp
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	89 f8                	mov    %edi,%eax
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret    
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
80106e10:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e16:	5b                   	pop    %ebx
80106e17:	89 f8                	mov    %edi,%eax
80106e19:	5e                   	pop    %esi
80106e1a:	5f                   	pop    %edi
80106e1b:	5d                   	pop    %ebp
80106e1c:	c3                   	ret    
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	89 c1                	mov    %eax,%ecx
80106e22:	8b 55 10             	mov    0x10(%ebp),%edx
80106e25:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106e28:	31 ff                	xor    %edi,%edi
80106e2a:	e8 41 fb ff ff       	call   80106970 <deallocuvm.part.0>
80106e2f:	eb 92                	jmp    80106dc3 <allocuvm+0xb3>
80106e31:	eb 0d                	jmp    80106e40 <deallocuvm>
80106e33:	90                   	nop
80106e34:	90                   	nop
80106e35:	90                   	nop
80106e36:	90                   	nop
80106e37:	90                   	nop
80106e38:	90                   	nop
80106e39:	90                   	nop
80106e3a:	90                   	nop
80106e3b:	90                   	nop
80106e3c:	90                   	nop
80106e3d:	90                   	nop
80106e3e:	90                   	nop
80106e3f:	90                   	nop

80106e40 <deallocuvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e4c:	39 d1                	cmp    %edx,%ecx
80106e4e:	73 10                	jae    80106e60 <deallocuvm+0x20>
}
80106e50:	5d                   	pop    %ebp
80106e51:	e9 1a fb ff ff       	jmp    80106970 <deallocuvm.part.0>
80106e56:	8d 76 00             	lea    0x0(%esi),%esi
80106e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e60:	89 d0                	mov    %edx,%eax
80106e62:	5d                   	pop    %ebp
80106e63:	c3                   	ret    
80106e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e7c:	85 f6                	test   %esi,%esi
80106e7e:	74 59                	je     80106ed9 <freevm+0x69>
80106e80:	31 c9                	xor    %ecx,%ecx
80106e82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e87:	89 f0                	mov    %esi,%eax
80106e89:	e8 e2 fa ff ff       	call   80106970 <deallocuvm.part.0>
80106e8e:	89 f3                	mov    %esi,%ebx
80106e90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e96:	eb 0f                	jmp    80106ea7 <freevm+0x37>
80106e98:	90                   	nop
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ea3:	39 fb                	cmp    %edi,%ebx
80106ea5:	74 23                	je     80106eca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ea7:	8b 03                	mov    (%ebx),%eax
80106ea9:	a8 01                	test   $0x1,%al
80106eab:	74 f3                	je     80106ea0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106eb2:	83 ec 0c             	sub    $0xc,%esp
80106eb5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106eb8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106ebd:	50                   	push   %eax
80106ebe:	e8 8d b4 ff ff       	call   80102350 <kfree>
80106ec3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ec6:	39 fb                	cmp    %edi,%ebx
80106ec8:	75 dd                	jne    80106ea7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106eca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed0:	5b                   	pop    %ebx
80106ed1:	5e                   	pop    %esi
80106ed2:	5f                   	pop    %edi
80106ed3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ed4:	e9 77 b4 ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
80106ed9:	83 ec 0c             	sub    $0xc,%esp
80106edc:	68 71 7b 10 80       	push   $0x80107b71
80106ee1:	e8 aa 94 ff ff       	call   80100390 <panic>
80106ee6:	8d 76 00             	lea    0x0(%esi),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <setupkvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	56                   	push   %esi
80106ef4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ef5:	e8 06 b6 ff ff       	call   80102500 <kalloc>
80106efa:	85 c0                	test   %eax,%eax
80106efc:	89 c6                	mov    %eax,%esi
80106efe:	74 42                	je     80106f42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106f00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f03:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f08:	68 00 10 00 00       	push   $0x1000
80106f0d:	6a 00                	push   $0x0
80106f0f:	50                   	push   %eax
80106f10:	e8 4b d7 ff ff       	call   80104660 <memset>
80106f15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f1e:	83 ec 08             	sub    $0x8,%esp
80106f21:	8b 13                	mov    (%ebx),%edx
80106f23:	ff 73 0c             	pushl  0xc(%ebx)
80106f26:	50                   	push   %eax
80106f27:	29 c1                	sub    %eax,%ecx
80106f29:	89 f0                	mov    %esi,%eax
80106f2b:	e8 b0 f9 ff ff       	call   801068e0 <mappages>
80106f30:	83 c4 10             	add    $0x10,%esp
80106f33:	85 c0                	test   %eax,%eax
80106f35:	78 19                	js     80106f50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f37:	83 c3 10             	add    $0x10,%ebx
80106f3a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f40:	75 d6                	jne    80106f18 <setupkvm+0x28>
}
80106f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f45:	89 f0                	mov    %esi,%eax
80106f47:	5b                   	pop    %ebx
80106f48:	5e                   	pop    %esi
80106f49:	5d                   	pop    %ebp
80106f4a:	c3                   	ret    
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106f50:	83 ec 0c             	sub    $0xc,%esp
80106f53:	56                   	push   %esi
      return 0;
80106f54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f56:	e8 15 ff ff ff       	call   80106e70 <freevm>
      return 0;
80106f5b:	83 c4 10             	add    $0x10,%esp
}
80106f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f61:	89 f0                	mov    %esi,%eax
80106f63:	5b                   	pop    %ebx
80106f64:	5e                   	pop    %esi
80106f65:	5d                   	pop    %ebp
80106f66:	c3                   	ret    
80106f67:	89 f6                	mov    %esi,%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f70 <kvmalloc>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f76:	e8 75 ff ff ff       	call   80106ef0 <setupkvm>
80106f7b:	a3 a4 59 11 80       	mov    %eax,0x801159a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f80:	05 00 00 00 80       	add    $0x80000000,%eax
80106f85:	0f 22 d8             	mov    %eax,%cr3
}
80106f88:	c9                   	leave  
80106f89:	c3                   	ret    
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f91:	31 c9                	xor    %ecx,%ecx
{
80106f93:	89 e5                	mov    %esp,%ebp
80106f95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9e:	e8 bd f8 ff ff       	call   80106860 <walkpgdir>
  if(pte == 0)
80106fa3:	85 c0                	test   %eax,%eax
80106fa5:	74 05                	je     80106fac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106fa7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106faa:	c9                   	leave  
80106fab:	c3                   	ret    
    panic("clearpteu");
80106fac:	83 ec 0c             	sub    $0xc,%esp
80106faf:	68 82 7b 10 80       	push   $0x80107b82
80106fb4:	e8 d7 93 ff ff       	call   80100390 <panic>
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fc9:	e8 22 ff ff ff       	call   80106ef0 <setupkvm>
80106fce:	85 c0                	test   %eax,%eax
80106fd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fd3:	0f 84 9f 00 00 00    	je     80107078 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fdc:	85 c9                	test   %ecx,%ecx
80106fde:	0f 84 94 00 00 00    	je     80107078 <copyuvm+0xb8>
80106fe4:	31 ff                	xor    %edi,%edi
80106fe6:	eb 4a                	jmp    80107032 <copyuvm+0x72>
80106fe8:	90                   	nop
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ff0:	83 ec 04             	sub    $0x4,%esp
80106ff3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106ff9:	68 00 10 00 00       	push   $0x1000
80106ffe:	53                   	push   %ebx
80106fff:	50                   	push   %eax
80107000:	e8 0b d7 ff ff       	call   80104710 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107005:	58                   	pop    %eax
80107006:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010700c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107011:	5a                   	pop    %edx
80107012:	ff 75 e4             	pushl  -0x1c(%ebp)
80107015:	50                   	push   %eax
80107016:	89 fa                	mov    %edi,%edx
80107018:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010701b:	e8 c0 f8 ff ff       	call   801068e0 <mappages>
80107020:	83 c4 10             	add    $0x10,%esp
80107023:	85 c0                	test   %eax,%eax
80107025:	78 61                	js     80107088 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107027:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010702d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107030:	76 46                	jbe    80107078 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107032:	8b 45 08             	mov    0x8(%ebp),%eax
80107035:	31 c9                	xor    %ecx,%ecx
80107037:	89 fa                	mov    %edi,%edx
80107039:	e8 22 f8 ff ff       	call   80106860 <walkpgdir>
8010703e:	85 c0                	test   %eax,%eax
80107040:	74 61                	je     801070a3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107042:	8b 00                	mov    (%eax),%eax
80107044:	a8 01                	test   $0x1,%al
80107046:	74 4e                	je     80107096 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107048:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010704a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010704f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107055:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107058:	e8 a3 b4 ff ff       	call   80102500 <kalloc>
8010705d:	85 c0                	test   %eax,%eax
8010705f:	89 c6                	mov    %eax,%esi
80107061:	75 8d                	jne    80106ff0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107063:	83 ec 0c             	sub    $0xc,%esp
80107066:	ff 75 e0             	pushl  -0x20(%ebp)
80107069:	e8 02 fe ff ff       	call   80106e70 <freevm>
  return 0;
8010706e:	83 c4 10             	add    $0x10,%esp
80107071:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107078:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010707b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010707e:	5b                   	pop    %ebx
8010707f:	5e                   	pop    %esi
80107080:	5f                   	pop    %edi
80107081:	5d                   	pop    %ebp
80107082:	c3                   	ret    
80107083:	90                   	nop
80107084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107088:	83 ec 0c             	sub    $0xc,%esp
8010708b:	56                   	push   %esi
8010708c:	e8 bf b2 ff ff       	call   80102350 <kfree>
      goto bad;
80107091:	83 c4 10             	add    $0x10,%esp
80107094:	eb cd                	jmp    80107063 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	68 a6 7b 10 80       	push   $0x80107ba6
8010709e:	e8 ed 92 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801070a3:	83 ec 0c             	sub    $0xc,%esp
801070a6:	68 8c 7b 10 80       	push   $0x80107b8c
801070ab:	e8 e0 92 ff ff       	call   80100390 <panic>

801070b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070b1:	31 c9                	xor    %ecx,%ecx
{
801070b3:	89 e5                	mov    %esp,%ebp
801070b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070bb:	8b 45 08             	mov    0x8(%ebp),%eax
801070be:	e8 9d f7 ff ff       	call   80106860 <walkpgdir>
  if((*pte & PTE_P) == 0)
801070c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070c5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801070c6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801070cd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070d0:	05 00 00 00 80       	add    $0x80000000,%eax
801070d5:	83 fa 05             	cmp    $0x5,%edx
801070d8:	ba 00 00 00 00       	mov    $0x0,%edx
801070dd:	0f 45 c2             	cmovne %edx,%eax
}
801070e0:	c3                   	ret    
801070e1:	eb 0d                	jmp    801070f0 <copyout>
801070e3:	90                   	nop
801070e4:	90                   	nop
801070e5:	90                   	nop
801070e6:	90                   	nop
801070e7:	90                   	nop
801070e8:	90                   	nop
801070e9:	90                   	nop
801070ea:	90                   	nop
801070eb:	90                   	nop
801070ec:	90                   	nop
801070ed:	90                   	nop
801070ee:	90                   	nop
801070ef:	90                   	nop

801070f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 1c             	sub    $0x1c,%esp
801070f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107102:	85 db                	test   %ebx,%ebx
80107104:	75 40                	jne    80107146 <copyout+0x56>
80107106:	eb 70                	jmp    80107178 <copyout+0x88>
80107108:	90                   	nop
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107110:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107113:	89 f1                	mov    %esi,%ecx
80107115:	29 d1                	sub    %edx,%ecx
80107117:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010711d:	39 d9                	cmp    %ebx,%ecx
8010711f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107122:	29 f2                	sub    %esi,%edx
80107124:	83 ec 04             	sub    $0x4,%esp
80107127:	01 d0                	add    %edx,%eax
80107129:	51                   	push   %ecx
8010712a:	57                   	push   %edi
8010712b:	50                   	push   %eax
8010712c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010712f:	e8 dc d5 ff ff       	call   80104710 <memmove>
    len -= n;
    buf += n;
80107134:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107137:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010713a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107140:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107142:	29 cb                	sub    %ecx,%ebx
80107144:	74 32                	je     80107178 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107146:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107148:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010714b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010714e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107154:	56                   	push   %esi
80107155:	ff 75 08             	pushl  0x8(%ebp)
80107158:	e8 53 ff ff ff       	call   801070b0 <uva2ka>
    if(pa0 == 0)
8010715d:	83 c4 10             	add    $0x10,%esp
80107160:	85 c0                	test   %eax,%eax
80107162:	75 ac                	jne    80107110 <copyout+0x20>
  }
  return 0;
}
80107164:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010716c:	5b                   	pop    %ebx
8010716d:	5e                   	pop    %esi
8010716e:	5f                   	pop    %edi
8010716f:	5d                   	pop    %ebp
80107170:	c3                   	ret    
80107171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010717b:	31 c0                	xor    %eax,%eax
}
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
80107181:	c3                   	ret    

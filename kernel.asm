
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp
8010002d:	b8 d0 2e 10 80       	mov    $0x80102ed0,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 7a 10 80       	push   $0x80107aa0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 f5 4c 00 00       	call   80104d50 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7a 10 80       	push   $0x80107aa7
80100097:	50                   	push   %eax
80100098:	e8 83 4b 00 00       	call   80104c20 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 a7 4d 00 00       	call   80104e90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 e9 4d 00 00       	call   80104f50 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 4a 00 00       	call   80104c60 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
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
80100193:	68 ae 7a 10 80       	push   $0x80107aae
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
801001ae:	e8 4d 4b 00 00       	call   80104d00 <holdingsleep>
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
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 7a 10 80       	push   $0x80107abf
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
801001ef:	e8 0c 4b 00 00       	call   80104d00 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 4a 00 00       	call   80104cc0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 80 4c 00 00       	call   80104e90 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ef 4c 00 00       	jmp    80104f50 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 7a 10 80       	push   $0x80107ac6
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
80100280:	e8 0b 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 ff 4b 00 00       	call   80104e90 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
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
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 b6 40 00 00       	call   80104380 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 a0 36 00 00       	call   80103980 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 5c 4c 00 00       	call   80104f50 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 13 00 00       	call   801016b0 <ilock>
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
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
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
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 fe 4b 00 00       	call   80104f50 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 13 00 00       	call   801016b0 <ilock>
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
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 23 00 00       	call   80102760 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 7a 10 80       	push   $0x80107acd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 e7 85 10 80 	movl   $0x801085e7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 49 00 00       	call   80104d70 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 7a 10 80       	push   $0x80107ae1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010043a:	e8 71 62 00 00       	call   801066b0 <uartputc>
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
801004ec:	e8 bf 61 00 00       	call   801066b0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 61 00 00       	call   801066b0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 61 00 00       	call   801066b0 <uartputc>
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
80100524:	e8 27 4b 00 00       	call   80105050 <memmove>
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
80100541:	e8 5a 4a 00 00       	call   80104fa0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 7a 10 80       	push   $0x80107ae5
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
801005b1:	0f b6 92 10 7b 10 80 	movzbl -0x7fef84f0(%edx),%edx
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
8010060f:	e8 7c 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 70 48 00 00       	call   80104e90 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 04 49 00 00       	call   80104f50 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 2c 48 00 00       	call   80104f50 <release>
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
801007d0:	ba f8 7a 10 80       	mov    $0x80107af8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 9b 46 00 00       	call   80104e90 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 7a 10 80       	push   $0x80107aff
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
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 68 46 00 00       	call   80104e90 <acquire>
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
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 c3 46 00 00       	call   80104f50 <release>
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
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 25 3c 00 00       	call   80104540 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
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
80100997:	e9 84 3c 00 00       	jmp    80104620 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
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
801009c6:	68 08 7b 10 80       	push   $0x80107b08
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 7b 43 00 00       	call   80104d50 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 02 19 00 00       	call   80102300 <ioapicenable>
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
80100a1c:	e8 5f 2f 00 00       	call   80103980 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 a4 21 00 00       	call   80102bd0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 d9 14 00 00       	call   80101f10 <namei>
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
80100a48:	e8 63 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 32 0f 00 00       	call   80101990 <readi>
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
80100a6a:	e8 d1 0e 00 00       	call   80101940 <iunlockput>
    end_op();
80100a6f:	e8 cc 21 00 00       	call   80102c40 <end_op>
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
80100a94:	e8 67 6d 00 00       	call   80107800 <setupkvm>
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
80100ab9:	0f 84 bc 02 00 00    	je     80100d7b <exec+0x36b>
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
80100af6:	e8 25 6b 00 00       	call   80107620 <allocuvm>
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
80100b28:	e8 33 6a 00 00       	call   80107560 <loaduvm>
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
80100b58:	e8 33 0e 00 00       	call   80101990 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 09 6c 00 00       	call   80107780 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 a6 0d 00 00       	call   80101940 <iunlockput>
  end_op();
80100b9a:	e8 a1 20 00 00       	call   80102c40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 71 6a 00 00       	call   80107620 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 6b 00 00       	call   80107780 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 68 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 7b 10 80       	push   $0x80107b21
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
80100c06:	e8 95 6c 00 00       	call   801078a0 <clearpteu>
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
80100c39:	e8 82 45 00 00       	call   801051c0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 6f 45 00 00       	call   801051c0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 6d 00 00       	call   80107a00 <copyout>
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
80100cc7:	e8 34 6d 00 00       	call   80107a00 <copyout>
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
80100d0a:	e8 71 44 00 00       	call   80105180 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->ticks = ticks;
80100d31:	a1 c0 64 11 80       	mov    0x801164c0,%eax
  curproc->queueNum = 0;
80100d36:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
80100d3d:	00 00 00 
  curproc->cycleNum = 1;
80100d40:	c7 81 84 00 00 00 01 	movl   $0x1,0x84(%ecx)
80100d47:	00 00 00 
  curproc->ticket = 100000;
80100d4a:	c7 41 7c a0 86 01 00 	movl   $0x186a0,0x7c(%ecx)
  curproc->remainingPriority = 10;
80100d51:	c7 81 8c 00 00 00 00 	movl   $0x41200000,0x8c(%ecx)
80100d58:	00 20 41 
  curproc->ticks = ticks;
80100d5b:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
  switchuvm(curproc);
80100d61:	89 0c 24             	mov    %ecx,(%esp)
80100d64:	e8 67 66 00 00       	call   801073d0 <switchuvm>
  freevm(oldpgdir);
80100d69:	89 3c 24             	mov    %edi,(%esp)
80100d6c:	e8 0f 6a 00 00       	call   80107780 <freevm>
  return 0;
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	31 c0                	xor    %eax,%eax
80100d76:	e9 01 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d7b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d80:	e9 0c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d85:	66 90                	xchg   %ax,%ax
80100d87:	66 90                	xchg   %ax,%ax
80100d89:	66 90                	xchg   %ax,%ax
80100d8b:	66 90                	xchg   %ax,%ax
80100d8d:	66 90                	xchg   %ax,%ax
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 2d 7b 10 80       	push   $0x80107b2d
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 ab 3f 00 00       	call   80104d50 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 ca 40 00 00       	call   80104e90 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 c0 0f 11 80       	push   $0x80110fc0
80100df1:	e8 5a 41 00 00       	call   80104f50 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0a:	e8 41 41 00 00       	call   80104f50 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2f:	e8 5c 40 00 00       	call   80104e90 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 c0 0f 11 80       	push   $0x80110fc0
80100e4c:	e8 ff 40 00 00       	call   80104f50 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 34 7b 10 80       	push   $0x80107b34
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e81:	e8 0a 40 00 00       	call   80104e90 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 9f 40 00 00       	jmp    80104f50 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 73 40 00 00       	call   80104f50 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 6a 24 00 00       	call   80103370 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 bb 1c 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 c0 08 00 00       	call   801017e0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 11 1d 00 00       	jmp    80102c40 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 3c 7b 10 80       	push   $0x80107b3c
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 56 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 f9 09 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 20 08 00 00       	call   80101790 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 f1 06 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 c4 09 00 00       	call   80101990 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 ad 07 00 00       	call   80101790 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 1e 25 00 00       	jmp    80103520 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 46 7b 10 80       	push   $0x80107b46
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 17 07 00 00       	call   80101790 <iunlock>
      end_op();
80101079:	e8 c2 1b 00 00       	call   80102c40 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 25 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 fa 05 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 c8 09 00 00       	call   80101a90 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 b3 06 00 00       	call   80101790 <iunlock>
      end_op();
801010dd:	e8 5e 1b 00 00       	call   80102c40 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 ee 22 00 00       	jmp    80103410 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 4f 7b 10 80       	push   $0x80107b4f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 55 7b 10 80       	push   $0x80107b55
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	56                   	push   %esi
80101144:	53                   	push   %ebx
80101145:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101147:	c1 ea 0c             	shr    $0xc,%edx
8010114a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101150:	83 ec 08             	sub    $0x8,%esp
80101153:	52                   	push   %edx
80101154:	50                   	push   %eax
80101155:	e8 76 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010115a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010115c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010115f:	ba 01 00 00 00       	mov    $0x1,%edx
80101164:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101167:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010116d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101170:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101172:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101177:	85 d1                	test   %edx,%ecx
80101179:	74 25                	je     801011a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010117b:	f7 d2                	not    %edx
8010117d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101182:	21 ca                	and    %ecx,%edx
80101184:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101188:	56                   	push   %esi
80101189:	e8 12 1c 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010118e:	89 34 24             	mov    %esi,(%esp)
80101191:	e8 4a f0 ff ff       	call   801001e0 <brelse>
}
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010119c:	5b                   	pop    %ebx
8010119d:	5e                   	pop    %esi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    panic("freeing free block");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 5f 7b 10 80       	push   $0x80107b5f
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi

801011b0 <balloc>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ee:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101205:	bb 01 00 00 00       	mov    $0x1,%ebx
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	85 df                	test   %ebx,%edi
8010121b:	89 fa                	mov    %edi,%edx
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 a4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 72 7b 10 80       	push   $0x80107b72
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 2e 1b 00 00       	call   80102da0 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101287:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128a:	83 c4 0c             	add    $0xc,%esp
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 06 3d 00 00       	call   80104fa0 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 fe 1a 00 00       	call   80102da0 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 36 ef ff ff       	call   801001e0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 19 11 80       	push   $0x801119e0
801012da:	e8 b1 3b 00 00       	call   80104e90 <acquire>
801012df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e5:	eb 17                	jmp    801012fe <iget+0x3e>
801012e7:	89 f6                	mov    %esi,%esi
801012e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012fc:	73 22                	jae    80101320 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101301:	85 c9                	test   %ecx,%ecx
80101303:	7e 04                	jle    80101309 <iget+0x49>
80101305:	39 3b                	cmp    %edi,(%ebx)
80101307:	74 4f                	je     80101358 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e3                	jne    801012f0 <iget+0x30>
8010130d:	85 c9                	test   %ecx,%ecx
8010130f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101318:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010131e:	72 de                	jb     801012fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 5b                	je     8010137f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101324:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101327:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101329:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010132c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101333:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010133a:	68 e0 19 11 80       	push   $0x801119e0
8010133f:	e8 0c 3c 00 00       	call   80104f50 <release>

  return ip;
80101344:	83 c4 10             	add    $0x10,%esp
}
80101347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134a:	89 f0                	mov    %esi,%eax
8010134c:	5b                   	pop    %ebx
8010134d:	5e                   	pop    %esi
8010134e:	5f                   	pop    %edi
8010134f:	5d                   	pop    %ebp
80101350:	c3                   	ret    
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101358:	39 53 04             	cmp    %edx,0x4(%ebx)
8010135b:	75 ac                	jne    80101309 <iget+0x49>
      release(&icache.lock);
8010135d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101360:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101363:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010136a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010136d:	e8 de 3b 00 00       	call   80104f50 <release>
      return ip;
80101372:	83 c4 10             	add    $0x10,%esp
}
80101375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101378:	89 f0                	mov    %esi,%eax
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
    panic("iget: no inodes");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 88 7b 10 80       	push   $0x80107b88
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	89 c6                	mov    %eax,%esi
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	77 18                	ja     801013b8 <bmap+0x28>
801013a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013a6:	85 db                	test   %ebx,%ebx
801013a8:	74 76                	je     80101420 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 d8                	mov    %ebx,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013bb:	83 fb 7f             	cmp    $0x7f,%ebx
801013be:	0f 87 90 00 00 00    	ja     80101454 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013ca:	8b 00                	mov    (%eax),%eax
801013cc:	85 d2                	test   %edx,%edx
801013ce:	74 70                	je     80101440 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013d0:	83 ec 08             	sub    $0x8,%esp
801013d3:	52                   	push   %edx
801013d4:	50                   	push   %eax
801013d5:	e8 f6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013e3:	8b 1a                	mov    (%edx),%ebx
801013e5:	85 db                	test   %ebx,%ebx
801013e7:	75 1d                	jne    80101406 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013e9:	8b 06                	mov    (%esi),%eax
801013eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ee:	e8 bd fd ff ff       	call   801011b0 <balloc>
801013f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013f9:	89 c3                	mov    %eax,%ebx
801013fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013fd:	57                   	push   %edi
801013fe:	e8 9d 19 00 00       	call   80102da0 <log_write>
80101403:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	57                   	push   %edi
8010140a:	e8 d1 ed ff ff       	call   801001e0 <brelse>
8010140f:	83 c4 10             	add    $0x10,%esp
}
80101412:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101415:	89 d8                	mov    %ebx,%eax
80101417:	5b                   	pop    %ebx
80101418:	5e                   	pop    %esi
80101419:	5f                   	pop    %edi
8010141a:	5d                   	pop    %ebp
8010141b:	c3                   	ret    
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101420:	8b 00                	mov    (%eax),%eax
80101422:	e8 89 fd ff ff       	call   801011b0 <balloc>
80101427:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010142d:	89 c3                	mov    %eax,%ebx
}
8010142f:	89 d8                	mov    %ebx,%eax
80101431:	5b                   	pop    %ebx
80101432:	5e                   	pop    %esi
80101433:	5f                   	pop    %edi
80101434:	5d                   	pop    %ebp
80101435:	c3                   	ret    
80101436:	8d 76 00             	lea    0x0(%esi),%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101440:	e8 6b fd ff ff       	call   801011b0 <balloc>
80101445:	89 c2                	mov    %eax,%edx
80101447:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010144d:	8b 06                	mov    (%esi),%eax
8010144f:	e9 7c ff ff ff       	jmp    801013d0 <bmap+0x40>
  panic("bmap: out of range");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 98 7b 10 80       	push   $0x80107b98
8010145c:	e8 2f ef ff ff       	call   80100390 <panic>
80101461:	eb 0d                	jmp    80101470 <readsb>
80101463:	90                   	nop
80101464:	90                   	nop
80101465:	90                   	nop
80101466:	90                   	nop
80101467:	90                   	nop
80101468:	90                   	nop
80101469:	90                   	nop
8010146a:	90                   	nop
8010146b:	90                   	nop
8010146c:	90                   	nop
8010146d:	90                   	nop
8010146e:	90                   	nop
8010146f:	90                   	nop

80101470 <readsb>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	6a 01                	push   $0x1
8010147d:	ff 75 08             	pushl  0x8(%ebp)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
80101485:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101487:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148a:	83 c4 0c             	add    $0xc,%esp
8010148d:	6a 1c                	push   $0x1c
8010148f:	50                   	push   %eax
80101490:	56                   	push   %esi
80101491:	e8 ba 3b 00 00       	call   80105050 <memmove>
  brelse(bp);
80101496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101499:	83 c4 10             	add    $0x10,%esp
}
8010149c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5d                   	pop    %ebp
  brelse(bp);
801014a2:	e9 39 ed ff ff       	jmp    801001e0 <brelse>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 ab 7b 10 80       	push   $0x80107bab
801014c1:	68 e0 19 11 80       	push   $0x801119e0
801014c6:	e8 85 38 00 00       	call   80104d50 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 b2 7b 10 80       	push   $0x80107bb2
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 3c 37 00 00       	call   80104c20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 c0 19 11 80       	push   $0x801119c0
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 71 ff ff ff       	call   80101470 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101505:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010150b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101511:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101517:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010151d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101523:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101529:	68 18 7c 10 80       	push   $0x80107c18
8010152e:	e8 2d f1 ff ff       	call   80100660 <cprintf>
}
80101533:	83 c4 30             	add    $0x30,%esp
80101536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101539:	c9                   	leave  
8010153a:	c3                   	ret    
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101550:	8b 45 0c             	mov    0xc(%ebp),%eax
80101553:	8b 75 08             	mov    0x8(%ebp),%esi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 91 00 00 00    	jbe    801015f0 <ialloc+0xb0>
8010155f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101564:	eb 21                	jmp    80101587 <ialloc+0x47>
80101566:	8d 76 00             	lea    0x0(%esi),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	57                   	push   %edi
80101577:	e8 64 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101595:	50                   	push   %eax
80101596:	56                   	push   %esi
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015a3:	83 e0 07             	and    $0x7,%eax
801015a6:	c1 e0 06             	shl    $0x6,%eax
801015a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 dd 39 00 00       	call   80104fa0 <memset>
      dip->type = type;
801015c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015cd:	89 3c 24             	mov    %edi,(%esp)
801015d0:	e8 cb 17 00 00       	call   80102da0 <log_write>
      brelse(bp);
801015d5:	89 3c 24             	mov    %edi,(%esp)
801015d8:	e8 03 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015e3:	89 da                	mov    %ebx,%edx
801015e5:	89 f0                	mov    %esi,%eax
}
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5f                   	pop    %edi
801015ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801015eb:	e9 d0 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	68 b8 7b 10 80       	push   $0x80107bb8
801015f8:	e8 93 ed ff ff       	call   80100390 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101639:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101640:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101643:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101647:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010164b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010164f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101653:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101657:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010165a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165d:	6a 34                	push   $0x34
8010165f:	53                   	push   %ebx
80101660:	50                   	push   %eax
80101661:	e8 ea 39 00 00       	call   80105050 <memmove>
  log_write(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 32 17 00 00       	call   80102da0 <log_write>
  brelse(bp);
8010166e:	89 75 08             	mov    %esi,0x8(%ebp)
80101671:	83 c4 10             	add    $0x10,%esp
}
80101674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5d                   	pop    %ebp
  brelse(bp);
8010167a:	e9 61 eb ff ff       	jmp    801001e0 <brelse>
8010167f:	90                   	nop

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 e0 19 11 80       	push   $0x801119e0
8010168f:	e8 fc 37 00 00       	call   80104e90 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010169f:	e8 ac 38 00 00       	call   80104f50 <release>
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 b7 00 00 00    	je     80101777 <ilock+0xc7>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e ac 00 00 00    	jle    80101777 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 89 35 00 00       	call   80104c60 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 03 39 00 00       	call   80105050 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 d0 7b 10 80       	push   $0x80107bd0
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 ca 7b 10 80       	push   $0x80107bca
8010177f:	e8 0c ec ff ff       	call   80100390 <panic>
80101784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010178a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	74 28                	je     801017c4 <iunlock+0x34>
8010179c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	56                   	push   %esi
801017a3:	e8 58 35 00 00       	call   80104d00 <holdingsleep>
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 c0                	test   %eax,%eax
801017ad:	74 15                	je     801017c4 <iunlock+0x34>
801017af:	8b 43 08             	mov    0x8(%ebx),%eax
801017b2:	85 c0                	test   %eax,%eax
801017b4:	7e 0e                	jle    801017c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017bf:	e9 fc 34 00 00       	jmp    80104cc0 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 df 7b 10 80       	push   $0x80107bdf
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <iput>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 28             	sub    $0x28,%esp
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ef:	57                   	push   %edi
801017f0:	e8 6b 34 00 00       	call   80104c60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 b1 34 00 00       	call   80104cc0 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101816:	e8 75 36 00 00       	call   80104e90 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 1b 37 00 00       	jmp    80104f50 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 e0 19 11 80       	push   $0x801119e0
80101840:	e8 4b 36 00 00       	call   80104e90 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010184f:	e8 fc 36 00 00       	call   80104f50 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x97>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fe                	cmp    %edi,%esi
80101875:	74 19                	je     80101890 <iput+0xb0>
    if(ip->addrs[i]){
80101877:	8b 16                	mov    (%esi),%edx
80101879:	85 d2                	test   %edx,%edx
8010187b:	74 f3                	je     80101870 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010187d:	8b 03                	mov    (%ebx),%eax
8010187f:	e8 bc f8 ff ff       	call   80101140 <bfree>
      ip->addrs[i] = 0;
80101884:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010188a:	eb e4                	jmp    80101870 <iput+0x90>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 33                	jne    801018d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	89 cf                	mov    %ecx,%edi
801018ef:	eb 0e                	jmp    801018ff <iput+0x11f>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018fb:	39 fe                	cmp    %edi,%esi
801018fd:	74 0f                	je     8010190e <iput+0x12e>
      if(a[j])
801018ff:	8b 16                	mov    (%esi),%edx
80101901:	85 d2                	test   %edx,%edx
80101903:	74 f3                	je     801018f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101905:	8b 03                	mov    (%ebx),%eax
80101907:	e8 34 f8 ff ff       	call   80101140 <bfree>
8010190c:	eb ea                	jmp    801018f8 <iput+0x118>
    brelse(bp);
8010190e:	83 ec 0c             	sub    $0xc,%esp
80101911:	ff 75 e4             	pushl  -0x1c(%ebp)
80101914:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101917:	e8 c4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010191c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 17 f8 ff ff       	call   80101140 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101930:	00 00 00 
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	e9 62 ff ff ff       	jmp    8010189d <iput+0xbd>
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 10             	sub    $0x10,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	53                   	push   %ebx
8010194b:	e8 40 fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101950:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
}
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
  iput(ip);
8010195a:	e9 81 fe ff ff       	jmp    801017e0 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 1c             	sub    $0x1c,%esp
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010199f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019a7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ad:	8b 75 10             	mov    0x10(%ebp),%esi
801019b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b3:	0f 84 a7 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019bc:	8b 40 58             	mov    0x58(%eax),%eax
801019bf:	39 c6                	cmp    %eax,%esi
801019c1:	0f 87 ba 00 00 00    	ja     80101a81 <readi+0xf1>
801019c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ca:	89 f9                	mov    %edi,%ecx
801019cc:	01 f1                	add    %esi,%ecx
801019ce:	0f 82 ad 00 00 00    	jb     80101a81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d4:	89 c2                	mov    %eax,%edx
801019d6:	29 f2                	sub    %esi,%edx
801019d8:	39 c8                	cmp    %ecx,%eax
801019da:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019dd:	31 ff                	xor    %edi,%edi
801019df:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e4:	74 6c                	je     80101a52 <readi+0xc2>
801019e6:	8d 76 00             	lea    0x0(%esi),%esi
801019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019f3:	89 f2                	mov    %esi,%edx
801019f5:	c1 ea 09             	shr    $0x9,%edx
801019f8:	89 d8                	mov    %ebx,%eax
801019fa:	e8 91 f9 ff ff       	call   80101390 <bmap>
801019ff:	83 ec 08             	sub    $0x8,%esp
80101a02:	50                   	push   %eax
80101a03:	ff 33                	pushl  (%ebx)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0f:	89 f0                	mov    %esi,%eax
80101a11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a1b:	83 c4 0c             	add    $0xc,%esp
80101a1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	29 fb                	sub    %edi,%ebx
80101a29:	39 d9                	cmp    %ebx,%ecx
80101a2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2e:	53                   	push   %ebx
80101a2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a37:	e8 14 36 00 00       	call   80105050 <memmove>
    brelse(bp);
80101a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a3f:	89 14 24             	mov    %edx,(%esp)
80101a42:	e8 99 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a50:	77 9e                	ja     801019f0 <readi+0x60>
  }
  return n;
80101a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5f                   	pop    %edi
80101a5b:	5d                   	pop    %ebp
80101a5c:	c3                   	ret    
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 0c                	je     80101a81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a7f:	ff e0                	jmp    *%eax
      return -1;
80101a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a86:	eb cd                	jmp    80101a55 <readi+0xc5>
80101a88:	90                   	nop
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 eb 00 00 00    	jb     80101bb0 <writei+0x120>
80101ac5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ac8:	31 d2                	xor    %edx,%edx
80101aca:	89 f8                	mov    %edi,%eax
80101acc:	01 f0                	add    %esi,%eax
80101ace:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad6:	0f 87 d4 00 00 00    	ja     80101bb0 <writei+0x120>
80101adc:	85 d2                	test   %edx,%edx
80101ade:	0f 85 cc 00 00 00    	jne    80101bb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae4:	85 ff                	test   %edi,%edi
80101ae6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aed:	74 72                	je     80101b61 <writei+0xd1>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 f8                	mov    %edi,%eax
80101afa:	e8 91 f8 ff ff       	call   80101390 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 37                	pushl  (%edi)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b12:	89 f0                	mov    %esi,%eax
80101b14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b19:	83 c4 0c             	add    $0xc,%esp
80101b1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	39 d9                	cmp    %ebx,%ecx
80101b29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b2c:	53                   	push   %ebx
80101b2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b32:	50                   	push   %eax
80101b33:	e8 18 35 00 00       	call   80105050 <memmove>
    log_write(bp);
80101b38:	89 3c 24             	mov    %edi,(%esp)
80101b3b:	e8 60 12 00 00       	call   80102da0 <log_write>
    brelse(bp);
80101b40:	89 3c 24             	mov    %edi,(%esp)
80101b43:	e8 98 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b57:	77 97                	ja     80101af0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b5f:	77 37                	ja     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b67:	5b                   	pop    %ebx
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 2b                	je     80101bb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ba1:	50                   	push   %eax
80101ba2:	e8 59 fa ff ff       	call   80101600 <iupdate>
80101ba7:	83 c4 10             	add    $0x10,%esp
80101baa:	eb b5                	jmp    80101b61 <writei+0xd1>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb5:	eb ad                	jmp    80101b64 <writei+0xd4>
80101bb7:	89 f6                	mov    %esi,%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	6a 0e                	push   $0xe
80101bc8:	ff 75 0c             	pushl  0xc(%ebp)
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 ed 34 00 00       	call   801050c0 <strncmp>
}
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 3e                	je     80101c41 <dirlookup+0x61>
80101c03:	90                   	nop
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c08:	6a 10                	push   $0x10
80101c0a:	57                   	push   %edi
80101c0b:	56                   	push   %esi
80101c0c:	53                   	push   %ebx
80101c0d:	e8 7e fd ff ff       	call   80101990 <readi>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	83 f8 10             	cmp    $0x10,%eax
80101c18:	75 55                	jne    80101c6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c1f:	74 18                	je     80101c39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c24:	83 ec 04             	sub    $0x4,%esp
80101c27:	6a 0e                	push   $0xe
80101c29:	50                   	push   %eax
80101c2a:	ff 75 0c             	pushl  0xc(%ebp)
80101c2d:	e8 8e 34 00 00       	call   801050c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c3f:	72 c7                	jb     80101c08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c44:	31 c0                	xor    %eax,%eax
}
80101c46:	5b                   	pop    %ebx
80101c47:	5e                   	pop    %esi
80101c48:	5f                   	pop    %edi
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c50:	8b 45 10             	mov    0x10(%ebp),%eax
80101c53:	85 c0                	test   %eax,%eax
80101c55:	74 05                	je     80101c5c <dirlookup+0x7c>
        *poff = off;
80101c57:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c60:	8b 03                	mov    (%ebx),%eax
80101c62:	e8 59 f6 ff ff       	call   801012c0 <iget>
}
80101c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6a:	5b                   	pop    %ebx
80101c6b:	5e                   	pop    %esi
80101c6c:	5f                   	pop    %edi
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
      panic("dirlookup read");
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	68 f9 7b 10 80       	push   $0x80107bf9
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 e7 7b 10 80       	push   $0x80107be7
80101c84:	e8 07 e7 ff ff       	call   80100390 <panic>
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	89 cf                	mov    %ecx,%edi
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 67 01 00 00    	je     80101e10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 d2 1c 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 e0 19 11 80       	push   $0x801119e0
80101cb9:	e8 d2 31 00 00       	call   80104e90 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cc9:	e8 82 32 00 00       	call   80104f50 <release>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	eb 08                	jmp    80101cdb <namex+0x4b>
80101cd3:	90                   	nop
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cdb:	0f b6 03             	movzbl (%ebx),%eax
80101cde:	3c 2f                	cmp    $0x2f,%al
80101ce0:	74 f6                	je     80101cd8 <namex+0x48>
  if(*path == 0)
80101ce2:	84 c0                	test   %al,%al
80101ce4:	0f 84 ee 00 00 00    	je     80101dd8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cea:	0f b6 03             	movzbl (%ebx),%eax
80101ced:	3c 2f                	cmp    $0x2f,%al
80101cef:	0f 84 b3 00 00 00    	je     80101da8 <namex+0x118>
80101cf5:	84 c0                	test   %al,%al
80101cf7:	89 da                	mov    %ebx,%edx
80101cf9:	75 09                	jne    80101d04 <namex+0x74>
80101cfb:	e9 a8 00 00 00       	jmp    80101da8 <namex+0x118>
80101d00:	84 c0                	test   %al,%al
80101d02:	74 0a                	je     80101d0e <namex+0x7e>
    path++;
80101d04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d07:	0f b6 02             	movzbl (%edx),%eax
80101d0a:	3c 2f                	cmp    $0x2f,%al
80101d0c:	75 f2                	jne    80101d00 <namex+0x70>
80101d0e:	89 d1                	mov    %edx,%ecx
80101d10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d12:	83 f9 0d             	cmp    $0xd,%ecx
80101d15:	0f 8e 91 00 00 00    	jle    80101dac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d1b:	83 ec 04             	sub    $0x4,%esp
80101d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d21:	6a 0e                	push   $0xe
80101d23:	53                   	push   %ebx
80101d24:	57                   	push   %edi
80101d25:	e8 26 33 00 00       	call   80105050 <memmove>
    path++;
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d35:	75 11                	jne    80101d48 <namex+0xb8>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	56                   	push   %esi
80101d4c:	e8 5f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d59:	0f 85 91 00 00 00    	jne    80101df0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d62:	85 d2                	test   %edx,%edx
80101d64:	74 09                	je     80101d6f <namex+0xdf>
80101d66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d69:	0f 84 b7 00 00 00    	je     80101e26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6f:	83 ec 04             	sub    $0x4,%esp
80101d72:	6a 00                	push   $0x0
80101d74:	57                   	push   %edi
80101d75:	56                   	push   %esi
80101d76:	e8 65 fe ff ff       	call   80101be0 <dirlookup>
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	74 6e                	je     80101df0 <namex+0x160>
  iunlock(ip);
80101d82:	83 ec 0c             	sub    $0xc,%esp
80101d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d88:	56                   	push   %esi
80101d89:	e8 02 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	83 c4 10             	add    $0x10,%esp
80101d9c:	89 c6                	mov    %eax,%esi
80101d9e:	e9 38 ff ff ff       	jmp    80101cdb <namex+0x4b>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101da8:	89 da                	mov    %ebx,%edx
80101daa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dac:	83 ec 04             	sub    $0x4,%esp
80101daf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db5:	51                   	push   %ecx
80101db6:	53                   	push   %ebx
80101db7:	57                   	push   %edi
80101db8:	e8 93 32 00 00       	call   80105050 <memmove>
    name[len] = 0;
80101dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dca:	89 d3                	mov    %edx,%ebx
80101dcc:	e9 61 ff ff ff       	jmp    80101d32 <namex+0xa2>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 5d                	jne    80101e3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de2:	89 f0                	mov    %esi,%eax
80101de4:	5b                   	pop    %ebx
80101de5:	5e                   	pop    %esi
80101de6:	5f                   	pop    %edi
80101de7:	5d                   	pop    %ebp
80101de8:	c3                   	ret    
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 97 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101df9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dfc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dfe:	e8 dd f9 ff ff       	call   801017e0 <iput>
      return 0;
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	89 f0                	mov    %esi,%eax
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e10:	ba 01 00 00 00       	mov    $0x1,%edx
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 a1 f4 ff ff       	call   801012c0 <iget>
80101e1f:	89 c6                	mov    %eax,%esi
80101e21:	e9 b5 fe ff ff       	jmp    80101cdb <namex+0x4b>
      iunlock(ip);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	56                   	push   %esi
80101e2a:	e8 61 f9 ff ff       	call   80101790 <iunlock>
      return ip;
80101e2f:	83 c4 10             	add    $0x10,%esp
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e35:	89 f0                	mov    %esi,%eax
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
    iput(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	56                   	push   %esi
    return 0;
80101e40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e42:	e8 99 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb 93                	jmp    80101ddf <namex+0x14f>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 20             	sub    $0x20,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	6a 00                	push   $0x0
80101e5e:	ff 75 0c             	pushl  0xc(%ebp)
80101e61:	53                   	push   %ebx
80101e62:	e8 79 fd ff ff       	call   80101be0 <dirlookup>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	75 67                	jne    80101ed5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e86:	73 19                	jae    80101ea1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e88:	6a 10                	push   $0x10
80101e8a:	57                   	push   %edi
80101e8b:	56                   	push   %esi
80101e8c:	53                   	push   %ebx
80101e8d:	e8 fe fa ff ff       	call   80101990 <readi>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	83 f8 10             	cmp    $0x10,%eax
80101e98:	75 4e                	jne    80101ee8 <dirlink+0x98>
    if(de.inum == 0)
80101e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9f:	75 df                	jne    80101e80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ea1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea4:	83 ec 04             	sub    $0x4,%esp
80101ea7:	6a 0e                	push   $0xe
80101ea9:	ff 75 0c             	pushl  0xc(%ebp)
80101eac:	50                   	push   %eax
80101ead:	e8 6e 32 00 00       	call   80105120 <strncpy>
  de.inum = inum;
80101eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb5:	6a 10                	push   $0x10
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
  de.inum = inum;
80101eba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebe:	e8 cd fb ff ff       	call   80101a90 <writei>
80101ec3:	83 c4 20             	add    $0x20,%esp
80101ec6:	83 f8 10             	cmp    $0x10,%eax
80101ec9:	75 2a                	jne    80101ef5 <dirlink+0xa5>
  return 0;
80101ecb:	31 c0                	xor    %eax,%eax
}
80101ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
    iput(ip);
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	50                   	push   %eax
80101ed9:	e8 02 f9 ff ff       	call   801017e0 <iput>
    return -1;
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee6:	eb e5                	jmp    80101ecd <dirlink+0x7d>
      panic("dirlink read");
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 08 7c 10 80       	push   $0x80107c08
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 ce 83 10 80       	push   $0x801083ce
80101efd:	e8 8e e4 ff ff       	call   80100390 <panic>
80101f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 b4 00 00 00    	je     80102015 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f61:	8b 58 08             	mov    0x8(%eax),%ebx
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f6c:	0f 87 96 00 00 00    	ja     80102008 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f72:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f77:	89 f6                	mov    %esi,%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f80:	89 ca                	mov    %ecx,%edx
80101f82:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f83:	83 e0 c0             	and    $0xffffffc0,%eax
80101f86:	3c 40                	cmp    $0x40,%al
80101f88:	75 f6                	jne    80101f80 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	ee                   	out    %al,(%dx)
80101f94:	b8 01 00 00 00       	mov    $0x1,%eax
80101f99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9e:	ee                   	out    %al,(%dx)
80101f9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fa4:	89 d8                	mov    %ebx,%eax
80101fa6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fae:	c1 f8 08             	sar    $0x8,%eax
80101fb1:	ee                   	out    %al,(%dx)
80101fb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc3:	c1 e0 04             	shl    $0x4,%eax
80101fc6:	83 e0 10             	and    $0x10,%eax
80101fc9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fcc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fcd:	f6 06 04             	testb  $0x4,(%esi)
80101fd0:	75 16                	jne    80101fe8 <idestart+0x98>
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	89 ca                	mov    %ecx,%edx
80101fd9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdd:	5b                   	pop    %ebx
80101fde:	5e                   	pop    %esi
80101fdf:	5f                   	pop    %edi
80101fe0:	5d                   	pop    %ebp
80101fe1:	c3                   	ret    
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fe8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fed:	89 ca                	mov    %ecx,%edx
80101fef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ff5:	83 c6 5c             	add    $0x5c,%esi
80101ff8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ffd:	fc                   	cld    
80101ffe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
    panic("incorrect blockno");
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	68 74 7c 10 80       	push   $0x80107c74
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 6b 7c 10 80       	push   $0x80107c6b
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 86 7c 10 80       	push   $0x80107c86
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 0b 2d 00 00       	call   80104d50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 30 38 11 80       	mov    0x80113830,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 a9 02 00 00       	call   80102300 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102091:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102099:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209e:	ee                   	out    %al,(%dx)
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 80 b5 10 80       	push   $0x8010b580
801020be:	e8 cd 2d 00 00       	call   80104e90 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
801020d3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 3b                	mov    (%ebx),%edi
801020da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020e0:	75 31                	jne    80102113 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c6                	mov    %eax,%esi
801020f3:	83 e6 c0             	and    $0xffffffc0,%esi
801020f6:	89 f1                	mov    %esi,%ecx
801020f8:	80 f9 40             	cmp    $0x40,%cl
801020fb:	75 f3                	jne    801020f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fd:	a8 21                	test   $0x21,%al
801020ff:	75 12                	jne    80102113 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102101:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102104:	b9 80 00 00 00       	mov    $0x80,%ecx
80102109:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210e:	fc                   	cld    
8010210f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102111:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102113:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102116:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102119:	89 f9                	mov    %edi,%ecx
8010211b:	83 c9 02             	or     $0x2,%ecx
8010211e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102120:	53                   	push   %ebx
80102121:	e8 1a 24 00 00       	call   80104540 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102126:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 05                	je     80102137 <ideintr+0x87>
    idestart(idequeue);
80102132:	e8 19 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
80102137:	83 ec 0c             	sub    $0xc,%esp
8010213a:	68 80 b5 10 80       	push   $0x8010b580
8010213f:	e8 0c 2e 00 00       	call   80104f50 <release>

  release(&idelock);
}
80102144:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 9d 2b 00 00       	call   80104d00 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 c6 00 00 00    	je     80102234 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 ab 00 00 00    	je     80102227 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 b1 00 00 00    	je     80102241 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 80 b5 10 80       	push   $0x8010b580
80102198:	e8 f3 2c 00 00       	call   80104e90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021cc:	74 42                	je     80102210 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 80 b5 10 80       	push   $0x8010b580
801021e8:	53                   	push   %ebx
801021e9:	e8 92 21 00 00       	call   80104380 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
  }


  release(&idelock);
801021fb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  release(&idelock);
80102206:	e9 45 2d 00 00       	jmp    80104f50 <release>
8010220b:	90                   	nop
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102210:	89 d8                	mov    %ebx,%eax
80102212:	e8 39 fd ff ff       	call   80101f50 <idestart>
80102217:	eb b5                	jmp    801021ce <iderw+0x7e>
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102220:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102225:	eb 9d                	jmp    801021c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 a0 7c 10 80       	push   $0x80107ca0
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 8a 7c 10 80       	push   $0x80107c8a
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 b5 7c 10 80       	push   $0x80107cb5
80102249:	e8 42 e1 ff ff       	call   80100390 <panic>
8010224e:	66 90                	xchg   %ax,%ax

80102250 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102251:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102258:	00 c0 fe 
{
8010225b:	89 e5                	mov    %esp,%ebp
8010225d:	56                   	push   %esi
8010225e:	53                   	push   %ebx
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	a1 34 36 11 80       	mov    0x80113634,%eax
8010226e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102277:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102284:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102287:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010228a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010228d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102290:	39 c2                	cmp    %eax,%edx
80102292:	74 16                	je     801022aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102294:	83 ec 0c             	sub    $0xc,%esp
80102297:	68 d4 7c 10 80       	push   $0x80107cd4
8010229c:	e8 bf e3 ff ff       	call   80100660 <cprintf>
801022a1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	83 c3 21             	add    $0x21,%ebx
{
801022ad:	ba 10 00 00 00       	mov    $0x10,%edx
801022b2:	b8 20 00 00 00       	mov    $0x20,%eax
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022c2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022c8:	89 c6                	mov    %eax,%esi
801022ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022d3:	89 71 10             	mov    %esi,0x10(%ecx)
801022d6:	8d 72 01             	lea    0x1(%edx),%esi
801022d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022e0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022ed:	75 d1                	jne    801022c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	8d 76 00             	lea    0x0(%esi),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102300:	55                   	push   %ebp
  ioapic->reg = reg;
80102301:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102307:	89 e5                	mov    %esp,%ebp
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010230c:	8d 50 20             	lea    0x20(%eax),%edx
8010230f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102313:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102315:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010231e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102321:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102324:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102326:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010232e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102331:	5d                   	pop    %ebp
80102332:	c3                   	ret    
80102333:	66 90                	xchg   %ax,%ax
80102335:	66 90                	xchg   %ax,%ax
80102337:	66 90                	xchg   %ax,%ax
80102339:	66 90                	xchg   %ax,%ax
8010233b:	66 90                	xchg   %ax,%ax
8010233d:	66 90                	xchg   %ax,%ax
8010233f:	90                   	nop

80102340 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 04             	sub    $0x4,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010234a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102350:	75 70                	jne    801023c2 <kfree+0x82>
80102352:	81 fb c8 64 11 80    	cmp    $0x801164c8,%ebx
80102358:	72 68                	jb     801023c2 <kfree+0x82>
8010235a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102360:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102365:	77 5b                	ja     801023c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102367:	83 ec 04             	sub    $0x4,%esp
8010236a:	68 00 10 00 00       	push   $0x1000
8010236f:	6a 01                	push   $0x1
80102371:	53                   	push   %ebx
80102372:	e8 29 2c 00 00       	call   80104fa0 <memset>

  if(kmem.use_lock)
80102377:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 d2                	test   %edx,%edx
80102382:	75 2c                	jne    801023b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102384:	a1 78 36 11 80       	mov    0x80113678,%eax
80102389:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010238b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102390:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102396:	85 c0                	test   %eax,%eax
80102398:	75 06                	jne    801023a0 <kfree+0x60>
    release(&kmem.lock);
}
8010239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239d:	c9                   	leave  
8010239e:	c3                   	ret    
8010239f:	90                   	nop
    release(&kmem.lock);
801023a0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023aa:	c9                   	leave  
    release(&kmem.lock);
801023ab:	e9 a0 2b 00 00       	jmp    80104f50 <release>
    acquire(&kmem.lock);
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 40 36 11 80       	push   $0x80113640
801023b8:	e8 d3 2a 00 00       	call   80104e90 <acquire>
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	eb c2                	jmp    80102384 <kfree+0x44>
    panic("kfree");
801023c2:	83 ec 0c             	sub    $0xc,%esp
801023c5:	68 06 7d 10 80       	push   $0x80107d06
801023ca:	e8 c1 df ff ff       	call   80100390 <panic>
801023cf:	90                   	nop

801023d0 <freerange>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ed:	39 de                	cmp    %ebx,%esi
801023ef:	72 23                	jb     80102414 <freerange+0x44>
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102401:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102407:	50                   	push   %eax
80102408:	e8 33 ff ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	39 f3                	cmp    %esi,%ebx
80102412:	76 e4                	jbe    801023f8 <freerange+0x28>
}
80102414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102417:	5b                   	pop    %ebx
80102418:	5e                   	pop    %esi
80102419:	5d                   	pop    %ebp
8010241a:	c3                   	ret    
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102420 <kinit1>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102428:	83 ec 08             	sub    $0x8,%esp
8010242b:	68 0c 7d 10 80       	push   $0x80107d0c
80102430:	68 40 36 11 80       	push   $0x80113640
80102435:	e8 16 29 00 00       	call   80104d50 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102440:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102447:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102450:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102456:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245c:	39 de                	cmp    %ebx,%esi
8010245e:	72 1c                	jb     8010247c <kinit1+0x5c>
    kfree(p);
80102460:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102466:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102469:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010246f:	50                   	push   %eax
80102470:	e8 cb fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102475:	83 c4 10             	add    $0x10,%esp
80102478:	39 de                	cmp    %ebx,%esi
8010247a:	73 e4                	jae    80102460 <kinit1+0x40>
}
8010247c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010247f:	5b                   	pop    %ebx
80102480:	5e                   	pop    %esi
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102495:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102498:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010249b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ad:	39 de                	cmp    %ebx,%esi
801024af:	72 23                	jb     801024d4 <kinit2+0x44>
801024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024c7:	50                   	push   %eax
801024c8:	e8 73 fe ff ff       	call   80102340 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	39 de                	cmp    %ebx,%esi
801024d2:	73 e4                	jae    801024b8 <kinit2+0x28>
  kmem.use_lock = 1;
801024d4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024db:	00 00 00 
}
801024de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024f0:	a1 74 36 11 80       	mov    0x80113674,%eax
801024f5:	85 c0                	test   %eax,%eax
801024f7:	75 1f                	jne    80102518 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f9:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 0e                	je     80102510 <kalloc+0x20>
    kmem.freelist = r->next;
80102502:	8b 10                	mov    (%eax),%edx
80102504:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010250a:	c3                   	ret    
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102510:	f3 c3                	repz ret 
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102518:	55                   	push   %ebp
80102519:	89 e5                	mov    %esp,%ebp
8010251b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010251e:	68 40 36 11 80       	push   $0x80113640
80102523:	e8 68 29 00 00       	call   80104e90 <acquire>
  r = kmem.freelist;
80102528:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102536:	85 c0                	test   %eax,%eax
80102538:	74 08                	je     80102542 <kalloc+0x52>
    kmem.freelist = r->next;
8010253a:	8b 08                	mov    (%eax),%ecx
8010253c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102542:	85 d2                	test   %edx,%edx
80102544:	74 16                	je     8010255c <kalloc+0x6c>
    release(&kmem.lock);
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010254c:	68 40 36 11 80       	push   $0x80113640
80102551:	e8 fa 29 00 00       	call   80104f50 <release>
  return (char*)r;
80102556:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102559:	83 c4 10             	add    $0x10,%esp
}
8010255c:	c9                   	leave  
8010255d:	c3                   	ret    
8010255e:	66 90                	xchg   %ax,%ax

80102560 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba 64 00 00 00       	mov    $0x64,%edx
80102565:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102566:	a8 01                	test   $0x1,%al
80102568:	0f 84 c2 00 00 00    	je     80102630 <kbdgetc+0xd0>
8010256e:	ba 60 00 00 00       	mov    $0x60,%edx
80102573:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102574:	0f b6 d0             	movzbl %al,%edx
80102577:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010257d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102583:	0f 84 7f 00 00 00    	je     80102608 <kbdgetc+0xa8>
{
80102589:	55                   	push   %ebp
8010258a:	89 e5                	mov    %esp,%ebp
8010258c:	53                   	push   %ebx
8010258d:	89 cb                	mov    %ecx,%ebx
8010258f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102592:	84 c0                	test   %al,%al
80102594:	78 4a                	js     801025e0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102596:	85 db                	test   %ebx,%ebx
80102598:	74 09                	je     801025a3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010259d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025a0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025a3:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
801025aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ac:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
801025b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025b7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c3:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
801025ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ce:	74 31                	je     80102601 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d3:	83 fa 19             	cmp    $0x19,%edx
801025d6:	77 40                	ja     80102618 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025d8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025db:	5b                   	pop    %ebx
801025dc:	5d                   	pop    %ebp
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025e0:	83 e0 7f             	and    $0x7f,%eax
801025e3:	85 db                	test   %ebx,%ebx
801025e5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025e8:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
801025ef:	83 c8 40             	or     $0x40,%eax
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	f7 d0                	not    %eax
801025f7:	21 c1                	and    %eax,%ecx
    return 0;
801025f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025fb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102601:	5b                   	pop    %ebx
80102602:	5d                   	pop    %ebp
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102608:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010260b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010260d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102618:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010261b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010261e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010261f:	83 f9 1a             	cmp    $0x1a,%ecx
80102622:	0f 42 c2             	cmovb  %edx,%eax
}
80102625:	5d                   	pop    %ebp
80102626:	c3                   	ret    
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kbdintr>:

void
kbdintr(void)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102646:	68 60 25 10 80       	push   $0x80102560
8010264b:	e8 c0 e1 ff ff       	call   80100810 <consoleintr>
}
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	c9                   	leave  
80102654:	c3                   	ret    
80102655:	66 90                	xchg   %ax,%ax
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c8 00 00 00    	je     80102738 <lapicinit+0xd8>
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 77                	ja     80102740 <lapicinit+0xe0>
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102720:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102726:	80 e6 10             	and    $0x10,%dh
80102729:	75 f5                	jne    80102720 <lapicinit+0xc0>
  lapic[index] = value;
8010272b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102732:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102735:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102740:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102747:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
8010274d:	e9 77 ff ff ff       	jmp    801026c9 <lapicinit+0x69>
80102752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102760:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102766:	55                   	push   %ebp
80102767:	31 c0                	xor    %eax,%eax
80102769:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010276b:	85 d2                	test   %edx,%edx
8010276d:	74 06                	je     80102775 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010276f:	8b 42 20             	mov    0x20(%edx),%eax
80102772:	c1 e8 18             	shr    $0x18,%eax
}
80102775:	5d                   	pop    %ebp
80102776:	c3                   	ret    
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027b6:	ba 70 00 00 00       	mov    $0x70,%edx
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	53                   	push   %ebx
801027be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	ba 71 00 00 00       	mov    $0x71,%edx
801027cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027dd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027e0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027e3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ee:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102803:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102809:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102810:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102813:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102816:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010281f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102828:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	b8 0b 00 00 00       	mov    $0xb,%eax
80102846:	ba 70 00 00 00       	mov    $0x70,%edx
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	ba 71 00 00 00       	mov    $0x71,%edx
80102859:	ec                   	in     (%dx),%al
8010285a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010285d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102862:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102865:	8d 76 00             	lea    0x0(%esi),%esi
80102868:	31 c0                	xor    %eax,%eax
8010286a:	89 da                	mov    %ebx,%edx
8010286c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102872:	89 ca                	mov    %ecx,%edx
80102874:	ec                   	in     (%dx),%al
80102875:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	89 da                	mov    %ebx,%edx
8010287a:	b8 02 00 00 00       	mov    $0x2,%eax
8010287f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
80102883:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102886:	89 da                	mov    %ebx,%edx
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
80102891:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 da                	mov    %ebx,%edx
80102896:	b8 07 00 00 00       	mov    $0x7,%eax
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	89 ca                	mov    %ecx,%edx
8010289e:	ec                   	in     (%dx),%al
8010289f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a2:	89 da                	mov    %ebx,%edx
801028a4:	b8 08 00 00 00       	mov    $0x8,%eax
801028a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028aa:	89 ca                	mov    %ecx,%edx
801028ac:	ec                   	in     (%dx),%al
801028ad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028af:	89 da                	mov    %ebx,%edx
801028b1:	b8 09 00 00 00       	mov    $0x9,%eax
801028b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b7:	89 ca                	mov    %ecx,%edx
801028b9:	ec                   	in     (%dx),%al
801028ba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	89 ca                	mov    %ecx,%edx
801028c6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028c7:	84 c0                	test   %al,%al
801028c9:	78 9d                	js     80102868 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028cb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028cf:	89 fa                	mov    %edi,%edx
801028d1:	0f b6 fa             	movzbl %dl,%edi
801028d4:	89 f2                	mov    %esi,%edx
801028d6:	0f b6 f2             	movzbl %dl,%esi
801028d9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dc:	89 da                	mov    %ebx,%edx
801028de:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028e4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028eb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028f2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028f9:	31 c0                	xor    %eax,%eax
801028fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
801028ff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 da                	mov    %ebx,%edx
80102904:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102907:	b8 02 00 00 00       	mov    $0x2,%eax
8010290c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
80102910:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 da                	mov    %ebx,%edx
80102915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102918:	b8 04 00 00 00       	mov    $0x4,%eax
8010291d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
80102921:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 da                	mov    %ebx,%edx
80102926:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102929:	b8 07 00 00 00       	mov    $0x7,%eax
8010292e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
80102932:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 da                	mov    %ebx,%edx
80102937:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010293a:	b8 08 00 00 00       	mov    $0x8,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010294b:	b8 09 00 00 00       	mov    $0x9,%eax
80102950:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102951:	89 ca                	mov    %ecx,%edx
80102953:	ec                   	in     (%dx),%al
80102954:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102957:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010295a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010295d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102960:	6a 18                	push   $0x18
80102962:	50                   	push   %eax
80102963:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102966:	50                   	push   %eax
80102967:	e8 84 26 00 00       	call   80104ff0 <memcmp>
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 c0                	test   %eax,%eax
80102971:	0f 85 f1 fe ff ff    	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102977:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010297b:	75 78                	jne    801029f5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102980:	89 c2                	mov    %eax,%edx
80102982:	83 e0 0f             	and    $0xf,%eax
80102985:	c1 ea 04             	shr    $0x4,%edx
80102988:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102991:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102994:	89 c2                	mov    %eax,%edx
80102996:	83 e0 0f             	and    $0xf,%eax
80102999:	c1 ea 04             	shr    $0x4,%edx
8010299c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a8:	89 c2                	mov    %eax,%edx
801029aa:	83 e0 0f             	and    $0xf,%eax
801029ad:	c1 ea 04             	shr    $0x4,%edx
801029b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029bc:	89 c2                	mov    %eax,%edx
801029be:	83 e0 0f             	and    $0xf,%eax
801029c1:	c1 ea 04             	shr    $0x4,%edx
801029c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029f5:	8b 75 08             	mov    0x8(%ebp),%esi
801029f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029fb:	89 06                	mov    %eax,(%esi)
801029fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a00:	89 46 04             	mov    %eax,0x4(%esi)
80102a03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a06:	89 46 08             	mov    %eax,0x8(%esi)
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a12:	89 46 10             	mov    %eax,0x10(%esi)
80102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a25:	5b                   	pop    %ebx
80102a26:	5e                   	pop    %esi
80102a27:	5f                   	pop    %edi
80102a28:	5d                   	pop    %ebp
80102a29:	c3                   	ret    
80102a2a:	66 90                	xchg   %ax,%ax
80102a2c:	66 90                	xchg   %ax,%ax
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a30:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102a36:	85 c9                	test   %ecx,%ecx
80102a38:	0f 8e 8a 00 00 00    	jle    80102ac8 <install_trans+0x98>
{
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	57                   	push   %edi
80102a42:	56                   	push   %esi
80102a43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a44:	31 db                	xor    %ebx,%ebx
{
80102a46:	83 ec 0c             	sub    $0xc,%esp
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a55:	83 ec 08             	sub    $0x8,%esp
80102a58:	01 d8                	add    %ebx,%eax
80102a5a:	83 c0 01             	add    $0x1,%eax
80102a5d:	50                   	push   %eax
80102a5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a64:	e8 67 d6 ff ff       	call   801000d0 <bread>
80102a69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6b:	58                   	pop    %eax
80102a6c:	5a                   	pop    %edx
80102a6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102a74:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7d:	e8 4e d6 ff ff       	call   801000d0 <bread>
80102a82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a87:	83 c4 0c             	add    $0xc,%esp
80102a8a:	68 00 02 00 00       	push   $0x200
80102a8f:	50                   	push   %eax
80102a90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a93:	50                   	push   %eax
80102a94:	e8 b7 25 00 00       	call   80105050 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 ff d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102aa1:	89 3c 24             	mov    %edi,(%esp)
80102aa4:	e8 37 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 2f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ab1:	83 c4 10             	add    $0x10,%esp
80102ab4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102aba:	7f 94                	jg     80102a50 <install_trans+0x20>
  }
}
80102abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102abf:	5b                   	pop    %ebx
80102ac0:	5e                   	pop    %esi
80102ac1:	5f                   	pop    %edi
80102ac2:	5d                   	pop    %ebp
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac8:	f3 c3                	repz ret 
80102aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ad0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ad5:	83 ec 08             	sub    $0x8,%esp
80102ad8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ade:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ae9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102af2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102af4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102af6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102af9:	7e 16                	jle    80102b11 <write_head+0x41>
80102afb:	c1 e3 02             	shl    $0x2,%ebx
80102afe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b00:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102b06:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b0a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <write_head+0x30>
  }
  bwrite(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	56                   	push   %esi
80102b15:	e8 86 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b1a:	89 34 24             	mov    %esi,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>
}
80102b22:	83 c4 10             	add    $0x10,%esp
80102b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b28:	5b                   	pop    %ebx
80102b29:	5e                   	pop    %esi
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <initlog>:
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 2c             	sub    $0x2c,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b3a:	68 40 7f 10 80       	push   $0x80107f40
80102b3f:	68 80 36 11 80       	push   $0x80113680
80102b44:	e8 07 22 00 00       	call   80104d50 <initlock>
  readsb(dev, &sb);
80102b49:	58                   	pop    %eax
80102b4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 1b e9 ff ff       	call   80101470 <readsb>
  log.size = sb.nlog;
80102b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b5b:	59                   	pop    %ecx
  log.dev = dev;
80102b5c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b62:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b68:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	5a                   	pop    %edx
80102b6e:	50                   	push   %eax
80102b6f:	53                   	push   %ebx
80102b70:	e8 5b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b75:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b7d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b83:	7e 1c                	jle    80102ba1 <initlog+0x71>
80102b85:	c1 e3 02             	shl    $0x2,%ebx
80102b88:	31 d2                	xor    %edx,%edx
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b94:	83 c2 04             	add    $0x4,%edx
80102b97:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b9d:	39 d3                	cmp    %edx,%ebx
80102b9f:	75 ef                	jne    80102b90 <initlog+0x60>
  brelse(buf);
80102ba1:	83 ec 0c             	sub    $0xc,%esp
80102ba4:	50                   	push   %eax
80102ba5:	e8 36 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102baa:	e8 81 fe ff ff       	call   80102a30 <install_trans>
  log.lh.n = 0;
80102baf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102bb6:	00 00 00 
  write_head(); // clear the log
80102bb9:	e8 12 ff ff ff       	call   80102ad0 <write_head>
}
80102bbe:	83 c4 10             	add    $0x10,%esp
80102bc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc4:	c9                   	leave  
80102bc5:	c3                   	ret    
80102bc6:	8d 76 00             	lea    0x0(%esi),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bd6:	68 80 36 11 80       	push   $0x80113680
80102bdb:	e8 b0 22 00 00       	call   80104e90 <acquire>
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	eb 18                	jmp    80102bfd <begin_op+0x2d>
80102be5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	83 ec 08             	sub    $0x8,%esp
80102beb:	68 80 36 11 80       	push   $0x80113680
80102bf0:	68 80 36 11 80       	push   $0x80113680
80102bf5:	e8 86 17 00 00       	call   80104380 <sleep>
80102bfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bfd:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 e2                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c06:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c0b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102c11:	83 c0 01             	add    $0x1,%eax
80102c14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c1a:	83 fa 1e             	cmp    $0x1e,%edx
80102c1d:	7f c9                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c22:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c27:	68 80 36 11 80       	push   $0x80113680
80102c2c:	e8 1f 23 00 00       	call   80104f50 <release>
      break;
    }
  }
}
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	c9                   	leave  
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	68 80 36 11 80       	push   $0x80113680
80102c4e:	e8 3d 22 00 00       	call   80104e90 <acquire>
  log.outstanding -= 1;
80102c53:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c58:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c66:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102c6c:	0f 85 1a 01 00 00    	jne    80102d8c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c72:	85 db                	test   %ebx,%ebx
80102c74:	0f 85 ee 00 00 00    	jne    80102d68 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c7a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c7d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c84:	00 00 00 
  release(&log.lock);
80102c87:	68 80 36 11 80       	push   $0x80113680
80102c8c:	e8 bf 22 00 00       	call   80104f50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c91:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	85 c9                	test   %ecx,%ecx
80102c9c:	0f 8e 85 00 00 00    	jle    80102d27 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	01 d8                	add    %ebx,%eax
80102cac:	83 c0 01             	add    $0x1,%eax
80102caf:	50                   	push   %eax
80102cb0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	58                   	pop    %eax
80102cbe:	5a                   	pop    %edx
80102cbf:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cc6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccf:	e8 fc d3 ff ff       	call   801000d0 <bread>
80102cd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cd6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cd9:	83 c4 0c             	add    $0xc,%esp
80102cdc:	68 00 02 00 00       	push   $0x200
80102ce1:	50                   	push   %eax
80102ce2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ce5:	50                   	push   %eax
80102ce6:	e8 65 23 00 00       	call   80105050 <memmove>
    bwrite(to);  // write the log
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ad d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cf3:	89 3c 24             	mov    %edi,(%esp)
80102cf6:	e8 e5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 dd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d03:	83 c4 10             	add    $0x10,%esp
80102d06:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102d0c:	7c 94                	jl     80102ca2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d0e:	e8 bd fd ff ff       	call   80102ad0 <write_head>
    install_trans(); // Now install writes to home locations
80102d13:	e8 18 fd ff ff       	call   80102a30 <install_trans>
    log.lh.n = 0;
80102d18:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d1f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d22:	e8 a9 fd ff ff       	call   80102ad0 <write_head>
    acquire(&log.lock);
80102d27:	83 ec 0c             	sub    $0xc,%esp
80102d2a:	68 80 36 11 80       	push   $0x80113680
80102d2f:	e8 5c 21 00 00       	call   80104e90 <acquire>
    wakeup(&log);
80102d34:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d3b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d42:	00 00 00 
    wakeup(&log);
80102d45:	e8 f6 17 00 00       	call   80104540 <wakeup>
    release(&log.lock);
80102d4a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d51:	e8 fa 21 00 00       	call   80104f50 <release>
80102d56:	83 c4 10             	add    $0x10,%esp
}
80102d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5c:	5b                   	pop    %ebx
80102d5d:	5e                   	pop    %esi
80102d5e:	5f                   	pop    %edi
80102d5f:	5d                   	pop    %ebp
80102d60:	c3                   	ret    
80102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d68:	83 ec 0c             	sub    $0xc,%esp
80102d6b:	68 80 36 11 80       	push   $0x80113680
80102d70:	e8 cb 17 00 00       	call   80104540 <wakeup>
  release(&log.lock);
80102d75:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d7c:	e8 cf 21 00 00       	call   80104f50 <release>
80102d81:	83 c4 10             	add    $0x10,%esp
}
80102d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d87:	5b                   	pop    %ebx
80102d88:	5e                   	pop    %esi
80102d89:	5f                   	pop    %edi
80102d8a:	5d                   	pop    %ebp
80102d8b:	c3                   	ret    
    panic("log.committing");
80102d8c:	83 ec 0c             	sub    $0xc,%esp
80102d8f:	68 44 7f 10 80       	push   $0x80107f44
80102d94:	e8 f7 d5 ff ff       	call   80100390 <panic>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102da0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db0:	83 fa 1d             	cmp    $0x1d,%edx
80102db3:	0f 8f 9d 00 00 00    	jg     80102e56 <log_write+0xb6>
80102db9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dbe:	83 e8 01             	sub    $0x1,%eax
80102dc1:	39 c2                	cmp    %eax,%edx
80102dc3:	0f 8d 8d 00 00 00    	jge    80102e56 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dc9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	0f 8e 8d 00 00 00    	jle    80102e63 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	68 80 36 11 80       	push   $0x80113680
80102dde:	e8 ad 20 00 00       	call   80104e90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102de3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	83 f9 00             	cmp    $0x0,%ecx
80102def:	7e 57                	jle    80102e48 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102df4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102df6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102dfc:	75 0b                	jne    80102e09 <log_write+0x69>
80102dfe:	eb 38                	jmp    80102e38 <log_write+0x98>
80102e00:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102e07:	74 2f                	je     80102e38 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	39 c1                	cmp    %eax,%ecx
80102e0e:	75 f0                	jne    80102e00 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e10:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e17:	83 c0 01             	add    $0x1,%eax
80102e1a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e1f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e22:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2c:	c9                   	leave  
  release(&log.lock);
80102e2d:	e9 1e 21 00 00       	jmp    80104f50 <release>
80102e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e38:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e3f:	eb de                	jmp    80102e1f <log_write+0x7f>
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8b 43 08             	mov    0x8(%ebx),%eax
80102e4b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e50:	75 cd                	jne    80102e1f <log_write+0x7f>
80102e52:	31 c0                	xor    %eax,%eax
80102e54:	eb c1                	jmp    80102e17 <log_write+0x77>
    panic("too big a transaction");
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 53 7f 10 80       	push   $0x80107f53
80102e5e:	e8 2d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e63:	83 ec 0c             	sub    $0xc,%esp
80102e66:	68 69 7f 10 80       	push   $0x80107f69
80102e6b:	e8 20 d5 ff ff       	call   80100390 <panic>

80102e70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e77:	e8 e4 0a 00 00       	call   80103960 <cpuid>
80102e7c:	89 c3                	mov    %eax,%ebx
80102e7e:	e8 dd 0a 00 00       	call   80103960 <cpuid>
80102e83:	83 ec 04             	sub    $0x4,%esp
80102e86:	53                   	push   %ebx
80102e87:	50                   	push   %eax
80102e88:	68 84 7f 10 80       	push   $0x80107f84
80102e8d:	e8 ce d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e92:	e8 29 34 00 00       	call   801062c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e97:	e8 74 0a 00 00       	call   80103910 <mycpu>
80102e9c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e9e:	b8 01 00 00 00       	mov    $0x1,%eax
80102ea3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eaa:	e8 e1 10 00 00       	call   80103f90 <scheduler>
80102eaf:	90                   	nop

80102eb0 <mpenter>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102eb6:	e8 f5 44 00 00       	call   801073b0 <switchkvm>
  seginit();
80102ebb:	e8 60 44 00 00       	call   80107320 <seginit>
  lapicinit();
80102ec0:	e8 9b f7 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102ec5:	e8 a6 ff ff ff       	call   80102e70 <mpmain>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <main>:
{
80102ed0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ed4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ed7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eda:	55                   	push   %ebp
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	53                   	push   %ebx
80102ede:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102edf:	83 ec 08             	sub    $0x8,%esp
80102ee2:	68 00 00 40 80       	push   $0x80400000
80102ee7:	68 c8 64 11 80       	push   $0x801164c8
80102eec:	e8 2f f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ef1:	e8 8a 49 00 00       	call   80107880 <kvmalloc>
  mpinit();        // detect other processors
80102ef6:	e8 75 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102efb:	e8 60 f7 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102f00:	e8 1b 44 00 00       	call   80107320 <seginit>
  picinit();       // disable pic
80102f05:	e8 36 03 00 00       	call   80103240 <picinit>
  ioapicinit();    // another interrupt controller
80102f0a:	e8 41 f3 ff ff       	call   80102250 <ioapicinit>
  consoleinit();   // console hardware
80102f0f:	e8 ac da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f14:	e8 d7 36 00 00       	call   801065f0 <uartinit>
  pinit();         // process table
80102f19:	e8 d2 09 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
80102f1e:	e8 1d 33 00 00       	call   80106240 <tvinit>
  binit();         // buffer cache
80102f23:	e8 18 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f28:	e8 63 de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
80102f2d:	e8 fe f0 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f32:	83 c4 0c             	add    $0xc,%esp
80102f35:	68 8a 00 00 00       	push   $0x8a
80102f3a:	68 8c b4 10 80       	push   $0x8010b48c
80102f3f:	68 00 70 00 80       	push   $0x80007000
80102f44:	e8 07 21 00 00       	call   80105050 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f49:	69 05 30 38 11 80 b0 	imul   $0xb0,0x80113830,%eax
80102f50:	00 00 00 
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	05 80 37 11 80       	add    $0x80113780,%eax
80102f5b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f60:	76 71                	jbe    80102fd3 <main+0x103>
80102f62:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f67:	89 f6                	mov    %esi,%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f70:	e8 9b 09 00 00       	call   80103910 <mycpu>
80102f75:	39 d8                	cmp    %ebx,%eax
80102f77:	74 41                	je     80102fba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f79:	e8 72 f5 ff ff       	call   801024f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f7e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f83:	c7 05 f8 6f 00 80 b0 	movl   $0x80102eb0,0x80006ff8
80102f8a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f8d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f94:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f97:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f9c:	0f b6 03             	movzbl (%ebx),%eax
80102f9f:	83 ec 08             	sub    $0x8,%esp
80102fa2:	68 00 70 00 00       	push   $0x7000
80102fa7:	50                   	push   %eax
80102fa8:	e8 03 f8 ff ff       	call   801027b0 <lapicstartap>
80102fad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fb0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 f6                	je     80102fb0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fba:	69 05 30 38 11 80 b0 	imul   $0xb0,0x80113830,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fca:	05 80 37 11 80       	add    $0x80113780,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 9d                	jb     80102f70 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	83 ec 08             	sub    $0x8,%esp
80102fd6:	68 00 00 00 8e       	push   $0x8e000000
80102fdb:	68 00 00 40 80       	push   $0x80400000
80102fe0:	e8 ab f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fe5:	e8 c6 09 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80102fea:	e8 81 fe ff ff       	call   80102e70 <mpmain>
80102fef:	90                   	nop

80102ff0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ff5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102ffb:	53                   	push   %ebx
  e = addr+len;
80102ffc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103002:	39 de                	cmp    %ebx,%esi
80103004:	72 10                	jb     80103016 <mpsearch1+0x26>
80103006:	eb 50                	jmp    80103058 <mpsearch1+0x68>
80103008:	90                   	nop
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	39 fb                	cmp    %edi,%ebx
80103012:	89 fe                	mov    %edi,%esi
80103014:	76 42                	jbe    80103058 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	83 ec 04             	sub    $0x4,%esp
80103019:	8d 7e 10             	lea    0x10(%esi),%edi
8010301c:	6a 04                	push   $0x4
8010301e:	68 98 7f 10 80       	push   $0x80107f98
80103023:	56                   	push   %esi
80103024:	e8 c7 1f 00 00       	call   80104ff0 <memcmp>
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	85 c0                	test   %eax,%eax
8010302e:	75 e0                	jne    80103010 <mpsearch1+0x20>
80103030:	89 f1                	mov    %esi,%ecx
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103038:	0f b6 11             	movzbl (%ecx),%edx
8010303b:	83 c1 01             	add    $0x1,%ecx
8010303e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103040:	39 f9                	cmp    %edi,%ecx
80103042:	75 f4                	jne    80103038 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103044:	84 c0                	test   %al,%al
80103046:	75 c8                	jne    80103010 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304b:	89 f0                	mov    %esi,%eax
8010304d:	5b                   	pop    %ebx
8010304e:	5e                   	pop    %esi
8010304f:	5f                   	pop    %edi
80103050:	5d                   	pop    %ebp
80103051:	c3                   	ret    
80103052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010305b:	31 f6                	xor    %esi,%esi
}
8010305d:	89 f0                	mov    %esi,%eax
8010305f:	5b                   	pop    %ebx
80103060:	5e                   	pop    %esi
80103061:	5f                   	pop    %edi
80103062:	5d                   	pop    %ebp
80103063:	c3                   	ret    
80103064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010306a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103070 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103079:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103080:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103087:	c1 e0 08             	shl    $0x8,%eax
8010308a:	09 d0                	or     %edx,%eax
8010308c:	c1 e0 04             	shl    $0x4,%eax
8010308f:	85 c0                	test   %eax,%eax
80103091:	75 1b                	jne    801030ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103093:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010309a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030a1:	c1 e0 08             	shl    $0x8,%eax
801030a4:	09 d0                	or     %edx,%eax
801030a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ae:	ba 00 04 00 00       	mov    $0x400,%edx
801030b3:	e8 38 ff ff ff       	call   80102ff0 <mpsearch1>
801030b8:	85 c0                	test   %eax,%eax
801030ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030bd:	0f 84 35 01 00 00    	je     801031f8 <mpinit+0x188>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c6:	8b 58 04             	mov    0x4(%eax),%ebx
801030c9:	85 db                	test   %ebx,%ebx
801030cb:	0f 84 47 01 00 00    	je     80103218 <mpinit+0x1a8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030d7:	83 ec 04             	sub    $0x4,%esp
801030da:	6a 04                	push   $0x4
801030dc:	68 b5 7f 10 80       	push   $0x80107fb5
801030e1:	56                   	push   %esi
801030e2:	e8 09 1f 00 00       	call   80104ff0 <memcmp>
801030e7:	83 c4 10             	add    $0x10,%esp
801030ea:	85 c0                	test   %eax,%eax
801030ec:	0f 85 26 01 00 00    	jne    80103218 <mpinit+0x1a8>
  if(conf->version != 1 && conf->version != 4)
801030f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030f9:	3c 01                	cmp    $0x1,%al
801030fb:	0f 95 c2             	setne  %dl
801030fe:	3c 04                	cmp    $0x4,%al
80103100:	0f 95 c0             	setne  %al
80103103:	20 c2                	and    %al,%dl
80103105:	0f 85 0d 01 00 00    	jne    80103218 <mpinit+0x1a8>
  if(sum((uchar*)conf, conf->length) != 0)
8010310b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103112:	66 85 ff             	test   %di,%di
80103115:	74 1a                	je     80103131 <mpinit+0xc1>
80103117:	89 f0                	mov    %esi,%eax
80103119:	01 f7                	add    %esi,%edi
  sum = 0;
8010311b:	31 d2                	xor    %edx,%edx
8010311d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103120:	0f b6 08             	movzbl (%eax),%ecx
80103123:	83 c0 01             	add    $0x1,%eax
80103126:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103128:	39 c7                	cmp    %eax,%edi
8010312a:	75 f4                	jne    80103120 <mpinit+0xb0>
8010312c:	84 d2                	test   %dl,%dl
8010312e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103131:	85 f6                	test   %esi,%esi
80103133:	0f 84 df 00 00 00    	je     80103218 <mpinit+0x1a8>
80103139:	84 d2                	test   %dl,%dl
8010313b:	0f 85 d7 00 00 00    	jne    80103218 <mpinit+0x1a8>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103141:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103147:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103153:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103159:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315e:	01 d6                	add    %edx,%esi
80103160:	39 c6                	cmp    %eax,%esi
80103162:	76 23                	jbe    80103187 <mpinit+0x117>
    switch(*p){
80103164:	0f b6 10             	movzbl (%eax),%edx
80103167:	80 fa 04             	cmp    $0x4,%dl
8010316a:	0f 87 c2 00 00 00    	ja     80103232 <mpinit+0x1c2>
80103170:	ff 24 95 dc 7f 10 80 	jmp    *-0x7fef8024(,%edx,4)
80103177:	89 f6                	mov    %esi,%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103180:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103183:	39 c6                	cmp    %eax,%esi
80103185:	77 dd                	ja     80103164 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103187:	85 db                	test   %ebx,%ebx
80103189:	0f 84 96 00 00 00    	je     80103225 <mpinit+0x1b5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010318f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103192:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103196:	74 15                	je     801031ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103198:	b8 70 00 00 00       	mov    $0x70,%eax
8010319d:	ba 22 00 00 00       	mov    $0x22,%edx
801031a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a3:	ba 23 00 00 00       	mov    $0x23,%edx
801031a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ac:	ee                   	out    %al,(%dx)
  }
}
801031ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b0:	5b                   	pop    %ebx
801031b1:	5e                   	pop    %esi
801031b2:	5f                   	pop    %edi
801031b3:	5d                   	pop    %ebp
801031b4:	c3                   	ret    
801031b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031b8:	8b 0d 30 38 11 80    	mov    0x80113830,%ecx
801031be:	85 c9                	test   %ecx,%ecx
801031c0:	7f 19                	jg     801031db <mpinit+0x16b>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c2:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031c6:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031cc:	83 c1 01             	add    $0x1,%ecx
801031cf:	89 0d 30 38 11 80    	mov    %ecx,0x80113830
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d5:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801031db:	83 c0 14             	add    $0x14,%eax
      continue;
801031de:	eb 80                	jmp    80103160 <mpinit+0xf0>
      ioapicid = ioapic->apicno;
801031e0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031e4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031e7:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
801031ed:	e9 6e ff ff ff       	jmp    80103160 <mpinit+0xf0>
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031f8:	ba 00 00 01 00       	mov    $0x10000,%edx
801031fd:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103202:	e8 e9 fd ff ff       	call   80102ff0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103207:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010320c:	0f 85 b1 fe ff ff    	jne    801030c3 <mpinit+0x53>
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103218:	83 ec 0c             	sub    $0xc,%esp
8010321b:	68 9d 7f 10 80       	push   $0x80107f9d
80103220:	e8 6b d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103225:	83 ec 0c             	sub    $0xc,%esp
80103228:	68 bc 7f 10 80       	push   $0x80107fbc
8010322d:	e8 5e d1 ff ff       	call   80100390 <panic>
      ismp = 0;
80103232:	31 db                	xor    %ebx,%ebx
80103234:	e9 2e ff ff ff       	jmp    80103167 <mpinit+0xf7>
80103239:	66 90                	xchg   %ax,%ax
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103240:	55                   	push   %ebp
80103241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103246:	ba 21 00 00 00       	mov    $0x21,%edx
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	ee                   	out    %al,(%dx)
8010324e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103253:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103254:	5d                   	pop    %ebp
80103255:	c3                   	ret    
80103256:	66 90                	xchg   %ax,%ax
80103258:	66 90                	xchg   %ax,%ax
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010326f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010327b:	e8 30 db ff ff       	call   80100db0 <filealloc>
80103280:	85 c0                	test   %eax,%eax
80103282:	89 03                	mov    %eax,(%ebx)
80103284:	74 22                	je     801032a8 <pipealloc+0x48>
80103286:	e8 25 db ff ff       	call   80100db0 <filealloc>
8010328b:	85 c0                	test   %eax,%eax
8010328d:	89 06                	mov    %eax,(%esi)
8010328f:	74 3f                	je     801032d0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103291:	e8 5a f2 ff ff       	call   801024f0 <kalloc>
80103296:	85 c0                	test   %eax,%eax
80103298:	89 c7                	mov    %eax,%edi
8010329a:	75 54                	jne    801032f0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010329c:	8b 03                	mov    (%ebx),%eax
8010329e:	85 c0                	test   %eax,%eax
801032a0:	75 34                	jne    801032d6 <pipealloc+0x76>
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032a8:	8b 06                	mov    (%esi),%eax
801032aa:	85 c0                	test   %eax,%eax
801032ac:	74 0c                	je     801032ba <pipealloc+0x5a>
    fileclose(*f1);
801032ae:	83 ec 0c             	sub    $0xc,%esp
801032b1:	50                   	push   %eax
801032b2:	e8 b9 db ff ff       	call   80100e70 <fileclose>
801032b7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032c2:	5b                   	pop    %ebx
801032c3:	5e                   	pop    %esi
801032c4:	5f                   	pop    %edi
801032c5:	5d                   	pop    %ebp
801032c6:	c3                   	ret    
801032c7:	89 f6                	mov    %esi,%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032d0:	8b 03                	mov    (%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 e4                	je     801032ba <pipealloc+0x5a>
    fileclose(*f0);
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	50                   	push   %eax
801032da:	e8 91 db ff ff       	call   80100e70 <fileclose>
  if(*f1)
801032df:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032e1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032e4:	85 c0                	test   %eax,%eax
801032e6:	75 c6                	jne    801032ae <pipealloc+0x4e>
801032e8:	eb d0                	jmp    801032ba <pipealloc+0x5a>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032f0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032f3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fa:	00 00 00 
  p->writeopen = 1;
801032fd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103304:	00 00 00 
  p->nwrite = 0;
80103307:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330e:	00 00 00 
  p->nread = 0;
80103311:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103318:	00 00 00 
  initlock(&p->lock, "pipe");
8010331b:	68 f0 7f 10 80       	push   $0x80107ff0
80103320:	50                   	push   %eax
80103321:	e8 2a 1a 00 00       	call   80104d50 <initlock>
  (*f0)->type = FD_PIPE;
80103326:	8b 03                	mov    (%ebx),%eax
  return 0;
80103328:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010332b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103331:	8b 03                	mov    (%ebx),%eax
80103333:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103337:	8b 03                	mov    (%ebx),%eax
80103339:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010333d:	8b 03                	mov    (%ebx),%eax
8010333f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103342:	8b 06                	mov    (%esi),%eax
80103344:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334a:	8b 06                	mov    (%esi),%eax
8010334c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103350:	8b 06                	mov    (%esi),%eax
80103352:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103356:	8b 06                	mov    (%esi),%eax
80103358:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010335b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335e:	31 c0                	xor    %eax,%eax
}
80103360:	5b                   	pop    %ebx
80103361:	5e                   	pop    %esi
80103362:	5f                   	pop    %edi
80103363:	5d                   	pop    %ebp
80103364:	c3                   	ret    
80103365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103370 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	56                   	push   %esi
80103374:	53                   	push   %ebx
80103375:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103378:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010337b:	83 ec 0c             	sub    $0xc,%esp
8010337e:	53                   	push   %ebx
8010337f:	e8 0c 1b 00 00       	call   80104e90 <acquire>
  if(writable){
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 f6                	test   %esi,%esi
80103389:	74 45                	je     801033d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010338b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103391:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103394:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010339b:	00 00 00 
    wakeup(&p->nread);
8010339e:	50                   	push   %eax
8010339f:	e8 9c 11 00 00       	call   80104540 <wakeup>
801033a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ad:	85 d2                	test   %edx,%edx
801033af:	75 0a                	jne    801033bb <pipeclose+0x4b>
801033b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033b7:	85 c0                	test   %eax,%eax
801033b9:	74 35                	je     801033f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c1:	5b                   	pop    %ebx
801033c2:	5e                   	pop    %esi
801033c3:	5d                   	pop    %ebp
    release(&p->lock);
801033c4:	e9 87 1b 00 00       	jmp    80104f50 <release>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033d6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033e0:	00 00 00 
    wakeup(&p->nwrite);
801033e3:	50                   	push   %eax
801033e4:	e8 57 11 00 00       	call   80104540 <wakeup>
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	eb b9                	jmp    801033a7 <pipeclose+0x37>
801033ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	53                   	push   %ebx
801033f4:	e8 57 1b 00 00       	call   80104f50 <release>
    kfree((char*)p);
801033f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033fc:	83 c4 10             	add    $0x10,%esp
}
801033ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103402:	5b                   	pop    %ebx
80103403:	5e                   	pop    %esi
80103404:	5d                   	pop    %ebp
    kfree((char*)p);
80103405:	e9 36 ef ff ff       	jmp    80102340 <kfree>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103410 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 28             	sub    $0x28,%esp
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010341c:	53                   	push   %ebx
8010341d:	e8 6e 1a 00 00       	call   80104e90 <acquire>
  for(i = 0; i < n; i++){
80103422:	8b 45 10             	mov    0x10(%ebp),%eax
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 8e c9 00 00 00    	jle    801034f9 <pipewrite+0xe9>
80103430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103433:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103439:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010343f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103442:	03 4d 10             	add    0x10(%ebp),%ecx
80103445:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103448:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010344e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103454:	39 d0                	cmp    %edx,%eax
80103456:	75 71                	jne    801034c9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103458:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010345e:	85 c0                	test   %eax,%eax
80103460:	74 4e                	je     801034b0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103462:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103468:	eb 3a                	jmp    801034a4 <pipewrite+0x94>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	57                   	push   %edi
80103474:	e8 c7 10 00 00       	call   80104540 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103479:	5a                   	pop    %edx
8010347a:	59                   	pop    %ecx
8010347b:	53                   	push   %ebx
8010347c:	56                   	push   %esi
8010347d:	e8 fe 0e 00 00       	call   80104380 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103482:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103488:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010348e:	83 c4 10             	add    $0x10,%esp
80103491:	05 00 02 00 00       	add    $0x200,%eax
80103496:	39 c2                	cmp    %eax,%edx
80103498:	75 36                	jne    801034d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010349a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034a0:	85 c0                	test   %eax,%eax
801034a2:	74 0c                	je     801034b0 <pipewrite+0xa0>
801034a4:	e8 d7 04 00 00       	call   80103980 <myproc>
801034a9:	8b 40 24             	mov    0x24(%eax),%eax
801034ac:	85 c0                	test   %eax,%eax
801034ae:	74 c0                	je     80103470 <pipewrite+0x60>
        release(&p->lock);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	53                   	push   %ebx
801034b4:	e8 97 1a 00 00       	call   80104f50 <release>
        return -1;
801034b9:	83 c4 10             	add    $0x10,%esp
801034bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c4:	5b                   	pop    %ebx
801034c5:	5e                   	pop    %esi
801034c6:	5f                   	pop    %edi
801034c7:	5d                   	pop    %ebp
801034c8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034c9:	89 c2                	mov    %eax,%edx
801034cb:	90                   	nop
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034d3:	8d 42 01             	lea    0x1(%edx),%eax
801034d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034e2:	83 c6 01             	add    $0x1,%esi
801034e5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034e9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034ec:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ef:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034f3:	0f 85 4f ff ff ff    	jne    80103448 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ff:	83 ec 0c             	sub    $0xc,%esp
80103502:	50                   	push   %eax
80103503:	e8 38 10 00 00       	call   80104540 <wakeup>
  release(&p->lock);
80103508:	89 1c 24             	mov    %ebx,(%esp)
8010350b:	e8 40 1a 00 00       	call   80104f50 <release>
  return n;
80103510:	83 c4 10             	add    $0x10,%esp
80103513:	8b 45 10             	mov    0x10(%ebp),%eax
80103516:	eb a9                	jmp    801034c1 <pipewrite+0xb1>
80103518:	90                   	nop
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103520 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 18             	sub    $0x18,%esp
80103529:	8b 75 08             	mov    0x8(%ebp),%esi
8010352c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010352f:	56                   	push   %esi
80103530:	e8 5b 19 00 00       	call   80104e90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010353e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103544:	75 6a                	jne    801035b0 <piperead+0x90>
80103546:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010354c:	85 db                	test   %ebx,%ebx
8010354e:	0f 84 c4 00 00 00    	je     80103618 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103554:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010355a:	eb 2d                	jmp    80103589 <piperead+0x69>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103560:	83 ec 08             	sub    $0x8,%esp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	e8 16 0e 00 00       	call   80104380 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103573:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103579:	75 35                	jne    801035b0 <piperead+0x90>
8010357b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103581:	85 d2                	test   %edx,%edx
80103583:	0f 84 8f 00 00 00    	je     80103618 <piperead+0xf8>
    if(myproc()->killed){
80103589:	e8 f2 03 00 00       	call   80103980 <myproc>
8010358e:	8b 48 24             	mov    0x24(%eax),%ecx
80103591:	85 c9                	test   %ecx,%ecx
80103593:	74 cb                	je     80103560 <piperead+0x40>
      release(&p->lock);
80103595:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103598:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010359d:	56                   	push   %esi
8010359e:	e8 ad 19 00 00       	call   80104f50 <release>
      return -1;
801035a3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a9:	89 d8                	mov    %ebx,%eax
801035ab:	5b                   	pop    %ebx
801035ac:	5e                   	pop    %esi
801035ad:	5f                   	pop    %edi
801035ae:	5d                   	pop    %ebp
801035af:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035b0:	8b 45 10             	mov    0x10(%ebp),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	7e 61                	jle    80103618 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035b7:	31 db                	xor    %ebx,%ebx
801035b9:	eb 13                	jmp    801035ce <piperead+0xae>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035c6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035cc:	74 1f                	je     801035ed <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ce:	8d 41 01             	lea    0x1(%ecx),%eax
801035d1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035d7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035dd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035e2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035e5:	83 c3 01             	add    $0x1,%ebx
801035e8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035eb:	75 d3                	jne    801035c0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035ed:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035f3:	83 ec 0c             	sub    $0xc,%esp
801035f6:	50                   	push   %eax
801035f7:	e8 44 0f 00 00       	call   80104540 <wakeup>
  release(&p->lock);
801035fc:	89 34 24             	mov    %esi,(%esp)
801035ff:	e8 4c 19 00 00       	call   80104f50 <release>
  return i;
80103604:	83 c4 10             	add    $0x10,%esp
}
80103607:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010360a:	89 d8                	mov    %ebx,%eax
8010360c:	5b                   	pop    %ebx
8010360d:	5e                   	pop    %esi
8010360e:	5f                   	pop    %edi
8010360f:	5d                   	pop    %ebp
80103610:	c3                   	ret    
80103611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103618:	31 db                	xor    %ebx,%ebx
8010361a:	eb d1                	jmp    801035ed <piperead+0xcd>
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103624:	bb 74 38 11 80       	mov    $0x80113874,%ebx
{
80103629:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010362c:	68 40 38 11 80       	push   $0x80113840
80103631:	e8 5a 18 00 00       	call   80104e90 <acquire>
80103636:	83 c4 10             	add    $0x10,%esp
80103639:	eb 17                	jmp    80103652 <allocproc+0x32>
8010363b:	90                   	nop
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103640:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103646:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
8010364c:	0f 83 ae 00 00 00    	jae    80103700 <allocproc+0xe0>
    if(p->state == UNUSED)
80103652:	8b 43 0c             	mov    0xc(%ebx),%eax
80103655:	85 c0                	test   %eax,%eax
80103657:	75 e7                	jne    80103640 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103659:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->ticket = 10;
  p->ticks = ticks;
  p->queueNum = 0;
  p->cycleNum = 1;
  p->remainingPriority = 10;
  release(&ptable.lock);
8010365e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103661:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->ticket = 10;
80103668:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->queueNum = 0;
8010366f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103676:	00 00 00 
  p->cycleNum = 1;
80103679:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80103680:	00 00 00 
  p->remainingPriority = 10;
80103683:	c7 83 8c 00 00 00 00 	movl   $0x41200000,0x8c(%ebx)
8010368a:	00 20 41 
  p->pid = nextpid++;
8010368d:	8d 50 01             	lea    0x1(%eax),%edx
80103690:	89 43 10             	mov    %eax,0x10(%ebx)
  p->ticks = ticks;
80103693:	a1 c0 64 11 80       	mov    0x801164c0,%eax
  p->pid = nextpid++;
80103698:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->ticks = ticks;
8010369e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  release(&ptable.lock);
801036a4:	68 40 38 11 80       	push   $0x80113840
801036a9:	e8 a2 18 00 00       	call   80104f50 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036ae:	e8 3d ee ff ff       	call   801024f0 <kalloc>
801036b3:	83 c4 10             	add    $0x10,%esp
801036b6:	85 c0                	test   %eax,%eax
801036b8:	89 43 08             	mov    %eax,0x8(%ebx)
801036bb:	74 5c                	je     80103719 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036bd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036c3:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036c6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036cb:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036ce:	c7 40 14 31 62 10 80 	movl   $0x80106231,0x14(%eax)
  p->context = (struct context*)sp;
801036d5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036d8:	6a 14                	push   $0x14
801036da:	6a 00                	push   $0x0
801036dc:	50                   	push   %eax
801036dd:	e8 be 18 00 00       	call   80104fa0 <memset>
  p->context->eip = (uint)forkret;
801036e2:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036e5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036e8:	c7 40 10 30 37 10 80 	movl   $0x80103730,0x10(%eax)
}
801036ef:	89 d8                	mov    %ebx,%eax
801036f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036f4:	c9                   	leave  
801036f5:	c3                   	ret    
801036f6:	8d 76 00             	lea    0x0(%esi),%esi
801036f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103703:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103705:	68 40 38 11 80       	push   $0x80113840
8010370a:	e8 41 18 00 00       	call   80104f50 <release>
}
8010370f:	89 d8                	mov    %ebx,%eax
  return 0;
80103711:	83 c4 10             	add    $0x10,%esp
}
80103714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103717:	c9                   	leave  
80103718:	c3                   	ret    
    p->state = UNUSED;
80103719:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103720:	31 db                	xor    %ebx,%ebx
80103722:	eb cb                	jmp    801036ef <allocproc+0xcf>
80103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103730 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103736:	68 40 38 11 80       	push   $0x80113840
8010373b:	e8 10 18 00 00       	call   80104f50 <release>

  if (first) {
80103740:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	85 c0                	test   %eax,%eax
8010374a:	75 04                	jne    80103750 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010374c:	c9                   	leave  
8010374d:	c3                   	ret    
8010374e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103750:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103753:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010375a:	00 00 00 
    iinit(ROOTDEV);
8010375d:	6a 01                	push   $0x1
8010375f:	e8 4c dd ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103764:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010376b:	e8 c0 f3 ff ff       	call   80102b30 <initlog>
80103770:	83 c4 10             	add    $0x10,%esp
}
80103773:	c9                   	leave  
80103774:	c3                   	ret    
80103775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103780 <itoa.part.1>:
char* itoa(int num, char* str) { 
80103780:	55                   	push   %ebp
80103781:	89 c1                	mov    %eax,%ecx
80103783:	89 e5                	mov    %esp,%ebp
80103785:	57                   	push   %edi
80103786:	56                   	push   %esi
80103787:	53                   	push   %ebx
80103788:	89 d3                	mov    %edx,%ebx
8010378a:	83 ec 04             	sub    $0x4,%esp
    if (num < 0 && 10 == 10) { 
8010378d:	85 c0                	test   %eax,%eax
8010378f:	0f 88 9b 00 00 00    	js     80103830 <itoa.part.1+0xb0>
    int isNegative = 0; 
80103795:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (num != 0) { 
8010379c:	0f 84 9e 00 00 00    	je     80103840 <itoa.part.1+0xc0>
    int isNegative = 0; 
801037a2:	31 ff                	xor    %edi,%edi
801037a4:	eb 0c                	jmp    801037b2 <itoa.part.1+0x32>
801037a6:	8d 76 00             	lea    0x0(%esi),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
801037b0:	89 f7                	mov    %esi,%edi
        int rem = num % 10; 
801037b2:	b8 67 66 66 66       	mov    $0x66666667,%eax
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
801037b7:	8d 77 01             	lea    0x1(%edi),%esi
        int rem = num % 10; 
801037ba:	f7 e9                	imul   %ecx
801037bc:	89 c8                	mov    %ecx,%eax
801037be:	c1 f8 1f             	sar    $0x1f,%eax
801037c1:	c1 fa 02             	sar    $0x2,%edx
801037c4:	29 c2                	sub    %eax,%edx
801037c6:	8d 04 92             	lea    (%edx,%edx,4),%eax
801037c9:	01 c0                	add    %eax,%eax
801037cb:	29 c1                	sub    %eax,%ecx
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
801037cd:	83 c1 30             	add    $0x30,%ecx
    while (num != 0) { 
801037d0:	85 d2                	test   %edx,%edx
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
801037d2:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
        num = num/10; 
801037d6:	89 d1                	mov    %edx,%ecx
    while (num != 0) { 
801037d8:	75 d6                	jne    801037b0 <itoa.part.1+0x30>
    if (isNegative) 
801037da:	8b 55 f0             	mov    -0x10(%ebp),%edx
801037dd:	8d 04 33             	lea    (%ebx,%esi,1),%eax
801037e0:	85 d2                	test   %edx,%edx
801037e2:	74 3c                	je     80103820 <itoa.part.1+0xa0>
801037e4:	8d 77 02             	lea    0x2(%edi),%esi
        str[i++] = '-'; 
801037e7:	c6 00 2d             	movb   $0x2d,(%eax)
801037ea:	89 f2                	mov    %esi,%edx
801037ec:	8d 04 33             	lea    (%ebx,%esi,1),%eax
801037ef:	d1 fa                	sar    %edx
  for (int i = 0; i < len / 2; i++) {
801037f1:	85 d2                	test   %edx,%edx
    str[i] = '\0'; 
801037f3:	c6 00 00             	movb   $0x0,(%eax)
  for (int i = 0; i < len / 2; i++) {
801037f6:	7e 1e                	jle    80103816 <itoa.part.1+0x96>
801037f8:	8d 44 1e ff          	lea    -0x1(%esi,%ebx,1),%eax
801037fc:	89 c6                	mov    %eax,%esi
801037fe:	29 d6                	sub    %edx,%esi
    temp = str[i];
80103800:	0f b6 13             	movzbl (%ebx),%edx
    str[i] = str[len - i - 1];
80103803:	0f b6 08             	movzbl (%eax),%ecx
80103806:	83 e8 01             	sub    $0x1,%eax
80103809:	83 c3 01             	add    $0x1,%ebx
8010380c:	88 4b ff             	mov    %cl,-0x1(%ebx)
    str[len - i - 1] = temp;
8010380f:	88 50 01             	mov    %dl,0x1(%eax)
  for (int i = 0; i < len / 2; i++) {
80103812:	39 f0                	cmp    %esi,%eax
80103814:	75 ea                	jne    80103800 <itoa.part.1+0x80>
} 
80103816:	83 c4 04             	add    $0x4,%esp
80103819:	5b                   	pop    %ebx
8010381a:	5e                   	pop    %esi
8010381b:	5f                   	pop    %edi
8010381c:	5d                   	pop    %ebp
8010381d:	c3                   	ret    
8010381e:	66 90                	xchg   %ax,%ax
80103820:	89 f2                	mov    %esi,%edx
80103822:	d1 fa                	sar    %edx
80103824:	eb cb                	jmp    801037f1 <itoa.part.1+0x71>
80103826:	8d 76 00             	lea    0x0(%esi),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        num = -num; 
80103830:	f7 d9                	neg    %ecx
        isNegative = 1; 
80103832:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80103839:	e9 64 ff ff ff       	jmp    801037a2 <itoa.part.1+0x22>
8010383e:	66 90                	xchg   %ax,%ax
    str[i] = '\0'; 
80103840:	c6 02 00             	movb   $0x0,(%edx)
80103843:	eb d1                	jmp    80103816 <itoa.part.1+0x96>
80103845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <findRunnableProcLottery.part.2>:
int findRunnableProcLottery (struct proc * queue0[], int q0Index){
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	89 c6                	mov    %eax,%esi
80103858:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < q0Index; i++) {
8010385b:	85 d2                	test   %edx,%edx
8010385d:	0f 8e 7d 00 00 00    	jle    801038e0 <findRunnableProcLottery.part.2+0x90>
80103863:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  int ticketNums = 0;
80103866:	31 d2                	xor    %edx,%edx
80103868:	90                   	nop
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ticketNums += queue0[i]->ticket;
80103870:	8b 08                	mov    (%eax),%ecx
80103872:	83 c0 04             	add    $0x4,%eax
80103875:	03 51 7c             	add    0x7c(%ecx),%edx
  for (int i = 0; i < q0Index; i++) {
80103878:	39 c3                	cmp    %eax,%ebx
8010387a:	75 f4                	jne    80103870 <findRunnableProcLottery.part.2+0x20>
8010387c:	89 d7                	mov    %edx,%edi
  acquire(&tickslock);
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	68 80 5c 11 80       	push   $0x80115c80
80103886:	e8 05 16 00 00       	call   80104e90 <acquire>
  int randomNum = (ticks * ticks) % ticketNums;
8010388b:	a1 c0 64 11 80       	mov    0x801164c0,%eax
80103890:	31 d2                	xor    %edx,%edx
  release(&tickslock);
80103892:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
  int randomNum = (ticks * ticks) % ticketNums;
80103899:	0f af c0             	imul   %eax,%eax
8010389c:	f7 f7                	div    %edi
8010389e:	89 d3                	mov    %edx,%ebx
  release(&tickslock);
801038a0:	e8 ab 16 00 00       	call   80104f50 <release>
  while(randomNum > 0) {
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 db                	test   %ebx,%ebx
801038aa:	7e 24                	jle    801038d0 <findRunnableProcLottery.part.2+0x80>
  int i = 0;
801038ac:	31 c0                	xor    %eax,%eax
801038ae:	66 90                	xchg   %ax,%ax
    randomNum -= queue0[i]->ticket;
801038b0:	8b 14 86             	mov    (%esi,%eax,4),%edx
    i++;
801038b3:	83 c0 01             	add    $0x1,%eax
    randomNum -= queue0[i]->ticket;
801038b6:	2b 5a 7c             	sub    0x7c(%edx),%ebx
  while(randomNum > 0) {
801038b9:	85 db                	test   %ebx,%ebx
801038bb:	7f f3                	jg     801038b0 <findRunnableProcLottery.part.2+0x60>
  return queue0[i-1]->pid;
801038bd:	8b 44 86 fc          	mov    -0x4(%esi,%eax,4),%eax
801038c1:	8b 40 10             	mov    0x10(%eax),%eax
} 
801038c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c7:	5b                   	pop    %ebx
801038c8:	5e                   	pop    %esi
801038c9:	5f                   	pop    %edi
801038ca:	5d                   	pop    %ebp
801038cb:	c3                   	ret    
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return queue0[0]->pid;
801038d0:	8b 06                	mov    (%esi),%eax
801038d2:	8b 40 10             	mov    0x10(%eax),%eax
} 
801038d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d8:	5b                   	pop    %ebx
801038d9:	5e                   	pop    %esi
801038da:	5f                   	pop    %edi
801038db:	5d                   	pop    %ebp
801038dc:	c3                   	ret    
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = 0; i < q0Index; i++) {
801038e0:	31 ff                	xor    %edi,%edi
801038e2:	eb 9a                	jmp    8010387e <findRunnableProcLottery.part.2+0x2e>
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 f5 7f 10 80       	push   $0x80107ff5
801038fb:	68 40 38 11 80       	push   $0x80113840
80103900:	e8 4b 14 00 00       	call   80104d50 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103916:	9c                   	pushf  
80103917:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103918:	f6 c4 02             	test   $0x2,%ah
8010391b:	75 32                	jne    8010394f <mycpu+0x3f>
  apicid = lapicid();
8010391d:	e8 3e ee ff ff       	call   80102760 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103922:	8b 15 30 38 11 80    	mov    0x80113830,%edx
80103928:	85 d2                	test   %edx,%edx
8010392a:	7e 0b                	jle    80103937 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
8010392c:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103933:	39 d0                	cmp    %edx,%eax
80103935:	74 11                	je     80103948 <mycpu+0x38>
  panic("unknown apicid\n");
80103937:	83 ec 0c             	sub    $0xc,%esp
8010393a:	68 fc 7f 10 80       	push   $0x80107ffc
8010393f:	e8 4c ca ff ff       	call   80100390 <panic>
80103944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103948:	b8 80 37 11 80       	mov    $0x80113780,%eax
8010394d:	c9                   	leave  
8010394e:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
8010394f:	83 ec 0c             	sub    $0xc,%esp
80103952:	68 d8 80 10 80       	push   $0x801080d8
80103957:	e8 34 ca ff ff       	call   80100390 <panic>
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 a5 ff ff ff       	call   80103910 <mycpu>
8010396b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103970:	c9                   	leave  
  return mycpu()-cpus;
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	90                   	nop
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 34 14 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010398c:	e8 7f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 64 14 00 00       	call   80104e00 <popcli>
}
8010399c:	83 c4 04             	add    $0x4,%esp
8010399f:	89 d8                	mov    %ebx,%eax
801039a1:	5b                   	pop    %ebx
801039a2:	5d                   	pop    %ebp
801039a3:	c3                   	ret    
801039a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 64 fc ff ff       	call   80103620 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 38 3e 00 00       	call   80107800 <setupkvm>
801039c8:	85 c0                	test   %eax,%eax
801039ca:	89 43 04             	mov    %eax,0x4(%ebx)
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 b4 10 80       	push   $0x8010b460
801039e0:	50                   	push   %eax
801039e1:	e8 fa 3a 00 00       	call   801074e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	pushl  0x18(%ebx)
801039f6:	e8 a5 15 00 00       	call   80104fa0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a03:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a08:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 25 80 10 80       	push   $0x80108025
80103a54:	50                   	push   %eax
80103a55:	e8 26 17 00 00       	call   80105180 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 2e 80 10 80 	movl   $0x8010802e,(%esp)
80103a61:	e8 aa e4 ff ff       	call   80101f10 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103a70:	e8 1b 14 00 00       	call   80104e90 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103a83:	e8 c8 14 00 00       	call   80104f50 <release>
}
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 0c 80 10 80       	push   $0x8010800c
80103a98:	e8 f3 c8 ff ff       	call   80100390 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 13 13 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80103aad:	e8 5e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 43 13 00 00       	call   80104e00 <popcli>
  if(n > 0){
80103abd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ac0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ac2:	7f 1c                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac4:	75 3a                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103acb:	53                   	push   %ebx
80103acc:	e8 ff 38 00 00       	call   801073d0 <switchuvm>
  return 0;
80103ad1:	83 c4 10             	add    $0x10,%esp
80103ad4:	31 c0                	xor    %eax,%eax
}
80103ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad9:	5b                   	pop    %ebx
80103ada:	5e                   	pop    %esi
80103adb:	5d                   	pop    %ebp
80103adc:	c3                   	ret    
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	pushl  0x4(%ebx)
80103aea:	e8 31 3b 00 00       	call   80107620 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 d0                	jne    80103ac6 <growproc+0x26>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d9                	jmp    80103ad6 <growproc+0x36>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	pushl  0x4(%ebx)
80103b0a:	e8 41 3c 00 00       	call   80107750 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 b0                	jne    80103ac6 <growproc+0x26>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	90                   	nop
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 92 12 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80103b2e:	e8 dd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 c2 12 00 00       	call   80104e00 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 dd fa ff ff       	call   80103620 <allocproc>
80103b43:	85 c0                	test   %eax,%eax
80103b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b48:	0f 84 b7 00 00 00    	je     80103c05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	pushl  (%ebx)
80103b53:	ff 73 04             	pushl  0x4(%ebx)
80103b56:	89 c7                	mov    %eax,%edi
80103b58:	e8 73 3d 00 00       	call   801078d0 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	85 c0                	test   %eax,%eax
80103b62:	89 47 04             	mov    %eax,0x4(%edi)
80103b65:	0f 84 a1 00 00 00    	je     80103c0c <fork+0xec>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b72:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b75:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b77:	8b 79 18             	mov    0x18(%ecx),%edi
80103b7a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b7d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 7f d2 ff ff       	call   80100e20 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 bf da ff ff       	call   80101680 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 aa 15 00 00       	call   80105180 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103be0:	e8 ab 12 00 00       	call   80104e90 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103bf3:	e8 58 13 00 00       	call   80104f50 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
    return -1;
80103c05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c0a:	eb ef                	jmp    80103bfb <fork+0xdb>
    kfree(np->kstack);
80103c0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	ff 73 08             	pushl  0x8(%ebx)
80103c15:	e8 26 e7 ff ff       	call   80102340 <kfree>
    np->kstack = 0;
80103c1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c21:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c30:	eb c9                	jmp    80103bfb <fork+0xdb>
80103c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <reverse>:
void reverse(char* str, int len) {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for (int i = 0; i < len / 2; i++) {
80103c48:	89 d9                	mov    %ebx,%ecx
80103c4a:	c1 e9 1f             	shr    $0x1f,%ecx
80103c4d:	01 d9                	add    %ebx,%ecx
80103c4f:	d1 f9                	sar    %ecx
80103c51:	85 c9                	test   %ecx,%ecx
80103c53:	7e 21                	jle    80103c76 <reverse+0x36>
80103c55:	8b 55 08             	mov    0x8(%ebp),%edx
80103c58:	8d 44 1a ff          	lea    -0x1(%edx,%ebx,1),%eax
80103c5c:	89 c6                	mov    %eax,%esi
80103c5e:	29 ce                	sub    %ecx,%esi
    temp = str[i];
80103c60:	0f b6 0a             	movzbl (%edx),%ecx
    str[i] = str[len - i - 1];
80103c63:	0f b6 18             	movzbl (%eax),%ebx
80103c66:	83 e8 01             	sub    $0x1,%eax
80103c69:	83 c2 01             	add    $0x1,%edx
80103c6c:	88 5a ff             	mov    %bl,-0x1(%edx)
    str[len - i - 1] = temp;
80103c6f:	88 48 01             	mov    %cl,0x1(%eax)
  for (int i = 0; i < len / 2; i++) {
80103c72:	39 f0                	cmp    %esi,%eax
80103c74:	75 ea                	jne    80103c60 <reverse+0x20>
}
80103c76:	5b                   	pop    %ebx
80103c77:	5e                   	pop    %esi
80103c78:	5d                   	pop    %ebp
80103c79:	c3                   	ret    
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c80 <itoa>:
char* itoa(int num, char* str) { 
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
80103c84:	8b 45 08             	mov    0x8(%ebp),%eax
80103c87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (num == 0) { 
80103c8a:	85 c0                	test   %eax,%eax
80103c8c:	74 12                	je     80103ca0 <itoa+0x20>
80103c8e:	89 da                	mov    %ebx,%edx
80103c90:	e8 eb fa ff ff       	call   80103780 <itoa.part.1>
} 
80103c95:	89 d8                	mov    %ebx,%eax
80103c97:	5b                   	pop    %ebx
80103c98:	5d                   	pop    %ebp
80103c99:	c3                   	ret    
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        str[i++] = '0'; 
80103ca0:	b8 30 00 00 00       	mov    $0x30,%eax
80103ca5:	66 89 03             	mov    %ax,(%ebx)
} 
80103ca8:	89 d8                	mov    %ebx,%eax
80103caa:	5b                   	pop    %ebx
80103cab:	5d                   	pop    %ebp
80103cac:	c3                   	ret    
80103cad:	8d 76 00             	lea    0x0(%esi),%esi

80103cb0 <ftos>:
char* ftos(float f, char* str) {
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 10             	sub    $0x10,%esp
 	value = (int)f;
80103cb9:	d9 7d f2             	fnstcw -0xe(%ebp)
80103cbc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
char* ftos(float f, char* str) {
80103cc0:	d9 45 08             	flds   0x8(%ebp)
 	value = (int)f;
80103cc3:	80 cc 0c             	or     $0xc,%ah
80103cc6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
80103cca:	d9 6d f0             	fldcw  -0x10(%ebp)
80103ccd:	db 55 ec             	fistl  -0x14(%ebp)
80103cd0:	d9 6d f2             	fldcw  -0xe(%ebp)
80103cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    if (num == 0) { 
80103cd6:	85 c0                	test   %eax,%eax
 	value = (int)f;
80103cd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (num == 0) { 
80103cdb:	75 7b                	jne    80103d58 <ftos+0xa8>
        str[i++] = '0'; 
80103cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce0:	ba 30 00 00 00       	mov    $0x30,%edx
 		++count;
80103ce5:	be 01 00 00 00       	mov    $0x1,%esi
        str[i++] = '0'; 
80103cea:	66 89 10             	mov    %dx,(%eax)
 		++curr;
80103ced:	8d 48 01             	lea    0x1(%eax),%ecx
80103cf0:	89 c2                	mov    %eax,%edx
80103cf2:	31 c0                	xor    %eax,%eax
 	str[count++] = '.';
80103cf4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103cf7:	83 c0 02             	add    $0x2,%eax
 	f = f - (float)value;
80103cfa:	db 45 e8             	fildl  -0x18(%ebp)
 	++curr;
80103cfd:	83 c2 02             	add    $0x2,%edx
 	while(count + 1 < MAXFLOATLEN) {
80103d00:	83 f8 09             	cmp    $0x9,%eax
 	f = f - (float)value;
80103d03:	de e9                	fsubrp %st,%st(1)
 	str[count++] = '.';
80103d05:	c6 04 37 2e          	movb   $0x2e,(%edi,%esi,1)
 	while(count + 1 < MAXFLOATLEN) {
80103d09:	74 13                	je     80103d1e <ftos+0x6e>
80103d0b:	90                   	nop
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 		++count;	
80103d10:	83 c0 01             	add    $0x1,%eax
 		f *= 10;
80103d13:	d8 0d c4 82 10 80    	fmuls  0x801082c4
 	while(count + 1 < MAXFLOATLEN) {
80103d19:	83 f8 09             	cmp    $0x9,%eax
80103d1c:	75 f2                	jne    80103d10 <ftos+0x60>
 	value = (int)f;
80103d1e:	d9 6d f0             	fldcw  -0x10(%ebp)
80103d21:	db 5d ec             	fistpl -0x14(%ebp)
80103d24:	d9 6d f2             	fldcw  -0xe(%ebp)
80103d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
    if (num == 0) { 
80103d2a:	85 c0                	test   %eax,%eax
80103d2c:	0f 85 7e 00 00 00    	jne    80103db0 <ftos+0x100>
        str[i++] = '0'; 
80103d32:	b8 30 00 00 00       	mov    $0x30,%eax
80103d37:	66 89 41 01          	mov    %ax,0x1(%ecx)
80103d3b:	eb 05                	jmp    80103d42 <ftos+0x92>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
80103d40:	dd d8                	fstp   %st(0)
 		str[MAXFLOATLEN - 1] = 0;
80103d42:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d45:	c6 40 09 00          	movb   $0x0,0x9(%eax)
}
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	5b                   	pop    %ebx
80103d4d:	5e                   	pop    %esi
80103d4e:	5f                   	pop    %edi
80103d4f:	5d                   	pop    %ebp
80103d50:	c3                   	ret    
80103d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d5e:	d9 5d e4             	fstps  -0x1c(%ebp)
80103d61:	e8 1a fa ff ff       	call   80103780 <itoa.part.1>
 	while(*curr != 0){
80103d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d69:	d9 45 e4             	flds   -0x1c(%ebp)
80103d6c:	80 38 00             	cmpb   $0x0,(%eax)
80103d6f:	74 57                	je     80103dc8 <ftos+0x118>
80103d71:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103d75:	89 c2                	mov    %eax,%edx
80103d77:	31 c0                	xor    %eax,%eax
80103d79:	eb 0d                	jmp    80103d88 <ftos+0xd8>
80103d7b:	90                   	nop
80103d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d80:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 		++count;
80103d84:	89 f0                	mov    %esi,%eax
 		++curr;
80103d86:	89 ca                	mov    %ecx,%edx
 	while(*curr != 0){
80103d88:	84 db                	test   %bl,%bl
 		++count;
80103d8a:	8d 70 01             	lea    0x1(%eax),%esi
 		++curr;
80103d8d:	8d 4a 01             	lea    0x1(%edx),%ecx
 	while(*curr != 0){
80103d90:	75 ee                	jne    80103d80 <ftos+0xd0>
 	if(count + 1 >= MAXFLOATLEN) {
80103d92:	83 fe 08             	cmp    $0x8,%esi
80103d95:	7f a9                	jg     80103d40 <ftos+0x90>
80103d97:	d9 7d f2             	fnstcw -0xe(%ebp)
80103d9a:	0f b7 7d f2          	movzwl -0xe(%ebp),%edi
80103d9e:	66 81 cf 00 0c       	or     $0xc00,%di
80103da3:	66 89 7d f0          	mov    %di,-0x10(%ebp)
80103da7:	e9 48 ff ff ff       	jmp    80103cf4 <ftos+0x44>
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db0:	e8 cb f9 ff ff       	call   80103780 <itoa.part.1>
 		str[MAXFLOATLEN - 1] = 0;
80103db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
}
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	5b                   	pop    %ebx
80103dc0:	5e                   	pop    %esi
80103dc1:	5f                   	pop    %edi
80103dc2:	5d                   	pop    %ebp
80103dc3:	c3                   	ret    
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
 	f = f - (float)value;
80103dcb:	db 45 e8             	fildl  -0x18(%ebp)
80103dce:	de e9                	fsubrp %st,%st(1)
 	str[count++] = '.';
80103dd0:	c6 00 2e             	movb   $0x2e,(%eax)
80103dd3:	d9 7d f2             	fnstcw -0xe(%ebp)
80103dd6:	0f b7 75 f2          	movzwl -0xe(%ebp),%esi
80103dda:	8d 50 01             	lea    0x1(%eax),%edx
 	f = f - (float)value;
80103ddd:	89 c1                	mov    %eax,%ecx
 	str[count++] = '.';
80103ddf:	b8 01 00 00 00       	mov    $0x1,%eax
 		++count;	
80103de4:	83 c0 01             	add    $0x1,%eax
 		f *= 10;
80103de7:	d8 0d c4 82 10 80    	fmuls  0x801082c4
80103ded:	66 81 ce 00 0c       	or     $0xc00,%si
 	while(count + 1 < MAXFLOATLEN) {
80103df2:	83 f8 09             	cmp    $0x9,%eax
80103df5:	66 89 75 f0          	mov    %si,-0x10(%ebp)
80103df9:	0f 85 11 ff ff ff    	jne    80103d10 <ftos+0x60>
80103dff:	e9 1a ff ff ff       	jmp    80103d1e <ftos+0x6e>
80103e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e10 <findRunnableProcLottery>:
int findRunnableProcLottery (struct proc * queue0[], int q0Index){
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e16:	8b 45 08             	mov    0x8(%ebp),%eax
  if(q0Index == 0)
80103e19:	85 d2                	test   %edx,%edx
80103e1b:	74 06                	je     80103e23 <findRunnableProcLottery+0x13>
} 
80103e1d:	5d                   	pop    %ebp
80103e1e:	e9 2d fa ff ff       	jmp    80103850 <findRunnableProcLottery.part.2>
80103e23:	83 c8 ff             	or     $0xffffffff,%eax
80103e26:	5d                   	pop    %ebp
80103e27:	c3                   	ret    
80103e28:	90                   	nop
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e30 <findRunnableProcHRRN>:
int findRunnableProcHRRN (struct proc * queue1[], int q1Index){
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 28             	sub    $0x28,%esp
80103e39:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&tickslock);
80103e3f:	68 80 5c 11 80       	push   $0x80115c80
int findRunnableProcHRRN (struct proc * queue1[], int q1Index){
80103e44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&tickslock);
80103e47:	e8 44 10 00 00       	call   80104e90 <acquire>
  release(&tickslock);
80103e4c:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
  int currTick = ticks;
80103e53:	8b 35 c0 64 11 80    	mov    0x801164c0,%esi
  release(&tickslock);
80103e59:	e8 f2 10 00 00       	call   80104f50 <release>
  for (int i = 0; i < q1Index; i++){
80103e5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	83 f8 00             	cmp    $0x0,%eax
80103e67:	7e 67                	jle    80103ed0 <findRunnableProcHRRN+0xa0>
  float max = -1;
80103e69:	d9 e8                	fld1   
  int maxIndex = -1;
80103e6b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  for (int i = 0; i < q1Index; i++){
80103e70:	31 d2                	xor    %edx,%edx
  int maxIndex = -1;
80103e72:	89 7d e0             	mov    %edi,-0x20(%ebp)
  float max = -1;
80103e75:	d9 e0                	fchs   
80103e77:	89 f6                	mov    %esi,%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    float waitingTime = (float)(currTick - queue1[i]->ticks);
80103e80:	8b 0c 93             	mov    (%ebx,%edx,4),%ecx
80103e83:	89 f7                	mov    %esi,%edi
80103e85:	2b b9 88 00 00 00    	sub    0x88(%ecx),%edi
80103e8b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80103e8e:	db 45 e4             	fildl  -0x1c(%ebp)
    float HRRN = waitingTime/(float)(queue1[i]->cycleNum);
80103e91:	db 81 84 00 00 00    	fildl  0x84(%ecx)
80103e97:	de f9                	fdivrp %st,%st(1)
    if(HRRN > max) {
80103e99:	db e9                	fucomi %st(1),%st
80103e9b:	76 0b                	jbe    80103ea8 <findRunnableProcHRRN+0x78>
80103e9d:	dd d9                	fstp   %st(1)
80103e9f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103ea2:	eb 06                	jmp    80103eaa <findRunnableProcHRRN+0x7a>
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	dd d8                	fstp   %st(0)
  for (int i = 0; i < q1Index; i++){
80103eaa:	83 c2 01             	add    $0x1,%edx
80103ead:	39 d0                	cmp    %edx,%eax
80103eaf:	75 cf                	jne    80103e80 <findRunnableProcHRRN+0x50>
80103eb1:	dd d8                	fstp   %st(0)
80103eb3:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103eb6:	c1 e7 02             	shl    $0x2,%edi
    return queue1[maxIndex]->pid; 
80103eb9:	8b 04 3b             	mov    (%ebx,%edi,1),%eax
80103ebc:	8b 40 10             	mov    0x10(%eax),%eax
}
80103ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec2:	5b                   	pop    %ebx
80103ec3:	5e                   	pop    %esi
80103ec4:	5f                   	pop    %edi
80103ec5:	5d                   	pop    %ebp
80103ec6:	c3                   	ret    
80103ec7:	89 f6                	mov    %esi,%esi
80103ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(q1Index == 0)
80103ed0:	74 07                	je     80103ed9 <findRunnableProcHRRN+0xa9>
80103ed2:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
80103ed7:	eb e0                	jmp    80103eb9 <findRunnableProcHRRN+0x89>
    return -1;
80103ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ede:	eb df                	jmp    80103ebf <findRunnableProcHRRN+0x8f>

80103ee0 <findRunnableProcSRPF>:
int findRunnableProcSRPF (struct proc * queue2[], int q2Index){
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
80103ee5:	83 ec 08             	sub    $0x8,%esp
80103ee8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  if(q2Index == 0)
80103eee:	83 fb 00             	cmp    $0x0,%ebx
80103ef1:	0f 84 8b 00 00 00    	je     80103f82 <findRunnableProcSRPF+0xa2>
  float min = queue2[0]->remainingPriority;
80103ef7:	8b 0a                	mov    (%edx),%ecx
  for (int i = 0; i < q2Index; i++) {
80103ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  int minIndex = 0;
80103efe:	be 00 00 00 00       	mov    $0x0,%esi
  float min = queue2[0]->remainingPriority;
80103f03:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
  for (int i = 0; i < q2Index; i++) {
80103f09:	7e 42                	jle    80103f4d <findRunnableProcSRPF+0x6d>
80103f0b:	eb 05                	jmp    80103f12 <findRunnableProcSRPF+0x32>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
80103f10:	dd d9                	fstp   %st(1)
80103f12:	83 c0 01             	add    $0x1,%eax
80103f15:	39 c3                	cmp    %eax,%ebx
80103f17:	74 27                	je     80103f40 <findRunnableProcSRPF+0x60>
    if (min > queue2[i]->remainingPriority) {
80103f19:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
80103f1c:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
80103f22:	d9 c9                	fxch   %st(1)
80103f24:	db e9                	fucomi %st(1),%st
80103f26:	76 e8                	jbe    80103f10 <findRunnableProcSRPF+0x30>
80103f28:	dd d8                	fstp   %st(0)
80103f2a:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < q2Index; i++) {
80103f2c:	83 c0 01             	add    $0x1,%eax
80103f2f:	39 c3                	cmp    %eax,%ebx
80103f31:	75 e6                	jne    80103f19 <findRunnableProcSRPF+0x39>
80103f33:	dd d8                	fstp   %st(0)
80103f35:	eb 0b                	jmp    80103f42 <findRunnableProcSRPF+0x62>
80103f37:	89 f6                	mov    %esi,%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103f40:	dd d8                	fstp   %st(0)
80103f42:	8d 14 b2             	lea    (%edx,%esi,4),%edx
80103f45:	8b 0a                	mov    (%edx),%ecx
80103f47:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
  if (queue2[minIndex]->remainingPriority - 0.1 > 0)
80103f4d:	dd 05 c8 82 10 80    	fldl   0x801082c8
80103f53:	de e9                	fsubrp %st,%st(1)
80103f55:	d9 ee                	fldz   
80103f57:	d9 ee                	fldz   
80103f59:	d9 ca                	fxch   %st(2)
80103f5b:	db ea                	fucomi %st(2),%st
80103f5d:	dd da                	fstp   %st(2)
80103f5f:	76 17                	jbe    80103f78 <findRunnableProcSRPF+0x98>
80103f61:	dd d8                	fstp   %st(0)
    queue2[minIndex]->remainingPriority -= 0.1;
80103f63:	d9 99 8c 00 00 00    	fstps  0x8c(%ecx)
  return queue2[minIndex]->pid;
80103f69:	8b 02                	mov    (%edx),%eax
80103f6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80103f6e:	83 c4 08             	add    $0x8,%esp
80103f71:	5b                   	pop    %ebx
80103f72:	5e                   	pop    %esi
80103f73:	5d                   	pop    %ebp
80103f74:	c3                   	ret    
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
80103f78:	dd d9                	fstp   %st(1)
    queue2[minIndex]->remainingPriority = 0;
80103f7a:	d9 99 8c 00 00 00    	fstps  0x8c(%ecx)
80103f80:	eb e7                	jmp    80103f69 <findRunnableProcSRPF+0x89>
    return -1;
80103f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f87:	eb e5                	jmp    80103f6e <findRunnableProcSRPF+0x8e>
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f90 <scheduler>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	81 ec 1c 0c 00 00    	sub    $0xc1c,%esp
  struct cpu *c = mycpu();
80103f9c:	e8 6f f9 ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103fa1:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fa8:	00 00 00 
  struct cpu *c = mycpu();
80103fab:	89 c6                	mov    %eax,%esi
80103fad:	8d 40 04             	lea    0x4(%eax),%eax
80103fb0:	89 85 e0 f3 ff ff    	mov    %eax,-0xc20(%ebp)
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  asm volatile("sti");
80103fc0:	fb                   	sti    
    acquire(&ptable.lock);
80103fc1:	83 ec 0c             	sub    $0xc,%esp
    int q0index = 0, q1index = 0, q2index = 0; 
80103fc4:	31 ff                	xor    %edi,%edi
80103fc6:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80103fc8:	68 40 38 11 80       	push   $0x80113840
80103fcd:	e8 be 0e 00 00       	call   80104e90 <acquire>
80103fd2:	83 c4 10             	add    $0x10,%esp
    int q0index = 0, q1index = 0, q2index = 0; 
80103fd5:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd7:	b8 74 38 11 80       	mov    $0x80113874,%eax
80103fdc:	eb 18                	jmp    80103ff6 <scheduler+0x66>
80103fde:	66 90                	xchg   %ax,%ax
        queue0[q0index] = p;
80103fe0:	89 84 95 e8 f3 ff ff 	mov    %eax,-0xc18(%ebp,%edx,4)
        q0index++;
80103fe7:	83 c2 01             	add    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fea:	05 90 00 00 00       	add    $0x90,%eax
80103fef:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103ff4:	73 3a                	jae    80104030 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103ff6:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ffa:	75 ee                	jne    80103fea <scheduler+0x5a>
      if(p->queueNum == 0){
80103ffc:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104002:	85 c9                	test   %ecx,%ecx
80104004:	74 da                	je     80103fe0 <scheduler+0x50>
      else if(p->queueNum == 1){
80104006:	83 f9 01             	cmp    $0x1,%ecx
80104009:	0f 84 f9 00 00 00    	je     80104108 <scheduler+0x178>
      else if(p->queueNum == 2){
8010400f:	83 f9 02             	cmp    $0x2,%ecx
80104012:	75 d6                	jne    80103fea <scheduler+0x5a>
        queue2[q2index] = p;
80104014:	89 84 bd e8 fb ff ff 	mov    %eax,-0x418(%ebp,%edi,4)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401b:	05 90 00 00 00       	add    $0x90,%eax
        q2index++;
80104020:	83 c7 01             	add    $0x1,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104023:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104028:	72 cc                	jb     80103ff6 <scheduler+0x66>
8010402a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	89 95 e4 f3 ff ff    	mov    %edx,-0xc1c(%ebp)
80104039:	68 40 38 11 80       	push   $0x80113840
8010403e:	e8 0d 0f 00 00       	call   80104f50 <release>
  if(q0Index == 0)
80104043:	8b 95 e4 f3 ff ff    	mov    -0xc1c(%ebp),%edx
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	85 d2                	test   %edx,%edx
8010404e:	74 0f                	je     8010405f <scheduler+0xcf>
80104050:	8d 85 e8 f3 ff ff    	lea    -0xc18(%ebp),%eax
80104056:	e8 f5 f7 ff ff       	call   80103850 <findRunnableProcLottery.part.2>
    if ((pid = findRunnableProcLottery(queue0, q0index)) < 0) 
8010405b:	85 c0                	test   %eax,%eax
8010405d:	79 1b                	jns    8010407a <scheduler+0xea>
      if ((pid = findRunnableProcHRRN(queue1, q1index)) < 0) 
8010405f:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
80104065:	83 ec 08             	sub    $0x8,%esp
80104068:	53                   	push   %ebx
80104069:	50                   	push   %eax
8010406a:	e8 c1 fd ff ff       	call   80103e30 <findRunnableProcHRRN>
8010406f:	83 c4 10             	add    $0x10,%esp
80104072:	85 c0                	test   %eax,%eax
80104074:	0f 88 9d 00 00 00    	js     80104117 <scheduler+0x187>
    acquire(&ptable.lock);
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	89 85 e4 f3 ff ff    	mov    %eax,-0xc1c(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104083:	bb 74 38 11 80       	mov    $0x80113874,%ebx
    acquire(&ptable.lock);
80104088:	68 40 38 11 80       	push   $0x80113840
8010408d:	e8 fe 0d 00 00       	call   80104e90 <acquire>
80104092:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104095:	8b 85 e4 f3 ff ff    	mov    -0xc1c(%ebp),%eax
8010409b:	eb 11                	jmp    801040ae <scheduler+0x11e>
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
801040a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801040a6:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
801040ac:	73 05                	jae    801040b3 <scheduler+0x123>
      if (pid == p->pid)
801040ae:	39 43 10             	cmp    %eax,0x10(%ebx)
801040b1:	75 ed                	jne    801040a0 <scheduler+0x110>
    p->cycleNum ++;
801040b3:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
    switchuvm(p);
801040ba:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
801040bd:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    switchuvm(p);
801040c3:	53                   	push   %ebx
801040c4:	e8 07 33 00 00       	call   801073d0 <switchuvm>
    p->state = RUNNING;
801040c9:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    swtch(&(c->scheduler), p->context);
801040d0:	58                   	pop    %eax
801040d1:	5a                   	pop    %edx
801040d2:	ff 73 1c             	pushl  0x1c(%ebx)
801040d5:	ff b5 e0 f3 ff ff    	pushl  -0xc20(%ebp)
801040db:	e8 fb 10 00 00       	call   801051db <swtch>
    switchkvm();
801040e0:	e8 cb 32 00 00       	call   801073b0 <switchkvm>
    c->proc = 0;
801040e5:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801040ec:	00 00 00 
    release(&ptable.lock);
801040ef:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
801040f6:	e8 55 0e 00 00       	call   80104f50 <release>
801040fb:	83 c4 10             	add    $0x10,%esp
801040fe:	e9 bd fe ff ff       	jmp    80103fc0 <scheduler+0x30>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        queue1[q1index] = p;
80104108:	89 84 9d e8 f7 ff ff 	mov    %eax,-0x818(%ebp,%ebx,4)
        q1index++;
8010410f:	83 c3 01             	add    $0x1,%ebx
80104112:	e9 d3 fe ff ff       	jmp    80103fea <scheduler+0x5a>
        if ((pid = findRunnableProcSRPF(queue2, q2index)) < 0)
80104117:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
8010411d:	83 ec 08             	sub    $0x8,%esp
80104120:	57                   	push   %edi
80104121:	50                   	push   %eax
80104122:	e8 b9 fd ff ff       	call   80103ee0 <findRunnableProcSRPF>
80104127:	83 c4 10             	add    $0x10,%esp
8010412a:	85 c0                	test   %eax,%eax
8010412c:	0f 89 48 ff ff ff    	jns    8010407a <scheduler+0xea>
80104132:	e9 89 fe ff ff       	jmp    80103fc0 <scheduler+0x30>
80104137:	89 f6                	mov    %esi,%esi
80104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104140 <sched>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
  pushcli();
80104145:	e8 76 0c 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010414a:	e8 c1 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010414f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104155:	e8 a6 0c 00 00       	call   80104e00 <popcli>
  if(!holding(&ptable.lock))
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 40 38 11 80       	push   $0x80113840
80104162:	e8 f9 0c 00 00       	call   80104e60 <holding>
80104167:	83 c4 10             	add    $0x10,%esp
8010416a:	85 c0                	test   %eax,%eax
8010416c:	74 4f                	je     801041bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010416e:	e8 9d f7 ff ff       	call   80103910 <mycpu>
80104173:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010417a:	75 68                	jne    801041e4 <sched+0xa4>
  if(p->state == RUNNING)
8010417c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104180:	74 55                	je     801041d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104182:	9c                   	pushf  
80104183:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104184:	f6 c4 02             	test   $0x2,%ah
80104187:	75 41                	jne    801041ca <sched+0x8a>
  intena = mycpu()->intena;
80104189:	e8 82 f7 ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010418e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104191:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104197:	e8 74 f7 ff ff       	call   80103910 <mycpu>
8010419c:	83 ec 08             	sub    $0x8,%esp
8010419f:	ff 70 04             	pushl  0x4(%eax)
801041a2:	53                   	push   %ebx
801041a3:	e8 33 10 00 00       	call   801051db <swtch>
  mycpu()->intena = intena;
801041a8:	e8 63 f7 ff ff       	call   80103910 <mycpu>
}
801041ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041b9:	5b                   	pop    %ebx
801041ba:	5e                   	pop    %esi
801041bb:	5d                   	pop    %ebp
801041bc:	c3                   	ret    
    panic("sched ptable.lock");
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 30 80 10 80       	push   $0x80108030
801041c5:	e8 c6 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 5c 80 10 80       	push   $0x8010805c
801041d2:	e8 b9 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
801041d7:	83 ec 0c             	sub    $0xc,%esp
801041da:	68 4e 80 10 80       	push   $0x8010804e
801041df:	e8 ac c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	68 42 80 10 80       	push   $0x80108042
801041ec:	e8 9f c1 ff ff       	call   80100390 <panic>
801041f1:	eb 0d                	jmp    80104200 <exit>
801041f3:	90                   	nop
801041f4:	90                   	nop
801041f5:	90                   	nop
801041f6:	90                   	nop
801041f7:	90                   	nop
801041f8:	90                   	nop
801041f9:	90                   	nop
801041fa:	90                   	nop
801041fb:	90                   	nop
801041fc:	90                   	nop
801041fd:	90                   	nop
801041fe:	90                   	nop
801041ff:	90                   	nop

80104200 <exit>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	53                   	push   %ebx
80104206:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104209:	e8 b2 0b 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010420e:	e8 fd f6 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104213:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104219:	e8 e2 0b 00 00       	call   80104e00 <popcli>
  if(curproc == initproc)
8010421e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104224:	8d 5e 28             	lea    0x28(%esi),%ebx
80104227:	8d 7e 68             	lea    0x68(%esi),%edi
8010422a:	0f 84 f1 00 00 00    	je     80104321 <exit+0x121>
    if(curproc->ofile[fd]){
80104230:	8b 03                	mov    (%ebx),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	74 12                	je     80104248 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	50                   	push   %eax
8010423a:	e8 31 cc ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
8010423f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104245:	83 c4 10             	add    $0x10,%esp
80104248:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010424b:	39 fb                	cmp    %edi,%ebx
8010424d:	75 e1                	jne    80104230 <exit+0x30>
  begin_op();
8010424f:	e8 7c e9 ff ff       	call   80102bd0 <begin_op>
  iput(curproc->cwd);
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	ff 76 68             	pushl  0x68(%esi)
8010425a:	e8 81 d5 ff ff       	call   801017e0 <iput>
  end_op();
8010425f:	e8 dc e9 ff ff       	call   80102c40 <end_op>
  curproc->cwd = 0;
80104264:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010426b:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104272:	e8 19 0c 00 00       	call   80104e90 <acquire>
  wakeup1(curproc->parent);
80104277:	8b 56 14             	mov    0x14(%esi),%edx
8010427a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427d:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104282:	eb 10                	jmp    80104294 <exit+0x94>
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104288:	05 90 00 00 00       	add    $0x90,%eax
8010428d:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104292:	73 1e                	jae    801042b2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104294:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104298:	75 ee                	jne    80104288 <exit+0x88>
8010429a:	3b 50 20             	cmp    0x20(%eax),%edx
8010429d:	75 e9                	jne    80104288 <exit+0x88>
      p->state = RUNNABLE;
8010429f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a6:	05 90 00 00 00       	add    $0x90,%eax
801042ab:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801042b0:	72 e2                	jb     80104294 <exit+0x94>
      p->parent = initproc;
801042b2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	ba 74 38 11 80       	mov    $0x80113874,%edx
801042bd:	eb 0f                	jmp    801042ce <exit+0xce>
801042bf:	90                   	nop
801042c0:	81 c2 90 00 00 00    	add    $0x90,%edx
801042c6:	81 fa 74 5c 11 80    	cmp    $0x80115c74,%edx
801042cc:	73 3a                	jae    80104308 <exit+0x108>
    if(p->parent == curproc){
801042ce:	39 72 14             	cmp    %esi,0x14(%edx)
801042d1:	75 ed                	jne    801042c0 <exit+0xc0>
      if(p->state == ZOMBIE)
801042d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801042d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801042da:	75 e4                	jne    801042c0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042dc:	b8 74 38 11 80       	mov    $0x80113874,%eax
801042e1:	eb 11                	jmp    801042f4 <exit+0xf4>
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	05 90 00 00 00       	add    $0x90,%eax
801042ed:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801042f2:	73 cc                	jae    801042c0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801042f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042f8:	75 ee                	jne    801042e8 <exit+0xe8>
801042fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801042fd:	75 e9                	jne    801042e8 <exit+0xe8>
      p->state = RUNNABLE;
801042ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104306:	eb e0                	jmp    801042e8 <exit+0xe8>
  curproc->state = ZOMBIE;
80104308:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010430f:	e8 2c fe ff ff       	call   80104140 <sched>
  panic("zombie exit");
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	68 7d 80 10 80       	push   $0x8010807d
8010431c:	e8 6f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	68 70 80 10 80       	push   $0x80108070
80104329:	e8 62 c0 ff ff       	call   80100390 <panic>
8010432e:	66 90                	xchg   %ax,%ax

80104330 <yield>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104337:	68 40 38 11 80       	push   $0x80113840
8010433c:	e8 4f 0b 00 00       	call   80104e90 <acquire>
  pushcli();
80104341:	e8 7a 0a 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80104346:	e8 c5 f5 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010434b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104351:	e8 aa 0a 00 00       	call   80104e00 <popcli>
  myproc()->state = RUNNABLE;
80104356:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010435d:	e8 de fd ff ff       	call   80104140 <sched>
  release(&ptable.lock);
80104362:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104369:	e8 e2 0b 00 00       	call   80104f50 <release>
}
8010436e:	83 c4 10             	add    $0x10,%esp
80104371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104374:	c9                   	leave  
80104375:	c3                   	ret    
80104376:	8d 76 00             	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <sleep>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	83 ec 0c             	sub    $0xc,%esp
80104389:	8b 7d 08             	mov    0x8(%ebp),%edi
8010438c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010438f:	e8 2c 0a 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80104394:	e8 77 f5 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104399:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010439f:	e8 5c 0a 00 00       	call   80104e00 <popcli>
  if(p == 0)
801043a4:	85 db                	test   %ebx,%ebx
801043a6:	0f 84 87 00 00 00    	je     80104433 <sleep+0xb3>
  if(lk == 0)
801043ac:	85 f6                	test   %esi,%esi
801043ae:	74 76                	je     80104426 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043b0:	81 fe 40 38 11 80    	cmp    $0x80113840,%esi
801043b6:	74 50                	je     80104408 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	68 40 38 11 80       	push   $0x80113840
801043c0:	e8 cb 0a 00 00       	call   80104e90 <acquire>
    release(lk);
801043c5:	89 34 24             	mov    %esi,(%esp)
801043c8:	e8 83 0b 00 00       	call   80104f50 <release>
  p->chan = chan;
801043cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043d7:	e8 64 fd ff ff       	call   80104140 <sched>
  p->chan = 0;
801043dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043e3:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
801043ea:	e8 61 0b 00 00       	call   80104f50 <release>
    acquire(lk);
801043ef:	89 75 08             	mov    %esi,0x8(%ebp)
801043f2:	83 c4 10             	add    $0x10,%esp
}
801043f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043f8:	5b                   	pop    %ebx
801043f9:	5e                   	pop    %esi
801043fa:	5f                   	pop    %edi
801043fb:	5d                   	pop    %ebp
    acquire(lk);
801043fc:	e9 8f 0a 00 00       	jmp    80104e90 <acquire>
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104408:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010440b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104412:	e8 29 fd ff ff       	call   80104140 <sched>
  p->chan = 0;
80104417:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010441e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104421:	5b                   	pop    %ebx
80104422:	5e                   	pop    %esi
80104423:	5f                   	pop    %edi
80104424:	5d                   	pop    %ebp
80104425:	c3                   	ret    
    panic("sleep without lk");
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	68 8f 80 10 80       	push   $0x8010808f
8010442e:	e8 5d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	68 89 80 10 80       	push   $0x80108089
8010443b:	e8 50 bf ff ff       	call   80100390 <panic>

80104440 <wait>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
  pushcli();
80104445:	e8 76 09 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010444a:	e8 c1 f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010444f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104455:	e8 a6 09 00 00       	call   80104e00 <popcli>
  acquire(&ptable.lock);
8010445a:	83 ec 0c             	sub    $0xc,%esp
8010445d:	68 40 38 11 80       	push   $0x80113840
80104462:	e8 29 0a 00 00       	call   80104e90 <acquire>
80104467:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010446a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010446c:	bb 74 38 11 80       	mov    $0x80113874,%ebx
80104471:	eb 13                	jmp    80104486 <wait+0x46>
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104478:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010447e:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104484:	73 1e                	jae    801044a4 <wait+0x64>
      if(p->parent != curproc)
80104486:	39 73 14             	cmp    %esi,0x14(%ebx)
80104489:	75 ed                	jne    80104478 <wait+0x38>
      if(p->state == ZOMBIE){
8010448b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010448f:	74 37                	je     801044c8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104491:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80104497:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010449c:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
801044a2:	72 e2                	jb     80104486 <wait+0x46>
    if(!havekids || curproc->killed){
801044a4:	85 c0                	test   %eax,%eax
801044a6:	74 76                	je     8010451e <wait+0xde>
801044a8:	8b 46 24             	mov    0x24(%esi),%eax
801044ab:	85 c0                	test   %eax,%eax
801044ad:	75 6f                	jne    8010451e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044af:	83 ec 08             	sub    $0x8,%esp
801044b2:	68 40 38 11 80       	push   $0x80113840
801044b7:	56                   	push   %esi
801044b8:	e8 c3 fe ff ff       	call   80104380 <sleep>
    havekids = 0;
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	eb a8                	jmp    8010446a <wait+0x2a>
801044c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801044ce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044d1:	e8 6a de ff ff       	call   80102340 <kfree>
        freevm(p->pgdir);
801044d6:	5a                   	pop    %edx
801044d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801044da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044e1:	e8 9a 32 00 00       	call   80107780 <freevm>
        release(&ptable.lock);
801044e6:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
        p->pid = 0;
801044ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104506:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010450d:	e8 3e 0a 00 00       	call   80104f50 <release>
        return pid;
80104512:	83 c4 10             	add    $0x10,%esp
}
80104515:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104518:	89 f0                	mov    %esi,%eax
8010451a:	5b                   	pop    %ebx
8010451b:	5e                   	pop    %esi
8010451c:	5d                   	pop    %ebp
8010451d:	c3                   	ret    
      release(&ptable.lock);
8010451e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104521:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104526:	68 40 38 11 80       	push   $0x80113840
8010452b:	e8 20 0a 00 00       	call   80104f50 <release>
      return -1;
80104530:	83 c4 10             	add    $0x10,%esp
80104533:	eb e0                	jmp    80104515 <wait+0xd5>
80104535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104540 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 10             	sub    $0x10,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010454a:	68 40 38 11 80       	push   $0x80113840
8010454f:	e8 3c 09 00 00       	call   80104e90 <acquire>
80104554:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104557:	b8 74 38 11 80       	mov    $0x80113874,%eax
8010455c:	eb 0e                	jmp    8010456c <wakeup+0x2c>
8010455e:	66 90                	xchg   %ax,%ax
80104560:	05 90 00 00 00       	add    $0x90,%eax
80104565:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010456a:	73 1e                	jae    8010458a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010456c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104570:	75 ee                	jne    80104560 <wakeup+0x20>
80104572:	3b 58 20             	cmp    0x20(%eax),%ebx
80104575:	75 e9                	jne    80104560 <wakeup+0x20>
      p->state = RUNNABLE;
80104577:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010457e:	05 90 00 00 00       	add    $0x90,%eax
80104583:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104588:	72 e2                	jb     8010456c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010458a:	c7 45 08 40 38 11 80 	movl   $0x80113840,0x8(%ebp)
}
80104591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104594:	c9                   	leave  
  release(&ptable.lock);
80104595:	e9 b6 09 00 00       	jmp    80104f50 <release>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045aa:	68 40 38 11 80       	push   $0x80113840
801045af:	e8 dc 08 00 00       	call   80104e90 <acquire>
801045b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b7:	b8 74 38 11 80       	mov    $0x80113874,%eax
801045bc:	eb 0e                	jmp    801045cc <kill+0x2c>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	05 90 00 00 00       	add    $0x90,%eax
801045c5:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801045ca:	73 34                	jae    80104600 <kill+0x60>
    if(p->pid == pid){
801045cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045cf:	75 ef                	jne    801045c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801045d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801045dc:	75 07                	jne    801045e5 <kill+0x45>
        p->state = RUNNABLE;
801045de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	68 40 38 11 80       	push   $0x80113840
801045ed:	e8 5e 09 00 00       	call   80104f50 <release>
      return 0;
801045f2:	83 c4 10             	add    $0x10,%esp
801045f5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801045f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045fa:	c9                   	leave  
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	68 40 38 11 80       	push   $0x80113840
80104608:	e8 43 09 00 00       	call   80104f50 <release>
  return -1;
8010460d:	83 c4 10             	add    $0x10,%esp
80104610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104618:	c9                   	leave  
80104619:	c3                   	ret    
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104620 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104629:	bb 74 38 11 80       	mov    $0x80113874,%ebx
{
8010462e:	83 ec 3c             	sub    $0x3c,%esp
80104631:	eb 27                	jmp    8010465a <procdump+0x3a>
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 e7 85 10 80       	push   $0x801085e7
80104640:	e8 1b c0 ff ff       	call   80100660 <cprintf>
80104645:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104648:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010464e:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104654:	0f 83 86 00 00 00    	jae    801046e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010465a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010465d:	85 c0                	test   %eax,%eax
8010465f:	74 e7                	je     80104648 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104661:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104664:	ba a0 80 10 80       	mov    $0x801080a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104669:	77 11                	ja     8010467c <procdump+0x5c>
8010466b:	8b 14 85 ac 82 10 80 	mov    -0x7fef7d54(,%eax,4),%edx
      state = "???";
80104672:	b8 a0 80 10 80       	mov    $0x801080a0,%eax
80104677:	85 d2                	test   %edx,%edx
80104679:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010467c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010467f:	50                   	push   %eax
80104680:	52                   	push   %edx
80104681:	ff 73 10             	pushl  0x10(%ebx)
80104684:	68 a4 80 10 80       	push   $0x801080a4
80104689:	e8 d2 bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104695:	75 a1                	jne    80104638 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104697:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010469a:	83 ec 08             	sub    $0x8,%esp
8010469d:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046a0:	50                   	push   %eax
801046a1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801046a4:	8b 40 0c             	mov    0xc(%eax),%eax
801046a7:	83 c0 08             	add    $0x8,%eax
801046aa:	50                   	push   %eax
801046ab:	e8 c0 06 00 00       	call   80104d70 <getcallerpcs>
801046b0:	83 c4 10             	add    $0x10,%esp
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801046b8:	8b 17                	mov    (%edi),%edx
801046ba:	85 d2                	test   %edx,%edx
801046bc:	0f 84 76 ff ff ff    	je     80104638 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046c2:	83 ec 08             	sub    $0x8,%esp
801046c5:	83 c7 04             	add    $0x4,%edi
801046c8:	52                   	push   %edx
801046c9:	68 e1 7a 10 80       	push   $0x80107ae1
801046ce:	e8 8d bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046d3:	83 c4 10             	add    $0x10,%esp
801046d6:	39 fe                	cmp    %edi,%esi
801046d8:	75 de                	jne    801046b8 <procdump+0x98>
801046da:	e9 59 ff ff ff       	jmp    80104638 <procdump+0x18>
801046df:	90                   	nop
  }
}
801046e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046e3:	5b                   	pop    %ebx
801046e4:	5e                   	pop    %esi
801046e5:	5f                   	pop    %edi
801046e6:	5d                   	pop    %ebp
801046e7:	c3                   	ret    
801046e8:	90                   	nop
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <changeQueueNum>:

int
changeQueueNum(int pid , int queue) {
801046f0:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046f1:	b8 74 38 11 80       	mov    $0x80113874,%eax
changeQueueNum(int pid , int queue) {
801046f6:	89 e5                	mov    %esp,%ebp
801046f8:	8b 55 08             	mov    0x8(%ebp),%edx
801046fb:	eb 0f                	jmp    8010470c <changeQueueNum+0x1c>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104700:	05 90 00 00 00       	add    $0x90,%eax
80104705:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010470a:	73 1c                	jae    80104728 <changeQueueNum+0x38>
    if (p->pid == pid) {
8010470c:	39 50 10             	cmp    %edx,0x10(%eax)
8010470f:	75 ef                	jne    80104700 <changeQueueNum+0x10>
      p->queueNum = queue;
80104711:	8b 55 0c             	mov    0xc(%ebp),%edx
80104714:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      return 1;
8010471a:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return -1;
}
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80104728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010472d:	5d                   	pop    %ebp
8010472e:	c3                   	ret    
8010472f:	90                   	nop

80104730 <evalTicket>:

int evalTicket(int pid, int ticket) {
80104730:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104731:	b8 74 38 11 80       	mov    $0x80113874,%eax
int evalTicket(int pid, int ticket) {
80104736:	89 e5                	mov    %esp,%ebp
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	eb 0f                	jmp    8010474c <evalTicket+0x1c>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104740:	05 90 00 00 00       	add    $0x90,%eax
80104745:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010474a:	73 14                	jae    80104760 <evalTicket+0x30>
    if (p->pid == pid) {
8010474c:	39 50 10             	cmp    %edx,0x10(%eax)
8010474f:	75 ef                	jne    80104740 <evalTicket+0x10>
      p->ticket = ticket;
80104751:	8b 55 0c             	mov    0xc(%ebp),%edx
80104754:	89 50 7c             	mov    %edx,0x7c(%eax)
      return 1;
80104757:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return -1;
}
8010475c:	5d                   	pop    %ebp
8010475d:	c3                   	ret    
8010475e:	66 90                	xchg   %ax,%ax
  return -1;
80104760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104765:	5d                   	pop    %ebp
80104766:	c3                   	ret    
80104767:	89 f6                	mov    %esi,%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <stof>:

float stof(char* s) {
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 04             	sub    $0x4,%esp
80104776:	8b 55 08             	mov    0x8(%ebp),%edx
  float rez = 0, fact = 1;
  if (*s == '-'){
80104779:	0f be 02             	movsbl (%edx),%eax
8010477c:	3c 2d                	cmp    $0x2d,%al
8010477e:	74 60                	je     801047e0 <stof+0x70>
    s++;
    fact = -1;
  };
  for (int point_seen = 0; *s; s++){
80104780:	84 c0                	test   %al,%al
80104782:	d9 e8                	fld1   
80104784:	74 69                	je     801047ef <stof+0x7f>
80104786:	31 c9                	xor    %ecx,%ecx
80104788:	d9 ee                	fldz   
8010478a:	eb 34                	jmp    801047c0 <stof+0x50>
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*s == '.'){
      point_seen = 1; 
      continue;
    };
    int d = *s - '0';
80104790:	83 e8 30             	sub    $0x30,%eax
    if (d >= 0 && d <= 9){
80104793:	83 f8 09             	cmp    $0x9,%eax
80104796:	77 1e                	ja     801047b6 <stof+0x46>
      if (point_seen) fact /= 10.0f;
80104798:	85 c9                	test   %ecx,%ecx
8010479a:	74 0a                	je     801047a6 <stof+0x36>
8010479c:	d9 c9                	fxch   %st(1)
8010479e:	d8 35 c4 82 10 80    	fdivs  0x801082c4
801047a4:	d9 c9                	fxch   %st(1)
      rez = rez * 10.0f + (float)d;
801047a6:	d9 05 c4 82 10 80    	flds   0x801082c4
801047ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801047af:	de c9                	fmulp  %st,%st(1)
801047b1:	db 45 fc             	fildl  -0x4(%ebp)
801047b4:	de c1                	faddp  %st,%st(1)
  for (int point_seen = 0; *s; s++){
801047b6:	83 c2 01             	add    $0x1,%edx
801047b9:	0f be 02             	movsbl (%edx),%eax
801047bc:	84 c0                	test   %al,%al
801047be:	74 13                	je     801047d3 <stof+0x63>
    if (*s == '.'){
801047c0:	3c 2e                	cmp    $0x2e,%al
801047c2:	75 cc                	jne    80104790 <stof+0x20>
  for (int point_seen = 0; *s; s++){
801047c4:	83 c2 01             	add    $0x1,%edx
801047c7:	0f be 02             	movsbl (%edx),%eax
      point_seen = 1; 
801047ca:	b9 01 00 00 00       	mov    $0x1,%ecx
  for (int point_seen = 0; *s; s++){
801047cf:	84 c0                	test   %al,%al
801047d1:	75 ed                	jne    801047c0 <stof+0x50>
    };
  };
  return rez * fact;
801047d3:	de c9                	fmulp  %st,%st(1)
}
801047d5:	c9                   	leave  
801047d6:	c3                   	ret    
801047d7:	89 f6                	mov    %esi,%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047e0:	0f be 42 01          	movsbl 0x1(%edx),%eax
    fact = -1;
801047e4:	d9 e8                	fld1   
    s++;
801047e6:	83 c2 01             	add    $0x1,%edx
    fact = -1;
801047e9:	d9 e0                	fchs   
  for (int point_seen = 0; *s; s++){
801047eb:	84 c0                	test   %al,%al
801047ed:	75 97                	jne    80104786 <stof+0x16>
801047ef:	d9 ee                	fldz   
}
801047f1:	c9                   	leave  
  return rez * fact;
801047f2:	de c9                	fmulp  %st,%st(1)
}
801047f4:	c3                   	ret    
801047f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <evalRemainingPriority>:

int evalRemainingPriority(int pid, char* priority) {
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
  float pri = stof(priority);
80104804:	ff 75 0c             	pushl  0xc(%ebp)
int evalRemainingPriority(int pid, char* priority) {
80104807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  float pri = stof(priority);
8010480a:	e8 61 ff ff ff       	call   80104770 <stof>
8010480f:	58                   	pop    %eax
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104810:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104815:	eb 15                	jmp    8010482c <evalRemainingPriority+0x2c>
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104820:	05 90 00 00 00       	add    $0x90,%eax
80104825:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010482a:	73 1c                	jae    80104848 <evalRemainingPriority+0x48>
    if (p->pid == pid) {
8010482c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010482f:	75 ef                	jne    80104820 <evalRemainingPriority+0x20>
      p->remainingPriority = pri;
80104831:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      return 1;
80104837:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return -1;
}
8010483c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010483f:	c9                   	leave  
80104840:	c3                   	ret    
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104848:	dd d8                	fstp   %st(0)
  return -1;
8010484a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010484f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104852:	c9                   	leave  
80104853:	c3                   	ret    
80104854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010485a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104860 <generateHRRN>:

char* generateHRRN(struct proc *p, char* out) {
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  float hrrnTime;
  float waitingTime;
  waitingTime = (ticks - p->ticks) / 100;
80104865:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
char* generateHRRN(struct proc *p, char* out) {
8010486a:	83 ec 04             	sub    $0x4,%esp
8010486d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104870:	8b 4d 08             	mov    0x8(%ebp),%ecx
  waitingTime = (ticks - p->ticks) / 100;
80104873:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
  ftos(hrrnTime, out);
80104879:	53                   	push   %ebx
  waitingTime = (ticks - p->ticks) / 100;
8010487a:	2b 91 88 00 00 00    	sub    0x88(%ecx),%edx
  ftos(hrrnTime, out);
80104880:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104883:	89 d0                	mov    %edx,%eax
80104885:	f7 e6                	mul    %esi
80104887:	c1 ea 05             	shr    $0x5,%edx
8010488a:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010488d:	db 45 f4             	fildl  -0xc(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104890:	db 81 84 00 00 00    	fildl  0x84(%ecx)
80104896:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104898:	d9 1c 24             	fstps  (%esp)
8010489b:	e8 10 f4 ff ff       	call   80103cb0 <ftos>
  return out;
}
801048a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a3:	89 d8                	mov    %ebx,%eax
801048a5:	5b                   	pop    %ebx
801048a6:	5e                   	pop    %esi
801048a7:	5d                   	pop    %ebp
801048a8:	c3                   	ret    
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <printInfo>:


int printInfo(void) {
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	56                   	push   %esi
801048b5:	53                   	push   %ebx
801048b6:	83 ec 38             	sub    $0x38,%esp
  asm volatile("sti");
801048b9:	fb                   	sti    
  char out[6];
  struct proc *p;
  sti();
  acquire(&ptable.lock);
801048ba:	68 40 38 11 80       	push   $0x80113840
  cprintf("---------------------------------------------------------------------");
  cprintf("---------------------------------------------------------------------\n");
  cprintf("name\t\tpid\t\tstate\t\tqueueNum\tpriority\ttickets\t\tcycles\t\tHRRN\t\ttimeCreated\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048bf:	bb 74 38 11 80       	mov    $0x80113874,%ebx
  ftos(hrrnTime, out);
801048c4:	8d 75 d8             	lea    -0x28(%ebp),%esi
  acquire(&ptable.lock);
801048c7:	e8 c4 05 00 00       	call   80104e90 <acquire>
  cprintf("---------------------------------------------------------------------");
801048cc:	c7 04 24 00 81 10 80 	movl   $0x80108100,(%esp)
801048d3:	e8 88 bd ff ff       	call   80100660 <cprintf>
  cprintf("---------------------------------------------------------------------\n");
801048d8:	c7 04 24 48 81 10 80 	movl   $0x80108148,(%esp)
801048df:	e8 7c bd ff ff       	call   80100660 <cprintf>
  cprintf("name\t\tpid\t\tstate\t\tqueueNum\tpriority\ttickets\t\tcycles\t\tHRRN\t\ttimeCreated\n");
801048e4:	c7 04 24 90 81 10 80 	movl   $0x80108190,(%esp)
801048eb:	e8 70 bd ff ff       	call   80100660 <cprintf>
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	eb 39                	jmp    8010492e <printInfo+0x7e>
801048f5:	8d 76 00             	lea    0x0(%esi),%esi
    char str[MAXFLOATLEN];
    if (p->state == EMBRYO)
      cprintf("%s\t\t%d\t\tEMBRYO\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == SLEEPING)
801048f8:	83 f8 02             	cmp    $0x2,%eax
801048fb:	0f 84 bd 00 00 00    	je     801049be <printInfo+0x10e>
      cprintf("%s\t\t%d\t\tSLEEPING\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == RUNNABLE)
80104901:	83 f8 03             	cmp    $0x3,%eax
80104904:	0f 84 3c 01 00 00    	je     80104a46 <printInfo+0x196>
      cprintf("%s\t\t%d\t\tRUNNABLE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == RUNNING)
8010490a:	83 f8 04             	cmp    $0x4,%eax
8010490d:	0f 84 bb 01 00 00    	je     80104ace <printInfo+0x21e>
      cprintf("%s\t\t%d\t\tRUNNING\t\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == ZOMBIE)
80104913:	83 f8 05             	cmp    $0x5,%eax
80104916:	0f 84 3a 02 00 00    	je     80104b56 <printInfo+0x2a6>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010491c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104922:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104928:	0f 83 b6 02 00 00    	jae    80104be4 <printInfo+0x334>
    if (p->state == EMBRYO)
8010492e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104931:	83 f8 01             	cmp    $0x1,%eax
80104934:	75 c2                	jne    801048f8 <printInfo+0x48>
      cprintf("%s\t\t%d\t\tEMBRYO\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104936:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  waitingTime = (ticks - p->ticks) / 100;
8010493c:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104942:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  ftos(hrrnTime, out);
80104947:	83 ec 08             	sub    $0x8,%esp
8010494a:	56                   	push   %esi
  waitingTime = (ticks - p->ticks) / 100;
8010494b:	29 fa                	sub    %edi,%edx
8010494d:	f7 e2                	mul    %edx
  ftos(hrrnTime, out);
8010494f:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104952:	c1 ea 05             	shr    $0x5,%edx
80104955:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104958:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
8010495b:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104961:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104963:	d9 1c 24             	fstps  (%esp)
80104966:	e8 45 f3 ff ff       	call   80103cb0 <ftos>
      cprintf("%s\t\t%d\t\tEMBRYO\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
8010496b:	8b 53 7c             	mov    0x7c(%ebx),%edx
8010496e:	58                   	pop    %eax
8010496f:	8d 45 de             	lea    -0x22(%ebp),%eax
80104972:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104978:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010497b:	5a                   	pop    %edx
8010497c:	50                   	push   %eax
8010497d:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104983:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104986:	e8 25 f3 ff ff       	call   80103cb0 <ftos>
8010498b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010498e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104991:	89 3c 24             	mov    %edi,(%esp)
80104994:	56                   	push   %esi
80104995:	51                   	push   %ecx
80104996:	52                   	push   %edx
80104997:	50                   	push   %eax
80104998:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010499b:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801049a1:	ff 73 10             	pushl  0x10(%ebx)
801049a4:	50                   	push   %eax
801049a5:	68 d8 81 10 80       	push   $0x801081d8
801049aa:	e8 b1 bc ff ff       	call   80100660 <cprintf>
801049af:	8b 43 0c             	mov    0xc(%ebx),%eax
801049b2:	83 c4 30             	add    $0x30,%esp
    if (p->state == SLEEPING)
801049b5:	83 f8 02             	cmp    $0x2,%eax
801049b8:	0f 85 43 ff ff ff    	jne    80104901 <printInfo+0x51>
      cprintf("%s\t\t%d\t\tSLEEPING\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
801049be:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  waitingTime = (ticks - p->ticks) / 100;
801049c4:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
801049ca:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  ftos(hrrnTime, out);
801049cf:	83 ec 08             	sub    $0x8,%esp
801049d2:	56                   	push   %esi
  waitingTime = (ticks - p->ticks) / 100;
801049d3:	29 fa                	sub    %edi,%edx
801049d5:	f7 e2                	mul    %edx
  ftos(hrrnTime, out);
801049d7:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
801049da:	c1 ea 05             	shr    $0x5,%edx
801049dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049e0:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
801049e3:	db 83 84 00 00 00    	fildl  0x84(%ebx)
801049e9:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
801049eb:	d9 1c 24             	fstps  (%esp)
801049ee:	e8 bd f2 ff ff       	call   80103cb0 <ftos>
      cprintf("%s\t\t%d\t\tSLEEPING\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
801049f3:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
801049f9:	8b 53 7c             	mov    0x7c(%ebx),%edx
801049fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801049ff:	59                   	pop    %ecx
80104a00:	58                   	pop    %eax
80104a01:	8d 45 de             	lea    -0x22(%ebp),%eax
80104a04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a07:	50                   	push   %eax
80104a08:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104a0e:	e8 9d f2 ff ff       	call   80103cb0 <ftos>
80104a13:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104a16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104a19:	89 3c 24             	mov    %edi,(%esp)
80104a1c:	56                   	push   %esi
80104a1d:	51                   	push   %ecx
80104a1e:	52                   	push   %edx
80104a1f:	50                   	push   %eax
80104a20:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a23:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104a29:	ff 73 10             	pushl  0x10(%ebx)
80104a2c:	50                   	push   %eax
80104a2d:	68 00 82 10 80       	push   $0x80108200
80104a32:	e8 29 bc ff ff       	call   80100660 <cprintf>
80104a37:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a3a:	83 c4 30             	add    $0x30,%esp
    if (p->state == RUNNABLE)
80104a3d:	83 f8 03             	cmp    $0x3,%eax
80104a40:	0f 85 c4 fe ff ff    	jne    8010490a <printInfo+0x5a>
      cprintf("%s\t\t%d\t\tRUNNABLE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104a46:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  waitingTime = (ticks - p->ticks) / 100;
80104a4c:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104a52:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  ftos(hrrnTime, out);
80104a57:	83 ec 08             	sub    $0x8,%esp
80104a5a:	56                   	push   %esi
  waitingTime = (ticks - p->ticks) / 100;
80104a5b:	29 fa                	sub    %edi,%edx
80104a5d:	f7 e2                	mul    %edx
  ftos(hrrnTime, out);
80104a5f:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104a62:	c1 ea 05             	shr    $0x5,%edx
80104a65:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a68:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104a6b:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104a71:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104a73:	d9 1c 24             	fstps  (%esp)
80104a76:	e8 35 f2 ff ff       	call   80103cb0 <ftos>
      cprintf("%s\t\t%d\t\tRUNNABLE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104a7b:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104a7e:	58                   	pop    %eax
80104a7f:	8d 45 de             	lea    -0x22(%ebp),%eax
80104a82:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104a88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a8b:	5a                   	pop    %edx
80104a8c:	50                   	push   %eax
80104a8d:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104a93:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a96:	e8 15 f2 ff ff       	call   80103cb0 <ftos>
80104a9b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104a9e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104aa1:	89 3c 24             	mov    %edi,(%esp)
80104aa4:	56                   	push   %esi
80104aa5:	51                   	push   %ecx
80104aa6:	52                   	push   %edx
80104aa7:	50                   	push   %eax
80104aa8:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104aab:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104ab1:	ff 73 10             	pushl  0x10(%ebx)
80104ab4:	50                   	push   %eax
80104ab5:	68 2c 82 10 80       	push   $0x8010822c
80104aba:	e8 a1 bb ff ff       	call   80100660 <cprintf>
80104abf:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ac2:	83 c4 30             	add    $0x30,%esp
    if (p->state == RUNNING)
80104ac5:	83 f8 04             	cmp    $0x4,%eax
80104ac8:	0f 85 45 fe ff ff    	jne    80104913 <printInfo+0x63>
      cprintf("%s\t\t%d\t\tRUNNING\t\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104ace:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  waitingTime = (ticks - p->ticks) / 100;
80104ad4:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104ada:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  ftos(hrrnTime, out);
80104adf:	83 ec 08             	sub    $0x8,%esp
80104ae2:	56                   	push   %esi
  waitingTime = (ticks - p->ticks) / 100;
80104ae3:	29 fa                	sub    %edi,%edx
80104ae5:	f7 e2                	mul    %edx
  ftos(hrrnTime, out);
80104ae7:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104aea:	c1 ea 05             	shr    $0x5,%edx
80104aed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104af0:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104af3:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104af9:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104afb:	d9 1c 24             	fstps  (%esp)
80104afe:	e8 ad f1 ff ff       	call   80103cb0 <ftos>
      cprintf("%s\t\t%d\t\tRUNNING\t\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104b03:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104b09:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104b0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b0f:	59                   	pop    %ecx
80104b10:	58                   	pop    %eax
80104b11:	8d 45 de             	lea    -0x22(%ebp),%eax
80104b14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b17:	50                   	push   %eax
80104b18:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104b1e:	e8 8d f1 ff ff       	call   80103cb0 <ftos>
80104b23:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104b26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104b29:	89 3c 24             	mov    %edi,(%esp)
80104b2c:	56                   	push   %esi
80104b2d:	51                   	push   %ecx
80104b2e:	52                   	push   %edx
80104b2f:	50                   	push   %eax
80104b30:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b33:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104b39:	ff 73 10             	pushl  0x10(%ebx)
80104b3c:	50                   	push   %eax
80104b3d:	68 58 82 10 80       	push   $0x80108258
80104b42:	e8 19 bb ff ff       	call   80100660 <cprintf>
80104b47:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b4a:	83 c4 30             	add    $0x30,%esp
    if (p->state == ZOMBIE)
80104b4d:	83 f8 05             	cmp    $0x5,%eax
80104b50:	0f 85 c6 fd ff ff    	jne    8010491c <printInfo+0x6c>
      cprintf("%s\t\t%d\t\tZOMBIE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104b56:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  waitingTime = (ticks - p->ticks) / 100;
80104b5c:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104b62:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  ftos(hrrnTime, out);
80104b67:	83 ec 08             	sub    $0x8,%esp
80104b6a:	56                   	push   %esi
  waitingTime = (ticks - p->ticks) / 100;
80104b6b:	29 fa                	sub    %edi,%edx
80104b6d:	f7 e2                	mul    %edx
  ftos(hrrnTime, out);
80104b6f:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104b72:	c1 ea 05             	shr    $0x5,%edx
80104b75:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b78:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104b7b:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104b81:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104b83:	d9 1c 24             	fstps  (%esp)
80104b86:	e8 25 f1 ff ff       	call   80103cb0 <ftos>
      cprintf("%s\t\t%d\t\tZOMBIE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104b8b:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104b8e:	58                   	pop    %eax
80104b8f:	8d 45 de             	lea    -0x22(%ebp),%eax
80104b92:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104b98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b9b:	5a                   	pop    %edx
80104b9c:	50                   	push   %eax
80104b9d:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104ba3:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ba6:	e8 05 f1 ff ff       	call   80103cb0 <ftos>
80104bab:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104bae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104bb1:	89 3c 24             	mov    %edi,(%esp)
80104bb4:	56                   	push   %esi
80104bb5:	51                   	push   %ecx
80104bb6:	52                   	push   %edx
80104bb7:	50                   	push   %eax
80104bb8:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104bbb:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104bc1:	ff 73 10             	pushl  0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bc4:	81 c3 90 00 00 00    	add    $0x90,%ebx
      cprintf("%s\t\t%d\t\tZOMBIE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
80104bca:	50                   	push   %eax
80104bcb:	68 84 82 10 80       	push   $0x80108284
80104bd0:	e8 8b ba ff ff       	call   80100660 <cprintf>
80104bd5:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bd8:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104bde:	0f 82 4a fd ff ff    	jb     8010492e <printInfo+0x7e>
  }
  cprintf("---------------------------------------------------------------------");
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	68 00 81 10 80       	push   $0x80108100
80104bec:	e8 6f ba ff ff       	call   80100660 <cprintf>
  cprintf("---------------------------------------------------------------------\n");
80104bf1:	c7 04 24 48 81 10 80 	movl   $0x80108148,(%esp)
80104bf8:	e8 63 ba ff ff       	call   80100660 <cprintf>
  release(&ptable.lock);
80104bfd:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104c04:	e8 47 03 00 00       	call   80104f50 <release>
  return 1;
}
80104c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c0c:	b8 01 00 00 00       	mov    $0x1,%eax
80104c11:	5b                   	pop    %ebx
80104c12:	5e                   	pop    %esi
80104c13:	5f                   	pop    %edi
80104c14:	5d                   	pop    %ebp
80104c15:	c3                   	ret    
80104c16:	66 90                	xchg   %ax,%ax
80104c18:	66 90                	xchg   %ax,%ax
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c2a:	68 d0 82 10 80       	push   $0x801082d0
80104c2f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c32:	50                   	push   %eax
80104c33:	e8 18 01 00 00       	call   80104d50 <initlock>
  lk->name = name;
80104c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c41:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c44:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c4b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c51:	c9                   	leave  
80104c52:	c3                   	ret    
80104c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c6e:	56                   	push   %esi
80104c6f:	e8 1c 02 00 00       	call   80104e90 <acquire>
  while (lk->locked) {
80104c74:	8b 13                	mov    (%ebx),%edx
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	85 d2                	test   %edx,%edx
80104c7b:	74 16                	je     80104c93 <acquiresleep+0x33>
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c80:	83 ec 08             	sub    $0x8,%esp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	e8 f6 f6 ff ff       	call   80104380 <sleep>
  while (lk->locked) {
80104c8a:	8b 03                	mov    (%ebx),%eax
80104c8c:	83 c4 10             	add    $0x10,%esp
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	75 ed                	jne    80104c80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c99:	e8 e2 ec ff ff       	call   80103980 <myproc>
80104c9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ca1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ca4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ca7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104caa:	5b                   	pop    %ebx
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
  release(&lk->lk);
80104cad:	e9 9e 02 00 00       	jmp    80104f50 <release>
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	8d 73 04             	lea    0x4(%ebx),%esi
80104cce:	56                   	push   %esi
80104ccf:	e8 bc 01 00 00       	call   80104e90 <acquire>
  lk->locked = 0;
80104cd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cda:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ce1:	89 1c 24             	mov    %ebx,(%esp)
80104ce4:	e8 57 f8 ff ff       	call   80104540 <wakeup>
  release(&lk->lk);
80104ce9:	89 75 08             	mov    %esi,0x8(%ebp)
80104cec:	83 c4 10             	add    $0x10,%esp
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cf5:	e9 56 02 00 00       	jmp    80104f50 <release>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
80104d06:	31 ff                	xor    %edi,%edi
80104d08:	83 ec 18             	sub    $0x18,%esp
80104d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d0e:	8d 73 04             	lea    0x4(%ebx),%esi
80104d11:	56                   	push   %esi
80104d12:	e8 79 01 00 00       	call   80104e90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d17:	8b 03                	mov    (%ebx),%eax
80104d19:	83 c4 10             	add    $0x10,%esp
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	74 13                	je     80104d33 <holdingsleep+0x33>
80104d20:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d23:	e8 58 ec ff ff       	call   80103980 <myproc>
80104d28:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d2b:	0f 94 c0             	sete   %al
80104d2e:	0f b6 c0             	movzbl %al,%eax
80104d31:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104d33:	83 ec 0c             	sub    $0xc,%esp
80104d36:	56                   	push   %esi
80104d37:	e8 14 02 00 00       	call   80104f50 <release>
  return r;
}
80104d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d3f:	89 f8                	mov    %edi,%eax
80104d41:	5b                   	pop    %ebx
80104d42:	5e                   	pop    %esi
80104d43:	5f                   	pop    %edi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	66 90                	xchg   %ax,%ax
80104d48:	66 90                	xchg   %ax,%ax
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	90                   	nop
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d70:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d71:	31 d2                	xor    %edx,%edx
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d76:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d7c:	83 e8 08             	sub    $0x8,%eax
80104d7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d8c:	77 1a                	ja     80104da8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d8e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d91:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d94:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d97:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d99:	83 fa 0a             	cmp    $0xa,%edx
80104d9c:	75 e2                	jne    80104d80 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d9e:	5b                   	pop    %ebx
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104dab:	83 c1 28             	add    $0x28,%ecx
80104dae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104db6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104db9:	39 c1                	cmp    %eax,%ecx
80104dbb:	75 f3                	jne    80104db0 <getcallerpcs+0x40>
}
80104dbd:	5b                   	pop    %ebx
80104dbe:	5d                   	pop    %ebp
80104dbf:	c3                   	ret    

80104dc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104dc7:	9c                   	pushf  
80104dc8:	5b                   	pop    %ebx
  asm volatile("cli");
80104dc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dca:	e8 41 eb ff ff       	call   80103910 <mycpu>
80104dcf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	75 11                	jne    80104dea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104dd9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ddf:	e8 2c eb ff ff       	call   80103910 <mycpu>
80104de4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104dea:	e8 21 eb ff ff       	call   80103910 <mycpu>
80104def:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104df6:	83 c4 04             	add    $0x4,%esp
80104df9:	5b                   	pop    %ebx
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <popcli>:

void
popcli(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e06:	9c                   	pushf  
80104e07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e08:	f6 c4 02             	test   $0x2,%ah
80104e0b:	75 35                	jne    80104e42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e0d:	e8 fe ea ff ff       	call   80103910 <mycpu>
80104e12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e19:	78 34                	js     80104e4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e1b:	e8 f0 ea ff ff       	call   80103910 <mycpu>
80104e20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e26:	85 d2                	test   %edx,%edx
80104e28:	74 06                	je     80104e30 <popcli+0x30>
    sti();
}
80104e2a:	c9                   	leave  
80104e2b:	c3                   	ret    
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e30:	e8 db ea ff ff       	call   80103910 <mycpu>
80104e35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	74 eb                	je     80104e2a <popcli+0x2a>
  asm volatile("sti");
80104e3f:	fb                   	sti    
}
80104e40:	c9                   	leave  
80104e41:	c3                   	ret    
    panic("popcli - interruptible");
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 db 82 10 80       	push   $0x801082db
80104e4a:	e8 41 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e4f:	83 ec 0c             	sub    $0xc,%esp
80104e52:	68 f2 82 10 80       	push   $0x801082f2
80104e57:	e8 34 b5 ff ff       	call   80100390 <panic>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e60 <holding>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	8b 75 08             	mov    0x8(%ebp),%esi
80104e68:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e6a:	e8 51 ff ff ff       	call   80104dc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e6f:	8b 06                	mov    (%esi),%eax
80104e71:	85 c0                	test   %eax,%eax
80104e73:	74 10                	je     80104e85 <holding+0x25>
80104e75:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e78:	e8 93 ea ff ff       	call   80103910 <mycpu>
80104e7d:	39 c3                	cmp    %eax,%ebx
80104e7f:	0f 94 c3             	sete   %bl
80104e82:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e85:	e8 76 ff ff ff       	call   80104e00 <popcli>
}
80104e8a:	89 d8                	mov    %ebx,%eax
80104e8c:	5b                   	pop    %ebx
80104e8d:	5e                   	pop    %esi
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret    

80104e90 <acquire>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e95:	e8 26 ff ff ff       	call   80104dc0 <pushcli>
  if(holding(lk))
80104e9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	53                   	push   %ebx
80104ea1:	e8 ba ff ff ff       	call   80104e60 <holding>
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	85 c0                	test   %eax,%eax
80104eab:	0f 85 83 00 00 00    	jne    80104f34 <acquire+0xa4>
80104eb1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104eb3:	ba 01 00 00 00       	mov    $0x1,%edx
80104eb8:	eb 09                	jmp    80104ec3 <acquire+0x33>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ec3:	89 d0                	mov    %edx,%eax
80104ec5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ec8:	85 c0                	test   %eax,%eax
80104eca:	75 f4                	jne    80104ec0 <acquire+0x30>
  __sync_synchronize();
80104ecc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ed4:	e8 37 ea ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ed9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104edc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104edf:	89 e8                	mov    %ebp,%eax
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ee8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104eee:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ef4:	77 1a                	ja     80104f10 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ef6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ef9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104efc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104eff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f01:	83 fe 0a             	cmp    $0xa,%esi
80104f04:	75 e2                	jne    80104ee8 <acquire+0x58>
}
80104f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104f13:	83 c2 28             	add    $0x28,%edx
80104f16:	8d 76 00             	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104f26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104f29:	39 d0                	cmp    %edx,%eax
80104f2b:	75 f3                	jne    80104f20 <acquire+0x90>
}
80104f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f30:	5b                   	pop    %ebx
80104f31:	5e                   	pop    %esi
80104f32:	5d                   	pop    %ebp
80104f33:	c3                   	ret    
    panic("acquire");
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	68 f9 82 10 80       	push   $0x801082f9
80104f3c:	e8 4f b4 ff ff       	call   80100390 <panic>
80104f41:	eb 0d                	jmp    80104f50 <release>
80104f43:	90                   	nop
80104f44:	90                   	nop
80104f45:	90                   	nop
80104f46:	90                   	nop
80104f47:	90                   	nop
80104f48:	90                   	nop
80104f49:	90                   	nop
80104f4a:	90                   	nop
80104f4b:	90                   	nop
80104f4c:	90                   	nop
80104f4d:	90                   	nop
80104f4e:	90                   	nop
80104f4f:	90                   	nop

80104f50 <release>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 10             	sub    $0x10,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f5a:	53                   	push   %ebx
80104f5b:	e8 00 ff ff ff       	call   80104e60 <holding>
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	85 c0                	test   %eax,%eax
80104f65:	74 22                	je     80104f89 <release+0x39>
  lk->pcs[0] = 0;
80104f67:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f6e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f75:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f7a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f83:	c9                   	leave  
  popcli();
80104f84:	e9 77 fe ff ff       	jmp    80104e00 <popcli>
    panic("release");
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	68 01 83 10 80       	push   $0x80108301
80104f91:	e8 fa b3 ff ff       	call   80100390 <panic>
80104f96:	66 90                	xchg   %ax,%ax
80104f98:	66 90                	xchg   %ax,%ax
80104f9a:	66 90                	xchg   %ax,%ax
80104f9c:	66 90                	xchg   %ax,%ax
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	53                   	push   %ebx
80104fa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104fab:	f6 c2 03             	test   $0x3,%dl
80104fae:	75 05                	jne    80104fb5 <memset+0x15>
80104fb0:	f6 c1 03             	test   $0x3,%cl
80104fb3:	74 13                	je     80104fc8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104fb5:	89 d7                	mov    %edx,%edi
80104fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fba:	fc                   	cld    
80104fbb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104fbd:	5b                   	pop    %ebx
80104fbe:	89 d0                	mov    %edx,%eax
80104fc0:	5f                   	pop    %edi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	90                   	nop
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104fc8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fcc:	c1 e9 02             	shr    $0x2,%ecx
80104fcf:	89 f8                	mov    %edi,%eax
80104fd1:	89 fb                	mov    %edi,%ebx
80104fd3:	c1 e0 18             	shl    $0x18,%eax
80104fd6:	c1 e3 10             	shl    $0x10,%ebx
80104fd9:	09 d8                	or     %ebx,%eax
80104fdb:	09 f8                	or     %edi,%eax
80104fdd:	c1 e7 08             	shl    $0x8,%edi
80104fe0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104fe2:	89 d7                	mov    %edx,%edi
80104fe4:	fc                   	cld    
80104fe5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104fe7:	5b                   	pop    %ebx
80104fe8:	89 d0                	mov    %edx,%eax
80104fea:	5f                   	pop    %edi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fff:	85 db                	test   %ebx,%ebx
80105001:	74 29                	je     8010502c <memcmp+0x3c>
    if(*s1 != *s2)
80105003:	0f b6 16             	movzbl (%esi),%edx
80105006:	0f b6 0f             	movzbl (%edi),%ecx
80105009:	38 d1                	cmp    %dl,%cl
8010500b:	75 2b                	jne    80105038 <memcmp+0x48>
8010500d:	b8 01 00 00 00       	mov    $0x1,%eax
80105012:	eb 14                	jmp    80105028 <memcmp+0x38>
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010501c:	83 c0 01             	add    $0x1,%eax
8010501f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105024:	38 ca                	cmp    %cl,%dl
80105026:	75 10                	jne    80105038 <memcmp+0x48>
  while(n-- > 0){
80105028:	39 d8                	cmp    %ebx,%eax
8010502a:	75 ec                	jne    80105018 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010502c:	5b                   	pop    %ebx
  return 0;
8010502d:	31 c0                	xor    %eax,%eax
}
8010502f:	5e                   	pop    %esi
80105030:	5f                   	pop    %edi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	90                   	nop
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105038:	0f b6 c2             	movzbl %dl,%eax
}
8010503b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010503c:	29 c8                	sub    %ecx,%eax
}
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	8b 45 08             	mov    0x8(%ebp),%eax
80105058:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010505b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010505e:	39 c3                	cmp    %eax,%ebx
80105060:	73 26                	jae    80105088 <memmove+0x38>
80105062:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105065:	39 c8                	cmp    %ecx,%eax
80105067:	73 1f                	jae    80105088 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105069:	85 f6                	test   %esi,%esi
8010506b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010506e:	74 0f                	je     8010507f <memmove+0x2f>
      *--d = *--s;
80105070:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105074:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105077:	83 ea 01             	sub    $0x1,%edx
8010507a:	83 fa ff             	cmp    $0xffffffff,%edx
8010507d:	75 f1                	jne    80105070 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	90                   	nop
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105088:	31 d2                	xor    %edx,%edx
8010508a:	85 f6                	test   %esi,%esi
8010508c:	74 f1                	je     8010507f <memmove+0x2f>
8010508e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105090:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105094:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105097:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010509a:	39 d6                	cmp    %edx,%esi
8010509c:	75 f2                	jne    80105090 <memmove+0x40>
}
8010509e:	5b                   	pop    %ebx
8010509f:	5e                   	pop    %esi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801050b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801050b4:	eb 9a                	jmp    80105050 <memmove>
801050b6:	8d 76 00             	lea    0x0(%esi),%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
801050c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801050c8:	53                   	push   %ebx
801050c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801050cf:	85 ff                	test   %edi,%edi
801050d1:	74 2f                	je     80105102 <strncmp+0x42>
801050d3:	0f b6 01             	movzbl (%ecx),%eax
801050d6:	0f b6 1e             	movzbl (%esi),%ebx
801050d9:	84 c0                	test   %al,%al
801050db:	74 37                	je     80105114 <strncmp+0x54>
801050dd:	38 c3                	cmp    %al,%bl
801050df:	75 33                	jne    80105114 <strncmp+0x54>
801050e1:	01 f7                	add    %esi,%edi
801050e3:	eb 13                	jmp    801050f8 <strncmp+0x38>
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
801050e8:	0f b6 01             	movzbl (%ecx),%eax
801050eb:	84 c0                	test   %al,%al
801050ed:	74 21                	je     80105110 <strncmp+0x50>
801050ef:	0f b6 1a             	movzbl (%edx),%ebx
801050f2:	89 d6                	mov    %edx,%esi
801050f4:	38 d8                	cmp    %bl,%al
801050f6:	75 1c                	jne    80105114 <strncmp+0x54>
    n--, p++, q++;
801050f8:	8d 56 01             	lea    0x1(%esi),%edx
801050fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050fe:	39 fa                	cmp    %edi,%edx
80105100:	75 e6                	jne    801050e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105102:	5b                   	pop    %ebx
    return 0;
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	5e                   	pop    %esi
80105106:	5f                   	pop    %edi
80105107:	5d                   	pop    %ebp
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105110:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105114:	29 d8                	sub    %ebx,%eax
}
80105116:	5b                   	pop    %ebx
80105117:	5e                   	pop    %esi
80105118:	5f                   	pop    %edi
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    
8010511b:	90                   	nop
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 45 08             	mov    0x8(%ebp),%eax
80105128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010512b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010512e:	89 c2                	mov    %eax,%edx
80105130:	eb 19                	jmp    8010514b <strncpy+0x2b>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105138:	83 c3 01             	add    $0x1,%ebx
8010513b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010513f:	83 c2 01             	add    $0x1,%edx
80105142:	84 c9                	test   %cl,%cl
80105144:	88 4a ff             	mov    %cl,-0x1(%edx)
80105147:	74 09                	je     80105152 <strncpy+0x32>
80105149:	89 f1                	mov    %esi,%ecx
8010514b:	85 c9                	test   %ecx,%ecx
8010514d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105150:	7f e6                	jg     80105138 <strncpy+0x18>
    ;
  while(n-- > 0)
80105152:	31 c9                	xor    %ecx,%ecx
80105154:	85 f6                	test   %esi,%esi
80105156:	7e 17                	jle    8010516f <strncpy+0x4f>
80105158:	90                   	nop
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105160:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105164:	89 f3                	mov    %esi,%ebx
80105166:	83 c1 01             	add    $0x1,%ecx
80105169:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010516b:	85 db                	test   %ebx,%ebx
8010516d:	7f f1                	jg     80105160 <strncpy+0x40>
  return os;
}
8010516f:	5b                   	pop    %ebx
80105170:	5e                   	pop    %esi
80105171:	5d                   	pop    %ebp
80105172:	c3                   	ret    
80105173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
80105185:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105188:	8b 45 08             	mov    0x8(%ebp),%eax
8010518b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010518e:	85 c9                	test   %ecx,%ecx
80105190:	7e 26                	jle    801051b8 <safestrcpy+0x38>
80105192:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105196:	89 c1                	mov    %eax,%ecx
80105198:	eb 17                	jmp    801051b1 <safestrcpy+0x31>
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051a0:	83 c2 01             	add    $0x1,%edx
801051a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801051a7:	83 c1 01             	add    $0x1,%ecx
801051aa:	84 db                	test   %bl,%bl
801051ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801051af:	74 04                	je     801051b5 <safestrcpy+0x35>
801051b1:	39 f2                	cmp    %esi,%edx
801051b3:	75 eb                	jne    801051a0 <safestrcpy+0x20>
    ;
  *s = 0;
801051b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801051b8:	5b                   	pop    %ebx
801051b9:	5e                   	pop    %esi
801051ba:	5d                   	pop    %ebp
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <strlen>:

int
strlen(const char *s)
{
801051c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801051c1:	31 c0                	xor    %eax,%eax
{
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801051c8:	80 3a 00             	cmpb   $0x0,(%edx)
801051cb:	74 0c                	je     801051d9 <strlen+0x19>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c0 01             	add    $0x1,%eax
801051d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051d7:	75 f7                	jne    801051d0 <strlen+0x10>
    ;
  return n;
}
801051d9:	5d                   	pop    %ebp
801051da:	c3                   	ret    

801051db <swtch>:
801051db:	8b 44 24 04          	mov    0x4(%esp),%eax
801051df:	8b 54 24 08          	mov    0x8(%esp),%edx
801051e3:	55                   	push   %ebp
801051e4:	53                   	push   %ebx
801051e5:	56                   	push   %esi
801051e6:	57                   	push   %edi
801051e7:	89 20                	mov    %esp,(%eax)
801051e9:	89 d4                	mov    %edx,%esp
801051eb:	5f                   	pop    %edi
801051ec:	5e                   	pop    %esi
801051ed:	5b                   	pop    %ebx
801051ee:	5d                   	pop    %ebp
801051ef:	c3                   	ret    

801051f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	53                   	push   %ebx
801051f4:	83 ec 04             	sub    $0x4,%esp
801051f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051fa:	e8 81 e7 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051ff:	8b 00                	mov    (%eax),%eax
80105201:	39 d8                	cmp    %ebx,%eax
80105203:	76 1b                	jbe    80105220 <fetchint+0x30>
80105205:	8d 53 04             	lea    0x4(%ebx),%edx
80105208:	39 d0                	cmp    %edx,%eax
8010520a:	72 14                	jb     80105220 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010520c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520f:	8b 13                	mov    (%ebx),%edx
80105211:	89 10                	mov    %edx,(%eax)
  return 0;
80105213:	31 c0                	xor    %eax,%eax
}
80105215:	83 c4 04             	add    $0x4,%esp
80105218:	5b                   	pop    %ebx
80105219:	5d                   	pop    %ebp
8010521a:	c3                   	ret    
8010521b:	90                   	nop
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	eb ee                	jmp    80105215 <fetchint+0x25>
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 04             	sub    $0x4,%esp
80105237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010523a:	e8 41 e7 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
8010523f:	39 18                	cmp    %ebx,(%eax)
80105241:	76 29                	jbe    8010526c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105246:	89 da                	mov    %ebx,%edx
80105248:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010524a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010524c:	39 c3                	cmp    %eax,%ebx
8010524e:	73 1c                	jae    8010526c <fetchstr+0x3c>
    if(*s == 0)
80105250:	80 3b 00             	cmpb   $0x0,(%ebx)
80105253:	75 10                	jne    80105265 <fetchstr+0x35>
80105255:	eb 39                	jmp    80105290 <fetchstr+0x60>
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105260:	80 3a 00             	cmpb   $0x0,(%edx)
80105263:	74 1b                	je     80105280 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105265:	83 c2 01             	add    $0x1,%edx
80105268:	39 d0                	cmp    %edx,%eax
8010526a:	77 f4                	ja     80105260 <fetchstr+0x30>
    return -1;
8010526c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105271:	83 c4 04             	add    $0x4,%esp
80105274:	5b                   	pop    %ebx
80105275:	5d                   	pop    %ebp
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105280:	83 c4 04             	add    $0x4,%esp
80105283:	89 d0                	mov    %edx,%eax
80105285:	29 d8                	sub    %ebx,%eax
80105287:	5b                   	pop    %ebx
80105288:	5d                   	pop    %ebp
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105290:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105292:	eb dd                	jmp    80105271 <fetchstr+0x41>
80105294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010529a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052a5:	e8 d6 e6 ff ff       	call   80103980 <myproc>
801052aa:	8b 40 18             	mov    0x18(%eax),%eax
801052ad:	8b 55 08             	mov    0x8(%ebp),%edx
801052b0:	8b 40 44             	mov    0x44(%eax),%eax
801052b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052b6:	e8 c5 e6 ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052bb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052bd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052c0:	39 c6                	cmp    %eax,%esi
801052c2:	73 1c                	jae    801052e0 <argint+0x40>
801052c4:	8d 53 08             	lea    0x8(%ebx),%edx
801052c7:	39 d0                	cmp    %edx,%eax
801052c9:	72 15                	jb     801052e0 <argint+0x40>
  *ip = *(int*)(addr);
801052cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ce:	8b 53 04             	mov    0x4(%ebx),%edx
801052d1:	89 10                	mov    %edx,(%eax)
  return 0;
801052d3:	31 c0                	xor    %eax,%eax
}
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052e5:	eb ee                	jmp    801052d5 <argint+0x35>
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	83 ec 10             	sub    $0x10,%esp
801052f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801052fb:	e8 80 e6 ff ff       	call   80103980 <myproc>
80105300:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105302:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105305:	83 ec 08             	sub    $0x8,%esp
80105308:	50                   	push   %eax
80105309:	ff 75 08             	pushl  0x8(%ebp)
8010530c:	e8 8f ff ff ff       	call   801052a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	85 c0                	test   %eax,%eax
80105316:	78 28                	js     80105340 <argptr+0x50>
80105318:	85 db                	test   %ebx,%ebx
8010531a:	78 24                	js     80105340 <argptr+0x50>
8010531c:	8b 16                	mov    (%esi),%edx
8010531e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105321:	39 c2                	cmp    %eax,%edx
80105323:	76 1b                	jbe    80105340 <argptr+0x50>
80105325:	01 c3                	add    %eax,%ebx
80105327:	39 da                	cmp    %ebx,%edx
80105329:	72 15                	jb     80105340 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010532b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010532e:	89 02                	mov    %eax,(%edx)
  return 0;
80105330:	31 c0                	xor    %eax,%eax
}
80105332:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105335:	5b                   	pop    %ebx
80105336:	5e                   	pop    %esi
80105337:	5d                   	pop    %ebp
80105338:	c3                   	ret    
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105345:	eb eb                	jmp    80105332 <argptr+0x42>
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105356:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105359:	50                   	push   %eax
8010535a:	ff 75 08             	pushl  0x8(%ebp)
8010535d:	e8 3e ff ff ff       	call   801052a0 <argint>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 17                	js     80105380 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105369:	83 ec 08             	sub    $0x8,%esp
8010536c:	ff 75 0c             	pushl  0xc(%ebp)
8010536f:	ff 75 f4             	pushl  -0xc(%ebp)
80105372:	e8 b9 fe ff ff       	call   80105230 <fetchstr>
80105377:	83 c4 10             	add    $0x10,%esp
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <syscall>:
[SYS_printInfo] sys_printInfo,
};

void
syscall(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105397:	e8 e4 e5 ff ff       	call   80103980 <myproc>
8010539c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010539e:	8b 40 18             	mov    0x18(%eax),%eax
801053a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a7:	83 fa 18             	cmp    $0x18,%edx
801053aa:	77 1c                	ja     801053c8 <syscall+0x38>
801053ac:	8b 14 85 40 83 10 80 	mov    -0x7fef7cc0(,%eax,4),%edx
801053b3:	85 d2                	test   %edx,%edx
801053b5:	74 11                	je     801053c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801053b7:	ff d2                	call   *%edx
801053b9:	8b 53 18             	mov    0x18(%ebx),%edx
801053bc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801053bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801053c8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801053c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801053cc:	50                   	push   %eax
801053cd:	ff 73 10             	pushl  0x10(%ebx)
801053d0:	68 09 83 10 80       	push   $0x80108309
801053d5:	e8 86 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801053da:	8b 43 18             	mov    0x18(%ebx),%eax
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	66 90                	xchg   %ax,%ax
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053f6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801053f9:	83 ec 34             	sub    $0x34,%esp
801053fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105402:	56                   	push   %esi
80105403:	50                   	push   %eax
{
80105404:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105407:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010540a:	e8 21 cb ff ff       	call   80101f30 <nameiparent>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	85 c0                	test   %eax,%eax
80105414:	0f 84 46 01 00 00    	je     80105560 <create+0x170>
    return 0;
  ilock(dp);
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	89 c3                	mov    %eax,%ebx
8010541f:	50                   	push   %eax
80105420:	e8 8b c2 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105425:	83 c4 0c             	add    $0xc,%esp
80105428:	6a 00                	push   $0x0
8010542a:	56                   	push   %esi
8010542b:	53                   	push   %ebx
8010542c:	e8 af c7 ff ff       	call   80101be0 <dirlookup>
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	85 c0                	test   %eax,%eax
80105436:	89 c7                	mov    %eax,%edi
80105438:	74 36                	je     80105470 <create+0x80>
    iunlockput(dp);
8010543a:	83 ec 0c             	sub    $0xc,%esp
8010543d:	53                   	push   %ebx
8010543e:	e8 fd c4 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80105443:	89 3c 24             	mov    %edi,(%esp)
80105446:	e8 65 c2 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010544b:	83 c4 10             	add    $0x10,%esp
8010544e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105453:	0f 85 97 00 00 00    	jne    801054f0 <create+0x100>
80105459:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010545e:	0f 85 8c 00 00 00    	jne    801054f0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105464:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105467:	89 f8                	mov    %edi,%eax
80105469:	5b                   	pop    %ebx
8010546a:	5e                   	pop    %esi
8010546b:	5f                   	pop    %edi
8010546c:	5d                   	pop    %ebp
8010546d:	c3                   	ret    
8010546e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105470:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	50                   	push   %eax
80105478:	ff 33                	pushl  (%ebx)
8010547a:	e8 c1 c0 ff ff       	call   80101540 <ialloc>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	89 c7                	mov    %eax,%edi
80105486:	0f 84 e8 00 00 00    	je     80105574 <create+0x184>
  ilock(ip);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	50                   	push   %eax
80105490:	e8 1b c2 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105495:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105499:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010549d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801054a1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801054a5:	b8 01 00 00 00       	mov    $0x1,%eax
801054aa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801054ae:	89 3c 24             	mov    %edi,(%esp)
801054b1:	e8 4a c1 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801054be:	74 50                	je     80105510 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801054c0:	83 ec 04             	sub    $0x4,%esp
801054c3:	ff 77 04             	pushl  0x4(%edi)
801054c6:	56                   	push   %esi
801054c7:	53                   	push   %ebx
801054c8:	e8 83 c9 ff ff       	call   80101e50 <dirlink>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	0f 88 8f 00 00 00    	js     80105567 <create+0x177>
  iunlockput(dp);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	53                   	push   %ebx
801054dc:	e8 5f c4 ff ff       	call   80101940 <iunlockput>
  return ip;
801054e1:	83 c4 10             	add    $0x10,%esp
}
801054e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e7:	89 f8                	mov    %edi,%eax
801054e9:	5b                   	pop    %ebx
801054ea:	5e                   	pop    %esi
801054eb:	5f                   	pop    %edi
801054ec:	5d                   	pop    %ebp
801054ed:	c3                   	ret    
801054ee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	57                   	push   %edi
    return 0;
801054f4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801054f6:	e8 45 c4 ff ff       	call   80101940 <iunlockput>
    return 0;
801054fb:	83 c4 10             	add    $0x10,%esp
}
801054fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105501:	89 f8                	mov    %edi,%eax
80105503:	5b                   	pop    %ebx
80105504:	5e                   	pop    %esi
80105505:	5f                   	pop    %edi
80105506:	5d                   	pop    %ebp
80105507:	c3                   	ret    
80105508:	90                   	nop
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105510:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	53                   	push   %ebx
80105519:	e8 e2 c0 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010551e:	83 c4 0c             	add    $0xc,%esp
80105521:	ff 77 04             	pushl  0x4(%edi)
80105524:	68 c4 83 10 80       	push   $0x801083c4
80105529:	57                   	push   %edi
8010552a:	e8 21 c9 ff ff       	call   80101e50 <dirlink>
8010552f:	83 c4 10             	add    $0x10,%esp
80105532:	85 c0                	test   %eax,%eax
80105534:	78 1c                	js     80105552 <create+0x162>
80105536:	83 ec 04             	sub    $0x4,%esp
80105539:	ff 73 04             	pushl  0x4(%ebx)
8010553c:	68 c3 83 10 80       	push   $0x801083c3
80105541:	57                   	push   %edi
80105542:	e8 09 c9 ff ff       	call   80101e50 <dirlink>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	0f 89 6e ff ff ff    	jns    801054c0 <create+0xd0>
      panic("create dots");
80105552:	83 ec 0c             	sub    $0xc,%esp
80105555:	68 b7 83 10 80       	push   $0x801083b7
8010555a:	e8 31 ae ff ff       	call   80100390 <panic>
8010555f:	90                   	nop
    return 0;
80105560:	31 ff                	xor    %edi,%edi
80105562:	e9 fd fe ff ff       	jmp    80105464 <create+0x74>
    panic("create: dirlink");
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	68 c6 83 10 80       	push   $0x801083c6
8010556f:	e8 1c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	68 a8 83 10 80       	push   $0x801083a8
8010557c:	e8 0f ae ff ff       	call   80100390 <panic>
80105581:	eb 0d                	jmp    80105590 <argfd.constprop.0>
80105583:	90                   	nop
80105584:	90                   	nop
80105585:	90                   	nop
80105586:	90                   	nop
80105587:	90                   	nop
80105588:	90                   	nop
80105589:	90                   	nop
8010558a:	90                   	nop
8010558b:	90                   	nop
8010558c:	90                   	nop
8010558d:	90                   	nop
8010558e:	90                   	nop
8010558f:	90                   	nop

80105590 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105597:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010559a:	89 d6                	mov    %edx,%esi
8010559c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010559f:	50                   	push   %eax
801055a0:	6a 00                	push   $0x0
801055a2:	e8 f9 fc ff ff       	call   801052a0 <argint>
801055a7:	83 c4 10             	add    $0x10,%esp
801055aa:	85 c0                	test   %eax,%eax
801055ac:	78 2a                	js     801055d8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055b2:	77 24                	ja     801055d8 <argfd.constprop.0+0x48>
801055b4:	e8 c7 e3 ff ff       	call   80103980 <myproc>
801055b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801055c0:	85 c0                	test   %eax,%eax
801055c2:	74 14                	je     801055d8 <argfd.constprop.0+0x48>
  if(pfd)
801055c4:	85 db                	test   %ebx,%ebx
801055c6:	74 02                	je     801055ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801055c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801055ca:	89 06                	mov    %eax,(%esi)
  return 0;
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5d                   	pop    %ebp
801055d4:	c3                   	ret    
801055d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dd:	eb ef                	jmp    801055ce <argfd.constprop.0+0x3e>
801055df:	90                   	nop

801055e0 <sys_dup>:
{
801055e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801055e1:	31 c0                	xor    %eax,%eax
{
801055e3:	89 e5                	mov    %esp,%ebp
801055e5:	56                   	push   %esi
801055e6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801055e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801055ea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801055ed:	e8 9e ff ff ff       	call   80105590 <argfd.constprop.0>
801055f2:	85 c0                	test   %eax,%eax
801055f4:	78 42                	js     80105638 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801055f6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055f9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055fb:	e8 80 e3 ff ff       	call   80103980 <myproc>
80105600:	eb 0e                	jmp    80105610 <sys_dup+0x30>
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105608:	83 c3 01             	add    $0x1,%ebx
8010560b:	83 fb 10             	cmp    $0x10,%ebx
8010560e:	74 28                	je     80105638 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	75 f0                	jne    80105608 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105618:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	ff 75 f4             	pushl  -0xc(%ebp)
80105622:	e8 f9 b7 ff ff       	call   80100e20 <filedup>
  return fd;
80105627:	83 c4 10             	add    $0x10,%esp
}
8010562a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010562d:	89 d8                	mov    %ebx,%eax
8010562f:	5b                   	pop    %ebx
80105630:	5e                   	pop    %esi
80105631:	5d                   	pop    %ebp
80105632:	c3                   	ret    
80105633:	90                   	nop
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105638:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010563b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105640:	89 d8                	mov    %ebx,%eax
80105642:	5b                   	pop    %ebx
80105643:	5e                   	pop    %esi
80105644:	5d                   	pop    %ebp
80105645:	c3                   	ret    
80105646:	8d 76 00             	lea    0x0(%esi),%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <sys_read>:
{
80105650:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105651:	31 c0                	xor    %eax,%eax
{
80105653:	89 e5                	mov    %esp,%ebp
80105655:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105658:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010565b:	e8 30 ff ff ff       	call   80105590 <argfd.constprop.0>
80105660:	85 c0                	test   %eax,%eax
80105662:	78 4c                	js     801056b0 <sys_read+0x60>
80105664:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105667:	83 ec 08             	sub    $0x8,%esp
8010566a:	50                   	push   %eax
8010566b:	6a 02                	push   $0x2
8010566d:	e8 2e fc ff ff       	call   801052a0 <argint>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 37                	js     801056b0 <sys_read+0x60>
80105679:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567c:	83 ec 04             	sub    $0x4,%esp
8010567f:	ff 75 f0             	pushl  -0x10(%ebp)
80105682:	50                   	push   %eax
80105683:	6a 01                	push   $0x1
80105685:	e8 66 fc ff ff       	call   801052f0 <argptr>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	85 c0                	test   %eax,%eax
8010568f:	78 1f                	js     801056b0 <sys_read+0x60>
  return fileread(f, p, n);
80105691:	83 ec 04             	sub    $0x4,%esp
80105694:	ff 75 f0             	pushl  -0x10(%ebp)
80105697:	ff 75 f4             	pushl  -0xc(%ebp)
8010569a:	ff 75 ec             	pushl  -0x14(%ebp)
8010569d:	e8 ee b8 ff ff       	call   80100f90 <fileread>
801056a2:	83 c4 10             	add    $0x10,%esp
}
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_write>:
{
801056c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801056cb:	e8 c0 fe ff ff       	call   80105590 <argfd.constprop.0>
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 4c                	js     80105720 <sys_write+0x60>
801056d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	50                   	push   %eax
801056db:	6a 02                	push   $0x2
801056dd:	e8 be fb ff ff       	call   801052a0 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 37                	js     80105720 <sys_write+0x60>
801056e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ec:	83 ec 04             	sub    $0x4,%esp
801056ef:	ff 75 f0             	pushl  -0x10(%ebp)
801056f2:	50                   	push   %eax
801056f3:	6a 01                	push   $0x1
801056f5:	e8 f6 fb ff ff       	call   801052f0 <argptr>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 1f                	js     80105720 <sys_write+0x60>
  return filewrite(f, p, n);
80105701:	83 ec 04             	sub    $0x4,%esp
80105704:	ff 75 f0             	pushl  -0x10(%ebp)
80105707:	ff 75 f4             	pushl  -0xc(%ebp)
8010570a:	ff 75 ec             	pushl  -0x14(%ebp)
8010570d:	e8 0e b9 ff ff       	call   80101020 <filewrite>
80105712:	83 c4 10             	add    $0x10,%esp
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_close>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105736:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105739:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010573c:	e8 4f fe ff ff       	call   80105590 <argfd.constprop.0>
80105741:	85 c0                	test   %eax,%eax
80105743:	78 2b                	js     80105770 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105745:	e8 36 e2 ff ff       	call   80103980 <myproc>
8010574a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010574d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105750:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105757:	00 
  fileclose(f);
80105758:	ff 75 f4             	pushl  -0xc(%ebp)
8010575b:	e8 10 b7 ff ff       	call   80100e70 <fileclose>
  return 0;
80105760:	83 c4 10             	add    $0x10,%esp
80105763:	31 c0                	xor    %eax,%eax
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_fstat>:
{
80105780:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105788:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010578b:	e8 00 fe ff ff       	call   80105590 <argfd.constprop.0>
80105790:	85 c0                	test   %eax,%eax
80105792:	78 2c                	js     801057c0 <sys_fstat+0x40>
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105797:	83 ec 04             	sub    $0x4,%esp
8010579a:	6a 14                	push   $0x14
8010579c:	50                   	push   %eax
8010579d:	6a 01                	push   $0x1
8010579f:	e8 4c fb ff ff       	call   801052f0 <argptr>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	78 15                	js     801057c0 <sys_fstat+0x40>
  return filestat(f, st);
801057ab:	83 ec 08             	sub    $0x8,%esp
801057ae:	ff 75 f4             	pushl  -0xc(%ebp)
801057b1:	ff 75 f0             	pushl  -0x10(%ebp)
801057b4:	e8 87 b7 ff ff       	call   80100f40 <filestat>
801057b9:	83 c4 10             	add    $0x10,%esp
}
801057bc:	c9                   	leave  
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <sys_link>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801057d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057dc:	50                   	push   %eax
801057dd:	6a 00                	push   $0x0
801057df:	e8 6c fb ff ff       	call   80105350 <argstr>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	0f 88 fb 00 00 00    	js     801058ea <sys_link+0x11a>
801057ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057f2:	83 ec 08             	sub    $0x8,%esp
801057f5:	50                   	push   %eax
801057f6:	6a 01                	push   $0x1
801057f8:	e8 53 fb ff ff       	call   80105350 <argstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	0f 88 e2 00 00 00    	js     801058ea <sys_link+0x11a>
  begin_op();
80105808:	e8 c3 d3 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	ff 75 d4             	pushl  -0x2c(%ebp)
80105813:	e8 f8 c6 ff ff       	call   80101f10 <namei>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	89 c3                	mov    %eax,%ebx
8010581f:	0f 84 ea 00 00 00    	je     8010590f <sys_link+0x13f>
  ilock(ip);
80105825:	83 ec 0c             	sub    $0xc,%esp
80105828:	50                   	push   %eax
80105829:	e8 82 be ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105836:	0f 84 bb 00 00 00    	je     801058f7 <sys_link+0x127>
  ip->nlink++;
8010583c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105841:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105844:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105847:	53                   	push   %ebx
80105848:	e8 b3 bd ff ff       	call   80101600 <iupdate>
  iunlock(ip);
8010584d:	89 1c 24             	mov    %ebx,(%esp)
80105850:	e8 3b bf ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105855:	58                   	pop    %eax
80105856:	5a                   	pop    %edx
80105857:	57                   	push   %edi
80105858:	ff 75 d0             	pushl  -0x30(%ebp)
8010585b:	e8 d0 c6 ff ff       	call   80101f30 <nameiparent>
80105860:	83 c4 10             	add    $0x10,%esp
80105863:	85 c0                	test   %eax,%eax
80105865:	89 c6                	mov    %eax,%esi
80105867:	74 5b                	je     801058c4 <sys_link+0xf4>
  ilock(dp);
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	50                   	push   %eax
8010586d:	e8 3e be ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	8b 03                	mov    (%ebx),%eax
80105877:	39 06                	cmp    %eax,(%esi)
80105879:	75 3d                	jne    801058b8 <sys_link+0xe8>
8010587b:	83 ec 04             	sub    $0x4,%esp
8010587e:	ff 73 04             	pushl  0x4(%ebx)
80105881:	57                   	push   %edi
80105882:	56                   	push   %esi
80105883:	e8 c8 c5 ff ff       	call   80101e50 <dirlink>
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	85 c0                	test   %eax,%eax
8010588d:	78 29                	js     801058b8 <sys_link+0xe8>
  iunlockput(dp);
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	56                   	push   %esi
80105893:	e8 a8 c0 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105898:	89 1c 24             	mov    %ebx,(%esp)
8010589b:	e8 40 bf ff ff       	call   801017e0 <iput>
  end_op();
801058a0:	e8 9b d3 ff ff       	call   80102c40 <end_op>
  return 0;
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	31 c0                	xor    %eax,%eax
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ad:	5b                   	pop    %ebx
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret    
801058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	56                   	push   %esi
801058bc:	e8 7f c0 ff ff       	call   80101940 <iunlockput>
    goto bad;
801058c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	53                   	push   %ebx
801058c8:	e8 e3 bd ff ff       	call   801016b0 <ilock>
  ip->nlink--;
801058cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058d2:	89 1c 24             	mov    %ebx,(%esp)
801058d5:	e8 26 bd ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801058da:	89 1c 24             	mov    %ebx,(%esp)
801058dd:	e8 5e c0 ff ff       	call   80101940 <iunlockput>
  end_op();
801058e2:	e8 59 d3 ff ff       	call   80102c40 <end_op>
  return -1;
801058e7:	83 c4 10             	add    $0x10,%esp
}
801058ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801058ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5f                   	pop    %edi
801058f5:	5d                   	pop    %ebp
801058f6:	c3                   	ret    
    iunlockput(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	53                   	push   %ebx
801058fb:	e8 40 c0 ff ff       	call   80101940 <iunlockput>
    end_op();
80105900:	e8 3b d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590d:	eb 9b                	jmp    801058aa <sys_link+0xda>
    end_op();
8010590f:	e8 2c d3 ff ff       	call   80102c40 <end_op>
    return -1;
80105914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105919:	eb 8f                	jmp    801058aa <sys_link+0xda>
8010591b:	90                   	nop
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_unlink>:
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105926:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105929:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010592c:	50                   	push   %eax
8010592d:	6a 00                	push   $0x0
8010592f:	e8 1c fa ff ff       	call   80105350 <argstr>
80105934:	83 c4 10             	add    $0x10,%esp
80105937:	85 c0                	test   %eax,%eax
80105939:	0f 88 77 01 00 00    	js     80105ab6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010593f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105942:	e8 89 d2 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	53                   	push   %ebx
8010594b:	ff 75 c0             	pushl  -0x40(%ebp)
8010594e:	e8 dd c5 ff ff       	call   80101f30 <nameiparent>
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	89 c6                	mov    %eax,%esi
8010595a:	0f 84 60 01 00 00    	je     80105ac0 <sys_unlink+0x1a0>
  ilock(dp);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	50                   	push   %eax
80105964:	e8 47 bd ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105969:	58                   	pop    %eax
8010596a:	5a                   	pop    %edx
8010596b:	68 c4 83 10 80       	push   $0x801083c4
80105970:	53                   	push   %ebx
80105971:	e8 4a c2 ff ff       	call   80101bc0 <namecmp>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	0f 84 03 01 00 00    	je     80105a84 <sys_unlink+0x164>
80105981:	83 ec 08             	sub    $0x8,%esp
80105984:	68 c3 83 10 80       	push   $0x801083c3
80105989:	53                   	push   %ebx
8010598a:	e8 31 c2 ff ff       	call   80101bc0 <namecmp>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 c0                	test   %eax,%eax
80105994:	0f 84 ea 00 00 00    	je     80105a84 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010599a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010599d:	83 ec 04             	sub    $0x4,%esp
801059a0:	50                   	push   %eax
801059a1:	53                   	push   %ebx
801059a2:	56                   	push   %esi
801059a3:	e8 38 c2 ff ff       	call   80101be0 <dirlookup>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	85 c0                	test   %eax,%eax
801059ad:	89 c3                	mov    %eax,%ebx
801059af:	0f 84 cf 00 00 00    	je     80105a84 <sys_unlink+0x164>
  ilock(ip);
801059b5:	83 ec 0c             	sub    $0xc,%esp
801059b8:	50                   	push   %eax
801059b9:	e8 f2 bc ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059c6:	0f 8e 10 01 00 00    	jle    80105adc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801059cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059d1:	74 6d                	je     80105a40 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801059d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059d6:	83 ec 04             	sub    $0x4,%esp
801059d9:	6a 10                	push   $0x10
801059db:	6a 00                	push   $0x0
801059dd:	50                   	push   %eax
801059de:	e8 bd f5 ff ff       	call   80104fa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059e6:	6a 10                	push   $0x10
801059e8:	ff 75 c4             	pushl  -0x3c(%ebp)
801059eb:	50                   	push   %eax
801059ec:	56                   	push   %esi
801059ed:	e8 9e c0 ff ff       	call   80101a90 <writei>
801059f2:	83 c4 20             	add    $0x20,%esp
801059f5:	83 f8 10             	cmp    $0x10,%eax
801059f8:	0f 85 eb 00 00 00    	jne    80105ae9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801059fe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a03:	0f 84 97 00 00 00    	je     80105aa0 <sys_unlink+0x180>
  iunlockput(dp);
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	56                   	push   %esi
80105a0d:	e8 2e bf ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105a12:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a17:	89 1c 24             	mov    %ebx,(%esp)
80105a1a:	e8 e1 bb ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80105a1f:	89 1c 24             	mov    %ebx,(%esp)
80105a22:	e8 19 bf ff ff       	call   80101940 <iunlockput>
  end_op();
80105a27:	e8 14 d2 ff ff       	call   80102c40 <end_op>
  return 0;
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	31 c0                	xor    %eax,%eax
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	5b                   	pop    %ebx
80105a35:	5e                   	pop    %esi
80105a36:	5f                   	pop    %edi
80105a37:	5d                   	pop    %ebp
80105a38:	c3                   	ret    
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a44:	76 8d                	jbe    801059d3 <sys_unlink+0xb3>
80105a46:	bf 20 00 00 00       	mov    $0x20,%edi
80105a4b:	eb 0f                	jmp    80105a5c <sys_unlink+0x13c>
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
80105a50:	83 c7 10             	add    $0x10,%edi
80105a53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105a56:	0f 83 77 ff ff ff    	jae    801059d3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a5c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a5f:	6a 10                	push   $0x10
80105a61:	57                   	push   %edi
80105a62:	50                   	push   %eax
80105a63:	53                   	push   %ebx
80105a64:	e8 27 bf ff ff       	call   80101990 <readi>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	83 f8 10             	cmp    $0x10,%eax
80105a6f:	75 5e                	jne    80105acf <sys_unlink+0x1af>
    if(de.inum != 0)
80105a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a76:	74 d8                	je     80105a50 <sys_unlink+0x130>
    iunlockput(ip);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	53                   	push   %ebx
80105a7c:	e8 bf be ff ff       	call   80101940 <iunlockput>
    goto bad;
80105a81:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	56                   	push   %esi
80105a88:	e8 b3 be ff ff       	call   80101940 <iunlockput>
  end_op();
80105a8d:	e8 ae d1 ff ff       	call   80102c40 <end_op>
  return -1;
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9a:	eb 95                	jmp    80105a31 <sys_unlink+0x111>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105aa0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105aa5:	83 ec 0c             	sub    $0xc,%esp
80105aa8:	56                   	push   %esi
80105aa9:	e8 52 bb ff ff       	call   80101600 <iupdate>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	e9 53 ff ff ff       	jmp    80105a09 <sys_unlink+0xe9>
    return -1;
80105ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abb:	e9 71 ff ff ff       	jmp    80105a31 <sys_unlink+0x111>
    end_op();
80105ac0:	e8 7b d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aca:	e9 62 ff ff ff       	jmp    80105a31 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	68 e8 83 10 80       	push   $0x801083e8
80105ad7:	e8 b4 a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105adc:	83 ec 0c             	sub    $0xc,%esp
80105adf:	68 d6 83 10 80       	push   $0x801083d6
80105ae4:	e8 a7 a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	68 fa 83 10 80       	push   $0x801083fa
80105af1:	e8 9a a8 ff ff       	call   80100390 <panic>
80105af6:	8d 76 00             	lea    0x0(%esi),%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_open>:

int
sys_open(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b06:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b09:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b0c:	50                   	push   %eax
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 3c f8 ff ff       	call   80105350 <argstr>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 88 1d 01 00 00    	js     80105c3c <sys_open+0x13c>
80105b1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b22:	83 ec 08             	sub    $0x8,%esp
80105b25:	50                   	push   %eax
80105b26:	6a 01                	push   $0x1
80105b28:	e8 73 f7 ff ff       	call   801052a0 <argint>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	0f 88 04 01 00 00    	js     80105c3c <sys_open+0x13c>
    return -1;

  begin_op();
80105b38:	e8 93 d0 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
80105b3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b41:	0f 85 a9 00 00 00    	jne    80105bf0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b47:	83 ec 0c             	sub    $0xc,%esp
80105b4a:	ff 75 e0             	pushl  -0x20(%ebp)
80105b4d:	e8 be c3 ff ff       	call   80101f10 <namei>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	89 c6                	mov    %eax,%esi
80105b59:	0f 84 b2 00 00 00    	je     80105c11 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105b5f:	83 ec 0c             	sub    $0xc,%esp
80105b62:	50                   	push   %eax
80105b63:	e8 48 bb ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b70:	0f 84 aa 00 00 00    	je     80105c20 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b76:	e8 35 b2 ff ff       	call   80100db0 <filealloc>
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c7                	mov    %eax,%edi
80105b7f:	0f 84 a6 00 00 00    	je     80105c2b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105b85:	e8 f6 dd ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b8a:	31 db                	xor    %ebx,%ebx
80105b8c:	eb 0e                	jmp    80105b9c <sys_open+0x9c>
80105b8e:	66 90                	xchg   %ax,%ax
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	0f 84 ac 00 00 00    	je     80105c48 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b9c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ba0:	85 d2                	test   %edx,%edx
80105ba2:	75 ec                	jne    80105b90 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ba7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bab:	56                   	push   %esi
80105bac:	e8 df bb ff ff       	call   80101790 <iunlock>
  end_op();
80105bb1:	e8 8a d0 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105bb6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bbf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bc2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105bc5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bcc:	89 d0                	mov    %edx,%eax
80105bce:	f7 d0                	not    %eax
80105bd0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bd6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be0:	89 d8                	mov    %ebx,%eax
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bf6:	31 c9                	xor    %ecx,%ecx
80105bf8:	6a 00                	push   $0x0
80105bfa:	ba 02 00 00 00       	mov    $0x2,%edx
80105bff:	e8 ec f7 ff ff       	call   801053f0 <create>
    if(ip == 0){
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105c09:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c0b:	0f 85 65 ff ff ff    	jne    80105b76 <sys_open+0x76>
      end_op();
80105c11:	e8 2a d0 ff ff       	call   80102c40 <end_op>
      return -1;
80105c16:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c1b:	eb c0                	jmp    80105bdd <sys_open+0xdd>
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c23:	85 c9                	test   %ecx,%ecx
80105c25:	0f 84 4b ff ff ff    	je     80105b76 <sys_open+0x76>
    iunlockput(ip);
80105c2b:	83 ec 0c             	sub    $0xc,%esp
80105c2e:	56                   	push   %esi
80105c2f:	e8 0c bd ff ff       	call   80101940 <iunlockput>
    end_op();
80105c34:	e8 07 d0 ff ff       	call   80102c40 <end_op>
    return -1;
80105c39:	83 c4 10             	add    $0x10,%esp
80105c3c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c41:	eb 9a                	jmp    80105bdd <sys_open+0xdd>
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	57                   	push   %edi
80105c4c:	e8 1f b2 ff ff       	call   80100e70 <fileclose>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	eb d5                	jmp    80105c2b <sys_open+0x12b>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c66:	e8 65 cf ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6e:	83 ec 08             	sub    $0x8,%esp
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 d7 f6 ff ff       	call   80105350 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 30                	js     80105cb0 <sys_mkdir+0x50>
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	31 c9                	xor    %ecx,%ecx
80105c88:	6a 00                	push   $0x0
80105c8a:	ba 01 00 00 00       	mov    $0x1,%edx
80105c8f:	e8 5c f7 ff ff       	call   801053f0 <create>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	85 c0                	test   %eax,%eax
80105c99:	74 15                	je     80105cb0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c9b:	83 ec 0c             	sub    $0xc,%esp
80105c9e:	50                   	push   %eax
80105c9f:	e8 9c bc ff ff       	call   80101940 <iunlockput>
  end_op();
80105ca4:	e8 97 cf ff ff       	call   80102c40 <end_op>
  return 0;
80105ca9:	83 c4 10             	add    $0x10,%esp
80105cac:	31 c0                	xor    %eax,%eax
}
80105cae:	c9                   	leave  
80105caf:	c3                   	ret    
    end_op();
80105cb0:	e8 8b cf ff ff       	call   80102c40 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_mknod>:

int
sys_mknod(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cc6:	e8 05 cf ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ccb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	50                   	push   %eax
80105cd2:	6a 00                	push   $0x0
80105cd4:	e8 77 f6 ff ff       	call   80105350 <argstr>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	85 c0                	test   %eax,%eax
80105cde:	78 60                	js     80105d40 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ce0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce3:	83 ec 08             	sub    $0x8,%esp
80105ce6:	50                   	push   %eax
80105ce7:	6a 01                	push   $0x1
80105ce9:	e8 b2 f5 ff ff       	call   801052a0 <argint>
  if((argstr(0, &path)) < 0 ||
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	78 4b                	js     80105d40 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf8:	83 ec 08             	sub    $0x8,%esp
80105cfb:	50                   	push   %eax
80105cfc:	6a 02                	push   $0x2
80105cfe:	e8 9d f5 ff ff       	call   801052a0 <argint>
     argint(1, &major) < 0 ||
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	85 c0                	test   %eax,%eax
80105d08:	78 36                	js     80105d40 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d0e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d11:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105d15:	ba 03 00 00 00       	mov    $0x3,%edx
80105d1a:	50                   	push   %eax
80105d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d1e:	e8 cd f6 ff ff       	call   801053f0 <create>
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	74 16                	je     80105d40 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d2a:	83 ec 0c             	sub    $0xc,%esp
80105d2d:	50                   	push   %eax
80105d2e:	e8 0d bc ff ff       	call   80101940 <iunlockput>
  end_op();
80105d33:	e8 08 cf ff ff       	call   80102c40 <end_op>
  return 0;
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	31 c0                	xor    %eax,%eax
}
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop
    end_op();
80105d40:	e8 fb ce ff ff       	call   80102c40 <end_op>
    return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_chdir>:

int
sys_chdir(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	56                   	push   %esi
80105d54:	53                   	push   %ebx
80105d55:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d58:	e8 23 dc ff ff       	call   80103980 <myproc>
80105d5d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d5f:	e8 6c ce ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d67:	83 ec 08             	sub    $0x8,%esp
80105d6a:	50                   	push   %eax
80105d6b:	6a 00                	push   $0x0
80105d6d:	e8 de f5 ff ff       	call   80105350 <argstr>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	85 c0                	test   %eax,%eax
80105d77:	78 77                	js     80105df0 <sys_chdir+0xa0>
80105d79:	83 ec 0c             	sub    $0xc,%esp
80105d7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7f:	e8 8c c1 ff ff       	call   80101f10 <namei>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	89 c3                	mov    %eax,%ebx
80105d8b:	74 63                	je     80105df0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	50                   	push   %eax
80105d91:	e8 1a b9 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105d96:	83 c4 10             	add    $0x10,%esp
80105d99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d9e:	75 30                	jne    80105dd0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	53                   	push   %ebx
80105da4:	e8 e7 b9 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105da9:	58                   	pop    %eax
80105daa:	ff 76 68             	pushl  0x68(%esi)
80105dad:	e8 2e ba ff ff       	call   801017e0 <iput>
  end_op();
80105db2:	e8 89 ce ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
80105db7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	31 c0                	xor    %eax,%eax
}
80105dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dc2:	5b                   	pop    %ebx
80105dc3:	5e                   	pop    %esi
80105dc4:	5d                   	pop    %ebp
80105dc5:	c3                   	ret    
80105dc6:	8d 76 00             	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	53                   	push   %ebx
80105dd4:	e8 67 bb ff ff       	call   80101940 <iunlockput>
    end_op();
80105dd9:	e8 62 ce ff ff       	call   80102c40 <end_op>
    return -1;
80105dde:	83 c4 10             	add    $0x10,%esp
80105de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de6:	eb d7                	jmp    80105dbf <sys_chdir+0x6f>
80105de8:	90                   	nop
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105df0:	e8 4b ce ff ff       	call   80102c40 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfa:	eb c3                	jmp    80105dbf <sys_chdir+0x6f>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_exec>:

int
sys_exec(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e06:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e12:	50                   	push   %eax
80105e13:	6a 00                	push   $0x0
80105e15:	e8 36 f5 ff ff       	call   80105350 <argstr>
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	0f 88 87 00 00 00    	js     80105eac <sys_exec+0xac>
80105e25:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	50                   	push   %eax
80105e2f:	6a 01                	push   $0x1
80105e31:	e8 6a f4 ff ff       	call   801052a0 <argint>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 6f                	js     80105eac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e3d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e43:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105e46:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e48:	68 80 00 00 00       	push   $0x80
80105e4d:	6a 00                	push   $0x0
80105e4f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e55:	50                   	push   %eax
80105e56:	e8 45 f1 ff ff       	call   80104fa0 <memset>
80105e5b:	83 c4 10             	add    $0x10,%esp
80105e5e:	eb 2c                	jmp    80105e8c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e60:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e66:	85 c0                	test   %eax,%eax
80105e68:	74 56                	je     80105ec0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e6a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e76:	52                   	push   %edx
80105e77:	50                   	push   %eax
80105e78:	e8 b3 f3 ff ff       	call   80105230 <fetchstr>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	85 c0                	test   %eax,%eax
80105e82:	78 28                	js     80105eac <sys_exec+0xac>
  for(i=0;; i++){
80105e84:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e87:	83 fb 20             	cmp    $0x20,%ebx
80105e8a:	74 20                	je     80105eac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e8c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e92:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e99:	83 ec 08             	sub    $0x8,%esp
80105e9c:	57                   	push   %edi
80105e9d:	01 f0                	add    %esi,%eax
80105e9f:	50                   	push   %eax
80105ea0:	e8 4b f3 ff ff       	call   801051f0 <fetchint>
80105ea5:	83 c4 10             	add    $0x10,%esp
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	79 b4                	jns    80105e60 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb4:	5b                   	pop    %ebx
80105eb5:	5e                   	pop    %esi
80105eb6:	5f                   	pop    %edi
80105eb7:	5d                   	pop    %ebp
80105eb8:	c3                   	ret    
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ec0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ec6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ec9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ed0:	00 00 00 00 
  return exec(path, argv);
80105ed4:	50                   	push   %eax
80105ed5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105edb:	e8 30 ab ff ff       	call   80100a10 <exec>
80105ee0:	83 c4 10             	add    $0x10,%esp
}
80105ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee6:	5b                   	pop    %ebx
80105ee7:	5e                   	pop    %esi
80105ee8:	5f                   	pop    %edi
80105ee9:	5d                   	pop    %ebp
80105eea:	c3                   	ret    
80105eeb:	90                   	nop
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_pipe>:

int
sys_pipe(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ef6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ef9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105efc:	6a 08                	push   $0x8
80105efe:	50                   	push   %eax
80105eff:	6a 00                	push   $0x0
80105f01:	e8 ea f3 ff ff       	call   801052f0 <argptr>
80105f06:	83 c4 10             	add    $0x10,%esp
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	0f 88 ae 00 00 00    	js     80105fbf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f14:	83 ec 08             	sub    $0x8,%esp
80105f17:	50                   	push   %eax
80105f18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f1b:	50                   	push   %eax
80105f1c:	e8 3f d3 ff ff       	call   80103260 <pipealloc>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 88 93 00 00 00    	js     80105fbf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f2f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f31:	e8 4a da ff ff       	call   80103980 <myproc>
80105f36:	eb 10                	jmp    80105f48 <sys_pipe+0x58>
80105f38:	90                   	nop
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f40:	83 c3 01             	add    $0x1,%ebx
80105f43:	83 fb 10             	cmp    $0x10,%ebx
80105f46:	74 60                	je     80105fa8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105f48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f4c:	85 f6                	test   %esi,%esi
80105f4e:	75 f0                	jne    80105f40 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105f50:	8d 73 08             	lea    0x8(%ebx),%esi
80105f53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f5a:	e8 21 da ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f5f:	31 d2                	xor    %edx,%edx
80105f61:	eb 0d                	jmp    80105f70 <sys_pipe+0x80>
80105f63:	90                   	nop
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f68:	83 c2 01             	add    $0x1,%edx
80105f6b:	83 fa 10             	cmp    $0x10,%edx
80105f6e:	74 28                	je     80105f98 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f70:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f74:	85 c9                	test   %ecx,%ecx
80105f76:	75 f0                	jne    80105f68 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f78:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f7f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f84:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f87:	31 c0                	xor    %eax,%eax
}
80105f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f8c:	5b                   	pop    %ebx
80105f8d:	5e                   	pop    %esi
80105f8e:	5f                   	pop    %edi
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f98:	e8 e3 d9 ff ff       	call   80103980 <myproc>
80105f9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fa4:	00 
80105fa5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 e0             	pushl  -0x20(%ebp)
80105fae:	e8 bd ae ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105fb3:	58                   	pop    %eax
80105fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fb7:	e8 b4 ae ff ff       	call   80100e70 <fileclose>
    return -1;
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc4:	eb c3                	jmp    80105f89 <sys_pipe+0x99>
80105fc6:	66 90                	xchg   %ax,%ax
80105fc8:	66 90                	xchg   %ax,%ax
80105fca:	66 90                	xchg   %ax,%ax
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105fd3:	5d                   	pop    %ebp
  return fork();
80105fd4:	e9 47 db ff ff       	jmp    80103b20 <fork>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exit>:

int
sys_exit(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fe6:	e8 15 e2 ff ff       	call   80104200 <exit>
  return 0;  // not reached
}
80105feb:	31 c0                	xor    %eax,%eax
80105fed:	c9                   	leave  
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <sys_wait>:

int
sys_wait(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ff3:	5d                   	pop    %ebp
  return wait();
80105ff4:	e9 47 e4 ff ff       	jmp    80104440 <wait>
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_kill>:

int
sys_kill(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106006:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	6a 00                	push   $0x0
8010600c:	e8 8f f2 ff ff       	call   801052a0 <argint>
80106011:	83 c4 10             	add    $0x10,%esp
80106014:	85 c0                	test   %eax,%eax
80106016:	78 18                	js     80106030 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 f4             	pushl  -0xc(%ebp)
8010601e:	e8 7d e5 ff ff       	call   801045a0 <kill>
80106023:	83 c4 10             	add    $0x10,%esp
}
80106026:	c9                   	leave  
80106027:	c3                   	ret    
80106028:	90                   	nop
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_getpid>:

int
sys_getpid(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106046:	e8 35 d9 ff ff       	call   80103980 <myproc>
8010604b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010604e:	c9                   	leave  
8010604f:	c3                   	ret    

80106050 <sys_sbrk>:

int
sys_sbrk(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106054:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106057:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010605a:	50                   	push   %eax
8010605b:	6a 00                	push   $0x0
8010605d:	e8 3e f2 ff ff       	call   801052a0 <argint>
80106062:	83 c4 10             	add    $0x10,%esp
80106065:	85 c0                	test   %eax,%eax
80106067:	78 27                	js     80106090 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106069:	e8 12 d9 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
8010606e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106071:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106073:	ff 75 f4             	pushl  -0xc(%ebp)
80106076:	e8 25 da ff ff       	call   80103aa0 <growproc>
8010607b:	83 c4 10             	add    $0x10,%esp
8010607e:	85 c0                	test   %eax,%eax
80106080:	78 0e                	js     80106090 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106082:	89 d8                	mov    %ebx,%eax
80106084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106087:	c9                   	leave  
80106088:	c3                   	ret    
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106090:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106095:	eb eb                	jmp    80106082 <sys_sbrk+0x32>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <sys_sleep>:

int
sys_sleep(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801060a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060aa:	50                   	push   %eax
801060ab:	6a 00                	push   $0x0
801060ad:	e8 ee f1 ff ff       	call   801052a0 <argint>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	0f 88 8a 00 00 00    	js     80106147 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060bd:	83 ec 0c             	sub    $0xc,%esp
801060c0:	68 80 5c 11 80       	push   $0x80115c80
801060c5:	e8 c6 ed ff ff       	call   80104e90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060cd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801060d0:	8b 1d c0 64 11 80    	mov    0x801164c0,%ebx
  while(ticks - ticks0 < n){
801060d6:	85 d2                	test   %edx,%edx
801060d8:	75 27                	jne    80106101 <sys_sleep+0x61>
801060da:	eb 54                	jmp    80106130 <sys_sleep+0x90>
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	68 80 5c 11 80       	push   $0x80115c80
801060e8:	68 c0 64 11 80       	push   $0x801164c0
801060ed:	e8 8e e2 ff ff       	call   80104380 <sleep>
  while(ticks - ticks0 < n){
801060f2:	a1 c0 64 11 80       	mov    0x801164c0,%eax
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	29 d8                	sub    %ebx,%eax
801060fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060ff:	73 2f                	jae    80106130 <sys_sleep+0x90>
    if(myproc()->killed){
80106101:	e8 7a d8 ff ff       	call   80103980 <myproc>
80106106:	8b 40 24             	mov    0x24(%eax),%eax
80106109:	85 c0                	test   %eax,%eax
8010610b:	74 d3                	je     801060e0 <sys_sleep+0x40>
      release(&tickslock);
8010610d:	83 ec 0c             	sub    $0xc,%esp
80106110:	68 80 5c 11 80       	push   $0x80115c80
80106115:	e8 36 ee ff ff       	call   80104f50 <release>
      return -1;
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	68 80 5c 11 80       	push   $0x80115c80
80106138:	e8 13 ee ff ff       	call   80104f50 <release>
  return 0;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	31 c0                	xor    %eax,%eax
}
80106142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106145:	c9                   	leave  
80106146:	c3                   	ret    
    return -1;
80106147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614c:	eb f4                	jmp    80106142 <sys_sleep+0xa2>
8010614e:	66 90                	xchg   %ax,%ax

80106150 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	53                   	push   %ebx
80106154:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106157:	68 80 5c 11 80       	push   $0x80115c80
8010615c:	e8 2f ed ff ff       	call   80104e90 <acquire>
  xticks = ticks;
80106161:	8b 1d c0 64 11 80    	mov    0x801164c0,%ebx
  release(&tickslock);
80106167:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010616e:	e8 dd ed ff ff       	call   80104f50 <release>
  return xticks;
}
80106173:	89 d8                	mov    %ebx,%eax
80106175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106178:	c9                   	leave  
80106179:	c3                   	ret    
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106180 <sys_changeQueueNum>:

int
sys_changeQueueNum(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	83 ec 20             	sub    $0x20,%esp
  int pid, destinationQueue;
  argint(0,&pid);
80106186:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106189:	50                   	push   %eax
8010618a:	6a 00                	push   $0x0
8010618c:	e8 0f f1 ff ff       	call   801052a0 <argint>
  argint(1,&destinationQueue);  
80106191:	58                   	pop    %eax
80106192:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106195:	5a                   	pop    %edx
80106196:	50                   	push   %eax
80106197:	6a 01                	push   $0x1
80106199:	e8 02 f1 ff ff       	call   801052a0 <argint>
  
  // cprintf("pid = %d des = %d\n", pid, destinationQueue);
  return changeQueueNum(pid, destinationQueue);
8010619e:	59                   	pop    %ecx
8010619f:	58                   	pop    %eax
801061a0:	ff 75 f4             	pushl  -0xc(%ebp)
801061a3:	ff 75 f0             	pushl  -0x10(%ebp)
801061a6:	e8 45 e5 ff ff       	call   801046f0 <changeQueueNum>
}
801061ab:	c9                   	leave  
801061ac:	c3                   	ret    
801061ad:	8d 76 00             	lea    0x0(%esi),%esi

801061b0 <sys_evalTicket>:
int
sys_evalTicket(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket;
  argint(0,&pid);
801061b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061b9:	50                   	push   %eax
801061ba:	6a 00                	push   $0x0
801061bc:	e8 df f0 ff ff       	call   801052a0 <argint>
  argint(1,&ticket);  
801061c1:	58                   	pop    %eax
801061c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c5:	5a                   	pop    %edx
801061c6:	50                   	push   %eax
801061c7:	6a 01                	push   $0x1
801061c9:	e8 d2 f0 ff ff       	call   801052a0 <argint>
  
  // cprintf("pid = %d des = %d\n", pid, ticket);
  return evalTicket(pid, ticket);
801061ce:	59                   	pop    %ecx
801061cf:	58                   	pop    %eax
801061d0:	ff 75 f4             	pushl  -0xc(%ebp)
801061d3:	ff 75 f0             	pushl  -0x10(%ebp)
801061d6:	e8 55 e5 ff ff       	call   80104730 <evalTicket>
}
801061db:	c9                   	leave  
801061dc:	c3                   	ret    
801061dd:	8d 76 00             	lea    0x0(%esi),%esi

801061e0 <sys_evalRemainingPriority>:
int
sys_evalRemainingPriority(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  char *priority;
  argint(0, &pid);
801061e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061e9:	50                   	push   %eax
801061ea:	6a 00                	push   $0x0
801061ec:	e8 af f0 ff ff       	call   801052a0 <argint>
  argstr(1, &priority);  
801061f1:	58                   	pop    %eax
801061f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061f5:	5a                   	pop    %edx
801061f6:	50                   	push   %eax
801061f7:	6a 01                	push   $0x1
801061f9:	e8 52 f1 ff ff       	call   80105350 <argstr>

  // cprintf("pid = %d des = %s\n", pid, priority);
  return evalRemainingPriority(pid, priority);
801061fe:	59                   	pop    %ecx
801061ff:	58                   	pop    %eax
80106200:	ff 75 f4             	pushl  -0xc(%ebp)
80106203:	ff 75 f0             	pushl  -0x10(%ebp)
80106206:	e8 f5 e5 ff ff       	call   80104800 <evalRemainingPriority>
}
8010620b:	c9                   	leave  
8010620c:	c3                   	ret    
8010620d:	8d 76 00             	lea    0x0(%esi),%esi

80106210 <sys_printInfo>:
int
sys_printInfo(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
  return printInfo();
}
80106213:	5d                   	pop    %ebp
  return printInfo();
80106214:	e9 97 e6 ff ff       	jmp    801048b0 <printInfo>

80106219 <alltraps>:
80106219:	1e                   	push   %ds
8010621a:	06                   	push   %es
8010621b:	0f a0                	push   %fs
8010621d:	0f a8                	push   %gs
8010621f:	60                   	pusha  
80106220:	66 b8 10 00          	mov    $0x10,%ax
80106224:	8e d8                	mov    %eax,%ds
80106226:	8e c0                	mov    %eax,%es
80106228:	54                   	push   %esp
80106229:	e8 c2 00 00 00       	call   801062f0 <trap>
8010622e:	83 c4 04             	add    $0x4,%esp

80106231 <trapret>:
80106231:	61                   	popa   
80106232:	0f a9                	pop    %gs
80106234:	0f a1                	pop    %fs
80106236:	07                   	pop    %es
80106237:	1f                   	pop    %ds
80106238:	83 c4 08             	add    $0x8,%esp
8010623b:	cf                   	iret   
8010623c:	66 90                	xchg   %ax,%ax
8010623e:	66 90                	xchg   %ax,%ax

80106240 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106240:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106241:	31 c0                	xor    %eax,%eax
{
80106243:	89 e5                	mov    %esp,%ebp
80106245:	83 ec 08             	sub    $0x8,%esp
80106248:	90                   	nop
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106250:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106257:	c7 04 c5 c2 5c 11 80 	movl   $0x8e000008,-0x7feea33e(,%eax,8)
8010625e:	08 00 00 8e 
80106262:	66 89 14 c5 c0 5c 11 	mov    %dx,-0x7feea340(,%eax,8)
80106269:	80 
8010626a:	c1 ea 10             	shr    $0x10,%edx
8010626d:	66 89 14 c5 c6 5c 11 	mov    %dx,-0x7feea33a(,%eax,8)
80106274:	80 
  for(i = 0; i < 256; i++)
80106275:	83 c0 01             	add    $0x1,%eax
80106278:	3d 00 01 00 00       	cmp    $0x100,%eax
8010627d:	75 d1                	jne    80106250 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010627f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106284:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106287:	c7 05 c2 5e 11 80 08 	movl   $0xef000008,0x80115ec2
8010628e:	00 00 ef 
  initlock(&tickslock, "time");
80106291:	68 09 84 10 80       	push   $0x80108409
80106296:	68 80 5c 11 80       	push   $0x80115c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010629b:	66 a3 c0 5e 11 80    	mov    %ax,0x80115ec0
801062a1:	c1 e8 10             	shr    $0x10,%eax
801062a4:	66 a3 c6 5e 11 80    	mov    %ax,0x80115ec6
  initlock(&tickslock, "time");
801062aa:	e8 a1 ea ff ff       	call   80104d50 <initlock>
}
801062af:	83 c4 10             	add    $0x10,%esp
801062b2:	c9                   	leave  
801062b3:	c3                   	ret    
801062b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801062c0 <idtinit>:

void
idtinit(void)
{
801062c0:	55                   	push   %ebp
  pd[0] = size-1;
801062c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062c6:	89 e5                	mov    %esp,%ebp
801062c8:	83 ec 10             	sub    $0x10,%esp
801062cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062cf:	b8 c0 5c 11 80       	mov    $0x80115cc0,%eax
801062d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062d8:	c1 e8 10             	shr    $0x10,%eax
801062db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
801062f5:	53                   	push   %ebx
801062f6:	83 ec 1c             	sub    $0x1c,%esp
801062f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062fc:	8b 47 30             	mov    0x30(%edi),%eax
801062ff:	83 f8 40             	cmp    $0x40,%eax
80106302:	0f 84 f0 00 00 00    	je     801063f8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106308:	83 e8 20             	sub    $0x20,%eax
8010630b:	83 f8 1f             	cmp    $0x1f,%eax
8010630e:	77 10                	ja     80106320 <trap+0x30>
80106310:	ff 24 85 b0 84 10 80 	jmp    *-0x7fef7b50(,%eax,4)
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106320:	e8 5b d6 ff ff       	call   80103980 <myproc>
80106325:	85 c0                	test   %eax,%eax
80106327:	8b 5f 38             	mov    0x38(%edi),%ebx
8010632a:	0f 84 14 02 00 00    	je     80106544 <trap+0x254>
80106330:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106334:	0f 84 0a 02 00 00    	je     80106544 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010633a:	0f 20 d1             	mov    %cr2,%ecx
8010633d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106340:	e8 1b d6 ff ff       	call   80103960 <cpuid>
80106345:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106348:	8b 47 34             	mov    0x34(%edi),%eax
8010634b:	8b 77 30             	mov    0x30(%edi),%esi
8010634e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106351:	e8 2a d6 ff ff       	call   80103980 <myproc>
80106356:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106359:	e8 22 d6 ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010635e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106361:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106364:	51                   	push   %ecx
80106365:	53                   	push   %ebx
80106366:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106367:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010636a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010636d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010636e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106371:	52                   	push   %edx
80106372:	ff 70 10             	pushl  0x10(%eax)
80106375:	68 6c 84 10 80       	push   $0x8010846c
8010637a:	e8 e1 a2 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010637f:	83 c4 20             	add    $0x20,%esp
80106382:	e8 f9 d5 ff ff       	call   80103980 <myproc>
80106387:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010638e:	e8 ed d5 ff ff       	call   80103980 <myproc>
80106393:	85 c0                	test   %eax,%eax
80106395:	74 1d                	je     801063b4 <trap+0xc4>
80106397:	e8 e4 d5 ff ff       	call   80103980 <myproc>
8010639c:	8b 50 24             	mov    0x24(%eax),%edx
8010639f:	85 d2                	test   %edx,%edx
801063a1:	74 11                	je     801063b4 <trap+0xc4>
801063a3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063a7:	83 e0 03             	and    $0x3,%eax
801063aa:	66 83 f8 03          	cmp    $0x3,%ax
801063ae:	0f 84 4c 01 00 00    	je     80106500 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063b4:	e8 c7 d5 ff ff       	call   80103980 <myproc>
801063b9:	85 c0                	test   %eax,%eax
801063bb:	74 0b                	je     801063c8 <trap+0xd8>
801063bd:	e8 be d5 ff ff       	call   80103980 <myproc>
801063c2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063c6:	74 68                	je     80106430 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c8:	e8 b3 d5 ff ff       	call   80103980 <myproc>
801063cd:	85 c0                	test   %eax,%eax
801063cf:	74 19                	je     801063ea <trap+0xfa>
801063d1:	e8 aa d5 ff ff       	call   80103980 <myproc>
801063d6:	8b 40 24             	mov    0x24(%eax),%eax
801063d9:	85 c0                	test   %eax,%eax
801063db:	74 0d                	je     801063ea <trap+0xfa>
801063dd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063e1:	83 e0 03             	and    $0x3,%eax
801063e4:	66 83 f8 03          	cmp    $0x3,%ax
801063e8:	74 37                	je     80106421 <trap+0x131>
    exit();
}
801063ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ed:	5b                   	pop    %ebx
801063ee:	5e                   	pop    %esi
801063ef:	5f                   	pop    %edi
801063f0:	5d                   	pop    %ebp
801063f1:	c3                   	ret    
801063f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801063f8:	e8 83 d5 ff ff       	call   80103980 <myproc>
801063fd:	8b 58 24             	mov    0x24(%eax),%ebx
80106400:	85 db                	test   %ebx,%ebx
80106402:	0f 85 e8 00 00 00    	jne    801064f0 <trap+0x200>
    myproc()->tf = tf;
80106408:	e8 73 d5 ff ff       	call   80103980 <myproc>
8010640d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106410:	e8 7b ef ff ff       	call   80105390 <syscall>
    if(myproc()->killed)
80106415:	e8 66 d5 ff ff       	call   80103980 <myproc>
8010641a:	8b 48 24             	mov    0x24(%eax),%ecx
8010641d:	85 c9                	test   %ecx,%ecx
8010641f:	74 c9                	je     801063ea <trap+0xfa>
}
80106421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106424:	5b                   	pop    %ebx
80106425:	5e                   	pop    %esi
80106426:	5f                   	pop    %edi
80106427:	5d                   	pop    %ebp
      exit();
80106428:	e9 d3 dd ff ff       	jmp    80104200 <exit>
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106430:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106434:	75 92                	jne    801063c8 <trap+0xd8>
    yield();
80106436:	e8 f5 de ff ff       	call   80104330 <yield>
8010643b:	eb 8b                	jmp    801063c8 <trap+0xd8>
8010643d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106440:	e8 1b d5 ff ff       	call   80103960 <cpuid>
80106445:	85 c0                	test   %eax,%eax
80106447:	0f 84 c3 00 00 00    	je     80106510 <trap+0x220>
    lapiceoi();
8010644d:	e8 2e c3 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106452:	e8 29 d5 ff ff       	call   80103980 <myproc>
80106457:	85 c0                	test   %eax,%eax
80106459:	0f 85 38 ff ff ff    	jne    80106397 <trap+0xa7>
8010645f:	e9 50 ff ff ff       	jmp    801063b4 <trap+0xc4>
80106464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106468:	e8 d3 c1 ff ff       	call   80102640 <kbdintr>
    lapiceoi();
8010646d:	e8 0e c3 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106472:	e8 09 d5 ff ff       	call   80103980 <myproc>
80106477:	85 c0                	test   %eax,%eax
80106479:	0f 85 18 ff ff ff    	jne    80106397 <trap+0xa7>
8010647f:	e9 30 ff ff ff       	jmp    801063b4 <trap+0xc4>
80106484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106488:	e8 53 02 00 00       	call   801066e0 <uartintr>
    lapiceoi();
8010648d:	e8 ee c2 ff ff       	call   80102780 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106492:	e8 e9 d4 ff ff       	call   80103980 <myproc>
80106497:	85 c0                	test   %eax,%eax
80106499:	0f 85 f8 fe ff ff    	jne    80106397 <trap+0xa7>
8010649f:	e9 10 ff ff ff       	jmp    801063b4 <trap+0xc4>
801064a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064a8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801064ac:	8b 77 38             	mov    0x38(%edi),%esi
801064af:	e8 ac d4 ff ff       	call   80103960 <cpuid>
801064b4:	56                   	push   %esi
801064b5:	53                   	push   %ebx
801064b6:	50                   	push   %eax
801064b7:	68 14 84 10 80       	push   $0x80108414
801064bc:	e8 9f a1 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801064c1:	e8 ba c2 ff ff       	call   80102780 <lapiceoi>
    break;
801064c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c9:	e8 b2 d4 ff ff       	call   80103980 <myproc>
801064ce:	85 c0                	test   %eax,%eax
801064d0:	0f 85 c1 fe ff ff    	jne    80106397 <trap+0xa7>
801064d6:	e9 d9 fe ff ff       	jmp    801063b4 <trap+0xc4>
801064db:	90                   	nop
801064dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801064e0:	e8 cb bb ff ff       	call   801020b0 <ideintr>
801064e5:	e9 63 ff ff ff       	jmp    8010644d <trap+0x15d>
801064ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801064f0:	e8 0b dd ff ff       	call   80104200 <exit>
801064f5:	e9 0e ff ff ff       	jmp    80106408 <trap+0x118>
801064fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106500:	e8 fb dc ff ff       	call   80104200 <exit>
80106505:	e9 aa fe ff ff       	jmp    801063b4 <trap+0xc4>
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 80 5c 11 80       	push   $0x80115c80
80106518:	e8 73 e9 ff ff       	call   80104e90 <acquire>
      wakeup(&ticks);
8010651d:	c7 04 24 c0 64 11 80 	movl   $0x801164c0,(%esp)
      ticks++;
80106524:	83 05 c0 64 11 80 01 	addl   $0x1,0x801164c0
      wakeup(&ticks);
8010652b:	e8 10 e0 ff ff       	call   80104540 <wakeup>
      release(&tickslock);
80106530:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80106537:	e8 14 ea ff ff       	call   80104f50 <release>
8010653c:	83 c4 10             	add    $0x10,%esp
8010653f:	e9 09 ff ff ff       	jmp    8010644d <trap+0x15d>
80106544:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106547:	e8 14 d4 ff ff       	call   80103960 <cpuid>
8010654c:	83 ec 0c             	sub    $0xc,%esp
8010654f:	56                   	push   %esi
80106550:	53                   	push   %ebx
80106551:	50                   	push   %eax
80106552:	ff 77 30             	pushl  0x30(%edi)
80106555:	68 38 84 10 80       	push   $0x80108438
8010655a:	e8 01 a1 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010655f:	83 c4 14             	add    $0x14,%esp
80106562:	68 0e 84 10 80       	push   $0x8010840e
80106567:	e8 24 9e ff ff       	call   80100390 <panic>
8010656c:	66 90                	xchg   %ax,%ax
8010656e:	66 90                	xchg   %ax,%ax

80106570 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106570:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106575:	55                   	push   %ebp
80106576:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106578:	85 c0                	test   %eax,%eax
8010657a:	74 1c                	je     80106598 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010657c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106581:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106582:	a8 01                	test   $0x1,%al
80106584:	74 12                	je     80106598 <uartgetc+0x28>
80106586:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010658c:	0f b6 c0             	movzbl %al,%eax
}
8010658f:	5d                   	pop    %ebp
80106590:	c3                   	ret    
80106591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010659d:	5d                   	pop    %ebp
8010659e:	c3                   	ret    
8010659f:	90                   	nop

801065a0 <uartputc.part.0>:
uartputc(int c)
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
801065a6:	89 c7                	mov    %eax,%edi
801065a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801065ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801065b2:	83 ec 0c             	sub    $0xc,%esp
801065b5:	eb 1b                	jmp    801065d2 <uartputc.part.0+0x32>
801065b7:	89 f6                	mov    %esi,%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	6a 0a                	push   $0xa
801065c5:	e8 d6 c1 ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	83 eb 01             	sub    $0x1,%ebx
801065d0:	74 07                	je     801065d9 <uartputc.part.0+0x39>
801065d2:	89 f2                	mov    %esi,%edx
801065d4:	ec                   	in     (%dx),%al
801065d5:	a8 20                	test   $0x20,%al
801065d7:	74 e7                	je     801065c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065de:	89 f8                	mov    %edi,%eax
801065e0:	ee                   	out    %al,(%dx)
}
801065e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065e4:	5b                   	pop    %ebx
801065e5:	5e                   	pop    %esi
801065e6:	5f                   	pop    %edi
801065e7:	5d                   	pop    %ebp
801065e8:	c3                   	ret    
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <uartinit>:
{
801065f0:	55                   	push   %ebp
801065f1:	31 c9                	xor    %ecx,%ecx
801065f3:	89 c8                	mov    %ecx,%eax
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	57                   	push   %edi
801065f8:	56                   	push   %esi
801065f9:	53                   	push   %ebx
801065fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065ff:	89 da                	mov    %ebx,%edx
80106601:	83 ec 0c             	sub    $0xc,%esp
80106604:	ee                   	out    %al,(%dx)
80106605:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010660a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010660f:	89 fa                	mov    %edi,%edx
80106611:	ee                   	out    %al,(%dx)
80106612:	b8 0c 00 00 00       	mov    $0xc,%eax
80106617:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010661c:	ee                   	out    %al,(%dx)
8010661d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106622:	89 c8                	mov    %ecx,%eax
80106624:	89 f2                	mov    %esi,%edx
80106626:	ee                   	out    %al,(%dx)
80106627:	b8 03 00 00 00       	mov    $0x3,%eax
8010662c:	89 fa                	mov    %edi,%edx
8010662e:	ee                   	out    %al,(%dx)
8010662f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106634:	89 c8                	mov    %ecx,%eax
80106636:	ee                   	out    %al,(%dx)
80106637:	b8 01 00 00 00       	mov    $0x1,%eax
8010663c:	89 f2                	mov    %esi,%edx
8010663e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010663f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106644:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106645:	3c ff                	cmp    $0xff,%al
80106647:	74 5a                	je     801066a3 <uartinit+0xb3>
  uart = 1;
80106649:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106650:	00 00 00 
80106653:	89 da                	mov    %ebx,%edx
80106655:	ec                   	in     (%dx),%al
80106656:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010665b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010665c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010665f:	bb 30 85 10 80       	mov    $0x80108530,%ebx
  ioapicenable(IRQ_COM1, 0);
80106664:	6a 00                	push   $0x0
80106666:	6a 04                	push   $0x4
80106668:	e8 93 bc ff ff       	call   80102300 <ioapicenable>
8010666d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106670:	b8 78 00 00 00       	mov    $0x78,%eax
80106675:	eb 13                	jmp    8010668a <uartinit+0x9a>
80106677:	89 f6                	mov    %esi,%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106680:	83 c3 01             	add    $0x1,%ebx
80106683:	0f be 03             	movsbl (%ebx),%eax
80106686:	84 c0                	test   %al,%al
80106688:	74 19                	je     801066a3 <uartinit+0xb3>
  if(!uart)
8010668a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106690:	85 d2                	test   %edx,%edx
80106692:	74 ec                	je     80106680 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106694:	83 c3 01             	add    $0x1,%ebx
80106697:	e8 04 ff ff ff       	call   801065a0 <uartputc.part.0>
8010669c:	0f be 03             	movsbl (%ebx),%eax
8010669f:	84 c0                	test   %al,%al
801066a1:	75 e7                	jne    8010668a <uartinit+0x9a>
}
801066a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a6:	5b                   	pop    %ebx
801066a7:	5e                   	pop    %esi
801066a8:	5f                   	pop    %edi
801066a9:	5d                   	pop    %ebp
801066aa:	c3                   	ret    
801066ab:	90                   	nop
801066ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066b0 <uartputc>:
  if(!uart)
801066b0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801066b6:	55                   	push   %ebp
801066b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801066b9:	85 d2                	test   %edx,%edx
{
801066bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801066be:	74 10                	je     801066d0 <uartputc+0x20>
}
801066c0:	5d                   	pop    %ebp
801066c1:	e9 da fe ff ff       	jmp    801065a0 <uartputc.part.0>
801066c6:	8d 76 00             	lea    0x0(%esi),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066d0:	5d                   	pop    %ebp
801066d1:	c3                   	ret    
801066d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066e0 <uartintr>:

void
uartintr(void)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066e6:	68 70 65 10 80       	push   $0x80106570
801066eb:	e8 20 a1 ff ff       	call   80100810 <consoleintr>
}
801066f0:	83 c4 10             	add    $0x10,%esp
801066f3:	c9                   	leave  
801066f4:	c3                   	ret    

801066f5 <vector0>:
801066f5:	6a 00                	push   $0x0
801066f7:	6a 00                	push   $0x0
801066f9:	e9 1b fb ff ff       	jmp    80106219 <alltraps>

801066fe <vector1>:
801066fe:	6a 00                	push   $0x0
80106700:	6a 01                	push   $0x1
80106702:	e9 12 fb ff ff       	jmp    80106219 <alltraps>

80106707 <vector2>:
80106707:	6a 00                	push   $0x0
80106709:	6a 02                	push   $0x2
8010670b:	e9 09 fb ff ff       	jmp    80106219 <alltraps>

80106710 <vector3>:
80106710:	6a 00                	push   $0x0
80106712:	6a 03                	push   $0x3
80106714:	e9 00 fb ff ff       	jmp    80106219 <alltraps>

80106719 <vector4>:
80106719:	6a 00                	push   $0x0
8010671b:	6a 04                	push   $0x4
8010671d:	e9 f7 fa ff ff       	jmp    80106219 <alltraps>

80106722 <vector5>:
80106722:	6a 00                	push   $0x0
80106724:	6a 05                	push   $0x5
80106726:	e9 ee fa ff ff       	jmp    80106219 <alltraps>

8010672b <vector6>:
8010672b:	6a 00                	push   $0x0
8010672d:	6a 06                	push   $0x6
8010672f:	e9 e5 fa ff ff       	jmp    80106219 <alltraps>

80106734 <vector7>:
80106734:	6a 00                	push   $0x0
80106736:	6a 07                	push   $0x7
80106738:	e9 dc fa ff ff       	jmp    80106219 <alltraps>

8010673d <vector8>:
8010673d:	6a 08                	push   $0x8
8010673f:	e9 d5 fa ff ff       	jmp    80106219 <alltraps>

80106744 <vector9>:
80106744:	6a 00                	push   $0x0
80106746:	6a 09                	push   $0x9
80106748:	e9 cc fa ff ff       	jmp    80106219 <alltraps>

8010674d <vector10>:
8010674d:	6a 0a                	push   $0xa
8010674f:	e9 c5 fa ff ff       	jmp    80106219 <alltraps>

80106754 <vector11>:
80106754:	6a 0b                	push   $0xb
80106756:	e9 be fa ff ff       	jmp    80106219 <alltraps>

8010675b <vector12>:
8010675b:	6a 0c                	push   $0xc
8010675d:	e9 b7 fa ff ff       	jmp    80106219 <alltraps>

80106762 <vector13>:
80106762:	6a 0d                	push   $0xd
80106764:	e9 b0 fa ff ff       	jmp    80106219 <alltraps>

80106769 <vector14>:
80106769:	6a 0e                	push   $0xe
8010676b:	e9 a9 fa ff ff       	jmp    80106219 <alltraps>

80106770 <vector15>:
80106770:	6a 00                	push   $0x0
80106772:	6a 0f                	push   $0xf
80106774:	e9 a0 fa ff ff       	jmp    80106219 <alltraps>

80106779 <vector16>:
80106779:	6a 00                	push   $0x0
8010677b:	6a 10                	push   $0x10
8010677d:	e9 97 fa ff ff       	jmp    80106219 <alltraps>

80106782 <vector17>:
80106782:	6a 11                	push   $0x11
80106784:	e9 90 fa ff ff       	jmp    80106219 <alltraps>

80106789 <vector18>:
80106789:	6a 00                	push   $0x0
8010678b:	6a 12                	push   $0x12
8010678d:	e9 87 fa ff ff       	jmp    80106219 <alltraps>

80106792 <vector19>:
80106792:	6a 00                	push   $0x0
80106794:	6a 13                	push   $0x13
80106796:	e9 7e fa ff ff       	jmp    80106219 <alltraps>

8010679b <vector20>:
8010679b:	6a 00                	push   $0x0
8010679d:	6a 14                	push   $0x14
8010679f:	e9 75 fa ff ff       	jmp    80106219 <alltraps>

801067a4 <vector21>:
801067a4:	6a 00                	push   $0x0
801067a6:	6a 15                	push   $0x15
801067a8:	e9 6c fa ff ff       	jmp    80106219 <alltraps>

801067ad <vector22>:
801067ad:	6a 00                	push   $0x0
801067af:	6a 16                	push   $0x16
801067b1:	e9 63 fa ff ff       	jmp    80106219 <alltraps>

801067b6 <vector23>:
801067b6:	6a 00                	push   $0x0
801067b8:	6a 17                	push   $0x17
801067ba:	e9 5a fa ff ff       	jmp    80106219 <alltraps>

801067bf <vector24>:
801067bf:	6a 00                	push   $0x0
801067c1:	6a 18                	push   $0x18
801067c3:	e9 51 fa ff ff       	jmp    80106219 <alltraps>

801067c8 <vector25>:
801067c8:	6a 00                	push   $0x0
801067ca:	6a 19                	push   $0x19
801067cc:	e9 48 fa ff ff       	jmp    80106219 <alltraps>

801067d1 <vector26>:
801067d1:	6a 00                	push   $0x0
801067d3:	6a 1a                	push   $0x1a
801067d5:	e9 3f fa ff ff       	jmp    80106219 <alltraps>

801067da <vector27>:
801067da:	6a 00                	push   $0x0
801067dc:	6a 1b                	push   $0x1b
801067de:	e9 36 fa ff ff       	jmp    80106219 <alltraps>

801067e3 <vector28>:
801067e3:	6a 00                	push   $0x0
801067e5:	6a 1c                	push   $0x1c
801067e7:	e9 2d fa ff ff       	jmp    80106219 <alltraps>

801067ec <vector29>:
801067ec:	6a 00                	push   $0x0
801067ee:	6a 1d                	push   $0x1d
801067f0:	e9 24 fa ff ff       	jmp    80106219 <alltraps>

801067f5 <vector30>:
801067f5:	6a 00                	push   $0x0
801067f7:	6a 1e                	push   $0x1e
801067f9:	e9 1b fa ff ff       	jmp    80106219 <alltraps>

801067fe <vector31>:
801067fe:	6a 00                	push   $0x0
80106800:	6a 1f                	push   $0x1f
80106802:	e9 12 fa ff ff       	jmp    80106219 <alltraps>

80106807 <vector32>:
80106807:	6a 00                	push   $0x0
80106809:	6a 20                	push   $0x20
8010680b:	e9 09 fa ff ff       	jmp    80106219 <alltraps>

80106810 <vector33>:
80106810:	6a 00                	push   $0x0
80106812:	6a 21                	push   $0x21
80106814:	e9 00 fa ff ff       	jmp    80106219 <alltraps>

80106819 <vector34>:
80106819:	6a 00                	push   $0x0
8010681b:	6a 22                	push   $0x22
8010681d:	e9 f7 f9 ff ff       	jmp    80106219 <alltraps>

80106822 <vector35>:
80106822:	6a 00                	push   $0x0
80106824:	6a 23                	push   $0x23
80106826:	e9 ee f9 ff ff       	jmp    80106219 <alltraps>

8010682b <vector36>:
8010682b:	6a 00                	push   $0x0
8010682d:	6a 24                	push   $0x24
8010682f:	e9 e5 f9 ff ff       	jmp    80106219 <alltraps>

80106834 <vector37>:
80106834:	6a 00                	push   $0x0
80106836:	6a 25                	push   $0x25
80106838:	e9 dc f9 ff ff       	jmp    80106219 <alltraps>

8010683d <vector38>:
8010683d:	6a 00                	push   $0x0
8010683f:	6a 26                	push   $0x26
80106841:	e9 d3 f9 ff ff       	jmp    80106219 <alltraps>

80106846 <vector39>:
80106846:	6a 00                	push   $0x0
80106848:	6a 27                	push   $0x27
8010684a:	e9 ca f9 ff ff       	jmp    80106219 <alltraps>

8010684f <vector40>:
8010684f:	6a 00                	push   $0x0
80106851:	6a 28                	push   $0x28
80106853:	e9 c1 f9 ff ff       	jmp    80106219 <alltraps>

80106858 <vector41>:
80106858:	6a 00                	push   $0x0
8010685a:	6a 29                	push   $0x29
8010685c:	e9 b8 f9 ff ff       	jmp    80106219 <alltraps>

80106861 <vector42>:
80106861:	6a 00                	push   $0x0
80106863:	6a 2a                	push   $0x2a
80106865:	e9 af f9 ff ff       	jmp    80106219 <alltraps>

8010686a <vector43>:
8010686a:	6a 00                	push   $0x0
8010686c:	6a 2b                	push   $0x2b
8010686e:	e9 a6 f9 ff ff       	jmp    80106219 <alltraps>

80106873 <vector44>:
80106873:	6a 00                	push   $0x0
80106875:	6a 2c                	push   $0x2c
80106877:	e9 9d f9 ff ff       	jmp    80106219 <alltraps>

8010687c <vector45>:
8010687c:	6a 00                	push   $0x0
8010687e:	6a 2d                	push   $0x2d
80106880:	e9 94 f9 ff ff       	jmp    80106219 <alltraps>

80106885 <vector46>:
80106885:	6a 00                	push   $0x0
80106887:	6a 2e                	push   $0x2e
80106889:	e9 8b f9 ff ff       	jmp    80106219 <alltraps>

8010688e <vector47>:
8010688e:	6a 00                	push   $0x0
80106890:	6a 2f                	push   $0x2f
80106892:	e9 82 f9 ff ff       	jmp    80106219 <alltraps>

80106897 <vector48>:
80106897:	6a 00                	push   $0x0
80106899:	6a 30                	push   $0x30
8010689b:	e9 79 f9 ff ff       	jmp    80106219 <alltraps>

801068a0 <vector49>:
801068a0:	6a 00                	push   $0x0
801068a2:	6a 31                	push   $0x31
801068a4:	e9 70 f9 ff ff       	jmp    80106219 <alltraps>

801068a9 <vector50>:
801068a9:	6a 00                	push   $0x0
801068ab:	6a 32                	push   $0x32
801068ad:	e9 67 f9 ff ff       	jmp    80106219 <alltraps>

801068b2 <vector51>:
801068b2:	6a 00                	push   $0x0
801068b4:	6a 33                	push   $0x33
801068b6:	e9 5e f9 ff ff       	jmp    80106219 <alltraps>

801068bb <vector52>:
801068bb:	6a 00                	push   $0x0
801068bd:	6a 34                	push   $0x34
801068bf:	e9 55 f9 ff ff       	jmp    80106219 <alltraps>

801068c4 <vector53>:
801068c4:	6a 00                	push   $0x0
801068c6:	6a 35                	push   $0x35
801068c8:	e9 4c f9 ff ff       	jmp    80106219 <alltraps>

801068cd <vector54>:
801068cd:	6a 00                	push   $0x0
801068cf:	6a 36                	push   $0x36
801068d1:	e9 43 f9 ff ff       	jmp    80106219 <alltraps>

801068d6 <vector55>:
801068d6:	6a 00                	push   $0x0
801068d8:	6a 37                	push   $0x37
801068da:	e9 3a f9 ff ff       	jmp    80106219 <alltraps>

801068df <vector56>:
801068df:	6a 00                	push   $0x0
801068e1:	6a 38                	push   $0x38
801068e3:	e9 31 f9 ff ff       	jmp    80106219 <alltraps>

801068e8 <vector57>:
801068e8:	6a 00                	push   $0x0
801068ea:	6a 39                	push   $0x39
801068ec:	e9 28 f9 ff ff       	jmp    80106219 <alltraps>

801068f1 <vector58>:
801068f1:	6a 00                	push   $0x0
801068f3:	6a 3a                	push   $0x3a
801068f5:	e9 1f f9 ff ff       	jmp    80106219 <alltraps>

801068fa <vector59>:
801068fa:	6a 00                	push   $0x0
801068fc:	6a 3b                	push   $0x3b
801068fe:	e9 16 f9 ff ff       	jmp    80106219 <alltraps>

80106903 <vector60>:
80106903:	6a 00                	push   $0x0
80106905:	6a 3c                	push   $0x3c
80106907:	e9 0d f9 ff ff       	jmp    80106219 <alltraps>

8010690c <vector61>:
8010690c:	6a 00                	push   $0x0
8010690e:	6a 3d                	push   $0x3d
80106910:	e9 04 f9 ff ff       	jmp    80106219 <alltraps>

80106915 <vector62>:
80106915:	6a 00                	push   $0x0
80106917:	6a 3e                	push   $0x3e
80106919:	e9 fb f8 ff ff       	jmp    80106219 <alltraps>

8010691e <vector63>:
8010691e:	6a 00                	push   $0x0
80106920:	6a 3f                	push   $0x3f
80106922:	e9 f2 f8 ff ff       	jmp    80106219 <alltraps>

80106927 <vector64>:
80106927:	6a 00                	push   $0x0
80106929:	6a 40                	push   $0x40
8010692b:	e9 e9 f8 ff ff       	jmp    80106219 <alltraps>

80106930 <vector65>:
80106930:	6a 00                	push   $0x0
80106932:	6a 41                	push   $0x41
80106934:	e9 e0 f8 ff ff       	jmp    80106219 <alltraps>

80106939 <vector66>:
80106939:	6a 00                	push   $0x0
8010693b:	6a 42                	push   $0x42
8010693d:	e9 d7 f8 ff ff       	jmp    80106219 <alltraps>

80106942 <vector67>:
80106942:	6a 00                	push   $0x0
80106944:	6a 43                	push   $0x43
80106946:	e9 ce f8 ff ff       	jmp    80106219 <alltraps>

8010694b <vector68>:
8010694b:	6a 00                	push   $0x0
8010694d:	6a 44                	push   $0x44
8010694f:	e9 c5 f8 ff ff       	jmp    80106219 <alltraps>

80106954 <vector69>:
80106954:	6a 00                	push   $0x0
80106956:	6a 45                	push   $0x45
80106958:	e9 bc f8 ff ff       	jmp    80106219 <alltraps>

8010695d <vector70>:
8010695d:	6a 00                	push   $0x0
8010695f:	6a 46                	push   $0x46
80106961:	e9 b3 f8 ff ff       	jmp    80106219 <alltraps>

80106966 <vector71>:
80106966:	6a 00                	push   $0x0
80106968:	6a 47                	push   $0x47
8010696a:	e9 aa f8 ff ff       	jmp    80106219 <alltraps>

8010696f <vector72>:
8010696f:	6a 00                	push   $0x0
80106971:	6a 48                	push   $0x48
80106973:	e9 a1 f8 ff ff       	jmp    80106219 <alltraps>

80106978 <vector73>:
80106978:	6a 00                	push   $0x0
8010697a:	6a 49                	push   $0x49
8010697c:	e9 98 f8 ff ff       	jmp    80106219 <alltraps>

80106981 <vector74>:
80106981:	6a 00                	push   $0x0
80106983:	6a 4a                	push   $0x4a
80106985:	e9 8f f8 ff ff       	jmp    80106219 <alltraps>

8010698a <vector75>:
8010698a:	6a 00                	push   $0x0
8010698c:	6a 4b                	push   $0x4b
8010698e:	e9 86 f8 ff ff       	jmp    80106219 <alltraps>

80106993 <vector76>:
80106993:	6a 00                	push   $0x0
80106995:	6a 4c                	push   $0x4c
80106997:	e9 7d f8 ff ff       	jmp    80106219 <alltraps>

8010699c <vector77>:
8010699c:	6a 00                	push   $0x0
8010699e:	6a 4d                	push   $0x4d
801069a0:	e9 74 f8 ff ff       	jmp    80106219 <alltraps>

801069a5 <vector78>:
801069a5:	6a 00                	push   $0x0
801069a7:	6a 4e                	push   $0x4e
801069a9:	e9 6b f8 ff ff       	jmp    80106219 <alltraps>

801069ae <vector79>:
801069ae:	6a 00                	push   $0x0
801069b0:	6a 4f                	push   $0x4f
801069b2:	e9 62 f8 ff ff       	jmp    80106219 <alltraps>

801069b7 <vector80>:
801069b7:	6a 00                	push   $0x0
801069b9:	6a 50                	push   $0x50
801069bb:	e9 59 f8 ff ff       	jmp    80106219 <alltraps>

801069c0 <vector81>:
801069c0:	6a 00                	push   $0x0
801069c2:	6a 51                	push   $0x51
801069c4:	e9 50 f8 ff ff       	jmp    80106219 <alltraps>

801069c9 <vector82>:
801069c9:	6a 00                	push   $0x0
801069cb:	6a 52                	push   $0x52
801069cd:	e9 47 f8 ff ff       	jmp    80106219 <alltraps>

801069d2 <vector83>:
801069d2:	6a 00                	push   $0x0
801069d4:	6a 53                	push   $0x53
801069d6:	e9 3e f8 ff ff       	jmp    80106219 <alltraps>

801069db <vector84>:
801069db:	6a 00                	push   $0x0
801069dd:	6a 54                	push   $0x54
801069df:	e9 35 f8 ff ff       	jmp    80106219 <alltraps>

801069e4 <vector85>:
801069e4:	6a 00                	push   $0x0
801069e6:	6a 55                	push   $0x55
801069e8:	e9 2c f8 ff ff       	jmp    80106219 <alltraps>

801069ed <vector86>:
801069ed:	6a 00                	push   $0x0
801069ef:	6a 56                	push   $0x56
801069f1:	e9 23 f8 ff ff       	jmp    80106219 <alltraps>

801069f6 <vector87>:
801069f6:	6a 00                	push   $0x0
801069f8:	6a 57                	push   $0x57
801069fa:	e9 1a f8 ff ff       	jmp    80106219 <alltraps>

801069ff <vector88>:
801069ff:	6a 00                	push   $0x0
80106a01:	6a 58                	push   $0x58
80106a03:	e9 11 f8 ff ff       	jmp    80106219 <alltraps>

80106a08 <vector89>:
80106a08:	6a 00                	push   $0x0
80106a0a:	6a 59                	push   $0x59
80106a0c:	e9 08 f8 ff ff       	jmp    80106219 <alltraps>

80106a11 <vector90>:
80106a11:	6a 00                	push   $0x0
80106a13:	6a 5a                	push   $0x5a
80106a15:	e9 ff f7 ff ff       	jmp    80106219 <alltraps>

80106a1a <vector91>:
80106a1a:	6a 00                	push   $0x0
80106a1c:	6a 5b                	push   $0x5b
80106a1e:	e9 f6 f7 ff ff       	jmp    80106219 <alltraps>

80106a23 <vector92>:
80106a23:	6a 00                	push   $0x0
80106a25:	6a 5c                	push   $0x5c
80106a27:	e9 ed f7 ff ff       	jmp    80106219 <alltraps>

80106a2c <vector93>:
80106a2c:	6a 00                	push   $0x0
80106a2e:	6a 5d                	push   $0x5d
80106a30:	e9 e4 f7 ff ff       	jmp    80106219 <alltraps>

80106a35 <vector94>:
80106a35:	6a 00                	push   $0x0
80106a37:	6a 5e                	push   $0x5e
80106a39:	e9 db f7 ff ff       	jmp    80106219 <alltraps>

80106a3e <vector95>:
80106a3e:	6a 00                	push   $0x0
80106a40:	6a 5f                	push   $0x5f
80106a42:	e9 d2 f7 ff ff       	jmp    80106219 <alltraps>

80106a47 <vector96>:
80106a47:	6a 00                	push   $0x0
80106a49:	6a 60                	push   $0x60
80106a4b:	e9 c9 f7 ff ff       	jmp    80106219 <alltraps>

80106a50 <vector97>:
80106a50:	6a 00                	push   $0x0
80106a52:	6a 61                	push   $0x61
80106a54:	e9 c0 f7 ff ff       	jmp    80106219 <alltraps>

80106a59 <vector98>:
80106a59:	6a 00                	push   $0x0
80106a5b:	6a 62                	push   $0x62
80106a5d:	e9 b7 f7 ff ff       	jmp    80106219 <alltraps>

80106a62 <vector99>:
80106a62:	6a 00                	push   $0x0
80106a64:	6a 63                	push   $0x63
80106a66:	e9 ae f7 ff ff       	jmp    80106219 <alltraps>

80106a6b <vector100>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	6a 64                	push   $0x64
80106a6f:	e9 a5 f7 ff ff       	jmp    80106219 <alltraps>

80106a74 <vector101>:
80106a74:	6a 00                	push   $0x0
80106a76:	6a 65                	push   $0x65
80106a78:	e9 9c f7 ff ff       	jmp    80106219 <alltraps>

80106a7d <vector102>:
80106a7d:	6a 00                	push   $0x0
80106a7f:	6a 66                	push   $0x66
80106a81:	e9 93 f7 ff ff       	jmp    80106219 <alltraps>

80106a86 <vector103>:
80106a86:	6a 00                	push   $0x0
80106a88:	6a 67                	push   $0x67
80106a8a:	e9 8a f7 ff ff       	jmp    80106219 <alltraps>

80106a8f <vector104>:
80106a8f:	6a 00                	push   $0x0
80106a91:	6a 68                	push   $0x68
80106a93:	e9 81 f7 ff ff       	jmp    80106219 <alltraps>

80106a98 <vector105>:
80106a98:	6a 00                	push   $0x0
80106a9a:	6a 69                	push   $0x69
80106a9c:	e9 78 f7 ff ff       	jmp    80106219 <alltraps>

80106aa1 <vector106>:
80106aa1:	6a 00                	push   $0x0
80106aa3:	6a 6a                	push   $0x6a
80106aa5:	e9 6f f7 ff ff       	jmp    80106219 <alltraps>

80106aaa <vector107>:
80106aaa:	6a 00                	push   $0x0
80106aac:	6a 6b                	push   $0x6b
80106aae:	e9 66 f7 ff ff       	jmp    80106219 <alltraps>

80106ab3 <vector108>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	6a 6c                	push   $0x6c
80106ab7:	e9 5d f7 ff ff       	jmp    80106219 <alltraps>

80106abc <vector109>:
80106abc:	6a 00                	push   $0x0
80106abe:	6a 6d                	push   $0x6d
80106ac0:	e9 54 f7 ff ff       	jmp    80106219 <alltraps>

80106ac5 <vector110>:
80106ac5:	6a 00                	push   $0x0
80106ac7:	6a 6e                	push   $0x6e
80106ac9:	e9 4b f7 ff ff       	jmp    80106219 <alltraps>

80106ace <vector111>:
80106ace:	6a 00                	push   $0x0
80106ad0:	6a 6f                	push   $0x6f
80106ad2:	e9 42 f7 ff ff       	jmp    80106219 <alltraps>

80106ad7 <vector112>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	6a 70                	push   $0x70
80106adb:	e9 39 f7 ff ff       	jmp    80106219 <alltraps>

80106ae0 <vector113>:
80106ae0:	6a 00                	push   $0x0
80106ae2:	6a 71                	push   $0x71
80106ae4:	e9 30 f7 ff ff       	jmp    80106219 <alltraps>

80106ae9 <vector114>:
80106ae9:	6a 00                	push   $0x0
80106aeb:	6a 72                	push   $0x72
80106aed:	e9 27 f7 ff ff       	jmp    80106219 <alltraps>

80106af2 <vector115>:
80106af2:	6a 00                	push   $0x0
80106af4:	6a 73                	push   $0x73
80106af6:	e9 1e f7 ff ff       	jmp    80106219 <alltraps>

80106afb <vector116>:
80106afb:	6a 00                	push   $0x0
80106afd:	6a 74                	push   $0x74
80106aff:	e9 15 f7 ff ff       	jmp    80106219 <alltraps>

80106b04 <vector117>:
80106b04:	6a 00                	push   $0x0
80106b06:	6a 75                	push   $0x75
80106b08:	e9 0c f7 ff ff       	jmp    80106219 <alltraps>

80106b0d <vector118>:
80106b0d:	6a 00                	push   $0x0
80106b0f:	6a 76                	push   $0x76
80106b11:	e9 03 f7 ff ff       	jmp    80106219 <alltraps>

80106b16 <vector119>:
80106b16:	6a 00                	push   $0x0
80106b18:	6a 77                	push   $0x77
80106b1a:	e9 fa f6 ff ff       	jmp    80106219 <alltraps>

80106b1f <vector120>:
80106b1f:	6a 00                	push   $0x0
80106b21:	6a 78                	push   $0x78
80106b23:	e9 f1 f6 ff ff       	jmp    80106219 <alltraps>

80106b28 <vector121>:
80106b28:	6a 00                	push   $0x0
80106b2a:	6a 79                	push   $0x79
80106b2c:	e9 e8 f6 ff ff       	jmp    80106219 <alltraps>

80106b31 <vector122>:
80106b31:	6a 00                	push   $0x0
80106b33:	6a 7a                	push   $0x7a
80106b35:	e9 df f6 ff ff       	jmp    80106219 <alltraps>

80106b3a <vector123>:
80106b3a:	6a 00                	push   $0x0
80106b3c:	6a 7b                	push   $0x7b
80106b3e:	e9 d6 f6 ff ff       	jmp    80106219 <alltraps>

80106b43 <vector124>:
80106b43:	6a 00                	push   $0x0
80106b45:	6a 7c                	push   $0x7c
80106b47:	e9 cd f6 ff ff       	jmp    80106219 <alltraps>

80106b4c <vector125>:
80106b4c:	6a 00                	push   $0x0
80106b4e:	6a 7d                	push   $0x7d
80106b50:	e9 c4 f6 ff ff       	jmp    80106219 <alltraps>

80106b55 <vector126>:
80106b55:	6a 00                	push   $0x0
80106b57:	6a 7e                	push   $0x7e
80106b59:	e9 bb f6 ff ff       	jmp    80106219 <alltraps>

80106b5e <vector127>:
80106b5e:	6a 00                	push   $0x0
80106b60:	6a 7f                	push   $0x7f
80106b62:	e9 b2 f6 ff ff       	jmp    80106219 <alltraps>

80106b67 <vector128>:
80106b67:	6a 00                	push   $0x0
80106b69:	68 80 00 00 00       	push   $0x80
80106b6e:	e9 a6 f6 ff ff       	jmp    80106219 <alltraps>

80106b73 <vector129>:
80106b73:	6a 00                	push   $0x0
80106b75:	68 81 00 00 00       	push   $0x81
80106b7a:	e9 9a f6 ff ff       	jmp    80106219 <alltraps>

80106b7f <vector130>:
80106b7f:	6a 00                	push   $0x0
80106b81:	68 82 00 00 00       	push   $0x82
80106b86:	e9 8e f6 ff ff       	jmp    80106219 <alltraps>

80106b8b <vector131>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	68 83 00 00 00       	push   $0x83
80106b92:	e9 82 f6 ff ff       	jmp    80106219 <alltraps>

80106b97 <vector132>:
80106b97:	6a 00                	push   $0x0
80106b99:	68 84 00 00 00       	push   $0x84
80106b9e:	e9 76 f6 ff ff       	jmp    80106219 <alltraps>

80106ba3 <vector133>:
80106ba3:	6a 00                	push   $0x0
80106ba5:	68 85 00 00 00       	push   $0x85
80106baa:	e9 6a f6 ff ff       	jmp    80106219 <alltraps>

80106baf <vector134>:
80106baf:	6a 00                	push   $0x0
80106bb1:	68 86 00 00 00       	push   $0x86
80106bb6:	e9 5e f6 ff ff       	jmp    80106219 <alltraps>

80106bbb <vector135>:
80106bbb:	6a 00                	push   $0x0
80106bbd:	68 87 00 00 00       	push   $0x87
80106bc2:	e9 52 f6 ff ff       	jmp    80106219 <alltraps>

80106bc7 <vector136>:
80106bc7:	6a 00                	push   $0x0
80106bc9:	68 88 00 00 00       	push   $0x88
80106bce:	e9 46 f6 ff ff       	jmp    80106219 <alltraps>

80106bd3 <vector137>:
80106bd3:	6a 00                	push   $0x0
80106bd5:	68 89 00 00 00       	push   $0x89
80106bda:	e9 3a f6 ff ff       	jmp    80106219 <alltraps>

80106bdf <vector138>:
80106bdf:	6a 00                	push   $0x0
80106be1:	68 8a 00 00 00       	push   $0x8a
80106be6:	e9 2e f6 ff ff       	jmp    80106219 <alltraps>

80106beb <vector139>:
80106beb:	6a 00                	push   $0x0
80106bed:	68 8b 00 00 00       	push   $0x8b
80106bf2:	e9 22 f6 ff ff       	jmp    80106219 <alltraps>

80106bf7 <vector140>:
80106bf7:	6a 00                	push   $0x0
80106bf9:	68 8c 00 00 00       	push   $0x8c
80106bfe:	e9 16 f6 ff ff       	jmp    80106219 <alltraps>

80106c03 <vector141>:
80106c03:	6a 00                	push   $0x0
80106c05:	68 8d 00 00 00       	push   $0x8d
80106c0a:	e9 0a f6 ff ff       	jmp    80106219 <alltraps>

80106c0f <vector142>:
80106c0f:	6a 00                	push   $0x0
80106c11:	68 8e 00 00 00       	push   $0x8e
80106c16:	e9 fe f5 ff ff       	jmp    80106219 <alltraps>

80106c1b <vector143>:
80106c1b:	6a 00                	push   $0x0
80106c1d:	68 8f 00 00 00       	push   $0x8f
80106c22:	e9 f2 f5 ff ff       	jmp    80106219 <alltraps>

80106c27 <vector144>:
80106c27:	6a 00                	push   $0x0
80106c29:	68 90 00 00 00       	push   $0x90
80106c2e:	e9 e6 f5 ff ff       	jmp    80106219 <alltraps>

80106c33 <vector145>:
80106c33:	6a 00                	push   $0x0
80106c35:	68 91 00 00 00       	push   $0x91
80106c3a:	e9 da f5 ff ff       	jmp    80106219 <alltraps>

80106c3f <vector146>:
80106c3f:	6a 00                	push   $0x0
80106c41:	68 92 00 00 00       	push   $0x92
80106c46:	e9 ce f5 ff ff       	jmp    80106219 <alltraps>

80106c4b <vector147>:
80106c4b:	6a 00                	push   $0x0
80106c4d:	68 93 00 00 00       	push   $0x93
80106c52:	e9 c2 f5 ff ff       	jmp    80106219 <alltraps>

80106c57 <vector148>:
80106c57:	6a 00                	push   $0x0
80106c59:	68 94 00 00 00       	push   $0x94
80106c5e:	e9 b6 f5 ff ff       	jmp    80106219 <alltraps>

80106c63 <vector149>:
80106c63:	6a 00                	push   $0x0
80106c65:	68 95 00 00 00       	push   $0x95
80106c6a:	e9 aa f5 ff ff       	jmp    80106219 <alltraps>

80106c6f <vector150>:
80106c6f:	6a 00                	push   $0x0
80106c71:	68 96 00 00 00       	push   $0x96
80106c76:	e9 9e f5 ff ff       	jmp    80106219 <alltraps>

80106c7b <vector151>:
80106c7b:	6a 00                	push   $0x0
80106c7d:	68 97 00 00 00       	push   $0x97
80106c82:	e9 92 f5 ff ff       	jmp    80106219 <alltraps>

80106c87 <vector152>:
80106c87:	6a 00                	push   $0x0
80106c89:	68 98 00 00 00       	push   $0x98
80106c8e:	e9 86 f5 ff ff       	jmp    80106219 <alltraps>

80106c93 <vector153>:
80106c93:	6a 00                	push   $0x0
80106c95:	68 99 00 00 00       	push   $0x99
80106c9a:	e9 7a f5 ff ff       	jmp    80106219 <alltraps>

80106c9f <vector154>:
80106c9f:	6a 00                	push   $0x0
80106ca1:	68 9a 00 00 00       	push   $0x9a
80106ca6:	e9 6e f5 ff ff       	jmp    80106219 <alltraps>

80106cab <vector155>:
80106cab:	6a 00                	push   $0x0
80106cad:	68 9b 00 00 00       	push   $0x9b
80106cb2:	e9 62 f5 ff ff       	jmp    80106219 <alltraps>

80106cb7 <vector156>:
80106cb7:	6a 00                	push   $0x0
80106cb9:	68 9c 00 00 00       	push   $0x9c
80106cbe:	e9 56 f5 ff ff       	jmp    80106219 <alltraps>

80106cc3 <vector157>:
80106cc3:	6a 00                	push   $0x0
80106cc5:	68 9d 00 00 00       	push   $0x9d
80106cca:	e9 4a f5 ff ff       	jmp    80106219 <alltraps>

80106ccf <vector158>:
80106ccf:	6a 00                	push   $0x0
80106cd1:	68 9e 00 00 00       	push   $0x9e
80106cd6:	e9 3e f5 ff ff       	jmp    80106219 <alltraps>

80106cdb <vector159>:
80106cdb:	6a 00                	push   $0x0
80106cdd:	68 9f 00 00 00       	push   $0x9f
80106ce2:	e9 32 f5 ff ff       	jmp    80106219 <alltraps>

80106ce7 <vector160>:
80106ce7:	6a 00                	push   $0x0
80106ce9:	68 a0 00 00 00       	push   $0xa0
80106cee:	e9 26 f5 ff ff       	jmp    80106219 <alltraps>

80106cf3 <vector161>:
80106cf3:	6a 00                	push   $0x0
80106cf5:	68 a1 00 00 00       	push   $0xa1
80106cfa:	e9 1a f5 ff ff       	jmp    80106219 <alltraps>

80106cff <vector162>:
80106cff:	6a 00                	push   $0x0
80106d01:	68 a2 00 00 00       	push   $0xa2
80106d06:	e9 0e f5 ff ff       	jmp    80106219 <alltraps>

80106d0b <vector163>:
80106d0b:	6a 00                	push   $0x0
80106d0d:	68 a3 00 00 00       	push   $0xa3
80106d12:	e9 02 f5 ff ff       	jmp    80106219 <alltraps>

80106d17 <vector164>:
80106d17:	6a 00                	push   $0x0
80106d19:	68 a4 00 00 00       	push   $0xa4
80106d1e:	e9 f6 f4 ff ff       	jmp    80106219 <alltraps>

80106d23 <vector165>:
80106d23:	6a 00                	push   $0x0
80106d25:	68 a5 00 00 00       	push   $0xa5
80106d2a:	e9 ea f4 ff ff       	jmp    80106219 <alltraps>

80106d2f <vector166>:
80106d2f:	6a 00                	push   $0x0
80106d31:	68 a6 00 00 00       	push   $0xa6
80106d36:	e9 de f4 ff ff       	jmp    80106219 <alltraps>

80106d3b <vector167>:
80106d3b:	6a 00                	push   $0x0
80106d3d:	68 a7 00 00 00       	push   $0xa7
80106d42:	e9 d2 f4 ff ff       	jmp    80106219 <alltraps>

80106d47 <vector168>:
80106d47:	6a 00                	push   $0x0
80106d49:	68 a8 00 00 00       	push   $0xa8
80106d4e:	e9 c6 f4 ff ff       	jmp    80106219 <alltraps>

80106d53 <vector169>:
80106d53:	6a 00                	push   $0x0
80106d55:	68 a9 00 00 00       	push   $0xa9
80106d5a:	e9 ba f4 ff ff       	jmp    80106219 <alltraps>

80106d5f <vector170>:
80106d5f:	6a 00                	push   $0x0
80106d61:	68 aa 00 00 00       	push   $0xaa
80106d66:	e9 ae f4 ff ff       	jmp    80106219 <alltraps>

80106d6b <vector171>:
80106d6b:	6a 00                	push   $0x0
80106d6d:	68 ab 00 00 00       	push   $0xab
80106d72:	e9 a2 f4 ff ff       	jmp    80106219 <alltraps>

80106d77 <vector172>:
80106d77:	6a 00                	push   $0x0
80106d79:	68 ac 00 00 00       	push   $0xac
80106d7e:	e9 96 f4 ff ff       	jmp    80106219 <alltraps>

80106d83 <vector173>:
80106d83:	6a 00                	push   $0x0
80106d85:	68 ad 00 00 00       	push   $0xad
80106d8a:	e9 8a f4 ff ff       	jmp    80106219 <alltraps>

80106d8f <vector174>:
80106d8f:	6a 00                	push   $0x0
80106d91:	68 ae 00 00 00       	push   $0xae
80106d96:	e9 7e f4 ff ff       	jmp    80106219 <alltraps>

80106d9b <vector175>:
80106d9b:	6a 00                	push   $0x0
80106d9d:	68 af 00 00 00       	push   $0xaf
80106da2:	e9 72 f4 ff ff       	jmp    80106219 <alltraps>

80106da7 <vector176>:
80106da7:	6a 00                	push   $0x0
80106da9:	68 b0 00 00 00       	push   $0xb0
80106dae:	e9 66 f4 ff ff       	jmp    80106219 <alltraps>

80106db3 <vector177>:
80106db3:	6a 00                	push   $0x0
80106db5:	68 b1 00 00 00       	push   $0xb1
80106dba:	e9 5a f4 ff ff       	jmp    80106219 <alltraps>

80106dbf <vector178>:
80106dbf:	6a 00                	push   $0x0
80106dc1:	68 b2 00 00 00       	push   $0xb2
80106dc6:	e9 4e f4 ff ff       	jmp    80106219 <alltraps>

80106dcb <vector179>:
80106dcb:	6a 00                	push   $0x0
80106dcd:	68 b3 00 00 00       	push   $0xb3
80106dd2:	e9 42 f4 ff ff       	jmp    80106219 <alltraps>

80106dd7 <vector180>:
80106dd7:	6a 00                	push   $0x0
80106dd9:	68 b4 00 00 00       	push   $0xb4
80106dde:	e9 36 f4 ff ff       	jmp    80106219 <alltraps>

80106de3 <vector181>:
80106de3:	6a 00                	push   $0x0
80106de5:	68 b5 00 00 00       	push   $0xb5
80106dea:	e9 2a f4 ff ff       	jmp    80106219 <alltraps>

80106def <vector182>:
80106def:	6a 00                	push   $0x0
80106df1:	68 b6 00 00 00       	push   $0xb6
80106df6:	e9 1e f4 ff ff       	jmp    80106219 <alltraps>

80106dfb <vector183>:
80106dfb:	6a 00                	push   $0x0
80106dfd:	68 b7 00 00 00       	push   $0xb7
80106e02:	e9 12 f4 ff ff       	jmp    80106219 <alltraps>

80106e07 <vector184>:
80106e07:	6a 00                	push   $0x0
80106e09:	68 b8 00 00 00       	push   $0xb8
80106e0e:	e9 06 f4 ff ff       	jmp    80106219 <alltraps>

80106e13 <vector185>:
80106e13:	6a 00                	push   $0x0
80106e15:	68 b9 00 00 00       	push   $0xb9
80106e1a:	e9 fa f3 ff ff       	jmp    80106219 <alltraps>

80106e1f <vector186>:
80106e1f:	6a 00                	push   $0x0
80106e21:	68 ba 00 00 00       	push   $0xba
80106e26:	e9 ee f3 ff ff       	jmp    80106219 <alltraps>

80106e2b <vector187>:
80106e2b:	6a 00                	push   $0x0
80106e2d:	68 bb 00 00 00       	push   $0xbb
80106e32:	e9 e2 f3 ff ff       	jmp    80106219 <alltraps>

80106e37 <vector188>:
80106e37:	6a 00                	push   $0x0
80106e39:	68 bc 00 00 00       	push   $0xbc
80106e3e:	e9 d6 f3 ff ff       	jmp    80106219 <alltraps>

80106e43 <vector189>:
80106e43:	6a 00                	push   $0x0
80106e45:	68 bd 00 00 00       	push   $0xbd
80106e4a:	e9 ca f3 ff ff       	jmp    80106219 <alltraps>

80106e4f <vector190>:
80106e4f:	6a 00                	push   $0x0
80106e51:	68 be 00 00 00       	push   $0xbe
80106e56:	e9 be f3 ff ff       	jmp    80106219 <alltraps>

80106e5b <vector191>:
80106e5b:	6a 00                	push   $0x0
80106e5d:	68 bf 00 00 00       	push   $0xbf
80106e62:	e9 b2 f3 ff ff       	jmp    80106219 <alltraps>

80106e67 <vector192>:
80106e67:	6a 00                	push   $0x0
80106e69:	68 c0 00 00 00       	push   $0xc0
80106e6e:	e9 a6 f3 ff ff       	jmp    80106219 <alltraps>

80106e73 <vector193>:
80106e73:	6a 00                	push   $0x0
80106e75:	68 c1 00 00 00       	push   $0xc1
80106e7a:	e9 9a f3 ff ff       	jmp    80106219 <alltraps>

80106e7f <vector194>:
80106e7f:	6a 00                	push   $0x0
80106e81:	68 c2 00 00 00       	push   $0xc2
80106e86:	e9 8e f3 ff ff       	jmp    80106219 <alltraps>

80106e8b <vector195>:
80106e8b:	6a 00                	push   $0x0
80106e8d:	68 c3 00 00 00       	push   $0xc3
80106e92:	e9 82 f3 ff ff       	jmp    80106219 <alltraps>

80106e97 <vector196>:
80106e97:	6a 00                	push   $0x0
80106e99:	68 c4 00 00 00       	push   $0xc4
80106e9e:	e9 76 f3 ff ff       	jmp    80106219 <alltraps>

80106ea3 <vector197>:
80106ea3:	6a 00                	push   $0x0
80106ea5:	68 c5 00 00 00       	push   $0xc5
80106eaa:	e9 6a f3 ff ff       	jmp    80106219 <alltraps>

80106eaf <vector198>:
80106eaf:	6a 00                	push   $0x0
80106eb1:	68 c6 00 00 00       	push   $0xc6
80106eb6:	e9 5e f3 ff ff       	jmp    80106219 <alltraps>

80106ebb <vector199>:
80106ebb:	6a 00                	push   $0x0
80106ebd:	68 c7 00 00 00       	push   $0xc7
80106ec2:	e9 52 f3 ff ff       	jmp    80106219 <alltraps>

80106ec7 <vector200>:
80106ec7:	6a 00                	push   $0x0
80106ec9:	68 c8 00 00 00       	push   $0xc8
80106ece:	e9 46 f3 ff ff       	jmp    80106219 <alltraps>

80106ed3 <vector201>:
80106ed3:	6a 00                	push   $0x0
80106ed5:	68 c9 00 00 00       	push   $0xc9
80106eda:	e9 3a f3 ff ff       	jmp    80106219 <alltraps>

80106edf <vector202>:
80106edf:	6a 00                	push   $0x0
80106ee1:	68 ca 00 00 00       	push   $0xca
80106ee6:	e9 2e f3 ff ff       	jmp    80106219 <alltraps>

80106eeb <vector203>:
80106eeb:	6a 00                	push   $0x0
80106eed:	68 cb 00 00 00       	push   $0xcb
80106ef2:	e9 22 f3 ff ff       	jmp    80106219 <alltraps>

80106ef7 <vector204>:
80106ef7:	6a 00                	push   $0x0
80106ef9:	68 cc 00 00 00       	push   $0xcc
80106efe:	e9 16 f3 ff ff       	jmp    80106219 <alltraps>

80106f03 <vector205>:
80106f03:	6a 00                	push   $0x0
80106f05:	68 cd 00 00 00       	push   $0xcd
80106f0a:	e9 0a f3 ff ff       	jmp    80106219 <alltraps>

80106f0f <vector206>:
80106f0f:	6a 00                	push   $0x0
80106f11:	68 ce 00 00 00       	push   $0xce
80106f16:	e9 fe f2 ff ff       	jmp    80106219 <alltraps>

80106f1b <vector207>:
80106f1b:	6a 00                	push   $0x0
80106f1d:	68 cf 00 00 00       	push   $0xcf
80106f22:	e9 f2 f2 ff ff       	jmp    80106219 <alltraps>

80106f27 <vector208>:
80106f27:	6a 00                	push   $0x0
80106f29:	68 d0 00 00 00       	push   $0xd0
80106f2e:	e9 e6 f2 ff ff       	jmp    80106219 <alltraps>

80106f33 <vector209>:
80106f33:	6a 00                	push   $0x0
80106f35:	68 d1 00 00 00       	push   $0xd1
80106f3a:	e9 da f2 ff ff       	jmp    80106219 <alltraps>

80106f3f <vector210>:
80106f3f:	6a 00                	push   $0x0
80106f41:	68 d2 00 00 00       	push   $0xd2
80106f46:	e9 ce f2 ff ff       	jmp    80106219 <alltraps>

80106f4b <vector211>:
80106f4b:	6a 00                	push   $0x0
80106f4d:	68 d3 00 00 00       	push   $0xd3
80106f52:	e9 c2 f2 ff ff       	jmp    80106219 <alltraps>

80106f57 <vector212>:
80106f57:	6a 00                	push   $0x0
80106f59:	68 d4 00 00 00       	push   $0xd4
80106f5e:	e9 b6 f2 ff ff       	jmp    80106219 <alltraps>

80106f63 <vector213>:
80106f63:	6a 00                	push   $0x0
80106f65:	68 d5 00 00 00       	push   $0xd5
80106f6a:	e9 aa f2 ff ff       	jmp    80106219 <alltraps>

80106f6f <vector214>:
80106f6f:	6a 00                	push   $0x0
80106f71:	68 d6 00 00 00       	push   $0xd6
80106f76:	e9 9e f2 ff ff       	jmp    80106219 <alltraps>

80106f7b <vector215>:
80106f7b:	6a 00                	push   $0x0
80106f7d:	68 d7 00 00 00       	push   $0xd7
80106f82:	e9 92 f2 ff ff       	jmp    80106219 <alltraps>

80106f87 <vector216>:
80106f87:	6a 00                	push   $0x0
80106f89:	68 d8 00 00 00       	push   $0xd8
80106f8e:	e9 86 f2 ff ff       	jmp    80106219 <alltraps>

80106f93 <vector217>:
80106f93:	6a 00                	push   $0x0
80106f95:	68 d9 00 00 00       	push   $0xd9
80106f9a:	e9 7a f2 ff ff       	jmp    80106219 <alltraps>

80106f9f <vector218>:
80106f9f:	6a 00                	push   $0x0
80106fa1:	68 da 00 00 00       	push   $0xda
80106fa6:	e9 6e f2 ff ff       	jmp    80106219 <alltraps>

80106fab <vector219>:
80106fab:	6a 00                	push   $0x0
80106fad:	68 db 00 00 00       	push   $0xdb
80106fb2:	e9 62 f2 ff ff       	jmp    80106219 <alltraps>

80106fb7 <vector220>:
80106fb7:	6a 00                	push   $0x0
80106fb9:	68 dc 00 00 00       	push   $0xdc
80106fbe:	e9 56 f2 ff ff       	jmp    80106219 <alltraps>

80106fc3 <vector221>:
80106fc3:	6a 00                	push   $0x0
80106fc5:	68 dd 00 00 00       	push   $0xdd
80106fca:	e9 4a f2 ff ff       	jmp    80106219 <alltraps>

80106fcf <vector222>:
80106fcf:	6a 00                	push   $0x0
80106fd1:	68 de 00 00 00       	push   $0xde
80106fd6:	e9 3e f2 ff ff       	jmp    80106219 <alltraps>

80106fdb <vector223>:
80106fdb:	6a 00                	push   $0x0
80106fdd:	68 df 00 00 00       	push   $0xdf
80106fe2:	e9 32 f2 ff ff       	jmp    80106219 <alltraps>

80106fe7 <vector224>:
80106fe7:	6a 00                	push   $0x0
80106fe9:	68 e0 00 00 00       	push   $0xe0
80106fee:	e9 26 f2 ff ff       	jmp    80106219 <alltraps>

80106ff3 <vector225>:
80106ff3:	6a 00                	push   $0x0
80106ff5:	68 e1 00 00 00       	push   $0xe1
80106ffa:	e9 1a f2 ff ff       	jmp    80106219 <alltraps>

80106fff <vector226>:
80106fff:	6a 00                	push   $0x0
80107001:	68 e2 00 00 00       	push   $0xe2
80107006:	e9 0e f2 ff ff       	jmp    80106219 <alltraps>

8010700b <vector227>:
8010700b:	6a 00                	push   $0x0
8010700d:	68 e3 00 00 00       	push   $0xe3
80107012:	e9 02 f2 ff ff       	jmp    80106219 <alltraps>

80107017 <vector228>:
80107017:	6a 00                	push   $0x0
80107019:	68 e4 00 00 00       	push   $0xe4
8010701e:	e9 f6 f1 ff ff       	jmp    80106219 <alltraps>

80107023 <vector229>:
80107023:	6a 00                	push   $0x0
80107025:	68 e5 00 00 00       	push   $0xe5
8010702a:	e9 ea f1 ff ff       	jmp    80106219 <alltraps>

8010702f <vector230>:
8010702f:	6a 00                	push   $0x0
80107031:	68 e6 00 00 00       	push   $0xe6
80107036:	e9 de f1 ff ff       	jmp    80106219 <alltraps>

8010703b <vector231>:
8010703b:	6a 00                	push   $0x0
8010703d:	68 e7 00 00 00       	push   $0xe7
80107042:	e9 d2 f1 ff ff       	jmp    80106219 <alltraps>

80107047 <vector232>:
80107047:	6a 00                	push   $0x0
80107049:	68 e8 00 00 00       	push   $0xe8
8010704e:	e9 c6 f1 ff ff       	jmp    80106219 <alltraps>

80107053 <vector233>:
80107053:	6a 00                	push   $0x0
80107055:	68 e9 00 00 00       	push   $0xe9
8010705a:	e9 ba f1 ff ff       	jmp    80106219 <alltraps>

8010705f <vector234>:
8010705f:	6a 00                	push   $0x0
80107061:	68 ea 00 00 00       	push   $0xea
80107066:	e9 ae f1 ff ff       	jmp    80106219 <alltraps>

8010706b <vector235>:
8010706b:	6a 00                	push   $0x0
8010706d:	68 eb 00 00 00       	push   $0xeb
80107072:	e9 a2 f1 ff ff       	jmp    80106219 <alltraps>

80107077 <vector236>:
80107077:	6a 00                	push   $0x0
80107079:	68 ec 00 00 00       	push   $0xec
8010707e:	e9 96 f1 ff ff       	jmp    80106219 <alltraps>

80107083 <vector237>:
80107083:	6a 00                	push   $0x0
80107085:	68 ed 00 00 00       	push   $0xed
8010708a:	e9 8a f1 ff ff       	jmp    80106219 <alltraps>

8010708f <vector238>:
8010708f:	6a 00                	push   $0x0
80107091:	68 ee 00 00 00       	push   $0xee
80107096:	e9 7e f1 ff ff       	jmp    80106219 <alltraps>

8010709b <vector239>:
8010709b:	6a 00                	push   $0x0
8010709d:	68 ef 00 00 00       	push   $0xef
801070a2:	e9 72 f1 ff ff       	jmp    80106219 <alltraps>

801070a7 <vector240>:
801070a7:	6a 00                	push   $0x0
801070a9:	68 f0 00 00 00       	push   $0xf0
801070ae:	e9 66 f1 ff ff       	jmp    80106219 <alltraps>

801070b3 <vector241>:
801070b3:	6a 00                	push   $0x0
801070b5:	68 f1 00 00 00       	push   $0xf1
801070ba:	e9 5a f1 ff ff       	jmp    80106219 <alltraps>

801070bf <vector242>:
801070bf:	6a 00                	push   $0x0
801070c1:	68 f2 00 00 00       	push   $0xf2
801070c6:	e9 4e f1 ff ff       	jmp    80106219 <alltraps>

801070cb <vector243>:
801070cb:	6a 00                	push   $0x0
801070cd:	68 f3 00 00 00       	push   $0xf3
801070d2:	e9 42 f1 ff ff       	jmp    80106219 <alltraps>

801070d7 <vector244>:
801070d7:	6a 00                	push   $0x0
801070d9:	68 f4 00 00 00       	push   $0xf4
801070de:	e9 36 f1 ff ff       	jmp    80106219 <alltraps>

801070e3 <vector245>:
801070e3:	6a 00                	push   $0x0
801070e5:	68 f5 00 00 00       	push   $0xf5
801070ea:	e9 2a f1 ff ff       	jmp    80106219 <alltraps>

801070ef <vector246>:
801070ef:	6a 00                	push   $0x0
801070f1:	68 f6 00 00 00       	push   $0xf6
801070f6:	e9 1e f1 ff ff       	jmp    80106219 <alltraps>

801070fb <vector247>:
801070fb:	6a 00                	push   $0x0
801070fd:	68 f7 00 00 00       	push   $0xf7
80107102:	e9 12 f1 ff ff       	jmp    80106219 <alltraps>

80107107 <vector248>:
80107107:	6a 00                	push   $0x0
80107109:	68 f8 00 00 00       	push   $0xf8
8010710e:	e9 06 f1 ff ff       	jmp    80106219 <alltraps>

80107113 <vector249>:
80107113:	6a 00                	push   $0x0
80107115:	68 f9 00 00 00       	push   $0xf9
8010711a:	e9 fa f0 ff ff       	jmp    80106219 <alltraps>

8010711f <vector250>:
8010711f:	6a 00                	push   $0x0
80107121:	68 fa 00 00 00       	push   $0xfa
80107126:	e9 ee f0 ff ff       	jmp    80106219 <alltraps>

8010712b <vector251>:
8010712b:	6a 00                	push   $0x0
8010712d:	68 fb 00 00 00       	push   $0xfb
80107132:	e9 e2 f0 ff ff       	jmp    80106219 <alltraps>

80107137 <vector252>:
80107137:	6a 00                	push   $0x0
80107139:	68 fc 00 00 00       	push   $0xfc
8010713e:	e9 d6 f0 ff ff       	jmp    80106219 <alltraps>

80107143 <vector253>:
80107143:	6a 00                	push   $0x0
80107145:	68 fd 00 00 00       	push   $0xfd
8010714a:	e9 ca f0 ff ff       	jmp    80106219 <alltraps>

8010714f <vector254>:
8010714f:	6a 00                	push   $0x0
80107151:	68 fe 00 00 00       	push   $0xfe
80107156:	e9 be f0 ff ff       	jmp    80106219 <alltraps>

8010715b <vector255>:
8010715b:	6a 00                	push   $0x0
8010715d:	68 ff 00 00 00       	push   $0xff
80107162:	e9 b2 f0 ff ff       	jmp    80106219 <alltraps>
80107167:	66 90                	xchg   %ax,%ax
80107169:	66 90                	xchg   %ax,%ax
8010716b:	66 90                	xchg   %ax,%ax
8010716d:	66 90                	xchg   %ax,%ax
8010716f:	90                   	nop

80107170 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107176:	89 d3                	mov    %edx,%ebx
{
80107178:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010717a:	c1 eb 16             	shr    $0x16,%ebx
8010717d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107180:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107183:	8b 06                	mov    (%esi),%eax
80107185:	a8 01                	test   $0x1,%al
80107187:	74 27                	je     801071b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107189:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010718e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107194:	c1 ef 0a             	shr    $0xa,%edi
}
80107197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010719a:	89 fa                	mov    %edi,%edx
8010719c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801071a5:	5b                   	pop    %ebx
801071a6:	5e                   	pop    %esi
801071a7:	5f                   	pop    %edi
801071a8:	5d                   	pop    %ebp
801071a9:	c3                   	ret    
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071b0:	85 c9                	test   %ecx,%ecx
801071b2:	74 2c                	je     801071e0 <walkpgdir+0x70>
801071b4:	e8 37 b3 ff ff       	call   801024f0 <kalloc>
801071b9:	85 c0                	test   %eax,%eax
801071bb:	89 c3                	mov    %eax,%ebx
801071bd:	74 21                	je     801071e0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801071bf:	83 ec 04             	sub    $0x4,%esp
801071c2:	68 00 10 00 00       	push   $0x1000
801071c7:	6a 00                	push   $0x0
801071c9:	50                   	push   %eax
801071ca:	e8 d1 dd ff ff       	call   80104fa0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071cf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071d5:	83 c4 10             	add    $0x10,%esp
801071d8:	83 c8 07             	or     $0x7,%eax
801071db:	89 06                	mov    %eax,(%esi)
801071dd:	eb b5                	jmp    80107194 <walkpgdir+0x24>
801071df:	90                   	nop
}
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801071f6:	89 d3                	mov    %edx,%ebx
801071f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801071fe:	83 ec 1c             	sub    $0x1c,%esp
80107201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107204:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107208:	8b 7d 08             	mov    0x8(%ebp),%edi
8010720b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107210:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107213:	8b 45 0c             	mov    0xc(%ebp),%eax
80107216:	29 df                	sub    %ebx,%edi
80107218:	83 c8 01             	or     $0x1,%eax
8010721b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010721e:	eb 15                	jmp    80107235 <mappages+0x45>
    if(*pte & PTE_P)
80107220:	f6 00 01             	testb  $0x1,(%eax)
80107223:	75 45                	jne    8010726a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107225:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107228:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010722b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010722d:	74 31                	je     80107260 <mappages+0x70>
      break;
    a += PGSIZE;
8010722f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107238:	b9 01 00 00 00       	mov    $0x1,%ecx
8010723d:	89 da                	mov    %ebx,%edx
8010723f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107242:	e8 29 ff ff ff       	call   80107170 <walkpgdir>
80107247:	85 c0                	test   %eax,%eax
80107249:	75 d5                	jne    80107220 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010724b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010724e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107253:	5b                   	pop    %ebx
80107254:	5e                   	pop    %esi
80107255:	5f                   	pop    %edi
80107256:	5d                   	pop    %ebp
80107257:	c3                   	ret    
80107258:	90                   	nop
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107263:	31 c0                	xor    %eax,%eax
}
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
      panic("remap");
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	68 38 85 10 80       	push   $0x80108538
80107272:	e8 19 91 ff ff       	call   80100390 <panic>
80107277:	89 f6                	mov    %esi,%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107280 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107286:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010728c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010728e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107294:	83 ec 1c             	sub    $0x1c,%esp
80107297:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010729a:	39 d3                	cmp    %edx,%ebx
8010729c:	73 66                	jae    80107304 <deallocuvm.part.0+0x84>
8010729e:	89 d6                	mov    %edx,%esi
801072a0:	eb 3d                	jmp    801072df <deallocuvm.part.0+0x5f>
801072a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801072a8:	8b 10                	mov    (%eax),%edx
801072aa:	f6 c2 01             	test   $0x1,%dl
801072ad:	74 26                	je     801072d5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801072af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801072b5:	74 58                	je     8010730f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801072b7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801072ba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801072c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801072c3:	52                   	push   %edx
801072c4:	e8 77 b0 ff ff       	call   80102340 <kfree>
      *pte = 0;
801072c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072cc:	83 c4 10             	add    $0x10,%esp
801072cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801072d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072db:	39 f3                	cmp    %esi,%ebx
801072dd:	73 25                	jae    80107304 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801072df:	31 c9                	xor    %ecx,%ecx
801072e1:	89 da                	mov    %ebx,%edx
801072e3:	89 f8                	mov    %edi,%eax
801072e5:	e8 86 fe ff ff       	call   80107170 <walkpgdir>
    if(!pte)
801072ea:	85 c0                	test   %eax,%eax
801072ec:	75 ba                	jne    801072a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072ee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801072f4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801072fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107300:	39 f3                	cmp    %esi,%ebx
80107302:	72 db                	jb     801072df <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107304:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730a:	5b                   	pop    %ebx
8010730b:	5e                   	pop    %esi
8010730c:	5f                   	pop    %edi
8010730d:	5d                   	pop    %ebp
8010730e:	c3                   	ret    
        panic("kfree");
8010730f:	83 ec 0c             	sub    $0xc,%esp
80107312:	68 06 7d 10 80       	push   $0x80107d06
80107317:	e8 74 90 ff ff       	call   80100390 <panic>
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107320 <seginit>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107326:	e8 35 c6 ff ff       	call   80103960 <cpuid>
8010732b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107331:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107336:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010733a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107341:	ff 00 00 
80107344:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010734b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010734e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107355:	ff 00 00 
80107358:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010735f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107362:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107369:	ff 00 00 
8010736c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107373:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107376:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
8010737d:	ff 00 00 
80107380:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107387:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010738a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
8010738f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107393:	c1 e8 10             	shr    $0x10,%eax
80107396:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010739a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010739d:	0f 01 10             	lgdtl  (%eax)
}
801073a0:	c9                   	leave  
801073a1:	c3                   	ret    
801073a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073b0:	a1 c4 64 11 80       	mov    0x801164c4,%eax
{
801073b5:	55                   	push   %ebp
801073b6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073b8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073bd:	0f 22 d8             	mov    %eax,%cr3
}
801073c0:	5d                   	pop    %ebp
801073c1:	c3                   	ret    
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073d0 <switchuvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 1c             	sub    $0x1c,%esp
801073d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801073dc:	85 db                	test   %ebx,%ebx
801073de:	0f 84 cb 00 00 00    	je     801074af <switchuvm+0xdf>
  if(p->kstack == 0)
801073e4:	8b 43 08             	mov    0x8(%ebx),%eax
801073e7:	85 c0                	test   %eax,%eax
801073e9:	0f 84 da 00 00 00    	je     801074c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801073ef:	8b 43 04             	mov    0x4(%ebx),%eax
801073f2:	85 c0                	test   %eax,%eax
801073f4:	0f 84 c2 00 00 00    	je     801074bc <switchuvm+0xec>
  pushcli();
801073fa:	e8 c1 d9 ff ff       	call   80104dc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073ff:	e8 0c c5 ff ff       	call   80103910 <mycpu>
80107404:	89 c6                	mov    %eax,%esi
80107406:	e8 05 c5 ff ff       	call   80103910 <mycpu>
8010740b:	89 c7                	mov    %eax,%edi
8010740d:	e8 fe c4 ff ff       	call   80103910 <mycpu>
80107412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107415:	83 c7 08             	add    $0x8,%edi
80107418:	e8 f3 c4 ff ff       	call   80103910 <mycpu>
8010741d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107420:	83 c0 08             	add    $0x8,%eax
80107423:	ba 67 00 00 00       	mov    $0x67,%edx
80107428:	c1 e8 18             	shr    $0x18,%eax
8010742b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107432:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107439:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010743f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107444:	83 c1 08             	add    $0x8,%ecx
80107447:	c1 e9 10             	shr    $0x10,%ecx
8010744a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107450:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107455:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010745c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107461:	e8 aa c4 ff ff       	call   80103910 <mycpu>
80107466:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010746d:	e8 9e c4 ff ff       	call   80103910 <mycpu>
80107472:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107476:	8b 73 08             	mov    0x8(%ebx),%esi
80107479:	e8 92 c4 ff ff       	call   80103910 <mycpu>
8010747e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107484:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107487:	e8 84 c4 ff ff       	call   80103910 <mycpu>
8010748c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107490:	b8 28 00 00 00       	mov    $0x28,%eax
80107495:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107498:	8b 43 04             	mov    0x4(%ebx),%eax
8010749b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074a0:	0f 22 d8             	mov    %eax,%cr3
}
801074a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074a6:	5b                   	pop    %ebx
801074a7:	5e                   	pop    %esi
801074a8:	5f                   	pop    %edi
801074a9:	5d                   	pop    %ebp
  popcli();
801074aa:	e9 51 d9 ff ff       	jmp    80104e00 <popcli>
    panic("switchuvm: no process");
801074af:	83 ec 0c             	sub    $0xc,%esp
801074b2:	68 3e 85 10 80       	push   $0x8010853e
801074b7:	e8 d4 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	68 69 85 10 80       	push   $0x80108569
801074c4:	e8 c7 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801074c9:	83 ec 0c             	sub    $0xc,%esp
801074cc:	68 54 85 10 80       	push   $0x80108554
801074d1:	e8 ba 8e ff ff       	call   80100390 <panic>
801074d6:	8d 76 00             	lea    0x0(%esi),%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <inituvm>:
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
801074e6:	83 ec 1c             	sub    $0x1c,%esp
801074e9:	8b 75 10             	mov    0x10(%ebp),%esi
801074ec:	8b 45 08             	mov    0x8(%ebp),%eax
801074ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801074f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801074f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074fb:	77 49                	ja     80107546 <inituvm+0x66>
  mem = kalloc();
801074fd:	e8 ee af ff ff       	call   801024f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107502:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107505:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107507:	68 00 10 00 00       	push   $0x1000
8010750c:	6a 00                	push   $0x0
8010750e:	50                   	push   %eax
8010750f:	e8 8c da ff ff       	call   80104fa0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107514:	58                   	pop    %eax
80107515:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010751b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107520:	5a                   	pop    %edx
80107521:	6a 06                	push   $0x6
80107523:	50                   	push   %eax
80107524:	31 d2                	xor    %edx,%edx
80107526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107529:	e8 c2 fc ff ff       	call   801071f0 <mappages>
  memmove(mem, init, sz);
8010752e:	89 75 10             	mov    %esi,0x10(%ebp)
80107531:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107534:	83 c4 10             	add    $0x10,%esp
80107537:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010753a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010753d:	5b                   	pop    %ebx
8010753e:	5e                   	pop    %esi
8010753f:	5f                   	pop    %edi
80107540:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107541:	e9 0a db ff ff       	jmp    80105050 <memmove>
    panic("inituvm: more than a page");
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	68 7d 85 10 80       	push   $0x8010857d
8010754e:	e8 3d 8e ff ff       	call   80100390 <panic>
80107553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107560 <loaduvm>:
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
80107566:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107569:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107570:	0f 85 91 00 00 00    	jne    80107607 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107576:	8b 75 18             	mov    0x18(%ebp),%esi
80107579:	31 db                	xor    %ebx,%ebx
8010757b:	85 f6                	test   %esi,%esi
8010757d:	75 1a                	jne    80107599 <loaduvm+0x39>
8010757f:	eb 6f                	jmp    801075f0 <loaduvm+0x90>
80107581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107588:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010758e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107594:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107597:	76 57                	jbe    801075f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107599:	8b 55 0c             	mov    0xc(%ebp),%edx
8010759c:	8b 45 08             	mov    0x8(%ebp),%eax
8010759f:	31 c9                	xor    %ecx,%ecx
801075a1:	01 da                	add    %ebx,%edx
801075a3:	e8 c8 fb ff ff       	call   80107170 <walkpgdir>
801075a8:	85 c0                	test   %eax,%eax
801075aa:	74 4e                	je     801075fa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801075ac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801075b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075c4:	01 d9                	add    %ebx,%ecx
801075c6:	05 00 00 00 80       	add    $0x80000000,%eax
801075cb:	57                   	push   %edi
801075cc:	51                   	push   %ecx
801075cd:	50                   	push   %eax
801075ce:	ff 75 10             	pushl  0x10(%ebp)
801075d1:	e8 ba a3 ff ff       	call   80101990 <readi>
801075d6:	83 c4 10             	add    $0x10,%esp
801075d9:	39 f8                	cmp    %edi,%eax
801075db:	74 ab                	je     80107588 <loaduvm+0x28>
}
801075dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075e5:	5b                   	pop    %ebx
801075e6:	5e                   	pop    %esi
801075e7:	5f                   	pop    %edi
801075e8:	5d                   	pop    %ebp
801075e9:	c3                   	ret    
801075ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075f3:	31 c0                	xor    %eax,%eax
}
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801075fa:	83 ec 0c             	sub    $0xc,%esp
801075fd:	68 97 85 10 80       	push   $0x80108597
80107602:	e8 89 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107607:	83 ec 0c             	sub    $0xc,%esp
8010760a:	68 38 86 10 80       	push   $0x80108638
8010760f:	e8 7c 8d ff ff       	call   80100390 <panic>
80107614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010761a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107620 <allocuvm>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107629:	8b 7d 10             	mov    0x10(%ebp),%edi
8010762c:	85 ff                	test   %edi,%edi
8010762e:	0f 88 8e 00 00 00    	js     801076c2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107634:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107637:	0f 82 93 00 00 00    	jb     801076d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010763d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107640:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107646:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010764c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010764f:	0f 86 7e 00 00 00    	jbe    801076d3 <allocuvm+0xb3>
80107655:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107658:	8b 7d 08             	mov    0x8(%ebp),%edi
8010765b:	eb 42                	jmp    8010769f <allocuvm+0x7f>
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107660:	83 ec 04             	sub    $0x4,%esp
80107663:	68 00 10 00 00       	push   $0x1000
80107668:	6a 00                	push   $0x0
8010766a:	50                   	push   %eax
8010766b:	e8 30 d9 ff ff       	call   80104fa0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107670:	58                   	pop    %eax
80107671:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107677:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010767c:	5a                   	pop    %edx
8010767d:	6a 06                	push   $0x6
8010767f:	50                   	push   %eax
80107680:	89 da                	mov    %ebx,%edx
80107682:	89 f8                	mov    %edi,%eax
80107684:	e8 67 fb ff ff       	call   801071f0 <mappages>
80107689:	83 c4 10             	add    $0x10,%esp
8010768c:	85 c0                	test   %eax,%eax
8010768e:	78 50                	js     801076e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107690:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107696:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107699:	0f 86 81 00 00 00    	jbe    80107720 <allocuvm+0x100>
    mem = kalloc();
8010769f:	e8 4c ae ff ff       	call   801024f0 <kalloc>
    if(mem == 0){
801076a4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801076a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801076a8:	75 b6                	jne    80107660 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801076aa:	83 ec 0c             	sub    $0xc,%esp
801076ad:	68 b5 85 10 80       	push   $0x801085b5
801076b2:	e8 a9 8f ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801076b7:	83 c4 10             	add    $0x10,%esp
801076ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801076bd:	39 45 10             	cmp    %eax,0x10(%ebp)
801076c0:	77 6e                	ja     80107730 <allocuvm+0x110>
}
801076c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801076c5:	31 ff                	xor    %edi,%edi
}
801076c7:	89 f8                	mov    %edi,%eax
801076c9:	5b                   	pop    %ebx
801076ca:	5e                   	pop    %esi
801076cb:	5f                   	pop    %edi
801076cc:	5d                   	pop    %ebp
801076cd:	c3                   	ret    
801076ce:	66 90                	xchg   %ax,%ax
    return oldsz;
801076d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801076d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d6:	89 f8                	mov    %edi,%eax
801076d8:	5b                   	pop    %ebx
801076d9:	5e                   	pop    %esi
801076da:	5f                   	pop    %edi
801076db:	5d                   	pop    %ebp
801076dc:	c3                   	ret    
801076dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076e0:	83 ec 0c             	sub    $0xc,%esp
801076e3:	68 cd 85 10 80       	push   $0x801085cd
801076e8:	e8 73 8f ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801076ed:	83 c4 10             	add    $0x10,%esp
801076f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801076f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801076f6:	76 0d                	jbe    80107705 <allocuvm+0xe5>
801076f8:	89 c1                	mov    %eax,%ecx
801076fa:	8b 55 10             	mov    0x10(%ebp),%edx
801076fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107700:	e8 7b fb ff ff       	call   80107280 <deallocuvm.part.0>
      kfree(mem);
80107705:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107708:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010770a:	56                   	push   %esi
8010770b:	e8 30 ac ff ff       	call   80102340 <kfree>
      return 0;
80107710:	83 c4 10             	add    $0x10,%esp
}
80107713:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107716:	89 f8                	mov    %edi,%eax
80107718:	5b                   	pop    %ebx
80107719:	5e                   	pop    %esi
8010771a:	5f                   	pop    %edi
8010771b:	5d                   	pop    %ebp
8010771c:	c3                   	ret    
8010771d:	8d 76 00             	lea    0x0(%esi),%esi
80107720:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107726:	5b                   	pop    %ebx
80107727:	89 f8                	mov    %edi,%eax
80107729:	5e                   	pop    %esi
8010772a:	5f                   	pop    %edi
8010772b:	5d                   	pop    %ebp
8010772c:	c3                   	ret    
8010772d:	8d 76 00             	lea    0x0(%esi),%esi
80107730:	89 c1                	mov    %eax,%ecx
80107732:	8b 55 10             	mov    0x10(%ebp),%edx
80107735:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107738:	31 ff                	xor    %edi,%edi
8010773a:	e8 41 fb ff ff       	call   80107280 <deallocuvm.part.0>
8010773f:	eb 92                	jmp    801076d3 <allocuvm+0xb3>
80107741:	eb 0d                	jmp    80107750 <deallocuvm>
80107743:	90                   	nop
80107744:	90                   	nop
80107745:	90                   	nop
80107746:	90                   	nop
80107747:	90                   	nop
80107748:	90                   	nop
80107749:	90                   	nop
8010774a:	90                   	nop
8010774b:	90                   	nop
8010774c:	90                   	nop
8010774d:	90                   	nop
8010774e:	90                   	nop
8010774f:	90                   	nop

80107750 <deallocuvm>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	8b 55 0c             	mov    0xc(%ebp),%edx
80107756:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107759:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010775c:	39 d1                	cmp    %edx,%ecx
8010775e:	73 10                	jae    80107770 <deallocuvm+0x20>
}
80107760:	5d                   	pop    %ebp
80107761:	e9 1a fb ff ff       	jmp    80107280 <deallocuvm.part.0>
80107766:	8d 76 00             	lea    0x0(%esi),%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107770:	89 d0                	mov    %edx,%eax
80107772:	5d                   	pop    %ebp
80107773:	c3                   	ret    
80107774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010777a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107780 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
80107786:	83 ec 0c             	sub    $0xc,%esp
80107789:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010778c:	85 f6                	test   %esi,%esi
8010778e:	74 59                	je     801077e9 <freevm+0x69>
80107790:	31 c9                	xor    %ecx,%ecx
80107792:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107797:	89 f0                	mov    %esi,%eax
80107799:	e8 e2 fa ff ff       	call   80107280 <deallocuvm.part.0>
8010779e:	89 f3                	mov    %esi,%ebx
801077a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077a6:	eb 0f                	jmp    801077b7 <freevm+0x37>
801077a8:	90                   	nop
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077b3:	39 fb                	cmp    %edi,%ebx
801077b5:	74 23                	je     801077da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077b7:	8b 03                	mov    (%ebx),%eax
801077b9:	a8 01                	test   $0x1,%al
801077bb:	74 f3                	je     801077b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801077c2:	83 ec 0c             	sub    $0xc,%esp
801077c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801077cd:	50                   	push   %eax
801077ce:	e8 6d ab ff ff       	call   80102340 <kfree>
801077d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077d6:	39 fb                	cmp    %edi,%ebx
801077d8:	75 dd                	jne    801077b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801077da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e0:	5b                   	pop    %ebx
801077e1:	5e                   	pop    %esi
801077e2:	5f                   	pop    %edi
801077e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077e4:	e9 57 ab ff ff       	jmp    80102340 <kfree>
    panic("freevm: no pgdir");
801077e9:	83 ec 0c             	sub    $0xc,%esp
801077ec:	68 e9 85 10 80       	push   $0x801085e9
801077f1:	e8 9a 8b ff ff       	call   80100390 <panic>
801077f6:	8d 76 00             	lea    0x0(%esi),%esi
801077f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107800 <setupkvm>:
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	56                   	push   %esi
80107804:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107805:	e8 e6 ac ff ff       	call   801024f0 <kalloc>
8010780a:	85 c0                	test   %eax,%eax
8010780c:	89 c6                	mov    %eax,%esi
8010780e:	74 42                	je     80107852 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107810:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107813:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107818:	68 00 10 00 00       	push   $0x1000
8010781d:	6a 00                	push   $0x0
8010781f:	50                   	push   %eax
80107820:	e8 7b d7 ff ff       	call   80104fa0 <memset>
80107825:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107828:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010782b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010782e:	83 ec 08             	sub    $0x8,%esp
80107831:	8b 13                	mov    (%ebx),%edx
80107833:	ff 73 0c             	pushl  0xc(%ebx)
80107836:	50                   	push   %eax
80107837:	29 c1                	sub    %eax,%ecx
80107839:	89 f0                	mov    %esi,%eax
8010783b:	e8 b0 f9 ff ff       	call   801071f0 <mappages>
80107840:	83 c4 10             	add    $0x10,%esp
80107843:	85 c0                	test   %eax,%eax
80107845:	78 19                	js     80107860 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107847:	83 c3 10             	add    $0x10,%ebx
8010784a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107850:	75 d6                	jne    80107828 <setupkvm+0x28>
}
80107852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107855:	89 f0                	mov    %esi,%eax
80107857:	5b                   	pop    %ebx
80107858:	5e                   	pop    %esi
80107859:	5d                   	pop    %ebp
8010785a:	c3                   	ret    
8010785b:	90                   	nop
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	56                   	push   %esi
      return 0;
80107864:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107866:	e8 15 ff ff ff       	call   80107780 <freevm>
      return 0;
8010786b:	83 c4 10             	add    $0x10,%esp
}
8010786e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107871:	89 f0                	mov    %esi,%eax
80107873:	5b                   	pop    %ebx
80107874:	5e                   	pop    %esi
80107875:	5d                   	pop    %ebp
80107876:	c3                   	ret    
80107877:	89 f6                	mov    %esi,%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107880 <kvmalloc>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107886:	e8 75 ff ff ff       	call   80107800 <setupkvm>
8010788b:	a3 c4 64 11 80       	mov    %eax,0x801164c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107890:	05 00 00 00 80       	add    $0x80000000,%eax
80107895:	0f 22 d8             	mov    %eax,%cr3
}
80107898:	c9                   	leave  
80107899:	c3                   	ret    
8010789a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078a1:	31 c9                	xor    %ecx,%ecx
{
801078a3:	89 e5                	mov    %esp,%ebp
801078a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ab:	8b 45 08             	mov    0x8(%ebp),%eax
801078ae:	e8 bd f8 ff ff       	call   80107170 <walkpgdir>
  if(pte == 0)
801078b3:	85 c0                	test   %eax,%eax
801078b5:	74 05                	je     801078bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078ba:	c9                   	leave  
801078bb:	c3                   	ret    
    panic("clearpteu");
801078bc:	83 ec 0c             	sub    $0xc,%esp
801078bf:	68 fa 85 10 80       	push   $0x801085fa
801078c4:	e8 c7 8a ff ff       	call   80100390 <panic>
801078c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	53                   	push   %ebx
801078d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078d9:	e8 22 ff ff ff       	call   80107800 <setupkvm>
801078de:	85 c0                	test   %eax,%eax
801078e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078e3:	0f 84 9f 00 00 00    	je     80107988 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078ec:	85 c9                	test   %ecx,%ecx
801078ee:	0f 84 94 00 00 00    	je     80107988 <copyuvm+0xb8>
801078f4:	31 ff                	xor    %edi,%edi
801078f6:	eb 4a                	jmp    80107942 <copyuvm+0x72>
801078f8:	90                   	nop
801078f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107900:	83 ec 04             	sub    $0x4,%esp
80107903:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107909:	68 00 10 00 00       	push   $0x1000
8010790e:	53                   	push   %ebx
8010790f:	50                   	push   %eax
80107910:	e8 3b d7 ff ff       	call   80105050 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107915:	58                   	pop    %eax
80107916:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010791c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107921:	5a                   	pop    %edx
80107922:	ff 75 e4             	pushl  -0x1c(%ebp)
80107925:	50                   	push   %eax
80107926:	89 fa                	mov    %edi,%edx
80107928:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010792b:	e8 c0 f8 ff ff       	call   801071f0 <mappages>
80107930:	83 c4 10             	add    $0x10,%esp
80107933:	85 c0                	test   %eax,%eax
80107935:	78 61                	js     80107998 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107937:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010793d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107940:	76 46                	jbe    80107988 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107942:	8b 45 08             	mov    0x8(%ebp),%eax
80107945:	31 c9                	xor    %ecx,%ecx
80107947:	89 fa                	mov    %edi,%edx
80107949:	e8 22 f8 ff ff       	call   80107170 <walkpgdir>
8010794e:	85 c0                	test   %eax,%eax
80107950:	74 61                	je     801079b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107952:	8b 00                	mov    (%eax),%eax
80107954:	a8 01                	test   $0x1,%al
80107956:	74 4e                	je     801079a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107958:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010795a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010795f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107968:	e8 83 ab ff ff       	call   801024f0 <kalloc>
8010796d:	85 c0                	test   %eax,%eax
8010796f:	89 c6                	mov    %eax,%esi
80107971:	75 8d                	jne    80107900 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107973:	83 ec 0c             	sub    $0xc,%esp
80107976:	ff 75 e0             	pushl  -0x20(%ebp)
80107979:	e8 02 fe ff ff       	call   80107780 <freevm>
  return 0;
8010797e:	83 c4 10             	add    $0x10,%esp
80107981:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107988:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798e:	5b                   	pop    %ebx
8010798f:	5e                   	pop    %esi
80107990:	5f                   	pop    %edi
80107991:	5d                   	pop    %ebp
80107992:	c3                   	ret    
80107993:	90                   	nop
80107994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107998:	83 ec 0c             	sub    $0xc,%esp
8010799b:	56                   	push   %esi
8010799c:	e8 9f a9 ff ff       	call   80102340 <kfree>
      goto bad;
801079a1:	83 c4 10             	add    $0x10,%esp
801079a4:	eb cd                	jmp    80107973 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	68 1e 86 10 80       	push   $0x8010861e
801079ae:	e8 dd 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801079b3:	83 ec 0c             	sub    $0xc,%esp
801079b6:	68 04 86 10 80       	push   $0x80108604
801079bb:	e8 d0 89 ff ff       	call   80100390 <panic>

801079c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079c1:	31 c9                	xor    %ecx,%ecx
{
801079c3:	89 e5                	mov    %esp,%ebp
801079c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079cb:	8b 45 08             	mov    0x8(%ebp),%eax
801079ce:	e8 9d f7 ff ff       	call   80107170 <walkpgdir>
  if((*pte & PTE_P) == 0)
801079d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801079d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079e0:	05 00 00 00 80       	add    $0x80000000,%eax
801079e5:	83 fa 05             	cmp    $0x5,%edx
801079e8:	ba 00 00 00 00       	mov    $0x0,%edx
801079ed:	0f 45 c2             	cmovne %edx,%eax
}
801079f0:	c3                   	ret    
801079f1:	eb 0d                	jmp    80107a00 <copyout>
801079f3:	90                   	nop
801079f4:	90                   	nop
801079f5:	90                   	nop
801079f6:	90                   	nop
801079f7:	90                   	nop
801079f8:	90                   	nop
801079f9:	90                   	nop
801079fa:	90                   	nop
801079fb:	90                   	nop
801079fc:	90                   	nop
801079fd:	90                   	nop
801079fe:	90                   	nop
801079ff:	90                   	nop

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 1c             	sub    $0x1c,%esp
80107a09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 db                	test   %ebx,%ebx
80107a14:	75 40                	jne    80107a56 <copyout+0x56>
80107a16:	eb 70                	jmp    80107a88 <copyout+0x88>
80107a18:	90                   	nop
80107a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a23:	89 f1                	mov    %esi,%ecx
80107a25:	29 d1                	sub    %edx,%ecx
80107a27:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107a2d:	39 d9                	cmp    %ebx,%ecx
80107a2f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a32:	29 f2                	sub    %esi,%edx
80107a34:	83 ec 04             	sub    $0x4,%esp
80107a37:	01 d0                	add    %edx,%eax
80107a39:	51                   	push   %ecx
80107a3a:	57                   	push   %edi
80107a3b:	50                   	push   %eax
80107a3c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a3f:	e8 0c d6 ff ff       	call   80105050 <memmove>
    len -= n;
    buf += n;
80107a44:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107a47:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107a4a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107a50:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107a52:	29 cb                	sub    %ecx,%ebx
80107a54:	74 32                	je     80107a88 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a56:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a58:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a5e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a64:	56                   	push   %esi
80107a65:	ff 75 08             	pushl  0x8(%ebp)
80107a68:	e8 53 ff ff ff       	call   801079c0 <uva2ka>
    if(pa0 == 0)
80107a6d:	83 c4 10             	add    $0x10,%esp
80107a70:	85 c0                	test   %eax,%eax
80107a72:	75 ac                	jne    80107a20 <copyout+0x20>
  }
  return 0;
}
80107a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a7c:	5b                   	pop    %ebx
80107a7d:	5e                   	pop    %esi
80107a7e:	5f                   	pop    %edi
80107a7f:	5d                   	pop    %ebp
80107a80:	c3                   	ret    
80107a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a8b:	31 c0                	xor    %eax,%eax
}
80107a8d:	5b                   	pop    %ebx
80107a8e:	5e                   	pop    %esi
80107a8f:	5f                   	pop    %edi
80107a90:	5d                   	pop    %ebp
80107a91:	c3                   	ret    

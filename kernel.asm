
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7a 10 80       	push   $0x80107a80
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 95 4c 00 00       	call   80104cf0 <initlock>
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
80100092:	68 87 7a 10 80       	push   $0x80107a87
80100097:	50                   	push   %eax
80100098:	e8 23 4b 00 00       	call   80104bc0 <initsleeplock>
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
801000e4:	e8 47 4d 00 00       	call   80104e30 <acquire>
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
80100162:	e8 89 4d 00 00       	call   80104ef0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 4a 00 00       	call   80104c00 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 1f 00 00       	call   80102140 <iderw>
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
80100193:	68 8e 7a 10 80       	push   $0x80107a8e
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
801001ae:	e8 ed 4a 00 00       	call   80104ca0 <holdingsleep>
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
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 7a 10 80       	push   $0x80107a9f
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
801001ef:	e8 ac 4a 00 00       	call   80104ca0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 4a 00 00       	call   80104c60 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 20 4c 00 00       	call   80104e30 <acquire>
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
8010025c:	e9 8f 4c 00 00       	jmp    80104ef0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 7a 10 80       	push   $0x80107aa6
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
80100280:	e8 fb 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 9f 4b 00 00       	call   80104e30 <acquire>
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
801002c5:	e8 d6 3e 00 00       	call   801041a0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 90 36 00 00       	call   80103970 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 fc 4b 00 00       	call   80104ef0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 a4 13 00 00       	call   801016a0 <ilock>
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
8010034d:	e8 9e 4b 00 00       	call   80104ef0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 46 13 00 00       	call   801016a0 <ilock>
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
801003a9:	e8 a2 23 00 00       	call   80102750 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 7a 10 80       	push   $0x80107aad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 0f 86 10 80 	movl   $0x8010860f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 49 00 00       	call   80104d10 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 7a 10 80       	push   $0x80107ac1
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
8010043a:	e8 41 62 00 00       	call   80106680 <uartputc>
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
801004ec:	e8 8f 61 00 00       	call   80106680 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 61 00 00       	call   80106680 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 61 00 00       	call   80106680 <uartputc>
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
80100524:	e8 c7 4a 00 00       	call   80104ff0 <memmove>
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
80100541:	e8 fa 49 00 00       	call   80104f40 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 7a 10 80       	push   $0x80107ac5
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
801005b1:	0f b6 92 f0 7a 10 80 	movzbl -0x7fef8510(%edx),%edx
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
8010060f:	e8 6c 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 10 48 00 00       	call   80104e30 <acquire>
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
80100647:	e8 a4 48 00 00       	call   80104ef0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 4b 10 00 00       	call   801016a0 <ilock>

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
8010071f:	e8 cc 47 00 00       	call   80104ef0 <release>
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
801007d0:	ba d8 7a 10 80       	mov    $0x80107ad8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 3b 46 00 00       	call   80104e30 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 7a 10 80       	push   $0x80107adf
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
80100823:	e8 08 46 00 00       	call   80104e30 <acquire>
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
80100888:	e8 63 46 00 00       	call   80104ef0 <release>
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
80100916:	e8 45 3a 00 00       	call   80104360 <wakeup>
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
80100997:	e9 a4 3a 00 00       	jmp    80104440 <procdump>
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
801009c6:	68 e8 7a 10 80       	push   $0x80107ae8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 1b 43 00 00       	call   80104cf0 <initlock>

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
801009f9:	e8 f2 18 00 00       	call   801022f0 <ioapicenable>
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
80100a1c:	e8 4f 2f 00 00       	call   80103970 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 94 21 00 00       	call   80102bc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 c9 14 00 00       	call   80101f00 <namei>
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
80100a48:	e8 53 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 22 0f 00 00       	call   80101980 <readi>
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
80100a6a:	e8 c1 0e 00 00       	call   80101930 <iunlockput>
    end_op();
80100a6f:	e8 bc 21 00 00       	call   80102c30 <end_op>
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
80100a94:	e8 37 6d 00 00       	call   801077d0 <setupkvm>
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
80100ab9:	0f 84 b1 02 00 00    	je     80100d70 <exec+0x360>
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
80100af6:	e8 f5 6a 00 00       	call   801075f0 <allocuvm>
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
80100b28:	e8 03 6a 00 00       	call   80107530 <loaduvm>
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
80100b58:	e8 23 0e 00 00       	call   80101980 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 d9 6b 00 00       	call   80107750 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 96 0d 00 00       	call   80101930 <iunlockput>
  end_op();
80100b9a:	e8 91 20 00 00       	call   80102c30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 41 6a 00 00       	call   801075f0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 8a 6b 00 00       	call   80107750 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 58 20 00 00       	call   80102c30 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 7b 10 80       	push   $0x80107b01
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
80100c06:	e8 65 6c 00 00       	call   80107870 <clearpteu>
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
80100c39:	e8 22 45 00 00       	call   80105160 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 45 00 00       	call   80105160 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 6e 6d 00 00       	call   801079d0 <copyout>
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
80100cc7:	e8 04 6d 00 00       	call   801079d0 <copyout>
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
80100d0a:	e8 11 44 00 00       	call   80105120 <safestrcpy>
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
  curproc->queueNum = 0;
80100d31:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
80100d38:	00 00 00 
  curproc->cycleNum = 1;
80100d3b:	c7 81 84 00 00 00 01 	movl   $0x1,0x84(%ecx)
80100d42:	00 00 00 
  curproc->ticket = 100000;
80100d45:	c7 41 7c a0 86 01 00 	movl   $0x186a0,0x7c(%ecx)
  curproc->remainingPriority = 10;
80100d4c:	c7 81 8c 00 00 00 00 	movl   $0x41200000,0x8c(%ecx)
80100d53:	00 20 41 
  switchuvm(curproc);
80100d56:	89 0c 24             	mov    %ecx,(%esp)
80100d59:	e8 42 66 00 00       	call   801073a0 <switchuvm>
  freevm(oldpgdir);
80100d5e:	89 3c 24             	mov    %edi,(%esp)
80100d61:	e8 ea 69 00 00       	call   80107750 <freevm>
  return 0;
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	31 c0                	xor    %eax,%eax
80100d6b:	e9 0c fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d70:	be 00 20 00 00       	mov    $0x2000,%esi
80100d75:	e9 17 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d7a:	66 90                	xchg   %ax,%ax
80100d7c:	66 90                	xchg   %ax,%ax
80100d7e:	66 90                	xchg   %ax,%ax

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 0d 7b 10 80       	push   $0x80107b0d
80100d8b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d90:	e8 5b 3f 00 00       	call   80104cf0 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave  
80100d99:	c3                   	ret    
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 c0 0f 11 80       	push   $0x80110fc0
80100db1:	e8 7a 40 00 00       	call   80104e30 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100dc9:	73 25                	jae    80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ddc:	68 c0 0f 11 80       	push   $0x80110fc0
80100de1:	e8 0a 41 00 00       	call   80104ef0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de6:	89 d8                	mov    %ebx,%eax
      return f;
80100de8:	83 c4 10             	add    $0x10,%esp
}
80100deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dee:	c9                   	leave  
80100def:	c3                   	ret    
  release(&ftable.lock);
80100df0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100df3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100df5:	68 c0 0f 11 80       	push   $0x80110fc0
80100dfa:	e8 f1 40 00 00       	call   80104ef0 <release>
}
80100dff:	89 d8                	mov    %ebx,%eax
  return 0;
80100e01:	83 c4 10             	add    $0x10,%esp
}
80100e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e07:	c9                   	leave  
80100e08:	c3                   	ret    
80100e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 10             	sub    $0x10,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e1f:	e8 0c 40 00 00       	call   80104e30 <acquire>
  if(f->ref < 1)
80100e24:	8b 43 04             	mov    0x4(%ebx),%eax
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	7e 1a                	jle    80100e48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e37:	68 c0 0f 11 80       	push   $0x80110fc0
80100e3c:	e8 af 40 00 00       	call   80104ef0 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 14 7b 10 80       	push   $0x80107b14
80100e50:	e8 3b f5 ff ff       	call   80100390 <panic>
80100e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 28             	sub    $0x28,%esp
80100e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e71:	e8 ba 3f 00 00       	call   80104e30 <acquire>
  if(f->ref < 1)
80100e76:	8b 43 04             	mov    0x4(%ebx),%eax
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 8e 9b 00 00 00    	jle    80100f1f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e84:	83 e8 01             	sub    $0x1,%eax
80100e87:	85 c0                	test   %eax,%eax
80100e89:	89 43 04             	mov    %eax,0x4(%ebx)
80100e8c:	74 1a                	je     80100ea8 <fileclose+0x48>
    release(&ftable.lock);
80100e8e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9c:	e9 4f 40 00 00       	jmp    80104ef0 <release>
80100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ea8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100eb1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100eb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ebd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ec0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 23 40 00 00       	call   80104ef0 <release>
  if(ff.type == FD_PIPE)
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 ff 01             	cmp    $0x1,%edi
80100ed3:	74 13                	je     80100ee8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ed5:	83 ff 02             	cmp    $0x2,%edi
80100ed8:	74 26                	je     80100f00 <fileclose+0xa0>
}
80100eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100edd:	5b                   	pop    %ebx
80100ede:	5e                   	pop    %esi
80100edf:	5f                   	pop    %edi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eec:	83 ec 08             	sub    $0x8,%esp
80100eef:	53                   	push   %ebx
80100ef0:	56                   	push   %esi
80100ef1:	e8 6a 24 00 00       	call   80103360 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f00:	e8 bb 1c 00 00       	call   80102bc0 <begin_op>
    iput(ff.ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 e0             	pushl  -0x20(%ebp)
80100f0b:	e8 c0 08 00 00       	call   801017d0 <iput>
    end_op();
80100f10:	83 c4 10             	add    $0x10,%esp
}
80100f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f16:	5b                   	pop    %ebx
80100f17:	5e                   	pop    %esi
80100f18:	5f                   	pop    %edi
80100f19:	5d                   	pop    %ebp
    end_op();
80100f1a:	e9 11 1d 00 00       	jmp    80102c30 <end_op>
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 1c 7b 10 80       	push   $0x80107b1c
80100f27:	e8 64 f4 ff ff       	call   80100390 <panic>
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 73 10             	pushl  0x10(%ebx)
80100f45:	e8 56 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100f4a:	58                   	pop    %eax
80100f4b:	5a                   	pop    %edx
80100f4c:	ff 75 0c             	pushl  0xc(%ebp)
80100f4f:	ff 73 10             	pushl  0x10(%ebx)
80100f52:	e8 f9 09 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f57:	59                   	pop    %ecx
80100f58:	ff 73 10             	pushl  0x10(%ebx)
80100f5b:	e8 20 08 00 00       	call   80101780 <iunlock>
    return 0;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f75:	eb ee                	jmp    80100f65 <filestat+0x35>
80100f77:	89 f6                	mov    %esi,%esi
80100f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 60                	je     80100ff8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 41                	je     80100fe0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 5b                	jne    80100fff <fileread+0x7f>
    ilock(f->ip);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	ff 73 10             	pushl  0x10(%ebx)
80100faa:	e8 f1 06 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	57                   	push   %edi
80100fb0:	ff 73 14             	pushl  0x14(%ebx)
80100fb3:	56                   	push   %esi
80100fb4:	ff 73 10             	pushl  0x10(%ebx)
80100fb7:	e8 c4 09 00 00       	call   80101980 <readi>
80100fbc:	83 c4 20             	add    $0x20,%esp
80100fbf:	85 c0                	test   %eax,%eax
80100fc1:	89 c6                	mov    %eax,%esi
80100fc3:	7e 03                	jle    80100fc8 <fileread+0x48>
      f->off += r;
80100fc5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff 73 10             	pushl  0x10(%ebx)
80100fce:	e8 ad 07 00 00       	call   80101780 <iunlock>
    return r;
80100fd3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	89 f0                	mov    %esi,%eax
80100fdb:	5b                   	pop    %ebx
80100fdc:	5e                   	pop    %esi
80100fdd:	5f                   	pop    %edi
80100fde:	5d                   	pop    %ebp
80100fdf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fe3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	5b                   	pop    %ebx
80100fea:	5e                   	pop    %esi
80100feb:	5f                   	pop    %edi
80100fec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fed:	e9 1e 25 00 00       	jmp    80103510 <piperead>
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ffd:	eb d7                	jmp    80100fd6 <fileread+0x56>
  panic("fileread");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 26 7b 10 80       	push   $0x80107b26
80101007:	e8 84 f3 ff ff       	call   80100390 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 1c             	sub    $0x1c,%esp
80101019:	8b 75 08             	mov    0x8(%ebp),%esi
8010101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010101f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101023:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101026:	8b 45 10             	mov    0x10(%ebp),%eax
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 aa 00 00 00    	je     801010dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 06                	mov    (%esi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c3 00 00 00    	je     80101100 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d9 00 00 00    	jne    8010111f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101049:	31 ff                	xor    %edi,%edi
    while(i < n){
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 34                	jg     80101083 <filewrite+0x73>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101058:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101061:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101064:	e8 17 07 00 00       	call   80101780 <iunlock>
      end_op();
80101069:	e8 c2 1b 00 00       	call   80102c30 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101074:	39 c3                	cmp    %eax,%ebx
80101076:	0f 85 96 00 00 00    	jne    80101112 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010107c:	01 df                	add    %ebx,%edi
    while(i < n){
8010107e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101081:	7e 6d                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101083:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101086:	b8 00 06 00 00       	mov    $0x600,%eax
8010108b:	29 fb                	sub    %edi,%ebx
8010108d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101093:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101096:	e8 25 1b 00 00       	call   80102bc0 <begin_op>
      ilock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
801010a1:	e8 fa 05 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a9:	53                   	push   %ebx
801010aa:	ff 76 14             	pushl  0x14(%esi)
801010ad:	01 f8                	add    %edi,%eax
801010af:	50                   	push   %eax
801010b0:	ff 76 10             	pushl  0x10(%esi)
801010b3:	e8 c8 09 00 00       	call   80101a80 <writei>
801010b8:	83 c4 20             	add    $0x20,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 99                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	ff 76 10             	pushl  0x10(%esi)
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010c8:	e8 b3 06 00 00       	call   80101780 <iunlock>
      end_op();
801010cd:	e8 5e 1b 00 00       	call   80102c30 <end_op>
      if(r < 0)
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	85 c0                	test   %eax,%eax
801010da:	74 98                	je     80101074 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010e4:	89 f8                	mov    %edi,%eax
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
801010ea:	c3                   	ret    
801010eb:	90                   	nop
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010f3:	75 e7                	jne    801010dc <filewrite+0xcc>
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	89 f8                	mov    %edi,%eax
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
801010ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101100:	8b 46 0c             	mov    0xc(%esi),%eax
80101103:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	5b                   	pop    %ebx
8010110a:	5e                   	pop    %esi
8010110b:	5f                   	pop    %edi
8010110c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110d:	e9 ee 22 00 00       	jmp    80103400 <pipewrite>
        panic("short filewrite");
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	68 2f 7b 10 80       	push   $0x80107b2f
8010111a:	e8 71 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 35 7b 10 80       	push   $0x80107b35
80101127:	e8 64 f2 ff ff       	call   80100390 <panic>
8010112c:	66 90                	xchg   %ax,%ax
8010112e:	66 90                	xchg   %ax,%ax

80101130 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	56                   	push   %esi
80101134:	53                   	push   %ebx
80101135:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101137:	c1 ea 0c             	shr    $0xc,%edx
8010113a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101140:	83 ec 08             	sub    $0x8,%esp
80101143:	52                   	push   %edx
80101144:	50                   	push   %eax
80101145:	e8 86 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010114a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010114c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010114f:	ba 01 00 00 00       	mov    $0x1,%edx
80101154:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101157:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010115d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101160:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101162:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101167:	85 d1                	test   %edx,%ecx
80101169:	74 25                	je     80101190 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010116b:	f7 d2                	not    %edx
8010116d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010116f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101172:	21 ca                	and    %ecx,%edx
80101174:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101178:	56                   	push   %esi
80101179:	e8 12 1c 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010117e:	89 34 24             	mov    %esi,(%esp)
80101181:	e8 5a f0 ff ff       	call   801001e0 <brelse>
}
80101186:	83 c4 10             	add    $0x10,%esp
80101189:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010118c:	5b                   	pop    %ebx
8010118d:	5e                   	pop    %esi
8010118e:	5d                   	pop    %ebp
8010118f:	c3                   	ret    
    panic("freeing free block");
80101190:	83 ec 0c             	sub    $0xc,%esp
80101193:	68 3f 7b 10 80       	push   $0x80107b3f
80101198:	e8 f3 f1 ff ff       	call   80100390 <panic>
8010119d:	8d 76 00             	lea    0x0(%esi),%esi

801011a0 <balloc>:
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011a9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
801011af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011b2:	85 c9                	test   %ecx,%ecx
801011b4:	0f 84 87 00 00 00    	je     80101241 <balloc+0xa1>
801011ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	89 f0                	mov    %esi,%eax
801011c9:	c1 f8 0c             	sar    $0xc,%eax
801011cc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011d2:	50                   	push   %eax
801011d3:	ff 75 d8             	pushl  -0x28(%ebp)
801011d6:	e8 f5 ee ff ff       	call   801000d0 <bread>
801011db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011de:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011e3:	83 c4 10             	add    $0x10,%esp
801011e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011e9:	31 c0                	xor    %eax,%eax
801011eb:	eb 2f                	jmp    8010121c <balloc+0x7c>
801011ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011f0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011f5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011fa:	83 e1 07             	and    $0x7,%ecx
801011fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ff:	89 c1                	mov    %eax,%ecx
80101201:	c1 f9 03             	sar    $0x3,%ecx
80101204:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101209:	85 df                	test   %ebx,%edi
8010120b:	89 fa                	mov    %edi,%edx
8010120d:	74 41                	je     80101250 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010120f:	83 c0 01             	add    $0x1,%eax
80101212:	83 c6 01             	add    $0x1,%esi
80101215:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010121a:	74 05                	je     80101221 <balloc+0x81>
8010121c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010121f:	77 cf                	ja     801011f0 <balloc+0x50>
    brelse(bp);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	ff 75 e4             	pushl  -0x1c(%ebp)
80101227:	e8 b4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010122c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101233:	83 c4 10             	add    $0x10,%esp
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010123f:	77 80                	ja     801011c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	68 52 7b 10 80       	push   $0x80107b52
80101249:	e8 42 f1 ff ff       	call   80100390 <panic>
8010124e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101253:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101256:	09 da                	or     %ebx,%edx
80101258:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010125c:	57                   	push   %edi
8010125d:	e8 2e 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
80101262:	89 3c 24             	mov    %edi,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010126a:	58                   	pop    %eax
8010126b:	5a                   	pop    %edx
8010126c:	56                   	push   %esi
8010126d:	ff 75 d8             	pushl  -0x28(%ebp)
80101270:	e8 5b ee ff ff       	call   801000d0 <bread>
80101275:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101277:	8d 40 5c             	lea    0x5c(%eax),%eax
8010127a:	83 c4 0c             	add    $0xc,%esp
8010127d:	68 00 02 00 00       	push   $0x200
80101282:	6a 00                	push   $0x0
80101284:	50                   	push   %eax
80101285:	e8 b6 3c 00 00       	call   80104f40 <memset>
  log_write(bp);
8010128a:	89 1c 24             	mov    %ebx,(%esp)
8010128d:	e8 fe 1a 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101292:	89 1c 24             	mov    %ebx,(%esp)
80101295:	e8 46 ef ff ff       	call   801001e0 <brelse>
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	89 f0                	mov    %esi,%eax
8010129f:	5b                   	pop    %ebx
801012a0:	5e                   	pop    %esi
801012a1:	5f                   	pop    %edi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012bf:	83 ec 28             	sub    $0x28,%esp
801012c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012c5:	68 e0 19 11 80       	push   $0x801119e0
801012ca:	e8 61 3b 00 00       	call   80104e30 <acquire>
801012cf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d5:	eb 17                	jmp    801012ee <iget+0x3e>
801012d7:	89 f6                	mov    %esi,%esi
801012d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012e0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012ec:	73 22                	jae    80101310 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012f1:	85 c9                	test   %ecx,%ecx
801012f3:	7e 04                	jle    801012f9 <iget+0x49>
801012f5:	39 3b                	cmp    %edi,(%ebx)
801012f7:	74 4f                	je     80101348 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f9:	85 f6                	test   %esi,%esi
801012fb:	75 e3                	jne    801012e0 <iget+0x30>
801012fd:	85 c9                	test   %ecx,%ecx
801012ff:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101302:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101308:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010130e:	72 de                	jb     801012ee <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 5b                	je     8010136f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 19 11 80       	push   $0x801119e0
8010132f:	e8 bc 3b 00 00       	call   80104ef0 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
80101341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101348:	39 53 04             	cmp    %edx,0x4(%ebx)
8010134b:	75 ac                	jne    801012f9 <iget+0x49>
      release(&icache.lock);
8010134d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101350:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101353:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010135a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010135d:	e8 8e 3b 00 00       	call   80104ef0 <release>
      return ip;
80101362:	83 c4 10             	add    $0x10,%esp
}
80101365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101368:	89 f0                	mov    %esi,%eax
8010136a:	5b                   	pop    %ebx
8010136b:	5e                   	pop    %esi
8010136c:	5f                   	pop    %edi
8010136d:	5d                   	pop    %ebp
8010136e:	c3                   	ret    
    panic("iget: no inodes");
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	68 68 7b 10 80       	push   $0x80107b68
80101377:	e8 14 f0 ff ff       	call   80100390 <panic>
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	89 c6                	mov    %eax,%esi
80101388:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010138b:	83 fa 0b             	cmp    $0xb,%edx
8010138e:	77 18                	ja     801013a8 <bmap+0x28>
80101390:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101393:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101396:	85 db                	test   %ebx,%ebx
80101398:	74 76                	je     80101410 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013a8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013ab:	83 fb 7f             	cmp    $0x7f,%ebx
801013ae:	0f 87 90 00 00 00    	ja     80101444 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013b4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013ba:	8b 00                	mov    (%eax),%eax
801013bc:	85 d2                	test   %edx,%edx
801013be:	74 70                	je     80101430 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013c0:	83 ec 08             	sub    $0x8,%esp
801013c3:	52                   	push   %edx
801013c4:	50                   	push   %eax
801013c5:	e8 06 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ca:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ce:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013d1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013d3:	8b 1a                	mov    (%edx),%ebx
801013d5:	85 db                	test   %ebx,%ebx
801013d7:	75 1d                	jne    801013f6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013d9:	8b 06                	mov    (%esi),%eax
801013db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013de:	e8 bd fd ff ff       	call   801011a0 <balloc>
801013e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013e6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013e9:	89 c3                	mov    %eax,%ebx
801013eb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013ed:	57                   	push   %edi
801013ee:	e8 9d 19 00 00       	call   80102d90 <log_write>
801013f3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013f6:	83 ec 0c             	sub    $0xc,%esp
801013f9:	57                   	push   %edi
801013fa:	e8 e1 ed ff ff       	call   801001e0 <brelse>
801013ff:	83 c4 10             	add    $0x10,%esp
}
80101402:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101405:	89 d8                	mov    %ebx,%eax
80101407:	5b                   	pop    %ebx
80101408:	5e                   	pop    %esi
80101409:	5f                   	pop    %edi
8010140a:	5d                   	pop    %ebp
8010140b:	c3                   	ret    
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101410:	8b 00                	mov    (%eax),%eax
80101412:	e8 89 fd ff ff       	call   801011a0 <balloc>
80101417:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010141d:	89 c3                	mov    %eax,%ebx
}
8010141f:	89 d8                	mov    %ebx,%eax
80101421:	5b                   	pop    %ebx
80101422:	5e                   	pop    %esi
80101423:	5f                   	pop    %edi
80101424:	5d                   	pop    %ebp
80101425:	c3                   	ret    
80101426:	8d 76 00             	lea    0x0(%esi),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101430:	e8 6b fd ff ff       	call   801011a0 <balloc>
80101435:	89 c2                	mov    %eax,%edx
80101437:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010143d:	8b 06                	mov    (%esi),%eax
8010143f:	e9 7c ff ff ff       	jmp    801013c0 <bmap+0x40>
  panic("bmap: out of range");
80101444:	83 ec 0c             	sub    $0xc,%esp
80101447:	68 78 7b 10 80       	push   $0x80107b78
8010144c:	e8 3f ef ff ff       	call   80100390 <panic>
80101451:	eb 0d                	jmp    80101460 <readsb>
80101453:	90                   	nop
80101454:	90                   	nop
80101455:	90                   	nop
80101456:	90                   	nop
80101457:	90                   	nop
80101458:	90                   	nop
80101459:	90                   	nop
8010145a:	90                   	nop
8010145b:	90                   	nop
8010145c:	90                   	nop
8010145d:	90                   	nop
8010145e:	90                   	nop
8010145f:	90                   	nop

80101460 <readsb>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	56                   	push   %esi
80101464:	53                   	push   %ebx
80101465:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101468:	83 ec 08             	sub    $0x8,%esp
8010146b:	6a 01                	push   $0x1
8010146d:	ff 75 08             	pushl  0x8(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
80101475:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101477:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147a:	83 c4 0c             	add    $0xc,%esp
8010147d:	6a 1c                	push   $0x1c
8010147f:	50                   	push   %eax
80101480:	56                   	push   %esi
80101481:	e8 6a 3b 00 00       	call   80104ff0 <memmove>
  brelse(bp);
80101486:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101489:	83 c4 10             	add    $0x10,%esp
}
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
  brelse(bp);
80101492:	e9 49 ed ff ff       	jmp    801001e0 <brelse>
80101497:	89 f6                	mov    %esi,%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <iinit>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014ac:	68 8b 7b 10 80       	push   $0x80107b8b
801014b1:	68 e0 19 11 80       	push   $0x801119e0
801014b6:	e8 35 38 00 00       	call   80104cf0 <initlock>
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	68 92 7b 10 80       	push   $0x80107b92
801014c8:	53                   	push   %ebx
801014c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014cf:	e8 ec 36 00 00       	call   80104bc0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014d4:	83 c4 10             	add    $0x10,%esp
801014d7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014dd:	75 e1                	jne    801014c0 <iinit+0x20>
  readsb(dev, &sb);
801014df:	83 ec 08             	sub    $0x8,%esp
801014e2:	68 c0 19 11 80       	push   $0x801119c0
801014e7:	ff 75 08             	pushl  0x8(%ebp)
801014ea:	e8 71 ff ff ff       	call   80101460 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ef:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014f5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014fb:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101501:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101507:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010150d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101513:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101519:	68 f8 7b 10 80       	push   $0x80107bf8
8010151e:	e8 3d f1 ff ff       	call   80100660 <cprintf>
}
80101523:	83 c4 30             	add    $0x30,%esp
80101526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101529:	c9                   	leave  
8010152a:	c3                   	ret    
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
80101543:	8b 75 08             	mov    0x8(%ebp),%esi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 91 00 00 00    	jbe    801015e0 <ialloc+0xb0>
8010154f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101554:	eb 21                	jmp    80101577 <ialloc+0x47>
80101556:	8d 76 00             	lea    0x0(%esi),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	57                   	push   %edi
80101567:	e8 74 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 c4 10             	add    $0x10,%esp
8010156f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101575:	76 69                	jbe    801015e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101577:	89 d8                	mov    %ebx,%eax
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	c1 e8 03             	shr    $0x3,%eax
8010157f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101585:	50                   	push   %eax
80101586:	56                   	push   %esi
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101590:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101593:	83 e0 07             	and    $0x7,%eax
80101596:	c1 e0 06             	shl    $0x6,%eax
80101599:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015a1:	75 bd                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a3:	83 ec 04             	sub    $0x4,%esp
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	6a 40                	push   $0x40
801015ab:	6a 00                	push   $0x0
801015ad:	51                   	push   %ecx
801015ae:	e8 8d 39 00 00       	call   80104f40 <memset>
      dip->type = type;
801015b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015bd:	89 3c 24             	mov    %edi,(%esp)
801015c0:	e8 cb 17 00 00       	call   80102d90 <log_write>
      brelse(bp);
801015c5:	89 3c 24             	mov    %edi,(%esp)
801015c8:	e8 13 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015cd:	83 c4 10             	add    $0x10,%esp
}
801015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015d3:	89 da                	mov    %ebx,%edx
801015d5:	89 f0                	mov    %esi,%eax
}
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5f                   	pop    %edi
801015da:	5d                   	pop    %ebp
      return iget(dev, inum);
801015db:	e9 d0 fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 98 7b 10 80       	push   $0x80107b98
801015e8:	e8 a3 ed ff ff       	call   80100390 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010160a:	50                   	push   %eax
8010160b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010160e:	e8 bd ea ff ff       	call   801000d0 <bread>
80101613:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101615:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101618:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010161f:	83 e0 07             	and    $0x7,%eax
80101622:	c1 e0 06             	shl    $0x6,%eax
80101625:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101629:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010162c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101630:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101633:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101637:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010163b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010163f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101643:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101647:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010164a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164d:	6a 34                	push   $0x34
8010164f:	53                   	push   %ebx
80101650:	50                   	push   %eax
80101651:	e8 9a 39 00 00       	call   80104ff0 <memmove>
  log_write(bp);
80101656:	89 34 24             	mov    %esi,(%esp)
80101659:	e8 32 17 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010165e:	89 75 08             	mov    %esi,0x8(%ebp)
80101661:	83 c4 10             	add    $0x10,%esp
}
80101664:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5d                   	pop    %ebp
  brelse(bp);
8010166a:	e9 71 eb ff ff       	jmp    801001e0 <brelse>
8010166f:	90                   	nop

80101670 <idup>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 10             	sub    $0x10,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	68 e0 19 11 80       	push   $0x801119e0
8010167f:	e8 ac 37 00 00       	call   80104e30 <acquire>
  ip->ref++;
80101684:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101688:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010168f:	e8 5c 38 00 00       	call   80104ef0 <release>
}
80101694:	89 d8                	mov    %ebx,%eax
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ilock>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016a8:	85 db                	test   %ebx,%ebx
801016aa:	0f 84 b7 00 00 00    	je     80101767 <ilock+0xc7>
801016b0:	8b 53 08             	mov    0x8(%ebx),%edx
801016b3:	85 d2                	test   %edx,%edx
801016b5:	0f 8e ac 00 00 00    	jle    80101767 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016bb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016be:	83 ec 0c             	sub    $0xc,%esp
801016c1:	50                   	push   %eax
801016c2:	e8 39 35 00 00       	call   80104c00 <acquiresleep>
  if(ip->valid == 0){
801016c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ca:	83 c4 10             	add    $0x10,%esp
801016cd:	85 c0                	test   %eax,%eax
801016cf:	74 0f                	je     801016e0 <ilock+0x40>
}
801016d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d4:	5b                   	pop    %ebx
801016d5:	5e                   	pop    %esi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    
801016d8:	90                   	nop
801016d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e0:	8b 43 04             	mov    0x4(%ebx),%eax
801016e3:	83 ec 08             	sub    $0x8,%esp
801016e6:	c1 e8 03             	shr    $0x3,%eax
801016e9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ef:	50                   	push   %eax
801016f0:	ff 33                	pushl  (%ebx)
801016f2:	e8 d9 e9 ff ff       	call   801000d0 <bread>
801016f7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101709:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010170f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101713:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101717:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010171b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010171f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101723:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101727:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010172b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010172e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101731:	6a 34                	push   $0x34
80101733:	50                   	push   %eax
80101734:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101737:	50                   	push   %eax
80101738:	e8 b3 38 00 00       	call   80104ff0 <memmove>
    brelse(bp);
8010173d:	89 34 24             	mov    %esi,(%esp)
80101740:	e8 9b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 77 ff ff ff    	jne    801016d1 <ilock+0x31>
      panic("ilock: no type");
8010175a:	83 ec 0c             	sub    $0xc,%esp
8010175d:	68 b0 7b 10 80       	push   $0x80107bb0
80101762:	e8 29 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 aa 7b 10 80       	push   $0x80107baa
8010176f:	e8 1c ec ff ff       	call   80100390 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iunlock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	74 28                	je     801017b4 <iunlock+0x34>
8010178c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	56                   	push   %esi
80101793:	e8 08 35 00 00       	call   80104ca0 <holdingsleep>
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	85 c0                	test   %eax,%eax
8010179d:	74 15                	je     801017b4 <iunlock+0x34>
8010179f:	8b 43 08             	mov    0x8(%ebx),%eax
801017a2:	85 c0                	test   %eax,%eax
801017a4:	7e 0e                	jle    801017b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ac:	5b                   	pop    %ebx
801017ad:	5e                   	pop    %esi
801017ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017af:	e9 ac 34 00 00       	jmp    80104c60 <releasesleep>
    panic("iunlock");
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	68 bf 7b 10 80       	push   $0x80107bbf
801017bc:	e8 cf eb ff ff       	call   80100390 <panic>
801017c1:	eb 0d                	jmp    801017d0 <iput>
801017c3:	90                   	nop
801017c4:	90                   	nop
801017c5:	90                   	nop
801017c6:	90                   	nop
801017c7:	90                   	nop
801017c8:	90                   	nop
801017c9:	90                   	nop
801017ca:	90                   	nop
801017cb:	90                   	nop
801017cc:	90                   	nop
801017cd:	90                   	nop
801017ce:	90                   	nop
801017cf:	90                   	nop

801017d0 <iput>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 28             	sub    $0x28,%esp
801017d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017df:	57                   	push   %edi
801017e0:	e8 1b 34 00 00       	call   80104c00 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 d2                	test   %edx,%edx
801017ed:	74 07                	je     801017f6 <iput+0x26>
801017ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017f4:	74 32                	je     80101828 <iput+0x58>
  releasesleep(&ip->lock);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	57                   	push   %edi
801017fa:	e8 61 34 00 00       	call   80104c60 <releasesleep>
  acquire(&icache.lock);
801017ff:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101806:	e8 25 36 00 00       	call   80104e30 <acquire>
  ip->ref--;
8010180b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010180f:	83 c4 10             	add    $0x10,%esp
80101812:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5f                   	pop    %edi
8010181f:	5d                   	pop    %ebp
  release(&icache.lock);
80101820:	e9 cb 36 00 00       	jmp    80104ef0 <release>
80101825:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 e0 19 11 80       	push   $0x801119e0
80101830:	e8 fb 35 00 00       	call   80104e30 <acquire>
    int r = ip->ref;
80101835:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101838:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010183f:	e8 ac 36 00 00       	call   80104ef0 <release>
    if(r == 1){
80101844:	83 c4 10             	add    $0x10,%esp
80101847:	83 fe 01             	cmp    $0x1,%esi
8010184a:	75 aa                	jne    801017f6 <iput+0x26>
8010184c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101852:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101855:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x97>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fe                	cmp    %edi,%esi
80101865:	74 19                	je     80101880 <iput+0xb0>
    if(ip->addrs[i]){
80101867:	8b 16                	mov    (%esi),%edx
80101869:	85 d2                	test   %edx,%edx
8010186b:	74 f3                	je     80101860 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010186d:	8b 03                	mov    (%ebx),%eax
8010186f:	e8 bc f8 ff ff       	call   80101130 <bfree>
      ip->addrs[i] = 0;
80101874:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010187a:	eb e4                	jmp    80101860 <iput+0x90>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 33                	jne    801018c0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010188d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101890:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101897:	53                   	push   %ebx
80101898:	e8 53 fd ff ff       	call   801015f0 <iupdate>
      ip->type = 0;
8010189d:	31 c0                	xor    %eax,%eax
8010189f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018a3:	89 1c 24             	mov    %ebx,(%esp)
801018a6:	e8 45 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
801018ab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	e9 3c ff ff ff       	jmp    801017f6 <iput+0x26>
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	83 ec 08             	sub    $0x8,%esp
801018c3:	50                   	push   %eax
801018c4:	ff 33                	pushl  (%ebx)
801018c6:	e8 05 e8 ff ff       	call   801000d0 <bread>
801018cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018d1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018d7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	89 cf                	mov    %ecx,%edi
801018df:	eb 0e                	jmp    801018ef <iput+0x11f>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018eb:	39 fe                	cmp    %edi,%esi
801018ed:	74 0f                	je     801018fe <iput+0x12e>
      if(a[j])
801018ef:	8b 16                	mov    (%esi),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018f5:	8b 03                	mov    (%ebx),%eax
801018f7:	e8 34 f8 ff ff       	call   80101130 <bfree>
801018fc:	eb ea                	jmp    801018e8 <iput+0x118>
    brelse(bp);
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	ff 75 e4             	pushl  -0x1c(%ebp)
80101904:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101907:	e8 d4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010190c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101912:	8b 03                	mov    (%ebx),%eax
80101914:	e8 17 f8 ff ff       	call   80101130 <bfree>
    ip->addrs[NDIRECT] = 0;
80101919:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101920:	00 00 00 
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	e9 62 ff ff ff       	jmp    8010188d <iput+0xbd>
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <iunlockput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	53                   	push   %ebx
8010193b:	e8 40 fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101940:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101943:	83 c4 10             	add    $0x10,%esp
}
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
  iput(ip);
8010194a:	e9 81 fe ff ff       	jmp    801017d0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 1c             	sub    $0x1c,%esp
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010198f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101992:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101997:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010199a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010199d:	8b 75 10             	mov    0x10(%ebp),%esi
801019a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019a3:	0f 84 a7 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019ac:	8b 40 58             	mov    0x58(%eax),%eax
801019af:	39 c6                	cmp    %eax,%esi
801019b1:	0f 87 ba 00 00 00    	ja     80101a71 <readi+0xf1>
801019b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ba:	89 f9                	mov    %edi,%ecx
801019bc:	01 f1                	add    %esi,%ecx
801019be:	0f 82 ad 00 00 00    	jb     80101a71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c4:	89 c2                	mov    %eax,%edx
801019c6:	29 f2                	sub    %esi,%edx
801019c8:	39 c8                	cmp    %ecx,%eax
801019ca:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	31 ff                	xor    %edi,%edi
801019cf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d4:	74 6c                	je     80101a42 <readi+0xc2>
801019d6:	8d 76 00             	lea    0x0(%esi),%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019e3:	89 f2                	mov    %esi,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	89 d8                	mov    %ebx,%eax
801019ea:	e8 91 f9 ff ff       	call   80101380 <bmap>
801019ef:	83 ec 08             	sub    $0x8,%esp
801019f2:	50                   	push   %eax
801019f3:	ff 33                	pushl  (%ebx)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019fd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ff:	89 f0                	mov    %esi,%eax
80101a01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a0b:	83 c4 0c             	add    $0xc,%esp
80101a0e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a14:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	29 fb                	sub    %edi,%ebx
80101a19:	39 d9                	cmp    %ebx,%ecx
80101a1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1e:	53                   	push   %ebx
80101a1f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a20:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a25:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a27:	e8 c4 35 00 00       	call   80104ff0 <memmove>
    brelse(bp);
80101a2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a2f:	89 14 24             	mov    %edx,(%esp)
80101a32:	e8 a9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3a:	83 c4 10             	add    $0x10,%esp
80101a3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a40:	77 9e                	ja     801019e0 <readi+0x60>
  }
  return n;
80101a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5f                   	pop    %edi
80101a4b:	5d                   	pop    %ebp
80101a4c:	c3                   	ret    
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 17                	ja     80101a71 <readi+0xf1>
80101a5a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 0c                	je     80101a71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5f                   	pop    %edi
80101a6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a6f:	ff e0                	jmp    *%eax
      return -1;
80101a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a76:	eb cd                	jmp    80101a45 <readi+0xc5>
80101a78:	90                   	nop
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 1c             	sub    $0x1c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 eb 00 00 00    	jb     80101ba0 <writei+0x120>
80101ab5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab8:	31 d2                	xor    %edx,%edx
80101aba:	89 f8                	mov    %edi,%eax
80101abc:	01 f0                	add    %esi,%eax
80101abe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac6:	0f 87 d4 00 00 00    	ja     80101ba0 <writei+0x120>
80101acc:	85 d2                	test   %edx,%edx
80101ace:	0f 85 cc 00 00 00    	jne    80101ba0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad4:	85 ff                	test   %edi,%edi
80101ad6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101add:	74 72                	je     80101b51 <writei+0xd1>
80101adf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ae3:	89 f2                	mov    %esi,%edx
80101ae5:	c1 ea 09             	shr    $0x9,%edx
80101ae8:	89 f8                	mov    %edi,%eax
80101aea:	e8 91 f8 ff ff       	call   80101380 <bmap>
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	50                   	push   %eax
80101af3:	ff 37                	pushl  (%edi)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101afd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b09:	83 c4 0c             	add    $0xc,%esp
80101b0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b17:	39 d9                	cmp    %ebx,%ecx
80101b19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b1c:	53                   	push   %ebx
80101b1d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b20:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b22:	50                   	push   %eax
80101b23:	e8 c8 34 00 00       	call   80104ff0 <memmove>
    log_write(bp);
80101b28:	89 3c 24             	mov    %edi,(%esp)
80101b2b:	e8 60 12 00 00       	call   80102d90 <log_write>
    brelse(bp);
80101b30:	89 3c 24             	mov    %edi,(%esp)
80101b33:	e8 a8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b3e:	83 c4 10             	add    $0x10,%esp
80101b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b47:	77 97                	ja     80101ae0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b4f:	77 37                	ja     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b57:	5b                   	pop    %ebx
80101b58:	5e                   	pop    %esi
80101b59:	5f                   	pop    %edi
80101b5a:	5d                   	pop    %ebp
80101b5b:	c3                   	ret    
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 36                	ja     80101ba0 <writei+0x120>
80101b6a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 2b                	je     80101ba0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b91:	50                   	push   %eax
80101b92:	e8 59 fa ff ff       	call   801015f0 <iupdate>
80101b97:	83 c4 10             	add    $0x10,%esp
80101b9a:	eb b5                	jmp    80101b51 <writei+0xd1>
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba5:	eb ad                	jmp    80101b54 <writei+0xd4>
80101ba7:	89 f6                	mov    %esi,%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	6a 0e                	push   $0xe
80101bb8:	ff 75 0c             	pushl  0xc(%ebp)
80101bbb:	ff 75 08             	pushl  0x8(%ebp)
80101bbe:	e8 9d 34 00 00       	call   80105060 <strncmp>
}
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    
80101bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 85 00 00 00    	jne    80101c6c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	74 3e                	je     80101c31 <dirlookup+0x61>
80101bf3:	90                   	nop
80101bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf8:	6a 10                	push   $0x10
80101bfa:	57                   	push   %edi
80101bfb:	56                   	push   %esi
80101bfc:	53                   	push   %ebx
80101bfd:	e8 7e fd ff ff       	call   80101980 <readi>
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	83 f8 10             	cmp    $0x10,%eax
80101c08:	75 55                	jne    80101c5f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c0f:	74 18                	je     80101c29 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c14:	83 ec 04             	sub    $0x4,%esp
80101c17:	6a 0e                	push   $0xe
80101c19:	50                   	push   %eax
80101c1a:	ff 75 0c             	pushl  0xc(%ebp)
80101c1d:	e8 3e 34 00 00       	call   80105060 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 17                	je     80101c40 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c29:	83 c7 10             	add    $0x10,%edi
80101c2c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c2f:	72 c7                	jb     80101bf8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c34:	31 c0                	xor    %eax,%eax
}
80101c36:	5b                   	pop    %ebx
80101c37:	5e                   	pop    %esi
80101c38:	5f                   	pop    %edi
80101c39:	5d                   	pop    %ebp
80101c3a:	c3                   	ret    
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c40:	8b 45 10             	mov    0x10(%ebp),%eax
80101c43:	85 c0                	test   %eax,%eax
80101c45:	74 05                	je     80101c4c <dirlookup+0x7c>
        *poff = off;
80101c47:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c50:	8b 03                	mov    (%ebx),%eax
80101c52:	e8 59 f6 ff ff       	call   801012b0 <iget>
}
80101c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5a:	5b                   	pop    %ebx
80101c5b:	5e                   	pop    %esi
80101c5c:	5f                   	pop    %edi
80101c5d:	5d                   	pop    %ebp
80101c5e:	c3                   	ret    
      panic("dirlookup read");
80101c5f:	83 ec 0c             	sub    $0xc,%esp
80101c62:	68 d9 7b 10 80       	push   $0x80107bd9
80101c67:	e8 24 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c6c:	83 ec 0c             	sub    $0xc,%esp
80101c6f:	68 c7 7b 10 80       	push   $0x80107bc7
80101c74:	e8 17 e7 ff ff       	call   80100390 <panic>
80101c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	89 cf                	mov    %ecx,%edi
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c93:	0f 84 67 01 00 00    	je     80101e00 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 d2 1c 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ca1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ca4:	68 e0 19 11 80       	push   $0x801119e0
80101ca9:	e8 82 31 00 00       	call   80104e30 <acquire>
  ip->ref++;
80101cae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cb9:	e8 32 32 00 00       	call   80104ef0 <release>
80101cbe:	83 c4 10             	add    $0x10,%esp
80101cc1:	eb 08                	jmp    80101ccb <namex+0x4b>
80101cc3:	90                   	nop
80101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cc8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ccb:	0f b6 03             	movzbl (%ebx),%eax
80101cce:	3c 2f                	cmp    $0x2f,%al
80101cd0:	74 f6                	je     80101cc8 <namex+0x48>
  if(*path == 0)
80101cd2:	84 c0                	test   %al,%al
80101cd4:	0f 84 ee 00 00 00    	je     80101dc8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cda:	0f b6 03             	movzbl (%ebx),%eax
80101cdd:	3c 2f                	cmp    $0x2f,%al
80101cdf:	0f 84 b3 00 00 00    	je     80101d98 <namex+0x118>
80101ce5:	84 c0                	test   %al,%al
80101ce7:	89 da                	mov    %ebx,%edx
80101ce9:	75 09                	jne    80101cf4 <namex+0x74>
80101ceb:	e9 a8 00 00 00       	jmp    80101d98 <namex+0x118>
80101cf0:	84 c0                	test   %al,%al
80101cf2:	74 0a                	je     80101cfe <namex+0x7e>
    path++;
80101cf4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf7:	0f b6 02             	movzbl (%edx),%eax
80101cfa:	3c 2f                	cmp    $0x2f,%al
80101cfc:	75 f2                	jne    80101cf0 <namex+0x70>
80101cfe:	89 d1                	mov    %edx,%ecx
80101d00:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d02:	83 f9 0d             	cmp    $0xd,%ecx
80101d05:	0f 8e 91 00 00 00    	jle    80101d9c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d0b:	83 ec 04             	sub    $0x4,%esp
80101d0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d11:	6a 0e                	push   $0xe
80101d13:	53                   	push   %ebx
80101d14:	57                   	push   %edi
80101d15:	e8 d6 32 00 00       	call   80104ff0 <memmove>
    path++;
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d1d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d20:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d25:	75 11                	jne    80101d38 <namex+0xb8>
80101d27:	89 f6                	mov    %esi,%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	56                   	push   %esi
80101d3c:	e8 5f f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d49:	0f 85 91 00 00 00    	jne    80101de0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d52:	85 d2                	test   %edx,%edx
80101d54:	74 09                	je     80101d5f <namex+0xdf>
80101d56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d59:	0f 84 b7 00 00 00    	je     80101e16 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5f:	83 ec 04             	sub    $0x4,%esp
80101d62:	6a 00                	push   $0x0
80101d64:	57                   	push   %edi
80101d65:	56                   	push   %esi
80101d66:	e8 65 fe ff ff       	call   80101bd0 <dirlookup>
80101d6b:	83 c4 10             	add    $0x10,%esp
80101d6e:	85 c0                	test   %eax,%eax
80101d70:	74 6e                	je     80101de0 <namex+0x160>
  iunlock(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d78:	56                   	push   %esi
80101d79:	e8 02 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	83 c4 10             	add    $0x10,%esp
80101d8c:	89 c6                	mov    %eax,%esi
80101d8e:	e9 38 ff ff ff       	jmp    80101ccb <namex+0x4b>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d98:	89 da                	mov    %ebx,%edx
80101d9a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d9c:	83 ec 04             	sub    $0x4,%esp
80101d9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da5:	51                   	push   %ecx
80101da6:	53                   	push   %ebx
80101da7:	57                   	push   %edi
80101da8:	e8 43 32 00 00       	call   80104ff0 <memmove>
    name[len] = 0;
80101dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dba:	89 d3                	mov    %edx,%ebx
80101dbc:	e9 61 ff ff ff       	jmp    80101d22 <namex+0xa2>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	75 5d                	jne    80101e2c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	89 f0                	mov    %esi,%eax
80101dd4:	5b                   	pop    %ebx
80101dd5:	5e                   	pop    %esi
80101dd6:	5f                   	pop    %edi
80101dd7:	5d                   	pop    %ebp
80101dd8:	c3                   	ret    
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	56                   	push   %esi
80101de4:	e8 97 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101de9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dec:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dee:	e8 dd f9 ff ff       	call   801017d0 <iput>
      return 0;
80101df3:	83 c4 10             	add    $0x10,%esp
}
80101df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df9:	89 f0                	mov    %esi,%eax
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e00:	ba 01 00 00 00       	mov    $0x1,%edx
80101e05:	b8 01 00 00 00       	mov    $0x1,%eax
80101e0a:	e8 a1 f4 ff ff       	call   801012b0 <iget>
80101e0f:	89 c6                	mov    %eax,%esi
80101e11:	e9 b5 fe ff ff       	jmp    80101ccb <namex+0x4b>
      iunlock(ip);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	56                   	push   %esi
80101e1a:	e8 61 f9 ff ff       	call   80101780 <iunlock>
      return ip;
80101e1f:	83 c4 10             	add    $0x10,%esp
}
80101e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e25:	89 f0                	mov    %esi,%eax
80101e27:	5b                   	pop    %ebx
80101e28:	5e                   	pop    %esi
80101e29:	5f                   	pop    %edi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
    iput(ip);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	56                   	push   %esi
    return 0;
80101e30:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e32:	e8 99 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb 93                	jmp    80101dcf <namex+0x14f>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 20             	sub    $0x20,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	6a 00                	push   $0x0
80101e4e:	ff 75 0c             	pushl  0xc(%ebp)
80101e51:	53                   	push   %ebx
80101e52:	e8 79 fd ff ff       	call   80101bd0 <dirlookup>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	75 67                	jne    80101ec5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e61:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e64:	85 ff                	test   %edi,%edi
80101e66:	74 29                	je     80101e91 <dirlink+0x51>
80101e68:	31 ff                	xor    %edi,%edi
80101e6a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6d:	eb 09                	jmp    80101e78 <dirlink+0x38>
80101e6f:	90                   	nop
80101e70:	83 c7 10             	add    $0x10,%edi
80101e73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e76:	73 19                	jae    80101e91 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 fe fa ff ff       	call   80101980 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 4e                	jne    80101ed8 <dirlink+0x98>
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	75 df                	jne    80101e70 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	ff 75 0c             	pushl  0xc(%ebp)
80101e9c:	50                   	push   %eax
80101e9d:	e8 1e 32 00 00       	call   801050c0 <strncpy>
  de.inum = inum;
80101ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea5:	6a 10                	push   $0x10
80101ea7:	57                   	push   %edi
80101ea8:	56                   	push   %esi
80101ea9:	53                   	push   %ebx
  de.inum = inum;
80101eaa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eae:	e8 cd fb ff ff       	call   80101a80 <writei>
80101eb3:	83 c4 20             	add    $0x20,%esp
80101eb6:	83 f8 10             	cmp    $0x10,%eax
80101eb9:	75 2a                	jne    80101ee5 <dirlink+0xa5>
  return 0;
80101ebb:	31 c0                	xor    %eax,%eax
}
80101ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec0:	5b                   	pop    %ebx
80101ec1:	5e                   	pop    %esi
80101ec2:	5f                   	pop    %edi
80101ec3:	5d                   	pop    %ebp
80101ec4:	c3                   	ret    
    iput(ip);
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	50                   	push   %eax
80101ec9:	e8 02 f9 ff ff       	call   801017d0 <iput>
    return -1;
80101ece:	83 c4 10             	add    $0x10,%esp
80101ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed6:	eb e5                	jmp    80101ebd <dirlink+0x7d>
      panic("dirlink read");
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 e8 7b 10 80       	push   $0x80107be8
80101ee0:	e8 ab e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	68 ce 83 10 80       	push   $0x801083ce
80101eed:	e8 9e e4 ff ff       	call   80100390 <panic>
80101ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f49:	85 c0                	test   %eax,%eax
80101f4b:	0f 84 b4 00 00 00    	je     80102005 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f51:	8b 58 08             	mov    0x8(%eax),%ebx
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f5c:	0f 87 96 00 00 00    	ja     80101ff8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f62:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f70:	89 ca                	mov    %ecx,%edx
80101f72:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f73:	83 e0 c0             	and    $0xffffffc0,%eax
80101f76:	3c 40                	cmp    $0x40,%al
80101f78:	75 f6                	jne    80101f70 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f81:	89 f8                	mov    %edi,%eax
80101f83:	ee                   	out    %al,(%dx)
80101f84:	b8 01 00 00 00       	mov    $0x1,%eax
80101f89:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8e:	ee                   	out    %al,(%dx)
80101f8f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f94:	89 d8                	mov    %ebx,%eax
80101f96:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f9e:	c1 f8 08             	sar    $0x8,%eax
80101fa1:	ee                   	out    %al,(%dx)
80101fa2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fa7:	89 f8                	mov    %edi,%eax
80101fa9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101faa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fae:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fb3:	c1 e0 04             	shl    $0x4,%eax
80101fb6:	83 e0 10             	and    $0x10,%eax
80101fb9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fbc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fbd:	f6 06 04             	testb  $0x4,(%esi)
80101fc0:	75 16                	jne    80101fd8 <idestart+0x98>
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	89 ca                	mov    %ecx,%edx
80101fc9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcd:	5b                   	pop    %ebx
80101fce:	5e                   	pop    %esi
80101fcf:	5f                   	pop    %edi
80101fd0:	5d                   	pop    %ebp
80101fd1:	c3                   	ret    
80101fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fd8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fdd:	89 ca                	mov    %ecx,%edx
80101fdf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fe5:	83 c6 5c             	add    $0x5c,%esi
80101fe8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fed:	fc                   	cld    
80101fee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff3:	5b                   	pop    %ebx
80101ff4:	5e                   	pop    %esi
80101ff5:	5f                   	pop    %edi
80101ff6:	5d                   	pop    %ebp
80101ff7:	c3                   	ret    
    panic("incorrect blockno");
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	68 54 7c 10 80       	push   $0x80107c54
80102000:	e8 8b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 4b 7c 10 80       	push   $0x80107c4b
8010200d:	e8 7e e3 ff ff       	call   80100390 <panic>
80102012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102026:	68 66 7c 10 80       	push   $0x80107c66
8010202b:	68 80 b5 10 80       	push   $0x8010b580
80102030:	e8 bb 2c 00 00       	call   80104cf0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102035:	58                   	pop    %eax
80102036:	a1 30 38 11 80       	mov    0x80113830,%eax
8010203b:	5a                   	pop    %edx
8010203c:	83 e8 01             	sub    $0x1,%eax
8010203f:	50                   	push   %eax
80102040:	6a 0e                	push   $0xe
80102042:	e8 a9 02 00 00       	call   801022f0 <ioapicenable>
80102047:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010204a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204f:	90                   	nop
80102050:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102051:	83 e0 c0             	and    $0xffffffc0,%eax
80102054:	3c 40                	cmp    $0x40,%al
80102056:	75 f8                	jne    80102050 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102062:	ee                   	out    %al,(%dx)
80102063:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102068:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206d:	eb 06                	jmp    80102075 <ideinit+0x55>
8010206f:	90                   	nop
  for(i=0; i<1000; i++){
80102070:	83 e9 01             	sub    $0x1,%ecx
80102073:	74 0f                	je     80102084 <ideinit+0x64>
80102075:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102076:	84 c0                	test   %al,%al
80102078:	74 f6                	je     80102070 <ideinit+0x50>
      havedisk1 = 1;
8010207a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102081:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102084:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102089:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010208e:	ee                   	out    %al,(%dx)
}
8010208f:	c9                   	leave  
80102090:	c3                   	ret    
80102091:	eb 0d                	jmp    801020a0 <ideintr>
80102093:	90                   	nop
80102094:	90                   	nop
80102095:	90                   	nop
80102096:	90                   	nop
80102097:	90                   	nop
80102098:	90                   	nop
80102099:	90                   	nop
8010209a:	90                   	nop
8010209b:	90                   	nop
8010209c:	90                   	nop
8010209d:	90                   	nop
8010209e:	90                   	nop
8010209f:	90                   	nop

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	68 80 b5 10 80       	push   $0x8010b580
801020ae:	e8 7d 2d 00 00       	call   80104e30 <acquire>

  if((b = idequeue) == 0){
801020b3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	85 db                	test   %ebx,%ebx
801020be:	74 67                	je     80102127 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020c0:	8b 43 58             	mov    0x58(%ebx),%eax
801020c3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c8:	8b 3b                	mov    (%ebx),%edi
801020ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020d0:	75 31                	jne    80102103 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020d7:	89 f6                	mov    %esi,%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c6                	mov    %eax,%esi
801020e3:	83 e6 c0             	and    $0xffffffc0,%esi
801020e6:	89 f1                	mov    %esi,%ecx
801020e8:	80 f9 40             	cmp    $0x40,%cl
801020eb:	75 f3                	jne    801020e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ed:	a8 21                	test   $0x21,%al
801020ef:	75 12                	jne    80102103 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fe:	fc                   	cld    
801020ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102101:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102103:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102106:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102109:	89 f9                	mov    %edi,%ecx
8010210b:	83 c9 02             	or     $0x2,%ecx
8010210e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102110:	53                   	push   %ebx
80102111:	e8 4a 22 00 00       	call   80104360 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102116:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	85 c0                	test   %eax,%eax
80102120:	74 05                	je     80102127 <ideintr+0x87>
    idestart(idequeue);
80102122:	e8 19 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
80102127:	83 ec 0c             	sub    $0xc,%esp
8010212a:	68 80 b5 10 80       	push   $0x8010b580
8010212f:	e8 bc 2d 00 00       	call   80104ef0 <release>

  release(&idelock);
}
80102134:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102137:	5b                   	pop    %ebx
80102138:	5e                   	pop    %esi
80102139:	5f                   	pop    %edi
8010213a:	5d                   	pop    %ebp
8010213b:	c3                   	ret    
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 10             	sub    $0x10,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	50                   	push   %eax
8010214e:	e8 4d 2b 00 00       	call   80104ca0 <holdingsleep>
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	85 c0                	test   %eax,%eax
80102158:	0f 84 c6 00 00 00    	je     80102224 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	0f 84 ab 00 00 00    	je     80102217 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216c:	8b 53 04             	mov    0x4(%ebx),%edx
8010216f:	85 d2                	test   %edx,%edx
80102171:	74 0d                	je     80102180 <iderw+0x40>
80102173:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102178:	85 c0                	test   %eax,%eax
8010217a:	0f 84 b1 00 00 00    	je     80102231 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	e8 a3 2c 00 00       	call   80104e30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102193:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102196:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	85 d2                	test   %edx,%edx
8010219f:	75 09                	jne    801021aa <iderw+0x6a>
801021a1:	eb 6d                	jmp    80102210 <iderw+0xd0>
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a8:	89 c2                	mov    %eax,%edx
801021aa:	8b 42 58             	mov    0x58(%edx),%eax
801021ad:	85 c0                	test   %eax,%eax
801021af:	75 f7                	jne    801021a8 <iderw+0x68>
801021b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021b6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021bc:	74 42                	je     80102200 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 e0 06             	and    $0x6,%eax
801021c3:	83 f8 02             	cmp    $0x2,%eax
801021c6:	74 23                	je     801021eb <iderw+0xab>
801021c8:	90                   	nop
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021d0:	83 ec 08             	sub    $0x8,%esp
801021d3:	68 80 b5 10 80       	push   $0x8010b580
801021d8:	53                   	push   %ebx
801021d9:	e8 c2 1f 00 00       	call   801041a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 c4 10             	add    $0x10,%esp
801021e3:	83 e0 06             	and    $0x6,%eax
801021e6:	83 f8 02             	cmp    $0x2,%eax
801021e9:	75 e5                	jne    801021d0 <iderw+0x90>
  }


  release(&idelock);
801021eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f5:	c9                   	leave  
  release(&idelock);
801021f6:	e9 f5 2c 00 00       	jmp    80104ef0 <release>
801021fb:	90                   	nop
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102200:	89 d8                	mov    %ebx,%eax
80102202:	e8 39 fd ff ff       	call   80101f40 <idestart>
80102207:	eb b5                	jmp    801021be <iderw+0x7e>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102210:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102215:	eb 9d                	jmp    801021b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 80 7c 10 80       	push   $0x80107c80
8010221f:	e8 6c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 6a 7c 10 80       	push   $0x80107c6a
8010222c:	e8 5f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102231:	83 ec 0c             	sub    $0xc,%esp
80102234:	68 95 7c 10 80       	push   $0x80107c95
80102239:	e8 52 e1 ff ff       	call   80100390 <panic>
8010223e:	66 90                	xchg   %ax,%ax

80102240 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102241:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102248:	00 c0 fe 
{
8010224b:	89 e5                	mov    %esp,%ebp
8010224d:	56                   	push   %esi
8010224e:	53                   	push   %ebx
  ioapic->reg = reg;
8010224f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102256:	00 00 00 
  return ioapic->data;
80102259:	a1 34 36 11 80       	mov    0x80113634,%eax
8010225e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102267:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010226d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102274:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102277:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010227a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010227d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102280:	39 c2                	cmp    %eax,%edx
80102282:	74 16                	je     8010229a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 b4 7c 10 80       	push   $0x80107cb4
8010228c:	e8 cf e3 ff ff       	call   80100660 <cprintf>
80102291:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	83 c3 21             	add    $0x21,%ebx
{
8010229d:	ba 10 00 00 00       	mov    $0x10,%edx
801022a2:	b8 20 00 00 00       	mov    $0x20,%eax
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022b2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022b8:	89 c6                	mov    %eax,%esi
801022ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022c0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022c3:	89 71 10             	mov    %esi,0x10(%ecx)
801022c6:	8d 72 01             	lea    0x1(%edx),%esi
801022c9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022cc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ce:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022d0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022dd:	75 d1                	jne    801022b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e2:	5b                   	pop    %ebx
801022e3:	5e                   	pop    %esi
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	8d 76 00             	lea    0x0(%esi),%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022f0:	55                   	push   %ebp
  ioapic->reg = reg;
801022f1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801022f7:	89 e5                	mov    %esp,%ebp
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022fc:	8d 50 20             	lea    0x20(%eax),%edx
801022ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102303:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102305:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010230e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102311:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102314:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102316:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010231e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102321:	5d                   	pop    %ebp
80102322:	c3                   	ret    
80102323:	66 90                	xchg   %ax,%ax
80102325:	66 90                	xchg   %ax,%ax
80102327:	66 90                	xchg   %ax,%ax
80102329:	66 90                	xchg   %ax,%ax
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 04             	sub    $0x4,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 70                	jne    801023b2 <kfree+0x82>
80102342:	81 fb c8 64 11 80    	cmp    $0x801164c8,%ebx
80102348:	72 68                	jb     801023b2 <kfree+0x82>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 5b                	ja     801023b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102357:	83 ec 04             	sub    $0x4,%esp
8010235a:	68 00 10 00 00       	push   $0x1000
8010235f:	6a 01                	push   $0x1
80102361:	53                   	push   %ebx
80102362:	e8 d9 2b 00 00       	call   80104f40 <memset>

  if(kmem.use_lock)
80102367:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	85 d2                	test   %edx,%edx
80102372:	75 2c                	jne    801023a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102374:	a1 78 36 11 80       	mov    0x80113678,%eax
80102379:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010237b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102380:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102386:	85 c0                	test   %eax,%eax
80102388:	75 06                	jne    80102390 <kfree+0x60>
    release(&kmem.lock);
}
8010238a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238d:	c9                   	leave  
8010238e:	c3                   	ret    
8010238f:	90                   	nop
    release(&kmem.lock);
80102390:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
    release(&kmem.lock);
8010239b:	e9 50 2b 00 00       	jmp    80104ef0 <release>
    acquire(&kmem.lock);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 40 36 11 80       	push   $0x80113640
801023a8:	e8 83 2a 00 00       	call   80104e30 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb c2                	jmp    80102374 <kfree+0x44>
    panic("kfree");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 e6 7c 10 80       	push   $0x80107ce6
801023ba:	e8 d1 df ff ff       	call   80100390 <panic>
801023bf:	90                   	nop

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023f7:	50                   	push   %eax
801023f8:	e8 33 ff ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	39 f3                	cmp    %esi,%ebx
80102402:	76 e4                	jbe    801023e8 <freerange+0x28>
}
80102404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102407:	5b                   	pop    %ebx
80102408:	5e                   	pop    %esi
80102409:	5d                   	pop    %ebp
8010240a:	c3                   	ret    
8010240b:	90                   	nop
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	68 ec 7c 10 80       	push   $0x80107cec
80102420:	68 40 36 11 80       	push   $0x80113640
80102425:	e8 c6 28 00 00       	call   80104cf0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102430:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102437:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102440:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102446:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244c:	39 de                	cmp    %ebx,%esi
8010244e:	72 1c                	jb     8010246c <kinit1+0x5c>
    kfree(p);
80102450:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102456:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102459:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010245f:	50                   	push   %eax
80102460:	e8 cb fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102465:	83 c4 10             	add    $0x10,%esp
80102468:	39 de                	cmp    %ebx,%esi
8010246a:	73 e4                	jae    80102450 <kinit1+0x40>
}
8010246c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010246f:	5b                   	pop    %ebx
80102470:	5e                   	pop    %esi
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <kinit2+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 73 fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 e4                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024c4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024cb:	00 00 00 
}
801024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
801024d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024e0:	a1 74 36 11 80       	mov    0x80113674,%eax
801024e5:	85 c0                	test   %eax,%eax
801024e7:	75 1f                	jne    80102508 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e9:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801024ee:	85 c0                	test   %eax,%eax
801024f0:	74 0e                	je     80102500 <kalloc+0x20>
    kmem.freelist = r->next;
801024f2:	8b 10                	mov    (%eax),%edx
801024f4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801024fa:	c3                   	ret    
801024fb:	90                   	nop
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102500:	f3 c3                	repz ret 
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010250e:	68 40 36 11 80       	push   $0x80113640
80102513:	e8 18 29 00 00       	call   80104e30 <acquire>
  r = kmem.freelist;
80102518:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102526:	85 c0                	test   %eax,%eax
80102528:	74 08                	je     80102532 <kalloc+0x52>
    kmem.freelist = r->next;
8010252a:	8b 08                	mov    (%eax),%ecx
8010252c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102532:	85 d2                	test   %edx,%edx
80102534:	74 16                	je     8010254c <kalloc+0x6c>
    release(&kmem.lock);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010253c:	68 40 36 11 80       	push   $0x80113640
80102541:	e8 aa 29 00 00       	call   80104ef0 <release>
  return (char*)r;
80102546:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102549:	83 c4 10             	add    $0x10,%esp
}
8010254c:	c9                   	leave  
8010254d:	c3                   	ret    
8010254e:	66 90                	xchg   %ax,%ax

80102550 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102550:	ba 64 00 00 00       	mov    $0x64,%edx
80102555:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102556:	a8 01                	test   $0x1,%al
80102558:	0f 84 c2 00 00 00    	je     80102620 <kbdgetc+0xd0>
8010255e:	ba 60 00 00 00       	mov    $0x60,%edx
80102563:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102564:	0f b6 d0             	movzbl %al,%edx
80102567:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010256d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102573:	0f 84 7f 00 00 00    	je     801025f8 <kbdgetc+0xa8>
{
80102579:	55                   	push   %ebp
8010257a:	89 e5                	mov    %esp,%ebp
8010257c:	53                   	push   %ebx
8010257d:	89 cb                	mov    %ecx,%ebx
8010257f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102582:	84 c0                	test   %al,%al
80102584:	78 4a                	js     801025d0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102586:	85 db                	test   %ebx,%ebx
80102588:	74 09                	je     80102593 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010258d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102590:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102593:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
8010259a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010259c:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
801025a3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025a7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025ad:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025b0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b3:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
801025ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025be:	74 31                	je     801025f1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c3:	83 fa 19             	cmp    $0x19,%edx
801025c6:	77 40                	ja     80102608 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025c8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025cb:	5b                   	pop    %ebx
801025cc:	5d                   	pop    %ebp
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025d0:	83 e0 7f             	and    $0x7f,%eax
801025d3:	85 db                	test   %ebx,%ebx
801025d5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025d8:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
801025df:	83 c8 40             	or     $0x40,%eax
801025e2:	0f b6 c0             	movzbl %al,%eax
801025e5:	f7 d0                	not    %eax
801025e7:	21 c1                	and    %eax,%ecx
    return 0;
801025e9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025eb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025f1:	5b                   	pop    %ebx
801025f2:	5d                   	pop    %ebp
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025f8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025fb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025fd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102608:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010260b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010260e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010260f:	83 f9 1a             	cmp    $0x1a,%ecx
80102612:	0f 42 c2             	cmovb  %edx,%eax
}
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	89 f6                	mov    %esi,%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102625:	c3                   	ret    
80102626:	8d 76 00             	lea    0x0(%esi),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kbdintr>:

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102636:	68 50 25 10 80       	push   $0x80102550
8010263b:	e8 d0 e1 ff ff       	call   80100810 <consoleintr>
}
80102640:	83 c4 10             	add    $0x10,%esp
80102643:	c9                   	leave  
80102644:	c3                   	ret    
80102645:	66 90                	xchg   %ax,%ax
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102650:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102658:	85 c0                	test   %eax,%eax
8010265a:	0f 84 c8 00 00 00    	je     80102728 <lapicinit+0xd8>
  lapic[index] = value;
80102660:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102667:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102681:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102687:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010268e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102694:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010269b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ae:	8b 50 30             	mov    0x30(%eax),%edx
801026b1:	c1 ea 10             	shr    $0x10,%edx
801026b4:	80 fa 03             	cmp    $0x3,%dl
801026b7:	77 77                	ja     80102730 <lapicinit+0xe0>
  lapic[index] = value;
801026b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102701:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102710:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102716:	80 e6 10             	and    $0x10,%dh
80102719:	75 f5                	jne    80102710 <lapicinit+0xc0>
  lapic[index] = value;
8010271b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102722:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102725:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102730:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102737:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
8010273d:	e9 77 ff ff ff       	jmp    801026b9 <lapicinit+0x69>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102750:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102756:	55                   	push   %ebp
80102757:	31 c0                	xor    %eax,%eax
80102759:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010275b:	85 d2                	test   %edx,%edx
8010275d:	74 06                	je     80102765 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010275f:	8b 42 20             	mov    0x20(%edx),%eax
80102762:	c1 e8 18             	shr    $0x18,%eax
}
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027a6:	ba 70 00 00 00       	mov    $0x70,%edx
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	ba 71 00 00 00       	mov    $0x71,%edx
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027d3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027de:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	b8 0b 00 00 00       	mov    $0xb,%eax
80102836:	ba 70 00 00 00       	mov    $0x70,%edx
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102852:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102855:	8d 76 00             	lea    0x0(%esi),%esi
80102858:	31 c0                	xor    %eax,%eax
8010285a:	89 da                	mov    %ebx,%edx
8010285c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102862:	89 ca                	mov    %ecx,%edx
80102864:	ec                   	in     (%dx),%al
80102865:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	89 da                	mov    %ebx,%edx
8010286a:	b8 02 00 00 00       	mov    $0x2,%eax
8010286f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
80102873:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102876:	89 da                	mov    %ebx,%edx
80102878:	b8 04 00 00 00       	mov    $0x4,%eax
8010287d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287e:	89 ca                	mov    %ecx,%edx
80102880:	ec                   	in     (%dx),%al
80102881:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	89 da                	mov    %ebx,%edx
80102886:	b8 07 00 00 00       	mov    $0x7,%eax
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
8010288f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 da                	mov    %ebx,%edx
80102894:	b8 08 00 00 00       	mov    $0x8,%eax
80102899:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
8010289d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289f:	89 da                	mov    %ebx,%edx
801028a1:	b8 09 00 00 00       	mov    $0x9,%eax
801028a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a7:	89 ca                	mov    %ecx,%edx
801028a9:	ec                   	in     (%dx),%al
801028aa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	b8 0a 00 00 00       	mov    $0xa,%eax
801028b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b4:	89 ca                	mov    %ecx,%edx
801028b6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b7:	84 c0                	test   %al,%al
801028b9:	78 9d                	js     80102858 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028bb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028bf:	89 fa                	mov    %edi,%edx
801028c1:	0f b6 fa             	movzbl %dl,%edi
801028c4:	89 f2                	mov    %esi,%edx
801028c6:	0f b6 f2             	movzbl %dl,%esi
801028c9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028d4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028db:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028e2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028e9:	31 c0                	xor    %eax,%eax
801028eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
801028ef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 da                	mov    %ebx,%edx
801028f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028f7:	b8 02 00 00 00       	mov    $0x2,%eax
801028fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fd:	89 ca                	mov    %ecx,%edx
801028ff:	ec                   	in     (%dx),%al
80102900:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102903:	89 da                	mov    %ebx,%edx
80102905:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102908:	b8 04 00 00 00       	mov    $0x4,%eax
8010290d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290e:	89 ca                	mov    %ecx,%edx
80102910:	ec                   	in     (%dx),%al
80102911:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	89 da                	mov    %ebx,%edx
80102916:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102919:	b8 07 00 00 00       	mov    $0x7,%eax
8010291e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291f:	89 ca                	mov    %ecx,%edx
80102921:	ec                   	in     (%dx),%al
80102922:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102925:	89 da                	mov    %ebx,%edx
80102927:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010292a:	b8 08 00 00 00       	mov    $0x8,%eax
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
80102933:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 da                	mov    %ebx,%edx
80102938:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010293b:	b8 09 00 00 00       	mov    $0x9,%eax
80102940:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102941:	89 ca                	mov    %ecx,%edx
80102943:	ec                   	in     (%dx),%al
80102944:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102947:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010294a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102950:	6a 18                	push   $0x18
80102952:	50                   	push   %eax
80102953:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102956:	50                   	push   %eax
80102957:	e8 34 26 00 00       	call   80104f90 <memcmp>
8010295c:	83 c4 10             	add    $0x10,%esp
8010295f:	85 c0                	test   %eax,%eax
80102961:	0f 85 f1 fe ff ff    	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102967:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010296b:	75 78                	jne    801029e5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	83 e0 0f             	and    $0xf,%eax
80102975:	c1 ea 04             	shr    $0x4,%edx
80102978:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102981:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	83 e0 0f             	and    $0xf,%eax
80102989:	c1 ea 04             	shr    $0x4,%edx
8010298c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102992:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102995:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102998:	89 c2                	mov    %eax,%edx
8010299a:	83 e0 0f             	and    $0xf,%eax
8010299d:	c1 ea 04             	shr    $0x4,%edx
801029a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ac:	89 c2                	mov    %eax,%edx
801029ae:	83 e0 0f             	and    $0xf,%eax
801029b1:	c1 ea 04             	shr    $0x4,%edx
801029b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c0:	89 c2                	mov    %eax,%edx
801029c2:	83 e0 0f             	and    $0xf,%eax
801029c5:	c1 ea 04             	shr    $0x4,%edx
801029c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d4:	89 c2                	mov    %eax,%edx
801029d6:	83 e0 0f             	and    $0xf,%eax
801029d9:	c1 ea 04             	shr    $0x4,%edx
801029dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e5:	8b 75 08             	mov    0x8(%ebp),%esi
801029e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029eb:	89 06                	mov    %eax,(%esi)
801029ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029f0:	89 46 04             	mov    %eax,0x4(%esi)
801029f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f6:	89 46 08             	mov    %eax,0x8(%esi)
801029f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fc:	89 46 0c             	mov    %eax,0xc(%esi)
801029ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a02:	89 46 10             	mov    %eax,0x10(%esi)
80102a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a15:	5b                   	pop    %ebx
80102a16:	5e                   	pop    %esi
80102a17:	5f                   	pop    %edi
80102a18:	5d                   	pop    %ebp
80102a19:	c3                   	ret    
80102a1a:	66 90                	xchg   %ax,%ax
80102a1c:	66 90                	xchg   %ax,%ax
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a20:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102a26:	85 c9                	test   %ecx,%ecx
80102a28:	0f 8e 8a 00 00 00    	jle    80102ab8 <install_trans+0x98>
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	57                   	push   %edi
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a34:	31 db                	xor    %ebx,%ebx
{
80102a36:	83 ec 0c             	sub    $0xc,%esp
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a45:	83 ec 08             	sub    $0x8,%esp
80102a48:	01 d8                	add    %ebx,%eax
80102a4a:	83 c0 01             	add    $0x1,%eax
80102a4d:	50                   	push   %eax
80102a4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a54:	e8 77 d6 ff ff       	call   801000d0 <bread>
80102a59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5b:	58                   	pop    %eax
80102a5c:	5a                   	pop    %edx
80102a5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102a64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6d:	e8 5e d6 ff ff       	call   801000d0 <bread>
80102a72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a77:	83 c4 0c             	add    $0xc,%esp
80102a7a:	68 00 02 00 00       	push   $0x200
80102a7f:	50                   	push   %eax
80102a80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a83:	50                   	push   %eax
80102a84:	e8 67 25 00 00       	call   80104ff0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 0f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a91:	89 3c 24             	mov    %edi,(%esp)
80102a94:	e8 47 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 3f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102aaa:	7f 94                	jg     80102a40 <install_trans+0x20>
  }
}
80102aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	c3                   	ret    
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ab8:	f3 c3                	repz ret 
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ac5:	83 ec 08             	sub    $0x8,%esp
80102ac8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ace:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ad4:	e8 f7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102adf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ae6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	7e 16                	jle    80102b01 <write_head+0x41>
80102aeb:	c1 e3 02             	shl    $0x2,%ebx
80102aee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102af0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102af6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102afa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102afd:	39 da                	cmp    %ebx,%edx
80102aff:	75 ef                	jne    80102af0 <write_head+0x30>
  }
  bwrite(buf);
80102b01:	83 ec 0c             	sub    $0xc,%esp
80102b04:	56                   	push   %esi
80102b05:	e8 96 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b0a:	89 34 24             	mov    %esi,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>
}
80102b12:	83 c4 10             	add    $0x10,%esp
80102b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b18:	5b                   	pop    %ebx
80102b19:	5e                   	pop    %esi
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <initlog>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 2c             	sub    $0x2c,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b2a:	68 20 7f 10 80       	push   $0x80107f20
80102b2f:	68 80 36 11 80       	push   $0x80113680
80102b34:	e8 b7 21 00 00       	call   80104cf0 <initlock>
  readsb(dev, &sb);
80102b39:	58                   	pop    %eax
80102b3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 1b e9 ff ff       	call   80101460 <readsb>
  log.size = sb.nlog;
80102b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b4b:	59                   	pop    %ecx
  log.dev = dev;
80102b4c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b52:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b58:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 6b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b6d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b73:	7e 1c                	jle    80102b91 <initlog+0x71>
80102b75:	c1 e3 02             	shl    $0x2,%ebx
80102b78:	31 d2                	xor    %edx,%edx
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b84:	83 c2 04             	add    $0x4,%edx
80102b87:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b8d:	39 d3                	cmp    %edx,%ebx
80102b8f:	75 ef                	jne    80102b80 <initlog+0x60>
  brelse(buf);
80102b91:	83 ec 0c             	sub    $0xc,%esp
80102b94:	50                   	push   %eax
80102b95:	e8 46 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b9a:	e8 81 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102b9f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ba6:	00 00 00 
  write_head(); // clear the log
80102ba9:	e8 12 ff ff ff       	call   80102ac0 <write_head>
}
80102bae:	83 c4 10             	add    $0x10,%esp
80102bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bc6:	68 80 36 11 80       	push   $0x80113680
80102bcb:	e8 60 22 00 00       	call   80104e30 <acquire>
80102bd0:	83 c4 10             	add    $0x10,%esp
80102bd3:	eb 18                	jmp    80102bed <begin_op+0x2d>
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bd8:	83 ec 08             	sub    $0x8,%esp
80102bdb:	68 80 36 11 80       	push   $0x80113680
80102be0:	68 80 36 11 80       	push   $0x80113680
80102be5:	e8 b6 15 00 00       	call   801041a0 <sleep>
80102bea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bed:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 e2                	jne    80102bd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bf6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102bfb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102c01:	83 c0 01             	add    $0x1,%eax
80102c04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c0a:	83 fa 1e             	cmp    $0x1e,%edx
80102c0d:	7f c9                	jg     80102bd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c12:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c17:	68 80 36 11 80       	push   $0x80113680
80102c1c:	e8 cf 22 00 00       	call   80104ef0 <release>
      break;
    }
  }
}
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	c9                   	leave  
80102c25:	c3                   	ret    
80102c26:	8d 76 00             	lea    0x0(%esi),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	57                   	push   %edi
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c39:	68 80 36 11 80       	push   $0x80113680
80102c3e:	e8 ed 21 00 00       	call   80104e30 <acquire>
  log.outstanding -= 1;
80102c43:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c48:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c54:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c56:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102c5c:	0f 85 1a 01 00 00    	jne    80102d7c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c62:	85 db                	test   %ebx,%ebx
80102c64:	0f 85 ee 00 00 00    	jne    80102d58 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c6a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c6d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c74:	00 00 00 
  release(&log.lock);
80102c77:	68 80 36 11 80       	push   $0x80113680
80102c7c:	e8 6f 22 00 00       	call   80104ef0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c81:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c87:	83 c4 10             	add    $0x10,%esp
80102c8a:	85 c9                	test   %ecx,%ecx
80102c8c:	0f 8e 85 00 00 00    	jle    80102d17 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c92:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c97:	83 ec 08             	sub    $0x8,%esp
80102c9a:	01 d8                	add    %ebx,%eax
80102c9c:	83 c0 01             	add    $0x1,%eax
80102c9f:	50                   	push   %eax
80102ca0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ca6:	e8 25 d4 ff ff       	call   801000d0 <bread>
80102cab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cad:	58                   	pop    %eax
80102cae:	5a                   	pop    %edx
80102caf:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cb6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbf:	e8 0c d4 ff ff       	call   801000d0 <bread>
80102cc4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cc6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cc9:	83 c4 0c             	add    $0xc,%esp
80102ccc:	68 00 02 00 00       	push   $0x200
80102cd1:	50                   	push   %eax
80102cd2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd5:	50                   	push   %eax
80102cd6:	e8 15 23 00 00       	call   80104ff0 <memmove>
    bwrite(to);  // write the log
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 bd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ce3:	89 3c 24             	mov    %edi,(%esp)
80102ce6:	e8 f5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ed d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf3:	83 c4 10             	add    $0x10,%esp
80102cf6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102cfc:	7c 94                	jl     80102c92 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cfe:	e8 bd fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d03:	e8 18 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d08:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d0f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d12:	e8 a9 fd ff ff       	call   80102ac0 <write_head>
    acquire(&log.lock);
80102d17:	83 ec 0c             	sub    $0xc,%esp
80102d1a:	68 80 36 11 80       	push   $0x80113680
80102d1f:	e8 0c 21 00 00       	call   80104e30 <acquire>
    wakeup(&log);
80102d24:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d2b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d32:	00 00 00 
    wakeup(&log);
80102d35:	e8 26 16 00 00       	call   80104360 <wakeup>
    release(&log.lock);
80102d3a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d41:	e8 aa 21 00 00       	call   80104ef0 <release>
80102d46:	83 c4 10             	add    $0x10,%esp
}
80102d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d4c:	5b                   	pop    %ebx
80102d4d:	5e                   	pop    %esi
80102d4e:	5f                   	pop    %edi
80102d4f:	5d                   	pop    %ebp
80102d50:	c3                   	ret    
80102d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d58:	83 ec 0c             	sub    $0xc,%esp
80102d5b:	68 80 36 11 80       	push   $0x80113680
80102d60:	e8 fb 15 00 00       	call   80104360 <wakeup>
  release(&log.lock);
80102d65:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d6c:	e8 7f 21 00 00       	call   80104ef0 <release>
80102d71:	83 c4 10             	add    $0x10,%esp
}
80102d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d77:	5b                   	pop    %ebx
80102d78:	5e                   	pop    %esi
80102d79:	5f                   	pop    %edi
80102d7a:	5d                   	pop    %ebp
80102d7b:	c3                   	ret    
    panic("log.committing");
80102d7c:	83 ec 0c             	sub    $0xc,%esp
80102d7f:	68 24 7f 10 80       	push   $0x80107f24
80102d84:	e8 07 d6 ff ff       	call   80100390 <panic>
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 9d 00 00 00    	jg     80102e46 <log_write+0xb6>
80102da9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 8d 00 00 00    	jge    80102e46 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 8d 00 00 00    	jle    80102e53 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 80 36 11 80       	push   $0x80113680
80102dce:	e8 5d 20 00 00       	call   80104e30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 f9 00             	cmp    $0x0,%ecx
80102ddf:	7e 57                	jle    80102e38 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 c1                	cmp    %eax,%ecx
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c0 01             	add    $0x1,%eax
80102e0a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e0f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e12:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1c:	c9                   	leave  
  release(&log.lock);
80102e1d:	e9 ce 20 00 00       	jmp    80104ef0 <release>
80102e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e28:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e2f:	eb de                	jmp    80102e0f <log_write+0x7f>
80102e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e38:	8b 43 08             	mov    0x8(%ebx),%eax
80102e3b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e40:	75 cd                	jne    80102e0f <log_write+0x7f>
80102e42:	31 c0                	xor    %eax,%eax
80102e44:	eb c1                	jmp    80102e07 <log_write+0x77>
    panic("too big a transaction");
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 33 7f 10 80       	push   $0x80107f33
80102e4e:	e8 3d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e53:	83 ec 0c             	sub    $0xc,%esp
80102e56:	68 49 7f 10 80       	push   $0x80107f49
80102e5b:	e8 30 d5 ff ff       	call   80100390 <panic>

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e67:	e8 e4 0a 00 00       	call   80103950 <cpuid>
80102e6c:	89 c3                	mov    %eax,%ebx
80102e6e:	e8 dd 0a 00 00       	call   80103950 <cpuid>
80102e73:	83 ec 04             	sub    $0x4,%esp
80102e76:	53                   	push   %ebx
80102e77:	50                   	push   %eax
80102e78:	68 64 7f 10 80       	push   $0x80107f64
80102e7d:	e8 de d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e82:	e8 09 34 00 00       	call   80106290 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e87:	e8 74 0a 00 00       	call   80103900 <mycpu>
80102e8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e9a:	e8 11 0f 00 00       	call   80103db0 <scheduler>
80102e9f:	90                   	nop

80102ea0 <mpenter>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 d5 44 00 00       	call   80107380 <switchkvm>
  seginit();
80102eab:	e8 40 44 00 00       	call   801072f0 <seginit>
  lapicinit();
80102eb0:	e8 9b f7 ff ff       	call   80102650 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ecf:	83 ec 08             	sub    $0x8,%esp
80102ed2:	68 00 00 40 80       	push   $0x80400000
80102ed7:	68 c8 64 11 80       	push   $0x801164c8
80102edc:	e8 2f f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102ee1:	e8 6a 49 00 00       	call   80107850 <kvmalloc>
  mpinit();        // detect other processors
80102ee6:	e8 75 01 00 00       	call   80103060 <mpinit>
  lapicinit();     // interrupt controller
80102eeb:	e8 60 f7 ff ff       	call   80102650 <lapicinit>
  seginit();       // segment descriptors
80102ef0:	e8 fb 43 00 00       	call   801072f0 <seginit>
  picinit();       // disable pic
80102ef5:	e8 36 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102efa:	e8 41 f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102eff:	e8 bc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f04:	e8 b7 36 00 00       	call   801065c0 <uartinit>
  pinit();         // process table
80102f09:	e8 d2 09 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
80102f0e:	e8 fd 32 00 00       	call   80106210 <tvinit>
  binit();         // buffer cache
80102f13:	e8 28 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f18:	e8 63 de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102f1d:	e8 fe f0 ff ff       	call   80102020 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f22:	83 c4 0c             	add    $0xc,%esp
80102f25:	68 8a 00 00 00       	push   $0x8a
80102f2a:	68 8c b4 10 80       	push   $0x8010b48c
80102f2f:	68 00 70 00 80       	push   $0x80007000
80102f34:	e8 b7 20 00 00       	call   80104ff0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f39:	69 05 30 38 11 80 b0 	imul   $0xb0,0x80113830,%eax
80102f40:	00 00 00 
80102f43:	83 c4 10             	add    $0x10,%esp
80102f46:	05 80 37 11 80       	add    $0x80113780,%eax
80102f4b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f50:	76 71                	jbe    80102fc3 <main+0x103>
80102f52:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f57:	89 f6                	mov    %esi,%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f60:	e8 9b 09 00 00       	call   80103900 <mycpu>
80102f65:	39 d8                	cmp    %ebx,%eax
80102f67:	74 41                	je     80102faa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f69:	e8 72 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f6e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f73:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102f7a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f7d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f84:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f87:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f8c:	0f b6 03             	movzbl (%ebx),%eax
80102f8f:	83 ec 08             	sub    $0x8,%esp
80102f92:	68 00 70 00 00       	push   $0x7000
80102f97:	50                   	push   %eax
80102f98:	e8 03 f8 ff ff       	call   801027a0 <lapicstartap>
80102f9d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fa0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 f6                	je     80102fa0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102faa:	69 05 30 38 11 80 b0 	imul   $0xb0,0x80113830,%eax
80102fb1:	00 00 00 
80102fb4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fba:	05 80 37 11 80       	add    $0x80113780,%eax
80102fbf:	39 c3                	cmp    %eax,%ebx
80102fc1:	72 9d                	jb     80102f60 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fc3:	83 ec 08             	sub    $0x8,%esp
80102fc6:	68 00 00 00 8e       	push   $0x8e000000
80102fcb:	68 00 00 40 80       	push   $0x80400000
80102fd0:	e8 ab f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102fd5:	e8 c6 09 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
80102fda:	e8 81 fe ff ff       	call   80102e60 <mpmain>
80102fdf:	90                   	nop

80102fe0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fe5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102feb:	53                   	push   %ebx
  e = addr+len;
80102fec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff2:	39 de                	cmp    %ebx,%esi
80102ff4:	72 10                	jb     80103006 <mpsearch1+0x26>
80102ff6:	eb 50                	jmp    80103048 <mpsearch1+0x68>
80102ff8:	90                   	nop
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103000:	39 fb                	cmp    %edi,%ebx
80103002:	89 fe                	mov    %edi,%esi
80103004:	76 42                	jbe    80103048 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103006:	83 ec 04             	sub    $0x4,%esp
80103009:	8d 7e 10             	lea    0x10(%esi),%edi
8010300c:	6a 04                	push   $0x4
8010300e:	68 78 7f 10 80       	push   $0x80107f78
80103013:	56                   	push   %esi
80103014:	e8 77 1f 00 00       	call   80104f90 <memcmp>
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	85 c0                	test   %eax,%eax
8010301e:	75 e0                	jne    80103000 <mpsearch1+0x20>
80103020:	89 f1                	mov    %esi,%ecx
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103028:	0f b6 11             	movzbl (%ecx),%edx
8010302b:	83 c1 01             	add    $0x1,%ecx
8010302e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103030:	39 f9                	cmp    %edi,%ecx
80103032:	75 f4                	jne    80103028 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103034:	84 c0                	test   %al,%al
80103036:	75 c8                	jne    80103000 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303b:	89 f0                	mov    %esi,%eax
8010303d:	5b                   	pop    %ebx
8010303e:	5e                   	pop    %esi
8010303f:	5f                   	pop    %edi
80103040:	5d                   	pop    %ebp
80103041:	c3                   	ret    
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010304b:	31 f6                	xor    %esi,%esi
}
8010304d:	89 f0                	mov    %esi,%eax
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret    
80103054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010305a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103060 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103069:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103070:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103077:	c1 e0 08             	shl    $0x8,%eax
8010307a:	09 d0                	or     %edx,%eax
8010307c:	c1 e0 04             	shl    $0x4,%eax
8010307f:	85 c0                	test   %eax,%eax
80103081:	75 1b                	jne    8010309e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103083:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010308a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103091:	c1 e0 08             	shl    $0x8,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103099:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010309e:	ba 00 04 00 00       	mov    $0x400,%edx
801030a3:	e8 38 ff ff ff       	call   80102fe0 <mpsearch1>
801030a8:	85 c0                	test   %eax,%eax
801030aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030ad:	0f 84 35 01 00 00    	je     801031e8 <mpinit+0x188>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030b6:	8b 58 04             	mov    0x4(%eax),%ebx
801030b9:	85 db                	test   %ebx,%ebx
801030bb:	0f 84 47 01 00 00    	je     80103208 <mpinit+0x1a8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030c7:	83 ec 04             	sub    $0x4,%esp
801030ca:	6a 04                	push   $0x4
801030cc:	68 95 7f 10 80       	push   $0x80107f95
801030d1:	56                   	push   %esi
801030d2:	e8 b9 1e 00 00       	call   80104f90 <memcmp>
801030d7:	83 c4 10             	add    $0x10,%esp
801030da:	85 c0                	test   %eax,%eax
801030dc:	0f 85 26 01 00 00    	jne    80103208 <mpinit+0x1a8>
  if(conf->version != 1 && conf->version != 4)
801030e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030e9:	3c 01                	cmp    $0x1,%al
801030eb:	0f 95 c2             	setne  %dl
801030ee:	3c 04                	cmp    $0x4,%al
801030f0:	0f 95 c0             	setne  %al
801030f3:	20 c2                	and    %al,%dl
801030f5:	0f 85 0d 01 00 00    	jne    80103208 <mpinit+0x1a8>
  if(sum((uchar*)conf, conf->length) != 0)
801030fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103102:	66 85 ff             	test   %di,%di
80103105:	74 1a                	je     80103121 <mpinit+0xc1>
80103107:	89 f0                	mov    %esi,%eax
80103109:	01 f7                	add    %esi,%edi
  sum = 0;
8010310b:	31 d2                	xor    %edx,%edx
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103110:	0f b6 08             	movzbl (%eax),%ecx
80103113:	83 c0 01             	add    $0x1,%eax
80103116:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103118:	39 c7                	cmp    %eax,%edi
8010311a:	75 f4                	jne    80103110 <mpinit+0xb0>
8010311c:	84 d2                	test   %dl,%dl
8010311e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103121:	85 f6                	test   %esi,%esi
80103123:	0f 84 df 00 00 00    	je     80103208 <mpinit+0x1a8>
80103129:	84 d2                	test   %dl,%dl
8010312b:	0f 85 d7 00 00 00    	jne    80103208 <mpinit+0x1a8>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103131:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103137:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103143:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103149:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314e:	01 d6                	add    %edx,%esi
80103150:	39 c6                	cmp    %eax,%esi
80103152:	76 23                	jbe    80103177 <mpinit+0x117>
    switch(*p){
80103154:	0f b6 10             	movzbl (%eax),%edx
80103157:	80 fa 04             	cmp    $0x4,%dl
8010315a:	0f 87 c2 00 00 00    	ja     80103222 <mpinit+0x1c2>
80103160:	ff 24 95 bc 7f 10 80 	jmp    *-0x7fef8044(,%edx,4)
80103167:	89 f6                	mov    %esi,%esi
80103169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103170:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103173:	39 c6                	cmp    %eax,%esi
80103175:	77 dd                	ja     80103154 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103177:	85 db                	test   %ebx,%ebx
80103179:	0f 84 96 00 00 00    	je     80103215 <mpinit+0x1b5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103182:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103186:	74 15                	je     8010319d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103188:	b8 70 00 00 00       	mov    $0x70,%eax
8010318d:	ba 22 00 00 00       	mov    $0x22,%edx
80103192:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103193:	ba 23 00 00 00       	mov    $0x23,%edx
80103198:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103199:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319c:	ee                   	out    %al,(%dx)
  }
}
8010319d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a0:	5b                   	pop    %ebx
801031a1:	5e                   	pop    %esi
801031a2:	5f                   	pop    %edi
801031a3:	5d                   	pop    %ebp
801031a4:	c3                   	ret    
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031a8:	8b 0d 30 38 11 80    	mov    0x80113830,%ecx
801031ae:	85 c9                	test   %ecx,%ecx
801031b0:	7f 19                	jg     801031cb <mpinit+0x16b>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b2:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031b6:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031bc:	83 c1 01             	add    $0x1,%ecx
801031bf:	89 0d 30 38 11 80    	mov    %ecx,0x80113830
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c5:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801031cb:	83 c0 14             	add    $0x14,%eax
      continue;
801031ce:	eb 80                	jmp    80103150 <mpinit+0xf0>
      ioapicid = ioapic->apicno;
801031d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031d7:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
801031dd:	e9 6e ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e8:	ba 00 00 01 00       	mov    $0x10000,%edx
801031ed:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031f2:	e8 e9 fd ff ff       	call   80102fe0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f7:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031fc:	0f 85 b1 fe ff ff    	jne    801030b3 <mpinit+0x53>
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103208:	83 ec 0c             	sub    $0xc,%esp
8010320b:	68 7d 7f 10 80       	push   $0x80107f7d
80103210:	e8 7b d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103215:	83 ec 0c             	sub    $0xc,%esp
80103218:	68 9c 7f 10 80       	push   $0x80107f9c
8010321d:	e8 6e d1 ff ff       	call   80100390 <panic>
      ismp = 0;
80103222:	31 db                	xor    %ebx,%ebx
80103224:	e9 2e ff ff ff       	jmp    80103157 <mpinit+0xf7>
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 30 db ff ff       	call   80100da0 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 25 db ff ff       	call   80100da0 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 5a f2 ff ff       	call   801024e0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 b9 db ff ff       	call   80100e60 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 91 db ff ff       	call   80100e60 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 d0 7f 10 80       	push   $0x80107fd0
80103310:	50                   	push   %eax
80103311:	e8 da 19 00 00       	call   80104cf0 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 bc 1a 00 00       	call   80104e30 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 cc 0f 00 00       	call   80104360 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 37 1b 00 00       	jmp    80104ef0 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 87 0f 00 00       	call   80104360 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 07 1b 00 00       	call   80104ef0 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 36 ef ff ff       	jmp    80102330 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 1e 1a 00 00       	call   80104e30 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 f7 0e 00 00       	call   80104360 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 2e 0d 00 00       	call   801041a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 d7 04 00 00       	call   80103970 <myproc>
80103499:	8b 40 24             	mov    0x24(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 47 1a 00 00       	call   80104ef0 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 68 0e 00 00       	call   80104360 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 f0 19 00 00       	call   80104ef0 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 0b 19 00 00       	call   80104e30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 46 0c 00 00       	call   801041a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
80103579:	e8 f2 03 00 00       	call   80103970 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 5d 19 00 00       	call   80104ef0 <release>
      return -1;
80103593:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 74 0d 00 00       	call   80104360 <wakeup>
  release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 fc 18 00 00       	call   80104ef0 <release>
  return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb 74 38 11 80       	mov    $0x80113874,%ebx
{
80103619:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010361c:	68 40 38 11 80       	push   $0x80113840
80103621:	e8 0a 18 00 00       	call   80104e30 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 17                	jmp    80103642 <allocproc+0x32>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103636:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
8010363c:	0f 83 9e 00 00 00    	jae    801036e0 <allocproc+0xd0>
    if(p->state == UNUSED)
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103649:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->ticket = 10;
  p->ticks = ticks;
  p->queueNum = 0;
  p->cycleNum = 1;
  release(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103651:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->ticket = 10;
80103658:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->queueNum = 0;
8010365f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103666:	00 00 00 
  p->cycleNum = 1;
80103669:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80103670:	00 00 00 
  p->pid = nextpid++;
80103673:	8d 50 01             	lea    0x1(%eax),%edx
80103676:	89 43 10             	mov    %eax,0x10(%ebx)
  p->ticks = ticks;
80103679:	a1 c0 64 11 80       	mov    0x801164c0,%eax
  p->pid = nextpid++;
8010367e:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->ticks = ticks;
80103684:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  release(&ptable.lock);
8010368a:	68 40 38 11 80       	push   $0x80113840
8010368f:	e8 5c 18 00 00       	call   80104ef0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103694:	e8 47 ee ff ff       	call   801024e0 <kalloc>
80103699:	83 c4 10             	add    $0x10,%esp
8010369c:	85 c0                	test   %eax,%eax
8010369e:	89 43 08             	mov    %eax,0x8(%ebx)
801036a1:	74 56                	je     801036f9 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a3:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036a9:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036ac:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036b1:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036b4:	c7 40 14 01 62 10 80 	movl   $0x80106201,0x14(%eax)
  p->context = (struct context*)sp;
801036bb:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036be:	6a 14                	push   $0x14
801036c0:	6a 00                	push   $0x0
801036c2:	50                   	push   %eax
801036c3:	e8 78 18 00 00       	call   80104f40 <memset>
  p->context->eip = (uint)forkret;
801036c8:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036cb:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036ce:	c7 40 10 10 37 10 80 	movl   $0x80103710,0x10(%eax)
}
801036d5:	89 d8                	mov    %ebx,%eax
801036d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036da:	c9                   	leave  
801036db:	c3                   	ret    
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036e5:	68 40 38 11 80       	push   $0x80113840
801036ea:	e8 01 18 00 00       	call   80104ef0 <release>
}
801036ef:	89 d8                	mov    %ebx,%eax
  return 0;
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036f7:	c9                   	leave  
801036f8:	c3                   	ret    
    p->state = UNUSED;
801036f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103700:	31 db                	xor    %ebx,%ebx
80103702:	eb d1                	jmp    801036d5 <allocproc+0xc5>
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
80103716:	68 40 38 11 80       	push   $0x80113840
8010371b:	e8 d0 17 00 00       	call   80104ef0 <release>

  if (first) {
80103720:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80103733:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010373a:	00 00 00 
    iinit(ROOTDEV);
8010373d:	6a 01                	push   $0x1
8010373f:	e8 5c dd ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
80103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010374b:	e8 d0 f3 ff ff       	call   80102b20 <initlog>
80103750:	83 c4 10             	add    $0x10,%esp
}
80103753:	c9                   	leave  
80103754:	c3                   	ret    
80103755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <findRunnableProcLottery.part.1>:
int findRunnableProcLottery (struct proc * queue0[], int q0Index){
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
80103765:	53                   	push   %ebx
80103766:	89 c6                	mov    %eax,%esi
80103768:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < q0Index; i++) {
8010376b:	85 d2                	test   %edx,%edx
8010376d:	0f 8e 8d 00 00 00    	jle    80103800 <findRunnableProcLottery.part.1+0xa0>
80103773:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  int ticketNums = 0;
80103776:	31 d2                	xor    %edx,%edx
80103778:	90                   	nop
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ticketNums += queue0[i]->ticket;
80103780:	8b 08                	mov    (%eax),%ecx
80103782:	83 c0 04             	add    $0x4,%eax
80103785:	03 51 7c             	add    0x7c(%ecx),%edx
  for (int i = 0; i < q0Index; i++) {
80103788:	39 c3                	cmp    %eax,%ebx
8010378a:	75 f4                	jne    80103780 <findRunnableProcLottery.part.1+0x20>
8010378c:	89 d7                	mov    %edx,%edi
  acquire(&tickslock);
8010378e:	83 ec 0c             	sub    $0xc,%esp
80103791:	68 80 5c 11 80       	push   $0x80115c80
80103796:	e8 95 16 00 00       	call   80104e30 <acquire>
  int randomNum = ticks % ticketNums;
8010379b:	a1 c0 64 11 80       	mov    0x801164c0,%eax
801037a0:	31 d2                	xor    %edx,%edx
  release(&tickslock);
801037a2:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
  int randomNum = ticks % ticketNums;
801037a9:	f7 f7                	div    %edi
801037ab:	89 d3                	mov    %edx,%ebx
  release(&tickslock);
801037ad:	e8 3e 17 00 00       	call   80104ef0 <release>
  cprintf("random num is : %d\n", randomNum);
801037b2:	58                   	pop    %eax
801037b3:	5a                   	pop    %edx
801037b4:	53                   	push   %ebx
801037b5:	68 d5 7f 10 80       	push   $0x80107fd5
801037ba:	e8 a1 ce ff ff       	call   80100660 <cprintf>
  while(randomNum > 0) {
801037bf:	83 c4 10             	add    $0x10,%esp
801037c2:	85 db                	test   %ebx,%ebx
801037c4:	7e 2a                	jle    801037f0 <findRunnableProcLottery.part.1+0x90>
  int i = 0;
801037c6:	31 c0                	xor    %eax,%eax
801037c8:	90                   	nop
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    randomNum -= queue0[i]->ticket;
801037d0:	8b 14 86             	mov    (%esi,%eax,4),%edx
    i++;
801037d3:	83 c0 01             	add    $0x1,%eax
    randomNum -= queue0[i]->ticket;
801037d6:	2b 5a 7c             	sub    0x7c(%edx),%ebx
  while(randomNum > 0) {
801037d9:	85 db                	test   %ebx,%ebx
801037db:	7f f3                	jg     801037d0 <findRunnableProcLottery.part.1+0x70>
  return queue0[i-1]->pid;
801037dd:	8b 44 86 fc          	mov    -0x4(%esi,%eax,4),%eax
801037e1:	8b 40 10             	mov    0x10(%eax),%eax
} 
801037e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e7:	5b                   	pop    %ebx
801037e8:	5e                   	pop    %esi
801037e9:	5f                   	pop    %edi
801037ea:	5d                   	pop    %ebp
801037eb:	c3                   	ret    
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return queue0[0]->pid;
801037f0:	8b 06                	mov    (%esi),%eax
801037f2:	8b 40 10             	mov    0x10(%eax),%eax
} 
801037f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f8:	5b                   	pop    %ebx
801037f9:	5e                   	pop    %esi
801037fa:	5f                   	pop    %edi
801037fb:	5d                   	pop    %ebp
801037fc:	c3                   	ret    
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = 0; i < q0Index; i++) {
80103800:	31 ff                	xor    %edi,%edi
80103802:	eb 8a                	jmp    8010378e <findRunnableProcLottery.part.1+0x2e>
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <itoa.part.3>:
    str[i] = str[len - i - 1];
    str[len - i - 1] = temp;
  }
}

char* itoa(int num, char* str) { 
80103810:	55                   	push   %ebp
80103811:	89 c1                	mov    %eax,%ecx
80103813:	89 e5                	mov    %esp,%ebp
80103815:	57                   	push   %edi
80103816:	56                   	push   %esi
80103817:	53                   	push   %ebx
80103818:	89 d3                	mov    %edx,%ebx
8010381a:	83 ec 04             	sub    $0x4,%esp
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 
  
    if (num < 0 && 10 == 10) { 
8010381d:	85 c0                	test   %eax,%eax
8010381f:	0f 88 9b 00 00 00    	js     801038c0 <itoa.part.3+0xb0>
    int isNegative = 0; 
80103825:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        isNegative = 1; 
        num = -num; 
    } 

    while (num != 0) { 
8010382c:	0f 84 9e 00 00 00    	je     801038d0 <itoa.part.3+0xc0>
    int isNegative = 0; 
80103832:	31 ff                	xor    %edi,%edi
80103834:	eb 0c                	jmp    80103842 <itoa.part.3+0x32>
80103836:	8d 76 00             	lea    0x0(%esi),%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        int rem = num % 10; 
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
80103840:	89 f7                	mov    %esi,%edi
        int rem = num % 10; 
80103842:	b8 67 66 66 66       	mov    $0x66666667,%eax
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
80103847:	8d 77 01             	lea    0x1(%edi),%esi
        int rem = num % 10; 
8010384a:	f7 e9                	imul   %ecx
8010384c:	89 c8                	mov    %ecx,%eax
8010384e:	c1 f8 1f             	sar    $0x1f,%eax
80103851:	c1 fa 02             	sar    $0x2,%edx
80103854:	29 c2                	sub    %eax,%edx
80103856:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103859:	01 c0                	add    %eax,%eax
8010385b:	29 c1                	sub    %eax,%ecx
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
8010385d:	83 c1 30             	add    $0x30,%ecx
    while (num != 0) { 
80103860:	85 d2                	test   %edx,%edx
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
80103862:	88 4c 33 ff          	mov    %cl,-0x1(%ebx,%esi,1)
        num = num/10; 
80103866:	89 d1                	mov    %edx,%ecx
    while (num != 0) { 
80103868:	75 d6                	jne    80103840 <itoa.part.3+0x30>
    } 
  
    
    if (isNegative) 
8010386a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010386d:	8d 04 33             	lea    (%ebx,%esi,1),%eax
80103870:	85 d2                	test   %edx,%edx
80103872:	74 3c                	je     801038b0 <itoa.part.3+0xa0>
80103874:	8d 77 02             	lea    0x2(%edi),%esi
        str[i++] = '-'; 
80103877:	c6 00 2d             	movb   $0x2d,(%eax)
8010387a:	89 f2                	mov    %esi,%edx
8010387c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
8010387f:	d1 fa                	sar    %edx
  for (int i = 0; i < len / 2; i++) {
80103881:	85 d2                	test   %edx,%edx
  
    str[i] = '\0'; 
80103883:	c6 00 00             	movb   $0x0,(%eax)
  for (int i = 0; i < len / 2; i++) {
80103886:	7e 1e                	jle    801038a6 <itoa.part.3+0x96>
80103888:	8d 44 1e ff          	lea    -0x1(%esi,%ebx,1),%eax
8010388c:	89 c6                	mov    %eax,%esi
8010388e:	29 d6                	sub    %edx,%esi
    temp = str[i];
80103890:	0f b6 13             	movzbl (%ebx),%edx
    str[i] = str[len - i - 1];
80103893:	0f b6 08             	movzbl (%eax),%ecx
80103896:	83 e8 01             	sub    $0x1,%eax
80103899:	83 c3 01             	add    $0x1,%ebx
8010389c:	88 4b ff             	mov    %cl,-0x1(%ebx)
    str[len - i - 1] = temp;
8010389f:	88 50 01             	mov    %dl,0x1(%eax)
  for (int i = 0; i < len / 2; i++) {
801038a2:	39 f0                	cmp    %esi,%eax
801038a4:	75 ea                	jne    80103890 <itoa.part.3+0x80>
    reverse(str, i); 
  
    return str; 
} 
801038a6:	83 c4 04             	add    $0x4,%esp
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5f                   	pop    %edi
801038ac:	5d                   	pop    %ebp
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
801038b0:	89 f2                	mov    %esi,%edx
801038b2:	d1 fa                	sar    %edx
801038b4:	eb cb                	jmp    80103881 <itoa.part.3+0x71>
801038b6:	8d 76 00             	lea    0x0(%esi),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        num = -num; 
801038c0:	f7 d9                	neg    %ecx
        isNegative = 1; 
801038c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801038c9:	e9 64 ff ff ff       	jmp    80103832 <itoa.part.3+0x22>
801038ce:	66 90                	xchg   %ax,%ax
    str[i] = '\0'; 
801038d0:	c6 02 00             	movb   $0x0,(%edx)
801038d3:	eb d1                	jmp    801038a6 <itoa.part.3+0x96>
801038d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 e9 7f 10 80       	push   $0x80107fe9
801038eb:	68 40 38 11 80       	push   $0x80113840
801038f0:	e8 fb 13 00 00       	call   80104cf0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103906:	9c                   	pushf  
80103907:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103908:	f6 c4 02             	test   $0x2,%ah
8010390b:	75 32                	jne    8010393f <mycpu+0x3f>
  apicid = lapicid();
8010390d:	e8 3e ee ff ff       	call   80102750 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103912:	8b 15 30 38 11 80    	mov    0x80113830,%edx
80103918:	85 d2                	test   %edx,%edx
8010391a:	7e 0b                	jle    80103927 <mycpu+0x27>
    if (cpus[i].apicid == apicid)
8010391c:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103923:	39 d0                	cmp    %edx,%eax
80103925:	74 11                	je     80103938 <mycpu+0x38>
  panic("unknown apicid\n");
80103927:	83 ec 0c             	sub    $0xc,%esp
8010392a:	68 f0 7f 10 80       	push   $0x80107ff0
8010392f:	e8 5c ca ff ff       	call   80100390 <panic>
80103934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103938:	b8 80 37 11 80       	mov    $0x80113780,%eax
8010393d:	c9                   	leave  
8010393e:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
8010393f:	83 ec 0c             	sub    $0xc,%esp
80103942:	68 d8 80 10 80       	push   $0x801080d8
80103947:	e8 44 ca ff ff       	call   80100390 <panic>
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <cpuid>:
cpuid() {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103956:	e8 a5 ff ff ff       	call   80103900 <mycpu>
8010395b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103960:	c9                   	leave  
  return mycpu()-cpus;
80103961:	c1 f8 04             	sar    $0x4,%eax
80103964:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396a:	c3                   	ret    
8010396b:	90                   	nop
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <myproc>:
myproc(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103977:	e8 e4 13 00 00       	call   80104d60 <pushcli>
  c = mycpu();
8010397c:	e8 7f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103981:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103987:	e8 14 14 00 00       	call   80104da0 <popcli>
}
8010398c:	83 c4 04             	add    $0x4,%esp
8010398f:	89 d8                	mov    %ebx,%eax
80103991:	5b                   	pop    %ebx
80103992:	5d                   	pop    %ebp
80103993:	c3                   	ret    
80103994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010399a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039a0 <userinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039a7:	e8 64 fc ff ff       	call   80103610 <allocproc>
801039ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ae:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039b3:	e8 18 3e 00 00       	call   801077d0 <setupkvm>
801039b8:	85 c0                	test   %eax,%eax
801039ba:	89 43 04             	mov    %eax,0x4(%ebx)
801039bd:	0f 84 bd 00 00 00    	je     80103a80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c3:	83 ec 04             	sub    $0x4,%esp
801039c6:	68 2c 00 00 00       	push   $0x2c
801039cb:	68 60 b4 10 80       	push   $0x8010b460
801039d0:	50                   	push   %eax
801039d1:	e8 da 3a 00 00       	call   801074b0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039df:	6a 4c                	push   $0x4c
801039e1:	6a 00                	push   $0x0
801039e3:	ff 73 18             	pushl  0x18(%ebx)
801039e6:	e8 55 15 00 00       	call   80104f40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039f3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a11:	8b 43 18             	mov    0x18(%ebx),%eax
80103a14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 19 80 10 80       	push   $0x80108019
80103a44:	50                   	push   %eax
80103a45:	e8 d6 16 00 00       	call   80105120 <safestrcpy>
  p->cwd = namei("/");
80103a4a:	c7 04 24 22 80 10 80 	movl   $0x80108022,(%esp)
80103a51:	e8 aa e4 ff ff       	call   80101f00 <namei>
80103a56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a59:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103a60:	e8 cb 13 00 00       	call   80104e30 <acquire>
  p->state = RUNNABLE;
80103a65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a6c:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103a73:	e8 78 14 00 00       	call   80104ef0 <release>
}
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	68 00 80 10 80       	push   $0x80108000
80103a88:	e8 03 c9 ff ff       	call   80100390 <panic>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

80103a90 <growproc>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a98:	e8 c3 12 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103a9d:	e8 5e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103aa2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa8:	e8 f3 12 00 00       	call   80104da0 <popcli>
  if(n > 0){
80103aad:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ab0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ab2:	7f 1c                	jg     80103ad0 <growproc+0x40>
  } else if(n < 0){
80103ab4:	75 3a                	jne    80103af0 <growproc+0x60>
  switchuvm(curproc);
80103ab6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ab9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103abb:	53                   	push   %ebx
80103abc:	e8 df 38 00 00       	call   801073a0 <switchuvm>
  return 0;
80103ac1:	83 c4 10             	add    $0x10,%esp
80103ac4:	31 c0                	xor    %eax,%eax
}
80103ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac9:	5b                   	pop    %ebx
80103aca:	5e                   	pop    %esi
80103acb:	5d                   	pop    %ebp
80103acc:	c3                   	ret    
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	pushl  0x4(%ebx)
80103ada:	e8 11 3b 00 00       	call   801075f0 <allocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 d0                	jne    80103ab6 <growproc+0x26>
      return -1;
80103ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aeb:	eb d9                	jmp    80103ac6 <growproc+0x36>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 21 3c 00 00       	call   80107720 <deallocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 b0                	jne    80103ab6 <growproc+0x26>
80103b06:	eb de                	jmp    80103ae6 <growproc+0x56>
80103b08:	90                   	nop
80103b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b10 <fork>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b19:	e8 42 12 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103b1e:	e8 dd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b29:	e8 72 12 00 00       	call   80104da0 <popcli>
  if((np = allocproc()) == 0){
80103b2e:	e8 dd fa ff ff       	call   80103610 <allocproc>
80103b33:	85 c0                	test   %eax,%eax
80103b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b38:	0f 84 b7 00 00 00    	je     80103bf5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b3e:	83 ec 08             	sub    $0x8,%esp
80103b41:	ff 33                	pushl  (%ebx)
80103b43:	ff 73 04             	pushl  0x4(%ebx)
80103b46:	89 c7                	mov    %eax,%edi
80103b48:	e8 53 3d 00 00       	call   801078a0 <copyuvm>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	85 c0                	test   %eax,%eax
80103b52:	89 47 04             	mov    %eax,0x4(%edi)
80103b55:	0f 84 a1 00 00 00    	je     80103bfc <fork+0xec>
  np->sz = curproc->sz;
80103b5b:	8b 03                	mov    (%ebx),%eax
80103b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b60:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b62:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b65:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b67:	8b 79 18             	mov    0x18(%ecx),%edi
80103b6a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b6d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b76:	8b 40 18             	mov    0x18(%eax),%eax
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 13                	je     80103b9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	50                   	push   %eax
80103b8c:	e8 7f d2 ff ff       	call   80100e10 <filedup>
80103b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b94:	83 c4 10             	add    $0x10,%esp
80103b97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9b:	83 c6 01             	add    $0x1,%esi
80103b9e:	83 fe 10             	cmp    $0x10,%esi
80103ba1:	75 dd                	jne    80103b80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ba3:	83 ec 0c             	sub    $0xc,%esp
80103ba6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bac:	e8 bf da ff ff       	call   80101670 <idup>
80103bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	53                   	push   %ebx
80103bc0:	50                   	push   %eax
80103bc1:	e8 5a 15 00 00       	call   80105120 <safestrcpy>
  pid = np->pid;
80103bc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bc9:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103bd0:	e8 5b 12 00 00       	call   80104e30 <acquire>
  np->state = RUNNABLE;
80103bd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bdc:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103be3:	e8 08 13 00 00       	call   80104ef0 <release>
  return pid;
80103be8:	83 c4 10             	add    $0x10,%esp
}
80103beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bee:	89 d8                	mov    %ebx,%eax
80103bf0:	5b                   	pop    %ebx
80103bf1:	5e                   	pop    %esi
80103bf2:	5f                   	pop    %edi
80103bf3:	5d                   	pop    %ebp
80103bf4:	c3                   	ret    
    return -1;
80103bf5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bfa:	eb ef                	jmp    80103beb <fork+0xdb>
    kfree(np->kstack);
80103bfc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bff:	83 ec 0c             	sub    $0xc,%esp
80103c02:	ff 73 08             	pushl  0x8(%ebx)
80103c05:	e8 26 e7 ff ff       	call   80102330 <kfree>
    np->kstack = 0;
80103c0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c11:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c18:	83 c4 10             	add    $0x10,%esp
80103c1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c20:	eb c9                	jmp    80103beb <fork+0xdb>
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c30 <findRunnableProcLottery>:
int findRunnableProcLottery (struct proc * queue0[], int q0Index){
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c36:	8b 45 08             	mov    0x8(%ebp),%eax
  if(q0Index == 0)
80103c39:	85 d2                	test   %edx,%edx
80103c3b:	74 06                	je     80103c43 <findRunnableProcLottery+0x13>
} 
80103c3d:	5d                   	pop    %ebp
80103c3e:	e9 1d fb ff ff       	jmp    80103760 <findRunnableProcLottery.part.1>
80103c43:	83 c8 ff             	or     $0xffffffff,%eax
80103c46:	5d                   	pop    %ebp
80103c47:	c3                   	ret    
80103c48:	90                   	nop
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <findRunnableProcHRRN>:
int findRunnableProcHRRN (struct proc * queue1[], int q1Index){
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 28             	sub    $0x28,%esp
80103c59:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&tickslock);
80103c5c:	68 80 5c 11 80       	push   $0x80115c80
80103c61:	e8 ca 11 00 00       	call   80104e30 <acquire>
  release(&tickslock);
80103c66:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
  int currTick = ticks;
80103c6d:	8b 35 c0 64 11 80    	mov    0x801164c0,%esi
  release(&tickslock);
80103c73:	e8 78 12 00 00       	call   80104ef0 <release>
  for (int i = 0; i < q1Index; i++){
80103c78:	83 c4 10             	add    $0x10,%esp
80103c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103c7f:	7e 6f                	jle    80103cf0 <findRunnableProcHRRN+0xa0>
  float max = -100;
80103c81:	d9 05 c4 82 10 80    	flds   0x801082c4
  for (int i = 0; i < q1Index; i++){
80103c87:	31 db                	xor    %ebx,%ebx
  int maxIndex = -1;
80103c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    float waitingTime = (currTick - queue1[i]->ticks) / 100;
80103c90:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80103c93:	89 f1                	mov    %esi,%ecx
80103c95:	2b 88 88 00 00 00    	sub    0x88(%eax),%ecx
80103c9b:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103ca0:	f7 e9                	imul   %ecx
80103ca2:	c1 f9 1f             	sar    $0x1f,%ecx
    float HRRN = waitingTime/(float)(queue1[i]->cycleNum);
80103ca5:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
    float waitingTime = (currTick - queue1[i]->ticks) / 100;
80103ca8:	c1 fa 05             	sar    $0x5,%edx
80103cab:	29 ca                	sub    %ecx,%edx
80103cad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103cb0:	db 45 e4             	fildl  -0x1c(%ebp)
    float HRRN = waitingTime/(float)(queue1[i]->cycleNum);
80103cb3:	db 80 84 00 00 00    	fildl  0x84(%eax)
80103cb9:	de f9                	fdivrp %st,%st(1)
    if(HRRN > max){
80103cbb:	db e9                	fucomi %st(1),%st
80103cbd:	76 11                	jbe    80103cd0 <findRunnableProcHRRN+0x80>
80103cbf:	dd d9                	fstp   %st(1)
80103cc1:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80103cc4:	eb 0c                	jmp    80103cd2 <findRunnableProcHRRN+0x82>
80103cc6:	8d 76 00             	lea    0x0(%esi),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103cd0:	dd d8                	fstp   %st(0)
  for (int i = 0; i < q1Index; i++){
80103cd2:	83 c3 01             	add    $0x1,%ebx
80103cd5:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80103cd8:	75 b6                	jne    80103c90 <findRunnableProcHRRN+0x40>
80103cda:	dd d8                	fstp   %st(0)
80103cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103cdf:	c1 e0 02             	shl    $0x2,%eax
    return queue1[maxIndex]->pid; 
80103ce2:	8b 04 07             	mov    (%edi,%eax,1),%eax
80103ce5:	8b 40 10             	mov    0x10(%eax),%eax
}
80103ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5f                   	pop    %edi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
  if(q1Index == 0)
80103cf0:	74 07                	je     80103cf9 <findRunnableProcHRRN+0xa9>
80103cf2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
80103cf7:	eb e9                	jmp    80103ce2 <findRunnableProcHRRN+0x92>
    return -1;
80103cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cfe:	eb e8                	jmp    80103ce8 <findRunnableProcHRRN+0x98>

80103d00 <findRunnableProcSRPF>:
int findRunnableProcSRPF (struct proc * queue2[], int q2Index){
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	83 ec 08             	sub    $0x8,%esp
80103d08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  if(q2Index == 0)
80103d0e:	83 fb 00             	cmp    $0x0,%ebx
80103d11:	0f 84 8b 00 00 00    	je     80103da2 <findRunnableProcSRPF+0xa2>
  float min = queue2[0]->remainingPriority;
80103d17:	8b 0a                	mov    (%edx),%ecx
  for (int i = 0; i < q2Index; i++) {
80103d19:	b8 00 00 00 00       	mov    $0x0,%eax
  int minIndex = 0;
80103d1e:	be 00 00 00 00       	mov    $0x0,%esi
  float min = queue2[0]->remainingPriority;
80103d23:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
  for (int i = 0; i < q2Index; i++) {
80103d29:	7e 42                	jle    80103d6d <findRunnableProcSRPF+0x6d>
80103d2b:	eb 05                	jmp    80103d32 <findRunnableProcSRPF+0x32>
80103d2d:	8d 76 00             	lea    0x0(%esi),%esi
80103d30:	dd d9                	fstp   %st(1)
80103d32:	83 c0 01             	add    $0x1,%eax
80103d35:	39 c3                	cmp    %eax,%ebx
80103d37:	74 27                	je     80103d60 <findRunnableProcSRPF+0x60>
    if (min > queue2[i]->remainingPriority) {
80103d39:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
80103d3c:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
80103d42:	d9 c9                	fxch   %st(1)
80103d44:	db e9                	fucomi %st(1),%st
80103d46:	76 e8                	jbe    80103d30 <findRunnableProcSRPF+0x30>
80103d48:	dd d8                	fstp   %st(0)
80103d4a:	89 c6                	mov    %eax,%esi
  for (int i = 0; i < q2Index; i++) {
80103d4c:	83 c0 01             	add    $0x1,%eax
80103d4f:	39 c3                	cmp    %eax,%ebx
80103d51:	75 e6                	jne    80103d39 <findRunnableProcSRPF+0x39>
80103d53:	dd d8                	fstp   %st(0)
80103d55:	eb 0b                	jmp    80103d62 <findRunnableProcSRPF+0x62>
80103d57:	89 f6                	mov    %esi,%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103d60:	dd d8                	fstp   %st(0)
80103d62:	8d 14 b2             	lea    (%edx,%esi,4),%edx
80103d65:	8b 0a                	mov    (%edx),%ecx
80103d67:	d9 81 8c 00 00 00    	flds   0x8c(%ecx)
  if (queue2[minIndex]->remainingPriority - 0.1 > 0)
80103d6d:	dd 05 d0 82 10 80    	fldl   0x801082d0
80103d73:	de e9                	fsubrp %st,%st(1)
80103d75:	d9 ee                	fldz   
80103d77:	d9 ee                	fldz   
80103d79:	d9 ca                	fxch   %st(2)
80103d7b:	db ea                	fucomi %st(2),%st
80103d7d:	dd da                	fstp   %st(2)
80103d7f:	76 17                	jbe    80103d98 <findRunnableProcSRPF+0x98>
80103d81:	dd d8                	fstp   %st(0)
    queue2[minIndex]->remainingPriority -= 0.1;
80103d83:	d9 99 8c 00 00 00    	fstps  0x8c(%ecx)
  return queue2[minIndex]->pid;
80103d89:	8b 02                	mov    (%edx),%eax
80103d8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80103d8e:	83 c4 08             	add    $0x8,%esp
80103d91:	5b                   	pop    %ebx
80103d92:	5e                   	pop    %esi
80103d93:	5d                   	pop    %ebp
80103d94:	c3                   	ret    
80103d95:	8d 76 00             	lea    0x0(%esi),%esi
80103d98:	dd d9                	fstp   %st(1)
    queue2[minIndex]->remainingPriority = 0;
80103d9a:	d9 99 8c 00 00 00    	fstps  0x8c(%ecx)
80103da0:	eb e7                	jmp    80103d89 <findRunnableProcSRPF+0x89>
    return -1;
80103da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103da7:	eb e5                	jmp    80103d8e <findRunnableProcSRPF+0x8e>
80103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103db0 <scheduler>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	81 ec 1c 0c 00 00    	sub    $0xc1c,%esp
  struct cpu *c = mycpu();
80103dbc:	e8 3f fb ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103dc1:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dc8:	00 00 00 
  struct cpu *c = mycpu();
80103dcb:	89 c6                	mov    %eax,%esi
80103dcd:	8d 40 04             	lea    0x4(%eax),%eax
80103dd0:	89 85 e0 f3 ff ff    	mov    %eax,-0xc20(%ebp)
80103dd6:	8d 76 00             	lea    0x0(%esi),%esi
80103dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  asm volatile("sti");
80103de0:	fb                   	sti    
    acquire(&ptable.lock);
80103de1:	83 ec 0c             	sub    $0xc,%esp
    int q0index = 0, q1index = 0, q2index = 0; 
80103de4:	31 ff                	xor    %edi,%edi
80103de6:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80103de8:	68 40 38 11 80       	push   $0x80113840
80103ded:	e8 3e 10 00 00       	call   80104e30 <acquire>
80103df2:	83 c4 10             	add    $0x10,%esp
    int q0index = 0, q1index = 0, q2index = 0; 
80103df5:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df7:	b8 74 38 11 80       	mov    $0x80113874,%eax
80103dfc:	eb 18                	jmp    80103e16 <scheduler+0x66>
80103dfe:	66 90                	xchg   %ax,%ax
        queue0[q0index] = p;
80103e00:	89 84 95 e8 f3 ff ff 	mov    %eax,-0xc18(%ebp,%edx,4)
        q0index++;
80103e07:	83 c2 01             	add    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0a:	05 90 00 00 00       	add    $0x90,%eax
80103e0f:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103e14:	73 3a                	jae    80103e50 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103e16:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e1a:	75 ee                	jne    80103e0a <scheduler+0x5a>
      if(p->queueNum == 0){
80103e1c:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103e22:	85 c9                	test   %ecx,%ecx
80103e24:	74 da                	je     80103e00 <scheduler+0x50>
      else if(p->queueNum == 1){
80103e26:	83 f9 01             	cmp    $0x1,%ecx
80103e29:	0f 84 01 01 00 00    	je     80103f30 <scheduler+0x180>
      else if(p->queueNum == 2){
80103e2f:	83 f9 02             	cmp    $0x2,%ecx
80103e32:	75 d6                	jne    80103e0a <scheduler+0x5a>
        queue2[q2index] = p;
80103e34:	89 84 bd e8 fb ff ff 	mov    %eax,-0x418(%ebp,%edi,4)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3b:	05 90 00 00 00       	add    $0x90,%eax
        q2index++;
80103e40:	83 c7 01             	add    $0x1,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e43:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80103e48:	72 cc                	jb     80103e16 <scheduler+0x66>
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	89 95 e4 f3 ff ff    	mov    %edx,-0xc1c(%ebp)
80103e59:	68 40 38 11 80       	push   $0x80113840
80103e5e:	e8 8d 10 00 00       	call   80104ef0 <release>
  if(q0Index == 0)
80103e63:	8b 95 e4 f3 ff ff    	mov    -0xc1c(%ebp),%edx
80103e69:	83 c4 10             	add    $0x10,%esp
80103e6c:	85 d2                	test   %edx,%edx
80103e6e:	74 0f                	je     80103e7f <scheduler+0xcf>
80103e70:	8d 85 e8 f3 ff ff    	lea    -0xc18(%ebp),%eax
80103e76:	e8 e5 f8 ff ff       	call   80103760 <findRunnableProcLottery.part.1>
    if ((pid = findRunnableProcLottery(queue0, q0index)) < 0) 
80103e7b:	85 c0                	test   %eax,%eax
80103e7d:	79 1b                	jns    80103e9a <scheduler+0xea>
      if ((pid = findRunnableProcHRRN(queue1, q1index)) < 0) 
80103e7f:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
80103e85:	83 ec 08             	sub    $0x8,%esp
80103e88:	53                   	push   %ebx
80103e89:	50                   	push   %eax
80103e8a:	e8 c1 fd ff ff       	call   80103c50 <findRunnableProcHRRN>
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	85 c0                	test   %eax,%eax
80103e94:	0f 88 a5 00 00 00    	js     80103f3f <scheduler+0x18f>
    cprintf("pid is : %d\n", pid);
80103e9a:	83 ec 08             	sub    $0x8,%esp
80103e9d:	89 85 e4 f3 ff ff    	mov    %eax,-0xc1c(%ebp)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ea3:	bb 74 38 11 80       	mov    $0x80113874,%ebx
    cprintf("pid is : %d\n", pid);
80103ea8:	50                   	push   %eax
80103ea9:	68 24 80 10 80       	push   $0x80108024
80103eae:	e8 ad c7 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
80103eb3:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103eba:	e8 71 0f 00 00       	call   80104e30 <acquire>
80103ebf:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ec2:	8b 85 e4 f3 ff ff    	mov    -0xc1c(%ebp),%eax
80103ec8:	eb 14                	jmp    80103ede <scheduler+0x12e>
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ed0:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ed6:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80103edc:	73 05                	jae    80103ee3 <scheduler+0x133>
      if (pid == p->pid)
80103ede:	39 43 10             	cmp    %eax,0x10(%ebx)
80103ee1:	75 ed                	jne    80103ed0 <scheduler+0x120>
    switchuvm(p);
80103ee3:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80103ee6:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    switchuvm(p);
80103eec:	53                   	push   %ebx
80103eed:	e8 ae 34 00 00       	call   801073a0 <switchuvm>
    p->state = RUNNING;
80103ef2:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    swtch(&(c->scheduler), p->context);
80103ef9:	58                   	pop    %eax
80103efa:	5a                   	pop    %edx
80103efb:	ff 73 1c             	pushl  0x1c(%ebx)
80103efe:	ff b5 e0 f3 ff ff    	pushl  -0xc20(%ebp)
80103f04:	e8 72 12 00 00       	call   8010517b <swtch>
    switchkvm();
80103f09:	e8 72 34 00 00       	call   80107380 <switchkvm>
    c->proc = 0;
80103f0e:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f15:	00 00 00 
    release(&ptable.lock);
80103f18:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80103f1f:	e8 cc 0f 00 00       	call   80104ef0 <release>
80103f24:	83 c4 10             	add    $0x10,%esp
80103f27:	e9 b4 fe ff ff       	jmp    80103de0 <scheduler+0x30>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        queue1[q1index] = p;
80103f30:	89 84 9d e8 f7 ff ff 	mov    %eax,-0x818(%ebp,%ebx,4)
        q1index++;
80103f37:	83 c3 01             	add    $0x1,%ebx
80103f3a:	e9 cb fe ff ff       	jmp    80103e0a <scheduler+0x5a>
        if ((pid = findRunnableProcHRRN(queue2, q2index)) < 0)
80103f3f:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
80103f45:	83 ec 08             	sub    $0x8,%esp
80103f48:	57                   	push   %edi
80103f49:	50                   	push   %eax
80103f4a:	e8 01 fd ff ff       	call   80103c50 <findRunnableProcHRRN>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	85 c0                	test   %eax,%eax
80103f54:	0f 89 40 ff ff ff    	jns    80103e9a <scheduler+0xea>
80103f5a:	e9 81 fe ff ff       	jmp    80103de0 <scheduler+0x30>
80103f5f:	90                   	nop

80103f60 <sched>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 f6 0d 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80103f6a:	e8 91 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f75:	e8 26 0e 00 00       	call   80104da0 <popcli>
  if(!holding(&ptable.lock))
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 40 38 11 80       	push   $0x80113840
80103f82:	e8 79 0e 00 00       	call   80104e00 <holding>
80103f87:	83 c4 10             	add    $0x10,%esp
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 4f                	je     80103fdd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f8e:	e8 6d f9 ff ff       	call   80103900 <mycpu>
80103f93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f9a:	75 68                	jne    80104004 <sched+0xa4>
  if(p->state == RUNNING)
80103f9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fa0:	74 55                	je     80103ff7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa2:	9c                   	pushf  
80103fa3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fa4:	f6 c4 02             	test   $0x2,%ah
80103fa7:	75 41                	jne    80103fea <sched+0x8a>
  intena = mycpu()->intena;
80103fa9:	e8 52 f9 ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fb7:	e8 44 f9 ff ff       	call   80103900 <mycpu>
80103fbc:	83 ec 08             	sub    $0x8,%esp
80103fbf:	ff 70 04             	pushl  0x4(%eax)
80103fc2:	53                   	push   %ebx
80103fc3:	e8 b3 11 00 00       	call   8010517b <swtch>
  mycpu()->intena = intena;
80103fc8:	e8 33 f9 ff ff       	call   80103900 <mycpu>
}
80103fcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    
    panic("sched ptable.lock");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 31 80 10 80       	push   $0x80108031
80103fe5:	e8 a6 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 5d 80 10 80       	push   $0x8010805d
80103ff2:	e8 99 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 4f 80 10 80       	push   $0x8010804f
80103fff:	e8 8c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 43 80 10 80       	push   $0x80108043
8010400c:	e8 7f c3 ff ff       	call   80100390 <panic>
80104011:	eb 0d                	jmp    80104020 <exit>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <exit>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104029:	e8 32 0d 00 00       	call   80104d60 <pushcli>
  c = mycpu();
8010402e:	e8 cd f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104033:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104039:	e8 62 0d 00 00       	call   80104da0 <popcli>
  if(curproc == initproc)
8010403e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104044:	8d 5e 28             	lea    0x28(%esi),%ebx
80104047:	8d 7e 68             	lea    0x68(%esi),%edi
8010404a:	0f 84 f1 00 00 00    	je     80104141 <exit+0x121>
    if(curproc->ofile[fd]){
80104050:	8b 03                	mov    (%ebx),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	74 12                	je     80104068 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	50                   	push   %eax
8010405a:	e8 01 ce ff ff       	call   80100e60 <fileclose>
      curproc->ofile[fd] = 0;
8010405f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010406b:	39 fb                	cmp    %edi,%ebx
8010406d:	75 e1                	jne    80104050 <exit+0x30>
  begin_op();
8010406f:	e8 4c eb ff ff       	call   80102bc0 <begin_op>
  iput(curproc->cwd);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	ff 76 68             	pushl  0x68(%esi)
8010407a:	e8 51 d7 ff ff       	call   801017d0 <iput>
  end_op();
8010407f:	e8 ac eb ff ff       	call   80102c30 <end_op>
  curproc->cwd = 0;
80104084:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010408b:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104092:	e8 99 0d 00 00       	call   80104e30 <acquire>
  wakeup1(curproc->parent);
80104097:	8b 56 14             	mov    0x14(%esi),%edx
8010409a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409d:	b8 74 38 11 80       	mov    $0x80113874,%eax
801040a2:	eb 10                	jmp    801040b4 <exit+0x94>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a8:	05 90 00 00 00       	add    $0x90,%eax
801040ad:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801040b2:	73 1e                	jae    801040d2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801040b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040b8:	75 ee                	jne    801040a8 <exit+0x88>
801040ba:	3b 50 20             	cmp    0x20(%eax),%edx
801040bd:	75 e9                	jne    801040a8 <exit+0x88>
      p->state = RUNNABLE;
801040bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c6:	05 90 00 00 00       	add    $0x90,%eax
801040cb:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801040d0:	72 e2                	jb     801040b4 <exit+0x94>
      p->parent = initproc;
801040d2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d8:	ba 74 38 11 80       	mov    $0x80113874,%edx
801040dd:	eb 0f                	jmp    801040ee <exit+0xce>
801040df:	90                   	nop
801040e0:	81 c2 90 00 00 00    	add    $0x90,%edx
801040e6:	81 fa 74 5c 11 80    	cmp    $0x80115c74,%edx
801040ec:	73 3a                	jae    80104128 <exit+0x108>
    if(p->parent == curproc){
801040ee:	39 72 14             	cmp    %esi,0x14(%edx)
801040f1:	75 ed                	jne    801040e0 <exit+0xc0>
      if(p->state == ZOMBIE)
801040f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040fa:	75 e4                	jne    801040e0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040fc:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104101:	eb 11                	jmp    80104114 <exit+0xf4>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104108:	05 90 00 00 00       	add    $0x90,%eax
8010410d:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
80104112:	73 cc                	jae    801040e0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104114:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104118:	75 ee                	jne    80104108 <exit+0xe8>
8010411a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010411d:	75 e9                	jne    80104108 <exit+0xe8>
      p->state = RUNNABLE;
8010411f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104126:	eb e0                	jmp    80104108 <exit+0xe8>
  curproc->state = ZOMBIE;
80104128:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010412f:	e8 2c fe ff ff       	call   80103f60 <sched>
  panic("zombie exit");
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	68 7e 80 10 80       	push   $0x8010807e
8010413c:	e8 4f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104141:	83 ec 0c             	sub    $0xc,%esp
80104144:	68 71 80 10 80       	push   $0x80108071
80104149:	e8 42 c2 ff ff       	call   80100390 <panic>
8010414e:	66 90                	xchg   %ax,%ax

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 40 38 11 80       	push   $0x80113840
8010415c:	e8 cf 0c 00 00       	call   80104e30 <acquire>
  pushcli();
80104161:	e8 fa 0b 00 00       	call   80104d60 <pushcli>
  c = mycpu();
80104166:	e8 95 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 2a 0c 00 00       	call   80104da0 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 de fd ff ff       	call   80103f60 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
80104189:	e8 62 0d 00 00       	call   80104ef0 <release>
}
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104194:	c9                   	leave  
80104195:	c3                   	ret    
80104196:	8d 76 00             	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 ac 0b 00 00       	call   80104d60 <pushcli>
  c = mycpu();
801041b4:	e8 47 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 dc 0b 00 00       	call   80104da0 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 40 38 11 80    	cmp    $0x80113840,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 40 38 11 80       	push   $0x80113840
801041e0:	e8 4b 0c 00 00       	call   80104e30 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 03 0d 00 00       	call   80104ef0 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 64 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
8010420a:	e8 e1 0c 00 00       	call   80104ef0 <release>
    acquire(lk);
8010420f:	89 75 08             	mov    %esi,0x8(%ebp)
80104212:	83 c4 10             	add    $0x10,%esp
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 0f 0c 00 00       	jmp    80104e30 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 29 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 90 80 10 80       	push   $0x80108090
8010424e:	e8 3d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 8a 80 10 80       	push   $0x8010808a
8010425b:	e8 30 c1 ff ff       	call   80100390 <panic>

80104260 <wait>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  pushcli();
80104265:	e8 f6 0a 00 00       	call   80104d60 <pushcli>
  c = mycpu();
8010426a:	e8 91 f6 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010426f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104275:	e8 26 0b 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 40 38 11 80       	push   $0x80113840
80104282:	e8 a9 0b 00 00       	call   80104e30 <acquire>
80104287:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010428a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428c:	bb 74 38 11 80       	mov    $0x80113874,%ebx
80104291:	eb 13                	jmp    801042a6 <wait+0x46>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010429e:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
801042a4:	73 1e                	jae    801042c4 <wait+0x64>
      if(p->parent != curproc)
801042a6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042a9:	75 ed                	jne    80104298 <wait+0x38>
      if(p->state == ZOMBIE){
801042ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042af:	74 37                	je     801042e8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
801042b7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042bc:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
801042c2:	72 e2                	jb     801042a6 <wait+0x46>
    if(!havekids || curproc->killed){
801042c4:	85 c0                	test   %eax,%eax
801042c6:	74 76                	je     8010433e <wait+0xde>
801042c8:	8b 46 24             	mov    0x24(%esi),%eax
801042cb:	85 c0                	test   %eax,%eax
801042cd:	75 6f                	jne    8010433e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042cf:	83 ec 08             	sub    $0x8,%esp
801042d2:	68 40 38 11 80       	push   $0x80113840
801042d7:	56                   	push   %esi
801042d8:	e8 c3 fe ff ff       	call   801041a0 <sleep>
    havekids = 0;
801042dd:	83 c4 10             	add    $0x10,%esp
801042e0:	eb a8                	jmp    8010428a <wait+0x2a>
801042e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042f1:	e8 3a e0 ff ff       	call   80102330 <kfree>
        freevm(p->pgdir);
801042f6:	5a                   	pop    %edx
801042f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104301:	e8 4a 34 00 00       	call   80107750 <freevm>
        release(&ptable.lock);
80104306:	c7 04 24 40 38 11 80 	movl   $0x80113840,(%esp)
        p->pid = 0;
8010430d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104314:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010431b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010431f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104326:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010432d:	e8 be 0b 00 00       	call   80104ef0 <release>
        return pid;
80104332:	83 c4 10             	add    $0x10,%esp
}
80104335:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104338:	89 f0                	mov    %esi,%eax
8010433a:	5b                   	pop    %ebx
8010433b:	5e                   	pop    %esi
8010433c:	5d                   	pop    %ebp
8010433d:	c3                   	ret    
      release(&ptable.lock);
8010433e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104341:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104346:	68 40 38 11 80       	push   $0x80113840
8010434b:	e8 a0 0b 00 00       	call   80104ef0 <release>
      return -1;
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	eb e0                	jmp    80104335 <wait+0xd5>
80104355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <wakeup>:
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010436a:	68 40 38 11 80       	push   $0x80113840
8010436f:	e8 bc 0a 00 00       	call   80104e30 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104377:	b8 74 38 11 80       	mov    $0x80113874,%eax
8010437c:	eb 0e                	jmp    8010438c <wakeup+0x2c>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	05 90 00 00 00       	add    $0x90,%eax
80104385:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010438a:	73 1e                	jae    801043aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010438c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104390:	75 ee                	jne    80104380 <wakeup+0x20>
80104392:	3b 58 20             	cmp    0x20(%eax),%ebx
80104395:	75 e9                	jne    80104380 <wakeup+0x20>
      p->state = RUNNABLE;
80104397:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439e:	05 90 00 00 00       	add    $0x90,%eax
801043a3:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801043a8:	72 e2                	jb     8010438c <wakeup+0x2c>
  release(&ptable.lock);
801043aa:	c7 45 08 40 38 11 80 	movl   $0x80113840,0x8(%ebp)
}
801043b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b4:	c9                   	leave  
  release(&ptable.lock);
801043b5:	e9 36 0b 00 00       	jmp    80104ef0 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <kill>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ca:	68 40 38 11 80       	push   $0x80113840
801043cf:	e8 5c 0a 00 00       	call   80104e30 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	b8 74 38 11 80       	mov    $0x80113874,%eax
801043dc:	eb 0e                	jmp    801043ec <kill+0x2c>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	05 90 00 00 00       	add    $0x90,%eax
801043e5:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
801043ea:	73 34                	jae    80104420 <kill+0x60>
    if(p->pid == pid){
801043ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801043ef:	75 ef                	jne    801043e0 <kill+0x20>
      if(p->state == SLEEPING)
801043f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043fc:	75 07                	jne    80104405 <kill+0x45>
        p->state = RUNNABLE;
801043fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104405:	83 ec 0c             	sub    $0xc,%esp
80104408:	68 40 38 11 80       	push   $0x80113840
8010440d:	e8 de 0a 00 00       	call   80104ef0 <release>
      return 0;
80104412:	83 c4 10             	add    $0x10,%esp
80104415:	31 c0                	xor    %eax,%eax
}
80104417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010441a:	c9                   	leave  
8010441b:	c3                   	ret    
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 40 38 11 80       	push   $0x80113840
80104428:	e8 c3 0a 00 00       	call   80104ef0 <release>
  return -1;
8010442d:	83 c4 10             	add    $0x10,%esp
80104430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <procdump>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	53                   	push   %ebx
80104446:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104449:	bb 74 38 11 80       	mov    $0x80113874,%ebx
{
8010444e:	83 ec 3c             	sub    $0x3c,%esp
80104451:	eb 27                	jmp    8010447a <procdump+0x3a>
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 0f 86 10 80       	push   $0x8010860f
80104460:	e8 fb c1 ff ff       	call   80100660 <cprintf>
80104465:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104468:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010446e:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104474:	0f 83 86 00 00 00    	jae    80104500 <procdump+0xc0>
    if(p->state == UNUSED)
8010447a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010447d:	85 c0                	test   %eax,%eax
8010447f:	74 e7                	je     80104468 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104481:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104484:	ba a1 80 10 80       	mov    $0x801080a1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104489:	77 11                	ja     8010449c <procdump+0x5c>
8010448b:	8b 14 85 ac 82 10 80 	mov    -0x7fef7d54(,%eax,4),%edx
      state = "???";
80104492:	b8 a1 80 10 80       	mov    $0x801080a1,%eax
80104497:	85 d2                	test   %edx,%edx
80104499:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010449c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010449f:	50                   	push   %eax
801044a0:	52                   	push   %edx
801044a1:	ff 73 10             	pushl  0x10(%ebx)
801044a4:	68 a5 80 10 80       	push   $0x801080a5
801044a9:	e8 b2 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044ae:	83 c4 10             	add    $0x10,%esp
801044b1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044b5:	75 a1                	jne    80104458 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044ba:	83 ec 08             	sub    $0x8,%esp
801044bd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044c0:	50                   	push   %eax
801044c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044c4:	8b 40 0c             	mov    0xc(%eax),%eax
801044c7:	83 c0 08             	add    $0x8,%eax
801044ca:	50                   	push   %eax
801044cb:	e8 40 08 00 00       	call   80104d10 <getcallerpcs>
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801044d8:	8b 17                	mov    (%edi),%edx
801044da:	85 d2                	test   %edx,%edx
801044dc:	0f 84 76 ff ff ff    	je     80104458 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	83 c7 04             	add    $0x4,%edi
801044e8:	52                   	push   %edx
801044e9:	68 c1 7a 10 80       	push   $0x80107ac1
801044ee:	e8 6d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044f3:	83 c4 10             	add    $0x10,%esp
801044f6:	39 fe                	cmp    %edi,%esi
801044f8:	75 de                	jne    801044d8 <procdump+0x98>
801044fa:	e9 59 ff ff ff       	jmp    80104458 <procdump+0x18>
801044ff:	90                   	nop
}
80104500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104503:	5b                   	pop    %ebx
80104504:	5e                   	pop    %esi
80104505:	5f                   	pop    %edi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
80104508:	90                   	nop
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104510 <changeQueueNum>:
{
80104510:	55                   	push   %ebp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104511:	b8 74 38 11 80       	mov    $0x80113874,%eax
{
80104516:	89 e5                	mov    %esp,%ebp
80104518:	8b 55 08             	mov    0x8(%ebp),%edx
8010451b:	eb 0f                	jmp    8010452c <changeQueueNum+0x1c>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104520:	05 90 00 00 00       	add    $0x90,%eax
80104525:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010452a:	73 1c                	jae    80104548 <changeQueueNum+0x38>
    if (p->pid == pid) {
8010452c:	39 50 10             	cmp    %edx,0x10(%eax)
8010452f:	75 ef                	jne    80104520 <changeQueueNum+0x10>
      p->queueNum = queue;
80104531:	8b 55 0c             	mov    0xc(%ebp),%edx
80104534:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      return 1;
8010453a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010453f:	5d                   	pop    %ebp
80104540:	c3                   	ret    
80104541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80104548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010454d:	5d                   	pop    %ebp
8010454e:	c3                   	ret    
8010454f:	90                   	nop

80104550 <evalTicket>:
{
80104550:	55                   	push   %ebp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104551:	b8 74 38 11 80       	mov    $0x80113874,%eax
{
80104556:	89 e5                	mov    %esp,%ebp
80104558:	8b 55 08             	mov    0x8(%ebp),%edx
8010455b:	eb 0f                	jmp    8010456c <evalTicket+0x1c>
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104560:	05 90 00 00 00       	add    $0x90,%eax
80104565:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010456a:	73 14                	jae    80104580 <evalTicket+0x30>
    if (p->pid == pid) {
8010456c:	39 50 10             	cmp    %edx,0x10(%eax)
8010456f:	75 ef                	jne    80104560 <evalTicket+0x10>
      p->ticket = ticket;
80104571:	8b 55 0c             	mov    0xc(%ebp),%edx
80104574:	89 50 7c             	mov    %edx,0x7c(%eax)
      return 1;
80104577:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010457c:	5d                   	pop    %ebp
8010457d:	c3                   	ret    
8010457e:	66 90                	xchg   %ax,%ax
  return -1;
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104585:	5d                   	pop    %ebp
80104586:	c3                   	ret    
80104587:	89 f6                	mov    %esi,%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <stof>:
float stof(char* s) {
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 04             	sub    $0x4,%esp
80104596:	8b 55 08             	mov    0x8(%ebp),%edx
  if (*s == '-'){
80104599:	0f be 02             	movsbl (%edx),%eax
8010459c:	3c 2d                	cmp    $0x2d,%al
8010459e:	74 60                	je     80104600 <stof+0x70>
  for (int point_seen = 0; *s; s++){
801045a0:	84 c0                	test   %al,%al
801045a2:	d9 e8                	fld1   
801045a4:	74 69                	je     8010460f <stof+0x7f>
801045a6:	31 c9                	xor    %ecx,%ecx
801045a8:	d9 ee                	fldz   
801045aa:	eb 34                	jmp    801045e0 <stof+0x50>
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int d = *s - '0';
801045b0:	83 e8 30             	sub    $0x30,%eax
    if (d >= 0 && d <= 9){
801045b3:	83 f8 09             	cmp    $0x9,%eax
801045b6:	77 1e                	ja     801045d6 <stof+0x46>
      if (point_seen) fact /= 10.0f;
801045b8:	85 c9                	test   %ecx,%ecx
801045ba:	74 0a                	je     801045c6 <stof+0x36>
801045bc:	d9 c9                	fxch   %st(1)
801045be:	d8 35 c8 82 10 80    	fdivs  0x801082c8
801045c4:	d9 c9                	fxch   %st(1)
      rez = rez * 10.0f + (float)d;
801045c6:	d9 05 c8 82 10 80    	flds   0x801082c8
801045cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801045cf:	de c9                	fmulp  %st,%st(1)
801045d1:	db 45 fc             	fildl  -0x4(%ebp)
801045d4:	de c1                	faddp  %st,%st(1)
  for (int point_seen = 0; *s; s++){
801045d6:	83 c2 01             	add    $0x1,%edx
801045d9:	0f be 02             	movsbl (%edx),%eax
801045dc:	84 c0                	test   %al,%al
801045de:	74 13                	je     801045f3 <stof+0x63>
    if (*s == '.'){
801045e0:	3c 2e                	cmp    $0x2e,%al
801045e2:	75 cc                	jne    801045b0 <stof+0x20>
  for (int point_seen = 0; *s; s++){
801045e4:	83 c2 01             	add    $0x1,%edx
801045e7:	0f be 02             	movsbl (%edx),%eax
      point_seen = 1; 
801045ea:	b9 01 00 00 00       	mov    $0x1,%ecx
  for (int point_seen = 0; *s; s++){
801045ef:	84 c0                	test   %al,%al
801045f1:	75 ed                	jne    801045e0 <stof+0x50>
  return rez * fact;
801045f3:	de c9                	fmulp  %st,%st(1)
}
801045f5:	c9                   	leave  
801045f6:	c3                   	ret    
801045f7:	89 f6                	mov    %esi,%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104600:	0f be 42 01          	movsbl 0x1(%edx),%eax
    fact = -1;
80104604:	d9 e8                	fld1   
    s++;
80104606:	83 c2 01             	add    $0x1,%edx
    fact = -1;
80104609:	d9 e0                	fchs   
  for (int point_seen = 0; *s; s++){
8010460b:	84 c0                	test   %al,%al
8010460d:	75 97                	jne    801045a6 <stof+0x16>
8010460f:	d9 ee                	fldz   
}
80104611:	c9                   	leave  
  return rez * fact;
80104612:	de c9                	fmulp  %st,%st(1)
}
80104614:	c3                   	ret    
80104615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <evalRemainingPriority>:
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
  float pri = stof(priority);
80104624:	ff 75 0c             	pushl  0xc(%ebp)
{
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  float pri = stof(priority);
8010462a:	e8 61 ff ff ff       	call   80104590 <stof>
8010462f:	58                   	pop    %eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104630:	b8 74 38 11 80       	mov    $0x80113874,%eax
80104635:	eb 15                	jmp    8010464c <evalRemainingPriority+0x2c>
80104637:	89 f6                	mov    %esi,%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104640:	05 90 00 00 00       	add    $0x90,%eax
80104645:	3d 74 5c 11 80       	cmp    $0x80115c74,%eax
8010464a:	73 1c                	jae    80104668 <evalRemainingPriority+0x48>
    if (p->pid == pid) {
8010464c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010464f:	75 ef                	jne    80104640 <evalRemainingPriority+0x20>
      p->remainingPriority = pri;
80104651:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      return 1;
80104657:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010465c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010465f:	c9                   	leave  
80104660:	c3                   	ret    
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104668:	dd d8                	fstp   %st(0)
  return -1;
8010466a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010466f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104672:	c9                   	leave  
80104673:	c3                   	ret    
80104674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010467a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104680 <reverse>:
void reverse(char* str, int len) {
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for (int i = 0; i < len / 2; i++) {
80104688:	89 d9                	mov    %ebx,%ecx
8010468a:	c1 e9 1f             	shr    $0x1f,%ecx
8010468d:	01 d9                	add    %ebx,%ecx
8010468f:	d1 f9                	sar    %ecx
80104691:	85 c9                	test   %ecx,%ecx
80104693:	7e 21                	jle    801046b6 <reverse+0x36>
80104695:	8b 55 08             	mov    0x8(%ebp),%edx
80104698:	8d 44 1a ff          	lea    -0x1(%edx,%ebx,1),%eax
8010469c:	89 c6                	mov    %eax,%esi
8010469e:	29 ce                	sub    %ecx,%esi
    temp = str[i];
801046a0:	0f b6 0a             	movzbl (%edx),%ecx
    str[i] = str[len - i - 1];
801046a3:	0f b6 18             	movzbl (%eax),%ebx
801046a6:	83 e8 01             	sub    $0x1,%eax
801046a9:	83 c2 01             	add    $0x1,%edx
801046ac:	88 5a ff             	mov    %bl,-0x1(%edx)
    str[len - i - 1] = temp;
801046af:	88 48 01             	mov    %cl,0x1(%eax)
  for (int i = 0; i < len / 2; i++) {
801046b2:	39 f0                	cmp    %esi,%eax
801046b4:	75 ea                	jne    801046a0 <reverse+0x20>
}
801046b6:	5b                   	pop    %ebx
801046b7:	5e                   	pop    %esi
801046b8:	5d                   	pop    %ebp
801046b9:	c3                   	ret    
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046c0 <itoa>:
char* itoa(int num, char* str) { 
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	8b 45 08             	mov    0x8(%ebp),%eax
801046c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (num == 0) { 
801046ca:	85 c0                	test   %eax,%eax
801046cc:	74 12                	je     801046e0 <itoa+0x20>
801046ce:	89 da                	mov    %ebx,%edx
801046d0:	e8 3b f1 ff ff       	call   80103810 <itoa.part.3>
} 
801046d5:	89 d8                	mov    %ebx,%eax
801046d7:	5b                   	pop    %ebx
801046d8:	5d                   	pop    %ebp
801046d9:	c3                   	ret    
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        str[i++] = '0'; 
801046e0:	b8 30 00 00 00       	mov    $0x30,%eax
801046e5:	66 89 03             	mov    %ax,(%ebx)
} 
801046e8:	89 d8                	mov    %ebx,%eax
801046ea:	5b                   	pop    %ebx
801046eb:	5d                   	pop    %ebp
801046ec:	c3                   	ret    
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <ftos>:

  
char * ftos(float f, char* str){
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	83 ec 10             	sub    $0x10,%esp
 	int count;
 	char* curr;
 	int value;
 	value = (int)f;
801046f9:	d9 7d f2             	fnstcw -0xe(%ebp)
801046fc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
char * ftos(float f, char* str){
80104700:	d9 45 08             	flds   0x8(%ebp)
 	value = (int)f;
80104703:	b4 0c                	mov    $0xc,%ah
80104705:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
80104709:	d9 6d f0             	fldcw  -0x10(%ebp)
8010470c:	db 55 ec             	fistl  -0x14(%ebp)
8010470f:	d9 6d f2             	fldcw  -0xe(%ebp)
80104712:	8b 45 ec             	mov    -0x14(%ebp),%eax
    if (num == 0) { 
80104715:	85 c0                	test   %eax,%eax
 	value = (int)f;
80104717:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (num == 0) { 
8010471a:	75 7c                	jne    80104798 <ftos+0xa8>
        str[i++] = '0'; 
8010471c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010471f:	ba 30 00 00 00       	mov    $0x30,%edx
 	itoa(value,str);
 	count = 0;
 	curr = str;
 	while(*curr != 0){
 		++count;
80104724:	be 01 00 00 00       	mov    $0x1,%esi
        str[i++] = '0'; 
80104729:	66 89 10             	mov    %dx,(%eax)
 		++curr;
8010472c:	8d 48 01             	lea    0x1(%eax),%ecx
8010472f:	89 c2                	mov    %eax,%edx
80104731:	31 c0                	xor    %eax,%eax
 	if(count + 1 >= MAXFLOATLEN){
 		str[MAXFLOATLEN - 1] = 0;
 		return str;	
 	}
 	
 	str[count++] = '.';
80104733:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104736:	83 c0 02             	add    $0x2,%eax
 	++curr;
 	f = f - (float)value;
80104739:	db 45 e8             	fildl  -0x18(%ebp)
 	++curr;
8010473c:	83 c2 02             	add    $0x2,%edx
 	
 	while(count + 1 < MAXFLOATLEN){
8010473f:	83 f8 09             	cmp    $0x9,%eax
 	f = f - (float)value;
80104742:	de e9                	fsubrp %st,%st(1)
 	str[count++] = '.';
80104744:	c6 04 37 2e          	movb   $0x2e,(%edi,%esi,1)
 	while(count + 1 < MAXFLOATLEN){
80104748:	74 14                	je     8010475e <ftos+0x6e>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 		f *= 10;
 		++count;	
80104750:	83 c0 01             	add    $0x1,%eax
 		f *= 10;
80104753:	d8 0d c8 82 10 80    	fmuls  0x801082c8
 	while(count + 1 < MAXFLOATLEN){
80104759:	83 f8 09             	cmp    $0x9,%eax
8010475c:	75 f2                	jne    80104750 <ftos+0x60>
 	}
 	
 	value = (int)f;
8010475e:	d9 6d f0             	fldcw  -0x10(%ebp)
80104761:	db 5d ec             	fistpl -0x14(%ebp)
80104764:	d9 6d f2             	fldcw  -0xe(%ebp)
80104767:	8b 45 ec             	mov    -0x14(%ebp),%eax
    if (num == 0) { 
8010476a:	85 c0                	test   %eax,%eax
8010476c:	0f 85 7e 00 00 00    	jne    801047f0 <ftos+0x100>
        str[i++] = '0'; 
80104772:	b8 30 00 00 00       	mov    $0x30,%eax
80104777:	66 89 41 01          	mov    %ax,0x1(%ecx)
8010477b:	eb 05                	jmp    80104782 <ftos+0x92>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	dd d8                	fstp   %st(0)
 		str[MAXFLOATLEN - 1] = 0;
80104782:	8b 45 0c             	mov    0xc(%ebp),%eax
80104785:	c6 40 09 00          	movb   $0x0,0x9(%eax)
 	itoa(value,curr);
 	str[MAXFLOATLEN - 1] = 0;
 	return str;
}
80104789:	83 c4 10             	add    $0x10,%esp
8010478c:	5b                   	pop    %ebx
8010478d:	5e                   	pop    %esi
8010478e:	5f                   	pop    %edi
8010478f:	5d                   	pop    %ebp
80104790:	c3                   	ret    
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104798:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010479b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010479e:	d9 5d e4             	fstps  -0x1c(%ebp)
801047a1:	e8 6a f0 ff ff       	call   80103810 <itoa.part.3>
 	while(*curr != 0){
801047a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801047a9:	d9 45 e4             	flds   -0x1c(%ebp)
801047ac:	80 38 00             	cmpb   $0x0,(%eax)
801047af:	74 57                	je     80104808 <ftos+0x118>
801047b1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801047b5:	89 c2                	mov    %eax,%edx
801047b7:	31 c0                	xor    %eax,%eax
801047b9:	eb 0d                	jmp    801047c8 <ftos+0xd8>
801047bb:	90                   	nop
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 		++count;
801047c4:	89 f0                	mov    %esi,%eax
 		++curr;
801047c6:	89 ca                	mov    %ecx,%edx
 	while(*curr != 0){
801047c8:	84 db                	test   %bl,%bl
 		++count;
801047ca:	8d 70 01             	lea    0x1(%eax),%esi
 		++curr;
801047cd:	8d 4a 01             	lea    0x1(%edx),%ecx
 	while(*curr != 0){
801047d0:	75 ee                	jne    801047c0 <ftos+0xd0>
 	if(count + 1 >= MAXFLOATLEN){
801047d2:	83 fe 08             	cmp    $0x8,%esi
801047d5:	7f a9                	jg     80104780 <ftos+0x90>
801047d7:	d9 7d f2             	fnstcw -0xe(%ebp)
801047da:	0f b7 7d f2          	movzwl -0xe(%ebp),%edi
801047de:	89 fb                	mov    %edi,%ebx
801047e0:	b7 0c                	mov    $0xc,%bh
801047e2:	66 89 5d f0          	mov    %bx,-0x10(%ebp)
801047e6:	e9 48 ff ff ff       	jmp    80104733 <ftos+0x43>
801047eb:	90                   	nop
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f0:	e8 1b f0 ff ff       	call   80103810 <itoa.part.3>
 		str[MAXFLOATLEN - 1] = 0;
801047f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801047f8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
}
801047fc:	83 c4 10             	add    $0x10,%esp
801047ff:	5b                   	pop    %ebx
80104800:	5e                   	pop    %esi
80104801:	5f                   	pop    %edi
80104802:	5d                   	pop    %ebp
80104803:	c3                   	ret    
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104808:	8b 45 0c             	mov    0xc(%ebp),%eax
 	f = f - (float)value;
8010480b:	db 45 e8             	fildl  -0x18(%ebp)
8010480e:	de e9                	fsubrp %st,%st(1)
 	str[count++] = '.';
80104810:	c6 00 2e             	movb   $0x2e,(%eax)
80104813:	d9 7d f2             	fnstcw -0xe(%ebp)
80104816:	0f b7 75 f2          	movzwl -0xe(%ebp),%esi
8010481a:	8d 50 01             	lea    0x1(%eax),%edx
 	f = f - (float)value;
8010481d:	89 c1                	mov    %eax,%ecx
 	str[count++] = '.';
8010481f:	b8 01 00 00 00       	mov    $0x1,%eax
 		++count;	
80104824:	83 c0 01             	add    $0x1,%eax
 	while(count + 1 < MAXFLOATLEN){
80104827:	83 f8 09             	cmp    $0x9,%eax
 		f *= 10;
8010482a:	d8 0d c8 82 10 80    	fmuls  0x801082c8
80104830:	89 f3                	mov    %esi,%ebx
80104832:	b7 0c                	mov    $0xc,%bh
80104834:	66 89 5d f0          	mov    %bx,-0x10(%ebp)
 	while(count + 1 < MAXFLOATLEN){
80104838:	0f 85 12 ff ff ff    	jne    80104750 <ftos+0x60>
8010483e:	e9 1b ff ff ff       	jmp    8010475e <ftos+0x6e>
80104843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <generateHRRN>:

char* generateHRRN(struct proc *p, char* out) {
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
  float hrrnTime;
  float waitingTime;
  waitingTime = (ticks - p->ticks) / 100;
80104855:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
char* generateHRRN(struct proc *p, char* out) {
8010485a:	83 ec 04             	sub    $0x4,%esp
8010485d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  waitingTime = (ticks - p->ticks) / 100;
80104863:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
  ftos(hrrnTime, out);
80104869:	53                   	push   %ebx
  waitingTime = (ticks - p->ticks) / 100;
8010486a:	2b 91 88 00 00 00    	sub    0x88(%ecx),%edx
  ftos(hrrnTime, out);
80104870:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104873:	89 d0                	mov    %edx,%eax
80104875:	f7 e6                	mul    %esi
80104877:	c1 ea 05             	shr    $0x5,%edx
8010487a:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010487d:	db 45 f4             	fildl  -0xc(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104880:	db 81 84 00 00 00    	fildl  0x84(%ecx)
80104886:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104888:	d9 1c 24             	fstps  (%esp)
8010488b:	e8 60 fe ff ff       	call   801046f0 <ftos>
  return out;
}
80104890:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104893:	89 d8                	mov    %ebx,%eax
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048a0 <printInfo>:


int
printInfo(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	53                   	push   %ebx
801048a6:	83 ec 38             	sub    $0x38,%esp
  asm volatile("sti");
801048a9:	fb                   	sti    
  char str[MAXFLOATLEN];
  char out[6];
  struct proc *p;
  sti();
  acquire(&ptable.lock);
801048aa:	68 40 38 11 80       	push   $0x80113840
  cprintf("name    pid    state    queueNum    priority    tickets    cycles    HRRN \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048af:	bb 74 38 11 80       	mov    $0x80113874,%ebx
  ftos(hrrnTime, out);
801048b4:	8d 75 d8             	lea    -0x28(%ebp),%esi
  waitingTime = (ticks - p->ticks) / 100;
801048b7:	bf 1f 85 eb 51       	mov    $0x51eb851f,%edi
  acquire(&ptable.lock);
801048bc:	e8 6f 05 00 00       	call   80104e30 <acquire>
  cprintf("name    pid    state    queueNum    priority    tickets    cycles    HRRN \n");
801048c1:	c7 04 24 00 81 10 80 	movl   $0x80108100,(%esp)
801048c8:	e8 93 bd ff ff       	call   80100660 <cprintf>
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	eb 3c                	jmp    8010490e <printInfo+0x6e>
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  //     cprintf("ticket is %d\n", p->ticket);
  //   }
    if (p->state == EMBRYO){
      cprintf("%s     %d     EMBRYO     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
    }
    if (p->state == SLEEPING){
801048d8:	83 f8 02             	cmp    $0x2,%eax
801048db:	0f 84 b5 00 00 00    	je     80104996 <printInfo+0xf6>
      cprintf("%s     %d     SLEEPING     %d     %s     %d        %d             %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
    }
    if (p->state == RUNNABLE){
801048e1:	83 f8 03             	cmp    $0x3,%eax
801048e4:	0f 84 2c 01 00 00    	je     80104a16 <printInfo+0x176>
      cprintf("%s     %d     RUNNABLE     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
    }
    if (p->state == RUNNING){
801048ea:	83 f8 04             	cmp    $0x4,%eax
801048ed:	0f 84 a3 01 00 00    	je     80104a96 <printInfo+0x1f6>
      cprintf("%s     %d     RUNNING     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
    }
    if (p->state == ZOMBIE){
801048f3:	83 f8 05             	cmp    $0x5,%eax
801048f6:	0f 84 1a 02 00 00    	je     80104b16 <printInfo+0x276>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048fc:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104902:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104908:	0f 83 8e 02 00 00    	jae    80104b9c <printInfo+0x2fc>
    if (p->state == EMBRYO){
8010490e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104911:	83 f8 01             	cmp    $0x1,%eax
80104914:	75 c2                	jne    801048d8 <printInfo+0x38>
  waitingTime = (ticks - p->ticks) / 100;
80104916:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
8010491c:	2b 93 88 00 00 00    	sub    0x88(%ebx),%edx
  ftos(hrrnTime, out);
80104922:	83 ec 08             	sub    $0x8,%esp
80104925:	56                   	push   %esi
80104926:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104929:	89 d0                	mov    %edx,%eax
8010492b:	f7 e7                	mul    %edi
8010492d:	c1 ea 05             	shr    $0x5,%edx
80104930:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104933:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104936:	db 83 84 00 00 00    	fildl  0x84(%ebx)
8010493c:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
8010493e:	d9 1c 24             	fstps  (%esp)
80104941:	e8 aa fd ff ff       	call   801046f0 <ftos>
      cprintf("%s     %d     EMBRYO     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
80104946:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104949:	58                   	pop    %eax
8010494a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010494d:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104953:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104956:	5a                   	pop    %edx
80104957:	50                   	push   %eax
80104958:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
8010495e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104961:	e8 8a fd ff ff       	call   801046f0 <ftos>
80104966:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104969:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010496c:	56                   	push   %esi
8010496d:	51                   	push   %ecx
8010496e:	52                   	push   %edx
8010496f:	50                   	push   %eax
80104970:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104973:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104979:	ff 73 10             	pushl  0x10(%ebx)
8010497c:	50                   	push   %eax
8010497d:	68 4c 81 10 80       	push   $0x8010814c
80104982:	e8 d9 bc ff ff       	call   80100660 <cprintf>
80104987:	8b 43 0c             	mov    0xc(%ebx),%eax
8010498a:	83 c4 30             	add    $0x30,%esp
    if (p->state == SLEEPING){
8010498d:	83 f8 02             	cmp    $0x2,%eax
80104990:	0f 85 4b ff ff ff    	jne    801048e1 <printInfo+0x41>
  waitingTime = (ticks - p->ticks) / 100;
80104996:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
8010499c:	2b 93 88 00 00 00    	sub    0x88(%ebx),%edx
  ftos(hrrnTime, out);
801049a2:	83 ec 08             	sub    $0x8,%esp
801049a5:	56                   	push   %esi
801049a6:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
801049a9:	89 d0                	mov    %edx,%eax
801049ab:	f7 e7                	mul    %edi
801049ad:	c1 ea 05             	shr    $0x5,%edx
801049b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049b3:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
801049b6:	db 83 84 00 00 00    	fildl  0x84(%ebx)
801049bc:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
801049be:	d9 1c 24             	fstps  (%esp)
801049c1:	e8 2a fd ff ff       	call   801046f0 <ftos>
      cprintf("%s     %d     SLEEPING     %d     %s     %d        %d             %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
801049c6:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
801049cc:	8b 53 7c             	mov    0x7c(%ebx),%edx
801049cf:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801049d2:	59                   	pop    %ecx
801049d3:	58                   	pop    %eax
801049d4:	8d 45 de             	lea    -0x22(%ebp),%eax
801049d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049da:	50                   	push   %eax
801049db:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
801049e1:	e8 0a fd ff ff       	call   801046f0 <ftos>
801049e6:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801049e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801049ec:	56                   	push   %esi
801049ed:	51                   	push   %ecx
801049ee:	52                   	push   %edx
801049ef:	50                   	push   %eax
801049f0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801049f3:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801049f9:	ff 73 10             	pushl  0x10(%ebx)
801049fc:	50                   	push   %eax
801049fd:	68 90 81 10 80       	push   $0x80108190
80104a02:	e8 59 bc ff ff       	call   80100660 <cprintf>
80104a07:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a0a:	83 c4 30             	add    $0x30,%esp
    if (p->state == RUNNABLE){
80104a0d:	83 f8 03             	cmp    $0x3,%eax
80104a10:	0f 85 d4 fe ff ff    	jne    801048ea <printInfo+0x4a>
  waitingTime = (ticks - p->ticks) / 100;
80104a16:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104a1c:	2b 93 88 00 00 00    	sub    0x88(%ebx),%edx
  ftos(hrrnTime, out);
80104a22:	83 ec 08             	sub    $0x8,%esp
80104a25:	56                   	push   %esi
80104a26:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104a29:	89 d0                	mov    %edx,%eax
80104a2b:	f7 e7                	mul    %edi
80104a2d:	c1 ea 05             	shr    $0x5,%edx
80104a30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a33:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104a36:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104a3c:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104a3e:	d9 1c 24             	fstps  (%esp)
80104a41:	e8 aa fc ff ff       	call   801046f0 <ftos>
      cprintf("%s     %d     RUNNABLE     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
80104a46:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104a49:	58                   	pop    %eax
80104a4a:	8d 45 de             	lea    -0x22(%ebp),%eax
80104a4d:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104a53:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a56:	5a                   	pop    %edx
80104a57:	50                   	push   %eax
80104a58:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104a5e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a61:	e8 8a fc ff ff       	call   801046f0 <ftos>
80104a66:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104a69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104a6c:	56                   	push   %esi
80104a6d:	51                   	push   %ecx
80104a6e:	52                   	push   %edx
80104a6f:	50                   	push   %eax
80104a70:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a73:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104a79:	ff 73 10             	pushl  0x10(%ebx)
80104a7c:	50                   	push   %eax
80104a7d:	68 d8 81 10 80       	push   $0x801081d8
80104a82:	e8 d9 bb ff ff       	call   80100660 <cprintf>
80104a87:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a8a:	83 c4 30             	add    $0x30,%esp
    if (p->state == RUNNING){
80104a8d:	83 f8 04             	cmp    $0x4,%eax
80104a90:	0f 85 5d fe ff ff    	jne    801048f3 <printInfo+0x53>
  waitingTime = (ticks - p->ticks) / 100;
80104a96:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104a9c:	2b 93 88 00 00 00    	sub    0x88(%ebx),%edx
  ftos(hrrnTime, out);
80104aa2:	83 ec 08             	sub    $0x8,%esp
80104aa5:	56                   	push   %esi
80104aa6:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104aa9:	89 d0                	mov    %edx,%eax
80104aab:	f7 e7                	mul    %edi
80104aad:	c1 ea 05             	shr    $0x5,%edx
80104ab0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ab3:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104ab6:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104abc:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104abe:	d9 1c 24             	fstps  (%esp)
80104ac1:	e8 2a fc ff ff       	call   801046f0 <ftos>
      cprintf("%s     %d     RUNNING     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
80104ac6:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104acc:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104acf:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ad2:	59                   	pop    %ecx
80104ad3:	58                   	pop    %eax
80104ad4:	8d 45 de             	lea    -0x22(%ebp),%eax
80104ad7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ada:	50                   	push   %eax
80104adb:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104ae1:	e8 0a fc ff ff       	call   801046f0 <ftos>
80104ae6:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104ae9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104aec:	56                   	push   %esi
80104aed:	51                   	push   %ecx
80104aee:	52                   	push   %edx
80104aef:	50                   	push   %eax
80104af0:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104af3:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104af9:	ff 73 10             	pushl  0x10(%ebx)
80104afc:	50                   	push   %eax
80104afd:	68 20 82 10 80       	push   $0x80108220
80104b02:	e8 59 bb ff ff       	call   80100660 <cprintf>
80104b07:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b0a:	83 c4 30             	add    $0x30,%esp
    if (p->state == ZOMBIE){
80104b0d:	83 f8 05             	cmp    $0x5,%eax
80104b10:	0f 85 e6 fd ff ff    	jne    801048fc <printInfo+0x5c>
  waitingTime = (ticks - p->ticks) / 100;
80104b16:	8b 15 c0 64 11 80    	mov    0x801164c0,%edx
80104b1c:	2b 93 88 00 00 00    	sub    0x88(%ebx),%edx
  ftos(hrrnTime, out);
80104b22:	83 ec 08             	sub    $0x8,%esp
80104b25:	56                   	push   %esi
80104b26:	83 ec 04             	sub    $0x4,%esp
  waitingTime = (ticks - p->ticks) / 100;
80104b29:	89 d0                	mov    %edx,%eax
80104b2b:	f7 e7                	mul    %edi
80104b2d:	c1 ea 05             	shr    $0x5,%edx
80104b30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b33:	db 45 d4             	fildl  -0x2c(%ebp)
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
80104b36:	db 83 84 00 00 00    	fildl  0x84(%ebx)
80104b3c:	de f9                	fdivrp %st,%st(1)
  ftos(hrrnTime, out);
80104b3e:	d9 1c 24             	fstps  (%esp)
80104b41:	e8 aa fb ff ff       	call   801046f0 <ftos>
      cprintf("%s     %d     ZOMBIE     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
80104b46:	8b 53 7c             	mov    0x7c(%ebx),%edx
80104b49:	58                   	pop    %eax
80104b4a:	8d 45 de             	lea    -0x22(%ebp),%eax
80104b4d:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104b53:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b56:	5a                   	pop    %edx
80104b57:	50                   	push   %eax
80104b58:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104b5e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b61:	e8 8a fb ff ff       	call   801046f0 <ftos>
80104b66:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104b69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104b6c:	56                   	push   %esi
80104b6d:	51                   	push   %ecx
80104b6e:	52                   	push   %edx
80104b6f:	50                   	push   %eax
80104b70:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b73:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104b79:	ff 73 10             	pushl  0x10(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b7c:	81 c3 90 00 00 00    	add    $0x90,%ebx
      cprintf("%s     %d     ZOMBIE     %d     %s     %d        %d            %s \n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out));
80104b82:	50                   	push   %eax
80104b83:	68 68 82 10 80       	push   $0x80108268
80104b88:	e8 d3 ba ff ff       	call   80100660 <cprintf>
80104b8d:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b90:	81 fb 74 5c 11 80    	cmp    $0x80115c74,%ebx
80104b96:	0f 82 72 fd ff ff    	jb     8010490e <printInfo+0x6e>
    }
  }
  release(&ptable.lock);
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	68 40 38 11 80       	push   $0x80113840
80104ba4:	e8 47 03 00 00       	call   80104ef0 <release>
  return 1;
}
80104ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bac:	b8 01 00 00 00       	mov    $0x1,%eax
80104bb1:	5b                   	pop    %ebx
80104bb2:	5e                   	pop    %esi
80104bb3:	5f                   	pop    %edi
80104bb4:	5d                   	pop    %ebp
80104bb5:	c3                   	ret    
80104bb6:	66 90                	xchg   %ax,%ax
80104bb8:	66 90                	xchg   %ax,%ax
80104bba:	66 90                	xchg   %ax,%ax
80104bbc:	66 90                	xchg   %ax,%ax
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bca:	68 d8 82 10 80       	push   $0x801082d8
80104bcf:	8d 43 04             	lea    0x4(%ebx),%eax
80104bd2:	50                   	push   %eax
80104bd3:	e8 18 01 00 00       	call   80104cf0 <initlock>
  lk->name = name;
80104bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104bdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104be1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104be4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104beb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf1:	c9                   	leave  
80104bf2:	c3                   	ret    
80104bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c08:	83 ec 0c             	sub    $0xc,%esp
80104c0b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c0e:	56                   	push   %esi
80104c0f:	e8 1c 02 00 00       	call   80104e30 <acquire>
  while (lk->locked) {
80104c14:	8b 13                	mov    (%ebx),%edx
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	85 d2                	test   %edx,%edx
80104c1b:	74 16                	je     80104c33 <acquiresleep+0x33>
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c20:	83 ec 08             	sub    $0x8,%esp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	e8 76 f5 ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
80104c2a:	8b 03                	mov    (%ebx),%eax
80104c2c:	83 c4 10             	add    $0x10,%esp
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	75 ed                	jne    80104c20 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c33:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c39:	e8 32 ed ff ff       	call   80103970 <myproc>
80104c3e:	8b 40 10             	mov    0x10(%eax),%eax
80104c41:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c44:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c4a:	5b                   	pop    %ebx
80104c4b:	5e                   	pop    %esi
80104c4c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c4d:	e9 9e 02 00 00       	jmp    80104ef0 <release>
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
80104c6f:	e8 bc 01 00 00       	call   80104e30 <acquire>
  lk->locked = 0;
80104c74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c7a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c81:	89 1c 24             	mov    %ebx,(%esp)
80104c84:	e8 d7 f6 ff ff       	call   80104360 <wakeup>
  release(&lk->lk);
80104c89:	89 75 08             	mov    %esi,0x8(%ebp)
80104c8c:	83 c4 10             	add    $0x10,%esp
}
80104c8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c92:	5b                   	pop    %ebx
80104c93:	5e                   	pop    %esi
80104c94:	5d                   	pop    %ebp
  release(&lk->lk);
80104c95:	e9 56 02 00 00       	jmp    80104ef0 <release>
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ca0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
80104ca5:	53                   	push   %ebx
80104ca6:	31 ff                	xor    %edi,%edi
80104ca8:	83 ec 18             	sub    $0x18,%esp
80104cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104cae:	8d 73 04             	lea    0x4(%ebx),%esi
80104cb1:	56                   	push   %esi
80104cb2:	e8 79 01 00 00       	call   80104e30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104cb7:	8b 03                	mov    (%ebx),%eax
80104cb9:	83 c4 10             	add    $0x10,%esp
80104cbc:	85 c0                	test   %eax,%eax
80104cbe:	74 13                	je     80104cd3 <holdingsleep+0x33>
80104cc0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cc3:	e8 a8 ec ff ff       	call   80103970 <myproc>
80104cc8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ccb:	0f 94 c0             	sete   %al
80104cce:	0f b6 c0             	movzbl %al,%eax
80104cd1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104cd3:	83 ec 0c             	sub    $0xc,%esp
80104cd6:	56                   	push   %esi
80104cd7:	e8 14 02 00 00       	call   80104ef0 <release>
  return r;
}
80104cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cdf:	89 f8                	mov    %edi,%eax
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5f                   	pop    %edi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    
80104ce6:	66 90                	xchg   %ax,%ax
80104ce8:	66 90                	xchg   %ax,%ax
80104cea:	66 90                	xchg   %ax,%ax
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	90                   	nop
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d10:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d11:	31 d2                	xor    %edx,%edx
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d16:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d1c:	83 e8 08             	sub    $0x8,%eax
80104d1f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d20:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d26:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d2c:	77 1a                	ja     80104d48 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d2e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d31:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d34:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d37:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d39:	83 fa 0a             	cmp    $0xa,%edx
80104d3c:	75 e2                	jne    80104d20 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5d                   	pop    %ebp
80104d40:	c3                   	ret    
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d4b:	83 c1 28             	add    $0x28,%ecx
80104d4e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d56:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d59:	39 c1                	cmp    %eax,%ecx
80104d5b:	75 f3                	jne    80104d50 <getcallerpcs+0x40>
}
80104d5d:	5b                   	pop    %ebx
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    

80104d60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d67:	9c                   	pushf  
80104d68:	5b                   	pop    %ebx
  asm volatile("cli");
80104d69:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d6a:	e8 91 eb ff ff       	call   80103900 <mycpu>
80104d6f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d75:	85 c0                	test   %eax,%eax
80104d77:	75 11                	jne    80104d8a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104d79:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d7f:	e8 7c eb ff ff       	call   80103900 <mycpu>
80104d84:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104d8a:	e8 71 eb ff ff       	call   80103900 <mycpu>
80104d8f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d96:	83 c4 04             	add    $0x4,%esp
80104d99:	5b                   	pop    %ebx
80104d9a:	5d                   	pop    %ebp
80104d9b:	c3                   	ret    
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <popcli>:

void
popcli(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104da6:	9c                   	pushf  
80104da7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104da8:	f6 c4 02             	test   $0x2,%ah
80104dab:	75 35                	jne    80104de2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104dad:	e8 4e eb ff ff       	call   80103900 <mycpu>
80104db2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104db9:	78 34                	js     80104def <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dbb:	e8 40 eb ff ff       	call   80103900 <mycpu>
80104dc0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dc6:	85 d2                	test   %edx,%edx
80104dc8:	74 06                	je     80104dd0 <popcli+0x30>
    sti();
}
80104dca:	c9                   	leave  
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dd0:	e8 2b eb ff ff       	call   80103900 <mycpu>
80104dd5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	74 eb                	je     80104dca <popcli+0x2a>
  asm volatile("sti");
80104ddf:	fb                   	sti    
}
80104de0:	c9                   	leave  
80104de1:	c3                   	ret    
    panic("popcli - interruptible");
80104de2:	83 ec 0c             	sub    $0xc,%esp
80104de5:	68 e3 82 10 80       	push   $0x801082e3
80104dea:	e8 a1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	68 fa 82 10 80       	push   $0x801082fa
80104df7:	e8 94 b5 ff ff       	call   80100390 <panic>
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <holding>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 75 08             	mov    0x8(%ebp),%esi
80104e08:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e0a:	e8 51 ff ff ff       	call   80104d60 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e0f:	8b 06                	mov    (%esi),%eax
80104e11:	85 c0                	test   %eax,%eax
80104e13:	74 10                	je     80104e25 <holding+0x25>
80104e15:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e18:	e8 e3 ea ff ff       	call   80103900 <mycpu>
80104e1d:	39 c3                	cmp    %eax,%ebx
80104e1f:	0f 94 c3             	sete   %bl
80104e22:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e25:	e8 76 ff ff ff       	call   80104da0 <popcli>
}
80104e2a:	89 d8                	mov    %ebx,%eax
80104e2c:	5b                   	pop    %ebx
80104e2d:	5e                   	pop    %esi
80104e2e:	5d                   	pop    %ebp
80104e2f:	c3                   	ret    

80104e30 <acquire>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e35:	e8 26 ff ff ff       	call   80104d60 <pushcli>
  if(holding(lk))
80104e3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e3d:	83 ec 0c             	sub    $0xc,%esp
80104e40:	53                   	push   %ebx
80104e41:	e8 ba ff ff ff       	call   80104e00 <holding>
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	0f 85 83 00 00 00    	jne    80104ed4 <acquire+0xa4>
80104e51:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e53:	ba 01 00 00 00       	mov    $0x1,%edx
80104e58:	eb 09                	jmp    80104e63 <acquire+0x33>
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e63:	89 d0                	mov    %edx,%eax
80104e65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e68:	85 c0                	test   %eax,%eax
80104e6a:	75 f4                	jne    80104e60 <acquire+0x30>
  __sync_synchronize();
80104e6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e74:	e8 87 ea ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e79:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104e7c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e7f:	89 e8                	mov    %ebp,%eax
80104e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e88:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104e8e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104e94:	77 1a                	ja     80104eb0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e96:	8b 48 04             	mov    0x4(%eax),%ecx
80104e99:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104e9c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e9f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ea1:	83 fe 0a             	cmp    $0xa,%esi
80104ea4:	75 e2                	jne    80104e88 <acquire+0x58>
}
80104ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea9:	5b                   	pop    %ebx
80104eaa:	5e                   	pop    %esi
80104eab:	5d                   	pop    %ebp
80104eac:	c3                   	ret    
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
80104eb0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104eb3:	83 c2 28             	add    $0x28,%edx
80104eb6:	8d 76 00             	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ec0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ec6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ec9:	39 d0                	cmp    %edx,%eax
80104ecb:	75 f3                	jne    80104ec0 <acquire+0x90>
}
80104ecd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed0:	5b                   	pop    %ebx
80104ed1:	5e                   	pop    %esi
80104ed2:	5d                   	pop    %ebp
80104ed3:	c3                   	ret    
    panic("acquire");
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	68 01 83 10 80       	push   $0x80108301
80104edc:	e8 af b4 ff ff       	call   80100390 <panic>
80104ee1:	eb 0d                	jmp    80104ef0 <release>
80104ee3:	90                   	nop
80104ee4:	90                   	nop
80104ee5:	90                   	nop
80104ee6:	90                   	nop
80104ee7:	90                   	nop
80104ee8:	90                   	nop
80104ee9:	90                   	nop
80104eea:	90                   	nop
80104eeb:	90                   	nop
80104eec:	90                   	nop
80104eed:	90                   	nop
80104eee:	90                   	nop
80104eef:	90                   	nop

80104ef0 <release>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 10             	sub    $0x10,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104efa:	53                   	push   %ebx
80104efb:	e8 00 ff ff ff       	call   80104e00 <holding>
80104f00:	83 c4 10             	add    $0x10,%esp
80104f03:	85 c0                	test   %eax,%eax
80104f05:	74 22                	je     80104f29 <release+0x39>
  lk->pcs[0] = 0;
80104f07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f23:	c9                   	leave  
  popcli();
80104f24:	e9 77 fe ff ff       	jmp    80104da0 <popcli>
    panic("release");
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	68 09 83 10 80       	push   $0x80108309
80104f31:	e8 5a b4 ff ff       	call   80100390 <panic>
80104f36:	66 90                	xchg   %ax,%ax
80104f38:	66 90                	xchg   %ax,%ax
80104f3a:	66 90                	xchg   %ax,%ax
80104f3c:	66 90                	xchg   %ax,%ax
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	53                   	push   %ebx
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
80104f48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f4b:	f6 c2 03             	test   $0x3,%dl
80104f4e:	75 05                	jne    80104f55 <memset+0x15>
80104f50:	f6 c1 03             	test   $0x3,%cl
80104f53:	74 13                	je     80104f68 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f55:	89 d7                	mov    %edx,%edi
80104f57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5a:	fc                   	cld    
80104f5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f5d:	5b                   	pop    %ebx
80104f5e:	89 d0                	mov    %edx,%eax
80104f60:	5f                   	pop    %edi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret    
80104f63:	90                   	nop
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f6c:	c1 e9 02             	shr    $0x2,%ecx
80104f6f:	89 f8                	mov    %edi,%eax
80104f71:	89 fb                	mov    %edi,%ebx
80104f73:	c1 e0 18             	shl    $0x18,%eax
80104f76:	c1 e3 10             	shl    $0x10,%ebx
80104f79:	09 d8                	or     %ebx,%eax
80104f7b:	09 f8                	or     %edi,%eax
80104f7d:	c1 e7 08             	shl    $0x8,%edi
80104f80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f82:	89 d7                	mov    %edx,%edi
80104f84:	fc                   	cld    
80104f85:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f87:	5b                   	pop    %ebx
80104f88:	89 d0                	mov    %edx,%eax
80104f8a:	5f                   	pop    %edi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
80104f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f99:	8b 75 08             	mov    0x8(%ebp),%esi
80104f9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f9f:	85 db                	test   %ebx,%ebx
80104fa1:	74 29                	je     80104fcc <memcmp+0x3c>
    if(*s1 != *s2)
80104fa3:	0f b6 16             	movzbl (%esi),%edx
80104fa6:	0f b6 0f             	movzbl (%edi),%ecx
80104fa9:	38 d1                	cmp    %dl,%cl
80104fab:	75 2b                	jne    80104fd8 <memcmp+0x48>
80104fad:	b8 01 00 00 00       	mov    $0x1,%eax
80104fb2:	eb 14                	jmp    80104fc8 <memcmp+0x38>
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104fbc:	83 c0 01             	add    $0x1,%eax
80104fbf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104fc4:	38 ca                	cmp    %cl,%dl
80104fc6:	75 10                	jne    80104fd8 <memcmp+0x48>
  while(n-- > 0){
80104fc8:	39 d8                	cmp    %ebx,%eax
80104fca:	75 ec                	jne    80104fb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104fcc:	5b                   	pop    %ebx
  return 0;
80104fcd:	31 c0                	xor    %eax,%eax
}
80104fcf:	5e                   	pop    %esi
80104fd0:	5f                   	pop    %edi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret    
80104fd3:	90                   	nop
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104fd8:	0f b6 c2             	movzbl %dl,%eax
}
80104fdb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104fdc:	29 c8                	sub    %ecx,%eax
}
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret    
80104fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ffb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ffe:	39 c3                	cmp    %eax,%ebx
80105000:	73 26                	jae    80105028 <memmove+0x38>
80105002:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105005:	39 c8                	cmp    %ecx,%eax
80105007:	73 1f                	jae    80105028 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105009:	85 f6                	test   %esi,%esi
8010500b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010500e:	74 0f                	je     8010501f <memmove+0x2f>
      *--d = *--s;
80105010:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105014:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105017:	83 ea 01             	sub    $0x1,%edx
8010501a:	83 fa ff             	cmp    $0xffffffff,%edx
8010501d:	75 f1                	jne    80105010 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	90                   	nop
80105024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105028:	31 d2                	xor    %edx,%edx
8010502a:	85 f6                	test   %esi,%esi
8010502c:	74 f1                	je     8010501f <memmove+0x2f>
8010502e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105030:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105034:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105037:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010503a:	39 d6                	cmp    %edx,%esi
8010503c:	75 f2                	jne    80105030 <memmove+0x40>
}
8010503e:	5b                   	pop    %ebx
8010503f:	5e                   	pop    %esi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105053:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105054:	eb 9a                	jmp    80104ff0 <memmove>
80105056:	8d 76 00             	lea    0x0(%esi),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	8b 7d 10             	mov    0x10(%ebp),%edi
80105068:	53                   	push   %ebx
80105069:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010506c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010506f:	85 ff                	test   %edi,%edi
80105071:	74 2f                	je     801050a2 <strncmp+0x42>
80105073:	0f b6 01             	movzbl (%ecx),%eax
80105076:	0f b6 1e             	movzbl (%esi),%ebx
80105079:	84 c0                	test   %al,%al
8010507b:	74 37                	je     801050b4 <strncmp+0x54>
8010507d:	38 c3                	cmp    %al,%bl
8010507f:	75 33                	jne    801050b4 <strncmp+0x54>
80105081:	01 f7                	add    %esi,%edi
80105083:	eb 13                	jmp    80105098 <strncmp+0x38>
80105085:	8d 76 00             	lea    0x0(%esi),%esi
80105088:	0f b6 01             	movzbl (%ecx),%eax
8010508b:	84 c0                	test   %al,%al
8010508d:	74 21                	je     801050b0 <strncmp+0x50>
8010508f:	0f b6 1a             	movzbl (%edx),%ebx
80105092:	89 d6                	mov    %edx,%esi
80105094:	38 d8                	cmp    %bl,%al
80105096:	75 1c                	jne    801050b4 <strncmp+0x54>
    n--, p++, q++;
80105098:	8d 56 01             	lea    0x1(%esi),%edx
8010509b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010509e:	39 fa                	cmp    %edi,%edx
801050a0:	75 e6                	jne    80105088 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801050a2:	5b                   	pop    %ebx
    return 0;
801050a3:	31 c0                	xor    %eax,%eax
}
801050a5:	5e                   	pop    %esi
801050a6:	5f                   	pop    %edi
801050a7:	5d                   	pop    %ebp
801050a8:	c3                   	ret    
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801050b4:	29 d8                	sub    %ebx,%eax
}
801050b6:	5b                   	pop    %ebx
801050b7:	5e                   	pop    %esi
801050b8:	5f                   	pop    %edi
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    
801050bb:	90                   	nop
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	8b 45 08             	mov    0x8(%ebp),%eax
801050c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050ce:	89 c2                	mov    %eax,%edx
801050d0:	eb 19                	jmp    801050eb <strncpy+0x2b>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801050df:	83 c2 01             	add    $0x1,%edx
801050e2:	84 c9                	test   %cl,%cl
801050e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050e7:	74 09                	je     801050f2 <strncpy+0x32>
801050e9:	89 f1                	mov    %esi,%ecx
801050eb:	85 c9                	test   %ecx,%ecx
801050ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050f0:	7f e6                	jg     801050d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050f2:	31 c9                	xor    %ecx,%ecx
801050f4:	85 f6                	test   %esi,%esi
801050f6:	7e 17                	jle    8010510f <strncpy+0x4f>
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105100:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105104:	89 f3                	mov    %esi,%ebx
80105106:	83 c1 01             	add    $0x1,%ecx
80105109:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010510b:	85 db                	test   %ebx,%ebx
8010510d:	7f f1                	jg     80105100 <strncpy+0x40>
  return os;
}
8010510f:	5b                   	pop    %ebx
80105110:	5e                   	pop    %esi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105128:	8b 45 08             	mov    0x8(%ebp),%eax
8010512b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010512e:	85 c9                	test   %ecx,%ecx
80105130:	7e 26                	jle    80105158 <safestrcpy+0x38>
80105132:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105136:	89 c1                	mov    %eax,%ecx
80105138:	eb 17                	jmp    80105151 <safestrcpy+0x31>
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105140:	83 c2 01             	add    $0x1,%edx
80105143:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105147:	83 c1 01             	add    $0x1,%ecx
8010514a:	84 db                	test   %bl,%bl
8010514c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010514f:	74 04                	je     80105155 <safestrcpy+0x35>
80105151:	39 f2                	cmp    %esi,%edx
80105153:	75 eb                	jne    80105140 <safestrcpy+0x20>
    ;
  *s = 0;
80105155:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105158:	5b                   	pop    %ebx
80105159:	5e                   	pop    %esi
8010515a:	5d                   	pop    %ebp
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <strlen>:

int
strlen(const char *s)
{
80105160:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105168:	80 3a 00             	cmpb   $0x0,(%edx)
8010516b:	74 0c                	je     80105179 <strlen+0x19>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c0 01             	add    $0x1,%eax
80105173:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105177:	75 f7                	jne    80105170 <strlen+0x10>
    ;
  return n;
}
80105179:	5d                   	pop    %ebp
8010517a:	c3                   	ret    

8010517b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010517b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010517f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105183:	55                   	push   %ebp
  pushl %ebx
80105184:	53                   	push   %ebx
  pushl %esi
80105185:	56                   	push   %esi
  pushl %edi
80105186:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105187:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105189:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010518b:	5f                   	pop    %edi
  popl %esi
8010518c:	5e                   	pop    %esi
  popl %ebx
8010518d:	5b                   	pop    %ebx
  popl %ebp
8010518e:	5d                   	pop    %ebp
  ret
8010518f:	c3                   	ret    

80105190 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 04             	sub    $0x4,%esp
80105197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010519a:	e8 d1 e7 ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010519f:	8b 00                	mov    (%eax),%eax
801051a1:	39 d8                	cmp    %ebx,%eax
801051a3:	76 1b                	jbe    801051c0 <fetchint+0x30>
801051a5:	8d 53 04             	lea    0x4(%ebx),%edx
801051a8:	39 d0                	cmp    %edx,%eax
801051aa:	72 14                	jb     801051c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801051af:	8b 13                	mov    (%ebx),%edx
801051b1:	89 10                	mov    %edx,(%eax)
  return 0;
801051b3:	31 c0                	xor    %eax,%eax
}
801051b5:	83 c4 04             	add    $0x4,%esp
801051b8:	5b                   	pop    %ebx
801051b9:	5d                   	pop    %ebp
801051ba:	c3                   	ret    
801051bb:	90                   	nop
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb ee                	jmp    801051b5 <fetchint+0x25>
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	53                   	push   %ebx
801051d4:	83 ec 04             	sub    $0x4,%esp
801051d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051da:	e8 91 e7 ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz)
801051df:	39 18                	cmp    %ebx,(%eax)
801051e1:	76 29                	jbe    8010520c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801051e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051e6:	89 da                	mov    %ebx,%edx
801051e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801051ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801051ec:	39 c3                	cmp    %eax,%ebx
801051ee:	73 1c                	jae    8010520c <fetchstr+0x3c>
    if(*s == 0)
801051f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801051f3:	75 10                	jne    80105205 <fetchstr+0x35>
801051f5:	eb 39                	jmp    80105230 <fetchstr+0x60>
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105200:	80 3a 00             	cmpb   $0x0,(%edx)
80105203:	74 1b                	je     80105220 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105205:	83 c2 01             	add    $0x1,%edx
80105208:	39 d0                	cmp    %edx,%eax
8010520a:	77 f4                	ja     80105200 <fetchstr+0x30>
    return -1;
8010520c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105211:	83 c4 04             	add    $0x4,%esp
80105214:	5b                   	pop    %ebx
80105215:	5d                   	pop    %ebp
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105220:	83 c4 04             	add    $0x4,%esp
80105223:	89 d0                	mov    %edx,%eax
80105225:	29 d8                	sub    %ebx,%eax
80105227:	5b                   	pop    %ebx
80105228:	5d                   	pop    %ebp
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105230:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105232:	eb dd                	jmp    80105211 <fetchstr+0x41>
80105234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010523a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105240 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	56                   	push   %esi
80105244:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105245:	e8 26 e7 ff ff       	call   80103970 <myproc>
8010524a:	8b 40 18             	mov    0x18(%eax),%eax
8010524d:	8b 55 08             	mov    0x8(%ebp),%edx
80105250:	8b 40 44             	mov    0x44(%eax),%eax
80105253:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105256:	e8 15 e7 ff ff       	call   80103970 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010525b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010525d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105260:	39 c6                	cmp    %eax,%esi
80105262:	73 1c                	jae    80105280 <argint+0x40>
80105264:	8d 53 08             	lea    0x8(%ebx),%edx
80105267:	39 d0                	cmp    %edx,%eax
80105269:	72 15                	jb     80105280 <argint+0x40>
  *ip = *(int*)(addr);
8010526b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526e:	8b 53 04             	mov    0x4(%ebx),%edx
80105271:	89 10                	mov    %edx,(%eax)
  return 0;
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	5b                   	pop    %ebx
80105276:	5e                   	pop    %esi
80105277:	5d                   	pop    %ebp
80105278:	c3                   	ret    
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105285:	eb ee                	jmp    80105275 <argint+0x35>
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
80105295:	83 ec 10             	sub    $0x10,%esp
80105298:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010529b:	e8 d0 e6 ff ff       	call   80103970 <myproc>
801052a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801052a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a5:	83 ec 08             	sub    $0x8,%esp
801052a8:	50                   	push   %eax
801052a9:	ff 75 08             	pushl  0x8(%ebp)
801052ac:	e8 8f ff ff ff       	call   80105240 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	85 c0                	test   %eax,%eax
801052b6:	78 28                	js     801052e0 <argptr+0x50>
801052b8:	85 db                	test   %ebx,%ebx
801052ba:	78 24                	js     801052e0 <argptr+0x50>
801052bc:	8b 16                	mov    (%esi),%edx
801052be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c1:	39 c2                	cmp    %eax,%edx
801052c3:	76 1b                	jbe    801052e0 <argptr+0x50>
801052c5:	01 c3                	add    %eax,%ebx
801052c7:	39 da                	cmp    %ebx,%edx
801052c9:	72 15                	jb     801052e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801052ce:	89 02                	mov    %eax,(%edx)
  return 0;
801052d0:	31 c0                	xor    %eax,%eax
}
801052d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e5:	eb eb                	jmp    801052d2 <argptr+0x42>
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f9:	50                   	push   %eax
801052fa:	ff 75 08             	pushl  0x8(%ebp)
801052fd:	e8 3e ff ff ff       	call   80105240 <argint>
80105302:	83 c4 10             	add    $0x10,%esp
80105305:	85 c0                	test   %eax,%eax
80105307:	78 17                	js     80105320 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105309:	83 ec 08             	sub    $0x8,%esp
8010530c:	ff 75 0c             	pushl  0xc(%ebp)
8010530f:	ff 75 f4             	pushl  -0xc(%ebp)
80105312:	e8 b9 fe ff ff       	call   801051d0 <fetchstr>
80105317:	83 c4 10             	add    $0x10,%esp
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <syscall>:
[SYS_printInfo] sys_printInfo,
};

void
syscall(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105337:	e8 34 e6 ff ff       	call   80103970 <myproc>
8010533c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010533e:	8b 40 18             	mov    0x18(%eax),%eax
80105341:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105344:	8d 50 ff             	lea    -0x1(%eax),%edx
80105347:	83 fa 18             	cmp    $0x18,%edx
8010534a:	77 1c                	ja     80105368 <syscall+0x38>
8010534c:	8b 14 85 40 83 10 80 	mov    -0x7fef7cc0(,%eax,4),%edx
80105353:	85 d2                	test   %edx,%edx
80105355:	74 11                	je     80105368 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105357:	ff d2                	call   *%edx
80105359:	8b 53 18             	mov    0x18(%ebx),%edx
8010535c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010535f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105362:	c9                   	leave  
80105363:	c3                   	ret    
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105368:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105369:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010536c:	50                   	push   %eax
8010536d:	ff 73 10             	pushl  0x10(%ebx)
80105370:	68 11 83 10 80       	push   $0x80108311
80105375:	e8 e6 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010537a:	8b 43 18             	mov    0x18(%ebx),%eax
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	66 90                	xchg   %ax,%ax
8010538e:	66 90                	xchg   %ax,%ax

80105390 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105396:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105399:	83 ec 34             	sub    $0x34,%esp
8010539c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010539f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053a2:	56                   	push   %esi
801053a3:	50                   	push   %eax
{
801053a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053aa:	e8 71 cb ff ff       	call   80101f20 <nameiparent>
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	85 c0                	test   %eax,%eax
801053b4:	0f 84 46 01 00 00    	je     80105500 <create+0x170>
    return 0;
  ilock(dp);
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	89 c3                	mov    %eax,%ebx
801053bf:	50                   	push   %eax
801053c0:	e8 db c2 ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053c5:	83 c4 0c             	add    $0xc,%esp
801053c8:	6a 00                	push   $0x0
801053ca:	56                   	push   %esi
801053cb:	53                   	push   %ebx
801053cc:	e8 ff c7 ff ff       	call   80101bd0 <dirlookup>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	85 c0                	test   %eax,%eax
801053d6:	89 c7                	mov    %eax,%edi
801053d8:	74 36                	je     80105410 <create+0x80>
    iunlockput(dp);
801053da:	83 ec 0c             	sub    $0xc,%esp
801053dd:	53                   	push   %ebx
801053de:	e8 4d c5 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
801053e3:	89 3c 24             	mov    %edi,(%esp)
801053e6:	e8 b5 c2 ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053eb:	83 c4 10             	add    $0x10,%esp
801053ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053f3:	0f 85 97 00 00 00    	jne    80105490 <create+0x100>
801053f9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801053fe:	0f 85 8c 00 00 00    	jne    80105490 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105404:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105407:	89 f8                	mov    %edi,%eax
80105409:	5b                   	pop    %ebx
8010540a:	5e                   	pop    %esi
8010540b:	5f                   	pop    %edi
8010540c:	5d                   	pop    %ebp
8010540d:	c3                   	ret    
8010540e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105410:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	50                   	push   %eax
80105418:	ff 33                	pushl  (%ebx)
8010541a:	e8 11 c1 ff ff       	call   80101530 <ialloc>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	89 c7                	mov    %eax,%edi
80105426:	0f 84 e8 00 00 00    	je     80105514 <create+0x184>
  ilock(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	50                   	push   %eax
80105430:	e8 6b c2 ff ff       	call   801016a0 <ilock>
  ip->major = major;
80105435:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105439:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010543d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105441:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105445:	b8 01 00 00 00       	mov    $0x1,%eax
8010544a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010544e:	89 3c 24             	mov    %edi,(%esp)
80105451:	e8 9a c1 ff ff       	call   801015f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010545e:	74 50                	je     801054b0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105460:	83 ec 04             	sub    $0x4,%esp
80105463:	ff 77 04             	pushl  0x4(%edi)
80105466:	56                   	push   %esi
80105467:	53                   	push   %ebx
80105468:	e8 d3 c9 ff ff       	call   80101e40 <dirlink>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	0f 88 8f 00 00 00    	js     80105507 <create+0x177>
  iunlockput(dp);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	53                   	push   %ebx
8010547c:	e8 af c4 ff ff       	call   80101930 <iunlockput>
  return ip;
80105481:	83 c4 10             	add    $0x10,%esp
}
80105484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105487:	89 f8                	mov    %edi,%eax
80105489:	5b                   	pop    %ebx
8010548a:	5e                   	pop    %esi
8010548b:	5f                   	pop    %edi
8010548c:	5d                   	pop    %ebp
8010548d:	c3                   	ret    
8010548e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	57                   	push   %edi
    return 0;
80105494:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105496:	e8 95 c4 ff ff       	call   80101930 <iunlockput>
    return 0;
8010549b:	83 c4 10             	add    $0x10,%esp
}
8010549e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a1:	89 f8                	mov    %edi,%eax
801054a3:	5b                   	pop    %ebx
801054a4:	5e                   	pop    %esi
801054a5:	5f                   	pop    %edi
801054a6:	5d                   	pop    %ebp
801054a7:	c3                   	ret    
801054a8:	90                   	nop
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801054b0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	53                   	push   %ebx
801054b9:	e8 32 c1 ff ff       	call   801015f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054be:	83 c4 0c             	add    $0xc,%esp
801054c1:	ff 77 04             	pushl  0x4(%edi)
801054c4:	68 c4 83 10 80       	push   $0x801083c4
801054c9:	57                   	push   %edi
801054ca:	e8 71 c9 ff ff       	call   80101e40 <dirlink>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	85 c0                	test   %eax,%eax
801054d4:	78 1c                	js     801054f2 <create+0x162>
801054d6:	83 ec 04             	sub    $0x4,%esp
801054d9:	ff 73 04             	pushl  0x4(%ebx)
801054dc:	68 c3 83 10 80       	push   $0x801083c3
801054e1:	57                   	push   %edi
801054e2:	e8 59 c9 ff ff       	call   80101e40 <dirlink>
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	85 c0                	test   %eax,%eax
801054ec:	0f 89 6e ff ff ff    	jns    80105460 <create+0xd0>
      panic("create dots");
801054f2:	83 ec 0c             	sub    $0xc,%esp
801054f5:	68 b7 83 10 80       	push   $0x801083b7
801054fa:	e8 91 ae ff ff       	call   80100390 <panic>
801054ff:	90                   	nop
    return 0;
80105500:	31 ff                	xor    %edi,%edi
80105502:	e9 fd fe ff ff       	jmp    80105404 <create+0x74>
    panic("create: dirlink");
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	68 c6 83 10 80       	push   $0x801083c6
8010550f:	e8 7c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105514:	83 ec 0c             	sub    $0xc,%esp
80105517:	68 a8 83 10 80       	push   $0x801083a8
8010551c:	e8 6f ae ff ff       	call   80100390 <panic>
80105521:	eb 0d                	jmp    80105530 <argfd.constprop.0>
80105523:	90                   	nop
80105524:	90                   	nop
80105525:	90                   	nop
80105526:	90                   	nop
80105527:	90                   	nop
80105528:	90                   	nop
80105529:	90                   	nop
8010552a:	90                   	nop
8010552b:	90                   	nop
8010552c:	90                   	nop
8010552d:	90                   	nop
8010552e:	90                   	nop
8010552f:	90                   	nop

80105530 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
80105535:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105537:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010553a:	89 d6                	mov    %edx,%esi
8010553c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553f:	50                   	push   %eax
80105540:	6a 00                	push   $0x0
80105542:	e8 f9 fc ff ff       	call   80105240 <argint>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	78 2a                	js     80105578 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105552:	77 24                	ja     80105578 <argfd.constprop.0+0x48>
80105554:	e8 17 e4 ff ff       	call   80103970 <myproc>
80105559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105560:	85 c0                	test   %eax,%eax
80105562:	74 14                	je     80105578 <argfd.constprop.0+0x48>
  if(pfd)
80105564:	85 db                	test   %ebx,%ebx
80105566:	74 02                	je     8010556a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105568:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010556a:	89 06                	mov    %eax,(%esi)
  return 0;
8010556c:	31 c0                	xor    %eax,%eax
}
8010556e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105571:	5b                   	pop    %ebx
80105572:	5e                   	pop    %esi
80105573:	5d                   	pop    %ebp
80105574:	c3                   	ret    
80105575:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb ef                	jmp    8010556e <argfd.constprop.0+0x3e>
8010557f:	90                   	nop

80105580 <sys_dup>:
{
80105580:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105581:	31 c0                	xor    %eax,%eax
{
80105583:	89 e5                	mov    %esp,%ebp
80105585:	56                   	push   %esi
80105586:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105587:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010558a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010558d:	e8 9e ff ff ff       	call   80105530 <argfd.constprop.0>
80105592:	85 c0                	test   %eax,%eax
80105594:	78 42                	js     801055d8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105596:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105599:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010559b:	e8 d0 e3 ff ff       	call   80103970 <myproc>
801055a0:	eb 0e                	jmp    801055b0 <sys_dup+0x30>
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055a8:	83 c3 01             	add    $0x1,%ebx
801055ab:	83 fb 10             	cmp    $0x10,%ebx
801055ae:	74 28                	je     801055d8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801055b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055b4:	85 d2                	test   %edx,%edx
801055b6:	75 f0                	jne    801055a8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801055b8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055bc:	83 ec 0c             	sub    $0xc,%esp
801055bf:	ff 75 f4             	pushl  -0xc(%ebp)
801055c2:	e8 49 b8 ff ff       	call   80100e10 <filedup>
  return fd;
801055c7:	83 c4 10             	add    $0x10,%esp
}
801055ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055cd:	89 d8                	mov    %ebx,%eax
801055cf:	5b                   	pop    %ebx
801055d0:	5e                   	pop    %esi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	90                   	nop
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055e0:	89 d8                	mov    %ebx,%eax
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5d                   	pop    %ebp
801055e5:	c3                   	ret    
801055e6:	8d 76 00             	lea    0x0(%esi),%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_read>:
{
801055f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f1:	31 c0                	xor    %eax,%eax
{
801055f3:	89 e5                	mov    %esp,%ebp
801055f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055fb:	e8 30 ff ff ff       	call   80105530 <argfd.constprop.0>
80105600:	85 c0                	test   %eax,%eax
80105602:	78 4c                	js     80105650 <sys_read+0x60>
80105604:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105607:	83 ec 08             	sub    $0x8,%esp
8010560a:	50                   	push   %eax
8010560b:	6a 02                	push   $0x2
8010560d:	e8 2e fc ff ff       	call   80105240 <argint>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	78 37                	js     80105650 <sys_read+0x60>
80105619:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561c:	83 ec 04             	sub    $0x4,%esp
8010561f:	ff 75 f0             	pushl  -0x10(%ebp)
80105622:	50                   	push   %eax
80105623:	6a 01                	push   $0x1
80105625:	e8 66 fc ff ff       	call   80105290 <argptr>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	78 1f                	js     80105650 <sys_read+0x60>
  return fileread(f, p, n);
80105631:	83 ec 04             	sub    $0x4,%esp
80105634:	ff 75 f0             	pushl  -0x10(%ebp)
80105637:	ff 75 f4             	pushl  -0xc(%ebp)
8010563a:	ff 75 ec             	pushl  -0x14(%ebp)
8010563d:	e8 3e b9 ff ff       	call   80100f80 <fileread>
80105642:	83 c4 10             	add    $0x10,%esp
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_write>:
{
80105660:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105661:	31 c0                	xor    %eax,%eax
{
80105663:	89 e5                	mov    %esp,%ebp
80105665:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105668:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010566b:	e8 c0 fe ff ff       	call   80105530 <argfd.constprop.0>
80105670:	85 c0                	test   %eax,%eax
80105672:	78 4c                	js     801056c0 <sys_write+0x60>
80105674:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105677:	83 ec 08             	sub    $0x8,%esp
8010567a:	50                   	push   %eax
8010567b:	6a 02                	push   $0x2
8010567d:	e8 be fb ff ff       	call   80105240 <argint>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	78 37                	js     801056c0 <sys_write+0x60>
80105689:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568c:	83 ec 04             	sub    $0x4,%esp
8010568f:	ff 75 f0             	pushl  -0x10(%ebp)
80105692:	50                   	push   %eax
80105693:	6a 01                	push   $0x1
80105695:	e8 f6 fb ff ff       	call   80105290 <argptr>
8010569a:	83 c4 10             	add    $0x10,%esp
8010569d:	85 c0                	test   %eax,%eax
8010569f:	78 1f                	js     801056c0 <sys_write+0x60>
  return filewrite(f, p, n);
801056a1:	83 ec 04             	sub    $0x4,%esp
801056a4:	ff 75 f0             	pushl  -0x10(%ebp)
801056a7:	ff 75 f4             	pushl  -0xc(%ebp)
801056aa:	ff 75 ec             	pushl  -0x14(%ebp)
801056ad:	e8 5e b9 ff ff       	call   80101010 <filewrite>
801056b2:	83 c4 10             	add    $0x10,%esp
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <sys_close>:
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056dc:	e8 4f fe ff ff       	call   80105530 <argfd.constprop.0>
801056e1:	85 c0                	test   %eax,%eax
801056e3:	78 2b                	js     80105710 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056e5:	e8 86 e2 ff ff       	call   80103970 <myproc>
801056ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056ed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056f0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056f7:	00 
  fileclose(f);
801056f8:	ff 75 f4             	pushl  -0xc(%ebp)
801056fb:	e8 60 b7 ff ff       	call   80100e60 <fileclose>
  return 0;
80105700:	83 c4 10             	add    $0x10,%esp
80105703:	31 c0                	xor    %eax,%eax
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    
80105707:	89 f6                	mov    %esi,%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_fstat>:
{
80105720:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105721:	31 c0                	xor    %eax,%eax
{
80105723:	89 e5                	mov    %esp,%ebp
80105725:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105728:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010572b:	e8 00 fe ff ff       	call   80105530 <argfd.constprop.0>
80105730:	85 c0                	test   %eax,%eax
80105732:	78 2c                	js     80105760 <sys_fstat+0x40>
80105734:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105737:	83 ec 04             	sub    $0x4,%esp
8010573a:	6a 14                	push   $0x14
8010573c:	50                   	push   %eax
8010573d:	6a 01                	push   $0x1
8010573f:	e8 4c fb ff ff       	call   80105290 <argptr>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	85 c0                	test   %eax,%eax
80105749:	78 15                	js     80105760 <sys_fstat+0x40>
  return filestat(f, st);
8010574b:	83 ec 08             	sub    $0x8,%esp
8010574e:	ff 75 f4             	pushl  -0xc(%ebp)
80105751:	ff 75 f0             	pushl  -0x10(%ebp)
80105754:	e8 d7 b7 ff ff       	call   80100f30 <filestat>
80105759:	83 c4 10             	add    $0x10,%esp
}
8010575c:	c9                   	leave  
8010575d:	c3                   	ret    
8010575e:	66 90                	xchg   %ax,%ax
    return -1;
80105760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <sys_link>:
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105776:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105779:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010577c:	50                   	push   %eax
8010577d:	6a 00                	push   $0x0
8010577f:	e8 6c fb ff ff       	call   801052f0 <argstr>
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	85 c0                	test   %eax,%eax
80105789:	0f 88 fb 00 00 00    	js     8010588a <sys_link+0x11a>
8010578f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105792:	83 ec 08             	sub    $0x8,%esp
80105795:	50                   	push   %eax
80105796:	6a 01                	push   $0x1
80105798:	e8 53 fb ff ff       	call   801052f0 <argstr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	0f 88 e2 00 00 00    	js     8010588a <sys_link+0x11a>
  begin_op();
801057a8:	e8 13 d4 ff ff       	call   80102bc0 <begin_op>
  if((ip = namei(old)) == 0){
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801057b3:	e8 48 c7 ff ff       	call   80101f00 <namei>
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	85 c0                	test   %eax,%eax
801057bd:	89 c3                	mov    %eax,%ebx
801057bf:	0f 84 ea 00 00 00    	je     801058af <sys_link+0x13f>
  ilock(ip);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	50                   	push   %eax
801057c9:	e8 d2 be ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057d6:	0f 84 bb 00 00 00    	je     80105897 <sys_link+0x127>
  ip->nlink++;
801057dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801057e1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801057e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057e7:	53                   	push   %ebx
801057e8:	e8 03 be ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
801057ed:	89 1c 24             	mov    %ebx,(%esp)
801057f0:	e8 8b bf ff ff       	call   80101780 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057f5:	58                   	pop    %eax
801057f6:	5a                   	pop    %edx
801057f7:	57                   	push   %edi
801057f8:	ff 75 d0             	pushl  -0x30(%ebp)
801057fb:	e8 20 c7 ff ff       	call   80101f20 <nameiparent>
80105800:	83 c4 10             	add    $0x10,%esp
80105803:	85 c0                	test   %eax,%eax
80105805:	89 c6                	mov    %eax,%esi
80105807:	74 5b                	je     80105864 <sys_link+0xf4>
  ilock(dp);
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	50                   	push   %eax
8010580d:	e8 8e be ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	8b 03                	mov    (%ebx),%eax
80105817:	39 06                	cmp    %eax,(%esi)
80105819:	75 3d                	jne    80105858 <sys_link+0xe8>
8010581b:	83 ec 04             	sub    $0x4,%esp
8010581e:	ff 73 04             	pushl  0x4(%ebx)
80105821:	57                   	push   %edi
80105822:	56                   	push   %esi
80105823:	e8 18 c6 ff ff       	call   80101e40 <dirlink>
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	85 c0                	test   %eax,%eax
8010582d:	78 29                	js     80105858 <sys_link+0xe8>
  iunlockput(dp);
8010582f:	83 ec 0c             	sub    $0xc,%esp
80105832:	56                   	push   %esi
80105833:	e8 f8 c0 ff ff       	call   80101930 <iunlockput>
  iput(ip);
80105838:	89 1c 24             	mov    %ebx,(%esp)
8010583b:	e8 90 bf ff ff       	call   801017d0 <iput>
  end_op();
80105840:	e8 eb d3 ff ff       	call   80102c30 <end_op>
  return 0;
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	31 c0                	xor    %eax,%eax
}
8010584a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010584d:	5b                   	pop    %ebx
8010584e:	5e                   	pop    %esi
8010584f:	5f                   	pop    %edi
80105850:	5d                   	pop    %ebp
80105851:	c3                   	ret    
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	56                   	push   %esi
8010585c:	e8 cf c0 ff ff       	call   80101930 <iunlockput>
    goto bad;
80105861:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105864:	83 ec 0c             	sub    $0xc,%esp
80105867:	53                   	push   %ebx
80105868:	e8 33 be ff ff       	call   801016a0 <ilock>
  ip->nlink--;
8010586d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105872:	89 1c 24             	mov    %ebx,(%esp)
80105875:	e8 76 bd ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010587a:	89 1c 24             	mov    %ebx,(%esp)
8010587d:	e8 ae c0 ff ff       	call   80101930 <iunlockput>
  end_op();
80105882:	e8 a9 d3 ff ff       	call   80102c30 <end_op>
  return -1;
80105887:	83 c4 10             	add    $0x10,%esp
}
8010588a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010588d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5f                   	pop    %edi
80105895:	5d                   	pop    %ebp
80105896:	c3                   	ret    
    iunlockput(ip);
80105897:	83 ec 0c             	sub    $0xc,%esp
8010589a:	53                   	push   %ebx
8010589b:	e8 90 c0 ff ff       	call   80101930 <iunlockput>
    end_op();
801058a0:	e8 8b d3 ff ff       	call   80102c30 <end_op>
    return -1;
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ad:	eb 9b                	jmp    8010584a <sys_link+0xda>
    end_op();
801058af:	e8 7c d3 ff ff       	call   80102c30 <end_op>
    return -1;
801058b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b9:	eb 8f                	jmp    8010584a <sys_link+0xda>
801058bb:	90                   	nop
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_unlink>:
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801058c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801058cc:	50                   	push   %eax
801058cd:	6a 00                	push   $0x0
801058cf:	e8 1c fa ff ff       	call   801052f0 <argstr>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	0f 88 77 01 00 00    	js     80105a56 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801058df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801058e2:	e8 d9 d2 ff ff       	call   80102bc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058e7:	83 ec 08             	sub    $0x8,%esp
801058ea:	53                   	push   %ebx
801058eb:	ff 75 c0             	pushl  -0x40(%ebp)
801058ee:	e8 2d c6 ff ff       	call   80101f20 <nameiparent>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	89 c6                	mov    %eax,%esi
801058fa:	0f 84 60 01 00 00    	je     80105a60 <sys_unlink+0x1a0>
  ilock(dp);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	50                   	push   %eax
80105904:	e8 97 bd ff ff       	call   801016a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105909:	58                   	pop    %eax
8010590a:	5a                   	pop    %edx
8010590b:	68 c4 83 10 80       	push   $0x801083c4
80105910:	53                   	push   %ebx
80105911:	e8 9a c2 ff ff       	call   80101bb0 <namecmp>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	0f 84 03 01 00 00    	je     80105a24 <sys_unlink+0x164>
80105921:	83 ec 08             	sub    $0x8,%esp
80105924:	68 c3 83 10 80       	push   $0x801083c3
80105929:	53                   	push   %ebx
8010592a:	e8 81 c2 ff ff       	call   80101bb0 <namecmp>
8010592f:	83 c4 10             	add    $0x10,%esp
80105932:	85 c0                	test   %eax,%eax
80105934:	0f 84 ea 00 00 00    	je     80105a24 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010593a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010593d:	83 ec 04             	sub    $0x4,%esp
80105940:	50                   	push   %eax
80105941:	53                   	push   %ebx
80105942:	56                   	push   %esi
80105943:	e8 88 c2 ff ff       	call   80101bd0 <dirlookup>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	89 c3                	mov    %eax,%ebx
8010594f:	0f 84 cf 00 00 00    	je     80105a24 <sys_unlink+0x164>
  ilock(ip);
80105955:	83 ec 0c             	sub    $0xc,%esp
80105958:	50                   	push   %eax
80105959:	e8 42 bd ff ff       	call   801016a0 <ilock>
  if(ip->nlink < 1)
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105966:	0f 8e 10 01 00 00    	jle    80105a7c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010596c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105971:	74 6d                	je     801059e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105973:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105976:	83 ec 04             	sub    $0x4,%esp
80105979:	6a 10                	push   $0x10
8010597b:	6a 00                	push   $0x0
8010597d:	50                   	push   %eax
8010597e:	e8 bd f5 ff ff       	call   80104f40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105983:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105986:	6a 10                	push   $0x10
80105988:	ff 75 c4             	pushl  -0x3c(%ebp)
8010598b:	50                   	push   %eax
8010598c:	56                   	push   %esi
8010598d:	e8 ee c0 ff ff       	call   80101a80 <writei>
80105992:	83 c4 20             	add    $0x20,%esp
80105995:	83 f8 10             	cmp    $0x10,%eax
80105998:	0f 85 eb 00 00 00    	jne    80105a89 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010599e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059a3:	0f 84 97 00 00 00    	je     80105a40 <sys_unlink+0x180>
  iunlockput(dp);
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	56                   	push   %esi
801059ad:	e8 7e bf ff ff       	call   80101930 <iunlockput>
  ip->nlink--;
801059b2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059b7:	89 1c 24             	mov    %ebx,(%esp)
801059ba:	e8 31 bc ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801059bf:	89 1c 24             	mov    %ebx,(%esp)
801059c2:	e8 69 bf ff ff       	call   80101930 <iunlockput>
  end_op();
801059c7:	e8 64 d2 ff ff       	call   80102c30 <end_op>
  return 0;
801059cc:	83 c4 10             	add    $0x10,%esp
801059cf:	31 c0                	xor    %eax,%eax
}
801059d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059e4:	76 8d                	jbe    80105973 <sys_unlink+0xb3>
801059e6:	bf 20 00 00 00       	mov    $0x20,%edi
801059eb:	eb 0f                	jmp    801059fc <sys_unlink+0x13c>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
801059f0:	83 c7 10             	add    $0x10,%edi
801059f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801059f6:	0f 83 77 ff ff ff    	jae    80105973 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059ff:	6a 10                	push   $0x10
80105a01:	57                   	push   %edi
80105a02:	50                   	push   %eax
80105a03:	53                   	push   %ebx
80105a04:	e8 77 bf ff ff       	call   80101980 <readi>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	83 f8 10             	cmp    $0x10,%eax
80105a0f:	75 5e                	jne    80105a6f <sys_unlink+0x1af>
    if(de.inum != 0)
80105a11:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a16:	74 d8                	je     801059f0 <sys_unlink+0x130>
    iunlockput(ip);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	53                   	push   %ebx
80105a1c:	e8 0f bf ff ff       	call   80101930 <iunlockput>
    goto bad;
80105a21:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	56                   	push   %esi
80105a28:	e8 03 bf ff ff       	call   80101930 <iunlockput>
  end_op();
80105a2d:	e8 fe d1 ff ff       	call   80102c30 <end_op>
  return -1;
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb 95                	jmp    801059d1 <sys_unlink+0x111>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105a40:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a45:	83 ec 0c             	sub    $0xc,%esp
80105a48:	56                   	push   %esi
80105a49:	e8 a2 bb ff ff       	call   801015f0 <iupdate>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	e9 53 ff ff ff       	jmp    801059a9 <sys_unlink+0xe9>
    return -1;
80105a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5b:	e9 71 ff ff ff       	jmp    801059d1 <sys_unlink+0x111>
    end_op();
80105a60:	e8 cb d1 ff ff       	call   80102c30 <end_op>
    return -1;
80105a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6a:	e9 62 ff ff ff       	jmp    801059d1 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	68 e8 83 10 80       	push   $0x801083e8
80105a77:	e8 14 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a7c:	83 ec 0c             	sub    $0xc,%esp
80105a7f:	68 d6 83 10 80       	push   $0x801083d6
80105a84:	e8 07 a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	68 fa 83 10 80       	push   $0x801083fa
80105a91:	e8 fa a8 ff ff       	call   80100390 <panic>
80105a96:	8d 76 00             	lea    0x0(%esi),%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_open>:

int
sys_open(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aa6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105aa9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aac:	50                   	push   %eax
80105aad:	6a 00                	push   $0x0
80105aaf:	e8 3c f8 ff ff       	call   801052f0 <argstr>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	0f 88 1d 01 00 00    	js     80105bdc <sys_open+0x13c>
80105abf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac2:	83 ec 08             	sub    $0x8,%esp
80105ac5:	50                   	push   %eax
80105ac6:	6a 01                	push   $0x1
80105ac8:	e8 73 f7 ff ff       	call   80105240 <argint>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	0f 88 04 01 00 00    	js     80105bdc <sys_open+0x13c>
    return -1;

  begin_op();
80105ad8:	e8 e3 d0 ff ff       	call   80102bc0 <begin_op>

  if(omode & O_CREATE){
80105add:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ae1:	0f 85 a9 00 00 00    	jne    80105b90 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ae7:	83 ec 0c             	sub    $0xc,%esp
80105aea:	ff 75 e0             	pushl  -0x20(%ebp)
80105aed:	e8 0e c4 ff ff       	call   80101f00 <namei>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	89 c6                	mov    %eax,%esi
80105af9:	0f 84 b2 00 00 00    	je     80105bb1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	50                   	push   %eax
80105b03:	e8 98 bb ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b10:	0f 84 aa 00 00 00    	je     80105bc0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b16:	e8 85 b2 ff ff       	call   80100da0 <filealloc>
80105b1b:	85 c0                	test   %eax,%eax
80105b1d:	89 c7                	mov    %eax,%edi
80105b1f:	0f 84 a6 00 00 00    	je     80105bcb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105b25:	e8 46 de ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b2a:	31 db                	xor    %ebx,%ebx
80105b2c:	eb 0e                	jmp    80105b3c <sys_open+0x9c>
80105b2e:	66 90                	xchg   %ax,%ax
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	83 fb 10             	cmp    $0x10,%ebx
80105b36:	0f 84 ac 00 00 00    	je     80105be8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b3c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b40:	85 d2                	test   %edx,%edx
80105b42:	75 ec                	jne    80105b30 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b44:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b47:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b4b:	56                   	push   %esi
80105b4c:	e8 2f bc ff ff       	call   80101780 <iunlock>
  end_op();
80105b51:	e8 da d0 ff ff       	call   80102c30 <end_op>

  f->type = FD_INODE;
80105b56:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b5f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b62:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b65:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b6c:	89 d0                	mov    %edx,%eax
80105b6e:	f7 d0                	not    %eax
80105b70:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b73:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b76:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b79:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b80:	89 d8                	mov    %ebx,%eax
80105b82:	5b                   	pop    %ebx
80105b83:	5e                   	pop    %esi
80105b84:	5f                   	pop    %edi
80105b85:	5d                   	pop    %ebp
80105b86:	c3                   	ret    
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b96:	31 c9                	xor    %ecx,%ecx
80105b98:	6a 00                	push   $0x0
80105b9a:	ba 02 00 00 00       	mov    $0x2,%edx
80105b9f:	e8 ec f7 ff ff       	call   80105390 <create>
    if(ip == 0){
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ba9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105bab:	0f 85 65 ff ff ff    	jne    80105b16 <sys_open+0x76>
      end_op();
80105bb1:	e8 7a d0 ff ff       	call   80102c30 <end_op>
      return -1;
80105bb6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bbb:	eb c0                	jmp    80105b7d <sys_open+0xdd>
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bc3:	85 c9                	test   %ecx,%ecx
80105bc5:	0f 84 4b ff ff ff    	je     80105b16 <sys_open+0x76>
    iunlockput(ip);
80105bcb:	83 ec 0c             	sub    $0xc,%esp
80105bce:	56                   	push   %esi
80105bcf:	e8 5c bd ff ff       	call   80101930 <iunlockput>
    end_op();
80105bd4:	e8 57 d0 ff ff       	call   80102c30 <end_op>
    return -1;
80105bd9:	83 c4 10             	add    $0x10,%esp
80105bdc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be1:	eb 9a                	jmp    80105b7d <sys_open+0xdd>
80105be3:	90                   	nop
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105be8:	83 ec 0c             	sub    $0xc,%esp
80105beb:	57                   	push   %edi
80105bec:	e8 6f b2 ff ff       	call   80100e60 <fileclose>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	eb d5                	jmp    80105bcb <sys_open+0x12b>
80105bf6:	8d 76 00             	lea    0x0(%esi),%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c06:	e8 b5 cf ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0e:	83 ec 08             	sub    $0x8,%esp
80105c11:	50                   	push   %eax
80105c12:	6a 00                	push   $0x0
80105c14:	e8 d7 f6 ff ff       	call   801052f0 <argstr>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	78 30                	js     80105c50 <sys_mkdir+0x50>
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c26:	31 c9                	xor    %ecx,%ecx
80105c28:	6a 00                	push   $0x0
80105c2a:	ba 01 00 00 00       	mov    $0x1,%edx
80105c2f:	e8 5c f7 ff ff       	call   80105390 <create>
80105c34:	83 c4 10             	add    $0x10,%esp
80105c37:	85 c0                	test   %eax,%eax
80105c39:	74 15                	je     80105c50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3b:	83 ec 0c             	sub    $0xc,%esp
80105c3e:	50                   	push   %eax
80105c3f:	e8 ec bc ff ff       	call   80101930 <iunlockput>
  end_op();
80105c44:	e8 e7 cf ff ff       	call   80102c30 <end_op>
  return 0;
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	31 c0                	xor    %eax,%eax
}
80105c4e:	c9                   	leave  
80105c4f:	c3                   	ret    
    end_op();
80105c50:	e8 db cf ff ff       	call   80102c30 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_mknod>:

int
sys_mknod(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c66:	e8 55 cf ff ff       	call   80102bc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c6e:	83 ec 08             	sub    $0x8,%esp
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 77 f6 ff ff       	call   801052f0 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 60                	js     80105ce0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c83:	83 ec 08             	sub    $0x8,%esp
80105c86:	50                   	push   %eax
80105c87:	6a 01                	push   $0x1
80105c89:	e8 b2 f5 ff ff       	call   80105240 <argint>
  if((argstr(0, &path)) < 0 ||
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	85 c0                	test   %eax,%eax
80105c93:	78 4b                	js     80105ce0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c98:	83 ec 08             	sub    $0x8,%esp
80105c9b:	50                   	push   %eax
80105c9c:	6a 02                	push   $0x2
80105c9e:	e8 9d f5 ff ff       	call   80105240 <argint>
     argint(1, &major) < 0 ||
80105ca3:	83 c4 10             	add    $0x10,%esp
80105ca6:	85 c0                	test   %eax,%eax
80105ca8:	78 36                	js     80105ce0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105caa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105cae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cb1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105cb5:	ba 03 00 00 00       	mov    $0x3,%edx
80105cba:	50                   	push   %eax
80105cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cbe:	e8 cd f6 ff ff       	call   80105390 <create>
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	74 16                	je     80105ce0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cca:	83 ec 0c             	sub    $0xc,%esp
80105ccd:	50                   	push   %eax
80105cce:	e8 5d bc ff ff       	call   80101930 <iunlockput>
  end_op();
80105cd3:	e8 58 cf ff ff       	call   80102c30 <end_op>
  return 0;
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	31 c0                	xor    %eax,%eax
}
80105cdd:	c9                   	leave  
80105cde:	c3                   	ret    
80105cdf:	90                   	nop
    end_op();
80105ce0:	e8 4b cf ff ff       	call   80102c30 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cea:	c9                   	leave  
80105ceb:	c3                   	ret    
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_chdir>:

int
sys_chdir(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	56                   	push   %esi
80105cf4:	53                   	push   %ebx
80105cf5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cf8:	e8 73 dc ff ff       	call   80103970 <myproc>
80105cfd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cff:	e8 bc ce ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d07:	83 ec 08             	sub    $0x8,%esp
80105d0a:	50                   	push   %eax
80105d0b:	6a 00                	push   $0x0
80105d0d:	e8 de f5 ff ff       	call   801052f0 <argstr>
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	78 77                	js     80105d90 <sys_chdir+0xa0>
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1f:	e8 dc c1 ff ff       	call   80101f00 <namei>
80105d24:	83 c4 10             	add    $0x10,%esp
80105d27:	85 c0                	test   %eax,%eax
80105d29:	89 c3                	mov    %eax,%ebx
80105d2b:	74 63                	je     80105d90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	50                   	push   %eax
80105d31:	e8 6a b9 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d3e:	75 30                	jne    80105d70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 37 ba ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80105d49:	58                   	pop    %eax
80105d4a:	ff 76 68             	pushl  0x68(%esi)
80105d4d:	e8 7e ba ff ff       	call   801017d0 <iput>
  end_op();
80105d52:	e8 d9 ce ff ff       	call   80102c30 <end_op>
  curproc->cwd = ip;
80105d57:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	31 c0                	xor    %eax,%eax
}
80105d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	53                   	push   %ebx
80105d74:	e8 b7 bb ff ff       	call   80101930 <iunlockput>
    end_op();
80105d79:	e8 b2 ce ff ff       	call   80102c30 <end_op>
    return -1;
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d86:	eb d7                	jmp    80105d5f <sys_chdir+0x6f>
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d90:	e8 9b ce ff ff       	call   80102c30 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9a:	eb c3                	jmp    80105d5f <sys_chdir+0x6f>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_exec>:

int
sys_exec(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105da6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105db2:	50                   	push   %eax
80105db3:	6a 00                	push   $0x0
80105db5:	e8 36 f5 ff ff       	call   801052f0 <argstr>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	0f 88 87 00 00 00    	js     80105e4c <sys_exec+0xac>
80105dc5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dcb:	83 ec 08             	sub    $0x8,%esp
80105dce:	50                   	push   %eax
80105dcf:	6a 01                	push   $0x1
80105dd1:	e8 6a f4 ff ff       	call   80105240 <argint>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 6f                	js     80105e4c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ddd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105de3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105de6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105de8:	68 80 00 00 00       	push   $0x80
80105ded:	6a 00                	push   $0x0
80105def:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105df5:	50                   	push   %eax
80105df6:	e8 45 f1 ff ff       	call   80104f40 <memset>
80105dfb:	83 c4 10             	add    $0x10,%esp
80105dfe:	eb 2c                	jmp    80105e2c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e00:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e06:	85 c0                	test   %eax,%eax
80105e08:	74 56                	je     80105e60 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e0a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e10:	83 ec 08             	sub    $0x8,%esp
80105e13:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e16:	52                   	push   %edx
80105e17:	50                   	push   %eax
80105e18:	e8 b3 f3 ff ff       	call   801051d0 <fetchstr>
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	85 c0                	test   %eax,%eax
80105e22:	78 28                	js     80105e4c <sys_exec+0xac>
  for(i=0;; i++){
80105e24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e27:	83 fb 20             	cmp    $0x20,%ebx
80105e2a:	74 20                	je     80105e4c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e2c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e32:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e39:	83 ec 08             	sub    $0x8,%esp
80105e3c:	57                   	push   %edi
80105e3d:	01 f0                	add    %esi,%eax
80105e3f:	50                   	push   %eax
80105e40:	e8 4b f3 ff ff       	call   80105190 <fetchint>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	79 b4                	jns    80105e00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e54:	5b                   	pop    %ebx
80105e55:	5e                   	pop    %esi
80105e56:	5f                   	pop    %edi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e60:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e66:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105e69:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e70:	00 00 00 00 
  return exec(path, argv);
80105e74:	50                   	push   %eax
80105e75:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e7b:	e8 90 ab ff ff       	call   80100a10 <exec>
80105e80:	83 c4 10             	add    $0x10,%esp
}
80105e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e86:	5b                   	pop    %ebx
80105e87:	5e                   	pop    %esi
80105e88:	5f                   	pop    %edi
80105e89:	5d                   	pop    %ebp
80105e8a:	c3                   	ret    
80105e8b:	90                   	nop
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_pipe>:

int
sys_pipe(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e96:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e99:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e9c:	6a 08                	push   $0x8
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 ea f3 ff ff       	call   80105290 <argptr>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	0f 88 ae 00 00 00    	js     80105f5f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105eb1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb4:	83 ec 08             	sub    $0x8,%esp
80105eb7:	50                   	push   %eax
80105eb8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ebb:	50                   	push   %eax
80105ebc:	e8 8f d3 ff ff       	call   80103250 <pipealloc>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	0f 88 93 00 00 00    	js     80105f5f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ecc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ecf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ed1:	e8 9a da ff ff       	call   80103970 <myproc>
80105ed6:	eb 10                	jmp    80105ee8 <sys_pipe+0x58>
80105ed8:	90                   	nop
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ee0:	83 c3 01             	add    $0x1,%ebx
80105ee3:	83 fb 10             	cmp    $0x10,%ebx
80105ee6:	74 60                	je     80105f48 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ee8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105eec:	85 f6                	test   %esi,%esi
80105eee:	75 f0                	jne    80105ee0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ef0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ef3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ef7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105efa:	e8 71 da ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eff:	31 d2                	xor    %edx,%edx
80105f01:	eb 0d                	jmp    80105f10 <sys_pipe+0x80>
80105f03:	90                   	nop
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f08:	83 c2 01             	add    $0x1,%edx
80105f0b:	83 fa 10             	cmp    $0x10,%edx
80105f0e:	74 28                	je     80105f38 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f10:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f14:	85 c9                	test   %ecx,%ecx
80105f16:	75 f0                	jne    80105f08 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f18:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f1f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f24:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f27:	31 c0                	xor    %eax,%eax
}
80105f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f2c:	5b                   	pop    %ebx
80105f2d:	5e                   	pop    %esi
80105f2e:	5f                   	pop    %edi
80105f2f:	5d                   	pop    %ebp
80105f30:	c3                   	ret    
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f38:	e8 33 da ff ff       	call   80103970 <myproc>
80105f3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f44:	00 
80105f45:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f4e:	e8 0d af ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105f53:	58                   	pop    %eax
80105f54:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f57:	e8 04 af ff ff       	call   80100e60 <fileclose>
    return -1;
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f64:	eb c3                	jmp    80105f29 <sys_pipe+0x99>
80105f66:	66 90                	xchg   %ax,%ax
80105f68:	66 90                	xchg   %ax,%ax
80105f6a:	66 90                	xchg   %ax,%ax
80105f6c:	66 90                	xchg   %ax,%ax
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105f73:	5d                   	pop    %ebp
  return fork();
80105f74:	e9 97 db ff ff       	jmp    80103b10 <fork>
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_exit>:

int
sys_exit(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f86:	e8 95 e0 ff ff       	call   80104020 <exit>
  return 0;  // not reached
}
80105f8b:	31 c0                	xor    %eax,%eax
80105f8d:	c9                   	leave  
80105f8e:	c3                   	ret    
80105f8f:	90                   	nop

80105f90 <sys_wait>:

int
sys_wait(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105f93:	5d                   	pop    %ebp
  return wait();
80105f94:	e9 c7 e2 ff ff       	jmp    80104260 <wait>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_kill>:

int
sys_kill(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa9:	50                   	push   %eax
80105faa:	6a 00                	push   $0x0
80105fac:	e8 8f f2 ff ff       	call   80105240 <argint>
80105fb1:	83 c4 10             	add    $0x10,%esp
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	78 18                	js     80105fd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fbe:	e8 fd e3 ff ff       	call   801043c0 <kill>
80105fc3:	83 c4 10             	add    $0x10,%esp
}
80105fc6:	c9                   	leave  
80105fc7:	c3                   	ret    
80105fc8:	90                   	nop
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <sys_getpid>:

int
sys_getpid(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fe6:	e8 85 d9 ff ff       	call   80103970 <myproc>
80105feb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fee:	c9                   	leave  
80105fef:	c3                   	ret    

80105ff0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ff7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffa:	50                   	push   %eax
80105ffb:	6a 00                	push   $0x0
80105ffd:	e8 3e f2 ff ff       	call   80105240 <argint>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	78 27                	js     80106030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106009:	e8 62 d9 ff ff       	call   80103970 <myproc>
  if(growproc(n) < 0)
8010600e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106011:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106013:	ff 75 f4             	pushl  -0xc(%ebp)
80106016:	e8 75 da ff ff       	call   80103a90 <growproc>
8010601b:	83 c4 10             	add    $0x10,%esp
8010601e:	85 c0                	test   %eax,%eax
80106020:	78 0e                	js     80106030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106022:	89 d8                	mov    %ebx,%eax
80106024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106027:	c9                   	leave  
80106028:	c3                   	ret    
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106035:	eb eb                	jmp    80106022 <sys_sbrk+0x32>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_sleep>:

int
sys_sleep(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106044:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106047:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010604a:	50                   	push   %eax
8010604b:	6a 00                	push   $0x0
8010604d:	e8 ee f1 ff ff       	call   80105240 <argint>
80106052:	83 c4 10             	add    $0x10,%esp
80106055:	85 c0                	test   %eax,%eax
80106057:	0f 88 8a 00 00 00    	js     801060e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	68 80 5c 11 80       	push   $0x80115c80
80106065:	e8 c6 ed ff ff       	call   80104e30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010606a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010606d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106070:	8b 1d c0 64 11 80    	mov    0x801164c0,%ebx
  while(ticks - ticks0 < n){
80106076:	85 d2                	test   %edx,%edx
80106078:	75 27                	jne    801060a1 <sys_sleep+0x61>
8010607a:	eb 54                	jmp    801060d0 <sys_sleep+0x90>
8010607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	68 80 5c 11 80       	push   $0x80115c80
80106088:	68 c0 64 11 80       	push   $0x801164c0
8010608d:	e8 0e e1 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80106092:	a1 c0 64 11 80       	mov    0x801164c0,%eax
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	29 d8                	sub    %ebx,%eax
8010609c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010609f:	73 2f                	jae    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
801060a1:	e8 ca d8 ff ff       	call   80103970 <myproc>
801060a6:	8b 40 24             	mov    0x24(%eax),%eax
801060a9:	85 c0                	test   %eax,%eax
801060ab:	74 d3                	je     80106080 <sys_sleep+0x40>
      release(&tickslock);
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 80 5c 11 80       	push   $0x80115c80
801060b5:	e8 36 ee ff ff       	call   80104ef0 <release>
      return -1;
801060ba:	83 c4 10             	add    $0x10,%esp
801060bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801060c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 80 5c 11 80       	push   $0x80115c80
801060d8:	e8 13 ee ff ff       	call   80104ef0 <release>
  return 0;
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
    return -1;
801060e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ec:	eb f4                	jmp    801060e2 <sys_sleep+0xa2>
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	53                   	push   %ebx
801060f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060f7:	68 80 5c 11 80       	push   $0x80115c80
801060fc:	e8 2f ed ff ff       	call   80104e30 <acquire>
  xticks = ticks;
80106101:	8b 1d c0 64 11 80    	mov    0x801164c0,%ebx
  release(&tickslock);
80106107:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
8010610e:	e8 dd ed ff ff       	call   80104ef0 <release>
  return xticks;
}
80106113:	89 d8                	mov    %ebx,%eax
80106115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106118:	c9                   	leave  
80106119:	c3                   	ret    
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106120 <sys_changeQueueNum>:

int
sys_changeQueueNum(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 20             	sub    $0x20,%esp
  int pid, destinationQueue;
  argint(0,&pid);
80106126:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106129:	50                   	push   %eax
8010612a:	6a 00                	push   $0x0
8010612c:	e8 0f f1 ff ff       	call   80105240 <argint>
  argint(1,&destinationQueue);  
80106131:	58                   	pop    %eax
80106132:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106135:	5a                   	pop    %edx
80106136:	50                   	push   %eax
80106137:	6a 01                	push   $0x1
80106139:	e8 02 f1 ff ff       	call   80105240 <argint>
  
  cprintf("pid = %d des = %d\n", pid, destinationQueue);
8010613e:	83 c4 0c             	add    $0xc,%esp
80106141:	ff 75 f4             	pushl  -0xc(%ebp)
80106144:	ff 75 f0             	pushl  -0x10(%ebp)
80106147:	68 09 84 10 80       	push   $0x80108409
8010614c:	e8 0f a5 ff ff       	call   80100660 <cprintf>
  return changeQueueNum(pid, destinationQueue);
80106151:	59                   	pop    %ecx
80106152:	58                   	pop    %eax
80106153:	ff 75 f4             	pushl  -0xc(%ebp)
80106156:	ff 75 f0             	pushl  -0x10(%ebp)
80106159:	e8 b2 e3 ff ff       	call   80104510 <changeQueueNum>
}
8010615e:	c9                   	leave  
8010615f:	c3                   	ret    

80106160 <sys_evalTicket>:
int
sys_evalTicket(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket;
  argint(0,&pid);
80106166:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106169:	50                   	push   %eax
8010616a:	6a 00                	push   $0x0
8010616c:	e8 cf f0 ff ff       	call   80105240 <argint>
  argint(1,&ticket);  
80106171:	58                   	pop    %eax
80106172:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106175:	5a                   	pop    %edx
80106176:	50                   	push   %eax
80106177:	6a 01                	push   $0x1
80106179:	e8 c2 f0 ff ff       	call   80105240 <argint>
  
  cprintf("pid = %d des = %d\n", pid, ticket);
8010617e:	83 c4 0c             	add    $0xc,%esp
80106181:	ff 75 f4             	pushl  -0xc(%ebp)
80106184:	ff 75 f0             	pushl  -0x10(%ebp)
80106187:	68 09 84 10 80       	push   $0x80108409
8010618c:	e8 cf a4 ff ff       	call   80100660 <cprintf>
  return evalTicket(pid, ticket);
80106191:	59                   	pop    %ecx
80106192:	58                   	pop    %eax
80106193:	ff 75 f4             	pushl  -0xc(%ebp)
80106196:	ff 75 f0             	pushl  -0x10(%ebp)
80106199:	e8 b2 e3 ff ff       	call   80104550 <evalTicket>
}
8010619e:	c9                   	leave  
8010619f:	c3                   	ret    

801061a0 <sys_evalRemainingPriority>:
int
sys_evalRemainingPriority(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  char *priority;
  argint(0, &pid);
801061a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061a9:	50                   	push   %eax
801061aa:	6a 00                	push   $0x0
801061ac:	e8 8f f0 ff ff       	call   80105240 <argint>
  argstr(1, &priority);  
801061b1:	58                   	pop    %eax
801061b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061b5:	5a                   	pop    %edx
801061b6:	50                   	push   %eax
801061b7:	6a 01                	push   $0x1
801061b9:	e8 32 f1 ff ff       	call   801052f0 <argstr>

  cprintf("pid = %d des = %s\n", pid, priority);
801061be:	83 c4 0c             	add    $0xc,%esp
801061c1:	ff 75 f4             	pushl  -0xc(%ebp)
801061c4:	ff 75 f0             	pushl  -0x10(%ebp)
801061c7:	68 1c 84 10 80       	push   $0x8010841c
801061cc:	e8 8f a4 ff ff       	call   80100660 <cprintf>
  return evalRemainingPriority(pid, priority);
801061d1:	59                   	pop    %ecx
801061d2:	58                   	pop    %eax
801061d3:	ff 75 f4             	pushl  -0xc(%ebp)
801061d6:	ff 75 f0             	pushl  -0x10(%ebp)
801061d9:	e8 42 e4 ff ff       	call   80104620 <evalRemainingPriority>
}
801061de:	c9                   	leave  
801061df:	c3                   	ret    

801061e0 <sys_printInfo>:
int
sys_printInfo(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
  return printInfo();
}
801061e3:	5d                   	pop    %ebp
  return printInfo();
801061e4:	e9 b7 e6 ff ff       	jmp    801048a0 <printInfo>

801061e9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061e9:	1e                   	push   %ds
  pushl %es
801061ea:	06                   	push   %es
  pushl %fs
801061eb:	0f a0                	push   %fs
  pushl %gs
801061ed:	0f a8                	push   %gs
  pushal
801061ef:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061f0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061f4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061f6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061f8:	54                   	push   %esp
  call trap
801061f9:	e8 c2 00 00 00       	call   801062c0 <trap>
  addl $4, %esp
801061fe:	83 c4 04             	add    $0x4,%esp

80106201 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106201:	61                   	popa   
  popl %gs
80106202:	0f a9                	pop    %gs
  popl %fs
80106204:	0f a1                	pop    %fs
  popl %es
80106206:	07                   	pop    %es
  popl %ds
80106207:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106208:	83 c4 08             	add    $0x8,%esp
  iret
8010620b:	cf                   	iret   
8010620c:	66 90                	xchg   %ax,%ax
8010620e:	66 90                	xchg   %ax,%ax

80106210 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106210:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106211:	31 c0                	xor    %eax,%eax
{
80106213:	89 e5                	mov    %esp,%ebp
80106215:	83 ec 08             	sub    $0x8,%esp
80106218:	90                   	nop
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106220:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106227:	c7 04 c5 c2 5c 11 80 	movl   $0x8e000008,-0x7feea33e(,%eax,8)
8010622e:	08 00 00 8e 
80106232:	66 89 14 c5 c0 5c 11 	mov    %dx,-0x7feea340(,%eax,8)
80106239:	80 
8010623a:	c1 ea 10             	shr    $0x10,%edx
8010623d:	66 89 14 c5 c6 5c 11 	mov    %dx,-0x7feea33a(,%eax,8)
80106244:	80 
  for(i = 0; i < 256; i++)
80106245:	83 c0 01             	add    $0x1,%eax
80106248:	3d 00 01 00 00       	cmp    $0x100,%eax
8010624d:	75 d1                	jne    80106220 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010624f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106254:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106257:	c7 05 c2 5e 11 80 08 	movl   $0xef000008,0x80115ec2
8010625e:	00 00 ef 
  initlock(&tickslock, "time");
80106261:	68 2f 84 10 80       	push   $0x8010842f
80106266:	68 80 5c 11 80       	push   $0x80115c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010626b:	66 a3 c0 5e 11 80    	mov    %ax,0x80115ec0
80106271:	c1 e8 10             	shr    $0x10,%eax
80106274:	66 a3 c6 5e 11 80    	mov    %ax,0x80115ec6
  initlock(&tickslock, "time");
8010627a:	e8 71 ea ff ff       	call   80104cf0 <initlock>
}
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	c9                   	leave  
80106283:	c3                   	ret    
80106284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010628a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106290 <idtinit>:

void
idtinit(void)
{
80106290:	55                   	push   %ebp
  pd[0] = size-1;
80106291:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106296:	89 e5                	mov    %esp,%ebp
80106298:	83 ec 10             	sub    $0x10,%esp
8010629b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010629f:	b8 c0 5c 11 80       	mov    $0x80115cc0,%eax
801062a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062a8:	c1 e8 10             	shr    $0x10,%eax
801062ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
801062b7:	89 f6                	mov    %esi,%esi
801062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	83 ec 1c             	sub    $0x1c,%esp
801062c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062cc:	8b 47 30             	mov    0x30(%edi),%eax
801062cf:	83 f8 40             	cmp    $0x40,%eax
801062d2:	0f 84 f0 00 00 00    	je     801063c8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062d8:	83 e8 20             	sub    $0x20,%eax
801062db:	83 f8 1f             	cmp    $0x1f,%eax
801062de:	77 10                	ja     801062f0 <trap+0x30>
801062e0:	ff 24 85 d8 84 10 80 	jmp    *-0x7fef7b28(,%eax,4)
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062f0:	e8 7b d6 ff ff       	call   80103970 <myproc>
801062f5:	85 c0                	test   %eax,%eax
801062f7:	8b 5f 38             	mov    0x38(%edi),%ebx
801062fa:	0f 84 14 02 00 00    	je     80106514 <trap+0x254>
80106300:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106304:	0f 84 0a 02 00 00    	je     80106514 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010630a:	0f 20 d1             	mov    %cr2,%ecx
8010630d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106310:	e8 3b d6 ff ff       	call   80103950 <cpuid>
80106315:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106318:	8b 47 34             	mov    0x34(%edi),%eax
8010631b:	8b 77 30             	mov    0x30(%edi),%esi
8010631e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106321:	e8 4a d6 ff ff       	call   80103970 <myproc>
80106326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106329:	e8 42 d6 ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010632e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106331:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106334:	51                   	push   %ecx
80106335:	53                   	push   %ebx
80106336:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106337:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010633a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010633d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010633e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106341:	52                   	push   %edx
80106342:	ff 70 10             	pushl  0x10(%eax)
80106345:	68 94 84 10 80       	push   $0x80108494
8010634a:	e8 11 a3 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010634f:	83 c4 20             	add    $0x20,%esp
80106352:	e8 19 d6 ff ff       	call   80103970 <myproc>
80106357:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010635e:	e8 0d d6 ff ff       	call   80103970 <myproc>
80106363:	85 c0                	test   %eax,%eax
80106365:	74 1d                	je     80106384 <trap+0xc4>
80106367:	e8 04 d6 ff ff       	call   80103970 <myproc>
8010636c:	8b 50 24             	mov    0x24(%eax),%edx
8010636f:	85 d2                	test   %edx,%edx
80106371:	74 11                	je     80106384 <trap+0xc4>
80106373:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106377:	83 e0 03             	and    $0x3,%eax
8010637a:	66 83 f8 03          	cmp    $0x3,%ax
8010637e:	0f 84 4c 01 00 00    	je     801064d0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106384:	e8 e7 d5 ff ff       	call   80103970 <myproc>
80106389:	85 c0                	test   %eax,%eax
8010638b:	74 0b                	je     80106398 <trap+0xd8>
8010638d:	e8 de d5 ff ff       	call   80103970 <myproc>
80106392:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106396:	74 68                	je     80106400 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106398:	e8 d3 d5 ff ff       	call   80103970 <myproc>
8010639d:	85 c0                	test   %eax,%eax
8010639f:	74 19                	je     801063ba <trap+0xfa>
801063a1:	e8 ca d5 ff ff       	call   80103970 <myproc>
801063a6:	8b 40 24             	mov    0x24(%eax),%eax
801063a9:	85 c0                	test   %eax,%eax
801063ab:	74 0d                	je     801063ba <trap+0xfa>
801063ad:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063b1:	83 e0 03             	and    $0x3,%eax
801063b4:	66 83 f8 03          	cmp    $0x3,%ax
801063b8:	74 37                	je     801063f1 <trap+0x131>
    exit();
}
801063ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063bd:	5b                   	pop    %ebx
801063be:	5e                   	pop    %esi
801063bf:	5f                   	pop    %edi
801063c0:	5d                   	pop    %ebp
801063c1:	c3                   	ret    
801063c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801063c8:	e8 a3 d5 ff ff       	call   80103970 <myproc>
801063cd:	8b 58 24             	mov    0x24(%eax),%ebx
801063d0:	85 db                	test   %ebx,%ebx
801063d2:	0f 85 e8 00 00 00    	jne    801064c0 <trap+0x200>
    myproc()->tf = tf;
801063d8:	e8 93 d5 ff ff       	call   80103970 <myproc>
801063dd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801063e0:	e8 4b ef ff ff       	call   80105330 <syscall>
    if(myproc()->killed)
801063e5:	e8 86 d5 ff ff       	call   80103970 <myproc>
801063ea:	8b 48 24             	mov    0x24(%eax),%ecx
801063ed:	85 c9                	test   %ecx,%ecx
801063ef:	74 c9                	je     801063ba <trap+0xfa>
}
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
      exit();
801063f8:	e9 23 dc ff ff       	jmp    80104020 <exit>
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106400:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106404:	75 92                	jne    80106398 <trap+0xd8>
    yield();
80106406:	e8 45 dd ff ff       	call   80104150 <yield>
8010640b:	eb 8b                	jmp    80106398 <trap+0xd8>
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106410:	e8 3b d5 ff ff       	call   80103950 <cpuid>
80106415:	85 c0                	test   %eax,%eax
80106417:	0f 84 c3 00 00 00    	je     801064e0 <trap+0x220>
    lapiceoi();
8010641d:	e8 4e c3 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106422:	e8 49 d5 ff ff       	call   80103970 <myproc>
80106427:	85 c0                	test   %eax,%eax
80106429:	0f 85 38 ff ff ff    	jne    80106367 <trap+0xa7>
8010642f:	e9 50 ff ff ff       	jmp    80106384 <trap+0xc4>
80106434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106438:	e8 f3 c1 ff ff       	call   80102630 <kbdintr>
    lapiceoi();
8010643d:	e8 2e c3 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106442:	e8 29 d5 ff ff       	call   80103970 <myproc>
80106447:	85 c0                	test   %eax,%eax
80106449:	0f 85 18 ff ff ff    	jne    80106367 <trap+0xa7>
8010644f:	e9 30 ff ff ff       	jmp    80106384 <trap+0xc4>
80106454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106458:	e8 53 02 00 00       	call   801066b0 <uartintr>
    lapiceoi();
8010645d:	e8 0e c3 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106462:	e8 09 d5 ff ff       	call   80103970 <myproc>
80106467:	85 c0                	test   %eax,%eax
80106469:	0f 85 f8 fe ff ff    	jne    80106367 <trap+0xa7>
8010646f:	e9 10 ff ff ff       	jmp    80106384 <trap+0xc4>
80106474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106478:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010647c:	8b 77 38             	mov    0x38(%edi),%esi
8010647f:	e8 cc d4 ff ff       	call   80103950 <cpuid>
80106484:	56                   	push   %esi
80106485:	53                   	push   %ebx
80106486:	50                   	push   %eax
80106487:	68 3c 84 10 80       	push   $0x8010843c
8010648c:	e8 cf a1 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106491:	e8 da c2 ff ff       	call   80102770 <lapiceoi>
    break;
80106496:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106499:	e8 d2 d4 ff ff       	call   80103970 <myproc>
8010649e:	85 c0                	test   %eax,%eax
801064a0:	0f 85 c1 fe ff ff    	jne    80106367 <trap+0xa7>
801064a6:	e9 d9 fe ff ff       	jmp    80106384 <trap+0xc4>
801064ab:	90                   	nop
801064ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801064b0:	e8 eb bb ff ff       	call   801020a0 <ideintr>
801064b5:	e9 63 ff ff ff       	jmp    8010641d <trap+0x15d>
801064ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801064c0:	e8 5b db ff ff       	call   80104020 <exit>
801064c5:	e9 0e ff ff ff       	jmp    801063d8 <trap+0x118>
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801064d0:	e8 4b db ff ff       	call   80104020 <exit>
801064d5:	e9 aa fe ff ff       	jmp    80106384 <trap+0xc4>
801064da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	68 80 5c 11 80       	push   $0x80115c80
801064e8:	e8 43 e9 ff ff       	call   80104e30 <acquire>
      wakeup(&ticks);
801064ed:	c7 04 24 c0 64 11 80 	movl   $0x801164c0,(%esp)
      ticks++;
801064f4:	83 05 c0 64 11 80 01 	addl   $0x1,0x801164c0
      wakeup(&ticks);
801064fb:	e8 60 de ff ff       	call   80104360 <wakeup>
      release(&tickslock);
80106500:	c7 04 24 80 5c 11 80 	movl   $0x80115c80,(%esp)
80106507:	e8 e4 e9 ff ff       	call   80104ef0 <release>
8010650c:	83 c4 10             	add    $0x10,%esp
8010650f:	e9 09 ff ff ff       	jmp    8010641d <trap+0x15d>
80106514:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106517:	e8 34 d4 ff ff       	call   80103950 <cpuid>
8010651c:	83 ec 0c             	sub    $0xc,%esp
8010651f:	56                   	push   %esi
80106520:	53                   	push   %ebx
80106521:	50                   	push   %eax
80106522:	ff 77 30             	pushl  0x30(%edi)
80106525:	68 60 84 10 80       	push   $0x80108460
8010652a:	e8 31 a1 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010652f:	83 c4 14             	add    $0x14,%esp
80106532:	68 34 84 10 80       	push   $0x80108434
80106537:	e8 54 9e ff ff       	call   80100390 <panic>
8010653c:	66 90                	xchg   %ax,%ax
8010653e:	66 90                	xchg   %ax,%ax

80106540 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106540:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106548:	85 c0                	test   %eax,%eax
8010654a:	74 1c                	je     80106568 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010654c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106551:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106552:	a8 01                	test   $0x1,%al
80106554:	74 12                	je     80106568 <uartgetc+0x28>
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010655c:	0f b6 c0             	movzbl %al,%eax
}
8010655f:	5d                   	pop    %ebp
80106560:	c3                   	ret    
80106561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010656d:	5d                   	pop    %ebp
8010656e:	c3                   	ret    
8010656f:	90                   	nop

80106570 <uartputc.part.0>:
uartputc(int c)
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	53                   	push   %ebx
80106576:	89 c7                	mov    %eax,%edi
80106578:	bb 80 00 00 00       	mov    $0x80,%ebx
8010657d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106582:	83 ec 0c             	sub    $0xc,%esp
80106585:	eb 1b                	jmp    801065a2 <uartputc.part.0+0x32>
80106587:	89 f6                	mov    %esi,%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	6a 0a                	push   $0xa
80106595:	e8 f6 c1 ff ff       	call   80102790 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	83 eb 01             	sub    $0x1,%ebx
801065a0:	74 07                	je     801065a9 <uartputc.part.0+0x39>
801065a2:	89 f2                	mov    %esi,%edx
801065a4:	ec                   	in     (%dx),%al
801065a5:	a8 20                	test   $0x20,%al
801065a7:	74 e7                	je     80106590 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ae:	89 f8                	mov    %edi,%eax
801065b0:	ee                   	out    %al,(%dx)
}
801065b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b4:	5b                   	pop    %ebx
801065b5:	5e                   	pop    %esi
801065b6:	5f                   	pop    %edi
801065b7:	5d                   	pop    %ebp
801065b8:	c3                   	ret    
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065c0 <uartinit>:
{
801065c0:	55                   	push   %ebp
801065c1:	31 c9                	xor    %ecx,%ecx
801065c3:	89 c8                	mov    %ecx,%eax
801065c5:	89 e5                	mov    %esp,%ebp
801065c7:	57                   	push   %edi
801065c8:	56                   	push   %esi
801065c9:	53                   	push   %ebx
801065ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065cf:	89 da                	mov    %ebx,%edx
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	ee                   	out    %al,(%dx)
801065d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065df:	89 fa                	mov    %edi,%edx
801065e1:	ee                   	out    %al,(%dx)
801065e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ec:	ee                   	out    %al,(%dx)
801065ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801065f2:	89 c8                	mov    %ecx,%eax
801065f4:	89 f2                	mov    %esi,%edx
801065f6:	ee                   	out    %al,(%dx)
801065f7:	b8 03 00 00 00       	mov    $0x3,%eax
801065fc:	89 fa                	mov    %edi,%edx
801065fe:	ee                   	out    %al,(%dx)
801065ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106604:	89 c8                	mov    %ecx,%eax
80106606:	ee                   	out    %al,(%dx)
80106607:	b8 01 00 00 00       	mov    $0x1,%eax
8010660c:	89 f2                	mov    %esi,%edx
8010660e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010660f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106614:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106615:	3c ff                	cmp    $0xff,%al
80106617:	74 5a                	je     80106673 <uartinit+0xb3>
  uart = 1;
80106619:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106620:	00 00 00 
80106623:	89 da                	mov    %ebx,%edx
80106625:	ec                   	in     (%dx),%al
80106626:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010662b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010662c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010662f:	bb 58 85 10 80       	mov    $0x80108558,%ebx
  ioapicenable(IRQ_COM1, 0);
80106634:	6a 00                	push   $0x0
80106636:	6a 04                	push   $0x4
80106638:	e8 b3 bc ff ff       	call   801022f0 <ioapicenable>
8010663d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106640:	b8 78 00 00 00       	mov    $0x78,%eax
80106645:	eb 13                	jmp    8010665a <uartinit+0x9a>
80106647:	89 f6                	mov    %esi,%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106650:	83 c3 01             	add    $0x1,%ebx
80106653:	0f be 03             	movsbl (%ebx),%eax
80106656:	84 c0                	test   %al,%al
80106658:	74 19                	je     80106673 <uartinit+0xb3>
  if(!uart)
8010665a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106660:	85 d2                	test   %edx,%edx
80106662:	74 ec                	je     80106650 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106664:	83 c3 01             	add    $0x1,%ebx
80106667:	e8 04 ff ff ff       	call   80106570 <uartputc.part.0>
8010666c:	0f be 03             	movsbl (%ebx),%eax
8010666f:	84 c0                	test   %al,%al
80106671:	75 e7                	jne    8010665a <uartinit+0x9a>
}
80106673:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106676:	5b                   	pop    %ebx
80106677:	5e                   	pop    %esi
80106678:	5f                   	pop    %edi
80106679:	5d                   	pop    %ebp
8010667a:	c3                   	ret    
8010667b:	90                   	nop
8010667c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106680 <uartputc>:
  if(!uart)
80106680:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106686:	55                   	push   %ebp
80106687:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106689:	85 d2                	test   %edx,%edx
{
8010668b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010668e:	74 10                	je     801066a0 <uartputc+0x20>
}
80106690:	5d                   	pop    %ebp
80106691:	e9 da fe ff ff       	jmp    80106570 <uartputc.part.0>
80106696:	8d 76 00             	lea    0x0(%esi),%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066a0:	5d                   	pop    %ebp
801066a1:	c3                   	ret    
801066a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066b0 <uartintr>:

void
uartintr(void)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066b6:	68 40 65 10 80       	push   $0x80106540
801066bb:	e8 50 a1 ff ff       	call   80100810 <consoleintr>
}
801066c0:	83 c4 10             	add    $0x10,%esp
801066c3:	c9                   	leave  
801066c4:	c3                   	ret    

801066c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $0
801066c7:	6a 00                	push   $0x0
  jmp alltraps
801066c9:	e9 1b fb ff ff       	jmp    801061e9 <alltraps>

801066ce <vector1>:
.globl vector1
vector1:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $1
801066d0:	6a 01                	push   $0x1
  jmp alltraps
801066d2:	e9 12 fb ff ff       	jmp    801061e9 <alltraps>

801066d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $2
801066d9:	6a 02                	push   $0x2
  jmp alltraps
801066db:	e9 09 fb ff ff       	jmp    801061e9 <alltraps>

801066e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $3
801066e2:	6a 03                	push   $0x3
  jmp alltraps
801066e4:	e9 00 fb ff ff       	jmp    801061e9 <alltraps>

801066e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $4
801066eb:	6a 04                	push   $0x4
  jmp alltraps
801066ed:	e9 f7 fa ff ff       	jmp    801061e9 <alltraps>

801066f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $5
801066f4:	6a 05                	push   $0x5
  jmp alltraps
801066f6:	e9 ee fa ff ff       	jmp    801061e9 <alltraps>

801066fb <vector6>:
.globl vector6
vector6:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $6
801066fd:	6a 06                	push   $0x6
  jmp alltraps
801066ff:	e9 e5 fa ff ff       	jmp    801061e9 <alltraps>

80106704 <vector7>:
.globl vector7
vector7:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $7
80106706:	6a 07                	push   $0x7
  jmp alltraps
80106708:	e9 dc fa ff ff       	jmp    801061e9 <alltraps>

8010670d <vector8>:
.globl vector8
vector8:
  pushl $8
8010670d:	6a 08                	push   $0x8
  jmp alltraps
8010670f:	e9 d5 fa ff ff       	jmp    801061e9 <alltraps>

80106714 <vector9>:
.globl vector9
vector9:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $9
80106716:	6a 09                	push   $0x9
  jmp alltraps
80106718:	e9 cc fa ff ff       	jmp    801061e9 <alltraps>

8010671d <vector10>:
.globl vector10
vector10:
  pushl $10
8010671d:	6a 0a                	push   $0xa
  jmp alltraps
8010671f:	e9 c5 fa ff ff       	jmp    801061e9 <alltraps>

80106724 <vector11>:
.globl vector11
vector11:
  pushl $11
80106724:	6a 0b                	push   $0xb
  jmp alltraps
80106726:	e9 be fa ff ff       	jmp    801061e9 <alltraps>

8010672b <vector12>:
.globl vector12
vector12:
  pushl $12
8010672b:	6a 0c                	push   $0xc
  jmp alltraps
8010672d:	e9 b7 fa ff ff       	jmp    801061e9 <alltraps>

80106732 <vector13>:
.globl vector13
vector13:
  pushl $13
80106732:	6a 0d                	push   $0xd
  jmp alltraps
80106734:	e9 b0 fa ff ff       	jmp    801061e9 <alltraps>

80106739 <vector14>:
.globl vector14
vector14:
  pushl $14
80106739:	6a 0e                	push   $0xe
  jmp alltraps
8010673b:	e9 a9 fa ff ff       	jmp    801061e9 <alltraps>

80106740 <vector15>:
.globl vector15
vector15:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $15
80106742:	6a 0f                	push   $0xf
  jmp alltraps
80106744:	e9 a0 fa ff ff       	jmp    801061e9 <alltraps>

80106749 <vector16>:
.globl vector16
vector16:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $16
8010674b:	6a 10                	push   $0x10
  jmp alltraps
8010674d:	e9 97 fa ff ff       	jmp    801061e9 <alltraps>

80106752 <vector17>:
.globl vector17
vector17:
  pushl $17
80106752:	6a 11                	push   $0x11
  jmp alltraps
80106754:	e9 90 fa ff ff       	jmp    801061e9 <alltraps>

80106759 <vector18>:
.globl vector18
vector18:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $18
8010675b:	6a 12                	push   $0x12
  jmp alltraps
8010675d:	e9 87 fa ff ff       	jmp    801061e9 <alltraps>

80106762 <vector19>:
.globl vector19
vector19:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $19
80106764:	6a 13                	push   $0x13
  jmp alltraps
80106766:	e9 7e fa ff ff       	jmp    801061e9 <alltraps>

8010676b <vector20>:
.globl vector20
vector20:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $20
8010676d:	6a 14                	push   $0x14
  jmp alltraps
8010676f:	e9 75 fa ff ff       	jmp    801061e9 <alltraps>

80106774 <vector21>:
.globl vector21
vector21:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $21
80106776:	6a 15                	push   $0x15
  jmp alltraps
80106778:	e9 6c fa ff ff       	jmp    801061e9 <alltraps>

8010677d <vector22>:
.globl vector22
vector22:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $22
8010677f:	6a 16                	push   $0x16
  jmp alltraps
80106781:	e9 63 fa ff ff       	jmp    801061e9 <alltraps>

80106786 <vector23>:
.globl vector23
vector23:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $23
80106788:	6a 17                	push   $0x17
  jmp alltraps
8010678a:	e9 5a fa ff ff       	jmp    801061e9 <alltraps>

8010678f <vector24>:
.globl vector24
vector24:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $24
80106791:	6a 18                	push   $0x18
  jmp alltraps
80106793:	e9 51 fa ff ff       	jmp    801061e9 <alltraps>

80106798 <vector25>:
.globl vector25
vector25:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $25
8010679a:	6a 19                	push   $0x19
  jmp alltraps
8010679c:	e9 48 fa ff ff       	jmp    801061e9 <alltraps>

801067a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $26
801067a3:	6a 1a                	push   $0x1a
  jmp alltraps
801067a5:	e9 3f fa ff ff       	jmp    801061e9 <alltraps>

801067aa <vector27>:
.globl vector27
vector27:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $27
801067ac:	6a 1b                	push   $0x1b
  jmp alltraps
801067ae:	e9 36 fa ff ff       	jmp    801061e9 <alltraps>

801067b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $28
801067b5:	6a 1c                	push   $0x1c
  jmp alltraps
801067b7:	e9 2d fa ff ff       	jmp    801061e9 <alltraps>

801067bc <vector29>:
.globl vector29
vector29:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $29
801067be:	6a 1d                	push   $0x1d
  jmp alltraps
801067c0:	e9 24 fa ff ff       	jmp    801061e9 <alltraps>

801067c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $30
801067c7:	6a 1e                	push   $0x1e
  jmp alltraps
801067c9:	e9 1b fa ff ff       	jmp    801061e9 <alltraps>

801067ce <vector31>:
.globl vector31
vector31:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $31
801067d0:	6a 1f                	push   $0x1f
  jmp alltraps
801067d2:	e9 12 fa ff ff       	jmp    801061e9 <alltraps>

801067d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $32
801067d9:	6a 20                	push   $0x20
  jmp alltraps
801067db:	e9 09 fa ff ff       	jmp    801061e9 <alltraps>

801067e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $33
801067e2:	6a 21                	push   $0x21
  jmp alltraps
801067e4:	e9 00 fa ff ff       	jmp    801061e9 <alltraps>

801067e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $34
801067eb:	6a 22                	push   $0x22
  jmp alltraps
801067ed:	e9 f7 f9 ff ff       	jmp    801061e9 <alltraps>

801067f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $35
801067f4:	6a 23                	push   $0x23
  jmp alltraps
801067f6:	e9 ee f9 ff ff       	jmp    801061e9 <alltraps>

801067fb <vector36>:
.globl vector36
vector36:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $36
801067fd:	6a 24                	push   $0x24
  jmp alltraps
801067ff:	e9 e5 f9 ff ff       	jmp    801061e9 <alltraps>

80106804 <vector37>:
.globl vector37
vector37:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $37
80106806:	6a 25                	push   $0x25
  jmp alltraps
80106808:	e9 dc f9 ff ff       	jmp    801061e9 <alltraps>

8010680d <vector38>:
.globl vector38
vector38:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $38
8010680f:	6a 26                	push   $0x26
  jmp alltraps
80106811:	e9 d3 f9 ff ff       	jmp    801061e9 <alltraps>

80106816 <vector39>:
.globl vector39
vector39:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $39
80106818:	6a 27                	push   $0x27
  jmp alltraps
8010681a:	e9 ca f9 ff ff       	jmp    801061e9 <alltraps>

8010681f <vector40>:
.globl vector40
vector40:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $40
80106821:	6a 28                	push   $0x28
  jmp alltraps
80106823:	e9 c1 f9 ff ff       	jmp    801061e9 <alltraps>

80106828 <vector41>:
.globl vector41
vector41:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $41
8010682a:	6a 29                	push   $0x29
  jmp alltraps
8010682c:	e9 b8 f9 ff ff       	jmp    801061e9 <alltraps>

80106831 <vector42>:
.globl vector42
vector42:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $42
80106833:	6a 2a                	push   $0x2a
  jmp alltraps
80106835:	e9 af f9 ff ff       	jmp    801061e9 <alltraps>

8010683a <vector43>:
.globl vector43
vector43:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $43
8010683c:	6a 2b                	push   $0x2b
  jmp alltraps
8010683e:	e9 a6 f9 ff ff       	jmp    801061e9 <alltraps>

80106843 <vector44>:
.globl vector44
vector44:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $44
80106845:	6a 2c                	push   $0x2c
  jmp alltraps
80106847:	e9 9d f9 ff ff       	jmp    801061e9 <alltraps>

8010684c <vector45>:
.globl vector45
vector45:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $45
8010684e:	6a 2d                	push   $0x2d
  jmp alltraps
80106850:	e9 94 f9 ff ff       	jmp    801061e9 <alltraps>

80106855 <vector46>:
.globl vector46
vector46:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $46
80106857:	6a 2e                	push   $0x2e
  jmp alltraps
80106859:	e9 8b f9 ff ff       	jmp    801061e9 <alltraps>

8010685e <vector47>:
.globl vector47
vector47:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $47
80106860:	6a 2f                	push   $0x2f
  jmp alltraps
80106862:	e9 82 f9 ff ff       	jmp    801061e9 <alltraps>

80106867 <vector48>:
.globl vector48
vector48:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $48
80106869:	6a 30                	push   $0x30
  jmp alltraps
8010686b:	e9 79 f9 ff ff       	jmp    801061e9 <alltraps>

80106870 <vector49>:
.globl vector49
vector49:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $49
80106872:	6a 31                	push   $0x31
  jmp alltraps
80106874:	e9 70 f9 ff ff       	jmp    801061e9 <alltraps>

80106879 <vector50>:
.globl vector50
vector50:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $50
8010687b:	6a 32                	push   $0x32
  jmp alltraps
8010687d:	e9 67 f9 ff ff       	jmp    801061e9 <alltraps>

80106882 <vector51>:
.globl vector51
vector51:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $51
80106884:	6a 33                	push   $0x33
  jmp alltraps
80106886:	e9 5e f9 ff ff       	jmp    801061e9 <alltraps>

8010688b <vector52>:
.globl vector52
vector52:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $52
8010688d:	6a 34                	push   $0x34
  jmp alltraps
8010688f:	e9 55 f9 ff ff       	jmp    801061e9 <alltraps>

80106894 <vector53>:
.globl vector53
vector53:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $53
80106896:	6a 35                	push   $0x35
  jmp alltraps
80106898:	e9 4c f9 ff ff       	jmp    801061e9 <alltraps>

8010689d <vector54>:
.globl vector54
vector54:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $54
8010689f:	6a 36                	push   $0x36
  jmp alltraps
801068a1:	e9 43 f9 ff ff       	jmp    801061e9 <alltraps>

801068a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $55
801068a8:	6a 37                	push   $0x37
  jmp alltraps
801068aa:	e9 3a f9 ff ff       	jmp    801061e9 <alltraps>

801068af <vector56>:
.globl vector56
vector56:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $56
801068b1:	6a 38                	push   $0x38
  jmp alltraps
801068b3:	e9 31 f9 ff ff       	jmp    801061e9 <alltraps>

801068b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $57
801068ba:	6a 39                	push   $0x39
  jmp alltraps
801068bc:	e9 28 f9 ff ff       	jmp    801061e9 <alltraps>

801068c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $58
801068c3:	6a 3a                	push   $0x3a
  jmp alltraps
801068c5:	e9 1f f9 ff ff       	jmp    801061e9 <alltraps>

801068ca <vector59>:
.globl vector59
vector59:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $59
801068cc:	6a 3b                	push   $0x3b
  jmp alltraps
801068ce:	e9 16 f9 ff ff       	jmp    801061e9 <alltraps>

801068d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $60
801068d5:	6a 3c                	push   $0x3c
  jmp alltraps
801068d7:	e9 0d f9 ff ff       	jmp    801061e9 <alltraps>

801068dc <vector61>:
.globl vector61
vector61:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $61
801068de:	6a 3d                	push   $0x3d
  jmp alltraps
801068e0:	e9 04 f9 ff ff       	jmp    801061e9 <alltraps>

801068e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $62
801068e7:	6a 3e                	push   $0x3e
  jmp alltraps
801068e9:	e9 fb f8 ff ff       	jmp    801061e9 <alltraps>

801068ee <vector63>:
.globl vector63
vector63:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $63
801068f0:	6a 3f                	push   $0x3f
  jmp alltraps
801068f2:	e9 f2 f8 ff ff       	jmp    801061e9 <alltraps>

801068f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $64
801068f9:	6a 40                	push   $0x40
  jmp alltraps
801068fb:	e9 e9 f8 ff ff       	jmp    801061e9 <alltraps>

80106900 <vector65>:
.globl vector65
vector65:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $65
80106902:	6a 41                	push   $0x41
  jmp alltraps
80106904:	e9 e0 f8 ff ff       	jmp    801061e9 <alltraps>

80106909 <vector66>:
.globl vector66
vector66:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $66
8010690b:	6a 42                	push   $0x42
  jmp alltraps
8010690d:	e9 d7 f8 ff ff       	jmp    801061e9 <alltraps>

80106912 <vector67>:
.globl vector67
vector67:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $67
80106914:	6a 43                	push   $0x43
  jmp alltraps
80106916:	e9 ce f8 ff ff       	jmp    801061e9 <alltraps>

8010691b <vector68>:
.globl vector68
vector68:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $68
8010691d:	6a 44                	push   $0x44
  jmp alltraps
8010691f:	e9 c5 f8 ff ff       	jmp    801061e9 <alltraps>

80106924 <vector69>:
.globl vector69
vector69:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $69
80106926:	6a 45                	push   $0x45
  jmp alltraps
80106928:	e9 bc f8 ff ff       	jmp    801061e9 <alltraps>

8010692d <vector70>:
.globl vector70
vector70:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $70
8010692f:	6a 46                	push   $0x46
  jmp alltraps
80106931:	e9 b3 f8 ff ff       	jmp    801061e9 <alltraps>

80106936 <vector71>:
.globl vector71
vector71:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $71
80106938:	6a 47                	push   $0x47
  jmp alltraps
8010693a:	e9 aa f8 ff ff       	jmp    801061e9 <alltraps>

8010693f <vector72>:
.globl vector72
vector72:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $72
80106941:	6a 48                	push   $0x48
  jmp alltraps
80106943:	e9 a1 f8 ff ff       	jmp    801061e9 <alltraps>

80106948 <vector73>:
.globl vector73
vector73:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $73
8010694a:	6a 49                	push   $0x49
  jmp alltraps
8010694c:	e9 98 f8 ff ff       	jmp    801061e9 <alltraps>

80106951 <vector74>:
.globl vector74
vector74:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $74
80106953:	6a 4a                	push   $0x4a
  jmp alltraps
80106955:	e9 8f f8 ff ff       	jmp    801061e9 <alltraps>

8010695a <vector75>:
.globl vector75
vector75:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $75
8010695c:	6a 4b                	push   $0x4b
  jmp alltraps
8010695e:	e9 86 f8 ff ff       	jmp    801061e9 <alltraps>

80106963 <vector76>:
.globl vector76
vector76:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $76
80106965:	6a 4c                	push   $0x4c
  jmp alltraps
80106967:	e9 7d f8 ff ff       	jmp    801061e9 <alltraps>

8010696c <vector77>:
.globl vector77
vector77:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $77
8010696e:	6a 4d                	push   $0x4d
  jmp alltraps
80106970:	e9 74 f8 ff ff       	jmp    801061e9 <alltraps>

80106975 <vector78>:
.globl vector78
vector78:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $78
80106977:	6a 4e                	push   $0x4e
  jmp alltraps
80106979:	e9 6b f8 ff ff       	jmp    801061e9 <alltraps>

8010697e <vector79>:
.globl vector79
vector79:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $79
80106980:	6a 4f                	push   $0x4f
  jmp alltraps
80106982:	e9 62 f8 ff ff       	jmp    801061e9 <alltraps>

80106987 <vector80>:
.globl vector80
vector80:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $80
80106989:	6a 50                	push   $0x50
  jmp alltraps
8010698b:	e9 59 f8 ff ff       	jmp    801061e9 <alltraps>

80106990 <vector81>:
.globl vector81
vector81:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $81
80106992:	6a 51                	push   $0x51
  jmp alltraps
80106994:	e9 50 f8 ff ff       	jmp    801061e9 <alltraps>

80106999 <vector82>:
.globl vector82
vector82:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $82
8010699b:	6a 52                	push   $0x52
  jmp alltraps
8010699d:	e9 47 f8 ff ff       	jmp    801061e9 <alltraps>

801069a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $83
801069a4:	6a 53                	push   $0x53
  jmp alltraps
801069a6:	e9 3e f8 ff ff       	jmp    801061e9 <alltraps>

801069ab <vector84>:
.globl vector84
vector84:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $84
801069ad:	6a 54                	push   $0x54
  jmp alltraps
801069af:	e9 35 f8 ff ff       	jmp    801061e9 <alltraps>

801069b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $85
801069b6:	6a 55                	push   $0x55
  jmp alltraps
801069b8:	e9 2c f8 ff ff       	jmp    801061e9 <alltraps>

801069bd <vector86>:
.globl vector86
vector86:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $86
801069bf:	6a 56                	push   $0x56
  jmp alltraps
801069c1:	e9 23 f8 ff ff       	jmp    801061e9 <alltraps>

801069c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $87
801069c8:	6a 57                	push   $0x57
  jmp alltraps
801069ca:	e9 1a f8 ff ff       	jmp    801061e9 <alltraps>

801069cf <vector88>:
.globl vector88
vector88:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $88
801069d1:	6a 58                	push   $0x58
  jmp alltraps
801069d3:	e9 11 f8 ff ff       	jmp    801061e9 <alltraps>

801069d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $89
801069da:	6a 59                	push   $0x59
  jmp alltraps
801069dc:	e9 08 f8 ff ff       	jmp    801061e9 <alltraps>

801069e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $90
801069e3:	6a 5a                	push   $0x5a
  jmp alltraps
801069e5:	e9 ff f7 ff ff       	jmp    801061e9 <alltraps>

801069ea <vector91>:
.globl vector91
vector91:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $91
801069ec:	6a 5b                	push   $0x5b
  jmp alltraps
801069ee:	e9 f6 f7 ff ff       	jmp    801061e9 <alltraps>

801069f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $92
801069f5:	6a 5c                	push   $0x5c
  jmp alltraps
801069f7:	e9 ed f7 ff ff       	jmp    801061e9 <alltraps>

801069fc <vector93>:
.globl vector93
vector93:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $93
801069fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106a00:	e9 e4 f7 ff ff       	jmp    801061e9 <alltraps>

80106a05 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $94
80106a07:	6a 5e                	push   $0x5e
  jmp alltraps
80106a09:	e9 db f7 ff ff       	jmp    801061e9 <alltraps>

80106a0e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $95
80106a10:	6a 5f                	push   $0x5f
  jmp alltraps
80106a12:	e9 d2 f7 ff ff       	jmp    801061e9 <alltraps>

80106a17 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $96
80106a19:	6a 60                	push   $0x60
  jmp alltraps
80106a1b:	e9 c9 f7 ff ff       	jmp    801061e9 <alltraps>

80106a20 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $97
80106a22:	6a 61                	push   $0x61
  jmp alltraps
80106a24:	e9 c0 f7 ff ff       	jmp    801061e9 <alltraps>

80106a29 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $98
80106a2b:	6a 62                	push   $0x62
  jmp alltraps
80106a2d:	e9 b7 f7 ff ff       	jmp    801061e9 <alltraps>

80106a32 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $99
80106a34:	6a 63                	push   $0x63
  jmp alltraps
80106a36:	e9 ae f7 ff ff       	jmp    801061e9 <alltraps>

80106a3b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $100
80106a3d:	6a 64                	push   $0x64
  jmp alltraps
80106a3f:	e9 a5 f7 ff ff       	jmp    801061e9 <alltraps>

80106a44 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $101
80106a46:	6a 65                	push   $0x65
  jmp alltraps
80106a48:	e9 9c f7 ff ff       	jmp    801061e9 <alltraps>

80106a4d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $102
80106a4f:	6a 66                	push   $0x66
  jmp alltraps
80106a51:	e9 93 f7 ff ff       	jmp    801061e9 <alltraps>

80106a56 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $103
80106a58:	6a 67                	push   $0x67
  jmp alltraps
80106a5a:	e9 8a f7 ff ff       	jmp    801061e9 <alltraps>

80106a5f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $104
80106a61:	6a 68                	push   $0x68
  jmp alltraps
80106a63:	e9 81 f7 ff ff       	jmp    801061e9 <alltraps>

80106a68 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $105
80106a6a:	6a 69                	push   $0x69
  jmp alltraps
80106a6c:	e9 78 f7 ff ff       	jmp    801061e9 <alltraps>

80106a71 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $106
80106a73:	6a 6a                	push   $0x6a
  jmp alltraps
80106a75:	e9 6f f7 ff ff       	jmp    801061e9 <alltraps>

80106a7a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $107
80106a7c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a7e:	e9 66 f7 ff ff       	jmp    801061e9 <alltraps>

80106a83 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $108
80106a85:	6a 6c                	push   $0x6c
  jmp alltraps
80106a87:	e9 5d f7 ff ff       	jmp    801061e9 <alltraps>

80106a8c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $109
80106a8e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a90:	e9 54 f7 ff ff       	jmp    801061e9 <alltraps>

80106a95 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $110
80106a97:	6a 6e                	push   $0x6e
  jmp alltraps
80106a99:	e9 4b f7 ff ff       	jmp    801061e9 <alltraps>

80106a9e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $111
80106aa0:	6a 6f                	push   $0x6f
  jmp alltraps
80106aa2:	e9 42 f7 ff ff       	jmp    801061e9 <alltraps>

80106aa7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $112
80106aa9:	6a 70                	push   $0x70
  jmp alltraps
80106aab:	e9 39 f7 ff ff       	jmp    801061e9 <alltraps>

80106ab0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $113
80106ab2:	6a 71                	push   $0x71
  jmp alltraps
80106ab4:	e9 30 f7 ff ff       	jmp    801061e9 <alltraps>

80106ab9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $114
80106abb:	6a 72                	push   $0x72
  jmp alltraps
80106abd:	e9 27 f7 ff ff       	jmp    801061e9 <alltraps>

80106ac2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $115
80106ac4:	6a 73                	push   $0x73
  jmp alltraps
80106ac6:	e9 1e f7 ff ff       	jmp    801061e9 <alltraps>

80106acb <vector116>:
.globl vector116
vector116:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $116
80106acd:	6a 74                	push   $0x74
  jmp alltraps
80106acf:	e9 15 f7 ff ff       	jmp    801061e9 <alltraps>

80106ad4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $117
80106ad6:	6a 75                	push   $0x75
  jmp alltraps
80106ad8:	e9 0c f7 ff ff       	jmp    801061e9 <alltraps>

80106add <vector118>:
.globl vector118
vector118:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $118
80106adf:	6a 76                	push   $0x76
  jmp alltraps
80106ae1:	e9 03 f7 ff ff       	jmp    801061e9 <alltraps>

80106ae6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $119
80106ae8:	6a 77                	push   $0x77
  jmp alltraps
80106aea:	e9 fa f6 ff ff       	jmp    801061e9 <alltraps>

80106aef <vector120>:
.globl vector120
vector120:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $120
80106af1:	6a 78                	push   $0x78
  jmp alltraps
80106af3:	e9 f1 f6 ff ff       	jmp    801061e9 <alltraps>

80106af8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $121
80106afa:	6a 79                	push   $0x79
  jmp alltraps
80106afc:	e9 e8 f6 ff ff       	jmp    801061e9 <alltraps>

80106b01 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $122
80106b03:	6a 7a                	push   $0x7a
  jmp alltraps
80106b05:	e9 df f6 ff ff       	jmp    801061e9 <alltraps>

80106b0a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $123
80106b0c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b0e:	e9 d6 f6 ff ff       	jmp    801061e9 <alltraps>

80106b13 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $124
80106b15:	6a 7c                	push   $0x7c
  jmp alltraps
80106b17:	e9 cd f6 ff ff       	jmp    801061e9 <alltraps>

80106b1c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $125
80106b1e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b20:	e9 c4 f6 ff ff       	jmp    801061e9 <alltraps>

80106b25 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $126
80106b27:	6a 7e                	push   $0x7e
  jmp alltraps
80106b29:	e9 bb f6 ff ff       	jmp    801061e9 <alltraps>

80106b2e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $127
80106b30:	6a 7f                	push   $0x7f
  jmp alltraps
80106b32:	e9 b2 f6 ff ff       	jmp    801061e9 <alltraps>

80106b37 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $128
80106b39:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b3e:	e9 a6 f6 ff ff       	jmp    801061e9 <alltraps>

80106b43 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $129
80106b45:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b4a:	e9 9a f6 ff ff       	jmp    801061e9 <alltraps>

80106b4f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $130
80106b51:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b56:	e9 8e f6 ff ff       	jmp    801061e9 <alltraps>

80106b5b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $131
80106b5d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b62:	e9 82 f6 ff ff       	jmp    801061e9 <alltraps>

80106b67 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $132
80106b69:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b6e:	e9 76 f6 ff ff       	jmp    801061e9 <alltraps>

80106b73 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $133
80106b75:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b7a:	e9 6a f6 ff ff       	jmp    801061e9 <alltraps>

80106b7f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $134
80106b81:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b86:	e9 5e f6 ff ff       	jmp    801061e9 <alltraps>

80106b8b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $135
80106b8d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b92:	e9 52 f6 ff ff       	jmp    801061e9 <alltraps>

80106b97 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $136
80106b99:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b9e:	e9 46 f6 ff ff       	jmp    801061e9 <alltraps>

80106ba3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $137
80106ba5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106baa:	e9 3a f6 ff ff       	jmp    801061e9 <alltraps>

80106baf <vector138>:
.globl vector138
vector138:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $138
80106bb1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106bb6:	e9 2e f6 ff ff       	jmp    801061e9 <alltraps>

80106bbb <vector139>:
.globl vector139
vector139:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $139
80106bbd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106bc2:	e9 22 f6 ff ff       	jmp    801061e9 <alltraps>

80106bc7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $140
80106bc9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bce:	e9 16 f6 ff ff       	jmp    801061e9 <alltraps>

80106bd3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $141
80106bd5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bda:	e9 0a f6 ff ff       	jmp    801061e9 <alltraps>

80106bdf <vector142>:
.globl vector142
vector142:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $142
80106be1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106be6:	e9 fe f5 ff ff       	jmp    801061e9 <alltraps>

80106beb <vector143>:
.globl vector143
vector143:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $143
80106bed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bf2:	e9 f2 f5 ff ff       	jmp    801061e9 <alltraps>

80106bf7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $144
80106bf9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bfe:	e9 e6 f5 ff ff       	jmp    801061e9 <alltraps>

80106c03 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $145
80106c05:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c0a:	e9 da f5 ff ff       	jmp    801061e9 <alltraps>

80106c0f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $146
80106c11:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c16:	e9 ce f5 ff ff       	jmp    801061e9 <alltraps>

80106c1b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $147
80106c1d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c22:	e9 c2 f5 ff ff       	jmp    801061e9 <alltraps>

80106c27 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $148
80106c29:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c2e:	e9 b6 f5 ff ff       	jmp    801061e9 <alltraps>

80106c33 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $149
80106c35:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c3a:	e9 aa f5 ff ff       	jmp    801061e9 <alltraps>

80106c3f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $150
80106c41:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c46:	e9 9e f5 ff ff       	jmp    801061e9 <alltraps>

80106c4b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $151
80106c4d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c52:	e9 92 f5 ff ff       	jmp    801061e9 <alltraps>

80106c57 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $152
80106c59:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c5e:	e9 86 f5 ff ff       	jmp    801061e9 <alltraps>

80106c63 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $153
80106c65:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c6a:	e9 7a f5 ff ff       	jmp    801061e9 <alltraps>

80106c6f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $154
80106c71:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c76:	e9 6e f5 ff ff       	jmp    801061e9 <alltraps>

80106c7b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $155
80106c7d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c82:	e9 62 f5 ff ff       	jmp    801061e9 <alltraps>

80106c87 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $156
80106c89:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c8e:	e9 56 f5 ff ff       	jmp    801061e9 <alltraps>

80106c93 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $157
80106c95:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c9a:	e9 4a f5 ff ff       	jmp    801061e9 <alltraps>

80106c9f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $158
80106ca1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ca6:	e9 3e f5 ff ff       	jmp    801061e9 <alltraps>

80106cab <vector159>:
.globl vector159
vector159:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $159
80106cad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106cb2:	e9 32 f5 ff ff       	jmp    801061e9 <alltraps>

80106cb7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $160
80106cb9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106cbe:	e9 26 f5 ff ff       	jmp    801061e9 <alltraps>

80106cc3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $161
80106cc5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106cca:	e9 1a f5 ff ff       	jmp    801061e9 <alltraps>

80106ccf <vector162>:
.globl vector162
vector162:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $162
80106cd1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cd6:	e9 0e f5 ff ff       	jmp    801061e9 <alltraps>

80106cdb <vector163>:
.globl vector163
vector163:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $163
80106cdd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ce2:	e9 02 f5 ff ff       	jmp    801061e9 <alltraps>

80106ce7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $164
80106ce9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cee:	e9 f6 f4 ff ff       	jmp    801061e9 <alltraps>

80106cf3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $165
80106cf5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cfa:	e9 ea f4 ff ff       	jmp    801061e9 <alltraps>

80106cff <vector166>:
.globl vector166
vector166:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $166
80106d01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d06:	e9 de f4 ff ff       	jmp    801061e9 <alltraps>

80106d0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $167
80106d0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d12:	e9 d2 f4 ff ff       	jmp    801061e9 <alltraps>

80106d17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $168
80106d19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d1e:	e9 c6 f4 ff ff       	jmp    801061e9 <alltraps>

80106d23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $169
80106d25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d2a:	e9 ba f4 ff ff       	jmp    801061e9 <alltraps>

80106d2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $170
80106d31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d36:	e9 ae f4 ff ff       	jmp    801061e9 <alltraps>

80106d3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $171
80106d3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d42:	e9 a2 f4 ff ff       	jmp    801061e9 <alltraps>

80106d47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $172
80106d49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d4e:	e9 96 f4 ff ff       	jmp    801061e9 <alltraps>

80106d53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $173
80106d55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d5a:	e9 8a f4 ff ff       	jmp    801061e9 <alltraps>

80106d5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $174
80106d61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d66:	e9 7e f4 ff ff       	jmp    801061e9 <alltraps>

80106d6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $175
80106d6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d72:	e9 72 f4 ff ff       	jmp    801061e9 <alltraps>

80106d77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $176
80106d79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d7e:	e9 66 f4 ff ff       	jmp    801061e9 <alltraps>

80106d83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $177
80106d85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d8a:	e9 5a f4 ff ff       	jmp    801061e9 <alltraps>

80106d8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $178
80106d91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d96:	e9 4e f4 ff ff       	jmp    801061e9 <alltraps>

80106d9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $179
80106d9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106da2:	e9 42 f4 ff ff       	jmp    801061e9 <alltraps>

80106da7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $180
80106da9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106dae:	e9 36 f4 ff ff       	jmp    801061e9 <alltraps>

80106db3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $181
80106db5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106dba:	e9 2a f4 ff ff       	jmp    801061e9 <alltraps>

80106dbf <vector182>:
.globl vector182
vector182:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $182
80106dc1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106dc6:	e9 1e f4 ff ff       	jmp    801061e9 <alltraps>

80106dcb <vector183>:
.globl vector183
vector183:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $183
80106dcd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106dd2:	e9 12 f4 ff ff       	jmp    801061e9 <alltraps>

80106dd7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $184
80106dd9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dde:	e9 06 f4 ff ff       	jmp    801061e9 <alltraps>

80106de3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $185
80106de5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dea:	e9 fa f3 ff ff       	jmp    801061e9 <alltraps>

80106def <vector186>:
.globl vector186
vector186:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $186
80106df1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106df6:	e9 ee f3 ff ff       	jmp    801061e9 <alltraps>

80106dfb <vector187>:
.globl vector187
vector187:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $187
80106dfd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e02:	e9 e2 f3 ff ff       	jmp    801061e9 <alltraps>

80106e07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $188
80106e09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e0e:	e9 d6 f3 ff ff       	jmp    801061e9 <alltraps>

80106e13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $189
80106e15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e1a:	e9 ca f3 ff ff       	jmp    801061e9 <alltraps>

80106e1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $190
80106e21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e26:	e9 be f3 ff ff       	jmp    801061e9 <alltraps>

80106e2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $191
80106e2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e32:	e9 b2 f3 ff ff       	jmp    801061e9 <alltraps>

80106e37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $192
80106e39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e3e:	e9 a6 f3 ff ff       	jmp    801061e9 <alltraps>

80106e43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $193
80106e45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e4a:	e9 9a f3 ff ff       	jmp    801061e9 <alltraps>

80106e4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $194
80106e51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e56:	e9 8e f3 ff ff       	jmp    801061e9 <alltraps>

80106e5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $195
80106e5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e62:	e9 82 f3 ff ff       	jmp    801061e9 <alltraps>

80106e67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $196
80106e69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e6e:	e9 76 f3 ff ff       	jmp    801061e9 <alltraps>

80106e73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $197
80106e75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e7a:	e9 6a f3 ff ff       	jmp    801061e9 <alltraps>

80106e7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $198
80106e81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e86:	e9 5e f3 ff ff       	jmp    801061e9 <alltraps>

80106e8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $199
80106e8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e92:	e9 52 f3 ff ff       	jmp    801061e9 <alltraps>

80106e97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $200
80106e99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e9e:	e9 46 f3 ff ff       	jmp    801061e9 <alltraps>

80106ea3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $201
80106ea5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106eaa:	e9 3a f3 ff ff       	jmp    801061e9 <alltraps>

80106eaf <vector202>:
.globl vector202
vector202:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $202
80106eb1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106eb6:	e9 2e f3 ff ff       	jmp    801061e9 <alltraps>

80106ebb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $203
80106ebd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ec2:	e9 22 f3 ff ff       	jmp    801061e9 <alltraps>

80106ec7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $204
80106ec9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ece:	e9 16 f3 ff ff       	jmp    801061e9 <alltraps>

80106ed3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $205
80106ed5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eda:	e9 0a f3 ff ff       	jmp    801061e9 <alltraps>

80106edf <vector206>:
.globl vector206
vector206:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $206
80106ee1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ee6:	e9 fe f2 ff ff       	jmp    801061e9 <alltraps>

80106eeb <vector207>:
.globl vector207
vector207:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $207
80106eed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ef2:	e9 f2 f2 ff ff       	jmp    801061e9 <alltraps>

80106ef7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $208
80106ef9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106efe:	e9 e6 f2 ff ff       	jmp    801061e9 <alltraps>

80106f03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $209
80106f05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f0a:	e9 da f2 ff ff       	jmp    801061e9 <alltraps>

80106f0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $210
80106f11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f16:	e9 ce f2 ff ff       	jmp    801061e9 <alltraps>

80106f1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $211
80106f1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f22:	e9 c2 f2 ff ff       	jmp    801061e9 <alltraps>

80106f27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $212
80106f29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f2e:	e9 b6 f2 ff ff       	jmp    801061e9 <alltraps>

80106f33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $213
80106f35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f3a:	e9 aa f2 ff ff       	jmp    801061e9 <alltraps>

80106f3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $214
80106f41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f46:	e9 9e f2 ff ff       	jmp    801061e9 <alltraps>

80106f4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $215
80106f4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f52:	e9 92 f2 ff ff       	jmp    801061e9 <alltraps>

80106f57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $216
80106f59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f5e:	e9 86 f2 ff ff       	jmp    801061e9 <alltraps>

80106f63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $217
80106f65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f6a:	e9 7a f2 ff ff       	jmp    801061e9 <alltraps>

80106f6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $218
80106f71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f76:	e9 6e f2 ff ff       	jmp    801061e9 <alltraps>

80106f7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $219
80106f7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f82:	e9 62 f2 ff ff       	jmp    801061e9 <alltraps>

80106f87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $220
80106f89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f8e:	e9 56 f2 ff ff       	jmp    801061e9 <alltraps>

80106f93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $221
80106f95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f9a:	e9 4a f2 ff ff       	jmp    801061e9 <alltraps>

80106f9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $222
80106fa1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106fa6:	e9 3e f2 ff ff       	jmp    801061e9 <alltraps>

80106fab <vector223>:
.globl vector223
vector223:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $223
80106fad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106fb2:	e9 32 f2 ff ff       	jmp    801061e9 <alltraps>

80106fb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $224
80106fb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106fbe:	e9 26 f2 ff ff       	jmp    801061e9 <alltraps>

80106fc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $225
80106fc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106fca:	e9 1a f2 ff ff       	jmp    801061e9 <alltraps>

80106fcf <vector226>:
.globl vector226
vector226:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $226
80106fd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fd6:	e9 0e f2 ff ff       	jmp    801061e9 <alltraps>

80106fdb <vector227>:
.globl vector227
vector227:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $227
80106fdd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fe2:	e9 02 f2 ff ff       	jmp    801061e9 <alltraps>

80106fe7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $228
80106fe9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fee:	e9 f6 f1 ff ff       	jmp    801061e9 <alltraps>

80106ff3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $229
80106ff5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106ffa:	e9 ea f1 ff ff       	jmp    801061e9 <alltraps>

80106fff <vector230>:
.globl vector230
vector230:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $230
80107001:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107006:	e9 de f1 ff ff       	jmp    801061e9 <alltraps>

8010700b <vector231>:
.globl vector231
vector231:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $231
8010700d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107012:	e9 d2 f1 ff ff       	jmp    801061e9 <alltraps>

80107017 <vector232>:
.globl vector232
vector232:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $232
80107019:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010701e:	e9 c6 f1 ff ff       	jmp    801061e9 <alltraps>

80107023 <vector233>:
.globl vector233
vector233:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $233
80107025:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010702a:	e9 ba f1 ff ff       	jmp    801061e9 <alltraps>

8010702f <vector234>:
.globl vector234
vector234:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $234
80107031:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107036:	e9 ae f1 ff ff       	jmp    801061e9 <alltraps>

8010703b <vector235>:
.globl vector235
vector235:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $235
8010703d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107042:	e9 a2 f1 ff ff       	jmp    801061e9 <alltraps>

80107047 <vector236>:
.globl vector236
vector236:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $236
80107049:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010704e:	e9 96 f1 ff ff       	jmp    801061e9 <alltraps>

80107053 <vector237>:
.globl vector237
vector237:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $237
80107055:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010705a:	e9 8a f1 ff ff       	jmp    801061e9 <alltraps>

8010705f <vector238>:
.globl vector238
vector238:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $238
80107061:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107066:	e9 7e f1 ff ff       	jmp    801061e9 <alltraps>

8010706b <vector239>:
.globl vector239
vector239:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $239
8010706d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107072:	e9 72 f1 ff ff       	jmp    801061e9 <alltraps>

80107077 <vector240>:
.globl vector240
vector240:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $240
80107079:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010707e:	e9 66 f1 ff ff       	jmp    801061e9 <alltraps>

80107083 <vector241>:
.globl vector241
vector241:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $241
80107085:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010708a:	e9 5a f1 ff ff       	jmp    801061e9 <alltraps>

8010708f <vector242>:
.globl vector242
vector242:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $242
80107091:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107096:	e9 4e f1 ff ff       	jmp    801061e9 <alltraps>

8010709b <vector243>:
.globl vector243
vector243:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $243
8010709d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801070a2:	e9 42 f1 ff ff       	jmp    801061e9 <alltraps>

801070a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $244
801070a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801070ae:	e9 36 f1 ff ff       	jmp    801061e9 <alltraps>

801070b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $245
801070b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801070ba:	e9 2a f1 ff ff       	jmp    801061e9 <alltraps>

801070bf <vector246>:
.globl vector246
vector246:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $246
801070c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070c6:	e9 1e f1 ff ff       	jmp    801061e9 <alltraps>

801070cb <vector247>:
.globl vector247
vector247:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $247
801070cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070d2:	e9 12 f1 ff ff       	jmp    801061e9 <alltraps>

801070d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $248
801070d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070de:	e9 06 f1 ff ff       	jmp    801061e9 <alltraps>

801070e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $249
801070e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070ea:	e9 fa f0 ff ff       	jmp    801061e9 <alltraps>

801070ef <vector250>:
.globl vector250
vector250:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $250
801070f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070f6:	e9 ee f0 ff ff       	jmp    801061e9 <alltraps>

801070fb <vector251>:
.globl vector251
vector251:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $251
801070fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107102:	e9 e2 f0 ff ff       	jmp    801061e9 <alltraps>

80107107 <vector252>:
.globl vector252
vector252:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $252
80107109:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010710e:	e9 d6 f0 ff ff       	jmp    801061e9 <alltraps>

80107113 <vector253>:
.globl vector253
vector253:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $253
80107115:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010711a:	e9 ca f0 ff ff       	jmp    801061e9 <alltraps>

8010711f <vector254>:
.globl vector254
vector254:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $254
80107121:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107126:	e9 be f0 ff ff       	jmp    801061e9 <alltraps>

8010712b <vector255>:
.globl vector255
vector255:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $255
8010712d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107132:	e9 b2 f0 ff ff       	jmp    801061e9 <alltraps>
80107137:	66 90                	xchg   %ax,%ax
80107139:	66 90                	xchg   %ax,%ax
8010713b:	66 90                	xchg   %ax,%ax
8010713d:	66 90                	xchg   %ax,%ax
8010713f:	90                   	nop

80107140 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107146:	89 d3                	mov    %edx,%ebx
{
80107148:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010714a:	c1 eb 16             	shr    $0x16,%ebx
8010714d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107150:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107153:	8b 06                	mov    (%esi),%eax
80107155:	a8 01                	test   $0x1,%al
80107157:	74 27                	je     80107180 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107159:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010715e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107164:	c1 ef 0a             	shr    $0xa,%edi
}
80107167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010716a:	89 fa                	mov    %edi,%edx
8010716c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107172:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107175:	5b                   	pop    %ebx
80107176:	5e                   	pop    %esi
80107177:	5f                   	pop    %edi
80107178:	5d                   	pop    %ebp
80107179:	c3                   	ret    
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107180:	85 c9                	test   %ecx,%ecx
80107182:	74 2c                	je     801071b0 <walkpgdir+0x70>
80107184:	e8 57 b3 ff ff       	call   801024e0 <kalloc>
80107189:	85 c0                	test   %eax,%eax
8010718b:	89 c3                	mov    %eax,%ebx
8010718d:	74 21                	je     801071b0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010718f:	83 ec 04             	sub    $0x4,%esp
80107192:	68 00 10 00 00       	push   $0x1000
80107197:	6a 00                	push   $0x0
80107199:	50                   	push   %eax
8010719a:	e8 a1 dd ff ff       	call   80104f40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010719f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071a5:	83 c4 10             	add    $0x10,%esp
801071a8:	83 c8 07             	or     $0x7,%eax
801071ab:	89 06                	mov    %eax,(%esi)
801071ad:	eb b5                	jmp    80107164 <walkpgdir+0x24>
801071af:	90                   	nop
}
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801071b3:	31 c0                	xor    %eax,%eax
}
801071b5:	5b                   	pop    %ebx
801071b6:	5e                   	pop    %esi
801071b7:	5f                   	pop    %edi
801071b8:	5d                   	pop    %ebp
801071b9:	c3                   	ret    
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071c0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801071c6:	89 d3                	mov    %edx,%ebx
801071c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801071ce:	83 ec 1c             	sub    $0x1c,%esp
801071d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071d4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071d8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801071e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e6:	29 df                	sub    %ebx,%edi
801071e8:	83 c8 01             	or     $0x1,%eax
801071eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071ee:	eb 15                	jmp    80107205 <mappages+0x45>
    if(*pte & PTE_P)
801071f0:	f6 00 01             	testb  $0x1,(%eax)
801071f3:	75 45                	jne    8010723a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801071f5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801071f8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801071fb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071fd:	74 31                	je     80107230 <mappages+0x70>
      break;
    a += PGSIZE;
801071ff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107205:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107208:	b9 01 00 00 00       	mov    $0x1,%ecx
8010720d:	89 da                	mov    %ebx,%edx
8010720f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107212:	e8 29 ff ff ff       	call   80107140 <walkpgdir>
80107217:	85 c0                	test   %eax,%eax
80107219:	75 d5                	jne    801071f0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010721b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010721e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107223:	5b                   	pop    %ebx
80107224:	5e                   	pop    %esi
80107225:	5f                   	pop    %edi
80107226:	5d                   	pop    %ebp
80107227:	c3                   	ret    
80107228:	90                   	nop
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
      panic("remap");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 60 85 10 80       	push   $0x80108560
80107242:	e8 49 91 ff ff       	call   80100390 <panic>
80107247:	89 f6                	mov    %esi,%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107256:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010725c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010725e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107264:	83 ec 1c             	sub    $0x1c,%esp
80107267:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010726a:	39 d3                	cmp    %edx,%ebx
8010726c:	73 66                	jae    801072d4 <deallocuvm.part.0+0x84>
8010726e:	89 d6                	mov    %edx,%esi
80107270:	eb 3d                	jmp    801072af <deallocuvm.part.0+0x5f>
80107272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107278:	8b 10                	mov    (%eax),%edx
8010727a:	f6 c2 01             	test   $0x1,%dl
8010727d:	74 26                	je     801072a5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010727f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107285:	74 58                	je     801072df <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107287:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010728a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107293:	52                   	push   %edx
80107294:	e8 97 b0 ff ff       	call   80102330 <kfree>
      *pte = 0;
80107299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010729c:	83 c4 10             	add    $0x10,%esp
8010729f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801072a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072ab:	39 f3                	cmp    %esi,%ebx
801072ad:	73 25                	jae    801072d4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801072af:	31 c9                	xor    %ecx,%ecx
801072b1:	89 da                	mov    %ebx,%edx
801072b3:	89 f8                	mov    %edi,%eax
801072b5:	e8 86 fe ff ff       	call   80107140 <walkpgdir>
    if(!pte)
801072ba:	85 c0                	test   %eax,%eax
801072bc:	75 ba                	jne    80107278 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072be:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801072c4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801072ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072d0:	39 f3                	cmp    %esi,%ebx
801072d2:	72 db                	jb     801072af <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801072d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072da:	5b                   	pop    %ebx
801072db:	5e                   	pop    %esi
801072dc:	5f                   	pop    %edi
801072dd:	5d                   	pop    %ebp
801072de:	c3                   	ret    
        panic("kfree");
801072df:	83 ec 0c             	sub    $0xc,%esp
801072e2:	68 e6 7c 10 80       	push   $0x80107ce6
801072e7:	e8 a4 90 ff ff       	call   80100390 <panic>
801072ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072f0 <seginit>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072f6:	e8 55 c6 ff ff       	call   80103950 <cpuid>
801072fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107301:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107306:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010730a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107311:	ff 00 00 
80107314:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010731b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010731e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107325:	ff 00 00 
80107328:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010732f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107332:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107339:	ff 00 00 
8010733c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107343:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107346:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
8010734d:	ff 00 00 
80107350:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107357:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010735a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
8010735f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107363:	c1 e8 10             	shr    $0x10,%eax
80107366:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010736a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010736d:	0f 01 10             	lgdtl  (%eax)
}
80107370:	c9                   	leave  
80107371:	c3                   	ret    
80107372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107380 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107380:	a1 c4 64 11 80       	mov    0x801164c4,%eax
{
80107385:	55                   	push   %ebp
80107386:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107388:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010738d:	0f 22 d8             	mov    %eax,%cr3
}
80107390:	5d                   	pop    %ebp
80107391:	c3                   	ret    
80107392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073a0 <switchuvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 1c             	sub    $0x1c,%esp
801073a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801073ac:	85 db                	test   %ebx,%ebx
801073ae:	0f 84 cb 00 00 00    	je     8010747f <switchuvm+0xdf>
  if(p->kstack == 0)
801073b4:	8b 43 08             	mov    0x8(%ebx),%eax
801073b7:	85 c0                	test   %eax,%eax
801073b9:	0f 84 da 00 00 00    	je     80107499 <switchuvm+0xf9>
  if(p->pgdir == 0)
801073bf:	8b 43 04             	mov    0x4(%ebx),%eax
801073c2:	85 c0                	test   %eax,%eax
801073c4:	0f 84 c2 00 00 00    	je     8010748c <switchuvm+0xec>
  pushcli();
801073ca:	e8 91 d9 ff ff       	call   80104d60 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073cf:	e8 2c c5 ff ff       	call   80103900 <mycpu>
801073d4:	89 c6                	mov    %eax,%esi
801073d6:	e8 25 c5 ff ff       	call   80103900 <mycpu>
801073db:	89 c7                	mov    %eax,%edi
801073dd:	e8 1e c5 ff ff       	call   80103900 <mycpu>
801073e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073e5:	83 c7 08             	add    $0x8,%edi
801073e8:	e8 13 c5 ff ff       	call   80103900 <mycpu>
801073ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073f0:	83 c0 08             	add    $0x8,%eax
801073f3:	ba 67 00 00 00       	mov    $0x67,%edx
801073f8:	c1 e8 18             	shr    $0x18,%eax
801073fb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107402:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107409:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010740f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107414:	83 c1 08             	add    $0x8,%ecx
80107417:	c1 e9 10             	shr    $0x10,%ecx
8010741a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107420:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107425:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010742c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107431:	e8 ca c4 ff ff       	call   80103900 <mycpu>
80107436:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010743d:	e8 be c4 ff ff       	call   80103900 <mycpu>
80107442:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107446:	8b 73 08             	mov    0x8(%ebx),%esi
80107449:	e8 b2 c4 ff ff       	call   80103900 <mycpu>
8010744e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107454:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107457:	e8 a4 c4 ff ff       	call   80103900 <mycpu>
8010745c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107460:	b8 28 00 00 00       	mov    $0x28,%eax
80107465:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107468:	8b 43 04             	mov    0x4(%ebx),%eax
8010746b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107470:	0f 22 d8             	mov    %eax,%cr3
}
80107473:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107476:	5b                   	pop    %ebx
80107477:	5e                   	pop    %esi
80107478:	5f                   	pop    %edi
80107479:	5d                   	pop    %ebp
  popcli();
8010747a:	e9 21 d9 ff ff       	jmp    80104da0 <popcli>
    panic("switchuvm: no process");
8010747f:	83 ec 0c             	sub    $0xc,%esp
80107482:	68 66 85 10 80       	push   $0x80108566
80107487:	e8 04 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010748c:	83 ec 0c             	sub    $0xc,%esp
8010748f:	68 91 85 10 80       	push   $0x80108591
80107494:	e8 f7 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107499:	83 ec 0c             	sub    $0xc,%esp
8010749c:	68 7c 85 10 80       	push   $0x8010857c
801074a1:	e8 ea 8e ff ff       	call   80100390 <panic>
801074a6:	8d 76 00             	lea    0x0(%esi),%esi
801074a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074b0 <inituvm>:
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
801074b9:	8b 75 10             	mov    0x10(%ebp),%esi
801074bc:	8b 45 08             	mov    0x8(%ebp),%eax
801074bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801074c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801074c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074cb:	77 49                	ja     80107516 <inituvm+0x66>
  mem = kalloc();
801074cd:	e8 0e b0 ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
801074d2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801074d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801074d7:	68 00 10 00 00       	push   $0x1000
801074dc:	6a 00                	push   $0x0
801074de:	50                   	push   %eax
801074df:	e8 5c da ff ff       	call   80104f40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801074e4:	58                   	pop    %eax
801074e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074f0:	5a                   	pop    %edx
801074f1:	6a 06                	push   $0x6
801074f3:	50                   	push   %eax
801074f4:	31 d2                	xor    %edx,%edx
801074f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f9:	e8 c2 fc ff ff       	call   801071c0 <mappages>
  memmove(mem, init, sz);
801074fe:	89 75 10             	mov    %esi,0x10(%ebp)
80107501:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107504:	83 c4 10             	add    $0x10,%esp
80107507:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010750a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750d:	5b                   	pop    %ebx
8010750e:	5e                   	pop    %esi
8010750f:	5f                   	pop    %edi
80107510:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107511:	e9 da da ff ff       	jmp    80104ff0 <memmove>
    panic("inituvm: more than a page");
80107516:	83 ec 0c             	sub    $0xc,%esp
80107519:	68 a5 85 10 80       	push   $0x801085a5
8010751e:	e8 6d 8e ff ff       	call   80100390 <panic>
80107523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107530 <loaduvm>:
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107539:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107540:	0f 85 91 00 00 00    	jne    801075d7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107546:	8b 75 18             	mov    0x18(%ebp),%esi
80107549:	31 db                	xor    %ebx,%ebx
8010754b:	85 f6                	test   %esi,%esi
8010754d:	75 1a                	jne    80107569 <loaduvm+0x39>
8010754f:	eb 6f                	jmp    801075c0 <loaduvm+0x90>
80107551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107558:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010755e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107564:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107567:	76 57                	jbe    801075c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107569:	8b 55 0c             	mov    0xc(%ebp),%edx
8010756c:	8b 45 08             	mov    0x8(%ebp),%eax
8010756f:	31 c9                	xor    %ecx,%ecx
80107571:	01 da                	add    %ebx,%edx
80107573:	e8 c8 fb ff ff       	call   80107140 <walkpgdir>
80107578:	85 c0                	test   %eax,%eax
8010757a:	74 4e                	je     801075ca <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010757c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010757e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107581:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010758b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107591:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107594:	01 d9                	add    %ebx,%ecx
80107596:	05 00 00 00 80       	add    $0x80000000,%eax
8010759b:	57                   	push   %edi
8010759c:	51                   	push   %ecx
8010759d:	50                   	push   %eax
8010759e:	ff 75 10             	pushl  0x10(%ebp)
801075a1:	e8 da a3 ff ff       	call   80101980 <readi>
801075a6:	83 c4 10             	add    $0x10,%esp
801075a9:	39 f8                	cmp    %edi,%eax
801075ab:	74 ab                	je     80107558 <loaduvm+0x28>
}
801075ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075b5:	5b                   	pop    %ebx
801075b6:	5e                   	pop    %esi
801075b7:	5f                   	pop    %edi
801075b8:	5d                   	pop    %ebp
801075b9:	c3                   	ret    
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075c3:	31 c0                	xor    %eax,%eax
}
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801075ca:	83 ec 0c             	sub    $0xc,%esp
801075cd:	68 bf 85 10 80       	push   $0x801085bf
801075d2:	e8 b9 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801075d7:	83 ec 0c             	sub    $0xc,%esp
801075da:	68 60 86 10 80       	push   $0x80108660
801075df:	e8 ac 8d ff ff       	call   80100390 <panic>
801075e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075f0 <allocuvm>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075f9:	8b 7d 10             	mov    0x10(%ebp),%edi
801075fc:	85 ff                	test   %edi,%edi
801075fe:	0f 88 8e 00 00 00    	js     80107692 <allocuvm+0xa2>
  if(newsz < oldsz)
80107604:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107607:	0f 82 93 00 00 00    	jb     801076a0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010760d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107610:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107616:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010761c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010761f:	0f 86 7e 00 00 00    	jbe    801076a3 <allocuvm+0xb3>
80107625:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107628:	8b 7d 08             	mov    0x8(%ebp),%edi
8010762b:	eb 42                	jmp    8010766f <allocuvm+0x7f>
8010762d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107630:	83 ec 04             	sub    $0x4,%esp
80107633:	68 00 10 00 00       	push   $0x1000
80107638:	6a 00                	push   $0x0
8010763a:	50                   	push   %eax
8010763b:	e8 00 d9 ff ff       	call   80104f40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107640:	58                   	pop    %eax
80107641:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107647:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010764c:	5a                   	pop    %edx
8010764d:	6a 06                	push   $0x6
8010764f:	50                   	push   %eax
80107650:	89 da                	mov    %ebx,%edx
80107652:	89 f8                	mov    %edi,%eax
80107654:	e8 67 fb ff ff       	call   801071c0 <mappages>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	85 c0                	test   %eax,%eax
8010765e:	78 50                	js     801076b0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107660:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107666:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107669:	0f 86 81 00 00 00    	jbe    801076f0 <allocuvm+0x100>
    mem = kalloc();
8010766f:	e8 6c ae ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
80107674:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107676:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107678:	75 b6                	jne    80107630 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010767a:	83 ec 0c             	sub    $0xc,%esp
8010767d:	68 dd 85 10 80       	push   $0x801085dd
80107682:	e8 d9 8f ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107687:	83 c4 10             	add    $0x10,%esp
8010768a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010768d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107690:	77 6e                	ja     80107700 <allocuvm+0x110>
}
80107692:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107695:	31 ff                	xor    %edi,%edi
}
80107697:	89 f8                	mov    %edi,%eax
80107699:	5b                   	pop    %ebx
8010769a:	5e                   	pop    %esi
8010769b:	5f                   	pop    %edi
8010769c:	5d                   	pop    %ebp
8010769d:	c3                   	ret    
8010769e:	66 90                	xchg   %ax,%ax
    return oldsz;
801076a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801076a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a6:	89 f8                	mov    %edi,%eax
801076a8:	5b                   	pop    %ebx
801076a9:	5e                   	pop    %esi
801076aa:	5f                   	pop    %edi
801076ab:	5d                   	pop    %ebp
801076ac:	c3                   	ret    
801076ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	68 f5 85 10 80       	push   $0x801085f5
801076b8:	e8 a3 8f ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801076bd:	83 c4 10             	add    $0x10,%esp
801076c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801076c3:	39 45 10             	cmp    %eax,0x10(%ebp)
801076c6:	76 0d                	jbe    801076d5 <allocuvm+0xe5>
801076c8:	89 c1                	mov    %eax,%ecx
801076ca:	8b 55 10             	mov    0x10(%ebp),%edx
801076cd:	8b 45 08             	mov    0x8(%ebp),%eax
801076d0:	e8 7b fb ff ff       	call   80107250 <deallocuvm.part.0>
      kfree(mem);
801076d5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801076d8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801076da:	56                   	push   %esi
801076db:	e8 50 ac ff ff       	call   80102330 <kfree>
      return 0;
801076e0:	83 c4 10             	add    $0x10,%esp
}
801076e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e6:	89 f8                	mov    %edi,%eax
801076e8:	5b                   	pop    %ebx
801076e9:	5e                   	pop    %esi
801076ea:	5f                   	pop    %edi
801076eb:	5d                   	pop    %ebp
801076ec:	c3                   	ret    
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
801076f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801076f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076f6:	5b                   	pop    %ebx
801076f7:	89 f8                	mov    %edi,%eax
801076f9:	5e                   	pop    %esi
801076fa:	5f                   	pop    %edi
801076fb:	5d                   	pop    %ebp
801076fc:	c3                   	ret    
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
80107700:	89 c1                	mov    %eax,%ecx
80107702:	8b 55 10             	mov    0x10(%ebp),%edx
80107705:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107708:	31 ff                	xor    %edi,%edi
8010770a:	e8 41 fb ff ff       	call   80107250 <deallocuvm.part.0>
8010770f:	eb 92                	jmp    801076a3 <allocuvm+0xb3>
80107711:	eb 0d                	jmp    80107720 <deallocuvm>
80107713:	90                   	nop
80107714:	90                   	nop
80107715:	90                   	nop
80107716:	90                   	nop
80107717:	90                   	nop
80107718:	90                   	nop
80107719:	90                   	nop
8010771a:	90                   	nop
8010771b:	90                   	nop
8010771c:	90                   	nop
8010771d:	90                   	nop
8010771e:	90                   	nop
8010771f:	90                   	nop

80107720 <deallocuvm>:
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	8b 55 0c             	mov    0xc(%ebp),%edx
80107726:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107729:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010772c:	39 d1                	cmp    %edx,%ecx
8010772e:	73 10                	jae    80107740 <deallocuvm+0x20>
}
80107730:	5d                   	pop    %ebp
80107731:	e9 1a fb ff ff       	jmp    80107250 <deallocuvm.part.0>
80107736:	8d 76 00             	lea    0x0(%esi),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107740:	89 d0                	mov    %edx,%eax
80107742:	5d                   	pop    %ebp
80107743:	c3                   	ret    
80107744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010774a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107750 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 0c             	sub    $0xc,%esp
80107759:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010775c:	85 f6                	test   %esi,%esi
8010775e:	74 59                	je     801077b9 <freevm+0x69>
80107760:	31 c9                	xor    %ecx,%ecx
80107762:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107767:	89 f0                	mov    %esi,%eax
80107769:	e8 e2 fa ff ff       	call   80107250 <deallocuvm.part.0>
8010776e:	89 f3                	mov    %esi,%ebx
80107770:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107776:	eb 0f                	jmp    80107787 <freevm+0x37>
80107778:	90                   	nop
80107779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107780:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107783:	39 fb                	cmp    %edi,%ebx
80107785:	74 23                	je     801077aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107787:	8b 03                	mov    (%ebx),%eax
80107789:	a8 01                	test   $0x1,%al
8010778b:	74 f3                	je     80107780 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010778d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107792:	83 ec 0c             	sub    $0xc,%esp
80107795:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107798:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010779d:	50                   	push   %eax
8010779e:	e8 8d ab ff ff       	call   80102330 <kfree>
801077a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077a6:	39 fb                	cmp    %edi,%ebx
801077a8:	75 dd                	jne    80107787 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801077aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b0:	5b                   	pop    %ebx
801077b1:	5e                   	pop    %esi
801077b2:	5f                   	pop    %edi
801077b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077b4:	e9 77 ab ff ff       	jmp    80102330 <kfree>
    panic("freevm: no pgdir");
801077b9:	83 ec 0c             	sub    $0xc,%esp
801077bc:	68 11 86 10 80       	push   $0x80108611
801077c1:	e8 ca 8b ff ff       	call   80100390 <panic>
801077c6:	8d 76 00             	lea    0x0(%esi),%esi
801077c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077d0 <setupkvm>:
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	56                   	push   %esi
801077d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077d5:	e8 06 ad ff ff       	call   801024e0 <kalloc>
801077da:	85 c0                	test   %eax,%eax
801077dc:	89 c6                	mov    %eax,%esi
801077de:	74 42                	je     80107822 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077e8:	68 00 10 00 00       	push   $0x1000
801077ed:	6a 00                	push   $0x0
801077ef:	50                   	push   %eax
801077f0:	e8 4b d7 ff ff       	call   80104f40 <memset>
801077f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077fb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077fe:	83 ec 08             	sub    $0x8,%esp
80107801:	8b 13                	mov    (%ebx),%edx
80107803:	ff 73 0c             	pushl  0xc(%ebx)
80107806:	50                   	push   %eax
80107807:	29 c1                	sub    %eax,%ecx
80107809:	89 f0                	mov    %esi,%eax
8010780b:	e8 b0 f9 ff ff       	call   801071c0 <mappages>
80107810:	83 c4 10             	add    $0x10,%esp
80107813:	85 c0                	test   %eax,%eax
80107815:	78 19                	js     80107830 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107817:	83 c3 10             	add    $0x10,%ebx
8010781a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107820:	75 d6                	jne    801077f8 <setupkvm+0x28>
}
80107822:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107825:	89 f0                	mov    %esi,%eax
80107827:	5b                   	pop    %ebx
80107828:	5e                   	pop    %esi
80107829:	5d                   	pop    %ebp
8010782a:	c3                   	ret    
8010782b:	90                   	nop
8010782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107830:	83 ec 0c             	sub    $0xc,%esp
80107833:	56                   	push   %esi
      return 0;
80107834:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107836:	e8 15 ff ff ff       	call   80107750 <freevm>
      return 0;
8010783b:	83 c4 10             	add    $0x10,%esp
}
8010783e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107841:	89 f0                	mov    %esi,%eax
80107843:	5b                   	pop    %ebx
80107844:	5e                   	pop    %esi
80107845:	5d                   	pop    %ebp
80107846:	c3                   	ret    
80107847:	89 f6                	mov    %esi,%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107850 <kvmalloc>:
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107856:	e8 75 ff ff ff       	call   801077d0 <setupkvm>
8010785b:	a3 c4 64 11 80       	mov    %eax,0x801164c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107860:	05 00 00 00 80       	add    $0x80000000,%eax
80107865:	0f 22 d8             	mov    %eax,%cr3
}
80107868:	c9                   	leave  
80107869:	c3                   	ret    
8010786a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107870 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107870:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107871:	31 c9                	xor    %ecx,%ecx
{
80107873:	89 e5                	mov    %esp,%ebp
80107875:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107878:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787b:	8b 45 08             	mov    0x8(%ebp),%eax
8010787e:	e8 bd f8 ff ff       	call   80107140 <walkpgdir>
  if(pte == 0)
80107883:	85 c0                	test   %eax,%eax
80107885:	74 05                	je     8010788c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107887:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010788a:	c9                   	leave  
8010788b:	c3                   	ret    
    panic("clearpteu");
8010788c:	83 ec 0c             	sub    $0xc,%esp
8010788f:	68 22 86 10 80       	push   $0x80108622
80107894:	e8 f7 8a ff ff       	call   80100390 <panic>
80107899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	57                   	push   %edi
801078a4:	56                   	push   %esi
801078a5:	53                   	push   %ebx
801078a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078a9:	e8 22 ff ff ff       	call   801077d0 <setupkvm>
801078ae:	85 c0                	test   %eax,%eax
801078b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078b3:	0f 84 9f 00 00 00    	je     80107958 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078bc:	85 c9                	test   %ecx,%ecx
801078be:	0f 84 94 00 00 00    	je     80107958 <copyuvm+0xb8>
801078c4:	31 ff                	xor    %edi,%edi
801078c6:	eb 4a                	jmp    80107912 <copyuvm+0x72>
801078c8:	90                   	nop
801078c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078d0:	83 ec 04             	sub    $0x4,%esp
801078d3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801078d9:	68 00 10 00 00       	push   $0x1000
801078de:	53                   	push   %ebx
801078df:	50                   	push   %eax
801078e0:	e8 0b d7 ff ff       	call   80104ff0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078e5:	58                   	pop    %eax
801078e6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801078ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078f1:	5a                   	pop    %edx
801078f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801078f5:	50                   	push   %eax
801078f6:	89 fa                	mov    %edi,%edx
801078f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078fb:	e8 c0 f8 ff ff       	call   801071c0 <mappages>
80107900:	83 c4 10             	add    $0x10,%esp
80107903:	85 c0                	test   %eax,%eax
80107905:	78 61                	js     80107968 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107907:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010790d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107910:	76 46                	jbe    80107958 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107912:	8b 45 08             	mov    0x8(%ebp),%eax
80107915:	31 c9                	xor    %ecx,%ecx
80107917:	89 fa                	mov    %edi,%edx
80107919:	e8 22 f8 ff ff       	call   80107140 <walkpgdir>
8010791e:	85 c0                	test   %eax,%eax
80107920:	74 61                	je     80107983 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107922:	8b 00                	mov    (%eax),%eax
80107924:	a8 01                	test   $0x1,%al
80107926:	74 4e                	je     80107976 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107928:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010792a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010792f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107935:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107938:	e8 a3 ab ff ff       	call   801024e0 <kalloc>
8010793d:	85 c0                	test   %eax,%eax
8010793f:	89 c6                	mov    %eax,%esi
80107941:	75 8d                	jne    801078d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107943:	83 ec 0c             	sub    $0xc,%esp
80107946:	ff 75 e0             	pushl  -0x20(%ebp)
80107949:	e8 02 fe ff ff       	call   80107750 <freevm>
  return 0;
8010794e:	83 c4 10             	add    $0x10,%esp
80107951:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107958:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795e:	5b                   	pop    %ebx
8010795f:	5e                   	pop    %esi
80107960:	5f                   	pop    %edi
80107961:	5d                   	pop    %ebp
80107962:	c3                   	ret    
80107963:	90                   	nop
80107964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	56                   	push   %esi
8010796c:	e8 bf a9 ff ff       	call   80102330 <kfree>
      goto bad;
80107971:	83 c4 10             	add    $0x10,%esp
80107974:	eb cd                	jmp    80107943 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	68 46 86 10 80       	push   $0x80108646
8010797e:	e8 0d 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107983:	83 ec 0c             	sub    $0xc,%esp
80107986:	68 2c 86 10 80       	push   $0x8010862c
8010798b:	e8 00 8a ff ff       	call   80100390 <panic>

80107990 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107990:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107991:	31 c9                	xor    %ecx,%ecx
{
80107993:	89 e5                	mov    %esp,%ebp
80107995:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107998:	8b 55 0c             	mov    0xc(%ebp),%edx
8010799b:	8b 45 08             	mov    0x8(%ebp),%eax
8010799e:	e8 9d f7 ff ff       	call   80107140 <walkpgdir>
  if((*pte & PTE_P) == 0)
801079a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079a5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801079a6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079ad:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079b0:	05 00 00 00 80       	add    $0x80000000,%eax
801079b5:	83 fa 05             	cmp    $0x5,%edx
801079b8:	ba 00 00 00 00       	mov    $0x0,%edx
801079bd:	0f 45 c2             	cmovne %edx,%eax
}
801079c0:	c3                   	ret    
801079c1:	eb 0d                	jmp    801079d0 <copyout>
801079c3:	90                   	nop
801079c4:	90                   	nop
801079c5:	90                   	nop
801079c6:	90                   	nop
801079c7:	90                   	nop
801079c8:	90                   	nop
801079c9:	90                   	nop
801079ca:	90                   	nop
801079cb:	90                   	nop
801079cc:	90                   	nop
801079cd:	90                   	nop
801079ce:	90                   	nop
801079cf:	90                   	nop

801079d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 1c             	sub    $0x1c,%esp
801079d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801079dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801079df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079e2:	85 db                	test   %ebx,%ebx
801079e4:	75 40                	jne    80107a26 <copyout+0x56>
801079e6:	eb 70                	jmp    80107a58 <copyout+0x88>
801079e8:	90                   	nop
801079e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801079f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801079f3:	89 f1                	mov    %esi,%ecx
801079f5:	29 d1                	sub    %edx,%ecx
801079f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801079fd:	39 d9                	cmp    %ebx,%ecx
801079ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a02:	29 f2                	sub    %esi,%edx
80107a04:	83 ec 04             	sub    $0x4,%esp
80107a07:	01 d0                	add    %edx,%eax
80107a09:	51                   	push   %ecx
80107a0a:	57                   	push   %edi
80107a0b:	50                   	push   %eax
80107a0c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a0f:	e8 dc d5 ff ff       	call   80104ff0 <memmove>
    len -= n;
    buf += n;
80107a14:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107a17:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107a1a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107a20:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107a22:	29 cb                	sub    %ecx,%ebx
80107a24:	74 32                	je     80107a58 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a26:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a28:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a2e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a34:	56                   	push   %esi
80107a35:	ff 75 08             	pushl  0x8(%ebp)
80107a38:	e8 53 ff ff ff       	call   80107990 <uva2ka>
    if(pa0 == 0)
80107a3d:	83 c4 10             	add    $0x10,%esp
80107a40:	85 c0                	test   %eax,%eax
80107a42:	75 ac                	jne    801079f0 <copyout+0x20>
  }
  return 0;
}
80107a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a4c:	5b                   	pop    %ebx
80107a4d:	5e                   	pop    %esi
80107a4e:	5f                   	pop    %edi
80107a4f:	5d                   	pop    %ebp
80107a50:	c3                   	ret    
80107a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a5b:	31 c0                	xor    %eax,%eax
}
80107a5d:	5b                   	pop    %ebx
80107a5e:	5e                   	pop    %esi
80107a5f:	5f                   	pop    %edi
80107a60:	5d                   	pop    %ebp
80107a61:	c3                   	ret    

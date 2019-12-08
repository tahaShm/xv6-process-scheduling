#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

#define MAX_PROC_NUMBER 256

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->ticket = 10;
  p->ticks = ticks;
  p->queueNum = 0;
  p->cycleNum = 1;
  p->remainingPriority = 10;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

void reverse(char* str, int len) {
  char temp;
  for (int i = 0; i < len / 2; i++) {
    temp = str[i];
    str[i] = str[len - i - 1];
    str[len - i - 1] = temp;
  }
}

char* itoa(int num, char* str) { 
    int i = 0; 
    int isNegative = 0; 
  
    if (num == 0) { 
        str[i++] = '0'; 
        str[i] = '\0'; 
        return str; 
    } 
  
    if (num < 0 && 10 == 10) { 
        isNegative = 1; 
        num = -num; 
    } 

    while (num != 0) { 
        int rem = num % 10; 
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0'; 
        num = num/10; 
    } 
  
    
    if (isNegative) 
        str[i++] = '-'; 
  
    str[i] = '\0'; 
    reverse(str, i); 
  
    return str; 
} 

  
char* ftos(float f, char* str) {
 	int count;
 	char* curr;
 	int value;
 	value = (int)f;
 	itoa(value,str);
 	count = 0;
 	curr = str;
 	while(*curr != 0){
 		++count;
 		++curr;
 	}
 
 	if(count + 1 >= MAXFLOATLEN) {
 		str[MAXFLOATLEN - 1] = 0;
 		return str;	
 	}
 	
 	str[count++] = '.';
 	++curr;
 	f = f - (float)value;
 	
 	while(count + 1 < MAXFLOATLEN) {
 		f *= 10;
 		++count;	
 	}
 	
 	value = (int)f;
 	itoa(value,curr);
 	str[MAXFLOATLEN - 1] = 0;
 	return str;
}

int findRunnableProcLottery (struct proc * queue0[], int q0Index){
  int ticketNums = 0;
  if(q0Index == 0)
    return -1;
  for (int i = 0; i < q0Index; i++) {
    ticketNums += queue0[i]->ticket;
  }
  acquire(&tickslock);
  int randomNum = (ticks * ticks) % ticketNums;
  release(&tickslock);
  int i = 0;
  // cprintf("random num is : %d\n", randomNum);
  while(randomNum > 0) {
    randomNum -= queue0[i]->ticket;
    i++;
  }
  if (i == 0)
    return queue0[0]->pid;
  return queue0[i-1]->pid;
} 

int findRunnableProcHRRN (struct proc * queue1[], int q1Index){
  acquire(&tickslock);
  int currTick = ticks;
  release(&tickslock);
  int maxIndex = -1;
  float max = -1;
  for (int i = 0; i < q1Index; i++){
    // char a[MAXFLOATLEN], b[MAXFLOATLEN];
    float waitingTime = (float)(currTick - queue1[i]->ticks);
    // ftos(waitingTime, b);
    // cprintf("Waiting time is : %d!!!!!!!!!!!!\n", currTick - queue1[i]->ticks);
    float HRRN = waitingTime/(float)(queue1[i]->cycleNum);
    // ftos(HRRN, a);
    // cprintf("HRRN time is : %s!!!!!!!!!!!!\n", a);
    if(HRRN > max) {
      max = HRRN;
      maxIndex = i;
    }
  }
  
  if(q1Index == 0)
    return -1;
  else
    return queue1[maxIndex]->pid; 
}

int findRunnableProcSRPF (struct proc * queue2[], int q2Index){
  if(q2Index == 0)
    return -1;
  float min = queue2[0]->remainingPriority;
  int minIndex = 0;
  for (int i = 0; i < q2Index; i++) {
    if (min > queue2[i]->remainingPriority) {
      min = queue2[i]->remainingPriority;
      minIndex = i;
    }
  }
  if (queue2[minIndex]->remainingPriority - 0.1 > 0)
    queue2[minIndex]->remainingPriority -= 0.1;
  else 
    queue2[minIndex]->remainingPriority = 0;
  return queue2[minIndex]->pid;
}

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;) {
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // int currQueueTaskExits = 0, currQueue = 0;

    struct proc *queue0[MAX_PROC_NUMBER], *queue1[MAX_PROC_NUMBER], *queue2[MAX_PROC_NUMBER];
    int q0index = 0, q1index = 0, q2index = 0; 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      
      if(p->state != RUNNABLE)
        continue;

      if(p->queueNum == 0){
        queue0[q0index] = p;
        q0index++;
      }
      else if(p->queueNum == 1){
        queue1[q1index] = p;
        q1index++;
      }
      else if(p->queueNum == 2){
        queue2[q2index] = p;
        q2index++;
      }
      // cprintf("q0index : %d, q1index: %d, q2index: %d \n", q0index, q1index, q2index);
    }    
    
    release(&ptable.lock);

    int pid;
    if ((pid = findRunnableProcLottery(queue0, q0index)) < 0) 
      if ((pid = findRunnableProcHRRN(queue1, q1index)) < 0) 
        if ((pid = findRunnableProcSRPF(queue2, q2index)) < 0)
          continue;
    // cprintf("pid is : %d\n", pid);
    acquire(&ptable.lock);
    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if (pid == p->pid)
        break;
    }

    p->cycleNum ++;
    
    // cprintf("queue is : %d\n", p->queueNum);
       
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
changeQueueNum(int pid , int queue) {
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      p->queueNum = queue;
      return 1;
    }
  }
  return -1;
}

int evalTicket(int pid, int ticket) {
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      p->ticket = ticket;
      return 1;
    }
  }
  return -1;
}

float stof(char* s) {
  float rez = 0, fact = 1;
  if (*s == '-'){
    s++;
    fact = -1;
  };
  for (int point_seen = 0; *s; s++){
    if (*s == '.'){
      point_seen = 1; 
      continue;
    };
    int d = *s - '0';
    if (d >= 0 && d <= 9){
      if (point_seen) fact /= 10.0f;
      rez = rez * 10.0f + (float)d;
    };
  };
  return rez * fact;
}

int evalRemainingPriority(int pid, char* priority) {
  float pri = stof(priority);
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid) {
      p->remainingPriority = pri;
      return 1;
    }
  }
  return -1;
}

char* generateHRRN(struct proc *p, char* out) {
  float hrrnTime;
  float waitingTime;
  waitingTime = (ticks - p->ticks) / 100;
  hrrnTime = (float)waitingTime / (float)p->cycleNum;
  ftos(hrrnTime, out);
  return out;
}


int printInfo(void) {
  char out[6];
  struct proc *p;
  sti();
  acquire(&ptable.lock);
  cprintf("---------------------------------------------------------------------");
  cprintf("---------------------------------------------------------------------\n");
  cprintf("name\t\tpid\t\tstate\t\tqueueNum\tpriority\ttickets\t\tcycles\t\tHRRN\t\ttimeCreated\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    char str[MAXFLOATLEN];
    if (p->state == EMBRYO)
      cprintf("%s\t\t%d\t\tEMBRYO\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == SLEEPING)
      cprintf("%s\t\t%d\t\tSLEEPING\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == RUNNABLE)
      cprintf("%s\t\t%d\t\tRUNNABLE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == RUNNING)
      cprintf("%s\t\t%d\t\tRUNNING\t\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
    if (p->state == ZOMBIE)
      cprintf("%s\t\t%d\t\tZOMBIE\t%d\t\t%s\t\t%d\t\t%d\t\t%s\t\t%d\n", p->name, p->pid, p->queueNum, ftos(p->remainingPriority, str), p->ticket, p->cycleNum, generateHRRN(p, out), p->ticks);
  }
  cprintf("---------------------------------------------------------------------");
  cprintf("---------------------------------------------------------------------\n");
  release(&ptable.lock);
  return 1;
}

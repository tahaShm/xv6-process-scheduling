#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char* argv[]) {
    
    // changeQueueNum(atoi(argv[1]), atoi(argv[2]));
    // evalRemainingPriority(atoi(argv[1]), argv[2]);
    // int pid = 0, pid2 = 0, pid3 = 0;
    // pid = fork();
    // if (pid == 0) {
    //     pid2 = fork();
    //     if (pid2 == 0) {
    //         pid3 = fork();
    //         if (pid3) {}
    //     }
    // }

    // printf(2, "Pid is : %d\n", pid);
    // printf(2, "Pid is : %d\n", pid2);
    // printf(2, "Pid is : %d\n", pid3);
    
    // wait();
    
    // printInfo();

    // int delay = 1000000;
    // while (delay > 0)
    // {
    //     delay--;
    // }

    int pid;
    for (int i = 0; i < 1; i++) {
        pid = fork();
        printInfo();
        // else {
            // if (pid > 0)
                // changeQueueNum(pid, pid % 3);
            if (pid == 0) {
                while(1) {}
            }
            wait();
        // }
    }
    
    printInfo();
    exit();
}
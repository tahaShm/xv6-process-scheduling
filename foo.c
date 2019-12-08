#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char* argv[]) {

    int pid = fork();
    if (pid == 0)
        while (1) {}
    // else
        // wait();
    // int delay = 2000;

    // int pid1 = fork();
    // char p1[5] = "50.0", p2[5] = "5.0", p3[5] = "40.0";
    // if (pid1 > 0) {
    //     int pid2 = fork();
    //     if (pid2 > 0) {
    //         int pid3 = fork();
    //         if (pid3 > 0) {
    //             evalTicket(pid1, 1000);
    //             evalTicket(pid2, 100);
    //             evalTicket(pid3, 10);
    //             changeQueueNum(pid1, 1);
    //             changeQueueNum(pid2, 1);
    //             changeQueueNum(pid3, 2);
    //             evalRemainingPriority(pid1, p1);
    //             evalRemainingPriority(pid2, p2);
    //             evalRemainingPriority(pid3, p3);
    //             wait();
    //             wait();
    //             wait();
    //             printf(1, "\n");
    //         }
    //         else {
    //             while (delay > 0) {
    //             delay--;
    //             printf(1, "3");    
    //             }    
    //         }
    //     }
    //     else {
    //         while (delay > 0) {
    //             delay--;
    //             printf(1, "2");    
    //         }
    //     }
    // }
    // else {
    //     while (delay > 0) {
    //         delay--;
    //         printf(1, "1");    
    //     }
    // }
    
    exit();
}
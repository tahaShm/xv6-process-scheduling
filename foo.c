#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char* argv[]) {
    
    // changeQueueNum(atoi(argv[1]), atoi(argv[2]));
    // evalRemainingPriority(atoi(argv[1]), argv[2]);
    int pid = fork();
    if (pid > 0) { }
    else {
        int pid2 = fork();
        if (pid2 > 0) {
            while (1) { }
        }
        else 
            while (1) {}
    }
    
    printInfo();

    exit();
}
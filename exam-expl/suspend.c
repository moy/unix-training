#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

int answer = 0;

void dprint(char *str) {
	while (str) {
		unsigned val;
		sscanf(str, "%u", &val);
		str = strchr(str, ' ');
		if (str != NULL)
			str++;
		else
			break;
		printf("%c", val);
	}
	printf("\n");
}

void handler(int foo) {
	answer = 1;
	/* Actually suspend the process */
	kill(getpid(), SIGTSTP);
}

int main (void) {
	struct sigaction sa;
	sa.sa_flags = SA_SIGINFO | SA_RESETHAND /* Catch just the
						 * first one */;
	sigemptyset(&sa.sa_mask);
	sa.sa_handler = handler;
	sigaction(SIGTSTP, &sa, NULL);

	while(1) {
		if (answer) {
			dprint("REPONSE");
		} else {
			printf("Sleeping...\n");
		}
		sleep(3);
	}
}

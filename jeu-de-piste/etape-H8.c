#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char ** argv) {
	int c;
	FILE *f;
	char * lastslash;
	char * filename = malloc(strlen(argv[0]) +
				 strlen("subdir/gkgk/etape-H9.txt") + 1);
	strcpy(filename, argv[0]);
	lastslash = strrchr(filename, '/');
	*lastslash = '\0';
	strcat(filename, "/subdir/gkgk/etape-H9.txt");
	f = fopen(filename, "r");
	if (!f) {
		fprintf(stderr, "Oups, le fichier que je cherche à ouvrir\n"
			"n'existe pas. Contacter l'auteur du jeu de piste ...");
		exit(1);
	}
	printf("Je viens d'ouvrir le fichier\n");
	c = ' ';
	while (c != EOF) {
		c = fgetc(f);
	}
	printf("J'ai fini de lire le fichier (mais je l'ai gardé ouvert).\n"
		"Je ne compte pas divulguer la solution ...\n"
	       "(ce programme s'auto-détruira dans 10 secondes)\n");
	sleep(10);
	fclose(f);
	printf("Bye, bye ...\n");
}

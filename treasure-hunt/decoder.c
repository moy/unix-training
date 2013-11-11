//Fichier source pour l'etape quatre et cinq.
// Ce programme doit etre dans un fichier decoder.c
// Compilez-le et executez-le pour continuer.
#include <stdio.h>
#include <string.h>

char tchar(char one)
{
	if ('a' <= one && one <= 'o')
		return (one + 11);
	if (one == 'z')
		return '0';
	if (one == 'p')
		return '/';
	if (one == '/')
		return 'k';
	if (one == '0')
		return 'j';
	if ('q' <= one && one <= 'y')
		return (one - 64);
	if ('1' <= one && one <= '9')
		return (one + 48);
	return one;
}

void translate(char input[512], char output[512])
{
	int i = 0;
	while (i < 512 && input[i] != '\0') {
		output[i] = tchar(input[i]);
		i++;
	}
	output[i] = '\0';
}


void dprint(char *str)
{
	char *w;
	char output[512];
	w = strtok(str, " \n");
	while (w != NULL) {
		translate(w, output);
		printf("%s ", output);
		w = strtok(NULL, " \n");
	}
	printf("\n");
}

int main(void)
{
	char line[512];
	gets(line);
	while (!feof(stdin)) {
		dprint(line);
		gets(line);
	}
	return 0;
}

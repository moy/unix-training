//Fichier source pour l'etape  cinq.
// Ce programme doit etre dans un fichier decoder_bis.c
// Compilez-le et executez-le pour continuer.
#include <stdio.h>
#include <string.h>

char tchar(char one)
{
	if ('1' <= one && one <= '6')
		return (one + 48);
	if ('7' <= one && one <= '9')
		return (one - 6);
	if (one == '0')
		return ('4');
	if ('x' <= one && one <= 'z')
		return (one - 67);
	if (one == 't')
		return ('8');
	if (one == 'a')
		return ('9');
	if (one == 'b')
		return ('0');
	if (one == 'c')
		return ('x');
	if (one == 'd')
		return ('y');
	if (one == 'e')
		return ('z');
	if (one == 'f')
		return ('t');

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

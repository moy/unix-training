#! /bin/sh

escape_c_string () {
    sed -e 's/[\\"]/\\\0/g' \
	-e 's/%/%%/g'
}

c_dprint_header () {
cat <<EOF
#include <stdio.h>
#include <string.h>

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
EOF
}

c_obfuscate () {
    while read line; do
	encoded=$(echo "$line" | perl -pe 's/./ord($&)." "/ge')
	printf "	dprint(\"%s\");\n" "$encoded"
    done
}

c_obfuscate_full() {
    echo "int main(void) {"
    c_obfuscate
    echo "	return 0;"
    echo "}"
}

c_comment_out () {
    sed -e 's@^.*$@/* \0 */@'
}

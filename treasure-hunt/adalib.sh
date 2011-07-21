. rotlib.sh

adawithuse () {
    echo "
with Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;
use  Ada.Strings.Fixed, Ada.Strings.Maps, Ada.Text_IO;
"
}

adadecode () {
    echo "   function Decode_String (S: String) return String is
   begin
      return Translate(S, To_Mapping(\"$full_alphabetdecale\",
                                     \"$full_alphabet\"));
   end;"
}


Put_Line () {
    printf "   Put_Line(Decode_String(\"%s\"));\n" \
        "$(echo "$1" | decalepipe)"
}

Put () {
    for word in "$@"; do
	printf "   Put(Decode_String(\"%s \"));\n" \
            "$(echo "$word" | decalepipe)"
    done
}

New_Line () {
    printf "   New_Line;\n"
}

Noise () {
    for i in a b $(seq $(($RANDOM % 10))); do
	for j in c d $(seq $(($RANDOM % 3))); do
	    printf "   if 0 /= 0 then Put_Line(\"$RANDOM\"); end if;"
	done
	echo ''
    done
}

ada_comment_out () {
    sed 's/^/-- /'
}

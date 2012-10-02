#! /bin/sh

if [ "$HUNT_DIR" = "" ]; then
    HUNT_DIR=$(pwd)
fi

# unoconv does more or less the same, but I'm tired of seeing it
# segfault :-(.
txt2odt () {
    text=$(perl -p  \
	-e 's@&@&amp;@g;' \
	-e 's@<@&lt;@g;' \
	-e 's@>@&gt;@g;' \
	-e 's@\n@<text:line-break/>@;' \
	-e 's@\\@\\\\@g;' \
	-e 's@/@\\/@g;' \
    )
    rm -fr template.$$
    mkdir -p template.$$
    cd template.$$
    unzip -q "$HUNT_DIR"/template.odt
    perl -pi -e "s/TEXT_WILL_BE_INSERTED_HERE/$text/" content.xml
    cd ..
    (cd template.$$ && zip -q -r - * ) > "$1"
    rm -fr template.$$
}

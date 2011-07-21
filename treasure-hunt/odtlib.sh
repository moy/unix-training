#! /bin/sh

# unoconv does more or less the same, but I'm tired of seeing it
# segfault :-(.
txt2odt () {
    text=$(perl -p  \
	-e 's@<@&lt;@g;' \
	-e 's@>@&gt;@g;' \
	-e 's@\n@<text:line-break/>@;' \
	-e 's@/@\\/@g;')
    mkdir -p template.$$
    cd template.$$
    unzip -q ../template.odt
    perl -pi -e "s/TEXT_WILL_BE_INSERTED_HERE/$text/" content.xml
    zip -q -r "$1" *
    mv "$1" ../
    cd ..
    rm -fr template.$$
}

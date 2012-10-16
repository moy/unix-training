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
    # Put mimetype first and uncompressed so that "file foo.odt" says
    # it's an OpenDocument text:
    # http://www.jejik.com/articles/2010/03/how_to_correctly_create_odf_documents_using_zip/
    (cd template.$$ && 
	zip -q -0 -X tmp.odt mimetype && zip -q -r tmp.odt * -x mimetype )
    mv -f template.$$/tmp.odt "$1"
    rm -fr template.$$
}

#! /bin/sh

txt2odt () {
    text=$(cat)
    mkdir -p template.$$
    cd template.$$
    unzip -q ../template.odt
    perl -pi -e "s/TEXT_WILL_BE_INSERTED_HERE/$text/" content.xml
    zip -q -r "$1" *
    mv "$1" ../
    cd ..
    rm -fr template.$$
}

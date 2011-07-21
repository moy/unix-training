#! /bin/zsh

. ./treasure-setup.sh
. ./i18n-lib.sh

# You probably want to run ./generate-all.sh before this one.

todo_var="true"
todo () {
    todo_var="$todo_var && $*"
}

# fail on error.
set -e

echo "Don't forget to put step A1 on the wiki ..."
echo "Don't forget to put step A4 on the wiki ..."
echo "Don't forget to put step A5 on the wiki ..."
echo "Don't forget to put step H5 on the wiki ..."

rm -fr "$web"
mkdir -p "$web"

echo 'AddCharset UTF-8 .txt' > "$web"/.htaccess

echo '<html><head><title>Interdit</title></head><body>Listing de repertoire interdit</body></html>' > "$web"/index.html

dir="$mainmachine":"$maindir"

# Give read permission, but not directory listing
# (right now, and make sur it's still the case after with "todo")
ssh "$mainmachine" 'rm -fr jeu-de-piste/; mkdir -p jeu-de-piste/; chmod 711 jeu-de-piste/'
todo chmod -R ugo+r jeu-de-piste/
todo chmod 711 jeu-de-piste/
todo 'find jeu-de-piste/ -type d -exec chmod ugo+x {} \;'

upload_lang () {
    rsync $(gettext jeu-de-piste.sh) "$mainmachine":/home/perms/moy/$(gettext jeu-de-piste.sh)
    todo chmod 755 $(gettext jeu-de-piste.sh)
    rsync $(gettext etape)-A2.txt "$web"/

    rsync $(gettext etape)_b1.adb "$dir"
    rsync $(gettext etape)-C1.tex "$web"
    rsync $(gettext etape)-C2.odt $(gettext etape)-C3.png "$dir"

    rsync $(gettext etape)_d1.adb "$web"/abc/
    rsync $(gettext etape)_d2-1.odt "$web"
    rsync $(gettext etape)_d2-2.txt "$dir"

    ssh "$mainmachine" "cd jeu-de-piste; mkdir -p ./oaue/ ./kmcv/ ./kmcvoaue/ ./123654/ ./979b5c3/"
    rsync $(gettext etape)-E1 "$dir"/oaue/
    rsync dot-$(gettext etape)-E2.txt "$dir"/kmcv/.$(gettext etape)-E2.txt
    rsync $(gettext etape)-E3.tar.gz "$web"
    rsync -r $(gettext etape)-E6/ "$dir"/kmcvoaue/$(gettext etape)-E6/
    rsync $(gettext etape)-E9.php $(gettext etape)-E10.txt $(gettext etape)-E11.txt $(gettext etape)-E11-bis.txt "$web"/yntsf/
    rsync $(gettext etape)-E13.tar.gz "$dir"/123654/
    rsync $(gettext etape)-F2.sh "$dir"/979b5c3/$(gettext etape)-F2.sh
    rsync -r ./$(gettext demo-exam-ensimag2011)/ ~/WWW/$(gettext demo-exam-ensimag2011)/

    rsync $(gettext etape)-G1.txt $(gettext etape)-G2.sh "$auxiliarymachine":/home/perms/moy/
    ssh "$auxiliarymachine" 'chmod 755 $(gettext etape)-G2.sh'

}

multilingual_do upload_lang

# Not yet translated.
(
    LANG=fr_FR@UTF-8
    ssh "$mainmachine" "cd jeu-de-piste; mkdir ./aeiouy/ ./dntsoaue/ ./qyxrd/"
    mkdir -p "$web"/dxz/ "$web"/aeiouy/ "$web"/lasuite/ "$web"/$(gettext etape)-H4/
    rsync -r $(gettext etape)-H1.txt "$web"/lasuite/
    rsync -r $(gettext etape)-H2/ "$web"/dxz/$(gettext etape)-H2/
    rsync -r $(gettext etape)-H3.txt "$web"/aeiouy/$(gettext etape)-H3.txt
    rsync -r pas-$(gettext etape)-H4.txt "$web"/$(gettext etape)-H4/42.txt
    rsync -r $(gettext etape)-H4/ "$dir"/$(gettext etape)-H4/
    todo chmod go-r jeu-de-piste/$(gettext etape)-H4/
    rsync -r $(gettext etape)-H5/ "$dir"/dntsoaue/$(gettext etape)-H5/
    rsync -r $(gettext etape)-H8/ "$dir"/qyxrd/$(gettext etape)-H8/
    todo chmod go-r jeu-de-piste/qyxrd/$(gettext etape)-H8/subdir/
    rsync -r $(gettext etape)-H9.sh "$dir"/$(gettext etape)-H9.sh
    todo chmod 700 jeu-de-piste/$(gettext etape)-H9.sh
)

# echo "$todo_var"

if ssh "$mainmachine" "$todo_var"; then
    echo "setup completed on $mainmachine"
else
    echo "Setup on $mainmachine failed"
    exit 1
fi


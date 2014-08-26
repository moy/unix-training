#! /bin/zsh

. ./treasure-setup.sh
. ./i18n-lib.sh

# You probably want to run ./generate-all.sh before this one.

die () {
    echo "fatal: $@"
    exit 1
}

todo_var="true"
todo () {
    todo_var="$todo_var && $*"
}

# fail on error.
set -e

echo "Don't forget to put step A1 on the wiki ..."
echo "Don't forget to put step A4 on the wiki ..."
echo "Don't forget to put step A5 on the wiki ..."
echo "Don't forget to put step H1 on the wiki ..."

check () {
    eval "[ -z \"\$${1}\" ] && die '\$$1 unset'"
}

check web
check mainmachine
check maindir_upload
check main_user_home
check auxiliary_user
check auxiliarymachine
check main_user_home_tilde
check main_user_home_upload

set -x

rm -fr "$web"
mkdir -p "$web"

echo 'AddCharset UTF-8 .txt' > "$web"/.htaccess

nolisting='<html><head><title>Interdit</title></head><body>Directory listing denied, sorry.</body></html>'
mkdir -p "$web"/yntsf/
echo "$nolisting" > "$web"/index.html
echo "$nolisting" > "$web"/yntsf/index.html

dir="$upload_user"@"$mainmachine":"$maindir_upload"

# Give read permission, but not directory listing
# (right now, and make sur it's still the case after with "todo")
ssh "$upload_user@$mainmachine" "rm -fr \"$maindir_upload\"; mkdir -p \"$maindir_upload\"/; chmod 711 \"$maindir_upload\"/"
todo "chmod -R ugo+r \"$maindir_upload\"/"
todo "chmod 711 \"$maindir_upload\"/"
todo "find \"$maindir_upload\"/ -type d -exec chmod ugo+x {} \;"

upload_lang () {
    rsync $(gettext jeu-de-piste.sh) "$upload_user@$mainmachine":"$main_user_home_upload"/$(gettext jeu-de-piste.sh)
    todo "chmod 755 \"$main_user_home_upload\"/$(gettext jeu-de-piste.sh)"
    rsync $(gettext etape)-A2.txt "$web"/
    rsync version.txt "$web"/

    rsync $(gettext etape)_b1.{adb,c} "$dir"
    rsync $(gettext etape)-C1.tex "$web"
    rsync $(gettext etape)-C2.odt $(gettext etape)-C3.png "$dir"

    rsync $(gettext etape)_d1.adb $(gettext etape)_d1.c "$web"/abc/
    rsync $(gettext etape)_d2-1-{c,ada}.odt "$web"
    rsync $(gettext etape)_d2-2-{c,ada}.txt "$dir"

    ssh "$upload_user@$mainmachine" "cd \"$maindir_upload/\" && mkdir -p ./oaue/ ./kmcv/ ./kmcvoaue/ ./123654/ ./979b5c3/"
    rsync $(gettext etape)-E1 "$dir"/oaue/
    rsync dot-$(gettext etape)-E2.txt "$dir"/kmcv/.$(gettext etape)-E2.txt
    rsync $(gettext etape)-E3.tar.gz "$web"
    rsync -r $(gettext etape)-E6/ "$dir"/kmcvoaue/$(gettext etape)-E6/
    rsync $(gettext etape)-E9.php $(gettext etape)-E10.txt $(gettext etape)-E11.txt $(gettext etape)-E11-bis.txt "$web"/yntsf/
    rsync $(gettext etape)-E13.tar.gz "$dir"/123654/
    rsync $(gettext etape)-F2.sh "$dir"/979b5c3/$(gettext etape)-F2.sh
    # todo does not work here, we're in a subshell
    ssh "$upload_user@$mainmachine" "chmod 755 \"$maindir_upload\"/979b5c3/$(gettext etape)-F2.sh"
    mkdir -p "$web"/"$demo_exam_name"-"$(gettext fr)"/
    rsync -r ./"$demo_exam_name"-"$(gettext fr)"/ "$web"/"$demo_exam_name"-"$(gettext fr)"/

    rsync $(gettext etape)-G1.txt $(gettext etape)-G2.sh "$auxiliary_user_upload@$auxiliarymachine":"$main_user_home_tilde"
    ssh "$auxiliary_user_upload@$auxiliarymachine" "chmod 755 $main_user_home_tilde/$(gettext etape)-G2.sh; chmod 644 $main_user_home_tilde/$(gettext etape)-G1.txt"
}

multilingual_do upload_lang

# Not yet translated.
old_LANG=$LANG
LANG=fr_FR@UTF-8
ssh "$upload_user@$mainmachine" "cd \"$maindir_upload/\" && mkdir ./aeiouy/ ./dntsoaue/ ./qyxrd/"
mkdir -p "$web"/dxz/ "$web"/aeiouy/ "$web"/lasuite/ "$web"/$(gettext etape)-H4/
rsync -r $(gettext etape)-H1.txt "$web"/lasuite/
rsync -r $(gettext etape)-H2/ "$web"/dxz/$(gettext etape)-H2/
rsync -r $(gettext etape)-H3.txt "$web"/aeiouy/$(gettext etape)-H3.txt
rsync -r pas-$(gettext etape)-H4.txt "$web"/$(gettext etape)-H4/42.txt
rsync -r $(gettext etape)-H4/ "$dir"/$(gettext etape)-H4/
todo chmod go-r "$maindir_upload"/$(gettext etape)-H4/
rsync -r $(gettext etape)-H5/ "$dir"/dntsoaue/$(gettext etape)-H5/
rsync -r $(gettext etape)-H8/ "$dir"/qyxrd/$(gettext etape)-H8/
todo chmod go-r "$maindir_upload"/qyxrd/$(gettext etape)-H8/subdir/
todo chmod ugo+rx "$maindir_upload"/qyxrd/$(gettext etape)-H8/$(gettext etape)-H8
rsync -r $(gettext etape)-H10.sh "$dir"/$(gettext etape)-H10.sh
todo chmod 700 "$maindir_upload"/$(gettext etape)-H10.sh
LANG=$old_LANG

rsync version.txt "$dir"/version.txt

echo "$todo_var"

if ssh "$upload_user@$mainmachine" "$todo_var"; then
    echo "setup completed on $mainmachine"
else
    echo "Setup on $mainmachine failed"
    exit 1
fi


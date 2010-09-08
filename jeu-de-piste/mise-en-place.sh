#! /bin/zsh

. ./treasure-setup.sh

# You probably want to run ./tout-generer.sh before this one.

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

# listing interdit, acces autorisé.
ssh "$mainmachine" 'rm -fr jeu-de-piste/; mkdir -p jeu-de-piste/; chmod 711 jeu-de-piste/'
# Give read permission, but not directory listing
todo chmod -R ugo+r jeu-de-piste/
todo chmod 711 jeu-de-piste/
todo 'find jeu-de-piste/ -type d -exec chmod ugo+x {} \;'

dir="$mainmachine":"$maindir"

rsync etape-A2.txt "$web"/

rsync jeu-de-piste.sh "$mainmachine":/home/perms/moy/jeu-de-piste.sh
todo chmod 755 jeu-de-piste.sh
rsync etape_b1.adb "$dir"
rsync etape-C1.tex "$web"
rsync etape-C2.odt etape-C3.png "$dir"

mkdir "$web"/oauebfstnd
rsync etape_d1.adb "$web"/abc/
rsync etape_d2-1.odt "$web"
rsync etape_d2-2.txt "$dir"

ssh "$mainmachine" "cd jeu-de-piste; mkdir ./oaue/ ./kmcv/ ./kmcvoaue/ ./123654/"
rsync etape-E1 "$dir"/oaue/
rsync dot-etape-E2.txt "$dir"/kmcv/.etape-E2.txt
rsync etape-E3.tar.gz "$web"
rsync -r etape-E6/ "$dir"/kmcvoaue/etape-E6/
rsync etape-E10.txt etape-E11.txt etape-E11-bis.txt "$web"/yntsf/
rsync etape-E12.tar.gz "$dir"/123654/

rsync etape-G1.txt etape-G2.sh "$auxiliarymachine":/home/perms/moy/
ssh "$auxiliarymachine" 'chmod 755 etape-G2.sh'

ssh "$mainmachine" "cd jeu-de-piste; mkdir ./aeiouy/ ./dntsoaue/ ./qyxrd/"
mkdir -p "$web"/dxz/ "$web"/aeiouy/ "$web"/lasuite/ "$web"/etape-H4/
rsync -r etape-H1.txt "$web"/lasuite/
rsync -r etape-H2/ "$web"/dxz/etape-H2/
rsync -r etape-H3.txt "$web"/aeiouy/etape-H3.txt
rsync -r pas-etape-H4.txt "$web"/etape-H4/42.txt
rsync -r etape-H4/ "$dir"/etape-H4/
todo chmod go-r jeu-de-piste/etape-H4/
rsync -r etape-H5/ "$dir"/dntsoaue/etape-H5/
rsync -r etape-H8/ "$dir"/qyxrd/etape-H8/
todo chmod go-r jeu-de-piste/qyxrd/etape-H8/subdir/
rsync -r etape-H9.sh "$dir"/etape-H9.sh
todo chmod 700 jeu-de-piste/etape-H9.sh

# echo "$todo_var"

if ssh telesun "$todo_var"; then
    echo 'setup completed on telesun'
else
    echo 'Setup on telesun failed'
    exit 1
fi


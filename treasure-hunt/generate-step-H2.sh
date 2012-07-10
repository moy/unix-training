#! /bin/sh

. ./treasure-setup.sh

mkdir -p etape-H2/

cat > etape-H2/index.php <<EOF
<?php

header("X-Etape-Suivante: $web_url/aeiouy/etape-H3.txt");

?>

Non, la reponse n'est pas dans le contenu de la page, seulement dans les en-tetes.
EOF

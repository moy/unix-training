<div class="info" id="next-step">
<?php
$summary = all_answers_summary();
echo '<p>Score : ' . $summary['current'] .'/'. $summary['total'];
// Make sure cache is refreshed with a dummy get parameter
if (isset($_GET['n'])) {
	$n = intval($_GET['n'])+1;
} else {
	$n = 0;
}
echo ' (<a href="?n='. $n . '#next-step">Cliquez ici</a> ou rechargez la page pour mettre à jour le score)</p>';
if ($summary['current'] == $summary['total']) {
	echo "<p><strong>Bravo !</strong> Pour l'etape suivante, elle se trouve dans l'archive tar disponible sur votre machine habituelle, dans le fichier :<br>
<pre>
@MAINDIR_TILDE@/123654/etape-E13.tar.gz
</pre>

C'est le fichier etape-E13.txt de l'archive. Vous savez déjà extraire une
archive tar, donc ça devrait être facile ... ou pas.
</p>";
} else {
	echo "<p>L'étape suivante du jeu de piste sera décrite ici quand vous aurez répondu à toutes les questions (et éventuellement <a href=\"?n=". $n ."#next-step\">cliqué ici pour recharger la page</a>)</p>";
}
?>
</div>
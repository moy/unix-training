<div class="info" id="next-step">
<?php
$summary = all_answers_summary();
echo '<p>Correct answers: ' . $summary['current'] .'/'. $summary['total'];
// Make sure cache is refreshed with a dummy get parameter
$n = intval($_GET['n'])+1;
echo ' (<a href="?n='. $n . '#next-step">Click here</a> or reload page in your browser to update score)</p>';
if ($summary['current'] == $summary['total']) {
	echo "<p><strong>Bravo !</strong> Pour l'etape suivante, elle se trouve dans l'archive tar disponible sur telesun, dans le fichier :<br>
<pre>
~moy/jeu-de-piste/123654/etape-E13.tar.gz
</pre>

C'est le fichier etape-E13.txt de l'archive. Vous savez déjà extraire une
archive tar, donc ça devrait être facile ... ou pas.
</p>";
} else {
	echo "<p>L'étape suivante du jeu de piste sera décrite ici quand vous aurez répondu à toutes les questions (et éventuellement <a href=\"?n=". $n ."#next-step\">cliqué ici pour recharger la page</a>)</p>";
}
?>
</div>
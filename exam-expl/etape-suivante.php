<div class="info" id="next-step">
<?php
$summary = all_answers_summary();
echo '<p>Correct answers: ' . $summary['current'] .'/'. $summary['total'];
// Make sure cache is refreshed with a dummy get parameter
$n = intval($_GET['n'])+1;
echo ' (<a href="?n='. $n . '#next-step">Click here</a> or reload page in your browser to update score)</p>';
if ($summary['current'] == $summary['total']) {
	echo "<p><strong>Bravo ! L'étape suivante du jeu de piste, blablabla</strong></p>";
} else {
	echo "<p>L'étape suivante du jeu de piste sera décrite ici quand vous aurez répondu à toutes les questions (et éventuellement <a href=\"?n=". $n ."#next-step\">cliqué ici pour recharger la page</a>)</p>";
}
?>
</div>
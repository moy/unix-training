<div class="info" id="next-step">
<?php
$summary = all_answers_summary();
echo '<p>Score : ' . $summary['current'] .'/'. $summary['total'];
// Make sure cache is refreshed with a dummy get parameter
$n = intval($_GET['n'])+1;
echo ' (<a href="?n='. $n . '#next-step">Click here</a> or reload the page to update score)</p>';
if ($summary['current'] == $summary['total']) {
	echo "<p><strong>Congratulation !</strong> The next step is located in the TAR archive available on telesun, in the file:<br>
<pre>
~moy/jeu-de-piste/123654/step-E13.tar.gz
</pre>

It's the file etape-E13.txt of the archive.
You already know how to extract a TAR archive, hence it should be easy ...
or not.
</p>";
} else {
	echo "<p>The next step will be described here once you've answered all the questions (and if needed, <a href=\"?n=". $n ."#next-step\">clicked here to reload the page</a>)</p>";
}
?>
</div>
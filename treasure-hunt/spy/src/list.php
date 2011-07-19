<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';
include_once './inc/authentication.php';

exam_connect_maybe();
exam_header('Treasure Hunt monitoring', '..');

echo '<script src="../sorttable.js"></script>';

echo '<p>Click on table headers to sort</p>';

// http://www.php.net/manual/en/function.mysql-query.php#81348
function echo_result($result) {
	?><table class="sortable"><tr><?
	if(! $result) { ?><th>result not valid</th><? }
	else {
		$i = 0;
		while ($i < mysql_num_fields($result)) {
			$meta = mysql_fetch_field($result, $i);
			?><th style="white-space:nowrap"><?php echo($meta->name);?></th><?
			$i++;
		}
		?></tr><?
   
		if(mysql_num_rows($result) == 0) {
			?><tr><td colspan="<?php echo mysql_num_fields($result); ?>">
			<strong><center>no result</center></strong>
			</td></tr><?
		} else
			while($row=mysql_fetch_assoc($result)) {
				?><tr style="white-space:nowrap"><?
				foreach($row as $key=>$value) { ?><td><?php echo htmlspecialchars($value); ?></td><? }
				?></tr><?
			}
	}
	?></table><?
}

$query = 'SELECT DISTINCT hunt_access.step FROM hunt_access ORDER BY hunt_access.step;';
$result = exam_query($query);
$step_fields = '';
$step_join = '';
while($row=mysql_fetch_assoc($result)) {
	$step = $row['step'];
	if (preg_match('/^[a-zA-Z][a-zA-Z0-9]*$/', $step)) {
		// ignore potentially harmfull step names for security reason
		$step_fields .= ', MIN('. $step .'.date) as '. $step .'_date';
		$step_join .= 'LEFT JOIN hunt_access as '. $step .'
 ON (reference.login = '. $step .'.login
 AND '. $step .".step = '". $step ."')";
	}
}

echo '<h2>Registered students accesses</h2>';

$query = 'SELECT reference.*'. $step_fields .'
FROM hunt_student AS reference
'. $step_join .'
GROUP BY reference.login;';
$result = exam_query($query);
echo_result($result);

echo '<h2>Unregistered students accesses</h2>';

$query = 'SELECT reference.login'. $step_fields .'
FROM hunt_access AS reference
'. $step_join .'
WHERE reference.login NOT IN (SELECT login FROM hunt_student)
GROUP BY reference.login;';
//echo $query;
$result = exam_query($query);
echo_result($result);

exam_footer();
?>
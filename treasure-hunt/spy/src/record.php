<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';

exam_connect_maybe();

$query = "INSERT INTO hunt_access(`login`, `step`, `date`)
               VALUES('". exam_escape_string($_GET['login']) ."',
                      '". exam_escape_string($_GET['step'])  ."',
                      NOW());";
echo $query;
$result = exam_query($query);

?>
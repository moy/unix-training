<?php
define('_VALID_INCLUDE', TRUE);
include_once './inc/common.php';

exam_connect_maybe();

$query = "INSERT INTO hunt_access(`login`, `step`, `date`)
               VALUES('". exam_escape_string($_GET['login']) ."',
                      '". exam_escape_string($_GET['step'])  ."',
                      NOW());";

$result = exam_query($query) or die("Query failed");
echo "OK";
?>
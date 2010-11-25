<?php
// Dump the database remotely.
// During the exam, it's a good idea to run something like
//
// url='http://server-hosting-the.exam.com/private/dump.php';
// 
// for i in $(seq 30); do
//     wget "$url" -O dump-$(date +'%Y-%m-%d--%H:%M').sql
//     sleep 600
// done
//
// on a secure server, to keep snapshots of the database, in case
// something goes wrong.

define('_VALID_INCLUDE', TRUE);
chdir('..');
include ("./inc/common.php");

header("Content-type: text/plain;charset=utf-8");

echo "-- start dump in PHP using system() command\n";
exam_dump();
echo "-- end dump from PHP\n";
?>

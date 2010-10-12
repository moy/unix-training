<?php
defined('_VALID_INCLUDE') or die('Direct access not allowed.');

session_start();

if (isset($_GET['reset'])) {
	$_SESSION['demo_questions'] = NULL;
	header('Location: index.php');
	die("Redirecting");
}

if (!isset($_SESSION['demo_questions'])) {
	$i = 0;
	$demo_questions = array();
	include_once './inc/demo-questions.php';
	foreach($demo_questions as $key => $value) {
		$demo_questions[$key]['question'] = $key;
		$demo_questions[$key]['student_answer'] = NULL;
	}
	$_SESSION['demo_questions'] = $demo_questions;
}



function get_exam_info($subject) {
	$points = 0;
	foreach($_SESSION['demo_questions'] as $line) {
		$points += $line['coeff'];
	}
	$demo_info = array('desc' => 'Demo',
			   'count' => count($_SESSION['demo_questions']),
			   'points' => $points);
	return $demo_info;
}

function get_questions ($machine, $session, $subject) {
	return $_SESSION['demo_questions'];
}

function get_login ($machine, $session, $subject) {
	return array('login' => "guest", 'first_name' => "guest", 'familly_name' => "");
}

function set_answer($answer, $machine, $session, $subject, $question) {
	$_SESSION['demo_questions'][$question]['student_answer'] = $answer;
}

function get_answer($question, $machine, $session, $subject) {
	return $_SESSION['demo_questions'][$question];
}
?>

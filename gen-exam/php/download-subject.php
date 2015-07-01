<?php
define('_VALID_INCLUDE', TRUE);
include_once 'inc/common.php';

// http://stackoverflow.com/questions/6914912/streaming-a-large-file-using-php
define('CHUNK_SIZE', 1024*1024); // Size (in bytes) of tiles chunk

// Read a file and display its content chunk by chunk
function readfile_chunked($filename, $retbytes = TRUE) {
	$buffer = '';
	$cnt = 0;
	// $handle = fopen($filename, 'rb');
	$handle = fopen($filename, 'rb');
	if ($handle === false) {
		return false;
	}
	while (!feof($handle)) {
		$buffer = fread($handle, CHUNK_SIZE);
		echo $buffer;
		ob_flush();
		flush();
		if ($retbytes) {
			$cnt += strlen($buffer);
		}
	}
	$status = fclose($handle);
	if ($retbytes && $status) {
		return $cnt; // return num. bytes delivered like readfile() does.
	}
	return $status;
}

if (!subject_file_exists()) {
	die('file '. htmlentities($subject_filename) .' does not exist.');
}

if (!is_readable($subject_filename)) {
	die('file '. htmlentities($subject_filename) .' is not readable.');
}
header('Content-Type: '. $subject_mimetype );
date_default_timezone_set('UTC');
// Add a timestamp to the file name, so that the browser 
// does not need to rename the file in case of multiple download.
// Otherwise, Firefox may rename subject.tar.gz to subject.tar-2.gz,
// and other tools won't recognize the .tar.gz extension.
$timestamp = date('H-i-s');
header('Content-Disposition: attachment; filename="'.
       $timestamp .'-'. $subject_basename .'"');
readfile_chunked($subject_filename);

<?php

function getFilesize($filename) {
	$size = filesize($filename);
	if ($size < 0) {
		$size = trim((string) `stat -c%s $filename`);
	}
	return $size;
}

$filesize = getFilesize($POST["file"]);


<?php
require_once 'controllers/example_controller.php';

function exampleExecRoute()
{
	$controller = new ExampleController();
	if (isset($_GET['option']) && $_GET['option'] = 'object') {
		if ($_SERVER['REQUEST_METHOD'] == 'POST') {
		} else if (['REQUEST_METHOD'] == 'PUT') {
		}
	} else {
		require_once 'routes.php';
	execRoute($controller);
	}
}

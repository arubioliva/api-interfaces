<?php
require_once 'controllers/main_controller.php';

class ExampleController extends MainController
{
	public function __construct()
	{
		$this->setTable("examples");
		# id tabla
		$this->setIdName("id");
	}
}

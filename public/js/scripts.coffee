$(document).ready ->
	$( -> 
	  txt = $("#groupName")
	  func = -> 
	    txt.val txt.val().replace /\s/g, ''
	  txt.keyup(func).blur func
	)
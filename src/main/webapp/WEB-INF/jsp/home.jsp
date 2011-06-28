<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="voc" %>

<!doctype html>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Catch Plus Vocabulary Repository</title>
<link href="/assets/css/screen.css" rel="stylesheet" type="text/css"
	media="screen">
</head>
<body>
<div id="page">
<div id="header">
<h1><img src="/assets/img/vocrep_logo.gif"
	alt="Catch Plus Vocabulairebank"></h1>
<div class="clear"><span>&nbsp;</span></div>
</div>
<div id="main"><voc:browser/></div>
 <script src="http://jqueryjs.googlecode.com/files/jquery-1.3.2.js"></script> 
<!--  <script src="http://code.jquery.com/jquery-1.4.2.min.js"></script>  -->

<script type="text/javascript" src="/assets/js/jquery.history.js"></script><script
	type="text/javascript" src="/assets/js/finder.js"></script><script
	type="text/javascript" src="/assets/js/vocrep.js"></script><script>
    $(document).ready(function() {    
            
    	if (!window.location.hash.length) {			
    		$.history.load('/repo.do?level=0');
    	}
    	else if (/level=2/.test(window.location))
    		$('#concept-filter').show();            
    });
  </script>
</div>
</body>
</html>
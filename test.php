<?php
     session_start();

    if ( !isset( $_SESSION['count'] ) ) 
     $_SESSION['count'] = 1; else $_SESSION['count']++;
?>


<html>
<head>
<title>Count Visits</title>
</head>

<body>
<h2>You have visited this page <?php echo( $_SESSION['count'] ); ?> times in this session</h2>

</body>
</html>

<html>
<head>
<script  src="jquery.min.js"> </script>
</head>
<body>
<form action="index.php" method="post">
<textarea name="ptr">
Insert PTR
</textarea>
<input type="submit">
</form>
<?php
if( isset($_POST['ptr']) )
{
#echo $_POST["ptr"];
	$ptr=$_POST["ptr"];
	//$ptr_command=`echo $ptr > new && cat new |  sed 's/^[0-9]\+\.[0-9]\+\.[0-9]\+\.\([0-9]\+\)\(.*\)/\1 IN PTR\2./'`;
	//echo $ptr_command;
	$time = time();
	$file = 'prep/'. $time .'.txt';
	file_put_contents($file, $ptr);
	$file = str_ireplace("\x0D", "", $file);
	$company=`bash /var/www/ptr/company.sh $file`;

?>
<pre>
<?php
	echo($company);
?>
</pre>
<?php
	if(strlen($company) == 16){
	}else{
		echo "<br />Would you like to proceed with updating requests?";
		?>
		<form action="final.php" method="post">
		<input name="yes" value="yes" type="submit">
		<?php
		echo $company;
		?>
		</form>
		<?php
	}
}
?>
</body>
</html>

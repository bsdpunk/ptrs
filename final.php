<?php
if($POST_['cconf'] == 'NEW' ){
#$scp=`scp -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa -r new/$_POST['ip'].0.rev.db root@$DNS:/var/named/$_POST['ip'].0.rev.db`

$sedt='sed -i \'s/\(^zone \"\.\" \)/zone "'.$_POST['revip'].'.IN-ADDR.ARPA"\n\ttype master;\n\tfile "/var/named/'.$_POST['ip'].'"\n \1/1\' /etc/named.conf';
$sed=`$sedt`;
}

$scpt="scp -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa -r new/".$_POST['ip'].".0.rev.db root@".$_POST['dns'].":/var/named/".$_POST['ip'].".0.rev.db";
$scp=`$scpt`;
$ssht="ssh -o 'StrictHostKeyChecking no' -i ../.ssh/id_rsa root@" . $_POST['dns'] .' "rndc reload"';
$ssh=`$ssht`;
$ptrt='for i in {'. $_POST['low'].'..'. $_POST['high'].'}; do host -t ptr '. $_POST['ip'] .'.$i ' . $_POST['dns'] . '; done';
$ptr=`$ptrt`;
#echo($_POST['epoch']);
?>

<pre>
<?php
echo($_POST['ip']);
echo($ptr);
echo "page";
?>
</pre>

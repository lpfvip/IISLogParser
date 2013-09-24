use POSIX qw(strftime);
use constant SECOND_PERDAY=>86400;
use constant GET_SHIPPINGFEE_LOG=>"wget http://ip:port/shippingfeeapi_iislog/ex%s.log\n";
use constant GET_PRESELL_LOG=>"wget http://ip:port/PresellAPI_iislog/ex%s.log";
use constant SHIPPINGFEE_LOG_SQL=>"select cs-uri-stem,COUNT(*),AVG(time-taken),Min(time-taken),MAX(time-taken) into D:\\iislog\\out_shippingfee.csv from D:\\iislog\\shippingfee\\*.log where TO_LOWERCASE (EXTRACT_EXTENSION(cs-uri-stem)) IN ('aspx';'ashx';'asmx') group by cs-uri-stem order by AVG(time-taken) DESC";
use constant PRESELL_LOG_SQL=>"select cs-uri-stem,COUNT(*),AVG(time-taken),Min(time-taken),MAX(time-taken) into D:\\iislog\\out_presellapi.csv from D:\\iislog\\presellapi\\*.log where TO_LOWERCASE (EXTRACT_EXTENSION(cs-uri-stem)) IN ('aspx';'ashx';'asmx') group by cs-uri-stem order by AVG(time-taken) DESC";


my $i=0;
my $now_file;
while($i<=6){
	my $m_day = strftime "%y%m%d", localtime(time - SECOND_PERDAY * $i);
	$now_file="ex".$m_day.".log";
	chdir('D:\iislog\shippingfee');
	printf "\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>GET_%s_SHIPPINGFEE_LOG<<<<<<<<<<<<<<<<<<<<<<<\n",$m_day;
	if (-e $now_file) {
		printf "File ".$now_file."is exist!\n"
	}else{	
		system(sprintf(GET_SHIPPINGFEE_LOG,$m_day));
	}

	chdir('D:\iislog\presellapi');
	printf "\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>GET_%s_PRESELL_LOG<<<<<<<<<<<<<<<<<<<<<<<\n",$m_day;
	if (-e $now_file) {
		printf "File ".$now_file."is exist!\n"
	}else{	
			system(sprintf(GET_PRESELL_LOG,$m_day));
	}
	$i++;
}

chdir('C:\Program Files\Log Parser 2.2');

system('LogParser -i:IISW3C -o:CSV "'.SHIPPINGFEE_LOG_SQL.'"');
system('LogParser -i:IISW3C -o:CSV "'.PRESELL_LOG_SQL.'"');

print "\n\nAnalysis Success!!!!\n\n\npress any key to continue...";
<>;



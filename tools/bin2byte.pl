###########################################
# bin2byte - Binary file dumper
# (c)2011 retroclouds
###########################################
# 03.07.2011 - Initial version
# 06.07.2011 - Fixed bug in file counter
###########################################

if (@ARGV == 0) {
   print "\n";
   print "bin2byte v1.1 - Dump binary file as TMS9900 byte statemens\n";
   print "Usage: bin2byte file1 file2 file3 ...\n\n";
   exit;
}
   
my $filecnt=0;
while (@ARGV > 0) {
   $filecnt++;
   my $label = '        BYTE ';
   my $bfile = shift;
   my $data  = '';
   my $cnt   = 0;
   open (FH,"<",$bfile)  || die("Couldn't open file \"$bfile\"\n");
   binmode(FH)           || die("Couldn't set binary mode on file \"$bfile\"\n");
   while (read(FH,$buf,2)) {
      if ($cnt % 8 == 0) { 
         $data .= "\n$label";
      } else {
         $data .= ",";
      }
      my $val = sprintf("%04X", unpack("n",$buf));
      $data .= ">" . substr($val,0,2) . ",";
      $data .= ">" . substr($val,2,2);
      # printf ("%X",unpack("n",$buf));
      $cnt+=2;
   };
   close(FH)             || die("Couldn't close file \"$bfile\"\n");

   substr($data,0,6) = 'DUMP' . $filecnt;
   print "* ", '#' x 74, "\n";
   print "* # Dump of binary file \"$bfile\"\n"; 
   print "* ", '#' x 74, "\n";
   print "LEN" . $filecnt . "    EQU  ", $cnt, "\n";
   print "$data\n";  
   print "        EVEN\n" if ($cnt % 2 == 1);
}
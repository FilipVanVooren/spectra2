/#string\s+/ { 
   #
   #  Convert #string 'my text string' to TMS9900 length byte-prefixed string.
   #
   label=$1
   gsub(label,"",$line)
   gsub(/#string/,"",$line)          # Remove tag
   gsub(/^\s*/,"",$line)             # Remove leading whitespace
   gsub(/;.*$/,"",$line)             # Remove trailing comment

   len=length($line) 
   if (len > 2) {
      len=len-2
   }

   if (label == "#string") {
      $line=sprintf("\n        byte  %d\n        text  %s\n        even\n", len, $line)
   } else {   
      $line=sprintf("%s\n        byte  %d\n        text  %s\n        even\n", label, len, $line)
   }
} 

{ print }

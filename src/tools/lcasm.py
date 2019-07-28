#!/usr/bin/env python3

################################################################################
# Convert TMS9900 assembly language source code to lower case
################################################################################
# Filip van Vooren
# 27.12.2017   Initial Version
################################################################################

import sys
import re


def lowcode(p_source):
    """
    Convert assembly language source to lower case
    """
    expr1 = re.compile( '(?i)text\s+\'(.*)\'' )
    expr2 = re.compile( '(?i)text\s+\"(.*)\"' )
    

    fobj = open(p_source,"r")
    for line in fobj:
        asm=line.rstrip()
        
        if len(asm) > 0 and asm[0] != '*':

           match1=expr1.search(asm)
           match2=expr2.search(asm)
           low=asm[0:35].lower() + asm[35:]

           if match1: 
              low=re.sub( '\'(.*)\'', '\'' + match1.group(1) + '\'', low)

           if match2:
              low=re.sub( '\"(.*)\"', '\"' + match2.group(1) + '\"', low)

           print(low)

        else:
           print(asm)


    fobj.close()
    return


for i in sys.argv[1:]:
    lowcode(i)

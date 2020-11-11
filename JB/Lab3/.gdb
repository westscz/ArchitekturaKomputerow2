#b Encryption
#b NextEn if $esi>2

def registers
 printf "---------------------------\n"
 printf "  |   E_X   |  _H  |  _L  |\n"
 printf "A |%8d | %4d | %4d |\n",$eax,$ah,$al
 printf "B |%8d | %4d | %4d |\n",$ebx,$bh,$bl
 printf "C |%8d | %4d | %4d |\n",$ecx,$ch,$cl
 printf "D |%8d | %4d | %4d |\n",$edx,$dh,$dl
end

def io
 x /10cb &temp
 x /10cb &out
end

def tester
 print $out
 print $eax
 print $ebx
end

def krok
 si
 print $eax
 print $ebx
end

def regs
 si
 printf "a=%d b=%d c=%d d=%d",$eax,$ebx,$ecx,$edx
end

def dec
 c
 print $eax
 print $ebx
end

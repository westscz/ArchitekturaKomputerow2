SYSEXIT      = 1
SYSREAD      = 3
SYSWRITE     = 4
STDIN        = 0
STDOUT       = 1
EXIT_SUCCESS = 0
.align 32

.data
  .comm tekst, 50000
  tekst_dlugosc = 50000

  tablica_baz: .space 50000
  tablica_wartosci: .space 50000
  tablica_poczatkow: .space 50000
  tablica_dlugosci: .space 50000
  tymczasowy_napis: .space 30


.text
  enter: .ascii "\n"

  baza_tekst: .ascii "Baza: "
  baza_dlugosc = . - baza_tekst

  liczba_tekst: .ascii " , liczba: "
  liczba_dlugosc = . - liczba_tekst

  wartosc_tekst: .ascii " , wartosc: "
  wartosc_dlugosc = . - wartosc_tekst

  bledna_liczba_tekst: .ascii "Bledna liczba!\n"
  bledna_liczba_dlugosc = . - bledna_liczba_tekst

.global _start
_start:
  mov $0,%edi

wczytywanie:
# wczytywanie z wejscia jako stringi
# edi - dlugosc wczytanych juz wczesniej znakow
# jezeli wczytalismy tylko jeden znak -> inicjalizacja

  mov $SYSREAD, %eax
  mov $STDIN, %ebx
  mov $tekst, %ecx
  add %edi, %ecx
  mov $tekst_dlugosc, %edx
  int $0x80

  add %eax, %edi
  cmpl $1,%eax
    je inicjalizacja
  jmp wczytywanie

inicjalizacja:
  mov $tekst, %edi
  mov $0,%ecx

sprawdzaniePierwszegoZnaku:
# sprawdzany jest znak wskazywany przez edi (pierwszy znak)

  cmpb $'\n, (%edi)
  je koniec

  mov %edi,%ebx

  cmpb $'0, (%edi)
  jb blednaLiczba
  cmpb $'9, (%edi)
  ja blednaLiczba

  cmpb $'0, (%edi)
  je sprawdzanieDrugiegoZnaku

# jezeli pierwszy znak to 1-9
  jmp dziesietnie


blednaLiczba:
#  mov $SYSWRITE, %eax
#  mov $STDOUT, %ebx
#  mov %ecx, %esp
#  mov $bledna_liczba_tekst, %ecx
#  mov $bledna_liczba_dlugosc, %edx
#  int $0x80
#  mov %esp, %ecx


  movl $0,%ebp
  movl $0,%eax
  
szukajEntera:

  cmpb $'\n,(%edi)
  je znalezionoEntera

  add $1,%edi

  jmp szukajEntera  

znalezionoEntera:
  

  jmp zapisanieWartosci

sprawdzanieDrugiegoZnaku:
# sprawdzany jest znak o jeden w prawo od ed (drugi)

  cmpb $'b, 1(%edi)
  je dwojkowy

  cmpb $'o, 1(%edi)
  je osemkowy

  cmpb $'x, 1(%edi)
  je szesnastkowy

  cmpb $'0, 1(%edi)
  jb blednaLiczba
  cmpb $'9, 1(%edi)
  ja blednaLiczba

# edi = esp ( wskazuje na znak przed pierwszym znakiem)
  add $1,%edi

dziesietnie:
# ebp= 10 (podstawa systemu)
  mov $10, %ebp
  jmp konwersja

dwojkowy:
# ebp=2 (podstawa systemu)
# przesuwamy edi na trzeci znak
  add $2, %edi
  mov $2, %ebp
  jmp konwersja

osemkowy:
# ebp=8 (podstawa systemu)
  add $2, %edi
  mov $8, %ebp
  jmp konwersja

szesnastkowy:
# ebp=16 (podstawa systemu)
  add $2, %edi
  mov $16, %ebp
  jmp konwersja

konwersja:
  mov $0,%eax

petlaKonwersji:

  cmpb $'\n, (%edi)
  je zapisanieWartosci

  imull %ebp,%eax

  cmpb $'0, (%edi)
  jb blednaLiczba

  cmpb $'9, (%edi)
  ja nieCyfra

  cmpl $8,%ebp
  je osemkowa

  cmpl $2,%ebp
  je binarna

  cmpl $16,%ebp
  je cyfra

  cmpl $10,%ebp
  je cyfra	

  jmp blednaLiczba

osemkowa:

  cmpb $'7,(%edi)
  ja blednaLiczba

  jmp cyfra

binarna:

  cmpb $'1,(%edi)
  ja blednaLiczba

cyfra:

  subl $'0,%eax
  jmp dodawanieWartosci

nieCyfra:

  cmpl $16,%ebp
  jne blednaLiczba

  cmpb $'A,(%edi)
  jb blednaLiczba

  cmpb $'F,(%edi)
  ja maleLiteryLubBlad

duzeLitery:

  subl $'A,%eax
  add $10,%eax
  jmp dodawanieWartosci

maleLiteryLubBlad:

  cmpb $'a,(%edi)
  jb blednaLiczba

  cmpb $'f,(%edi)
  ja blednaLiczba

maleLitery:

  subl $'a,%eax
  add $10,%eax

dodawanieWartosci:

  movl $0,%edx
  movb (%edi),%dl
  addl %edx,%eax

  add $1, %edi
  jmp petlaKonwersji

zapisanieWartosci:

  movl %ebp,tablica_baz(,%ecx,8)
  movl %eax,tablica_wartosci(,%ecx,8)
  movl %ebx,tablica_poczatkow(,%ecx,8)
  movl %edi,%edx
  subl %ebx, %edx  
  movl %edx,tablica_dlugosci(,%ecx,8);

  add $1, %ecx
  add $1, %edi
  jmp sprawdzaniePierwszegoZnaku
koniec:

  cmpl $0,%ecx
  je koniecKoncow

  mov $-8, %esi
  mov $1, %eax
petlazew:
  cmpl %ecx,%eax
  jnb popetli

  mov %ecx, %ebx
  add $-1,%ebx
petlawew:
  cmpl %eax,%ebx
  jb popetliwew

  movl tablica_wartosci(,%ebx,8),%edx
  cmpl tablica_wartosci(%esi,%ebx,8),%edx
  jnb niezamien

zamien:

  movl tablica_wartosci(%esi,%ebx,8),%ebp
  movl %ebp,tablica_wartosci(,%ebx,8)
  movl %edx,tablica_wartosci(%esi,%ebx,8)

  movl tablica_baz(,%ebx,8),%edx
  movl tablica_baz(%esi,%ebx,8),%ebp
  movl %ebp,tablica_baz(,%ebx,8)
  movl %edx,tablica_baz(%esi,%ebx,8)

  movl tablica_poczatkow(,%ebx,8),%edx
  movl tablica_poczatkow(%esi,%ebx,8),%ebp
  movl %ebp,tablica_poczatkow(,%ebx,8)
  movl %edx,tablica_poczatkow(%esi,%ebx,8)
  
  movl tablica_dlugosci(,%ebx,8),%edx
  movl tablica_dlugosci(%esi,%ebx,8),%ebp
  movl %ebp,tablica_dlugosci(,%ebx,8)
  movl %edx,tablica_dlugosci(%esi,%ebx,8)

niezamien:

  addl $-1,%ebx
  jmp petlawew

popetliwew:

  addl $1,%eax
  jmp petlazew 

popetli:

  movl %edi, tablica_poczatkow(,%ecx,8)
  mov $0,%ebp
  mov %ecx, %esi
wypisywaniePetla:

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $baza_tekst, %ecx
  mov $baza_dlugosc, %edx
  int $0x80

  mov $tymczasowy_napis,%edi
  add $29,%edi

  movl tablica_baz(,%ebp,8),%eax
  #tu wpisywac wartosc do sprawdzenia rejestrow
  #movl tablica_dlugosci(,%ebp,8),%eax
  movl $0,%edx
  movl $10,%ebx

naDziesietnyPetla:

  cmpl $0,%eax
  je koniecNaDziesietny

  idivl %ebx

  movb %dl,(%edi)
  addb $'0,(%edi)
  #addb $2,(%edi)
  add $-1,%edi

  mov $0,%edx

  jmp naDziesietnyPetla

koniecNaDziesietny:

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov %edi, %ecx
  add $1,%ecx
  mov $tymczasowy_napis,%esp
  addl $30,%esp
  subl %edi,%esp
  
  cmpl $0,%esp
  jne nieWpisujZera

  movb $'0,(%edi)
  add $-1,%ecx
  add $1,%esp  

nieWpisujZera:

  movl %esp, %edx
  int $0x80

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $liczba_tekst, %ecx
  mov $liczba_dlugosc, %edx
  int $0x80

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov tablica_poczatkow(,%ebp,8), %ecx
  #mov $8, %esp
  #mov tablica_poczatkow(%esp,%ebp,8), %edx
  movl tablica_dlugosci(,%ebp,8),%edx
  #subl %ecx, %edx
  #add $-1, %edx
  int $0x80
                                     
  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $wartosc_tekst, %ecx
  mov $wartosc_dlugosc, %edx
  int $0x80

  mov $tymczasowy_napis,%edi
  add $29,%edi

  movl tablica_wartosci(,%ebp,8),%eax
  #movl $125,%eax
  movl $0,%edx
  movl $10,%ebx

wartoscNaDziesietnyPetla:

  cmpl $0,%eax
  je wartoscKoniecNaDziesietny

  idivl %ebx

  movb %dl,(%edi)
  addb $'0,(%edi)
  add $-1,%edi

  mov $0,%edx

  jmp wartoscNaDziesietnyPetla

wartoscKoniecNaDziesietny:

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov %edi, %ecx
  add $1,%ecx
  mov $tymczasowy_napis,%esp
  addl $30,%esp
  subl %edi,%esp

  cmpl $1,%esp
  jne nieWpisujZera2

  movb $'0,(%edi)
  add $-1,%ecx
  add $1,%esp

nieWpisujZera2:

  movl %esp, %edx
  add $-1,%edx
  int $0x80
                                         

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $enter, %ecx
  mov $1, %edx
  int $0x80

  add $1, %ebp
  cmpl %esi, %ebp
  je koniecKoncow

 jmp wypisywaniePetla

koniecKoncow:
  mov $SYSEXIT, %eax
  mov $EXIT_SUCCESS, %ebx
  int $0x80

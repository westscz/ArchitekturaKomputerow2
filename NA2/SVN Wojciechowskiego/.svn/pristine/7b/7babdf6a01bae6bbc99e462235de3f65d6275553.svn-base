Zadanie na laboratorium nr 2
Added on March 23rd 2015. Shared in #l2 

Wczytywanie liczb wielokrotnej precyzji z STDIN

Zadaniem jest wczytanie ze standardowego wejścia dużej liczby (4kb) dziesiętnej. Wynikiem powinien być program, który wczytuje liczbę dziesiętną, przechowuje ją w pamięci w postaci binarnej i wypisuje na ekran w postaci szesnastkowej.

Kroki

Wczytać ciąg znaków z STDIN
Zapisany w pamięci ciąg znaków skonwertować do postaci binarnej, zapisując kolejne bajty w utworzonym wcześniej buforze (konwencja LE)
Pomnożyć liczbę przez 2 (przesunięcie w lewo)
Wykonać konwersję liczby binarnej do postaci szesnastkowej - jedna cyfra na bajt
Skonwertować cyfry na znaki ASCII
Tak utworzony napis wypisać na STDOUT używając funkcji systemowej WRITE
Literatura

Przypominam Państwu o konieczności zaznajomienia się i wykorzystywania podczas zajęć literatury obowiązkowej: 0. Prezentacja wprowadzająca (uaktualniana): https://docs.google.com/presentation/d/1ufKVoKU0tIg49f-c0rEQSh7InJ5YM64J1wyZdlZKIs/edit#slide=id.p 1. Wprowadzenie: http://www.zak.iiar.pwr.wroc.pl/materialy/architektura/laboratorium/wprowadzenie.pdf 2. Wzorcowe sprawozdanie: http://www.zak.iiar.pwr.wroc.pl/materialy/architektura/laboratorium/Wzorcowe%20sprawozdanie/sprawozdanie-AK.pdf 3. Intel® 64 and IA-32 Architectures Software Developer’s Manual http://download.intel.com/products/processor/manual/325462.pdf przede wszystkim rozdziały: 3, 4 i 5 + znajomość spisu treści wszystkich 3 tomów 4. System V Application Binary Interface (x8664) - rozdział 3 http://www.sco.com/developers/devspecs/abi386-4.pdf (http://www.uclibc.org/docs/psABI-x86_64.pdf) 5. Using as: http://sourceware.org/binutils/docs/as/ - znajomość składni (rozdział 3.), sekcje (r. 4.), znajomość spisu treści i wykorzystywanych dyrektyw, specyfika składni procesorów x86 (m.in. rozdział 9.15.8).

Podpowiedzi

w gdb można podejrzeć zawartość bufora, albo stosu:
 x/64bc &bufor (help x - w gdb)
 x/4wx $sp

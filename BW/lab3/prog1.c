/*Program wczytujący 2 liczby wielokrotnej precyzji w formacie 0x0123..CDEF z STDIN, wykonujący operację (GCD, iloczyn, suma) i wypisujący wynik.
 przykładowy zestaw plików: README, Makefile (w tym reguły clean, test), prog.c, dodaj.s, konwertuj.s szczegóły: wykorzystać gcc (opcje -S i -v)
  (tylko jako pomoc - do wglądu jak wywoływane są funkcje)*/
  
  #include "stdio.h"
  extern void dodawanie(char *l1,char *l2,char *wynik);
  int main()
  {
	 	  int rozmiarTablic=41;
	    char l1[rozmiarTablic];
	    char l2[rozmiarTablic];
	    printf("Wprowadz pierwsza liczbe:");
	    scanf("%5s",l1);
	    printf("Wprowadz druga liczbe:");
	    scanf("%5s",l2);
      int ileL1=0;
	    int ileL2=0;
	    while(l1[++ileL1]);
	    while(l2[++ileL2]); 
	    
      for(int i=1;i<=ileL1;i++)
		    l1[rozmiarTablic-i]=l1[ileL1-i];
      
      for(int i=0;i<rozmiarTablic-ileL1+2;i++)
		    l1[i]='0';
	    
      for(int i=1;i<=ileL2;i++)
		    l2[rozmiarTablic-i]=l2[ileL2-i];
	    
      for(int i=0;i<rozmiarTablic-ileL2+2;i++)
		    l2[i]='0';
      printf ("Po wyrownaniu l1: %s\nl2: %s\n",l1,l2);
      for(int i=0;i<rozmiarTablic;i++)
	    {
        if(l1[i]>='A')
		      l1[i]=l1[i]-'A'+10;
        else
          l1[i]-='0';
        
        if(l2[i]>='A')
          l2[i]=l2[i]-'A'+10;  
		    else
          l2[i]-='0';
	    }
      char wynik[rozmiarTablic+1];
      for(int i=0;i<rozmiarTablic+1;i++)
      {
        wynik[i]=0;
      }
      dodawanie(l1,l2,wynik);
      for(int i=0;i<1+rozmiarTablic;i++)
      {
        if(wynik[i]>=10)
          wynik[i]=wynik[i]-10+'A';
        else
          wynik[i]+='0';
      }
      printf ("\n wynik: %s: ",wynik);
      
  }
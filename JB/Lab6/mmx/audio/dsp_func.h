#ifndef _DSP_FUNC_H_
#define _DSP_FUNC_H_

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <linux/soundcard.h>

//--------------------------------------------------------------------------------

/*
 *	Otwiera urzadzenie audio o podanej sciezce. W przypaku niepowodzenia konczy program 
 *	z kodem bledu -3. Zwraca deskryptor pliku.
 *
 *	Przyklad:
 *
 *				open_dsp ("/dev/dsp") ;
 */
int open_dsp (const char* path) ;

/*
 *	Ustawia parametry (liczbe bitow probki - "SIZE", liczbe kanalow - "CHANNELS" 
 *	i czestotliwosc probkowania - "RATE")  otwartego urzadzenia dsp opisanego przez 
 *	deskryptor "dsp". W przypadku niepowodzenia wyswietla odpowiedni komunikat.
 *
 *	Przyklad dla strumienia stereo zawierajacego 2 kanaly 16 bitow probkowane 
 *	z czestotliwoscia 44100 Hz:
 *
 *				set_dsp (16, 2, 44100, dsp) ;
 */
void set_dsp (int SIZE, int CHANNELS, int RATE, int dsp) ;

/*
 *	Odtwarza bufor "data" o rozmiarze "size" bajtow na urzadzeniu opisanym przez 
 *	deskryptor "dsp". Przed uzyciem tej funkcji nalezy ustawic parametry urzadzenia
 *	korzystajac z funkcji "set_dsp". Funkcja czeka na zakonczenie odtwarzania. 
 *	W przypadku niepowodzenia wyswietla odpowiedni komunikat.
 *
 *	Przyklad dla bufora zawierajacego 10 sekund nagrania jednokanalowego sprobkowanego
 *	44100 razy na sekunde z rozdzielczoscia 16 bitow :
 *
 *			play_dsp (data, 882000, dsp) ;
 */
void play_dsp (char *data, int size, int dsp) ;

/*
 *	Zwraca wskaznik na bufor zawierajacy sume kanalow z przekazanego bufora stereo "buf"
 *	o rozmiarze "size" bajtow. Funkcja zaklada, ze rozmiar probki wynosi 16 bitow. 
 *	W przypadku niepowodzenia konczy program z kodem bledu -4.
 *
 *	Przyklad zwraca bufor zawierajacy 10 sekund sygnalu sprobkowanego 44100 razy na 
 *	sekunde z rozdzielczoscia 16 bitow - bufor wyjsciowy zajmuje 882000 bajtow:
 *
 *			short *mono = stereo_2_mono (data, 1764000) ;
 */
short* stereo_2_mono (char *buf, int size) ;

/*
 *	Zwraca bufor zawierajacy usredniony sygnal z bufora wejsciowego "mono" o rozmiarze
 *	"size" slow 16-bitowych. Usrednienie polega na znalezieniu wartosci probki wynikowej
 *	jako sredniej arytmetycznej "N" probek poprzedzajacych. Rozmiar bufora wyjsciowego
 *	jest rowny rozmiarowi bufora wejsciowego. W przypadku niepowodzenia funkcja konczy 
 *	program z kodem -5.
 */
short* fir_wave (short* mono, int size, int N) ;


#endif

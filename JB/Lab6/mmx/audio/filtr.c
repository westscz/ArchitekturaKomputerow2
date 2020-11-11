
#include "dsp_func.h"


int main (int argc, char**argv)
{
	if (argc < 2) {
		printf ("Podaj nazwe pliku!\n") ;
		return -1 ;
	} ;

	FILE *fd = fopen (argv[1], "r") ;
	if (fd == NULL) {
		perror ("nie mozna otworzyc pliku audio") ;
		return -2 ;
	} ;
	
	char	nap[5] ;
	int		i_tmp ;
	
	/*
	 *		Czytamy naglowki...
	 */
	nap[4] = '\0' ;
	fread (&nap[0], 1, 4, fd) ;

	printf ("ChunkID : %s\n", nap) ;
	fread (&i_tmp, 4,1,fd) ;
	printf ("ChunkSize : %d\n", i_tmp) ;
	fread (&nap[0], 1, 4, fd) ;
	printf ("Format : %s\n", nap) ;
	
	fread (&nap[0], 1, 4, fd) ;
	printf ("\tSubchunk1ID : %s\n", nap) ;
	fread (&i_tmp, 4,1,fd) ;
	printf ("\tSubchunk1Size : %d\n", i_tmp) ;
	i_tmp = 0 ;
	fread (&i_tmp, 2,1,fd) ;
	printf ("\tAudioFormat : %d\n", i_tmp) ;
	i_tmp = 0 ;
	fread (&i_tmp, 2,1,fd) ;
	printf ("\tNumChannels : %d\n", i_tmp) ;
	int CHANNELS = i_tmp ;
	fread (&i_tmp, 4,1,fd) ;
	printf ("\tSampleRate : %d\n", i_tmp) ;
	int RATE = i_tmp ;
	fread (&i_tmp, 4,1,fd) ;
	printf ("\tByteRate : %d\n", i_tmp) ;
	i_tmp = 0 ;
	fread (&i_tmp, 2,1,fd) ;
	printf ("\tBlockAlign: %d\n", i_tmp) ;
	i_tmp = 0 ;
	fread (&i_tmp, 2,1,fd) ;
	printf ("\tBitsPerSample: %d\n", i_tmp) ;
	int SIZE = i_tmp ;
	
	fread (&nap[0], 1, 4, fd) ;
	printf ("\tSubchunk2ID : %s\n", nap) ;
	fread (&i_tmp, 4,1,fd) ;
	printf ("\tSubchunk2Size : %d\n", i_tmp) ;
	int B_SIZE = i_tmp ;
	
	/*
	 *		Czytamy strumien audio
	 */
	char *data ;						// strumien audio z pliku (stereo)
	data = calloc (i_tmp, 1) ;
	int nread = fread (data, 1, B_SIZE,fd) ;
	printf ("Przeczytano %d bajtow.\n", nread) ;
	fclose (fd) ;
	
	/*
	 * 		Odtwarzanie bufora
	 */
	int dsp;       						// deskryptor urzadzenia DSP	

	dsp = open_dsp("/dev/dsp");
  	set_dsp (SIZE, CHANNELS, RATE, dsp) ;
	//play_dsp (data, nread, dsp) ;
	play_dsp (data, 1000000, dsp) ;		// tylko ok. 10 sekund
	
	/*
	 *		Redukcja kanalow audio
	 */
	short *data_mono = stereo_2_mono (data, nread) ;	// strumien mono

  	set_dsp (SIZE, 1, RATE, dsp) ;
	//play_dsp ((char*)data_mono, nread/2, dsp) ;
	play_dsp ((char*)data_mono, 1000000, dsp) ;

	/*
	 *		Filtracja
	 */


	short *fir ;	
	
	fir = fir_wave (data_mono, nread/4, 4) ;

	//play_dsp ((char*)fir, nread/2, dsp) ;
	play_dsp ((char*)fir, 1000000, dsp) ;

	/*
	 *		Porzadki 
	 */
	free (data) ;
	free (data_mono) ;
	free (fir) ;
	
	return 0 ;
} ;



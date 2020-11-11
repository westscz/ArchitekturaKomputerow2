
#include "dsp_func.h"

int open_dsp (const char* path)
{
  int dsp = open(path, O_RDWR);
  
  if (dsp < 0) {
    perror("open of dsp device failed");
    exit(-3);
  } ;

  return dsp ;
} ;

void set_dsp (int SIZE, int CHANNELS, int RATE, int dsp) 
{  
	int arg = SIZE;    /* sample size */  
	int status = ioctl(dsp, SOUND_PCM_WRITE_BITS, &arg);

	if (status == -1) 
    	perror("SOUND_PCM_WRITE_BITS ioctl failed");
    if (arg != SIZE) 
    	perror("unable to set sample size");

	arg = CHANNELS;  /* mono or stereo */
  	status = ioctl(dsp, SOUND_PCM_WRITE_CHANNELS, &arg);
  	if (status == -1)
    	perror("SOUND_PCM_WRITE_CHANNELS ioctl failed");
  	if (arg != CHANNELS)
    	perror("unable to set number of channels");

  	arg = RATE;      /* sampling rate */
  	status = ioctl(dsp, SOUND_PCM_WRITE_RATE, &arg);
  	if (status == -1)
    	perror("SOUND_PCM_WRITE_WRITE ioctl failed");

} ;

void play_dsp (char *data, int size, int dsp)
{
  	printf ("Odtwarzam %d bajtow....\n", size) ;
	
	int status = write (dsp, data, size) ;
	if (status != size)
      	perror("wrote wrong number of bytes");
	status = ioctl(dsp, SOUND_PCM_SYNC, 0); 
  	if (status == -1)
    	perror("SOUND_PCM_SYNC ioctl failed");
  	
	printf ("Koniec odtwarzania.\n") ;
} ;

short* stereo_2_mono (char *buf, int size)
{
	short *data_mono = calloc (size/2,1) ;
	if (data_mono == NULL) {
		perror ("mono bufor allocation error") ;
		exit(-4) ;
	} ;

	short *short_stereo = (short*)buf ;			// dla wygody

	int i ;
	for (i=0;i<size/2;i+=2)
	{
		int lp, pp, mp ;
		lp =0 ;pp = 0 ; mp = 0  ;
		lp = short_stereo[i] ;
		pp = short_stereo[i+1] ;
		mp = (lp + pp)/2 ;
		data_mono[i/2] = mp ;
	} ;

	return data_mono ;
} ;



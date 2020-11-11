#include <SDL/SDL.h>
SDL_Surface * ekran = NULL;
SDL_Surface * obraz = NULL;
SDL_Event zdarzenie;
bool wyjscie = false;
SDL_Rect spix[ 2 ];	//deklaracja tablicy
SDL_Rect dpix[ 2 ];	// destination prostokat

int main( int argc, char * args[] )
{
    SDL_Init( SDL_INIT_EVERYTHING );
    ekran = SDL_SetVideoMode( 640, 800, 32, SDL_SWSURFACE );
    SDL_WM_SetCaption( "90 stopni", NULL );
    obraz = SDL_LoadBMP( "2.bmp" );
    int w = 865;
    int h = 600;
    
    for (int y = 0; y < h; y++){
    	for (int i = 0; i < w; i++){
	    	spix[ 0 ].x = 0 + i;		//w poziomie gdzie zaczynamy wyciecie
	    	spix[ 0 ].y = 0 + y;		//w pionie gdzie zaczynamy wyciecie
	    	spix[ 0 ].w = 1;		//szerokosc
	    	spix[ 0 ].h = 1; 		//wysokosc

    		dpix[ 0 ].x = 640 - y;
    		dpix[ 0 ].y = i;
    
    		SDL_BlitSurface( obraz, & spix[ 0 ], ekran, & dpix[ 0 ] );
    	}
    }

    SDL_Flip( ekran );
    SDL_Delay( 2000 );
    while( !wyjscie )
    {
        while( SDL_PollEvent( & zdarzenie ) )
        {
            if( zdarzenie.type == SDL_QUIT )
            {
                wyjscie = true;
            }
        }
    }
    SDL_Quit();
    SDL_FreeSurface( obraz );
    return 0;
}

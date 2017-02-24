SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LDFLAGS := $(shell sdl-config --libs)


showimage: showimage.c
	gcc showimage.c -o lab `sdl-config --cflags --libs` -lSDL_image -lSDLmain

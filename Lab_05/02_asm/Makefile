SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LDFLAGS := $(shell sdl-config --libs)


showimage: showimage.c negative.o
	gcc showimage.c _negative.o -g -o lab `sdl-config --cflags --libs` -lSDL_image -lSDLmain

negative.o: _negative.s
	as -g -o _negative.o _negative.s 
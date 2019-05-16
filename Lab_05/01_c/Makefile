SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LDFLAGS := $(shell sdl-config --libs)


showimage: showimage.c
	gcc showimage.c -o lab `sdl-config --cflags --libs` -lSDL_image -lSDLmain

ex1:
	./lab 1.bmp 513078

ex2:
	./lab 2.bmp 1557654

ex3:
	./lab 3.jpg 64645
// Start of 2d game engine
// Started 2/9/2024

#include <iostream>
#include "game.h"

using namespace std;

Game *game = nullptr;

int main(int argc, char* argv[])
{

	const int FPS = 60;
	// How much time between frames
	const int frameDelay = 1000 / FPS;

	//
	Uint32 frameStart;
	int frameTime;

	// Game object
	game = new Game();

	// Picked 800x640 because x600 doesn't divide by 32
	game->init("ArchangelEngine", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 640, false);

	// Do game ops while game is running. Self-explanatory
	while (game->running())
	{
		// Get frame
		frameStart = SDL_GetTicks();


		game->handleEvents();
		game->update();
		game->render();

		// How long the frame takes
		frameTime = SDL_GetTicks() - frameStart;

		// Delay frame if needed
		if (frameDelay > frameTime)
		{
			SDL_Delay(frameDelay - frameTime);
		}
	}

	game->clean();

	return 0;
}

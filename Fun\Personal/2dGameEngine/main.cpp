// Start of 2d game engine
// Started 2/9/2024

#include <iostream>
#include "game.h"

using namespace std;

Game *game = nullptr;

int main(int argc, char* argv[])
{
	// Game object
	game = new Game();

	game->init("SpruceEngine", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, false);

	// Do game ops while game is running. Self-explanatory
	while (game->running())
	{
		game->handleEvents();
		game->update();
		game->render();
	}

	game->clean();

	return 0;
}

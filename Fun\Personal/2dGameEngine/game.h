#pragma once

#include <SDL.h>

class Game
{
	public:
		Game();		// Constructor
		~Game();	// Destructor

		void init(const char* title, int xpos, int ypos, int width, int height, bool fullscreen);
		
		void handleEvents();
		void update();
		void render();
		void clean();

		bool running() { return isRunning; }	// Returns bool

	private:
		bool isRunning;
		SDL_Window *window;
		SDL_Renderer *renderer;

};

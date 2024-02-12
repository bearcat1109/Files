#include "game.h"
#include <iostream>
#include <SDL.h>
using namespace std;

Game::Game()
{

}

Game::~Game()
{

}

void Game::init(const char* title, int xpos, int ypos, int width, int height, bool fullscreen)
{
	int flags = 0;
	if (fullscreen)
	{
		// Change flags variable if fullscreen is desired
		flags = SDL_WINDOW_FULLSCREEN;
	}

	if (SDL_Init(SDL_INIT_EVERYTHING) == 0)
	{
		cout << "SDL subsystems initialized" << endl;

		window = SDL_CreateWindow(title, xpos, ypos, width, height, flags);
		if (window)
		{
			cout << "Window created!" << endl;
		}

		renderer = SDL_CreateRenderer(window, -1, 0);
			if (renderer)
			{
				SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
				cout << "Renderer created!" << endl;
			}
			isRunning = true;
	} else 
	{
		isRunning = false;
	}
}


void Game::handleEvents()
{
	SDL_Event event;
	SDL_PollEvent(&event);

	// Switch statement to determine type of event
	switch (event.type)
	{
	case SDL_QUIT:
		isRunning = false;
		break;

	default:
		break;
	}
}

void Game::update()
{}

void Game::render()
{
	SDL_RenderClear(renderer);

	// Add stuff to render
	SDL_RenderPresent(renderer);
}

void Game::clean()
{
	SDL_DestroyWindow(window);
	SDL_DestroyRenderer(renderer);
	SDL_Quit();
	cout << "Cleanup on aisle Game complete" << endl;
}


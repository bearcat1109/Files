#include "game.h"
#include <iostream>
#include <SDL.h>
#include "textureManager.h"
#include "gameObject.h"
using namespace std;

// Texture manager (unneeded now)
//SDL_Texture* playerTex;
//SDL_Rect srcRect, destRect;

gameObject* player;
gameObject* enemy;


SDL_Renderer* Game::renderer = nullptr;

Game::Game()
{}

Game::~Game()
{}

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

	//playerTex = textureManager::LoadTexture("assets/player.png", renderer);
	player = new gameObject("assets/player.png", 0, 0);
	enemy = new gameObject("assets/enemy.png", 50, 50);
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
{
	// Old
	/*cnt++;
	destRect.h = 64;
	destRect.w = 64;
	destRect.x = cnt;
	cout << cnt << endl;*/

	player->update();
	enemy->update();
}

void Game::render()
{
	SDL_RenderClear(renderer);

	// Old now
	//SDL_RenderCopy(renderer, playerTex, NULL, &destRect);
	
	player->render();
	enemy->render();
	
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


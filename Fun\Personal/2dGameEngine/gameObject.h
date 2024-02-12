#pragma once
#include "game.h"

class gameObject
{
public:
	// Constructor/Deconstructor
	gameObject(const char* textureSheet, int x, int y);
	~gameObject();

	void update();
	void render();

private:
	// Attributes of the game object
	int xpos;
	int ypos;

	SDL_Texture* objTexture;
	SDL_Rect srcRect, destRect;
	// No longer needed since we have this in game.h now
	//SDL_Renderer* renderer;

};

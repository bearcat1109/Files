#include "gameObject.h"
#include "textureManager.h"

gameObject::gameObject(const char* textureSheet,int x, int y)
{
	//renderer = ren;
	// Create texture
	objTexture = textureManager::LoadTexture(textureSheet);

	xpos = x;
	ypos = y;
}

// Movements/Behaviors
void gameObject::update()
{
	// No longer needed as it's now above in gameObject::gameObject
	//xpos = 0;
	//ypos = 0;
	xpos++;
	ypos++;

	srcRect.h = 32;
	srcRect.w = 32;
	srcRect.x = 0;
	srcRect.y = 0;

	destRect.x = xpos;
	destRect.y = ypos;
	destRect.w = srcRect.w * 2;
	destRect.h = srcRect.h * 2;
}


// Draw texture
void gameObject::render()
{
	SDL_RenderCopy(Game::renderer, objTexture, &srcRect, &destRect);
}

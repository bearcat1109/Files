#include <iostream>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>


using namespace std;

const int WIDTH = 800, HEIGHT = 600;

int main(int argc, char* argv[]) {

    SDL_Init(SDL_INIT_EVERYTHING);

    SDL_Window* window = SDL_CreateWindow("Hello, SDL World!", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_ALLOW_HIGHDPI);

    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    if (NULL == window || NULL == renderer) {
        cout << "Could not create window/renderer: " << SDL_GetError() << endl;
        return 2;
    }

    // Initialize SDL_ttf
    if (TTF_Init() == -1) {
        cout << "TTF_Init failed: " << TTF_GetError() << endl;
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 3;
    }

    // Load a font (adjust the path and size as needed)
    TTF_Font* font = TTF_OpenFont("C:\\Users\\berresg\\Desktop\\download\\Roboto_Mono\\RobotoMono-VariableFont_wght.ttf", 24);

    if (!font) {
        cout << "TTF_OpenFont failed: " << TTF_GetError() << endl;
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        TTF_Quit();
        SDL_Quit();
        return 4;
    }

    SDL_Surface* icon = SDL_LoadBMP("C:\\Users\\berresg\\Desktop\\download\\1ae0cfcec29aaff9.bmp");

    SDL_SetWindowIcon(window, icon);

    SDL_Event windowEvent;

    while (true) {
        if (SDL_PollEvent(&windowEvent)) {
            if (SDL_QUIT == windowEvent.type) {
                break;
            }
        }

        // Clear the renderer
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);

        // Set the color for rendering text
        SDL_Color textColor = { 255, 255, 255 }; // White color

        // Create a surface for the text
        SDL_Surface* textSurface = TTF_RenderText_Solid(font, "Hello, SDL Text!", textColor);

        // Create a texture from the surface
        SDL_Texture* textTexture = SDL_CreateTextureFromSurface(renderer, textSurface);

        // Get the width and height of the text surface
        int textWidth = textSurface->w;
        int textHeight = textSurface->h;

        // Set the destination rectangle for rendering the text
        SDL_Rect destRect = { 100, 100, textWidth, textHeight }; // Adjust the position as needed

        // Render the text on the window
        SDL_RenderCopy(renderer, textTexture, NULL, &destRect);

        // Clean up resources
        SDL_DestroyTexture(textTexture);
        SDL_FreeSurface(textSurface);

        // Present the renderer
        SDL_RenderPresent(renderer);
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    TTF_CloseFont(font);
    TTF_Quit();
    SDL_Quit();

    return EXIT_SUCCESS;
}

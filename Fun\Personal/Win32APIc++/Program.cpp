#include <iostream>
#include "Window.h"

using namespace std;

int main()
{
    cout << "Creating Window...\n";

    Window* pWindow = new Window();

    bool running = true;
    while (running)
    {
        // Render
        if (pWindow->ProcessMessages())
        {
            cout << "Closing window.\n";
            running = false;
        }

        Sleep(10);
    }

    delete pWindow;

    return 0;
}

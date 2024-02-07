#include "Window.h"

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
        // When window is closed, destroy
    case WM_CLOSE:
        DestroyWindow(hWnd);
        break;
        // When window is destroyed, 
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    }

    return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

Window::Window()
    : m_hInstance(GetModuleHandle(nullptr))
{
    // Char pointer, L defines wide string
    const wchar_t* CLASS_NAME = L"Gabriel's Window Class";

    WNDCLASS wndClass = {};
    wndClass.lpszClassName = CLASS_NAME; // Fills with string from before
    wndClass.hInstance = m_hInstance;
    wndClass.hIcon = LoadIcon(NULL, IDI_WINLOGO);   // Windows logo on icon
    wndClass.hCursor = LoadCursor(NULL, IDC_ARROW); // Windows pointer arrow for cursor
    wndClass.lpfnWndProc = WindowProc; // Procedure to implement later

    RegisterClass(&wndClass);

    // Caption gives the window a title bar, minimizebox creates a tray icon, sysmenu makes windows close, expand icons
    DWORD style = WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU;

    // Resolution
    int width = 640;
    int height = 480;

    // Dimensions of the window. Left and top are where it appears on screen
    //RECT rect;
    //rect.left = 350;
    //rect.top = 350;
    //rect.right = rect.left + width;
    //rect.bottom = rect.top + height;

    // Previously that stuff would define the outer border, but we want the inner border (canvas) to be the desired resolution
    // Takes in pointer to the rect, the style, and whether or not to use menus(true/false)
    RECT rect = { 0, 0, width, height };
    AdjustWindowRect(&rect, style, false);

    m_hWnd = CreateWindowEx(
        0,
        CLASS_NAME,
        L"My Window",
        style,
        CW_USEDEFAULT, CW_USEDEFAULT, rect.right - rect.left, rect.bottom - rect.top,
        nullptr,
        nullptr,
        m_hInstance,
        nullptr
    );

    ShowWindow(m_hWnd, SW_SHOW); // To actually DISPLAY the window

    // Get "device context" which I don't 100% understand yet
    HDC hdc = GetDC(m_hWnd);
    // For font
    HFONT hFont = CreateFont(20, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET,
        OUT_OUTLINE_PRECIS, CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY, VARIABLE_PITCH, TEXT("Comic Sans"));

    SelectObject(hdc, hFont);

    // Drwa text
    const wchar_t* textToDisplay = L"Use C#, nerd";
    RECT textRect = { 50, 50, 400, 200 };
    DrawText(hdc, textToDisplay, -1, &rect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

    ReleaseDC(m_hWnd, hdc);

    MSG msg = {};
    while (GetMessage(&msg, nullptr, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
}

Window::~Window()
{
    const wchar_t* CLASS_NAME = L"Gabriel's Window Class";
    UnregisterClass(CLASS_NAME, m_hInstance);
}

bool Window::ProcessMessages()
{
    // Initialize message
    MSG msg = {};

    // &msg pass passes the message, PM_REMOVE removes it from the queue when done
    while (PeekMessage(&msg, nullptr, 0u, 0u, PM_REMOVE))
    {
        if (msg.message = WM_QUIT)   // If quit message is received from PostQuitMessage, quit the application
        {
            return false;
        }

        TranslateMessage(&msg);     // Translates key presses to characters
        DispatchMessage(&msg);      // Calls window procedure
    }

    return true;        // return true as long as we want to continue the program
}


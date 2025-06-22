## Brief overview
This guideline specifies how to manage and access screenshots for review. I can also call them local screenshots or print screens

## Screenshot Management
-   **Location:** All screenshots are saved in `C:\Users\admin\Pictures\Screenshots`.
-   **Default Behavior:** If instructed to check a screenshot, always check the last screenshot saved in the specified directory by default.
-   **Flexible Access:** The user may explicitly instruct to check a specific number of recent screenshots (e.g., "last 2" or "last 3").
-   **Viewing Screenshots:** When instructed to "check" or "see" a screenshot, always open it in the browser using the `browser_action` tool with the `launch` action and the `file:///` protocol. After viewing, close the browser using the `close` action.
-   **Describing Screenshots:** After opening a screenshot in the browser, provide a brief description of its contents to the user.

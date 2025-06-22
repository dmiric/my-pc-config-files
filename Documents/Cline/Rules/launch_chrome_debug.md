## Brief overview
This guideline provides the command to launch Chrome with remote debugging enabled for Playwright MCP server connection.

## Launch Chrome with Debug Mode
-   **Purpose:** To launch a Chrome browser instance that the Playwright MCP server can connect to and control, ensuring a visible browser window.
-   **Command:**
    `Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--remote-debugging-port=9222", "--user-data-dir=C:\Users\admin\Documents\Cline\MCP\temp_chrome_profile"`
-   **Usage Notes:**
    -   Execute this command in your terminal before attempting to use Playwright MCP server tools (like `browser_navigate`).
    -   The `--remote-debugging-port=9222` argument enables the Chrome DevTools Protocol for remote control.
    -   The `--user-data-dir` argument points to a temporary profile, which helps avoid conflicts with other Chrome instances and ensures a clean session.
    -   Ensure all other Chrome instances are closed before running this command to prevent interference.

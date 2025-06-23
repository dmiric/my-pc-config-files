## Brief overview
This guideline defines how to remember URLs provided by the user.

## Remember URL Workflow
-   **Trigger:** This workflow is initiated when the user provides a message starting with "remember:".
-   **Step 1: Extract URL:**
    -   Extract the URL by removing the "remember:" prefix from the user's message.
-   **Step 2: Store URL:**
    -   Append the extracted URL to the file `C:\Users\admin\Documents\Cline\Rules\remembered_urls.txt` using the PowerShell command: `Add-Content -Path "C:\Users\admin\Documents\Cline\Rules\remembered_urls.txt" -Value "YourURLHere`n"`.
-   **Step 3: Confirm:**
    -   Confirm to the user that the URL has been successfully remembered.
-   **Step 4: Open File in VS Code (Optional):**
    -   To open the `remembered_urls.txt` file in VS Code, use the command: `code C:\Users\admin\Documents\Cline\MCP\remembered_urls.txt`.

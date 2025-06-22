## Brief overview
This guideline defines the process for "asking a pro" when external assistance is needed for a task.

## Ask a Pro Workflow
-   **Trigger:** This workflow is initiated when the user explicitly instructs to "ask a pro".
-   **Step 1: Prepare the Prompt:**
    -   If the user's instruction is a direct question (e.g., "how big is the sun?"), use that text directly as the prompt.
    -   Otherwise, create a concise summary of the last task being worked on.
    -   Include:
        -   A brief description of the problem.
        -   What troubleshooting steps or solutions were attempted.
        -   Relevant code snippets that were involved in the problem or attempted solutions.
        -   The exact results or errors encountered.
-   **Step 2: Launch Chrome with Debugging:**
    -   Execute the `launch_chrome_debug.ps1` script: `powershell -File C:\Users\admin\Documents\Cline\Rules\launch_chrome_debug.ps1`.
    -   Then, navigate the Playwright-controlled browser to the URL: `use_mcp_tool` with `server_name: "playwright"`, `tool_name: "browser_navigate"`, and `arguments: { "url": "https://aistudio.google.com/prompts/new_chat" }`.
-   **Step 4: Interact with Chat Interface:**
    -   **Wait for Page Content:** First wait 2 seconds for page to load and then use `browser_snapshot` to get the page's accessibility tree.
    -   **Paste Summary into Text Area:** Take the prepared prompt from Step 1 and use `browser_type` to input it into the primary text input area on the page.
    -   **Target Text Area Hint:** Look for a `textbox` element with `aria-label="Start typing a prompt"`. Verify the `ref` attribute from the latest `browser_snapshot`.
    -   **If Text Area Not Found:** If the specified text area is not found, attempt to identify another relevant and prominent text input area on the page. If a new, reliable target is found, update this rule with the new selector information for future use.
    -   **Submit Prompt:** Type the prepared prompt into the identified text area using `browser_type` with `element: "Start typing a prompt"` and the verified `ref`.
    -   Click the "Run" button to submit the prompt using `browser_click` with `element: "Run button"`. Verify the `ref` attribute from the latest `browser_snapshot`.
    -   **Step 5: Wait for Response Completion:**
    -   Wait for the AI's response to finish, indicated by the appearance of the "thumb_up" icon. Use `browser_wait_for` with `text: "thumb_up"`. Retry 3 times.
-   **Step 6: Extract Response Text:**
    -   After the response is complete, extract the text content of the AI's response. The response text typically starts after the "Edit" button and ends before the "Good response" button.
    -   Use `browser_snapshot` to get the page's accessibility tree.
    -   Identify the `paragraph` elements that contain the response text. These elements are usually children of a `generic` element that follows the "Edit" button and precedes the "Good response" button.
    -   Concatenate the text content of these `paragraph` elements to form the complete response.
-   **Step 7: Review Response (No Automatic Browser Close):**
    -   The browser window will remain open after the prompt is submitted, allowing the user to review the AI's response. Do not automatically close the browser.

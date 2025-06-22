## Brief overview
This guideline specifies preferences for API key usage during testing within this project.

## Testing Preferences
-   **API Key Usage:** When an API key is required for testing, use the `API_KEY` defined in the `Makefile` rather than creating new users for that purpose.
-   **Server Testing:** When testing API endpoints on the server, use `curl` commands executed from the local machine, targeting the server's public IP address. Do not SSH into the server to run commands on `localhost` from there.

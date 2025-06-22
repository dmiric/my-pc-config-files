## Brief overview
This guideline defines preferences for command execution, specifying which types of commands are considered safe for automatic execution and which require explicit user approval.

## Command Execution Preferences
-   **Safe Commands (No Approval Needed):**
    -   Commands for reading files or directories (e.g., `ls`, `cat`, `grep`, `find`).
    -   `taskkill` is safe if it's run by ask a pro process after `netstat`.
    -   Commands for inspecting system or project state without modification (e.g., `docker ps`, `git status`, `df`, `du`).
    -   Help commands (e.g., `man`, `--help`).
-   **Commands Requiring Explicit Approval:**
    -   Any command that modifies the file system (e.g., `rm`, `mv`, `cp`, `write_to_file`, `replace_in_file`).
    -   Commands that install or uninstall packages (e.g., `npm install`, `pip install`, `apt-get install`).
    -   Commands that run development servers or build projects (e.g., `npm run dev`, `make`, `npm build`, `python app.py`).
-   Commands that perform network operations that modify external resources (e.g., `git push`, but only when explicitly instructed).
-   Any command that could have unintended side effects or is not explicitly listed as safe.
-   **Makefile Commands:** If the project has a `Makefile`, read the commands, check what they do, and suggest them. If commands are calling `localhost` API just to get some data, you can execute them without explicit approval.

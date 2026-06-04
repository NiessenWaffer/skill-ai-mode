# skill-ai-mode

Minimal AI skill repo for supported AI editors.

## Prerequisite

- Install [Node.js](https://nodejs.org/) (includes npm) on your computer (Windows, macOS, or Linux).

## Active Skills

- `/planning` → `Planning mode/Planning.md`
- `/developer` → `Developer mode/developer.md`
- `/debug` → `Debugging mode/debugger.md`

## Gemini CLI Native Commands

Gemini CLI does not load these slash commands from `.md` files. It loads command definition files with the `.toml` extension.

- Global Gemini commands path:
  - Windows: `C:\Users\<you>\.gemini\commands`
  - POSIX: `~/.gemini/commands`
- Project-local Gemini commands path:
  - `<project>/.gemini/commands`
- Generated command files:
  - `planning.toml`
  - `developer.toml`
  - `debug.toml`

This repo includes generated project-local commands in `.gemini/commands/` for local testing. Installers also generate the same commands into the global Gemini commands folder.

To regenerate project-local Gemini command files from the Markdown skill sources:

```bash
npm run generate:gemini-commands
```

After installing or regenerating commands, run this inside Gemini CLI:

```text
/commands reload
```

## Installation

**Planning, Developer, and Debugging mode skills are installed to your global skills folder, never inside a project.**
**Gemini CLI slash commands are installed as `.toml` files in your global Gemini commands folder.**

### Windows PowerShell

Paste this into PowerShell. You do not need to download the repo first.

```powershell
$installer = "$env:TEMP\skill-ai-mode-install.ps1"; Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.ps1" -OutFile $installer; powershell -ExecutionPolicy Bypass -File $installer -Yes
```

It installs:

- Skills: `C:\Users\<you>\.agents\skills`
- Gemini CLI commands: `C:\Users\<you>\.gemini\commands`

Then open Gemini CLI and run:

```text
/commands reload
```

After that, use:

```text
/planning
/developer
/debug
```

### macOS/Linux
```bash
curl -fsSL https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.sh | bash -s -- -y
```

Then run `/commands reload` in Gemini CLI.

### Advanced Install Options

Use these only if you want custom install paths or you already cloned the repo.

```powershell
# From the repo root
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Yes

# Custom skills destination
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Yes -Destination "C:\Users\<you>\.agents\skills"

# Custom Gemini commands destination
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Yes -GeminiCommandsDestination "C:\Users\<you>\.gemini\commands"
```

```bash
# Custom skills destination
curl -fsSL https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.sh | bash -s -- -y -d "$HOME/.agents/skills"

# Custom Gemini commands destination
curl -fsSL https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.sh | bash -s -- -y --gemini-commands-destination "$HOME/.gemini/commands"
```

### Editor Configuration (All Editors)
- Set skills directory to your install path, e.g. `~/.agents/skills`.
- Optional: set `AI_PROVIDER` environment variable to hint formatting/profile
  - `gemini` | `anthropic` | `openai` | `copilot` | `generic`
- Optional: override skills dir with `AI_SKILLS_DIR` (takes precedence over default `~/.agents/skills`).
- Use slash commands in chat: `/planning`, `/developer`, and `/debug`.
- Gemini CLI requires command files to be `.toml`; these are generated into `~/.gemini/commands`.

### Update
- Re-run the installer (either method). It safely overwrites the existing files in `~/.agents/skills`.
- Re-run `/commands reload` in Gemini CLI after updating.

### Uninstall
- Delete the global skills folder manually:
  - Windows: `C:\Users\<you>\.agents\skills`
  - POSIX: `~/.agents/skills`
- Delete generated Gemini commands manually:
  - Windows: `C:\Users\<you>\.gemini\commands\planning.toml`, `developer.toml`, `debug.toml`
  - POSIX: `~/.gemini/commands/planning.toml`, `developer.toml`, `debug.toml`

## Project Setup

- **Keep** `List plan/` inside your local project repository to store `plan.md`, `workflow.md`, and `task.md`.
- **Do NOT** copy `Planning mode/`, `Developer mode/`, `.agents/`, or `gemini.md` into your local project.
- **Do NOT** copy `.gemini/commands` into every project unless you intentionally want project-local Gemini commands. The normal installer writes global commands to `~/.gemini/commands`.
- To start, open your AI editor inside your project and type `/planning`, `/developer`, or `/debug`. The AI will automatically ask where the `List plan/` folder should be created if it doesn't exist.

## Example Workflow

1. Install globally (see above)
2. Open your project in your AI editor
3. In Gemini CLI, run `/commands reload` after install or update
4. Type `/planning`, `/developer`, or `/debug`
5. The AI uses global skills and creates/updates `List plan/plan1/plan.md` etc. in your project

## Multi-Provider Support

This repo is provider-agnostic. It works with Gemini, Claude (Anthropic), OpenAI, GitHub Copilot Chat, and generic editors.

- Configure your editor/CLI to load skills from: `~/.agents/skills`
- For Gemini CLI, commands are loaded from `~/.gemini/commands/*.toml`
- The Gemini `.toml` files are generated from the Markdown source files in this repo
- On first use, the router can adapt style and constraints per provider (see `gemini.md#PROVIDER_ADAPTERS`).
- If your editor lacks a system message, the agent embeds a MODE/ROLE/SCOPE header in the first reply to preserve behavior.

### Vibe Coder Quickstart
- Install skills globally (Windows one-liner or PowerShell).
- In Vibe Coder, set Skills Directory to `C:\Users\<you>\.agents\skills`.
- Start a session inside your project and type:
  - `/planning` to create or revise `List plan/plan1/plan.md`
  - `/developer` to generate `task.md` and implement tasks progressively
  - `/debug` to create `List plan/plan1/debug.md` and run a focused debugging lifecycle
- If prompted, confirm where to create `List plan/` in the project.

### Provider Tips
- **Claude/OpenAI**: Keep outputs compact; large responses are split per phase.
- **Copilot Chat**: System messages may be limited. The router auto-includes a MODE/ROLE/SCOPE header in the first answer.
- **Generic**: Uses compact technical contract style and fenced code by default.

See also: `gemini.md#AGENTIC_DISCIPLINE` for consolidated agentic behavior principles used by all modes.

## Debugging Mode Overview

- Purpose: isolate and resolve bugs with minimal, safe changes.
- Artifact: `List plan/plan{n}/debug.md` (debug plan only; not a feature plan).
- Phases: `D1_INTAKE → D2_REPRO → D3_SCOPE_IMPACT → D4_HYPOTHESES → D5_INSTRUMENT → D6_FIX → D7_VERIFY → D8_POSTMORTEM`.
- Safety: minimal-delta fixes, follow runtime-safety, no secrets/PII, no production data writes.

## CLI Usage (All Providers)

If you prefer a pure terminal flow, use the helper scripts to assemble system/user messages for your AI CLI:

- Windows (PowerShell):
  - Planning:
    ```powershell
    ./planning.ps1 -ProjectRoot "C:\path\to\your\project" -PlanUnit "List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```
  - Developer:
    ```powershell
    ./developer.ps1 -ProjectRoot "C:\path\to\your\project" -PlanUnit "List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```
  - Debug:
    ```powershell
    ./debugging.ps1 -ProjectRoot "C:\path\to\your\project" -PlanUnit "List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```

- macOS/Linux:
  - Planning:
    ```bash
    ./planning.sh PROJECT_ROOT="/path/to/project" PLAN_UNIT="List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```
  - Developer:
    ```bash
    ./developer.sh PROJECT_ROOT="/path/to/project" PLAN_UNIT="List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```
  - Debug:
    ```bash
    ./debugging.sh PROJECT_ROOT="/path/to/project" PLAN_UNIT="List plan/plan1"
    # Note the output: SYSTEM_FILE=... and USER_FILE=...
    # Send those to your AI CLI as system and user messages.
    ```

Per-provider examples (to be added based on your CLI):
- Anthropic/Claude CLI:
  ```bash
  anthropic messages create \
    --model claude-3-opus-20240229 \
    --system @"$SYSTEM_FILE" \
    --input-file @"$USER_FILE"
  ```
- OpenAI CLI: pass system and user via input files
- Gemini CLI: pass system and user via input files
- Gemini CLI native slash commands: run `/commands reload`, then `/planning`, `/developer`, or `/debug`
- Copilot CLI: if unsupported, run via editor chat instead

### CLI environment variables quick reference
- AI_SKILLS_DIR: Absolute path to your global skills folder. Default: `~/.agents/skills`.
- AI_PROVIDER: Provider hint used by helpers to choose a default model.
  - Allowed: `gemini` | `anthropic` | `openai` | `copilot` | `generic`.
- MODEL: Explicit model to use. If unset, helpers select defaults by provider.
  - Fallbacks when MODEL is unset: `ANTHROPIC_MODEL` | `OPENAI_MODEL` | `GEMINI_MODEL`.
  - Built-in defaults if none provided: `claude-3-opus-20240229` | `gpt-4o` | `gemini-1.5-pro` (picked by provider).
- AI_CLI_TEMPLATE: Shell command template the helpers expand and print as `COMMAND=...`.
  - Placeholders: `{SYSTEM_FILE}` `{USER_FILE}` `{MODEL}`.
  - Example (PowerShell): `anthropic messages create --model {MODEL} --system @"{SYSTEM_FILE}" --input-file @"{USER_FILE}"`
  - Example (bash): `anthropic messages create --model {MODEL} --system @"{SYSTEM_FILE}" --input-file @"{USER_FILE}"`


## Versioning & Upgrade
- This skills bundle is versioned via `SKILLS_VERSION` (semver). Installers copy this file.
- To check installed version:
  - Windows: prints after install (install.ps1) or re-run installer
  - macOS/Linux: prints after install (install.sh) or re-run installer
- Upgrading: re-run your installer command; files are safely overwritten in `~/.agents/skills` (or `AI_SKILLS_DIR`).
- Gemini command upgrades overwrite `planning.toml`, `developer.toml`, and `debug.toml`; run `/commands reload` afterward.

## Developer Delta Reads
- The developer pipeline uses delta-only reads for `plan.md`, `workflow.md`, and inspected project files.
- Strategy: SHA-256 preferred, mtime fallback, session-scoped cache per `plan{n}`.

## Slash Commands in Editors

The skills are invoked by simple chat commands. Most AI editors accept these as plain messages.
Gemini CLI specifically reads custom slash commands from `.toml` files in `~/.gemini/commands` or `<project>/.gemini/commands`.
Markdown files such as `gemini.md` and `Planning mode/Planning.md` remain the skill source of truth, but Gemini CLI slash command discovery requires the generated `.toml` wrappers.

- Primary commands:
  - `/planning` → loads Planning kernel and runs PHASE_1_INIT progressively
  - `/developer` → loads Developer kernel and starts the implementation pipeline
  - `/debug` → loads Debugging kernel and starts D1_INTAKE

- Fallback aliases (if your editor reserves `/`):
  - `planning` or `plan` or `spec` or `workflow`
  - `developer` or `implement` or `build` or `code` or `task`
  - `debug` or `triage` or `repro` or `fix_bug`

- Expected first prompts in Planning:
  - Confirms/asks for `List plan/` folder location in your project
  - Parses your goal and begins PHASE_1_INIT

- Expected first prompts in Developer:
  - Requires approved `plan.md` and `workflow.md` from `List plan/plan{n}/`
  - Generates or patches `task.md` before any code changes

### Configure Your Editor Once
- Skills directory: point your editor/CLI to `~/.agents/skills`
- Gemini CLI commands directory: `~/.gemini/commands`
- Optional provider hint (helps formatting): set env `AI_PROVIDER` to
  - `gemini` | `anthropic` | `openai` | `copilot` | `generic`

### Vibe Coder
- Settings → Skills Directory → `C:\Users\<you>\.agents\skills`
- In a project chat, type `/planning` or `/developer`

### Optional: Quick Command Bindings (Editors)

- **VS Code**
  - Add to `File → Preferences → Keyboard Shortcuts → Open JSON` (keybindings.json):
  ```json
  [
    {
      "key": "ctrl+alt+p",
      "command": "type",
      "args": { "text": "/planning " },
      "when": "chatInputFocus"
    },
    {
      "key": "ctrl+alt+d",
      "command": "type",
      "args": { "text": "/developer " },
      "when": "chatInputFocus"
    }
  ]
  ```
  - Focus your editor's Chat input, then press the shortcut to insert the command.

- **JetBrains IDEs (IntelliJ, WebStorm, etc.)**
  - Use built-in Macros:
    - Tools → Start Macro Recording → type `/planning` → Stop Macro Recording → save as "AI Planning".
    - Settings → Keymap → search "AI Planning" → Add Keyboard Shortcut (e.g., Ctrl+Alt+P).
    - Repeat for `/developer` as "AI Developer" (e.g., Ctrl+Alt+D).

- **Neovim (init.lua)**
  - Map keys to copy the commands to clipboard for quick paste into your chat buffer:
  ```lua
  vim.keymap.set('n', '<leader>pp', function()
    vim.fn.setreg('+', '/planning ')
    print('Copied /planning to clipboard. Paste in your AI chat input.')
  end, { desc = 'AI: /planning to clipboard' })

  vim.keymap.set('n', '<leader>pd', function()
    vim.fn.setreg('+', '/developer ')
    print('Copied /developer to clipboard. Paste in your AI chat input.')
  end, { desc = 'AI: /developer to clipboard' })
  ```

- **Sublime Text**
  - Preferences → Key Bindings → add to the right-hand (User) pane:
  ```json
  [
    { "keys": ["ctrl+alt+p"], "command": "insert", "args": { "characters": "/planning " } },
    { "keys": ["ctrl+alt+d"], "command": "insert", "args": { "characters": "/developer " } }
  ]
  ```
  - Focus the chat input (or any text box) and press the shortcut.

- **Emacs (init.el)**
  ```elisp
  (defun ai/insert-planning () (interactive) (insert "/planning "))
  (defun ai/insert-developer () (interactive) (insert "/developer "))
  (global-set-key (kbd "C-c p p") #'ai/insert-planning)
  (global-set-key (kbd "C-c p d") #'ai/insert-developer)
  ```

- **Cursor (VS Code-based)**
  - Use the same VS Code keybindings.json snippet above.

- **Zed**
  - Open Settings → Keyboard Shortcuts.
  - Add two shortcuts that insert the literal text:
    - "/planning "
    - "/developer "
  - Then focus Zed's chat input and press the shortcut to insert the command.

## Editor Verification Checklists

- **All Editors**
  - Confirm skills installed at `~/.agents/skills` and that your editor/CLI points to that folder.
  - Open your actual project folder (not the global skills folder).
  - Send `/planning` in the editor's chat.
  - Expect: a prompt to confirm/create `List plan/` and the start of PHASE_1_INIT.
  - Verify: `List plan/` appears in your project; `List plan/plan1/plan.md` is created or patched.
  - Send `/developer` only after plan.md + workflow.md are approved.
  - Expect: "task.md generation required before code" and creation/patch of `task.md`.

- **Gemini CLI**
  - Confirm command files exist in `C:\Users\<you>\.gemini\commands` or `~/.gemini/commands`.
  - Confirm the files are `planning.toml`, `developer.toml`, and `debug.toml`.
  - Run `/commands reload`.
  - Run `/planning`, `/developer`, or `/debug`.
  - If a command is missing, check that the file extension is `.toml`, not `.md`.

- **Vibe Coder**
  - Settings → Skills Directory = `C:\Users\<you>\.agents\skills`.
  - New project chat → type `/planning` → confirm List plan path → ensure `List plan/plan1/plan.md` is created.
  - Type `/developer` → ensure `task.md` appears in the same `plan1` folder.

- **VS Code / Cursor (Chat)**
  - Ensure the AI/Chat extension is active. Focus Chat input.
  - Use the provided keybindings or paste `/planning` and send.
  - Verify the response begins the planning lifecycle and prompts for `List plan/`.
  - Check your workspace for `List plan/plan1/plan.md` after the message completes.

- **JetBrains IDEs**
  - Record a Macro for `/planning` and bind a shortcut.
  - Trigger it in a project chat → verify `List plan/` is created and `plan.md` is written.

- **Zed**
  - Add keyboard shortcuts that insert `/planning` and `/developer`.
  - Trigger in chat → confirm `List plan/` and `plan.md` creation.

- **Sublime Text**
  - Add user key bindings to insert `/planning` and `/developer`.
  - Paste into your chat/input panel → verify artifact creation as above.

- **Emacs**
  - Use the provided keybindings to insert commands.
  - In your chat buffer, send `/planning` → verify `List plan/` appears in the project.

- **Neovim**
  - Use the Lua mappings to copy `/planning` or `/developer` to clipboard and paste into chat.
  - Confirm `List plan/` and `plan1/plan.md` are created.

## Troubleshooting

- If your AI CLI/editor doesn't recognize the skills, double-check that `~/.agents/skills` is set as the skills directory in your editor settings.
- If Gemini CLI doesn't show `/planning`, `/developer`, or `/debug`, confirm the files are in `~/.gemini/commands`, have the `.toml` extension, and then run `/commands reload`.
- If install fails, ensure Node.js and npm are installed and up to date.
- To fully remove, uninstall the CLI and manually delete `~/.agents/skills` plus the generated command files in `~/.gemini/commands`.

## Planning Lifecycle

Planning reads files progressively through phases (NOT all at once):

1. **PHASE_1_INIT**: Confirms `List plan/` folder location with user, reads index.md
2. **PHASE_2_ANALYSIS**: Reads plan.md sections, inspects existing pages/components
3. **PHASE_3_DEPENDENCY**: Reads dependency registers, inspects shared entities
4. **PHASE_4_WORKFLOW**: Derives workflow.md from plan.md
5. **PHASE_5_QUALITY**: Scans plan+workflow against quality lenses
6. **PHASE_6_VALIDATION**: Verifies all rules loaded, validates integration
7. **PHASE_7_FINALIZE**: Presents plan to user for approval before deployment

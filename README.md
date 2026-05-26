# skill-ai-mode

Minimal AI skill repo for supported AI editors.

## Active skills

- `/planning` -> `Planning mode/Planning.md`
- `/developer` -> `Developer mode/developer.md`

## Install

```powershell
irm https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.ps1 | iex
```

The installer will explain what it does first and ask:

```text
Do you want to install? (y/n)
```

Optional full repo clone:

```bash
git clone https://github.com/NiessenWaffer/skill-ai-mode.git
```

## Purpose

- planning -> plan + workflow
- developer -> task + implementation
- design -> clear mobile-first UI, simple tables/forms, visible actions
- planning overlap -> revise/connect related plans instead of isolating them

## Project setup

- Keep `List plan/` inside the project for plan artifacts.
- Do **not** add `Planning mode/`, `Developer mode/`, `.agents/`, or `gemini.md` inside every project.
- The CLI install places the existing `Planning mode/` and `Developer mode/` folders plus `gemini.md` in the global skills folder instead.
- After install, use `/planning` or `/developer` from the AI CLI/editor when it is pointed at the global skills folder.

## Notes

- The installer downloads the GitHub archive, then copies `gemini.md`, `Planning mode/`, and `Developer mode/` into `~/.agents/skills` by default.
- The global install copies the full `Planning mode/` and `Developer mode/` folders recursively, including nested `rules/` and `implementation rules/` files.
- The global install uses the existing rule folders as the source of truth.
- Configure your AI CLI/editor to read that global skills folder.
- Supported AI editors can install and recognize these skills.
- Not every AI editor supports external skills automatically.

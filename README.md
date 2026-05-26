# skill-ai-mode

Minimal AI skill repo for supported AI editors.

## Active skills

- `/planning` -> `.agents/skills/planning-mode/SKILL.md`
- `/developer` -> `.agents/skills/developer-mode/SKILL.md`

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

## Notes

- The installer copies the active skill files into `~/.agents/skills` by default.
- The active skills live at `~/.agents/skills/planning-mode/SKILL.md` and `~/.agents/skills/developer-mode/SKILL.md`.
- Configure your AI CLI/editor to read that global skills folder.
- Supported AI editors can install and recognize these skills.
- Not every AI editor supports external skills automatically.

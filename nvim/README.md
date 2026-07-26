# nvim-config-windows

A personal Neovim configuration for Windows, based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Built for academic and technical writing with LaTeX, vector figure editing, and general development.

---

## Features

- **Catppuccin** colorscheme (Frappe/Mocha)
- **VimTeX** for LaTeX editing and live compilation
- **Inkscape figure workflow** — draw figures and embed them in LaTeX without leaving Neovim (see [inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows))
- **Neo-tree** file explorer
- **Telescope** fuzzy finder
- **LuaSnip** snippets
- **nvim-cmp** autocompletion
- **Aerial** code outline
- **Flash** for fast navigation
- **Zen mode / Twilight** for distraction-free writing
- **Toggleterm** for integrated terminal
- **Orgmode** for note-taking

---

## Quick Install (Recommended)

The easiest way to get everything set up is to use the included installer script. It will automatically install any missing dependencies, clone both repos, patch your config, and set up your PowerShell profile — all in one go.

### Step 1 — Download the installer

Clone or download this repo anywhere on your machine. The installer lives at the root:

```
nvim-config-windows/
└── install.ps1      ← this is what you run
```

You can download just the installer directly with:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mezbah488-ops/nvim-config-windows/main/install.ps1" -OutFile "install.ps1"
```

### Step 2 — Open PowerShell as Administrator

Right-click the Start button → **Terminal (Admin)** or **Windows PowerShell (Admin)**.

> The installer needs Administrator privileges to install fonts and write to the Windows registry.

### Step 3 — Navigate to where you saved the installer

```powershell
cd C:\path\to\wherever\you\saved\it
```

For example, if you downloaded it to your Downloads folder:

```powershell
cd $env:USERPROFILE\Downloads
```

### Step 4 — Run the installer

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```

The first line temporarily allows the script to run in your current session only — it does not permanently change your system security settings.

### What the installer does

The installer is smart about what is already on your system. For each tool, it checks first and only installs if it is missing:

| Step | What happens |
|------|-------------|
| Check winget | Aborts with a clear message if winget is not available |
| Git | Installs via winget if not found, skips if already installed |
| Neovim | Installs via winget if not found, skips if already installed |
| Python 3 | Installs via winget if not found, skips if already installed |
| Inkscape | Installs via winget if not found, skips if already installed |
| MiKTeX | Installs via winget if not found, skips if already installed |
| watchdog | Installs via pip (required for the figure watcher) |
| Neovim config | Backs up any existing config, then clones this repo to `%LOCALAPPDATA%\nvim` |
| inkscape-figures-windows | Asks where you want it installed, then clones it there |
| Patch init.lua | Automatically updates `fig_path` to match where you installed inkscape-figures |
| Nerd Font | Downloads and installs JetBrainsMonoNL Nerd Font |
| PowerShell alias | Adds a `save` alias to your PowerShell profile for quick git commits |

### After the installer finishes

The installer will print a summary of next steps, but in short:

1. **Set the font in Windows Terminal** to `JetBrainsMonoNL Nerd Font`
2. **(Optional)** Add the Catppuccin Frappe color scheme to Windows Terminal — see the [Colorscheme](#colorscheme) section below
3. **Open Neovim** — plugins install automatically on first launch:
   ```powershell
   nvim
   ```
4. **Restart PowerShell** to activate the `save` alias
5. **In any LaTeX project folder**, initialize the figure workflow:
   ```powershell
   fig init
   fig start
   ```

---

## Manual Installation

If you prefer to set things up yourself, follow these steps.

### Prerequisites

| Tool | Purpose | Download |
|------|---------|----------|
| Neovim 0.9+ | Editor | https://neovim.io |
| Git | Plugin management | https://git-scm.com |
| Python 3 | Runs the figure watcher scripts | https://python.org |
| Inkscape 1.x | Vector drawing + PDF export | https://inkscape.org |
| MiKTeX or TeX Live | LaTeX compiler | https://miktex.org |
| A Nerd Font | Icons in the UI | https://www.nerdfonts.com |

Verify everything is on your PATH:

```powershell
nvim --version
git --version
python --version
inkscape --version
pdflatex --version
```

Install the Python dependency:

```powershell
pip install watchdog
```

### Clone this repo

Back up any existing Neovim config first:

```powershell
mv $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
```

Then clone:

```powershell
git clone https://github.com/mezbah488-ops/nvim-config-windows.git $env:LOCALAPPDATA\nvim
```

### Set up inkscape-figures-windows

Follow the full setup guide at:
👉 **[inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows)**

Then update the path in `init.lua` to match where you installed it:

```lua
local fig_path = "C:\\Users\\YourName\\inkscape-figures\\fig.bat"
```

### Open Neovim

```powershell
nvim
```

[lazy.nvim](https://github.com/folke/lazy.nvim) will install all plugins automatically on first launch. Wait for it to finish, then restart Neovim.

---

## Colorscheme

This config uses [Catppuccin](https://github.com/catppuccin/catppuccin) with:

- **Light mode** → Mocha
- **Dark mode** → Frappe

For the best experience, install the Catppuccin theme in **Windows Terminal** so the terminal background matches Neovim. Add this to the `"schemes"` array in your Windows Terminal `settings.json` (`Ctrl+,` → Open JSON file):

```json
{
    "name": "Catppuccin Frappe",
    "background": "#303446",
    "foreground": "#C6D0F5",
    "black": "#51576D",
    "red": "#E78284",
    "green": "#A6D189",
    "yellow": "#E5C890",
    "blue": "#8CAAEE",
    "purple": "#F4B8E4",
    "cyan": "#81C8BE",
    "white": "#B5BFE2",
    "brightBlack": "#626880",
    "brightRed": "#E78284",
    "brightGreen": "#A6D189",
    "brightYellow": "#E5C890",
    "brightBlue": "#8CAAEE",
    "brightPurple": "#F4B8E4",
    "brightCyan": "#81C8BE",
    "brightWhite": "#A5ADCE",
    "cursorColor": "#F2D5CF",
    "selectionBackground": "#626880"
}
```

Then set `"colorScheme": "Catppuccin Frappe"` in your PowerShell profile entry inside `"list"`.

---

## Structure

```
nvim/
├── install.ps1                     # Automated installer
├── init.lua                        # Entry point
└── lua/
    ├── custom/
    │   └── plugins/
    │       └── init.lua            # Personal plugin additions
    └── kickstart/
        └── plugins/
            ├── catppuccin.lua      # Colorscheme
            ├── nvim-cmp.lua        # Autocompletion
            ├── neo-tree.lua        # File explorer
            ├── toggleterm.lua      # Terminal
            ├── vimtex.lua          # LaTeX
            ├── zen-mode.lua        # Distraction-free writing
            └── ...                 # Other plugins
```

---

## Related

- [inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows) — Companion tool for Inkscape + LaTeX figure automation
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — The base config this is built on
- [Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal) — Terminal colorscheme to match

---

## License

MIT

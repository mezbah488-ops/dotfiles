# LaTeX Workflow Setup Guide
### Neovim + Inkscape + Zathura on Windows via WSL2

---

Initial remarks: I just thought to keep a little record of how I attempted to set this up, so that I don't have to redo this from scratch again. 

## Overview

This guide sets up a complete LaTeX workflow on Windows using:
- **WSL2** (Ubuntu) as the Linux environment
- **Neovim** as the editor
- **Inkscape** (Windows) for drawing figures
- **Zathura** as the PDF viewer with forward/inverse search
- **inkscape-figures** for automatic figure management

---

## Part 1: WSL2 Setup

### Install WSL2

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

Restart your PC when prompted. Ubuntu will open automatically and ask you to create a Linux username and password.

### Move WSL2 to Another Drive (Optional but Recommended)

If your C: drive is low on space, move WSL2 to D: drive after the initial install:

```powershell
wsl --shutdown
mkdir D:\WSL\Ubuntu
wsl --export Ubuntu "D:\WSL\ubuntu-backup.tar"
wsl --unregister Ubuntu
wsl --import Ubuntu "D:\WSL\Ubuntu" "D:\WSL\ubuntu-backup.tar"
del "D:\WSL\ubuntu-backup.tar"
```

### Take a Snapshot (Important!)

After everything is set up and working, always save a snapshot so you can restore if anything breaks:

```powershell
wsl --shutdown
wsl --export Ubuntu "D:\WSL\ubuntu-snapshot.tar"
```

To restore from snapshot:

```powershell
wsl --unregister Ubuntu
wsl --import Ubuntu "D:\WSL\Ubuntu" "D:\WSL\ubuntu-snapshot.tar"
```

---

## Part 2: Ubuntu Setup

Open your Ubuntu terminal and run these commands one by one.

### Update the System

```bash
sudo apt update && sudo apt upgrade -y
```

### Install Neovim

```bash
sudo snap install nvim --classic
```

### Install Required Tools

```bash
sudo apt install python3-pip fzf make git gcc g++ nodejs npm -y
sudo npm install -g tree-sitter-cli
```

### Install LaTeX

```bash
sudo apt install texlive-latex-extra texlive-fonts-extra latexmk -y
```

### Install PDF Viewer

```bash
sudo apt install zathura xdotool -y
```

### Install inkscape-figures

```bash
sudo apt install pipx -y
pipx install inkscape-figures
pipx ensurepath
source ~/.bashrc
mkdir -p ~/.config/inkscape-figures
```

### Configure inkscape-figures

Create `~/.config/inkscape-figures/config.py`:

```python
inkscape_executable = "/mnt/c/Program Files/Inkscape/bin/inkscape.exe"

def latex_template(name, title):
    return '\n'.join((
        r'\begin{figure}[ht]',
        r'    \centering',
        rf'    \incfig{{{name}}}',
        rf'    \caption{{{title}}}',
        rf'    \label{{fig:{name}}}',
        r'\end{figure}'
    ))
```

### Patch inkscape-figures for WSL2

**Patch 1: Replace rofi with fzf** in `~/.local/share/pipx/venvs/inkscape-figures/lib/python3.12/site-packages/inkscapefigures/picker.py`:

```python
import subprocess
import platform

SYSTEM_NAME = platform.system()

def get_picker_cmd(picker_args=None, fuzzy=True):
    args = ['fzf', '--prompt', 'Select Figure: ']
    if picker_args is not None:
        args += picker_args
    return [str(arg) for arg in args]

def pick(options, picker_args=None, fuzzy=True):
    optionstr = '\n'.join(option.replace('\n', ' ') for option in options)
    cmd = get_picker_cmd(picker_args=picker_args, fuzzy=fuzzy)
    result = subprocess.run(cmd, input=optionstr, stdout=subprocess.PIPE,
                            universal_newlines=True)
    returncode = result.returncode
    stdout = result.stdout.strip()
    selected = stdout.strip()
    try:
        index = [opt.strip() for opt in options].index(selected)
    except ValueError:
        index = -1
    if returncode == 0:
        key = 0
    elif returncode == 1:
        key = -1
    elif returncode > 9:
        key = returncode - 9
    return key, index, selected
```

**Patch 2: Add `start_new_session=True`** in `~/.local/share/pipx/venvs/inkscape-figures/lib/python3.12/site-packages/inkscapefigures/main.py`. Find the `inkscape()` function and change it to:

```python
def inkscape(path):
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", ResourceWarning)
        subprocess.Popen(['inkscape', str(path)], start_new_session=True)
```

### Create the Inkscape Wrapper Script

```bash
mkdir -p ~/bin
nano ~/bin/inkscape
```

Paste:

```bash
#!/bin/bash
"/mnt/c/Program Files/Inkscape/bin/inkscape.exe" "$@" &
disown
```

Then:

```bash
chmod +x ~/bin/inkscape
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Part 3: Neovim Configuration

### Clone Your Config

```bash
cp -r "/mnt/c/Users/YourUsername/path/to/nvim" ~/.config/nvim
```

Or clone from GitHub:

```bash
git clone https://github.com/yourusername/nvim-config ~/.config/nvim
```

### Fix init.lua

Make sure this line is commented out in `init.lua` (it's Windows-specific):

```lua
-- vim.fn.serverstart '\\\\.\\pipe\\nvim-latex'
```

And set:

```lua
vim.g.have_nerd_font = true
```

### VimTeX Configuration

Create `~/.config/nvim/lua/kickstart/plugins/vimtex.lua`:

```lua
return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = 'zathura'
  end,
}
```
Keeping only this minimal setup for vimtex will be enough for the inverse-search. 

### Treesitter Configuration

Create `~/.config/nvim/lua/kickstart/plugins/treesitter.lua`:

```lua
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({})
        local ensure_installed = {
            "bash", "c", "cpp", "css", "dockerfile", "go",
            "html", "javascript", "json", "lua", "latex",
            "markdown", "markdown_inline", "python", "rust",
            "svelte", "solidity", "typescript", "vue", "yaml",
        }
        local config = require("nvim-treesitter.config")
        local already_installed = config.get_installed()
        local parsers_to_install = {}
        for _, parser in ipairs(ensure_installed) do
            if not vim.tbl_contains(already_installed, parser) then
                table.insert(parsers_to_install, parser)
            end
        end
        if #parsers_to_install > 0 then
            treesitter.install(parsers_to_install)
        end
        local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(args)
                if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
                    vim.treesitter.start(args.buf)
                end
            end,
        })
    end,
}
```

### ftplugin for Inkscape Figures

Create `~/.config/nvim/ftplugin/tex.lua`:

```lua
local map = vim.keymap.set

-- Auto-start inkscape-figures watcher
vim.fn.jobstart('inkscape-figures watch', {
  detach = true,
  on_stderr = function() end,
})

-- Create new figure (type figure name on a line, press <leader>fi in normal mode)
map('n', '<leader>fi', function()
  local line = vim.api.nvim_get_current_line():match '^%s*(.-)%s*$'
  if line == '' then
    return
  end
  local root = vim.fn.expand '%:p:h'
  local output = vim.fn.system(string.format("inkscape-figures create '%s' '%s/figures/'", line, root))
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, vim.split(output, '\n', { trimempty = true }))
end, { buffer = true })

-- Edit existing figure (<leader>fe opens fuzzy picker in terminal split)
map('n', '<leader>fe', function()
  local root = vim.fn.expand '%:p:h'
  vim.cmd('split | terminal inkscape-figures edit \'' .. root .. '/figures/\'')
end, { buffer = true })
```

---

## Part 4: LaTeX Project Setup

### Required Preamble

Add this to every new LaTeX document:

```latex
\usepackage{import}
\usepackage{xifthen}
\usepackage{pdfpages}
\usepackage{transparent}
\newcommand{\incfig}[2][1]{%
    \def\svgwidth{#1\columnwidth}
    \import{./figures/}{#2.pdf_tex}
}
\pdfsuppresswarningpagegroup=1
```

The `\incfig` command accepts an optional width argument:
- `\incfig{my-figure}` — full column width (default)
- `\incfig[0.5]{my-figure}` — 50% of column width

### Project Directory Structure

```
my-project/
├── main.tex
└── figures/
    ├── my-figure.svg
    ├── my-figure.pdf
    └── my-figure.pdf_tex
```

Keep all projects inside `~/latex-files/` to avoid path issues with synctex.

---

## Part 5: Daily Workflow

### Figure Workflow

1. Open your `.tex` file in Neovim
2. Type a figure name on a blank line (e.g. `my-diagram`)
3. Press `<leader>fi` — Inkscape opens, `\incfig{}` snippet inserted automatically
4. Draw your figure in Inkscape
5. Press `Ctrl+S` to save — auto-compiled to `pdf`+`pdf_tex`
6. Figure appears in Zathura automatically

To edit an existing figure: press `<leader>fe`, select figure with arrow keys, press Enter.

To add LaTeX text in a figure: use Inkscape's text tool (`T`) and type LaTeX directly (e.g. `$\int_0^\infty e^{-x}dx$`). It renders properly in the final PDF.

### Vimtex Keybindings

| Key | Action |
|-----|--------|
| `\ll` | Start/stop continuous compilation |
| `\lv` | Forward search (jump to position in Zathura) |
| `Ctrl+Click` in Zathura | Inverse search (jump back to line in Neovim) |
| `\lk` | Stop compilation |
| `\le` | Open error list |

---

## Part 6: GitHub Backup

### Initial Setup

```bash
sudo apt install gh -y
gh auth login
```

Choose: GitHub.com → HTTPS → Login with a web browser.

### Create Repos

```bash
# For LaTeX files
cd ~/latex-files
git init
git add .
git commit -m "Initial commit"
gh repo create latex-files --private --source=. --remote=origin --push

# For Neovim config
cd ~/.config/nvim
git init
git add .
git commit -m "Initial commit"
gh repo create nvim-config --private --source=. --remote=origin --push
```

### Aliases for Quick Saving

```bash
echo 'alias save="git add . && git commit -m \"autosave\" && git push"' >> ~/.bashrc
echo 'alias savenvim="cd ~/.config/nvim && git add . && git commit -m \"autosave\" && git push && cd -"' >> ~/.bashrc
source ~/.bashrc
```

Use `save` from inside any project folder to back up to GitHub.

---

## Part 7: Nerd Fonts

1. Download **JetBrainsMono Nerd Font** from https://www.nerdfonts.com/font-downloads
2. Extract, select all `.ttf` files, right-click → Install for all users
3. In Windows Terminal settings → Ubuntu profile → Appearance → Font face → set to `JetBrainsMono Nerd Font`
4. In `init.lua` set `vim.g.have_nerd_font = true`

---

## Troubleshooting

### Inverse search not working
Make sure your project files are inside `~/latex-files/` (Linux filesystem), not on `/mnt/c/`. Delete any old compiled files (`*.pdf`, `*.synctex.gz`, `*.aux`) and recompile.

### Inkscape not opening
Check that `~/bin/inkscape` exists and is executable (`chmod +x ~/bin/inkscape`), and that `~/bin` is in your PATH (`echo $PATH`).

### WSL2 filesystem corruption
Restore from snapshot:
```powershell
wsl --unregister Ubuntu
wsl --import Ubuntu "D:\WSL\Ubuntu" "D:\WSL\ubuntu-snapshot.tar"
```

### inkscape-figures errors
Make sure both patches (picker.py and main.py) are applied correctly, and that the config.py has the `latex_template` function defined.

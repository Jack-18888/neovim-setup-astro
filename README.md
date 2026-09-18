# Neovim Configuration (AstroNvim)

> **Note:** This configuration is built and based on **[AstroNvim](https://github.com/AstroNvim/AstroNvim)** (v6+ template architecture).

---

## 📖 Overview

This repository contains a personal, fast, and feature-rich Neovim configuration built on top of the **AstroNvim** ecosystem. It leverages AstroNvim's modular architecture (`AstroCore`, `AstroUI`, `AstroLSP`, and `AstroCommunity`) powered by [`lazy.nvim`](https://github.com/folke/lazy.nvim).

### ✨ Key Features & Customizations

- **AstroNvim Foundation**: Extensible and well-structured configuration using the latest AstroNvim v6 specification.
- **Theme**: Styled with the [Catppuccin](https://github.com/catppuccin/nvim) colorscheme imported via `astrocommunity`.
- **PowerShell (`pwsh`) Integration**: Configured out of the box with proper UTF-8 encoding flags and execution policies, tailored for smooth development on Windows and cross-platform environments.
- **Enhanced Terminal Workflow (`toggleterm.nvim`)**:
  - Unified single-split window layout with interactive winbar tabs for each session.
  - Quick terminal creation and navigation (`<Leader>tc`, `<`, `>`, and `<Leader>tr`).
  - Split options for horizontal (`<Leader>th`) and vertical (`<Leader>tv`).
- **Git Integration (`diffview.nvim` & `gitsigns.nvim`)**:
  - Full side-by-side git diff viewing via `<Leader>gd` / `<Leader>gD`.
- **Language Server & Tool Management**:
  - Automated package management via [`mason.nvim`](https://github.com/williamboman/mason.nvim) and `mason-tool-installer`.
  - Includes `lua-language-server`, `stylua`, `debugpy`, and `tree-sitter-cli`.

---

## ⚡ Prerequisites

To get the full experience (syntax highlighting, live grep, code navigation, formatters, and icons), install the following tools on your system before launching Neovim.

### Core Requirements

| Tool | Purpose | Status |
| :--- | :--- | :--- |
| **[Neovim](https://neovim.io/)** (>= 0.9.5, recommended **0.10+**) | Core text editor | **Required** |
| **[Git](https://git-scm.com/)** (>= 2.19) | Plugin cloning and version control | **Required** |
| **[Nerd Font](https://www.nerdfonts.com/)** (v3.0+) | Icons and glyphs (e.g. *JetBrainsMono Nerd Font*) | **Required** |
| **[ripgrep (`rg`)](https://github.com/BurntSushi/ripgrep)** | Fast file contents search / live grep | **Required** |
| **[fd (`fd`)](https://github.com/sharkdp/fd)** | Fast file and directory searching | **Required** |
| **[tree-sitter-cli](https://github.com/tree-sitter/tree-sitter)** | Generating and compiling Tree-sitter parsers | **Required** |
| **C Compiler** (`gcc`, `clang`, `zig`, or MSVC `cl.exe`) | Compiling Tree-sitter parsers | **Required** |
| **[PowerShell 7+ (`pwsh`)](https://github.com/PowerShell/PowerShell)** | Shell configured for Windows terminals and commands | **Required (Windows)** |

### Language & Tooling Runtimes (for Mason & LSPs)

| Tool | Purpose | Status |
| :--- | :--- | :--- |
| **[Node.js](https://nodejs.org/) & `npm`** (LTS) | Required by Mason for many LSP servers and formatters | Recommended |
| **[Python 3](https://www.python.org/) & `pip`** | Debuggers (`debugpy`) and Python LSP support | Recommended |
| **[lazygit](https://github.com/jesseduffield/lazygit)** | Terminal UI for Git operations | Recommended |

---

## 📦 Installation of Prerequisites

### Windows

Using `winget`:

```powershell
# Core tools and search utilities
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
winget install Microsoft.PowerShell
winget install JesseDuffield.lazygit

# Language runtimes for Mason LSPs
winget install OpenJS.NodeJS.LTS
winget install Python.Python.3.12

# Nerd Font (example: JetBrains Mono Nerd Font)
winget install DEVCOM.JetBrainsMonoNerdFont
```

To install `tree-sitter-cli`:

```powershell
# Via npm (requires Node.js):
npm install -g tree-sitter-cli

# Or via cargo (requires Rust):
cargo install tree-sitter-cli

# Or via winget:
winget install Tree-sitter.Tree-sitter
```

> **Note for Windows C Compiler:** Ensure you have a C compiler installed for `nvim-treesitter` parsers (such as Visual Studio Build Tools with C++ workload, or `zig` / `gcc` via MinGW/Scoop/Chocolatey).

### macOS

Using [Homebrew](https://brew.sh/):

```bash
brew install neovim git ripgrep fd tree-sitter lazygit node python
brew install --cask font-jetbrains-mono-nerd-font
```

### Linux (Ubuntu / Debian)

```bash
sudo apt update
sudo apt install -y git ripgrep fd-find build-essential nodejs npm python3 python3-pip
# If tree-sitter is not in apt repositories, install via npm or cargo:
sudo npm install -g tree-sitter-cli
```

---

## 🛠️ Installation & Setup

### 1. Back up existing configuration (Optional but recommended)

**Windows (PowerShell):**

```powershell
Rename-Item $env:LOCALAPPDATA\nvim "$env:LOCALAPPDATA\nvim.bak" -ErrorAction SilentlyContinue
Rename-Item $env:LOCALAPPDATA\nvim-data "$env:LOCALAPPDATA\nvim-data.bak" -ErrorAction SilentlyContinue
```

**Linux / macOS (Bash/Zsh):**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. Clone the repository

**Windows (PowerShell):**

```powershell
git clone https://github.com/Jack-18888/neovim-setup-astro.git "$env:LOCALAPPDATA\nvim"
```

**Linux / macOS:**

```bash
git clone https://github.com/Jack-18888/neovim-setup-astro.git ~/.config/nvim
```

### 3. Start Neovim

```shell
nvim
```

On initial launch:
1. `lazy.nvim` will automatically bootstrap and install all configured plugins.
2. `mason.nvim` and `mason-tool-installer` will download configured language servers, linters, and formatters.
3. Tree-sitter parsers will compile in the background. Restart Neovim once the initial setup finishes.

---

## ⌨️ Custom Keybindings

In addition to standard AstroNvim mappings, this setup includes custom configurations:

### Terminal (`ToggleTerm`)

| Keybinding | Mode | Description |
| :--- | :--- | :--- |
| `<F7>` | Normal / Terminal | Toggle terminal window |
| `<Leader>th` | Normal | Open horizontal split terminal |
| `<Leader>tv` | Normal | Open vertical split terminal |
| `<Leader>tc` | Normal | Create a new terminal session in the current container |
| `<Leader>ts` | Normal | Select terminal from list |
| `<Leader>tr` | Normal | Rename current terminal session |
| `<Leader>ta` | Normal | Toggle all open terminals |
| `<` / `>` | Terminal Normal | Switch to previous / next terminal session |
| `+` | Terminal Normal | Create new terminal in same window |
| `<Esc><Esc>` | Terminal | Exit terminal mode to normal mode |

### Git & Diffview

| Keybinding | Mode | Description |
| :--- | :--- | :--- |
| `<Leader>gd` | Normal | Open Git Diffview |
| `<Leader>gD` | Normal | Close Git Diffview |

### Buffer Management

| Keybinding | Mode | Description |
| :--- | :--- | :--- |
| `<Tab>` | Normal | Navigate to next buffer |
| `<S-Tab>` | Normal | Navigate to previous buffer |
| `<Leader>bd` | Normal | Close buffer interactively from tabline |

---

## 📁 Configuration Structure

```text
├── init.lua              # Bootstrap lazy.nvim and load base configuration
├── lazy-lock.json        # Pinned lockfile for plugins
├── lua/
│   ├── lazy_setup.lua    # Lazy plugin manager setup & AstroNvim imports
│   ├── community.lua     # AstroCommunity imports (Catppuccin theme, language packs)
│   ├── polish.lua        # Arbitrary lua code executed at the end of setup
│   └── plugins/          # Plugin specifications & custom configurations
│       ├── astrocore.lua   # Core options (pwsh shell, keymaps, diagnostics)
│       ├── astrolsp.lua    # LSP settings & auto-formatting rules
│       ├── astroui.lua     # UI & statusline configurations
│       ├── diffview.lua    # Diffview git integration
│       ├── mason.lua       # Mason tool installer specification
│       ├── toggleterm.lua  # Advanced multi-terminal container setup
│       └── treesitter.lua  # Tree-sitter parser configurations
```

---

## 🔗 References & Documentation

- [AstroNvim Documentation](https://docs.astronvim.com/)
- [AstroCommunity Repository](https://github.com/AstroNvim/astrocommunity)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [ToggleTerm Documentation](https://github.com/akinsho/toggleterm.nvim)
- [Diffview Documentation](https://github.com/sindrets/diffview.nvim)

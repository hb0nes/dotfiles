
# Dotfiles

## Nvim
This nvim configuration is done with Lua, using Lazy for plugins.
init.lua doesn't do much other than tell Lazy where to find plugins.
The plugins dir contains plenty of example on how to add your own plugin.
init.lua also pulls in some options and keybinds, check those files to see if you agree with those.
For example, leader is bound to `<Space>`.

### LSP
Configured LSP servers require the appropriate local installation, which differs per server.
For example, to enable proper support for Rust, you need to have a rust-analyzer installed.
Check these docs:

https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

#### Diagnostics
LSP also provides proper diagnostics.
The keybindings for these can be found in plugins/lua.lsp.
An example would be `<leader>=` and `<leader>-` to go to the next and previous diagnostic.

#### Tips
- To get docs through the LSP, press K (`<S-k>`) on a symbol.
- gd is used to go to a symbol definition.
- To easily navigate back afterwards, use `<C-o>` and `<C-i>` to go back and forwards in the jumplist respectively.

_FzfLua works together well with LSP and there are keybindings set up in fzf-lua.lua._

### CMP
nvim-cmp is used for completion.
It can be tuned through cmp.lua and it works together with lsp to set up proper completion.
Usually you don't have to worry about it too much, but if you find it too obtrusive or distracting you can
for example not show the float until you ask for it.
Docs are here: https://github.com/hrsh7th/nvim-cmp

_Docs while LSP/CMP-ing can usually be scrolled through with ctrl+d and ctrl+u._

### Outline
Press `<leader>o` to open an outline window with an overview of all the functions and symbols.
Useful for quick navigation with hkjl.
If you want to switch to the tree, you can `<C-w>` twice or use `<C-M-l>` and `<C-M-h>` to navigate left and right between nvim windows.
Another way is to close and open outline by doing `<leader>o` multiple times.
For more info about Outline functionality check out outline.lua or go to the GitHub page.

### Formatting
*Conform* is used for better formatting. Depending on how you set it up, you might have to install formatters.
e.g.: Lua can be formatted using Stylua which needs to be available.
Conform by default formats on save but can be triggered manually by the keybind: `<leader>f`

### FzfLua
FzfLua has a bunch of useful things you can do, which can easily be viewed by typing :FzfLua and looking at completion.

fzf-lua.lua contains the current keybindings for it, for which (imo) the most useful are:
- `<leader>r`  - go to references
- `<leader>s`  - search files
- `<leader>g`  - grep through files
- `<leader>ld` - list diagnostics
- `<leader>ls` - list symbols
- `<leader>b`  - list buffers

### Copilot
Copilot config can be found in plugins/copilot.lua.
By default `<C-space>` is used to accept suggestions and suggestions are given automatically while typing.
If the suggestion text jumping around all the time is too confusing, disable that feature.

Check out the file for other keybinds and settings.

### CopilotChat

If you freshly cloned this repo and replaced your ~/.config/nvim/ directory, chances are your CopilotChat won't work.
Follow the latest instructions here: https://github.com/jellydn/CopilotChat.nvim/tree/canary
At this time, CopilotChat requires you to install these globally (yuck...):
```
pip3 install python-dotenv requests pynvim==0.5.0 prompt-toolkit
```

Once Lazy has pulled in the dependencies for CopilotChat, you can run `:UpdateRemotePlugins` and reload nvim.
After that, CopilotChat should be available.
I strongly prefer to have the InPlaceChat.
Use visual line mode or the `<Cr>` key to select a bunch of text and then run `<leader>ccx`.
Then, type your question in the box, type `jk` in quick succession (or press `<Esc>` like a pleb) and press `<Cr>`.

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'vimtex#fold#level(v:lnum)'
vim.opt_local.foldtext = 'vimtex#fold#text()'
vim.opt_local.foldlevel = 1
vim.opt_local.foldenable = false -- since your global default turns folding OFF

vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- wrap at word boundaries, not mid-word
vim.opt_local.textwidth = 0 -- don't hard-wrap with inserted newlines
vim.opt_local.breakindent = true -- wrapped lines keep the indent of the original

-- Navigate by visual line instead of logical line, since lines are long/wrapped
vim.keymap.set('n', 'j', 'gj', { buffer = true })
vim.keymap.set('n', 'k', 'gk', { buffer = true })

vim.opt.fileencoding = 'utf-8'
vim.opt.bomb = false

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function(args)
    vim.keymap.set('n', 'gx', function()
      local line = vim.api.nvim_get_current_line()
      local url = line:match '\\href%s*{(.-)}' or line:match '\\url%s*{(.-)}'
      if url then
        vim.ui.open(url)
      else
        -- fall back to netrw's own logic for non-href lines
        vim.fn['netrw#BrowseX'](vim.fn['netrw#GX'](), vim.fn['netrw#CheckIfRemote']())
      end
    end, { buffer = args.buf, desc = 'Open URL under cursor (tex-aware)' })
  end,
})
-- --spell check
-- vim.opt_local.spell = true
-- vim.opt_local.spelllang = 'en_us'
--
--conceallevel
vim.opt_local.conceallevel = 2
--vim.opt_local.concealcursor = 'nc' -- conceal even when cursor is on the line, in normal/command mode
--
-- after/ftplugin/tex.lua
-- ... your existing folding/indent settings above ...
local function luasnip_picker()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local previewers = require 'telescope.previewers'
  local ls = require 'luasnip'
  local ft = vim.bo.filetype

  local snippets = ls.get_snippets(ft, { type = 'snippets' }) or {}
  local autosnippets = ls.get_snippets(ft, { type = 'autosnippets' }) or {}

  local entries = {}
  for _, list in ipairs { snippets, autosnippets } do
    for _, snip in ipairs(list) do
      table.insert(entries, snip)
    end
  end

  pickers
    .new({}, {
      prompt_title = 'LuaSnip Triggers (' .. ft .. ')',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(snip)
          local trig = snip.trigger or '?'
          local name = snip.name or trig
          return {
            value = snip,
            display = string.format('%-25s %s', trig, name),
            ordinal = trig .. ' ' .. name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = previewers.new_buffer_previewer {
        title = 'Expansion Preview',
        define_preview = function(self, entry)
          local snip = entry.value
          local ok, docstring = pcall(function()
            return snip:get_docstring()
          end)

          local lines
          if ok and docstring then
            if type(docstring) == 'string' then
              lines = vim.split(docstring, '\n')
            elseif type(docstring) == 'table' then
              lines = docstring
            end
          end

          if not lines or #lines == 0 then
            lines = { 'No static preview available (depends on regex captures / dynamic input).' }
          end

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = 'tex'
        end,
      },
    })
    :find()
end

vim.keymap.set('n', '<leader>cs', luasnip_picker, { buffer = true, desc = 'List LuaSnip triggers' })

-- Setting up latex pdf viewer:

-- Resolve the root .tex file for a project:
-- 1. magic comment `% !TEX root = ...` in the first 20 lines
-- 2. main.tex in the cwd
-- 3. fall back to the current buffer (single-file case)
local function find_root_file()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
  for _, line in ipairs(lines) do
    local root = line:match '^%%%s*!TEX%s+root%s*=%s*(.+)%s*$'
    if root then
      root = root:gsub('%s+$', '')
      if root:match '^/' then
        return root
      end
      return vim.fn.expand '%:p:h' .. '/' .. root
    end
  end

  local cwd_main = vim.fn.getcwd() .. '/main.tex'
  if vim.fn.filereadable(cwd_main) == 1 then
    return cwd_main
  end

  return vim.fn.expand '%:p'
end

-- Manual forward search (root-aware) via Zathura's synctex flag
vim.keymap.set('n', '<leader>fs', function()
  if vim.fn.executable 'zathura' == 0 then
    vim.notify('zathura not found on PATH', vim.log.levels.ERROR)
    return
  end

  local root_tex = find_root_file()
  local root_pdf = root_tex:gsub('%.tex$', '.pdf')
  local current_file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'

  vim.system {
    'zathura',
    '--synctex-forward',
    string.format('%d:1:%s', line, current_file),
    root_pdf,
  }
end, { buffer = true, desc = 'Forward search to PDF' })

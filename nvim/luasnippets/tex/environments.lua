--[[
================================================================================
LaTeX Environment/Structure Snippets (LuaSnip)
================================================================================
Block-level LaTeX structures (\begin{}...\end{} environments, display-math,
lists, figures), as opposed to the inline math-symbol snippet file. Most
gated by `line_begin` (line-start only, since these are structural units).

GENERIC ENVIRONMENTS
  new   -> \begin{}...\end{}          (name mirrored via rep(1), body visual-aware)
  n2    -> \begin{}{}...\end{}        (+1 arg, name mirrored, body visual-aware)
  n3    -> \begin{}{}{}...\end{}      (+2 args, name mirrored, body visual-aware)
  nt    -> \begin{topic}{}{}...\end{topic}  (custom tcbtheorem env, fixed name)

MATH DISPLAY
  nn    -> equation* (unnumbered), single tabstop
  eq    -> equation (numbered), single tabstop
  ss    -> equation*/split (unnumbered), visual-aware body
  all   -> align* (unnumbered), single tabstop

LISTS
  itt   -> itemize, \item, final tabstop  (line_begin)
  enn   -> enumerate, \item, final tabstop  (NOTE: no line_begin, unlike itt)

INLINE MATH
  mm    -> $...$  (after non-lowercase char, visual-aware)
  ^mm   -> $...$  (line-start variant, no capture needed)

FIGURES
  fig   -> full figure block, 4 tabstops (width, path, caption, label)
           manual trigger, not autosnippet (avoids misfiring on "fig" substring)

NOTE: rep(1) mirrors the environment name into \end{} without a second
editable field, so it's typed only once.
================================================================================
--]]

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local rep = require('luasnip.extras').rep
local fmta = require('luasnip.extras.fmt').fmta
local line_begin = require('luasnip.extras.expand_conditions').line_begin
local helpers = dofile(vim.fn.stdpath 'config' .. '/luasnippets/luasnip-helper-funcs.lua')
local get_visual = helpers.get_visual

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local line_begin = require('luasnip.extras.expand_conditions').line_begin

-- Return snippet tables
return {
  -- GENERIC ENVIRONMENT
  s(
    { trig = 'new', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH ONE EXTRA ARGUMENT
  s(
    { trig = 'n2', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ENVIRONMENT WITH TWO EXTRA ARGUMENTS
  s(
    { trig = 'n3', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  -- TOPIC ENVIRONMENT (my custom tcbtheorem environment)
  s(
    { trig = 'nt', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{topic}{<>}{<>}
            <>
        \end{topic}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- EQUATION
  s(
    { trig = 'nn', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- NUMBERED EQUATION
  s(
    { trig = 'eq', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation}
            <>
        \end{equation}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- SPLIT EQUATION
  s(
    { trig = 'ss', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{equation*}
            \begin{split}
                <>
            \end{split}
        \end{equation*}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),
  -- ALIGN
  s(
    { trig = 'all', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),
  -- ITEMIZE
  s(
    { trig = 'itt', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{itemize}

            \item <>

        \end{itemize}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),
  -- ENUMERATE
  s(
    { trig = 'enn', snippetType = 'autosnippet' },
    fmta(
      [[
        \begin{enumerate}

            \item <>

        \end{enumerate}
      ]],
      {
        i(0),
      }
    )
  ),
  -- INLINE MATH
  s(
    { trig = '([^%l])mm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>$<>$', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- INLINE MATH ON NEW LINE
  s(
    { trig = '^mm', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('$<>$', {
      i(1),
    })
  ),
  -- FIGURE
  s(
    { trig = 'fig' },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    { condition = line_begin }
  ),
}

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta
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

-- Return snippet tables
return {
  -- LEFT/RIGHT PARENTHESES
  s(
    { trig = '([^%a])l%(', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\left(<>\\right)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- LEFT/RIGHT SQUARE BRACES
  s(
    { trig = '([^%a])l%[', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\left[<>\\right]', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- LEFT/RIGHT CURLY BRACES
  s(
    { trig = '([^%a])l%{', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\left\\{<>\\right\\}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- BIG PARENTHESES
  s(
    { trig = '([^%a])b%(', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\big(<>\\big)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- BIG SQUARE BRACES
  s(
    { trig = '([^%a])b%[', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\big[<>\\big]', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- BIG CURLY BRACES
  s(
    { trig = '([^%a])b%{', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\big\\{<>\\big\\}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- ESCAPED CURLY BRACES
  s(
    { trig = '([^%a])\\%{', regTrig = true, wordTrig = false, snippetType = 'autosnippet', priority = 2000 },
    fmta('<>\\{<>\\}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  -- LATEX QUOTATION MARK
  s(
    { trig = '``', snippetType = 'autosnippet' },
    fmta("``<>''", {
      d(1, get_visual),
    })
  ),
}

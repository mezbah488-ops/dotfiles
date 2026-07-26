--[[
================================================================================
LaTeX Math Snippets (LuaSnip) — Summary
================================================================================
All snippets below are regex- or word-triggered autosnippets, most gated by
`tex.in_mathzone` (only expand inside math mode; a few, like ||, ::, >>, are
mode-agnostic). Regex-triggered ones capture and re-insert any preceding
non-alphabetic/non-word character (via `snip.captures[1]`) so the trigger can
fire immediately after operators, brackets, or spaces without eating them.
Nodes marked `d(1, get_visual)` will wrap a visual selection if one is active
when the snippet fires, otherwise drop an empty editable insert node.

--------------------------------------------------------------------------------
SCRIPTS (super/subscript)
--------------------------------------------------------------------------------
  '            after alnum/)/]/}      ->  ^{}          (superscript, visual-aware)
  ;            after alnum/)/]/}      ->  _{}          (subscript, visual-aware)
  __           after alnum/)/]/}      ->  ^{}_{}       (super+subscript)
  sd                                  ->  _{\mathrm{}} (text/roman subscript, visual-aware)
  "X           after alnum/)/]/}      ->  ^{X}         (single-char superscript shortcut)
  :X           after alnum/)/]/}      ->  _{X}         (single-char subscript shortcut)
  ee           after non-letter       ->  e^{}         (Euler's number, visual-aware)
  00           after letter/)/]/}     ->  _{0}         (zero subscript shortcut)
  11           after letter/)/]/}     ->  _{-1}        (minus-one subscript shortcut)
  JJ           after letter/)/]/}     ->  _{j}         (j subscript; avoids "jk" jump-forward key)
  ++           after letter/)/]/}     ->  ^{+}         (plus superscript shortcut)
  CC           after letter/)/]/}     ->  ^{\complement} (complement superscript)
  **           after letter/)/]/}     ->  ^{*}         (conjugate/star superscript)

--------------------------------------------------------------------------------
VECTORS & MATRICES
--------------------------------------------------------------------------------
  vv           after non-letter       ->  \vec{}                (visual-aware)
  ue           after non-letter       ->  \unitvector_{}        (visual-aware)
  uv           after non-letter       ->  \uvec{}               (visual-aware)
  mt           after non-letter       ->  \mat{}                (visual-aware)

--------------------------------------------------------------------------------
FRACTIONS, ROOTS, MISC WRAPPERS
--------------------------------------------------------------------------------
  ff           after non-letter       ->  \frac{}{}     (numerator visual-aware, tab to denom)
  gg           after non-letter       ->  \ang{}         (angle, visual-aware)
  aa           after non-letter       ->  \abs{}         (absolute value, visual-aware)
  sq           after non-backslash    ->  \sqrt{}        (square root, visual-aware)
  bnn          after non-backslash    ->  \binom{}{}
  ll           after non-letter/bksl  ->  \log_{}        (log with base subscript)
  bb           after non-letter       ->  \boxed{}       (visual-aware)

--------------------------------------------------------------------------------
DERIVATIVES (plain \frac form, no custom macros required)
--------------------------------------------------------------------------------
  dV           after non-letter       ->  \frac{d}{d}                    (visual-aware, denom only)
  dvv          after non-letter       ->  \frac{d}{d}                    (numerator + denominator var)
  ddv          after non-letter       ->  \frac{d^{n}}{d^{n}}            (nth-order; n auto-mirrored via rep())
  pV           after non-letter       ->  \frac{\partial}{\partial }     (visual-aware, denom only)
  pvv          after non-letter       ->  \frac{\partial }{\partial }    (numerator + denominator var)
  ppv          after non-letter       ->  \frac{\partial^{n}}{\partial ^{n}} (nth-order; n auto-mirrored via rep())

  Tab order for ddv/ppv: order n (tabstop 1) -> numerator var (tabstop 2)
  -> denominator var (tabstop 3); n is retyped only once and mirrors into
  both the numerator and denominator exponent via rep(3).

--------------------------------------------------------------------------------
SUMS & INTEGRALS
--------------------------------------------------------------------------------
  sM           after non-letter       ->  \sum_{}
  smm          after non-letter       ->  \sum_{}^{}
  intt         after non-letter       ->  \int_{}^{}
  intf         after non-letter       ->  \int_{\infty}^{\infty}  (fixed, no tabstops)

--------------------------------------------------------------------------------
STATIC / WORD-TRIGGERED SYMBOLS (no capture group, plain word triggers)
--------------------------------------------------------------------------------
  df                                  ->  \diff           (priority 2000, math zone only)
  in1 / in2 / in3                     ->  \int / \iint / \iiint  (math zone only)
  oi1 / oi2                           ->  \oint / \oiint  (math zone only)
  gdd                                 ->  \grad           (math zone only)
  cll                                 ->  \curl           (math zone only)
  DI                                  ->  \div            (math zone only)
  laa                                 ->  \laplacian      (math zone only)
  ||                                  ->  \parallel       (any mode)
  cdd                                 ->  \cdots          (any mode)
  ldd                                 ->  \ldots          (any mode)
  eqq                                 ->  \equiv          (any mode)
  stm                                 ->  \setminus       (any mode)
  sbb                                 ->  \subset         (any mode)
  px                                  ->  \approx         (math zone only)
  pt                                  ->  \propto         (math zone only)
  ::                                  ->  \colon          (any mode)
  >>                                  ->  \implies        (any mode)
  ,.                                  ->  \cdot           (any mode)
  xx                                  ->  \times          (any mode)

================================================================================
NOTE: `rep(3)` (from luasnip.extras) mirrors the live value of insert node 3
without creating a second editable field — used to keep the derivative order
`n` in sync between numerator and denominator in ddv/ppv.
================================================================================
--]]

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

local helpers = dofile(vim.fn.stdpath 'config' .. '/luasnippets/luasnip-helper-funcs.lua')
local get_visual = helpers.get_visual
local rep = require('luasnip.extras').rep

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
  -- SUPERSCRIPT
  s(
    { trig = "([%w%)%]%}])'", wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT
  s(
    { trig = '([%w%)%]%}]);', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s(
    { trig = '([%w%)%]%}])__', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>^{<>}_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- TEXT SUBSCRIPT
  s({ trig = 'sd', snippetType = 'autosnippet', wordTrig = false }, fmta('_{\\mathrm{<>}}', { d(1, get_visual) }), { condition = tex.in_mathzone }),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  s(
    { trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  s(
    { trig = '([%w%)%]%}]):([%w])', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- EULER'S NUMBER SUPERSCRIPT SHORTCUT
  s(
    { trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>e^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ZERO SUBSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])00', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '0',
    }),
    { condition = tex.in_mathzone }
  ),
  -- MINUS ONE SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])11', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '-1',
    }),
    { condition = tex.in_mathzone }
  ),
  -- J SUBSCRIPT SHORTCUT (since jk triggers snippet jump forward)
  s(
    { trig = '([%a%)%]%}])JJ', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t 'j',
    }),
    { condition = tex.in_mathzone }
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '+',
    }),
    { condition = tex.in_mathzone }
  ),
  -- COMPLEMENT SUPERSCRIPT
  s(
    { trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '\\complement',
    }),
    { condition = tex.in_mathzone }
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
  s(
    { trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t '*',
    }),
    { condition = tex.in_mathzone }
  ),
  -- VECTOR, i.e. \vec
  s(
    { trig = '([^%a])vv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\vec{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DEFAULT UNIT VECTOR WITH SUBSCRIPT, i.e. \unitvector_{}
  s(
    { trig = '([^%a])ue', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\unitvector_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- UNIT VECTOR WITH HAT, i.e. \uvec{}
  s(
    { trig = '([^%a])uv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\uvec{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- MATRIX, i.e. \vec
  s(
    { trig = '([^%a])mt', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\mat{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- FRACTION
  s(
    { trig = '([^%a])ff', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{<>}{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ANGLE
  s(
    { trig = '([^%a])gg', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\ang{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE
  s(
    { trig = '([^%a])aa', regTrig = true, wordTrig = false, snippetType = 'autosnippet' },
    fmta('<>\\abs{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SQUARE ROOT
  s(
    { trig = '([^%\\])sq', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sqrt{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BINOMIAL SYMBOL
  s(
    { trig = '([^%\\])bnn', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\binom{<>}{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- LOGARITHM WITH BASE SUBSCRIPT
  s(
    { trig = '([^%a%\\])ll', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\log_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),

  -- DERIVATIVE with denominator only: d/dx
  s(
    { trig = '([^%a])dV', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{d}{d<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator and denominator: df/dx
  s(
    { trig = '([^%a])dvv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{d<>}{d<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- DERIVATIVE with numerator, denominator, and order: d^n f / dx^n
  s(
    { trig = '([^%a])ddv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{d^{<>}<>}{d<>^{<>}}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(3),
      i(1),
      i(2),
      rep(3),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with denominator only: ∂/∂x
  s(
    { trig = '([^%a])pV', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{\\partial}{\\partial <>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with numerator and denominator: ∂f/∂x
  s(
    { trig = '([^%a])pvv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{\\partial <>}{\\partial <>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- PARTIAL DERIVATIVE with numerator, denominator, and order: ∂^n f / ∂x^n
  s(
    { trig = '([^%a])ppv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\frac{\\partial^{<>}<>}{\\partial <>^{<>}}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(3),
      i(1),
      i(2),
      rep(3),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with lower limit
  s(
    { trig = '([^%a])sM', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),
  -- SUM with upper and lower limit
  s(
    { trig = '([^%a])smm', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\sum_{<>}^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL with upper and lower limit
  s(
    { trig = '([^%a])intt', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{<>}^{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),
  -- INTEGRAL from positive to negative infinity
  s(
    { trig = '([^%a])intf', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\int_{-\\infty}^{\\infty}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BOXED command
  s(
    { trig = '([^%a])bb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\boxed{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  --
  -- BEGIN STATIC SNIPPETS
  --

  -- DIFFERENTIAL, i.e. \diff
  s({ trig = 'df', snippetType = 'autosnippet', priority = 2000, snippetType = 'autosnippet' }, {
    t '\\diff',
  }, { condition = tex.in_mathzone }),
  -- BASIC INTEGRAL SYMBOL, i.e. \int
  s({ trig = 'in1', snippetType = 'autosnippet' }, {
    t '\\int',
  }, { condition = tex.in_mathzone }),
  -- DOUBLE INTEGRAL, i.e. \iint
  s({ trig = 'in2', snippetType = 'autosnippet' }, {
    t '\\iint',
  }, { condition = tex.in_mathzone }),
  -- TRIPLE INTEGRAL, i.e. \iiint
  s({ trig = 'in3', snippetType = 'autosnippet' }, {
    t '\\iiint',
  }, { condition = tex.in_mathzone }),
  -- CLOSED SINGLE INTEGRAL, i.e. \oint
  s({ trig = 'oi1', snippetType = 'autosnippet' }, {
    t '\\oint',
  }, { condition = tex.in_mathzone }),
  -- CLOSED DOUBLE INTEGRAL, i.e. \oiint
  s({ trig = 'oi2', snippetType = 'autosnippet' }, {
    t '\\oiint',
  }, { condition = tex.in_mathzone }),
  -- GRADIENT OPERATOR, i.e. \grad
  s({ trig = 'gdd', snippetType = 'autosnippet' }, {
    t '\\grad ',
  }, { condition = tex.in_mathzone }),
  -- CURL OPERATOR, i.e. \curl
  s({ trig = 'cll', snippetType = 'autosnippet' }, {
    t '\\curl ',
  }, { condition = tex.in_mathzone }),
  -- DIVERGENCE OPERATOR, i.e. \divergence
  s({ trig = 'DI', snippetType = 'autosnippet' }, {
    t '\\div ',
  }, { condition = tex.in_mathzone }),
  -- LAPLACIAN OPERATOR, i.e. \laplacian
  s({ trig = 'laa', snippetType = 'autosnippet' }, {
    t '\\laplacian ',
  }, { condition = tex.in_mathzone }),
  -- PARALLEL SYMBOL, i.e. \parallel
  s({ trig = '||', snippetType = 'autosnippet' }, {
    t '\\parallel',
  }),
  -- CDOTS, i.e. \cdots
  s({ trig = 'cdd', snippetType = 'autosnippet' }, {
    t '\\cdots',
  }),
  -- LDOTS, i.e. \ldots
  s({ trig = 'ldd', snippetType = 'autosnippet' }, {
    t '\\ldots',
  }),
  -- EQUIV, i.e. \equiv
  s({ trig = 'eqq', snippetType = 'autosnippet' }, {
    t '\\equiv ',
  }),
  -- SETMINUS, i.e. \setminus
  s({ trig = 'stm', snippetType = 'autosnippet' }, {
    t '\\setminus ',
  }),
  -- SUBSET, i.e. \subset
  s({ trig = 'sbb', snippetType = 'autosnippet' }, {
    t '\\subset ',
  }),
  -- APPROX, i.e. \approx
  s({ trig = 'px', snippetType = 'autosnippet' }, {
    t '\\approx ',
  }, { condition = tex.in_mathzone }),
  -- PROPTO, i.e. \propto
  s({ trig = 'pt', snippetType = 'autosnippet' }, {
    t '\\propto ',
  }, { condition = tex.in_mathzone }),
  -- COLON, i.e. \colon
  s({ trig = '::', snippetType = 'autosnippet' }, {
    t '\\colon ',
  }),
  -- IMPLIES, i.e. \implies
  s({ trig = '>>', snippetType = 'autosnippet' }, {
    t '\\implies ',
  }),
  -- DOT PRODUCT, i.e. \cdot
  s({ trig = ',.', snippetType = 'autosnippet' }, {
    t '\\cdot ',
  }),
  -- CROSS PRODUCT, i.e. \times
  s({ trig = 'xx', snippetType = 'autosnippet' }, {
    t '\\times ',
  }),
  -- LEFT-RIGHT DELIMITER PAIRS
  -- \left( \right)  -- FIRST BRACKET
  s(
    { trig = '([^%a])fb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left(<>\\right)', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- \left\{ \right\}  -- SECOND BRACKET
  s(
    { trig = '([^%a])sb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left\\{<>\\right\\}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- \left[ \right]  -- THIRD BRACKET
  s(
    { trig = '([^%a])tb', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left[<>\\right]', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ABSOLUTE VALUE / NORM BARS
  s(
    { trig = '([^%a])lv', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left|<>\\right|', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- ANGLE BRACKETS
  s(
    { trig = '([^%a])la', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\left\\langle<>\\right\\rangle', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- OVERLINE (bar notation)
  s(
    { trig = '([^%a])ov', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\overline{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- UNDERLINE
  s(
    { trig = '([^%a])un', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\underline{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- HAT ACCENT
  s(
    { trig = '([^%a])ha', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\hat{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- TILDE ACCENT
  s(
    { trig = '([^%a])td', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\tilde{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- BOLD (mathbf)
  s(
    { trig = '([^%a])bf', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\mathbf{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- TEXT WITHIN MATH
  s(
    { trig = '([^%a])tx', wordTrig = false, regTrig = true, snippetType = 'autosnippet' },
    fmta('<>\\text{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
}

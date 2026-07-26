local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local rep = require('luasnip.extras').rep
local fmta = require('luasnip.extras.fmt').fmta
local helpers = dofile(vim.fn.stdpath 'config' .. '/luasnippets/luasnip-helper-funcs.lua')
local get_visual = helpers.get_visual

local tex = {}
tex.in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

return {
  -- DOCUMENT / ENVIRONMENT EXTRAS
  s({ trig = 'mdframe', snippetType = 'autosnippet' }, fmta('\\begin{mdframed}\n\t<>\n\\end{mdframed}', { i(1) })),
  s(
    { trig = 'incfig_center', snippetType = 'autosnippet' },
    fmta('\\begin{center}\n\t$$\\vcenter{\\hbox{\\scriptsize \\incfig[0.5]{<>}}}$$\n\\end{center}<>', { i(1), i(0) })
  ),
  s({ trig = 'incfig;', snippetType = 'autosnippet' }, fmta('$\\vcenter{\\hbox{\\scriptsize \\incfig[0.5]{<>}}}$', { i(1) })),
  s(
    { trig = 'fig;', snippetType = 'autosnippet' },
    fmta('\\begin{figure}[ht]\n\t\\centering\n\t\\incfig[<>]{<>}\n\t\\caption{<>}\n\\end{figure}', { i(1), i(2), i(3) })
  ),
  s({ trig = 'ex;', snippetType = 'autosnippet' }, fmta('\\begin{exercise}{<>}{<>}\n\t<>\n\\end{exercise}', { i(1), i(2), i(3) })),
  s({ trig = 'exref', snippetType = 'autosnippet' }, fmta('\\ref{ex:<>}', { i(1) })),
  s({ trig = 'ref;', snippetType = 'autosnippet' }, fmta('\\ref{<>}', { i(1) })),
  s({ trig = 'mat2', snippetType = 'autosnippet' }, fmta('\\begin{pmatrix}\n<> & <> \\\\\n<> & <>\n\\end{pmatrix}', { i(1), i(2), i(3), i(4) })),
  s({ trig = 'mt', snippetType = 'autosnippet' }, fmta('\\begin{<>matrix}\n\t<>\n\\end{<>matrix}', { i(1), i(2), rep(1) })),
  s({ trig = 'quad', snippetType = 'autosnippet' }, t '\\quad'),
  s({ trig = 'thm', snippetType = 'autosnippet' }, fmta('\\begin{theorem}[<>]\n\t<>\n\\end{theorem}', { i(1), i(2) })),
  s({ trig = 'bnabla', snippetType = 'autosnippet' }, t '\\boldsymbol{\\nabla}', { condition = tex.in_mathzone }),
  s(
    { trig = 'us2', snippetType = 'autosnippet' },
    fmta('\\underset{\\substack{\\scriptstyle <>\\\\ \\scriptstyle <>}}{<>}', { i(1), i(2), i(3) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'us1', snippetType = 'autosnippet' }, fmta('\\underset{\\scriptstyle <>}{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'overset', snippetType = 'autosnippet' }, fmta('\\overset{<>}{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'undset', snippetType = 'autosnippet' }, fmta('\\underset{<>}{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),

  -- BRA-KET / PRODUCTS / ARROWS
  s({ trig = 'expt', snippetType = 'autosnippet' }, fmta('\\langle <> \\rangle', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ipc', snippetType = 'autosnippet' }, fmta('\\langle <> , <> \\rangle', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'oprod', snippetType = 'autosnippet' }, fmta('| <> \\rangle \\langle <> |', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'Rarr', snippetType = 'autosnippet' }, t '\\Rightarrow', { condition = tex.in_mathzone }),
  --
  -- TEXT FORMATTING:
  s({ trig = 'italic', snippetType = 'autosnippet' }, fmta('\\textit{<>}', { i(1) })),
  -- BOLD TEXT
  s({ trig = 'bold', snippetType = 'autosnippet' }, fmta('\\textbf{<>}', { i(1) })),
  -- EMPHASIS (context-sensitive italics)
  s({ trig = 'emph;', snippetType = 'autosnippet' }, fmta('\\emph{<>}', { i(1) })),
  -- UNDERLINE
  s({ trig = 'underline', snippetType = 'autosnippet' }, fmta('\\underline{<>}', { i(1) })),

  -- COLORED TEXT (requires \usepackage{xcolor})
  s({ trig = 'cl;', snippetType = 'autosnippet' }, fmta('\\textcolor{<>}{<>}', { i(1, 'red'), i(2) })),
  -- FOOTNOTE
  s({ trig = 'fn', snippetType = 'autosnippet' }, fmta('\\footnote{<>}', { i(1) })),

  -- MISC SYMBOLS
  -- TIMES (semicolon-style trigger)
  s({ trig = 'times', snippetType = 'autosnippet', wordTrig = false }, t '\\times', { condition = tex.in_mathzone }),
  s({ trig = 'dots', snippetType = 'autosnippet' }, t '\\dots', { condition = tex.in_mathzone }),
  s({ trig = 'ord', snippetType = 'autosnippet' }, fmta('\\mathcal{O}(<>)', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'bar', snippetType = 'autosnippet' }, fmta('\\bar{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'wtilde', snippetType = 'autosnippet' }, fmta('\\widetilde{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'what', snippetType = 'autosnippet' }, fmta('\\widehat{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'bsym', snippetType = 'autosnippet' }, fmta('\\boldsymbol{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'dot', snippetType = 'autosnippet' }, fmta('\\dot{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'dddot', snippetType = 'autosnippet' }, fmta('\\dddot{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'check', snippetType = 'autosnippet' }, fmta('\\check{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'hbar', snippetType = 'autosnippet' }, t '\\hbar', { condition = tex.in_mathzone }),
  s({ trig = 'par', snippetType = 'autosnippet' }, t '\\partial', { condition = tex.in_mathzone }),
  s({ trig = 'nab', snippetType = 'autosnippet' }, t '\\nabla', { condition = tex.in_mathzone }),
  s({ trig = 'inf', snippetType = 'autosnippet' }, t '\\infty', { condition = tex.in_mathzone }),
  s({ trig = 'pm', snippetType = 'autosnippet' }, t '\\pm', { condition = tex.in_mathzone }),
  s({ trig = 'otimes', snippetType = 'autosnippet' }, t '\\otimes', { condition = tex.in_mathzone }),
  s({ trig = 'oplus', snippetType = 'autosnippet' }, t '\\oplus', { condition = tex.in_mathzone }),
  s({ trig = 'iff', snippetType = 'autosnippet' }, t '\\iff', { condition = tex.in_mathzone }),
  s({ trig = 'rarr', snippetType = 'autosnippet' }, t '\\rightarrow', { condition = tex.in_mathzone }),
  s({ trig = 'larr', snippetType = 'autosnippet' }, t '\\leftarrow', { condition = tex.in_mathzone }),
  s({ trig = 'lrarr', snippetType = 'autosnippet' }, t '\\longrightarrow', { condition = tex.in_mathzone }),
  s({ trig = 'leq', snippetType = 'autosnippet' }, t '\\leq', { condition = tex.in_mathzone }),
  s({ trig = 'geq', snippetType = 'autosnippet' }, t '\\geq', { condition = tex.in_mathzone }),
  s({ trig = 'neq', snippetType = 'autosnippet' }, t '\\neq', { condition = tex.in_mathzone }),
  s({ trig = 'doteq', snippetType = 'autosnippet' }, t '\\doteq', { condition = tex.in_mathzone }),
  s({ trig = 'inn', snippetType = 'autosnippet' }, t '\\in', { condition = tex.in_mathzone }),
  s({ trig = 'fall', snippetType = 'autosnippet' }, t '\\forall', { condition = tex.in_mathzone }),
  s({ trig = 'exist', snippetType = 'autosnippet' }, t '\\exists', { condition = tex.in_mathzone }),
  s({ trig = 'dirac', snippetType = 'autosnippet' }, fmta('\\delta^{(<>)}(<>)', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'heav', snippetType = 'autosnippet' }, fmta('\\Theta(<>)', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'mca', snippetType = 'autosnippet' }, fmta('\\mathcal{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'scr', snippetType = 'autosnippet' }, fmta('\\mathscr{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'mbb', snippetType = 'autosnippet' }, fmta('\\mathbb{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'sim', snippetType = 'autosnippet' }, t '\\sim', { condition = tex.in_mathzone }),
  s({ trig = 'lnorm', snippetType = 'autosnippet' }, fmta('\\left\\| <> \\right\\|', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'eval', snippetType = 'autosnippet' }, fmta('\\left. <> \\right|_{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),

  -- EQUATION/ALIGN EXTRAS
  s({ trig = 'aln', snippetType = 'autosnippet' }, fmta('\\begin{align}\n\t<> \\label{eq:<>}\n\\end{align}', { i(1), i(2) })),
  s({ trig = 'spl', snippetType = 'autosnippet' }, fmta('\\begin{split}\n\t<> &= <> \\\\\n\t<>\n\\end{split}', { i(1), i(2), i(0) })),
  s({ trig = 'gat', snippetType = 'autosnippet' }, fmta('\\begin{gather*}\n\t<>\n\\end{gather*}', { i(1) })),
  s(
    { trig = ';case', snippetType = 'autosnippet' },
    fmta('\\begin{cases}\n\t<>, & \\text{if } <> \\\\\n\t<>, & \\text{otherwise}\n\\end{cases}', { i(1), i(2), i(3) })
  ),
  s({ trig = 'eqref', snippetType = 'autosnippet' }, fmta('Eq.\\eqref{eq:<>}', { i(1) })),
  s({ trig = 'lab', snippetType = 'autosnippet' }, fmta('\\label{eq:<>}', { i(1) })),

  -- REFERENCES / LINKS
  s({ trig = 'url', snippetType = 'autosnippet' }, fmta('\\url{<>}', { i(1) })),
  s({ trig = 'href', snippetType = 'autosnippet' }, fmta('\\href{<>}{<>}', { i(1), i(2) })),
  s({ trig = 'hreffoot', snippetType = 'autosnippet' }, fmta('\\href{<>}{<>}\\footnote{\\url{<>}}', { i(1), i(2), rep(1) })),
  s({ trig = 'hyperref', snippetType = 'autosnippet' }, fmta('\\hyperref[<>]{<>}', { i(1), i(2) })),
  s({ trig = 'mailto', snippetType = 'autosnippet' }, fmta('\\href{mailto:<>}{<>}', { i(1), i(2) })),
  s({ trig = 'cite;', snippetType = 'autosnippet' }, fmta('\\cite{<>}', { i(1) })),
  s({ trig = 'figref', snippetType = 'autosnippet' }, fmta('Fig.~\\ref{fig:<>}', { i(1) })),
  s({ trig = 'tabref', snippetType = 'autosnippet' }, fmta('Table~\\ref{tab:<>}', { i(1) })),

  -- TRIG FUNCTIONS
  s({ trig = 'sinn', snippetType = 'autosnippet' }, t '\\sin', { condition = tex.in_mathzone }),
  s({ trig = 'coss', snippetType = 'autosnippet' }, t '\\cos', { condition = tex.in_mathzone }),
  s({ trig = 'tann', snippetType = 'autosnippet' }, t '\\tan', { condition = tex.in_mathzone }),
  s({ trig = 'cscc', snippetType = 'autosnippet' }, t '\\csc', { condition = tex.in_mathzone }),
  s({ trig = 'secc', snippetType = 'autosnippet' }, t '\\sec', { condition = tex.in_mathzone }),
  s({ trig = 'cott', snippetType = 'autosnippet' }, t '\\cot', { condition = tex.in_mathzone }),
  s({ trig = 'sinh', snippetType = 'autosnippet' }, t '\\sinh', { condition = tex.in_mathzone }),
  s({ trig = 'cosh', snippetType = 'autosnippet' }, t '\\cosh', { condition = tex.in_mathzone }),
  s({ trig = 'tanh', snippetType = 'autosnippet' }, t '\\tanh', { condition = tex.in_mathzone }),
  s({ trig = 'csch', snippetType = 'autosnippet' }, t '\\operatorname{csch}', { condition = tex.in_mathzone }),
  s({ trig = 'sech', snippetType = 'autosnippet' }, t '\\operatorname{sech}', { condition = tex.in_mathzone }),
  s({ trig = 'coth', snippetType = 'autosnippet' }, t '\\coth', { condition = tex.in_mathzone }),

  -- GREEK LETTERS
  s({ trig = 'zeta', snippetType = 'autosnippet' }, t '\\zeta', { condition = tex.in_mathzone }),
  s({ trig = 'vartheta', snippetType = 'autosnippet' }, t '\\vartheta', { condition = tex.in_mathzone }),
  s({ trig = 'iota', snippetType = 'autosnippet' }, t '\\iota', { condition = tex.in_mathzone }),
  s({ trig = 'upsilon', snippetType = 'autosnippet' }, t '\\upsilon', { condition = tex.in_mathzone }),
  s({ trig = 'Xi', snippetType = 'autosnippet' }, t '\\Xi', { condition = tex.in_mathzone }),
  s({ trig = 'Upsilon', snippetType = 'autosnippet' }, t '\\Upsilon', { condition = tex.in_mathzone }),
  s({ trig = 'mu', snippetType = 'autosnippet' }, t '\\mu', { condition = tex.in_mathzone }),
  s({ trig = 'nu', snippetType = 'autosnippet' }, t '\\nu', { condition = tex.in_mathzone }),
  s({ trig = 'rho', snippetType = 'autosnippet' }, t '\\rho', { condition = tex.in_mathzone }),
  s({ trig = 'sigma', snippetType = 'autosnippet' }, t '\\sigma', { condition = tex.in_mathzone }),
  s({ trig = 'alpha', snippetType = 'autosnippet' }, t '\\alpha', { condition = tex.in_mathzone }),
  s({ trig = 'beta', snippetType = 'autosnippet' }, t '\\beta', { condition = tex.in_mathzone }),
  s({ trig = 'gamma', snippetType = 'autosnippet' }, t '\\gamma', { condition = tex.in_mathzone }),
  s({ trig = 'delta', snippetType = 'autosnippet' }, t '\\delta', { condition = tex.in_mathzone }),
  s({ trig = 'lambda', snippetType = 'autosnippet' }, t '\\lambda', { condition = tex.in_mathzone }),
  s({ trig = 'kappa', snippetType = 'autosnippet' }, t '\\kappa', { condition = tex.in_mathzone }),
  s({ trig = 'epsilon', snippetType = 'autosnippet' }, t '\\epsilon', { condition = tex.in_mathzone }),
  s({ trig = 'varepsilon', snippetType = 'autosnippet' }, t '\\varepsilon', { condition = tex.in_mathzone }),
  s({ trig = 'varphi', snippetType = 'autosnippet' }, t '\\varphi', { condition = tex.in_mathzone }),
  s({ trig = 'phi', snippetType = 'autosnippet' }, t '\\phi', { condition = tex.in_mathzone }),
  s({ trig = 'Phi', snippetType = 'autosnippet' }, t '\\Phi', { condition = tex.in_mathzone }),
  s({ trig = 'psi', snippetType = 'autosnippet' }, t '\\psi', { condition = tex.in_mathzone }),
  s({ trig = 'Psi', snippetType = 'autosnippet' }, t '\\Psi', { condition = tex.in_mathzone }),
  s({ trig = 'omega', snippetType = 'autosnippet' }, t '\\omega', { condition = tex.in_mathzone }),
  s({ trig = 'Omega', snippetType = 'autosnippet' }, t '\\Omega', { condition = tex.in_mathzone }),
  s({ trig = 'chi', snippetType = 'autosnippet' }, t '\\chi', { condition = tex.in_mathzone }),
  s({ trig = 'xi', snippetType = 'autosnippet' }, t '\\xi', { condition = tex.in_mathzone }),
  s({ trig = 'pi', snippetType = 'autosnippet' }, t '\\pi', { condition = tex.in_mathzone }),
  s({ trig = 'Pi', snippetType = 'autosnippet' }, t '\\Pi', { condition = tex.in_mathzone }),
  s({ trig = 'tau', snippetType = 'autosnippet' }, t '\\tau', { condition = tex.in_mathzone }),
  s({ trig = 'eta', snippetType = 'autosnippet' }, t '\\eta', { condition = tex.in_mathzone }),
  s({ trig = 'theta', snippetType = 'autosnippet' }, t '\\theta', { condition = tex.in_mathzone }),
  s({ trig = 'Theta', snippetType = 'autosnippet' }, t '\\Theta', { condition = tex.in_mathzone }),
  s({ trig = 'Lambda', snippetType = 'autosnippet' }, t '\\Lambda', { condition = tex.in_mathzone }),
  s({ trig = 'Gamma', snippetType = 'autosnippet' }, t '\\Gamma', { condition = tex.in_mathzone }),
  s({ trig = 'Delta', snippetType = 'autosnippet' }, t '\\Delta', { condition = tex.in_mathzone }),
  s({ trig = 'Sigma', snippetType = 'autosnippet' }, t '\\Sigma', { condition = tex.in_mathzone }),

  -- FRACTIONS / ROOTS / EXP / LOG
  s({ trig = 'dfrac', snippetType = 'autosnippet' }, fmta('\\dfrac{<>}{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'tfrac', snippetType = 'autosnippet' }, fmta('\\tfrac{<>}{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'nrt', snippetType = 'autosnippet' }, fmta('\\sqrt[<>]{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'expo', snippetType = 'autosnippet' }, fmta('\\exp\\!\\left( <> \\right)', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'expbig', snippetType = 'autosnippet' }, fmta('\\exp\\!\\left[ <> \\right]', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ln', snippetType = 'autosnippet' }, fmta('\\ln\\!\\left( <> \\right)', { i(1) }), { condition = tex.in_mathzone }),

  -- SUPERSCRIPT SHORTCUTS
  s({ trig = 'cub', snippetType = 'autosnippet' }, t '^{3}', { condition = tex.in_mathzone }),
  s({ trig = 'inv', snippetType = 'autosnippet' }, t '^{-1}', { condition = tex.in_mathzone }),
  s({ trig = 'dag', snippetType = 'autosnippet' }, t '^{\\dagger}', { condition = tex.in_mathzone }),
  s({ trig = 'conj', snippetType = 'autosnippet' }, t '^{*}', { condition = tex.in_mathzone }),
  s({ trig = 'trans', snippetType = 'autosnippet' }, t '^{\\top}', { condition = tex.in_mathzone }),

  -- INTEGRALS
  s({ trig = 'int', snippetType = 'autosnippet' }, fmta('\\int_{<>}^{<>} <> \\, d<>', { i(1), i(2), i(3), i(4) }), { condition = tex.in_mathzone }),
  s({ trig = 'dblint', snippetType = 'autosnippet' }, fmta('\\iint_{<>} <> \\, d<>', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'trint', snippetType = 'autosnippet' }, fmta('\\iiint_{<>} <> \\, d<>', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'oint', snippetType = 'autosnippet' }, fmta('\\oint_{<>} <> \\, d<>', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'vol3', snippetType = 'autosnippet' }, fmta('\\int d^3 <>\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'vol4', snippetType = 'autosnippet' }, fmta('\\int d^4 <>\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'gvol', snippetType = 'autosnippet' }, fmta('\\int d^4 <>\\, \\sqrt{-g}\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'd3p', snippetType = 'autosnippet' }, fmta('\\int \\frac{d^3 <>}{(2\\pi)^3}\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'd4p', snippetType = 'autosnippet' }, fmta('\\int \\frac{d^4 <>}{(2\\pi)^4}\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'dnk', snippetType = 'autosnippet' }, fmta('\\int \\frac{d^{<>} <>}{(2\\pi)^{<>}}\\, ', { i(1), i(2), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'd4pEuc', snippetType = 'autosnippet' }, fmta('\\int \\frac{d^4 <>_E}{(2\\pi)^4}\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'pathintM', snippetType = 'autosnippet' }, fmta('\\int \\mathcal{D}<>\\, e^{i S[<>]}\\, ', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'pathintE', snippetType = 'autosnippet' }, fmta('\\int \\mathcal{D}<>\\, e^{-S_E[<>]}\\, ', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'Dphi', snippetType = 'autosnippet' }, fmta('\\mathcal{D}<>\\, ', { i(1) }), { condition = tex.in_mathzone }),

  -- DERIVATIVE EXTRAS
  s(
    { trig = 'pdm', snippetType = 'autosnippet' },
    fmta('\\frac{\\partial^{2} <>}{\\partial <> \\, \\partial <>}', { i(1), i(2), i(3) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'fd', snippetType = 'autosnippet' }, fmta('\\frac{\\delta <>}{\\delta <>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'fd2', snippetType = 'autosnippet' },
    fmta('\\frac{\\delta^{2} <>}{\\delta <>(<>) \\, \\delta <>(<>)}', { i(1), i(2), i(3), rep(2), i(4) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'covd', snippetType = 'autosnippet' }, fmta('\\nabla_{<>} ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'covdu', snippetType = 'autosnippet' }, fmta('\\nabla^{<>} ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'lied', snippetType = 'autosnippet' }, fmta('\\mathcal{L}_{<>} ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ddot', snippetType = 'autosnippet' }, fmta('\\ddot{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'box;', snippetType = 'autosnippet' }, t '\\Box ', { condition = tex.in_mathzone }),
  s({ trig = 'lap;', snippetType = 'autosnippet' }, t '\\nabla^2 ', { condition = tex.in_mathzone }),
  s({ trig = 'grad;', snippetType = 'autosnippet' }, t '\\boldsymbol{\\nabla} ', { condition = tex.in_mathzone }),
  s({ trig = 'divv', snippetType = 'autosnippet' }, t '\\boldsymbol{\\nabla} \\cdot ', { condition = tex.in_mathzone }),
  s({ trig = 'curl;', snippetType = 'autosnippet' }, t '\\boldsymbol{\\nabla} \\times ', { condition = tex.in_mathzone }),

  -- TENSOR INDICES
  s({ trig = 'uu', snippetType = 'autosnippet' }, fmta('^{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'llidx', snippetType = 'autosnippet' }, fmta('_{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ul', snippetType = 'autosnippet' }, fmta('^{<>}{}_{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),

  -- GR TENSORS
  s({ trig = 'guu', snippetType = 'autosnippet' }, fmta('g^{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'etadd', snippetType = 'autosnippet' }, fmta('\\eta_{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'etauu', snippetType = 'autosnippet' }, fmta('\\eta^{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'kron', snippetType = 'autosnippet' }, fmta('\\delta^{<>}{}_{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'levi', snippetType = 'autosnippet' }, fmta('\\epsilon_{<><><><>}', { i(1), i(2), i(3), i(4) }), { condition = tex.in_mathzone }),
  s({ trig = 'chris', snippetType = 'autosnippet' }, fmta('\\Gamma^{<>}{}_{<><>}', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'riem', snippetType = 'autosnippet' }, fmta('R^{<>}{}_{<><><>}', { i(1), i(2), i(3), i(4) }), { condition = tex.in_mathzone }),
  s({ trig = 'ricci', snippetType = 'autosnippet' }, fmta('R_{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'riccis', snippetType = 'autosnippet' }, t 'R', { condition = tex.in_mathzone }),
  s({ trig = 'einst', snippetType = 'autosnippet' }, fmta('G_{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'tmunu', snippetType = 'autosnippet' }, fmta('T_{<><>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'efe', snippetType = 'autosnippet' }, fmta('G_{<><>} = 8\\pi G\\, T_{<><>}', { i(1), i(2), rep(1), rep(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'vierbein', snippetType = 'autosnippet' }, fmta('e^{<>}{}_{<>}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'spincon', snippetType = 'autosnippet' }, fmta('\\omega_{<>}{}^{<>}{}_{<>}', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'covdiv', snippetType = 'autosnippet' }, fmta('\\nabla_{<>} <>^{<>}', { i(1), i(2), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'sym', snippetType = 'autosnippet' }, fmta('\\left( <> <> \\right)', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'asym', snippetType = 'autosnippet' }, fmta('\\left[ <> <> \\right]', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'extd', snippetType = 'autosnippet' }, fmta('d<>', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'wedge', snippetType = 'autosnippet' }, fmta('<> \\wedge <>', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'hodge', snippetType = 'autosnippet' }, fmta('\\star\\, <>', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'vol', snippetType = 'autosnippet' }, fmta('\\sqrt{-g}\\, d^{<>}x', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'killing', snippetType = 'autosnippet' }, fmta('\\nabla_{(<>} \\xi_{<>)} = 0', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'geod', snippetType = 'autosnippet' },
    fmta(
      '\\frac{d^2 x^{<>}}{d\\tau^2} + \\Gamma^{<>}{}_{<> <>} \\frac{dx^{<>}}{d\\tau} \\frac{dx^{<>}}{d\\tau} = 0',
      { i(1), rep(1), i(2), i(3), rep(2), rep(3) }
    ),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = 'lineel', snippetType = 'autosnippet' },
    fmta('ds^2 = g_{<><>}\\, dx^{<>} dx^{<>}', { i(1), i(2), rep(1), rep(2) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = 'flrw', snippetType = 'autosnippet' },
    t 'ds^2 = -dt^2 + a^2(t)\\left[ \\frac{dr^2}{1-kr^2} + r^2 d\\Omega^2 \\right]',
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'domega', snippetType = 'autosnippet' }, t 'd\\Omega^2 = d\\theta^2 + \\sin^2\\!\\theta\\, d\\varphi^2', { condition = tex.in_mathzone }),
  s({ trig = 'bianchi', snippetType = 'autosnippet' }, fmta('\\nabla_{[<>} R_{<><>]<>} = 0', { i(1), i(2), i(3), i(4) }), { condition = tex.in_mathzone }),

  -- QFT / EFFECTIVE ACTION / THERMAL
  s(
    { trig = 'action', snippetType = 'autosnippet' },
    fmta('S[<>] = \\int d^4x\\, \\mathcal{L}(<>, \\partial_\\mu <>)', { i(1), rep(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'actionE', snippetType = 'autosnippet' }, fmta('S_E[<>] = \\int d^4x_E\\, \\mathcal{L}_E(<>)', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'lag', snippetType = 'autosnippet' }, fmta('\\mathcal{L}(<>, \\partial_\\mu <>)', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'Zj', snippetType = 'autosnippet' },
    fmta('Z[<>] = \\int \\mathcal{D}<>\\, \\exp\\!\\left( i S[<>] + i\\int d^4x\\, <>(x)<>(x) \\right)', { i(1), i(2), rep(2), rep(1), rep(2) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'Wj', snippetType = 'autosnippet' }, fmta('W[<>] = -i \\ln Z[<>]', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'Gamma1PI', snippetType = 'autosnippet' },
    fmta('\\Gamma[<>] = W[J] - \\int d^4x\\, J(x)\\, <>(x)', { i(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'Veff', snippetType = 'autosnippet' }, fmta('V_{\\mathrm{eff}}(<>)', { i(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'Vcw', snippetType = 'autosnippet' },
    fmta('V_{\\mathrm{CW}}(<>) = \\frac{1}{64\\pi^2} M^4(<>) \\left[ \\ln\\frac{M^2(<>)}{\\mu^2} - \\frac{3}{2} \\right]', { i(1), rep(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = 'V1loop', snippetType = 'autosnippet' },
    fmta('V^{(1)}(<>) = \\frac{1}{64\\pi^2} M^4(<>) \\left( \\ln\\frac{M^2(<>)}{\\mu^2} - c \\right)', { i(1), rep(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'prop', snippetType = 'autosnippet' }, t '\\frac{i}{p^2 - m^2 + i\\varepsilon}', { condition = tex.in_mathzone }),
  s(
    { trig = 'propx', snippetType = 'autosnippet' },
    t '\\Delta_F(x - y) = \\int \\frac{d^4p}{(2\\pi)^4} \\frac{i\\, e^{-ip\\cdot(x-y)}}{p^2 - m^2 + i\\varepsilon}',
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'propD', snippetType = 'autosnippet' }, t '\\frac{i(\\slashed{p} + m)}{p^2 - m^2 + i\\varepsilon}', { condition = tex.in_mathzone }),
  s({ trig = 'slash', snippetType = 'autosnippet' }, fmta('\\slashed{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'nord', snippetType = 'autosnippet' }, fmta(':\\!<>\\!:', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'tord', snippetType = 'autosnippet' }, fmta('\\mathcal{T}\\!\\left\\{ <> \\right\\}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'vev', snippetType = 'autosnippet' }, fmta('\\langle 0 | <> | 0 \\rangle', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'expval', snippetType = 'autosnippet' }, fmta('\\langle <> | <> | <> \\rangle', { i(1), i(2), rep(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'mel', snippetType = 'autosnippet' }, fmta('\\langle <> | <> | <> \\rangle', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'bra', snippetType = 'autosnippet' }, fmta('\\langle <> |', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ket', snippetType = 'autosnippet' }, fmta('| <> \\rangle', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ip', snippetType = 'autosnippet' }, fmta('\\langle <> | <> \\rangle', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'comm', snippetType = 'autosnippet' }, fmta('\\left[ <>, <> \\right]', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'acomm', snippetType = 'autosnippet' }, fmta('\\left\\{ <>, <> \\right\\}', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'adag', snippetType = 'autosnippet' }, fmta('a^{\\dagger}_{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'ann', snippetType = 'autosnippet' }, fmta('a_{<>}', { i(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'ccr', snippetType = 'autosnippet' },
    fmta('\\left[ \\hat{<>}(\\mathbf{x}), \\hat{\\pi}(\\mathbf{y}) \\right] = i\\delta^{(3)}(\\mathbf{x} - \\mathbf{y})', { i(1) }),
    { condition = tex.in_mathzone }
  ),
  s(
    { trig = 'modeexp', snippetType = 'autosnippet' },
    fmta(
      '\\hat{<>}(x) = \\int \\frac{d^3k}{(2\\pi)^3} \\frac{1}{\\sqrt{2\\omega_{\\mathbf{k}}}} \\left( a_{\\mathbf{k}}\\, e^{-ik\\cdot x} + a^{\\dagger}_{\\mathbf{k}}\\, e^{ik\\cdot x} \\right)',
      { i(1) }
    ),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'smat', snippetType = 'autosnippet' }, fmta('\\langle <> | S | <> \\rangle', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'tmat', snippetType = 'autosnippet' }, fmta('i\\mathcal{M}(<> \\to <>)', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'lsz', snippetType = 'autosnippet' },
    fmta('\\langle <> | S | <> \\rangle = \\prod_i \\left( \\frac{i}{p_i^2 - m^2} \\right) \\tilde{G}^{(n+m)}(\\{p\\}, \\{k\\})', { i(1), i(2) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'dimreg', snippetType = 'autosnippet' }, fmta('\\mu^{4-d} \\int \\frac{d^d <>}{(2\\pi)^d}\\, ', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'wick', snippetType = 'autosnippet' }, t 'p^0 \\to i p^0_E, \\quad p^2 \\to -p_E^2', { condition = tex.in_mathzone }),
  s({ trig = 'tr', snippetType = 'autosnippet' }, fmta('\\mathrm{Tr}\\!\\left[ <> \\right]', { i(1) }), { condition = tex.in_mathzone }),
  s({ trig = 'det', snippetType = 'autosnippet' }, fmta('\\det\\!\\left( <> \\right)', { i(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'logdet', snippetType = 'autosnippet' },
    fmta('\\ln \\det\\!\\left( <> \\right) = \\mathrm{Tr} \\ln\\!\\left( <> \\right)', { i(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'schwtime', snippetType = 'autosnippet' }, t '\\int_0^{\\infty} \\frac{ds}{s}\\, e^{-s M^2}\\, K(x, x; s)', { condition = tex.in_mathzone }),
  s(
    { trig = 'bounce', snippetType = 'autosnippet' },
    t 'S_B = \\int d^4x \\left[ \\frac{1}{2}(\\partial_\\mu \\phi)^2 + V(\\phi) \\right]',
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'nucrate', snippetType = 'autosnippet' }, t '\\frac{\\Gamma}{V} = A\\, e^{-S_E / \\hbar}', { condition = tex.in_mathzone }),
  s({ trig = 'rgrun', snippetType = 'autosnippet' }, fmta('\\mu \\frac{d <>}{d\\mu} = \\beta(<>)', { i(1), rep(1) }), { condition = tex.in_mathzone }),
  s(
    { trig = 'betafn', snippetType = 'autosnippet' },
    fmta('\\beta(<>) = \\mu \\frac{\\partial <>}{\\partial \\mu}\\bigg|_{g_0, m_0}', { i(1), rep(1) }),
    { condition = tex.in_mathzone }
  ),
  s({ trig = 'anom', snippetType = 'autosnippet' }, t '\\gamma = \\mu \\frac{\\partial \\ln Z_{\\phi}}{\\partial \\mu}', { condition = tex.in_mathzone }),
  s({ trig = 'Zbeta', snippetType = 'autosnippet' }, t 'Z(\\beta) = \\mathrm{Tr}\\, e^{-\\beta \\hat{H}}', { condition = tex.in_mathzone }),
  s({ trig = 'matsuB', snippetType = 'autosnippet' }, t '\\omega_n = \\frac{2\\pi n}{\\beta}', { condition = tex.in_mathzone }),
  s({ trig = 'matsuF', snippetType = 'autosnippet' }, t '\\omega_n = \\frac{(2n+1)\\pi}{\\beta}', { condition = tex.in_mathzone }),
  s({ trig = 'sumint', snippetType = 'autosnippet' }, t 'T \\sum_{n=-\\infty}^{\\infty} \\int \\frac{d^3k}{(2\\pi)^3}\\, ', { condition = tex.in_mathzone }),
  s({ trig = 'hubble', snippetType = 'autosnippet' }, t 'H = \\frac{\\dot{a}}{a}', { condition = tex.in_mathzone }),
  s(
    { trig = 'friedmann', snippetType = 'autosnippet' },
    t 'H^2 = \\frac{8\\pi G}{3} \\rho - \\frac{k}{a^2} + \\frac{\\Lambda}{3}',
    { condition = tex.in_mathzone }
  ),

  -- MISC MATH
  s({ trig = 'prodd', snippetType = 'autosnippet' }, fmta('\\prod_{<>=<>}^{<>} ', { i(1), i(2), i(3) }), { condition = tex.in_mathzone }),
  s({ trig = 'lim', snippetType = 'autosnippet' }, fmta('\\lim_{<> \\to <>} ', { i(1), i(2) }), { condition = tex.in_mathzone }),
  s({ trig = 'ohbar', snippetType = 'autosnippet' }, fmta('\\mathcal{O}(\\hbar^{<>})', { i(1) }), { condition = tex.in_mathzone }),
  --
  -- CHECKMARK (bold)
  s({ trig = 'done;', snippetType = 'autosnippet' }, t '\\CheckmarkBold'),
  -- X MARK (crossed out)
  s({ trig = 'undone;', snippetType = 'autosnippet' }, t '\\XSolidBrush'),
}

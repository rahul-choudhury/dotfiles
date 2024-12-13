local ls = require("luasnip")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local s, t, i, l = ls.snippet, ls.text_node, ls.insert_node, extras.lambda

return {
  s("ucd", { t('"use client"') }),
  s("usd", { t('"use server"') }),

  s("rni", { t('import * as React from "react"') }),
  s("rdni", { t('import * as ReactDOM from "react-dom"') }),

  s(
    "ush",
    fmt("const [{}, set{setter}] = React.useState({})", {
      i(1, "state"),
      i(2),
      setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
    })
  ),

  s(
    "ueh",
    fmt(
      [[
        React.useEffect(() => {{
          {}
        }}, [{}])
      ]],
      { i(1), i(2, "deps") }
    )
  ),

  s(
    "urh",
    fmt("const {} = React.useRef<{}>(null)", {
      i(1, "ref"),
      i(2, "generic"),
    })
  ),

  s(
    "ufsh",
    fmt("const [state, formAction] = ReactDOM.useFormState({}, initState)", {
      i(1, "action"),
    })
  ),
}

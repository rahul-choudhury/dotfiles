local ls = require("luasnip")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local s, t, i, l = ls.snippet, ls.text_node, ls.insert_node, extras.lambda

return {
  s("ucl", { t('"use client"') }),
  s("rimp", { t('import * as React from "react"') }),

  s(
    "us",
    fmt("const [{}, set{setter}] = React.useState({})", {
      i(1, "state"),
      i(2),
      setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
    })
  ),

  s(
    "ue",
    fmt(
      [[
        React.useEffect(() => {{
          {}
        }}, [{}])
      ]],
      { i(1), i(2, "dependencies") }
    )
  ),
}

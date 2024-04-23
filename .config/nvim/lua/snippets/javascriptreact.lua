local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local l = extras.lambda
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- import
  s("imp", { t('import * as React from "react"') }),

  -- useState
  s(
    "us",
    fmt("const [{}, set{setter}] = React.useState({})", {
      i(1, "state"),
      i(2),
      setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
    })
  ),

  -- useEffect
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

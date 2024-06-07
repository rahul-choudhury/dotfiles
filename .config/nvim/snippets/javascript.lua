local ls = require("luasnip")
local s, i, t = ls.snippet, ls.insert_node, ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("cl", fmt("console.log({})", { i(1) })),

  s("?", {
    i(1, "cond"),
    t(" ? "),
    i(2, "then"),
    t(" : "),
    i(3, "else"),
  }),

  s(
    "if",
    fmt(
      [[
        if ({}) {{
          {}
        }}
      ]],
      { i(1, "condition"), i(2) }
    )
  ),

  s(
    "f",
    fmt(
      [[
        function {}({}) {{
          {}
        }}
      ]],
      { i(1, "name"), i(2, "params"), i(3) }
    )
  ),

  s(
    "af",
    fmt(
      [[
        const {} = ({}) => {{
          {}
        }}
      ]],
      { i(1, "name"), i(2, "params"), i(3) }
    )
  ),

  s(
    "tc",
    fmt(
      [[
        try {{
          {}
        }} catch({}) {{
          {}
        }}
      ]],
      { i(2), i(1, "error"), i(3) }
    )
  ),

  s(
    "forof",
    fmt(
      [[
        for ({} of {}) {{
          {}
        }}
      ]],
      { i(1, "variable"), i(2, "iterable"), i(3) }
    )
  ),
}

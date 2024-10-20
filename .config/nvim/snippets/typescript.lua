local ls = require("luasnip")
local s, i = ls.snippet, ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("log", fmt("console.log({})", { i(1) })),

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
    "fn",
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
}

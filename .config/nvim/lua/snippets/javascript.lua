local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- async arrow function
  s("aaf", fmt(
    [[
    const {} = async ({}) => {{
      {}
    }}
    ]], {i(1, "name"), i(2, "param"), i(3)}
  )),
}

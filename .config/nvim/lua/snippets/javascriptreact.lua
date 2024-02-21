local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local l = extras.lambda
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- jsx self closing tag
  s("jc", fmt("<{} />", {i(1, "Component")})),

  -- useState
  s(
    "us",
    fmt("const [{}, set{setter}] = useState({})", {
      i(1, "state"),
      i(2),
      setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1)
    })
  ),
}

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node

return {
  -- console log
  s("cl", fmt("console.log({})", {i(1)})),

  -- if
  s("if", fmt(
    [[
    if ({}) {{
      {}
    }}
    ]], {i(1, "condition"), i(2)}
  )),

  -- function
  s("f", fmt(
    [[
    function {}({}) {{
      {}
    }}
    ]], {i(1, "name"), i(2, "params"), i(3)}
  )),

  -- arrow function
  s("af", fmt(
    [[
    const {} = ({}) => {{
      {}
    }}
    ]], {i(1, "name"), i(2, "params"), i(3)}
  )),

  -- try...catch block
  s("tc", fmt(
    [[
    try {{
      {}
    }} catch({}) {{
      {}
    }}
    ]], {i(2), i(1, "error"), i(3)}
  )),

  -- default function export
  s("edf", fmt(
    [[
    export default function {}({}) {{
      {}
    }}
    ]], {i(1, "name"), i(2, "params"), i(3)}
  )),

  -- named function export
  s("ef", fmt(
    [[
    export function {}({}) {{
      {}
    }}
    ]], {i(1, "name"), i(2, "params"), i(3)}
  )),
}

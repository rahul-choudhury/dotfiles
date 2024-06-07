local ls = require("luasnip")
local s, i, t = ls.snippet, ls.insert_node, ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "!",
    fmt(
      [[
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width={}, initial-scale={}">
        <title>{}</title>
      </head>
      <body>
        {}
      </body>
      </html>
    ]],
      { i(1, "device-width"), i(2, "1.0"), i(3, "Document"), i(4) }
    )
  ),

  s("link:css", fmt('<link href="{}" rel="stylesheet" />', { i(1, "style.css") })),
}

# blink-sql.nvim

SQL reserved keywords

## Installation

### lazy.nvim

```lua
---@type LazySpec
return {
  "KevinNitroG/blink-sql.nvim",
  event = "InsertEnter",
  specs = {
    {
      "Saghen/blink.cmp",
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        sources = {
          providers = {
            sql = {
              name = "sql",
              module = "blink-sql",
              ---@module 'blink-sql'
              ---@type BlinkSql.Opts
              opts = nil,
            },
          },
        },
      },
    },
  },
  dependencies = {
    "Saghen/blink.cmp",
  },
}
```

## Tweak

```lua
---@type table<string, table<string, true>>
local allowed_filetypes_nodes = {
  go = {
    raw_string_literal = true,
    string_literal = true,
    template_string = true,
    interpreted_string_literal = true,
  },
}

---@type LazySpec
return {
  "KevinNitroG/blink-sql.nvim",
  event = "InsertEnter",
  specs = {
    {
      "Saghen/blink.cmp",
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        sources = {
          providers = {
            sql = {
              name = "sql",
              module = "blink-sql",
              score_offset = function(ctx)
                if vim.bo[ctx.bufnr].filetype:match("sql") then
                  return 0
                end
                return -5
              end,
              max_items = function(ctx)
                if vim.bo[ctx.bufnr].filetype:match("sql") then
                  return 10
                end
                return 50
              end,
              should_show_items = function(ctx)
                local filetype = vim.bo[ctx.bufnr].filetype
                if filetype:match("sql") then
                  return true
                end
                local ok, node = pcall(vim.treesitter.get_node)
                if not ok or not node then
                  return false
                end
                local allowed_filetype_nodes = allowed_filetypes_nodes[filetype]
                return allowed_filetype_nodes and allowed_filetype_nodes[node:type()] or false
              end,
            },
            lsp = {
              fallbacks = {
                "sql",
              },
            },
          },
          default = {
            "sql",
          },
        },
      },
      opts_extend = {
        "sources.default",
        "sources.providers.lsp.fallbacks",
      },
    },
  },
  dependencies = {
    "Saghen/blink.cmp",
  },
}
```

## Source

- <https://en.wikipedia.org/wiki/List_of_SQL_reserved_words>
- <https://docs.oracle.com/cd/A97630_01/appdev.920/a42525/apb.htm>
- <https://www.postgresql.org/docs/current/sql-keywords-appendix.html>
- <https://learn.microsoft.com/en-us/sql/t-sql/language-elements/reserved-keywords-transact-sql?view=sql-server-ver17>
- <https://dev.mysql.com/doc/refman/8.0/en/keywords.html#keywords-in-current-series>

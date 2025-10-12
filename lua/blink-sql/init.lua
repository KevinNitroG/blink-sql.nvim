local async = require("blink.cmp.lib.async")

---@class BlinkSql.Opts
---@field sql BlinkSql.Opts.Sql

---@class BlinkSql.Opts.Sql
---@field kind? integer
---@field kind_name?string
---@field kind_icon? string
---@field kind_hl? string

--- @module 'blink.cmp'
--- @class blink.cmp.Source
--- @field items blink.cmp.CompletionItem[]
--- @field options BlinkSql.Opts
local source = {}

---@type BlinkSql.Opts
local default_opts = {
  sql = {
    kind = require("blink.cmp.types").CompletionItemKind.Keyword,
    kind_icon = "",
    kind_name = "SQL",
    kind_hl = "@keyword.sql",
   }
}

---@param opts BlinkSql.Opts
function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.options = vim.tbl_deep_extend("force", default_opts, opts)
  self.items = require("blink-sql.sql-words")(self.options.sql)
  package.loaded["blink-sql.sql-words"] = nil
  return self
end

function source:get_completions(_, callback)
  local task = async.task.empty():map(function()
    callback({
      is_incomplete_backward = false,
      is_incomplete_forward = false,
      items = self.items,
    })
  end)

  return function()
    task:cancel()
  end
end

return source

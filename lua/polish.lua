--if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- 3. Controlled color configuration for a softer, darker workspace
local active_color = "#7A7A7A" -- Softer medium-dark gray for active elements
local relative_color = "#656565" -- Noticeably darker slate gray for relative elements

-- Set the current line number and the wrap arrow to the medium-dark gray
vim.api.nvim_set_hl(0, "LineNr", { fg = active_color })
vim.api.nvim_set_hl(0, "Whitespace", { fg = active_color })
vim.api.nvim_set_hl(0, "NonText", { fg = active_color })

-- Set the relative numbers above and below to be significantly darker
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = relative_color })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = relative_color })
-- NOTE: buffer nav ()b/(b) and <Leader>gD moved to lua/plugins/astrocore.lua
-- so they're registered with which-key (see mappings.n there)

-- :Fredlog <comment>[, arg2, arg3, ...] inserts a "fredddds" debug console.log below the cursor
local fredlog_counters = {}
local fredlog_func_types = {
  function_declaration = true,
  function_expression = true,
  method_definition = true,
  arrow_function = true,
  generator_function_declaration = true,
}

local function fredlog_function_name()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok then return nil end
  while node do
    if fredlog_func_types[node:type()] then
      local name = node:field("name")[1]
      if name then return vim.treesitter.get_node_text(name, 0) end
      local parent = node:parent()
      if parent then
        local key = parent:field("name")[1] or parent:field("key")[1] or parent:field("left")[1]
        if key then return vim.treesitter.get_node_text(key, 0) end
      end
    end
    node = node:parent()
  end
  return nil
end

vim.api.nvim_create_user_command("Fredlog", function(opts)
  local parts = vim.split(opts.args, ",")
  for i, p in ipairs(parts) do
    parts[i] = vim.trim(p)
  end
  local comment = table.remove(parts, 1)
  local fname = fredlog_function_name() or vim.fn.input "Fredlog function name: "
  if fname == "" then return end
  fredlog_counters[fname] = (fredlog_counters[fname] or -1) + 1
  local extra = #parts > 0 and (", " .. table.concat(parts, ", ")) or ""
  local msg = string.format(
    "console.log('fredddds %s %s %s'%s);",
    fname,
    string.format("%02d", fredlog_counters[fname]),
    comment,
    extra
  )
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local indent = vim.api.nvim_get_current_line():match "^%s*"
  vim.api.nvim_buf_set_lines(0, lnum, lnum, false, { indent .. msg })
  vim.api.nvim_win_set_cursor(0, { lnum + 1, #indent })
end, { nargs = "+", desc = "Insert fredddds debug console.log below cursor" })

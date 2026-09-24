---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- applies to both "find files" (<Leader>ff) and "find words" (<Leader>fw)
      exclude = {
        "node_modules",
        "dist",
        ".git",
        ".idea",
        "package-lock.json",
        "coverage",
        "libs",
      },
    },
  },
}

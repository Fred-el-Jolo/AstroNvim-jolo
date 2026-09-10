-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.vue" }, -- vtsls + volar hybrid mode, covers src/vue (TS+Vue)
  { import = "astrocommunity.pack.eslint" }, -- eslint LSP, covers src/js (root) and src/vue
  { import = "astrocommunity.pack.html-css" }, -- cssls + less/scss treesitter, covers src/css (LESS)
  -- import/override with your plugins folder
}

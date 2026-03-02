-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Escape from terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

local todo_win = nil

local wk = require("which-key")
wk.add({
  {
    "<leader>T",
    function()
      if todo_win == nil then
        todo_win = Snacks.win({
          file = vim.fn.expand("C:/Users/tbk/notes/todo.md"),
          width = 0.6,
          height = 0.7,
          title = " TODO ",
          title_pos = "center",
          wo = {
            wrap = true,
            signcolumn = "no",
            statuscolumn = "",
            conceallevel = 3,
          },
        })
      else
        todo_win:toggle()
      end
    end,
    desc = "Toggle Todo",
  },
  { "<leader>t", group = "Tests" },
  { "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
  { "<leader>ta", "<cmd>lua require('neotest').run.run({ suite = true })<cr>", desc = "Run all tests" },
  { "<leader>to", "<cmd>lua require('neotest').output.open()<cr>", desc = "Show tests output" },
  { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Show tests panel" },
  { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Show tests summary" },
  { "s", "cl" },
})

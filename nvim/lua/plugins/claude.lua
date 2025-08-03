print("Loading claude.lua")
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
opts={
-- Diff Integration
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
    }
},
  keys = {
    -- { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ii", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>iw", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>iv", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil" },
    },
    -- Diff management
    { "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>in", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}

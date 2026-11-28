return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },

  opts = {
    git_cmd = "git",
    symbols = {
      merge_commit = "M",
      commit = "*",
    },
    format = {
      timestamp = "%H:%M:%S %d-%m-%Y",
      fields = { "hash", "timestamp", "author", "branch_name", "tag" },
    },
    hooks = {
      on_select_commit = function(commit)
        vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
      end,
      on_select_range_commit = function(from, to)
        vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
      end,
    },
  },
}

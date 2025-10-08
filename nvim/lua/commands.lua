local command = vim.api.nvim_create_user_command

command("DiscordRichPresence", function()
  vim.g.disable_discord_rich_presence = not vim.g.disable_discord_rich_presence

  if not vim.g.disable_discord_rich_presence then
    vim.notify(
      "Discord Rich Presence: Enabled",
      vim.log.levels.INFO,
      { title = "cord.nvim" }
    )
    vim.cmd "Cord enable"
  else
    vim.notify(
      "Discord Rich Presence: Disabled",
      vim.log.levels.INFO,
      { title = "cord.nvim" }
    )
    vim.cmd "Cord disable"
  end
end, { desc = "Toggle Discord Rich Presence" })

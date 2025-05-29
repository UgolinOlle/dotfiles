local M = {
	launch_menu = {
		{
			label = "Zsh Shell",
			args = { "/bin/zsh" },
			cwd = os.getenv("HOME"),
		},
		{
			label = "Default Bash",
			args = { "/bin/bash", "--login" },
			cwd = os.getenv("HOME"),
		},
		{
			label = "Python Virtual Env",
			args = { "/bin/zsh", "-c", "source ~/myenv/bin/activate && zsh" },
			cwd = os.getenv("HOME"),
		},
		{
			label = "Node REPL",
			args = { "/usr/local/bin/node" },
			cwd = os.getenv("HOME"),
		},
		{
			label = "System Ruby",
			args = { "/usr/bin/ruby" },
		},
		{
			label = "📁 Zoxide + FZF",
			args = { "zellij", "run", "--", "zoxide", "zi" },
		},
	},
}

return M

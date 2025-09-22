require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- Terminal
o.shell = "bash"
o.shellcmdflag = "-c"
o.shellquote = "\""
o.shellxquote = ""

o.ruler = true
o.number = true
o.relativenumber = true

o.cc = "+1"
o.mouse = ""
o.mousemodel = "popup"
o.mousefocus = false


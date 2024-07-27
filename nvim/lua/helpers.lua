function bind(mode, src, dest, opts)
	opts = opts or { silent = true, noremap = true }
	vim.keymap.set(mode, src, dest, opts)
end

function getDarkMode()
	-- TODO: Support linux
	return vim.fn.system("defaults read -g AppleInterfaceStyle")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
	extension = {
		html = function(path)
			if vim.fs.find({ 'angular.json', 'nx.json' }, { upward = true, path = path })[1] then
				return 'html' or 'typescript.angular' -- или 'typescript.angular'
			end
			return 'html'
		end,
	},
})

vim.opt.undofile = true
vim.opt.signcolumn = "yes" -- Панель слева всегда на месте, текст не прыгает
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.diagnostic.disable() -- Вырубить вообще всё, когда зашел в Insert Mode
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.diagnostic.enable() -- Включить обратно, только когда нажал Esc
	end,
})

local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  local forbidden = {
    "db worker",
    "Update db cache",
    "sqls",
    "postgres_lsp",
    "exit code 1"
  }
  for _, word in ipairs(forbidden) do
    if msg:find(word) then
      return
    end
  end
  original_notify(msg, level, opts)
end

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})

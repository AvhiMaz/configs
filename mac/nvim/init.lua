vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

vim.opt.foldenable = false
vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99
vim.opt.scrolloff = 2
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.wildmode = "list:longest"
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 8
vim.opt.tabstop = 8
vim.opt.expandtab = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.vb = true
vim.opt.clipboard = "unnamedplus"
vim.opt.diffopt:append("iwhite")
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("Filetype", { pattern = "rust", command = "set colorcolumn=100" })
vim.opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•"

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", ";", ":")
for _, mode in ipairs({ "i", "v", "s", "x", "c", "o", "l", "t" }) do
	vim.keymap.set(mode, "<C-j>", "<Esc>")
	vim.keymap.set(mode, "<C-k>", "<Esc>")
end
vim.keymap.set("v", "<C-h>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("", "H", "^")
vim.keymap.set("", "L", "$")
vim.keymap.set("n", "<leader><leader>", "<c-^>")
vim.keymap.set("n", "<leader>,", ":set invlist<cr>")
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })
vim.keymap.set("n", "g*", "g*zz", { silent = true })
vim.keymap.set("n", "?", "?\\v")
vim.keymap.set("n", "/", "/\\v")
vim.keymap.set("c", "%s/", "%sm/")
vim.keymap.set("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/" <cr>')
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")
vim.keymap.set("n", "<left>", ":bp<cr>")
vim.keymap.set("n", "<right>", ":bn<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<leader>m", "ct_")
vim.keymap.set("", "<F1>", "<Esc>")
vim.keymap.set("i", "<F1>", "<Esc>")
vim.keymap.set("n", "<C-\\>", function()
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "compilation" then
			vim.api.nvim_set_current_win(w)
			return
		end
	end
end)

vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	command = "silent! lua vim.highlight.on_yank({ timeout = 500 })",
})
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			if not vim.fn.expand("%:p"):find(".git", 1, true) then
				vim.cmd("exe \"normal! g'\\\"\"")
			end
		end
	end,
})
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.orig", command = "set readonly" })
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.pacnew", command = "set readonly" })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fzf",
	callback = function(ev)
		vim.keymap.set("t", "<C-j>", function()
			vim.fn.chansend(vim.bo[ev.buf].channel, "\x0a")
		end, { buffer = ev.buf })
		vim.keymap.set("t", "<C-k>", function()
			vim.fn.chansend(vim.bo[ev.buf].channel, "\x0b")
		end, { buffer = ev.buf })
	end,
})

local email = vim.api.nvim_create_augroup("email", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "/tmp/mutt*",
	group = email,
	command = "setfiletype mail",
})
vim.api.nvim_create_autocmd("Filetype", {
	pattern = "mail",
	group = email,
	command = "setlocal formatoptions+=w",
})

local text = vim.api.nvim_create_augroup("text", { clear = true })
for _, pat in ipairs({ "text", "markdown", "mail", "gitcommit" }) do
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = pat,
		group = text,
		command = "setlocal spell tw=72 colorcolumn=73",
	})
end
vim.api.nvim_create_autocmd("Filetype", {
	pattern = "tex",
	group = text,
	command = "setlocal spell tw=80 colorcolumn=81",
})

local CompileMode = {}
do
	local history_file = vim.fn.stdpath("data") .. "/compile_history"
	local history = {}

	local function load_history()
		local f = io.open(history_file, "r")
		if not f then
			return
		end
		for line in f:lines() do
			if line ~= "" then
				table.insert(history, line)
			end
		end
		f:close()
	end

	local function save_history(cmd)
		for i, v in ipairs(history) do
			if v == cmd then
				table.remove(history, i)
				break
			end
		end
		table.insert(history, 1, cmd)
		while #history > 10000 do
			table.remove(history)
		end
		local f = io.open(history_file, "w")
		if not f then
			return
		end
		for _, v in ipairs(history) do
			f:write(v .. "\n")
		end
		f:close()
	end

	local function run(cmd)
		save_history(cmd)
		vim.api.nvim_cmd({ cmd = "Compile", args = { cmd } }, {})
	end

	function CompileMode.compile(default)
		local last = default or vim.g.compile_command or ""
		local cmd = vim.fn.input({ prompt = "Compile: ", default = last, completion = "shellcmd" })
		if cmd == "" then
			return
		end
		run(cmd)
	end

	function CompileMode.history()
		if #history == 0 then
			vim.notify("No compile history", vim.log.levels.INFO)
			return
		end
		require("fzf-lua").fzf_exec(history, {
			prompt = "Compile History> ",
			actions = {
				["default"] = function(selected)
					CompileMode.compile(selected[1])
				end,
			},
		})
	end

	local function jump_to_code()
		for _, w in ipairs(vim.api.nvim_list_wins()) do
			if vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= "compilation" then
				vim.api.nvim_set_current_win(w)
				return
			end
		end
	end

	local function setup_buf(ev)
		local MAX_LINES = 5000
		local timer = vim.uv.new_timer()
		timer:start(
			0,
			300,
			vim.schedule_wrap(function()
				if not vim.api.nvim_buf_is_valid(ev.buf) then
					timer:stop()
					timer:close()
					return
				end
				local count = vim.api.nvim_buf_line_count(ev.buf)
				if count > MAX_LINES * 2 then
					vim.api.nvim_buf_set_lines(ev.buf, 0, count - MAX_LINES, false, {})
				end
			end)
		)

		vim.api.nvim_create_autocmd("BufDelete", {
			buffer = ev.buf,
			once = true,
			callback = function()
				timer:stop()
				timer:close()
			end,
		})

		vim.keymap.set("n", "<cr>", function()
			local line = vim.api.nvim_get_current_line()
			local file, lnum, col = line:match("%-%->%s+(.+):(%d+):(%d+)")
			if not file then
				file, lnum = line:match("%-%->%s+(.+):(%d+)")
			end
			if not file then
				file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+error")
			end
			if not file then
				file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+warning")
			end
			if not file then
				return
			end

			local compile_win = vim.api.nvim_get_current_win()
			local target_win = nil
			for _, w in ipairs(vim.api.nvim_list_wins()) do
				if w ~= compile_win then
					local buf = vim.api.nvim_win_get_buf(w)
					if vim.bo[buf].filetype ~= "compilation" then
						target_win = w
						if vim.api.nvim_buf_get_name(buf):find(file, 1, true) then
							break
						end
					end
				end
			end

			if target_win then
				vim.api.nvim_set_current_win(target_win)
			else
				vim.cmd("wincmd p")
			end
			vim.cmd("e " .. file)
			if lnum then
				vim.api.nvim_win_set_cursor(0, { tonumber(lnum), col and (tonumber(col) - 1) or 0 })
			end
		end, { buffer = true, silent = true })

		vim.keymap.set("n", "<C-q>", "<cmd>QuickfixErrors<cr><cmd>copen<cr>", { buffer = true, silent = true })
		vim.keymap.set("n", "<C-\\>", jump_to_code, { buffer = true, silent = true })

		vim.keymap.set("n", "i", function()
			local job = vim.g.compile_job_id
			if not job then
				vim.notify("No running compilation job", vim.log.levels.WARN)
				return
			end
			local ok, line = pcall(vim.fn.input, "stdin> ")
			if not ok then
				return
			end
			vim.fn.chansend(job, line .. "\n")
		end, { buffer = true, silent = true, desc = "Send input to running program" })

		vim.keymap.set("n", "<C-d>", function()
			local job = vim.g.compile_job_id
			if job then
				vim.fn.chanclose(job, "stdin")
			end
		end, { buffer = true, silent = true, desc = "Send EOF to running program" })
	end

	function CompileMode.setup()
		vim.g.compile_mode = {
			recompile_no_fail = true,
			use_pseudo_terminal = true,
			baleia_setup = true,
			environment = { MANPAGER = "col -b", PAGER = "col -b" },
		}
		load_history()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "compilation",
			callback = setup_buf,
		})
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"wincent/base16-nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox-dark-hard]])
			vim.o.background = "dark"
			vim.cmd([[hi Normal ctermbg=NONE]])
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = 1250067 })
			local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = pmenu.bg })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = pmenu.bg, fg = 1250067 })
			vim.o.winborder = "rounded"
			local bools = vim.api.nvim_get_hl(0, { name = "Boolean" })
			vim.api.nvim_set_hl(0, "Comment", bools)
			vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
				fg = pmenu.fg,
				bg = pmenu.bg,
				ctermfg = pmenu.ctermfg,
				ctermbg = pmenu.ctermbg,
				bold = true,
			})
		end,
	},
	{
		"itchyny/lightline.vim",
		lazy = false,
		config = function()
			vim.o.showmode = false
			vim.g.lightline = {
				active = {
					left = {
						{ "mode", "paste" },
						{ "readonly", "filename", "modified" },
					},
					right = {
						{ "lineinfo" },
						{ "percent" },
						{ "fileencoding", "filetype" },
					},
				},
				component_function = {
					filename = "LightlineFilename",
				},
			}
			function LightlineFilenameInLua()
				if vim.fn.expand("%:t") == "" then
					return "[No Name]"
				else
					return vim.fn.getreg("%")
				end
			end
			vim.api.nvim_exec(
				[[
				function! g:LightlineFilename()
					return v:lua.LightlineFilenameInLua()
				endfunction
				]],
				true
			)
		end,
	},
	{
		"https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
		end,
	},
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = {}
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {
			mappings = {
				enabled = true,
				toggle = false,
				toggleLeftSide = false,
				toggleRightSide = false,
				widthUp = false,
				widthDown = false,
				scratchPad = false,
			},
		},
		config = function()
			vim.keymap.set("", "<leader>t", function()
				vim.cmd([[
					:NoNeckPain
					:set formatoptions-=tc linebreak tw=0 cc=0 wrap wm=20 noautoindent nocindent nosmartindent indentkeys=
				]])
				vim.keymap.set("n", "0", "g0")
				vim.keymap.set("n", "$", "g$")
				vim.keymap.set("n", "^", "g^")
			end)
		end,
	},
	{
		"notjedi/nvim-rooter.lua",
		config = function()
			require("nvim-rooter").setup()
		end,
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("fzf-lua").setup({
				winopts = {
					split = "belowright 10new",
					preview = {
						hidden = true,
					},
				},
				files = {
					file_icons = false,
					git_icons = true,
					_fzf_nth_devicons = true,
				},
				buffers = {
					file_icons = false,
					git_icons = true,
				},
				fzf_opts = {
					["--layout"] = "default",
				},
			})
			vim.keymap.set("", "<C-p>", function()
				local opts = {}
				opts.cmd = "fd --color=never --hidden --type f --type l --exclude .git"
				local base = vim.fn.fnamemodify(vim.fn.expand("%"), ":h:.:S")
				if base ~= "." and vim.fn.executable("proximity-sort") == 1 then
					opts.cmd = opts.cmd .. (" | proximity-sort %s"):format(vim.fn.shellescape(vim.fn.expand("%")))
				end
				opts.fzf_opts = {
					["--scheme"] = "path",
					["--tiebreak"] = "index",
					["--layout"] = "default",
				}
				require("fzf-lua").files(opts)
			end)
			vim.keymap.set("n", "<leader>;", function()
				require("fzf-lua").buffers({
					fzf_opts = {
						["--with-nth"] = "{-3..-2}",
						["--nth"] = "-1",
						["--delimiter"] = "[:\u{2002}]",
						["--header-lines"] = "false",
					},
					header = false,
				})
			end)
		end,
	},
	{
		"ej-shafran/compile-mode.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
		cmd = { "Compile", "Recompile" },
		keys = {
			{ "<leader>cc", function() CompileMode.compile() end },
			{ "<leader>ch", function() CompileMode.history() end },
			{ "<leader>cr", "<cmd>Recompile<cr>" },
		},
		config = function()
			CompileMode.setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"refractalize/oil-git-status.nvim",
		},
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Oil<cr>" },
		},
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				view_options = { show_hidden = true },
				win_options = { signcolumn = "yes:2" },
			})
			require("oil-git-status").setup({})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all",
						},
						checkOnSave = {
							enable = true,
						},
						check = {
							command = "clippy",
						},
						imports = {
							group = {
								enable = false,
							},
						},
						completion = {
							postfix = {
								enable = false,
							},
						},
					},
				},
			})
			vim.lsp.enable("rust_analyzer")

			if vim.fn.executable("bash-language-server") == 1 then
				vim.lsp.enable("bashls")
			end
			if vim.fn.executable("texlab") == 1 then
				vim.lsp.enable("texlab")
			end
			if vim.fn.executable("ruff") == 1 then
				vim.lsp.enable("ruff")
			end
			if vim.fn.executable("nil") == 1 then
				vim.lsp.enable("nil_ls")
			end
			if vim.fn.executable("typescript-language-server") == 1 then
				vim.lsp.enable("ts_ls")
			end
			if vim.fn.executable("clangd") == 1 then
				vim.lsp.enable("clangd")
			end

			vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
					end

					client.server_capabilities.semanticTokensProvider = nil

					if client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
							buffer = ev.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = ev.buf })
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "path" },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}),
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup({
				doc_lines = 0,
				handler_opts = {
					border = "none",
				},
			})
		end,
	},
	{
		"hashivim/vim-terraform",
		ft = { "terraform" },
	},
	{
		"evanleck/vim-svelte",
		ft = { "svelte" },
	},
	"cespare/vim-toml",
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"lervag/vimtex",
		ft = { "tex" },
		lazy = false,
		init = function()
			vim.g.vimtex_mappings_enabled = false
		end,
	},
	"khaveesh/vim-fish-syntax",
	{
		"plasticboy/vim-markdown",
		ft = { "markdown" },
		dependencies = {
			"godlygeek/tabular",
		},
		config = function()
			vim.g.vim_markdown_folding_disabled = 1
			vim.g.vim_markdown_frontmatter = 1
			vim.g.vim_markdown_new_list_item_indent = 0
			vim.g.vim_markdown_auto_insert_bullets = 0
		end,
	},
})

local wk = require("which-key")

wk.register({
	f = {
		name = "Find",
		f = { "Find File" },
		b = { "Find Buffer" },
		h = { "Find Help" },
		w = { "Find Text" },
	},
	b = { "Toggle BreakPoint" },
	B = { "Set BreakPoint" },
	p = { "Paste" },
	y = { "Copy" },
	e = { "File Manager" },
	o = { "Git status" },
	x = { "Close Buffer" },
	w = { "Save" },
	t = { name = "Terminal", f = { "Float terminal" }, h = { "Horizontal terminal" } },
	h = { "No highlight" },
	g = { name = "Git", b = "Branches", c = "Commits", s = "Status" },
	c = { name = "Comment", l = "Comment Line" },
	l = {
		name = "LSP",
		d = "Diagnostic",
		D = "Hover diagnostic",
		f = "Format",
		r = "Rename",
		a = "Action",
		s = "Symbol",
	},
	m = {
		-- Typical cmake workflow:
		-- 1. CMake configure (only once)
		-- 2. CMake selec_target (ususally once)
		-- 3. CMake build (once change, build it)
		name = "CMake",
		g = { "<cmd>CMakeGenerate<CR>", "Generate" },
		x = { "<cmd>CMakeGenerate!<CR>", "Clean and Generate" },
		b = { "<cmd>CMakeBuild<CR>", "Build" },
		r = { "<cmd>CMakeRun<CR>", "Run" },
		d = { "<cmd>CMakeDebug<CR>", "Debug" },
		y = { "<cmd>CMakeSelectBuildType<CR>", "Select Build Type" },
		t = { "<cmd>CMakeSelectBuildTarget<CR>", "Select Build Target" },
		l = { "<cmd>CMakeSelectLaunchTarget<CR>", "Select Launch Target" },
		o = { "<cmd>CMakeOpen<CR>", "Open CMake Console" },
		c = { "<cmd>CMakeClose<CR>", "Close CMake Console" },
		i = { "<cmd>CMakeInstall<CR>", "Intall CMake target" },
		n = { "<cmd>CMakeClean<CR>", "Clean CMake target" },
		s = { "<cmd>CMakeStop<CR>", "Stop CMake Process" },
	},
}, { prefix = "<leader>" })

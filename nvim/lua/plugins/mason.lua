require("mason").setup()

require("mason-tool-installer").setup({
    ensure_installed = {
        "yapf",
        "basedpyright",
        "pylint",
        "beautysh",
        "neocmakelsp",
        "stylua", },     -- auto-install ruff
    auto_update = true,  -- check for updates on startup
    run_on_start = true, -- install missing tools on startup
    start_delay = 3000,  -- delay ms before running installer (optional)
})

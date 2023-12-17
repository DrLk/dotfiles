local leap = require('leap')
leap.add_default_mappings()
leap.add_repeat_mappings(';', ',', {
    -- False by default. If set to true, the keys will work like the
    -- native semicolon/comma, i.e., forward/backward is understood in
    -- relation to the last motion.
    relative_directions = true,
    -- By default, all modes are included.
    modes = { 'n', 'x', 'o' },
})

local flit = require('flit')
flit.setup({
    keys = { f = 'f', F = 'F', t = 't', T = 'T' },
    -- A string like "nv", "nvo", "o", etc.
    labeled_modes = "nvo",
    multiline = true,
    -- Like `leap`s similar argument (call-specific overrides).
    -- E.g.: opts = { equivalence_classes = {} }
    opts = {}
})

local leap = require('leap')
leap.add_default_mappings()
leap.add_repeat_mappings(';', ',', {
    -- False by default. If set to true, the keys will work like the
    -- native semicolon/comma, i.e., forward/backward is understood in
    -- relation to the last motion.
    relative_directions = true,
    -- By default, all modes are included.
    modes = { 'n', 'v', 'x', 'o' },
})

local map = vim.keymap.set

map({ 'n', 'v' }, 'f', function() leap.leap({ inputlen = 1 }) end, { desc = 'Leap forward search' })
map({ 'n', 'v' }, 'F', function() leap.leap({ inputlen = 1, backward = true  }) end, { desc = 'Leap backward search' })
map({ 'n', 'v' }, 't', function() leap.leap({ inputlen = 1 }) end, { desc = 'Leap forward with ahead search' })
map({ 'n', 'v' }, 'T', function() leap.leap({ inputlen = 1, backward = true  }) end, { desc = 'Leap backward with ahead search' })

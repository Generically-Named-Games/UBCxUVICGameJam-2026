--[[
FILE_NAME = "waves"
PURPOSE: PREMADE WAVE DEFINITIONS
STRUCTURE:
    Each wave is a table of spawn entries:
    { name = "enemy_type", delay = seconds_after_wave_start }

USAGE:
    local WaveData = require("data/waves")
    local wave = WaveData[1]  -- get wave 1
    for _, entry in ipairs(wave) do
        -- entry.name, entry.delay
    end
]]

local waves = {
	-- WAVE 1: Tutorial wave, just a few slow bugs
	{
		{ name = "bug", delay = 0 },
		{ name = "bug", delay = 2 },
		{ name = "bug", delay = 4 },
	},

	-- WAVE 2: More bugs, slightly faster
	{
		{ name = "bug", delay = 0 },
		{ name = "bug", delay = 1.5 },
		{ name = "bug", delay = 3 },
		{ name = "small_bug", delay = 4 },
		{ name = "small_bug", delay = 5 },
	},

	-- WAVE 3: Introduction of small bugs
	{
		{ name = "small_bug", delay = 0 },
		{ name = "small_bug", delay = 0.8 },
		{ name = "small_bug", delay = 1.6 },
		{ name = "bug", delay = 3 },
		{ name = "bug", delay = 4.5 },
		{ name = "bug", delay = 6 },
	},

	-- WAVE 4: First flying bugs
	{
		{ name = "bug", delay = 0 },
		{ name = "bug", delay = 1.5 },
		{ name = "flying_bug", delay = 2 },
		{ name = "flying_bug", delay = 3 },
		{ name = "small_bug", delay = 4 },
		{ name = "small_bug", delay = 4.5 },
	},

	-- WAVE 5: Mixed swarm
	{
		{ name = "small_bug", delay = 0 },
		{ name = "small_bug", delay = 0.5 },
		{ name = "small_bug", delay = 1 },
		{ name = "flying_bug", delay = 1.5 },
		{ name = "flying_bug", delay = 2 },
		{ name = "bug", delay = 3 },
		{ name = "bug", delay = 4 },
		{ name = "bug", delay = 5 },
	},

	-- WAVE 6: Flying bug swarm
	{
		{ name = "flying_bug", delay = 0 },
		{ name = "flying_bug", delay = 0.8 },
		{ name = "flying_bug", delay = 1.6 },
		{ name = "flying_bug", delay = 2.4 },
		{ name = "bug", delay = 4 },
		{ name = "bug", delay = 5 },
		{ name = "small_bug", delay = 5.5 },
		{ name = "small_bug", delay = 6 },
	},

	-- WAVE 7: Double trouble
	{
		{ name = "bug", delay = 0 },
		{ name = "small_bug", delay = 0 },
		{ name = "bug", delay = 1.5 },
		{ name = "small_bug", delay = 1.5 },
		{ name = "flying_bug", delay = 2 },
		{ name = "flying_bug", delay = 2.5 },
		{ name = "bug", delay = 4 },
		{ name = "bug", delay = 5 },
		{ name = "bug", delay = 6 },
	},

	-- WAVE 8: Small bug blitz
	{
		{ name = "small_bug", delay = 0 },
		{ name = "small_bug", delay = 0.3 },
		{ name = "small_bug", delay = 0.6 },
		{ name = "small_bug", delay = 0.9 },
		{ name = "small_bug", delay = 1.2 },
		{ name = "flying_bug", delay = 2 },
		{ name = "flying_bug", delay = 2.5 },
		{ name = "flying_bug", delay = 3 },
		{ name = "bug", delay = 5 },
		{ name = "bug", delay = 6 },
	},

	-- WAVE 9: Full swarm
	{
		{ name = "bug", delay = 0 },
		{ name = "small_bug", delay = 0.5 },
		{ name = "flying_bug", delay = 1 },
		{ name = "bug", delay = 1.5 },
		{ name = "small_bug", delay = 2 },
		{ name = "flying_bug", delay = 2.5 },
		{ name = "bug", delay = 3 },
		{ name = "small_bug", delay = 3.5 },
		{ name = "flying_bug", delay = 4 },
		{ name = "bug", delay = 5 },
		{ name = "bug", delay = 6 },
	},

	-- WAVE 10: Final boss wave
	{
		{ name = "flying_bug", delay = 0 },
		{ name = "flying_bug", delay = 0.5 },
		{ name = "flying_bug", delay = 1 },
		{ name = "small_bug", delay = 1 },
		{ name = "small_bug", delay = 1.3 },
		{ name = "small_bug", delay = 1.6 },
		{ name = "bug", delay = 2 },
		{ name = "bug", delay = 2.5 },
		{ name = "bug", delay = 3 },
		{ name = "flying_bug", delay = 4 },
		{ name = "flying_bug", delay = 4.5 },
		{ name = "small_bug", delay = 5 },
		{ name = "small_bug", delay = 5.3 },
		{ name = "small_bug", delay = 5.6 },
		{ name = "bug", delay = 6 },
		{ name = "bug", delay = 6.5 },
		{ name = "bug", delay = 7 },
	},
}

return waves

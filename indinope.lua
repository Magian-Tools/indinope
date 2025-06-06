---@diagnostic disable: undefined-global
addon.name = 'indinope'
addon.author = 'ThornyFFXI (Ported by Lili, Ported by Arkevorkhat)'
addon.version = '0.1'
addon.desc = 'Disables indicolure visual effects'
addon.link = 'https://github.com/Magian-Tools/indinope'

local ffi = require('ffi')
local jit = require('jit')
require('common')

jit.on()

local offsets = T{[0x00D] = 0x42, [0x00E] = 0x34,  [0x037] = 88}

ashita.events.register('packet_in', 'packet_in_cb', function(e)
    if (e.blocked or not offsets:containskey(e.id)) then return end
    
    local offset = offsets[e.id]
    local pointer = ffi.cast('uint8_t*', e.data_modified_raw) -- gets entire packet struct
    if e.id == 0x00E then
        pointer[offset] = bit.band(pointer[offset], 0xF7)
    elseif bit.band(pointer[offset], 0x7F) then -- check if any of the first 3 bits are set
        pointer[offset] = bit.band(pointer[offset], 0x80)
    end
end)

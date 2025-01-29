if SDM_0s_Stuff_Config.sdm_jokers then
    -- Loading meme jokers into Cryptid's "Meme packs"
    for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
        Cryptid.memepack[#Cryptid.memepack+1] = k
    end

    -- Loading food jokers into Cryptid's "://SPAGHETTI" pool
    for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
        Cryptid.food[#Cryptid.food+1] = k
    end
end

if SDM_0s_Stuff_Config.sdm_vouchers then

    -- Oblivion

    SMODS.Voucher{
        key = 'oblivion',
        name = 'Oblivion',
        pos = {x = 0, y = 2},
        config = {extra = 5},
        requires = {"v_sdm_eclipse"},
        loc_vars = function(self, info_queue, card)
            return {vars = {math.max(1, self.config.extra)}}
        end,
        calculate = function(self, card, context)
            if context.end_of_round and not (context.individual or context.repetition) then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_negative'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end,
        atlas = "sdm_vouchers"
    }

    SDM_0s_Stuff_Mod.modded_objects.v_sdm_oblivion = "Oblivion"
    Cryptid.Megavouchers[#Cryptid.Megavouchers + 1] = "v_sdm_oblivion"
end
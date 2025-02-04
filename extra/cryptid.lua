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

    -- Oblivion --

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

    if SDM_0s_Stuff_Config.sdm_bakery then

        -- Bakery Acclimator --

        -- TODO: Update voucher to fit with the other Cryptud "acclimator" voucher theme
        SMODS.Voucher{
            key = 'bakery_acclimator',
            name = 'Bakery Acclimator',
            pos = {x = 0, y = 2},
            requires = {"v_sdm_bakery_tycoon"},
            config = {extra = 24 / 4, extra_disp = 6},
            loc_vars = function(self, info_queue, card)
                return {vars = {card.ability.extra_disp}}
            end,
            redeem = function(self, card)
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.bakery_rate = 4 * (card and card.ability and card.ability.extra or self.config.extra)
                return true end}))
            end,
            atlas = "sdm_bakery_vouchers"
        }

        SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_acclimator = "Bakery Acclimator"
        Cryptid.Megavouchers[#Cryptid.Megavouchers + 1] = "v_sdm_bakery_acclimator"
    end
end
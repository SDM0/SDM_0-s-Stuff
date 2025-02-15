if SDM_0s_Stuff_Config.sdm_jokers then
    -- Loading meme jokers into Cryptid's "Meme packs"
    if SMODS.ObjectTypes["Meme"] then
        for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
            SMODS.ObjectTypes["Meme"]:inject_card(k)
        end
    end

    -- Loading food jokers into Cryptid's "://SPAGHETTI" pool
    if SMODS.ObjectTypes["Food"] then
        for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
            SMODS.ObjectTypes["Food"]:inject_card(k)
        end
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
            if context.end_of_round and context.main_eval then
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
    SDM_0s_Stuff_Mod.tier3_vouchers.v_sdm_oblivion = "Oblivion"

    if SDM_0s_Stuff_Config.sdm_bakery then

        -- Bakery Acclimator --

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
                    G.GAME.bakery_rate = 4 * card.ability.extra
                return true end}))
            end,
            atlas = "sdm_bakery_vouchers"
        }

        SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_acclimator = "Bakery Acclimator"
        SDM_0s_Stuff_Mod.tier3_vouchers.v_sdm_bakery_acclimator = "Bakery Acclimator"
    end

    if SMODS.ObjectTypes["Tier3"] then
        for k, _ in pairs(SDM_0s_Stuff_Mod.tier3_vouchers) do
            SMODS.ObjectTypes["Tier3"]:inject_card(k)
        end
    end
end
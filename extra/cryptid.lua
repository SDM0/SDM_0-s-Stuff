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

-- TODO: Add Cryptid items to their corresponding SMODS.ContentSet

if SDM_0s_Stuff_Config.sdm_bakery then

    -- Bread Bites --

    SMODS.Bakery{
        key = 'bread_bites',
        name = 'Bread Bites',
        pos = {x = 0, y = 0},
        config = {extra = {amount = 1, remaining = 2}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
        end,
        calculate = function(self, card, context)
            if context.setting_blind and no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                SMODS.add_card({set = 'Code', key_append = 'bpg'})
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize('k_plus_code'),
                            colour = G.C.SECONDARY_SET.Code,
                        })
                    end
                end
                decrease_remaining_food(card)
            end
        end,
    }

    SDM_0s_Stuff_Mod.modded_objects.c_sdm_bread_bites = "Bread Bites"
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

        -- Bakery Factory --

        SMODS.Voucher{
            key = 'bakery_factory',
            name = 'Bakery Factory',
            pos = {x = 0, y = 2},
            requires = {"v_sdm_bakery_shop"},
            redeem = function(self, card)
                for _, v in ipairs(G.consumeables.cards) do
                    if v.config.center.set == "Bakery" then
                        v.ability.extra.amount = v.ability.extra.amount * 2
                    end
                end
                -- Future Bakery goods boost handled in SMODS.Bakery
            end,
            atlas = "sdm_bakery_vouchers"
        }

        SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_factory = "Bakery Factory"
        SDM_0s_Stuff_Mod.tier3_vouchers.v_sdm_bakery_factory = "Bakery Factory"
    end

    if SMODS.ObjectTypes["Tier3"] then
        for k, _ in pairs(SDM_0s_Stuff_Mod.tier3_vouchers) do
            SMODS.ObjectTypes["Tier3"]:inject_card(k)
        end
    end
end
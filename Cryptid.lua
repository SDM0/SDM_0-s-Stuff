local sdm_bakery_consumables = {
    object_type = "Atlas",
	key = "sdm_bakery_consumables",
    path = "bakery/sdm_bakery_consumables.png",
    px = 71,
    py = 95
}

local sdm_vouchers = {
    object_type = "Atlas",
	key = "sdm_vouchers",
    path = "sdm_vouchers.png",
    px = 71,
    py = 95
}

local sdm_bakery_vouchers = {
    object_type = "Atlas",
    key = "sdm_bakery_vouchers",
    path = "bakery/sdm_bakery_vouchers.png",
    px = 71,
    py = 95
}

local items = {sdm_bakery_consumables, sdm_vouchers, sdm_bakery_vouchers}

if SDM_0s_Stuff_Config.sdm_bakery then

    -- Bread Bites --

    local bread_bites = {
        cry_credits = {
            idea = {
                "SDM_0",
            },
            art = {
                "SDM_0",
            },
            code = {
                "SDM_0",
            },
        },
        dependencies = {
            items = {
                "set_cry_code",
            },
        },
        object_type = "Consumable",
        set = "Bakery",
        key = "bread_bites",
        name = "Bread Bites",
        atlas = "sdm_bakery_consumables",
        pos = {x = 5, y = 1},
        config = {extra = {amount = 1, remaining = 2}},
        cost = 4,
        can_bulk_use = false,
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.amount, card.ability.extra.remaining}}
        end,
        can_use = function(self, card)
            return false
        end,
        calculate = function(self, card, context)
            if context.setting_blind and no_bp_retrigger(context) then
                for i = 1, card.ability.extra.amount do
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
                decrease_remaining_food(card)
            end
        end,
    }

    SDM_0s_Stuff_Mod.modded_objects.c_sdm_bread_bites = "Bread Bites"

    items[#items+1] = bread_bites
end

if SDM_0s_Stuff_Config.sdm_vouchers then

    -- Oblivion --

    local oblivion = {
        cry_credits = {
            idea = {
                "SDM_0",
            },
            art = {
                "SDM_0",
            },
            code = {
                "SDM_0",
            },
        },
        dependencies = {
            items = {
                "set_cry_tier3",
            },
        },
        object_type = "Voucher",
        key = 'oblivion',
        name = 'Oblivion',
        pos = {x = 0, y = 2},
        requires = {"v_sdm_eclipse"},
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

    items[#items+1] = oblivion

    SDM_0s_Stuff_Mod.modded_objects.v_sdm_oblivion = "Oblivion"
    SDM_0s_Stuff_Mod.tier3_vouchers.v_sdm_oblivion = "Oblivion"

    if SDM_0s_Stuff_Config.sdm_bakery then

        -- Bakery Factory --

        local bakery_factory = {
            cry_credits = {
                idea = {
                    "SDM_0",
                },
                art = {
                    "SDM_0",
                },
                code = {
                    "SDM_0",
                },
            },
            dependencies = {
                items = {
                    "set_cry_tier3",
                },
            },
            object_type = "Voucher",
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

        items[#items+1] = bakery_factory

        SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_factory = "Bakery Factory"
        SDM_0s_Stuff_Mod.tier3_vouchers.v_sdm_bakery_factory = "Bakery Factory"
    end

end

return {
    init = function()
        if SDM_0s_Stuff_Config.sdm_jokers then
            -- Loading meme jokers into Cryptid's "Meme packs"
            for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
                SMODS.Centers[k].pools = {["Meme"] = true}
            end

            -- Loading food jokers into Cryptid's "Food packs"
            for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
                SMODS.Centers[k].pools = {["Food"] = true}
            end
        end
    end,
    items = items
}
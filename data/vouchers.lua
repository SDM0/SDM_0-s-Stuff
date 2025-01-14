SMODS.Atlas{
    key = "sdm_vouchers",
    path = "sdm_vouchers.png",
    px = 71,
    py = 95
}

--- Joker Voucher

SMODS.Voucher{
    key = 'joker_voucher',
    name = 'Joker Voucher',
    pos = {x = 0, y = 0},
    in_pool = function()
        return false
    end,
    no_collection = true,
    atlas = "sdm_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_joker_voucher = "Joker Voucher"

-- Shadow

SMODS.Voucher{
    key = 'shadow',
    name = 'Shadow',
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker
    end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            local eligible_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and not v.edition then
                    table.insert(eligible_jokers, v)
                end
            end
            if #eligible_jokers > 0 then
                local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('sdw'))
                chosen_joker:set_edition("e_negative", true)
            else
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, "j_joker", 'elp')
                card:set_edition("e_negative", true)
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
            end
            return true
        end}))
    end,
    atlas = "sdm_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_shadow = "Shadow"

-- Eclipse

SMODS.Voucher{
    key = 'eclipse',
    name = 'Eclipse',
    pos = {x = 0, y = 1},
    requires = {"v_sdm_shadow"},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker
    end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            local eligible_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and not v.edition then
                    table.insert(eligible_jokers, v)
                end
            end
            if #eligible_jokers > 0 then
                local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('sdw'))
                chosen_joker:set_edition("e_negative", true)
            else
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, "j_joker", 'elp')
                card:set_edition("e_negative", true)
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
            end
            return true
        end}))
    end,
    atlas = "sdm_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_eclipse = "Eclipse"
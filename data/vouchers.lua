SMODS.Atlas{
    key = "sdm_vouchers",
    path = "sdm_vouchers.png",
    px = 71,
    py = 95
}

-- Shadow

SMODS.Voucher{
    key = 'shadow',
    name = 'Shadow',
    pos = {x = 0, y = 0},
    config = {extra = {jkr_slots = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.jkr_slots}}
    end,
    redeem = function(self)
        local eligible_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and not v.edition then
                table.insert(eligible_jokers, v)
            end
        end
        if #eligible_jokers > 0 then
            local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('sdw'))
            chosen_joker:set_edition({negative = true}, true)
        end
        return true
    end,
    atlas = "sdm_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_shadow = "Shadow"

-- Eclipse

SMODS.Voucher{
    key = 'eclipse',
    name = 'Eclipse',
    pos = {x = 0, y = 1},
    requires = {"v_sdm_Shadow"},
    config = {extra = {jkr_slots = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.jkr_slots}}
    end,
    redeem = function(self)
        local eligible_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and not v.edition then
                table.insert(eligible_jokers, v)
            end
        end
        if #eligible_jokers > 0 then
            local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('sdw'))
            chosen_joker:set_edition({negative = true}, true)
        end
        return true
    end,
    atlas = "sdm_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_eclipse = "Eclipse"
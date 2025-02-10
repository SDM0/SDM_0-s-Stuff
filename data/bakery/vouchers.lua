SMODS.Atlas{
    key = "sdm_bakery_vouchers",
    path = "bakery/sdm_bakery_vouchers.png",
    px = 71,
    py = 95
}

-- Bakery Merchant

SMODS.Voucher{
    key = 'bakery_merchant',
    name = 'Bakery Merchant',
    pos = {x = 0, y = 0},
    config = {extra = 9.6 / 4, extra_disp = 2},
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

SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_merchant = "Bakery Merchant"

-- Bakery Tycoon

SMODS.Voucher{
    key = 'bakery_tycoon',
    name = 'Bakery Tycoon',
    pos = {x = 0, y = 1},
    requires = {"v_sdm_bakery_merchant"},
    config = {extra = 32 / 4, extra_disp = 4},
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

SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_tycoon = "Bakery Tycoon"
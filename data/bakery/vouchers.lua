SMODS.Atlas{
    key = "sdm_bakery_vouchers",
    path = "bakery/sdm_bakery_vouchers.png",
    px = 71,
    py = 95
}

-- Bakery Stall

SMODS.Voucher{
    key = 'bakery_stall',
    name = 'Bakery Stall',
    pos = {x = 0, y = 0},
    config = {extra = 2},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.bakery_rate = card.ability.extra
        return true end}))
    end,
    atlas = "sdm_bakery_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_stall = "Bakery Stall"

-- Bakery Shop

SMODS.Voucher{
    key = 'bakery_shop',
    name = 'Bakery Shop',
    pos = {x = 0, y = 1},
    redeem = function(self, card)
        for k, v in ipairs(G.consumeables.cards) do
            if v.config.center.set == "Bakery" then
                v.ability.extra.remaining = v.ability.extra.remaining * 2
            end
        end
        -- Future Bakery goods boost handled in SMODS.Bakery
    end,
    requires = {"v_sdm_bakery_stall"},
    atlas = "sdm_bakery_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_shop = "Bakery Shop"
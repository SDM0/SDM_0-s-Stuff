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
            G.GAME.bakery_rate = 2
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
    requires = {"v_sdm_bakery_stall"},
    -- redeem = function(self, card)
    --     for _, v in pairs(G.P_CENTERS) do
    --         if v.set == "Bakery" then
    --             v.config.extra.remaining = v.config.extra.remaining * 2
    --         end
    --     end
    -- end,
    atlas = "sdm_bakery_vouchers"
}

SDM_0s_Stuff_Mod.modded_objects.v_sdm_bakery_shop = "Bakery Shop"
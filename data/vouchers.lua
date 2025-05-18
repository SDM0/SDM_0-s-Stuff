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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_negative
    end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({
            func = (function()
                add_tag(Tag('tag_negative'))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
    end,
    atlas = "sdm_vouchers"
}

-- Eclipse

SMODS.Voucher{
    key = 'eclipse',
    name = 'Eclipse',
    pos = {x = 0, y = 1},
    requires = {"v_sdm_shadow"},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_negative
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if G.GAME.blind.boss then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_negative'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end,
    atlas = "sdm_vouchers"
}

-- Drought

SMODS.Voucher{
    key = 'drought',
    name = 'Drought',
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "undefined_standard_pack", set = "Other"}
    end,
    redeem = function(self)
        for _, v in pairs(G.P_CENTERS) do
            sdm_debug(v)
            if v.set and v.set == "Booster" and v.kind and v.kind == "Standard" then
                G.GAME.banned_keys[v.key] = true
            end
        end
        if G.shop_booster then
            sdm_debug("In shop")
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.shop_booster.cards, 1, -1 do
                        local _center = G.shop_booster.cards[i].config.center
                        sdm_debug(_center)
                        if G.GAME.banned_keys[_center.key] and (_center.kind and _center.kind == "Standard") then
                            G.shop_booster.cards[i]:remove()
                            SMODS.add_booster_to_shop()
                        end
                    end
                return true
            end}))
        end
    end,
    atlas = "sdm_vouchers"
}

-- Famine

SMODS.Voucher{
    key = 'famine',
    name = 'Famine',
    pos = {x = 1, y = 1},
    requires = {"v_sdm_drought"},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "undefined_buffoon_pack", set = "Other"}
    end,
    redeem = function(self)
        for _, v in pairs(G.P_CENTERS) do
            if v.set and v.set == "Booster" and v.kind and v.kind == "Buffoon" then
                G.GAME.banned_keys[v.key] = true
            end
        end
        if G.shop_booster then
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.shop_booster.cards, 1, -1 do
                        local _center = G.shop_booster.cards[i].config.center
                        if G.GAME.banned_keys[_center.key] and (_center.kind and _center.kind == "Buffoon") then
                            G.shop_booster.cards[i]:remove()
                            SMODS.add_booster_to_shop()
                        end
                    end
                return true
            end}))
        end
    end,
    atlas = "sdm_vouchers"
}

if JokerEvolution then

    --- Joker Voucher

    SMODS.Voucher{
        key = 'joker_voucher',
        name = 'Joker Voucher',
        pos = {x = 2, y = 0},
        config = {extra = {Xmult_mod = 0.5}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.Xmult_mod, 1 + (G.vouchers and #G.vouchers.cards or 0) * card.ability.extra.Xmult_mod}}
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local xmlt = 1 + (#G.vouchers.cards or 0) * card.ability.extra.Xmult_mod
                if xmlt > 1 then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={xmlt}},
                        Xmult_mod = xmlt,
                    }
                end
            end
        end,
        in_pool = function()
            return false
        end,
        no_collection = true,
        atlas = "sdm_vouchers"
    }
end
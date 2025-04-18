SMODS.Atlas {
    key = "sdm_colours",
    path = "sdm_colours.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
    key = "caramel",
    name = "col_Caramel",
    set = "Colour",
    pos = { x = 0, y = 1 },
    config = {
        val = 0,
        partial_rounds = 0,
        upgrade_rounds = 3,
    },
    cost = 4,
    atlas = "sdm_colours",
    unlocked = true,
    discovered = true,
    display_size = { w = 71, h = 87 },
    pixel_size = { w = 71, h = 87 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        for i = 1, card.ability.val do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    local _card = create_card("Bakery", G.consumeables, nil, nil, nil, nil, nil, "caramel")
                    _card:add_to_deck()
                    _card:set_edition({ negative = true }, true)
                    G.consumeables:emplace(_card)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
        local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
        return { vars = { card.ability.val, val, max, card.ability.upgrade_rounds } }
    end,
    dependencies = "MoreFluff"
}

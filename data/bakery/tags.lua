SMODS.Atlas{
    key = "sdm_bakery_tags",
    path = "bakery/sdm_bakery_tags.png",
    px = 34,
    py = 34,
}

SMODS.Tag{
    key = 'flour',
    name = 'Flour Tag',
    pos = {x = 0, y = 0},
    min_ante = 2,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE,function()
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_sdm_bakery_jumbo_1'], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    atlas = "sdm_bakery_tags"
}
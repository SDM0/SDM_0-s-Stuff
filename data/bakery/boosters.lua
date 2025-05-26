SMODS.Atlas{
    key = "sdm_bakery_boosters",
    path = "bakery/sdm_bakery_boosters.png",
    px = 71,
    py = 95
}

SMODS.Sound{
    key = "sdm_bakery_doorbell",
    path = "doorbell.ogg"
}

SMODS.Booster{
    key = 'bakery_normal_1',
    name = 'Bakery Pack',
    pos = {x = 0, y = 0},
    cost = 4,
    config = {extra = 3, choose = 1},
    group_key = 'k_bakery_pack',
    create_card = function(self, card, i)
        return {set = "Bakery", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "bkr"}
    end,
    weight = 0.3,
    kind = 'Bakery',
    atlas = "sdm_bakery_boosters"
}

SMODS.Booster{
    key = 'bakery_normal_2',
    name = 'Bakery Pack',
    pos = {x = 1, y = 0},
    cost = 4,
    config = {extra = 3, choose = 1},
    group_key = 'k_bakery_pack',
    create_card = function(self, card, i)
        return {set = "Bakery", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "bkr"}
    end,
    weight = 0.3,
    kind = 'Bakery',
    atlas = "sdm_bakery_boosters"
}

SMODS.Booster{
    key = 'bakery_jumbo_1',
    name = 'Jumbo Bakery Pack',
    pos = {x = 2, y = 0},
    cost = 4,
    config = {extra = 5, choose = 1},
    group_key = 'k_bakery_pack',
    create_card = function(self, card, i)
        return {set = "Bakery", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "bkr"}
    end,
    weight = 0.3,
    kind = 'Bakery',
    atlas = "sdm_bakery_boosters"
}

SMODS.Booster{
    key = 'bakery_mega_1',
    name = 'Mega Bakery Pack',
    pos = {x = 3, y = 0},
    cost = 8,
    config = {extra = 5, choose = 2},
    group_key = 'k_bakery_pack',
    create_card = function(self, card, i)
        return {set = "Bakery", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "bkr"}
    end,
    weight = 0.07,
    kind = 'Bakery',
    atlas = "sdm_bakery_boosters"
}
--- Challenges ---

-- TODO: Finish challenges update

--- Scientific Downfall ---

SMODS.Challenge{
    loc_txt = "Scientific Downfall",
    key = 'scientific_downfall',
    rules = {
        custom = {
            {id = 'no_shop_planets'},
        },
        modifiers = {
            {id = 'discards', value = 4},
            {id = 'hands', value = 2},
        },
    },
    jokers = {
        {id = 'j_sdm_la_revolution', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'c_high_priestess'},
            {id = 'c_black_hole'},
            {id = 'c_trance'},
            {id = 'p_celestial_normal_1', ids = {
                'p_celestial_normal_1','p_celestial_normal_2','p_celestial_normal_3','p_celestial_normal_4','p_celestial_jumbo_1','p_celestial_jumbo_2','p_celestial_mega_1','p_celestial_mega_2',
            }},
            {id = 'j_8_ball'},
            {id = 'j_space'},
            {id = 'j_constellation'},
            {id = 'j_certificate'},
            {id = 'j_satellite'},
            {id = 'j_astronomer'},
            {id = 'j_burnt'},
            {id = 'j_sdm_reach_the_stars'},
            {id = 'j_sdm_wormhole'},
            {id = 'v_telescope'},
            {id = 'v_observatory'},
            {id = 'v_planet_merchant'},
            {id = 'v_planet_tycoon'},
        },
        banned_tags = {
            {id = 'tag_meteor'},
            {id = 'tag_orbital'},
        },
        banned_other = {},
    }
}

--- A Plumber's Hassle ---

SMODS.Challenge{
    loc_txt = "A Plumber's Hassle",
    key = 'a_plumber_s_hassle',
    rules = {
        custom = {},
        modifiers = {
            {id = 'joker_slots', value = 4},
            {id = 'hands', value = 3},
        },
    },
    jokers = {
        {id = 'j_sdm_infinite_staircase', eternal = true},
        {id = 'j_runner', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'v_grabber'},
            {id = 'v_nacho_tong'},
            {id = 'j_burglar'},
            {id = 'j_sdm_pizza'},
        },
        banned_tags = {},
        banned_other = {}
    }
}

--- Spare Change ---

SMODS.Challenge{
    loc_txt = "Spare Change",
    key = 'spare_change',
    rules = {
        custom = {
            {id = 'no_extra_hand_money'},
            {id = 'no_interest'}
        },
        modifiers = {},
    },
    jokers = {
        {id = 'j_sdm_clown_bank', eternal = true},
        {id = 'j_sdm_tip_jar', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'v_seed_money'},
            {id = 'v_money_tree'},
            {id = 'j_to_the_moon'},
            {id = 'j_rocket'},
            {id = 'j_golden'},
            {id = 'j_satellite'},
            {id = 'j_sdm_shareholder_joker'},
            {id = 'j_sdm_tip_jar'},
            {id = 'j_sdm_treasure_chest'},
        },
        banned_tags = {},
        banned_other = {}
    }
}

--- Twisted Binding ---

SMODS.Challenge{
    loc_txt = "Twisted Binding",
    key = 'twisted_binding',
    jokers = {
        {id = 'j_sdm_crooked_joker', eternal = true},
    },
}

--- Archifoolery ---

SMODS.Challenge{
    loc_txt = "Archifoolery",
    key = 'Archifoolery',
    rules = {
        custom = {},
        modifiers = {
            {id = 'joker_slots', value = 1},
        },
    },
    jokers = {
        {id = 'j_sdm_archibald', edition = 'negative', eternal = true},
    },
    restrictions = {
        banned_cards = {
            {id = 'j_sdm_0'},
            {id = 'v_blank'},
            {id = 'v_antimatter'},
        },
        banned_tags = {},
        banned_other = {}
    }
}
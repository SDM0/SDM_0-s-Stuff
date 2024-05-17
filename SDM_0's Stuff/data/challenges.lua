local parameters = NFS.load(SMODS.current_mod.path.."config.lua")()
local config = parameters.config

--- Challenges ---

local smods_current_mod_process_loc_textref = SMODS.current_mod.process_loc_text
function SMODS.current_mod.process_loc_text()
    smods_current_mod_process_loc_textref()
    G.localization.misc.v_text.ch_c_no_shop_planets = {"{C:planet}Planets{} no longer appear in the {C:attention}shop"}
end

if config.challenges then

    --- Devil's Deal ---

    if config.j_sdm_trance_the_devil then
        SMODS.Challenge{
            name = "Devil's Deal",
            key = 'devil_s_deal',
            rules = {
                custom = {},
                modifiers = {
                    {id = 'dollars', value = 0},
                    {id = 'discards', value = 3},
                    {id = 'hands', value = 3},
                    {id = 'reroll_cost', value = 8},
                    {id = 'joker_slots', value = 4},
                }
            },
            jokers = {
                {id = 'j_sdm_trance_the_devil', eternal = true},
            },
            consumeables = {
                {id = 'c_trance'},
                {id = 'c_devil'},
            },
            vouchers = {
                {id = 'v_tarot_merchant'},
                {id = 'v_tarot_tycoon'},
                {id = 'v_omen_globe'},
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
                    {id = 'j_sdm_wandering_star'},
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
    end

    --- Scientific Downfall ---

    if config.j_sdm_la_revolution then
        SMODS.Challenge{
            name = "Scientific Downfall",
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
                    {id = 'j_burglar'},
                    {id = 'j_drunkard'},
                    {id = 'j_merry_andy'},
                    {id = 'j_sdm_pizza'},
                    {id = 'v_crystal_ball'},
                    {id = 'v_grabber'},
                    {id = 'v_nacho_tong'},
                    {id = 'v_wasteful'},
                    {id = 'v_recyclomancy'},
                },
                banned_tags = {},
                banned_other = {},
            }
        }
    end

    --- A Plumber's Hassle ---

    if config.j_sdm_infinite_staircase then
        SMODS.Challenge{
            name = "A Plumber's Hassle",
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
    end

    --- Spare Change ---

    if config.j_sdm_clown_bank and config.j_sdm_tip_jar then
        SMODS.Challenge{
            name = "Spare Change",
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
                },
                banned_tags = {},
                banned_other = {}
            }
        }
    end

    --- Rock Smash ---

    if config.j_sdm_property_damage and config.j_sdm_rock_n_roll then
        SMODS.Challenge{
            name = "Rock Smash",
            key = 'rock_smash',
            rules = {
                custom = {},
                modifiers = {
                    {id = 'joker_slots', value = 4},
                },
            },
            jokers = {
                {id = 'j_sdm_property_damage', eternal = true},
                {id = 'j_sdm_rock_n_roll', eternal = true},
            },
            restrictions = {
                banned_cards = {
                    {id = 'c_lovers'},
                    {id = 'c_tower'},
                    {id = 'j_marble'},
                },
                banned_tags = {},
                banned_other = {}
            }
        }
    end

    --- Twisted Binding ---

    if config.j_sdm_crooked_joker then

        SMODS.Challenge{
            name = "Twisted Binding",
            key = 'twisted_binding',
            jokers = {
                {id = 'j_sdm_crooked_joker', eternal = true},
            },
        }

    end

    --- Archifoolery ---

    if config.j_sdm_archibald then

        SMODS.Challenge{
            name = "Archifoolery",
            key = 'archifoolery',
            rules = {
                custom = {},
                modifiers = {
                    {id = 'joker_slots', value = 1},
                },
            },
            jokers = {
                {id = 'j_sdm_archibald', edition = "negative"},
            },
        }
    end
end

return
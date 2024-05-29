local parameters = {
    config = {

        jokers = true,  --- disables all of the mod jokers, challenges and SDM_0's Deck on "false"

        j_trance_the_devil = true,
        j_burger = true,
        j_bounciest_ball = true,
        j_lucky_joker = true,
        j_iconic_icon = true,
        j_mult_n_chips = true,
        j_moon_base = true,
        j_shareholder_joker = true,
        j_magic_hands = true,
        j_tip_jar = true,
        j_wandering_star = true,
        j_ouija_board = true,
        j_la_revolution = true,
        j_clown_bank = true,
        j_furnace = true,
        j_warehouse = true,
        j_zombie_joker = true,
        j_mystery_joker = true,
        j_infinite_staircase = true,
        j_ninja_joker = true,
        j_reach_the_stars = true,
        j_crooked_joker = true,
        j_property_damage = true,
        j_rock_n_roll = true,
        j_contract = true,
        j_cupidon = true,
        j_pizza = true,
        j_treasure_chest = true,
        j_bullet_train = true,
        j_chaos_theory = true,
        j_archibald = true,
        j_sdm_0 = true,

        consumables = true,  --- disables all of the mod consumables on "false"

        c_sphinx = true,
        c_sacrifice = true,
        c_morph = true,

        challenges = true,  --- disables all of the mod challenges on "false"

        decks = true,   --- disables all of the mod decks on "false"

        b_sdm_0_s = true,
        b_bazaar = true,
        b_sandbox = true,
        b_lucky_7 = true,
        b_stuff = true
    },

    space_jokers = {
        -- Vanilla --
        j_supernova = "Supernova",
        j_space = "Space Joker",
        j_constellation = "Constellation",
        j_rocket = "Rocket",
        j_satellite = "Satellite",
        j_astronomer = "Astronomer",
    }
}

-- SDM_0's Stuff space jokers --
if parameters.config.j_moon_base then parameters.space_jokers.j_moon_base = "Moon Base" end
if parameters.config.j_wandering_star then parameters.space_jokers.j_wandering_star = "Wandering Star" end
if parameters.config.j_reach_the_stars then parameters.space_jokers.j_reach_the_stars = "Reach The Stars" end
-- if parameters.config.j_moon_landing then parameters.space_jokers.j_moon_landing = "Moon Landing" end

-- Other mods space jokers
-- !! DISABLED UNTIL MODS ARE UPDATED !! --
--[[
if SMODS.Mods["OrtalabDEMO"] then
    parameters.space_jokers.j_fuel_tank = "Afterburner"
end
if SMODS.Mods["MikasMods"] then
    parameters.space_jokers.j_mmc_blue_moon = "Blue Moon"
end
if SMODS.Mods["OrtalabDEMO"] then
    parameters.space_jokers.j_fuel_tank = "Afterburner"
end
if SMODS.Mods["JankJonklersMod"] then
    parameters.space_jokers.j_sentai = "Sentai Joker"
    parameters.space_jokers.j_ternary_system = "Ternary System"
end
if SMODS.Mods["FusionJokers"] then
    parameters.space_jokers.j_big_bang = "Big Bang"
end
if SMODS.Mods["VictinsCollection"] then
    parameters.space_jokers.j_syzygy = "Syzygy"
end
if SMODS.Mods["mtl_jkr"] then
    parameters.space_jokers.j_moon = "Moon Rabbit"
end
]]--

return parameters
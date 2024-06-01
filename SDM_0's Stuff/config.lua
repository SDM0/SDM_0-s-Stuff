SDM_0s_Stuff_Config = {
    config = {

        jokers = true,  --- disables all of the mod jokers, challenges and SDM_0's Deck on "false"

        j_sdm_trance_the_devil = true,
        j_sdm_burger = true,
        j_sdm_bounciest_ball = true,
        j_sdm_lucky_joker = true,
        j_sdm_iconic_icon = true,
        j_sdm_mult_n_chips = true,
        j_sdm_moon_base = true,
        j_sdm_shareholder_joker = true,
        j_sdm_magic_hands = true,
        j_sdm_tip_jar = true,
        j_sdm_wandering_star = true,
        j_sdm_ouija_board = true,
        j_sdm_la_revolution = true,
        j_sdm_clown_bank = true,
        j_sdm_furnace = true,
        j_sdm_warehouse = true,
        j_sdm_zombie_joker = true,
        j_sdm_mystery_joker = true,
        j_sdm_infinite_staircase = true,
        j_sdm_ninja_joker = true,
        j_sdm_reach_the_stars = true,
        j_sdm_crooked_joker = true,
        j_sdm_property_damage = true,
        j_sdm_rock_n_roll = true,
        j_sdm_contract = true,
        j_sdm_cupidon = true,
        j_sdm_pizza = true,
        j_sdm_treasure_chest = true,
        j_sdm_bullet_train = true,
        j_sdm_chaos_theory = true,
        j_sdm_archibald = true,
        j_sdm_sdm_0 = true,

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
        b_dna = true,
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
if SDM_0s_Stuff_Config.config.j_sdm_moon_base then SDM_0s_Stuff_Config.space_jokers.j_sdm_moon_base = "Moon Base" end
if SDM_0s_Stuff_Config.config.j_sdm_wandering_star then SDM_0s_Stuff_Config.space_jokers.j_sdm_wandering_star = "Wandering Star" end
if SDM_0s_Stuff_Config.config.j_sdm_reach_the_stars then SDM_0s_Stuff_Config.space_jokers.j_sdm_reach_the_stars = "Reach The Stars" end
-- if SDM_0s_Stuff_Config.config.j_sdm_moon_landing then SDM_0s_Stuff_Config.space_jokers.j_sdm_moon_landing = "Moon Landing" end

-- Other mods space jokers
-- !! DISABLED UNTIL MODS ARE UPDATED !! --
--[[
if SMODS.Mods["OrtalabDEMO"] then
    SDM_0s_Stuff_Config.space_jokers.j_fuel_tank = "Afterburner"
end
if SMODS.Mods["MikasMods"] then
    SDM_0s_Stuff_Config.space_jokers.j_mmc_blue_moon = "Blue Moon"
end
if SMODS.Mods["OrtalabDEMO"] then
    SDM_0s_Stuff_Config.space_jokers.j_fuel_tank = "Afterburner"
end
if SMODS.Mods["JankJonklersMod"] then
    SDM_0s_Stuff_Config.space_jokers.j_sentai = "Sentai Joker"
    SDM_0s_Stuff_Config.space_jokers.j_ternary_system = "Ternary System"
end
if SMODS.Mods["FusionJokers"] then
    SDM_0s_Stuff_Config.space_jokers.j_big_bang = "Big Bang"
end
if SMODS.Mods["VictinsCollection"] then
    SDM_0s_Stuff_Config.space_jokers.j_syzygy = "Syzygy"
end
if SMODS.Mods["mtl_jkr"] then
    SDM_0s_Stuff_Config.space_jokers.j_moon = "Moon Rabbit"
end
]]--
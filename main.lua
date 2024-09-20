--- STEAMODDED HEADER
--- MOD_NAME: SDM_0's Stuff
--- MOD_ID: sdm0sstuff
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Content mod that adds new jokers, consumables, decks and challenges.
--- BADGE_COLOUR: c20000
--- DISPLAY_NAME: SDM_0's Stuff
--- PREFIX: sdm
--- VERSION: 1.6.4e
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

----------------------------------------------
------------MOD CODE -------------------------

SDM_0s_Stuff_Mod = SMODS.current_mod
sdm_config = SDM_0s_Stuff_Mod.config

SDM_0s_Stuff_Mod.modded_objects = {}
SDM_0s_Stuff_Mod.meme_jokers = {}
SDM_0s_Stuff_Mod.space_jokers = {   --- Space jokers from this mod are in when loaded
    --- Vanilla ---
    j_supernova = "Supernova",
    j_space = "Space Joker",
    j_constellation = "Constellation",
    j_rocket = "Rocket",
    j_satellite = "Satellite",
    j_astronomer = "Astronomer",

    --- Modded ---
    j_moon = "Moon Rabbit",
    j_big_bang = "Big Bang",
    j_dsix_planet_die = "Planet Die",
    j_dsix_planet_plus_die = "Planet Die+",
    j_dsix_interstellar_die = "Interstellar Die",
    j_dsix_interstellar_plus_die = "Interstellar Die+",
    j_cj_extraterrestrial = "Extraterrestrial",
    j_cry_spaceglobe = "Celestial Globe",
    j_cry_meteor = "Meteor Shower",
    j_cry_exoplanet = "Exoplanet",
    j_cry_stardust = "Stardust",
    j_cry_virgo = "Virgo",
    j_cry_universum = "Universum",
    j_jank_sentai = "Sentai Joker",
    j_jank_ternary_system = "Ternary System",
    j_kcva_collapse = "Cosmic Collapse",
    j_lobc_child_galaxy = "O-01-55",
    j_mmc_aurora_borealis = "Aurora Borealis",
    j_mmc_blue_moon = "Blue Moon",
    j_mmc_nebula = "Nebula",
    j_olab_bowling_ball_solar_system = "Bowling Ball Solar System",
    j_olab_fuel_tank = "Afterburner",
    j_olab_evil_eye = "Evil Eye",
    j_pape_solar_system = "Solar System",
    j_ssj_void = "Sagittarius A*",
    j_twewy_lightningMoon = "Lightning Moon",
    ["j_Themed_C-Aries"] = "Cosmic - Aries",
    ["j_Themed_C-Taurus"] = "Cosmic - Taurus",
    ["j_Themed_C-Gemini"] = "Cosmic - Gemini",
    ["j_Themed_C-Cancer"] = "Cosmic - Cancer",
    ["j_Themed_C-Leo"] = "Cosmic - Leo",
    ["j_Themed_C-Virgo"] = "Cosmic - Virgo",
    ["j_Themed_C-Libra"] = "Cosmic - Libra",
    ["j_Themed_C-Scorpio"] = "Cosmic - Scorpio",
    ["j_Themed_C-Sagittarius"] = "Cosmic - Sagittarius",
    ["j_Themed_C-Capricorn"] = "Cosmic - Capricorn",
    ["j_Themed_C-Aquarius"] = "Cosmic - Aquarius",
    ["j_Themed_C-Pisces"] = "Cosmic - Pisces",
    ["j_Themed_C-Ophiuchus"] = "Cosmic - Ophiuchus",
    j_PlusJokers_thelemnisc8 = "The Lemnisc 8",
    j_PlusJokers_interstellar = "Interstellar"
}

SMODS.load_file("utils.lua")()

if sdm_config.sdm_jokers then
    SMODS.load_file("data/jokers.lua")()
    SMODS.load_file("data/challenges.lua")()
    if JokerDisplay then
        SMODS.load_file("extra/jokerdisplay_definitions.lua")()
    end
    if Cryptid then
        SMODS.load_file("extra/cryptid.lua")()
    end
end

if sdm_config.sdm_consus then
    SMODS.load_file("data/consumables.lua")()
end

if sdm_config.sdm_decks then
    SMODS.load_file("data/decks.lua")()
    if CardSleeves then
        SMODS.load_file("extra/card_sleeves.lua")()
    end
end

SMODS.Atlas{
    key = "modicon",
    path = "sdm_modicon.png",
    px = 34,
    py = 34,
}

SDM_0s_Stuff_Mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "cl", padding = 0, minh = 0.1}, nodes = {}},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = sdm_config, ref_value = "sdm_jokers" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Jokers", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = sdm_config, ref_value = "sdm_consus" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Consumables", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = sdm_config, ref_value = "sdm_decks" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Decks", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = sdm_config, ref_value = "limit_moon_base" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Limit Moon Base", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0.5}, nodes = {
            {n = G.UIT.T, config = {text = "(Must restart to apply changes)", scale = 0.40, colour = G.C.UI.TEXT_LIGHT}},
        }},

    }}
end

----------------------------------------------
------------MOD CODE END----------------------

--- STEAMODDED HEADER
--- MOD_NAME: SDM_0's Stuff
--- MOD_ID: sdm0sstuff
--- MOD_AUTHOR: [SDM_0]
--- MOD_DESCRIPTION: Content mod that adds new jokers, consumables, decks and challenges.
--- BADGE_COLOUR: c20000
--- DISPLAY_NAME: SDM_0's Stuff
--- PREFIX: sdm
--- VERSION: 1.6.0c
--- LOADER_VERSION_GEQ: 1.0.0 

----------------------------------------------
------------MOD CODE -------------------------

SDM_0s_Stuff_Mod = SMODS.current_mod
sdm_config = SDM_0s_Stuff_Mod.config

SDM_0s_Stuff_Mod.modded_objects = {}
SDM_0s_Stuff_Mod.space_jokers = {
    --- Vanilla ---
    j_supernova = "Supernova",
    j_space = "Space Joker",
    j_constellation = "Constellation",
    j_rocket = "Rocket",
    j_satellite = "Satellite",
    j_astronomer = "Astronomer",

    --- Modded ---
    j_mtl__j_moon = "Moon Rabbit",
    j_evo_astronaut = "Astronaut Joker",
    j_dsix_planet_die = "Planet Die",
    j_dsix_planet_plus_die = "Planet Die+",
    j_dsix_interstellar_die = "Interstellar Die",
    j_dsix_interstellar_plus_die = "Interstellar Die+",
    j_bala_eclipse = "Eclipse Joker",
    j_cj_extraterrestrial = "Extraterrestrial",
    j_cry_spaceglobe = "Celestial Globe",
    j_cry_meteor = "Meteor Shower",
    j_cry_exoplanet = "Exoplanet",
    j_cry_stardust = "Stardust",
    j_cry_virgo = "Virgo",
    j_cry_Universum = "Universum",
    j_jank_j_sentai = "Sentai Joker",
    j_jank_j_ternary_system = "Ternary System",
    j_KCVa_collapse = "Cosmic Collapse",
    j_lobc_child_galaxy = "O-01-55",
    j_mmc_aurora_borealis = "Aurora Borealis",
    j_mmc_blue_moon = "Blue Moon",
    j_mmc_nebula = "Nebula",
    j_olab_bowling_ball_solar_system = "Bowling Ball Solar System",
    j_olab_fuel_tank = "Afterburner",
    j_olab_evil_eye = "Evil Eye",
    j_ssj_void = "Sagittarius A*",
    j_twewy_lightningMoon = "Lightning Moon",
    j_Them_cosmicaries = "Cosmic - Aries",
    j_Them_cosmictaurus = "Cosmic - Taurus",
    j_Them_cosmicgemini = "Cosmic - Gemini",
    j_Them_cosmiccancer = "Cosmic - Cancer",
    j_Them_cosmicleo = "Cosmic - Leo",
    j_Them_cosmicvirgo = "Cosmic - Virgo",
    j_Them_cosmiclibra = "Cosmic - Libra",
    j_Them_cosmicscorpio = "Cosmic - Scorpio",
    j_Them_cosmicsagittarius = "Cosmic - Sagittarius",
    j_Them_cosmiccapricorn = "Cosmic - Capricorn",
    j_Them_cosmicaquarius = "Cosmic - Aquarius",
    j_Them_cosmicpisces = "Cosmic - Pisces",
    j_Them_cosmicophiuchus = "Cosmic - Ophiuchus",
    j_flou_orb = "Orbit"
}

SMODS.load_file("utils.lua")()

SMODS.load_file("data/jokers.lua")()
SMODS.load_file("data/challenges.lua")()
SMODS.load_file("data/consumables.lua")()
SMODS.load_file("data/decks.lua")()

SMODS.load_file("localization.lua")()

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

        {n = G.UIT.R, config = {align = "cm", padding = 0.5}, nodes = {
            {n = G.UIT.T, config = {text = "(Must restart to apply changes)", scale = 0.40, colour = G.C.UI.TEXT_LIGHT}},
        }},

    }}
end

----------------------------------------------
------------MOD CODE END----------------------
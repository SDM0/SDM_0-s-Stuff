SDM_0s_Stuff_Mod = SMODS.current_mod
SDM_0s_Stuff_Config = SDM_0s_Stuff_Mod.config

SDM_0s_Stuff_Mod.modded_jokers = {}
SDM_0s_Stuff_Mod.modded_consumables = {}
SDM_0s_Stuff_Mod.food_jokers = {}
SDM_0s_Stuff_Mod.meme_jokers = {}
SDM_0s_Stuff_Mod.tier3_vouchers = {}
SDM_0s_Stuff_Mod.space_jokers = {   --- SDM_0's Stuff space jokers loaded in during their creation

    --- Vanilla ---
    j_supernova = "Supernova",
    j_space = "Space Joker",
    j_constellation = "Constellation",
    j_rocket = "Rocket",
    j_satellite = "Satellite",
    j_astronomer = "Astronomer",

    --- Pampa ---
    j_moon = "Moon Rabbit",

    --- Fusion Jokers / Defused ---
    j_big_bang = "Big Bang",

    --- D6 Jokers ---
    j_dsix_planet_die = "Planet Die",
    j_dsix_planet_plus_die = "Planet Die+",
    j_dsix_interstellar_die = "Interstellar Die",
    j_dsix_interstellar_plus_die = "Interstellar Die+",

    --- Cheesy Jokers ---
    j_cj_extraterrestrial = "Extraterrestrial",

    --- Cryptid ---
    j_cry_spaceglobe = "Celestial Globe",
    j_cry_meteor = "Meteor Shower",
    j_cry_exoplanet = "Exoplanet",
    j_cry_stardust = "Stardust",
    j_cry_virgo = "Virgo",
    j_cry_night = "Night",
    j_cry_universe = "Universe",
    j_cry_universum = "Universum",
    j_cry_stella_mortis = "Stella Mortis",

    --- Jank Jonklers ---
    j_jank_sentai = "Sentai Joker",
    j_jank_ternary_system = "Ternary System",

    --- KCVanilla ---
    j_kcva_collapse = "Cosmic Collapse",

    --- Lobotomy Corporation ---
    j_lobc_child_galaxy = "O-01-55",

    --- Mika's Mod Collection ---
    j_mmc_aurora_borealis = "Aurora Borealis",
    j_mmc_blue_moon = "Blue Moon",
    j_mmc_nebula = "Nebula",

    --- Ortalab ---
    j_ortalab_afterburner = "Afterburner",
    j_ortalab_protostar = "Protostar",
    j_ortalab_stargazing = "Stargazing",
    j_ortalab_sun_sign = "Sun Sign",
    j_ortalab_astrologist = "Astrologist",

    --- Paperback ---
    j_paperback_solar_system = "Solar System",
    j_paperback_triple_moon_goddess = "Triple Moon Goddess",

    --- SpicyJokers ---
    j_ssj_void = "Sagittarius A*",

    --- TWEWJ ---
    j_twewy_lightningMoon = "Lightning Moon",

    --- Themed Jokers ---
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

    --- Balatro Jokers Plus ---
    j_PlusJokers_thelemnisc8 = "The Lemnisc 8",
    j_PlusJokers_interstellar = "Interstellar",

    --- Balatro 451 ---
    j_bala_eclipse = "Eclipse Joker",

    --- Celeste Card Collection ---
    j_ccc_eventhorizon = "Event Horizon",

    --- Emporium ---
    j_emp_wishing_star = "Wishing Star",

    --- TOGA's Stuff ---
    j_toga_asterism = "Asterism",
    j_toga_spacecadetpinball = "Space Cadet",

    --- Warp Zone! ---
    j_Wzon_votv = "Voices of the Void",

    --- Art Of The Deal ---
    j_deal_atrax = "Atraxia",
    j_deal_hyper = "Hypergiant",

    --- 7th beat cards ---
    j_sbc_NHH = "No hints here",

    --- Maximus ---
    j_mxms_space_race = "Space Race",

    --- No Laughing Matter ---
    j_mini_astrology = "Astrology",

    --- Printer Jokers ---
    j_crv_celestialprinter = "Celestial Printer",

    --- Extra Credit ---
    j_ExtraCredit_eclipse = "Eclipse",
    j_ExtraCredit_accretiondisk = "Accretion Disk",

    --- Familiar ---
    j_fam_astrophysicist = "Astrophysicist",

    --- Unstable ---
    j_unstb_lunar_calendar = "Lunar Calendar",

    --- Strange Pencil ---
    j_pencil_eclipse = "Solar Eclipse",
}

SMODS.load_file("utils.lua")()

if SDM_0s_Stuff_Config.sdm_jokers then
    SMODS.load_file("data/jokers.lua")()
    SMODS.load_file("data/challenges.lua")()
    if JokerEvolution then
        SMODS.load_file("extra/joker_evolution.lua")()
    end
    if JokerDisplay then
        SMODS.load_file("extra/jokerdisplay_definitions.lua")()
    end
end

SMODS.load_file("data/pokerhands.lua")()

if SDM_0s_Stuff_Config.sdm_consus then
    SMODS.load_file("data/consumables.lua")()
end

if SDM_0s_Stuff_Config.sdm_vouchers then
    SMODS.load_file("data/vouchers.lua")()
end

if SDM_0s_Stuff_Config.sdm_decks then
    SMODS.load_file("data/decks.lua")()
    if CardSleeves then
        SMODS.load_file("extra/card_sleeves.lua")()
    end
end

if SDM_0s_Stuff_Config.sdm_bakery then
    SMODS.load_file("data/bakery/bakery.lua")()
end

SMODS.load_file("data/pools.lua")()

SMODS.Atlas{
    key = "modicon",
    path = "sdm_modicon.png",
    px = 34,
    py = 34,
}

SDM_0s_Stuff_Mod.optional_features = {
    retrigger_joker = true,
    cardareas = {
        unscored = true
    }
}

SDM_0s_Stuff_Mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "cl", padding = 0, minh = 0.1}, nodes = {}},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "sdm_jokers" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Jokers*", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "sdm_consus" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Consumables*", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "sdm_vouchers" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Vouchers*", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "sdm_decks" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Decks*", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "sdm_bakery" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "Enable Bakery Goods*", scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
            {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
                create_toggle{ col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = SDM_0s_Stuff_Config, ref_value = "retrigger_on_deck" },
            }},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = 'Reverb Deck: "Again" on Deck?', scale = 0.45, colour = G.C.UI.TEXT_LIGHT }},
            }},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0.5}, nodes = {
            {n = G.UIT.T, config = {text = "*Must restart to apply changes", scale = 0.35, colour = G.C.UI.TEXT_LIGHT}},
        }},

    }}
end
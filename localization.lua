function SDM_0s_Stuff_Mod.process_loc_text()
    G.localization.misc.dictionary.k_halved_ex = "Halved!"
    G.localization.misc.dictionary.k_stone = "Stone"
    G.localization.misc.dictionary.k_shared_ex = "Shared!"
    G.localization.misc.dictionary.k_change_ex = "Change!"

    G.localization.misc.v_dictionary.a_hand = "+#1# Hand"
    G.localization.misc.v_dictionary.a_hand_minus = "-#1# Hand"
    G.localization.misc.v_dictionary.a_discard = "+#1# Discard"
    G.localization.misc.v_dictionary.a_discard_minus = "-#1# Discard"
    G.localization.misc.v_dictionary.a_joker_slot = "+#1# Joker Slot"
    G.localization.misc.v_dictionary.a_joker_slot_minus = "-#1# Joker Slot"
    G.localization.misc.v_dictionary.a_consumable_slot = "+#1# Cons. Slot"
    G.localization.misc.v_dictionary.a_consumable_slot_minus = "-#1# Cons. Slot"

    G.localization.descriptions.Other.space_jokers = {
        name = "Space Jokers",
        text = {
            "Astronomer, Constellation,",
            "Rocket, Satellite,",
            "Space Joker, Supernova etc.",

        }
    }
    G.localization.descriptions.Other.modified_card = {
        name = "Modified",
        text = {
            "Enhancement, seal,",
            "edition"
        }
    }
    G.localization.descriptions.Other.chaos_exceptions = {
        name = "Exceptions",
        text = {
            "Round score, goal score,",
            "hand level, and descriptions",
        }
    }
    G.localization.descriptions.Other.perishable_no_debuff = {
        name = "Perishable",
        text = {
            "Debuffed after",
            "{C:attention}#1#{} rounds"
        }
    }
    G.localization.descriptions.Other.resources = {
        name = "Resources",
        text = {
            "Hand, discard, dollar, handsize,",
            "joker slot, consumable slot"
        }
    }
end

return
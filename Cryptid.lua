local sdm_jokers = {
    shareholder_joker = {
        take_ownership = true,
        object_type = "Joker",
        key = "shareholder_joker",
        gameset_config = {
            mainline = {extra = {min = 5, max = 10}},
            madness = {extra = {min = 100, max = 10000}},
        }
    }
}

return {items = sdm_jokers}
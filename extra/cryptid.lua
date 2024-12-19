if SDM_0s_Stuff_Config.sdm_jokers then
    -- Loading meme jokers into Cryptid's "Meme packs"
    for k, _ in pairs(SDM_0s_Stuff_Mod.meme_jokers) do
        Cryptid.memepack[#Cryptid.memepack+1] = k
    end

    -- Loading food jokers into Cryptid's "://SPAGHETTI" pool
    for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
        Cryptid.food[#Cryptid.food+1] = k
    end
end

if SDM_0s_Stuff_Config.sdm_vouchers then

    -- Oblivion

    SMODS.Voucher{
        key = 'oblivion',
        name = 'Oblivion',
        pos = {x = 0, y = 2},
        config = {extra = 5},
        requires = {"v_sdm_eclipse"},
        loc_vars = function(self, info_queue, card)
            return {vars = {math.max(1, self.config.extra)}}
        end,
        redeem = function(self)
            G.E_MANAGER:add_event(Event({func = function()
                local negative_made = false
                if #G.jokers.cards > 0 then
                    for k, v in pairs(G.jokers.cards) do
                        if not v.edition then
                            v:set_edition("e_negative", true)
                            negative_made = true
                        end
                    end
                end
                if not negative_made then
                    for i = 1, math.max(1, self.config.extra) do
                        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, "j_joker", 'obv')
                        card:set_edition("e_negative", true)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                    end
                end
                return true
            end}))
        end,
        atlas = "sdm_vouchers"
    }

    SDM_0s_Stuff_Mod.modded_objects.v_sdm_oblivion = "Oblivion"
    Cryptid.Megavouchers[#Cryptid.Megavouchers + 1] = "v_sdm_oblivion"
end
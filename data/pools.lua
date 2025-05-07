if SDM_0s_Stuff_Config.sdm_jokers then

    SMODS.ObjectType {
        key = 'SDM_0s_jokers',
        default = 'j_sdm_bounciest_ball',
        cards = {},
        inject = function(self)
            SMODS.ObjectType.inject(self)
            for k, _ in pairs(SDM_0s_Stuff_Mod.modded_jokers) do
                local joker = nil
                if G.P_CENTERS[k] then
                    joker = G.P_CENTERS[k]
                elseif SMODS.Centers[k] then
                    joker = SMODS.Centers[k]
                end
                if joker then
                    self:inject_card(joker)
                end
            end
        end
    }

    -- Space pool for Moon Base
    SMODS.ObjectType {
        key = 'Space',
        default = 'j_space',
        cards = {},
        inject = function(self)
            SMODS.ObjectType.inject(self)
            for k, _ in pairs(SDM_0s_Stuff_Mod.space_jokers) do
                local joker = nil
                if G.P_CENTERS[k] then
                    joker = G.P_CENTERS[k]
                elseif SMODS.Centers[k] then
                    joker = SMODS.Centers[k]
                end
                if joker then
                    self:inject_card(joker)
                end
            end
        end
    }

    -- Food pool additions for cross-mod compat
    if not Cryptid and (SMODS.ObjectTypes and SMODS.ObjectTypes.Food) then
        for k, _ in pairs(SDM_0s_Stuff_Mod.food_jokers) do
            local joker = nil
            if G.P_CENTERS[k] then
                joker = G.P_CENTERS[k]
            elseif SMODS.Centers[k] then
                joker = SMODS.Centers[k]
            end
            if joker then
                SMODS.insert_pool(SMODS.ObjectTypes.Food, joker)
            end
        end
    end

end

if SDM_0s_Stuff_Config.sdm_consus or SDM_0s_Stuff_Config.sdm_bakery then
    -- Space pool for Moon Base
    local default = (SDM_0s_Stuff_Config.sdm_consus and 'c_sdm_mother') or 'c_sdm_pita'

    SMODS.ObjectType {
        key = 'SDM_0s_consus',
        default = default,
        cards = {},
        inject = function(self)
            SMODS.ObjectType.inject(self)
            for k, _ in pairs(SDM_0s_Stuff_Mod.modded_consumables) do
                local consu = nil
                if G.P_CENTERS[k] then
                    consu = G.P_CENTERS[k]
                elseif SMODS.Centers[k] then
                    consu = SMODS.Centers[k]
                end
                if consu then
                    self:inject_card(consu)
                end
            end
        end
    }
end
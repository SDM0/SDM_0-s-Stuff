local game_start_runref = Game.start_run
function Game:start_run(args)
    game_start_runref(self, args)
    local saveTable = args.savetext or nil
    if not saveTable then
        if args.challenge then
            local _ch = args.challenge
            if _ch.rules then
                if _ch.rules.custom then
                    for k, v in ipairs(_ch.rules.custom) do
                        if v.id == 'no_shop_planets' then
                            self.GAME.planet_rate = 0
                        end
                    end
                end
            end
        end
    end
end

local calculate_dollar_bonusref = Card.calculate_dollar_bonus
function Card.calculate_dollar_bonus(self)
    if self.debuff then return end
    if self.ability.set == "Joker" then
        local obj = self.config.center
        if obj and obj.sdm_calc_dollar_bonus and type(obj.sdm_calc_dollar_bonus) == 'function' then
            return obj:sdm_calc_dollar_bonus(self)
        end
    end
    return calculate_dollar_bonusref(self)
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if G.jokers and #G.jokers.cards > 0 then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({sdm_adding_card = true, card = self})
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

return
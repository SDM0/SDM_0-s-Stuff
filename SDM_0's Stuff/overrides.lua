local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self.config.center_key == 'j_sdm_iconic_icon' then
            self.ability.extra.mult = 0
            for _, v in pairs(G.playing_cards) do
                if v:get_id() == 14 and (v.edition or v.seal or v.ability.effect ~= "Base") then
                    self.ability.extra.mult =  self.ability.extra.mult + self.ability.extra.mult_mod
                end
            end
        elseif self.config.center_key == 'j_sdm_bounciest_ball' then
            self.ability.extra.hand = G.GAME.last_hand_played or "High Card"
        elseif self.config.center_key == 'j_sdm_warehouse' then
            if self.set_cost and self.ability.extra_value ~= self.ability.extra.dollars - math.floor(self.cost / 2) then 
                self.ability.extra_value = self.ability.extra.dollars - math.floor(self.cost / 2)
                self:set_cost()
            end
        elseif self.config.center_key == 'j_sdm_contract' then
            if self.ability.extra.registered and not self.ability.extra.breached then
                if G.GAME.dollars < self.ability.extra.dollars or
                G.GAME.dollars > self.ability.extra.dollars + self.ability.extra.dollars_mod then
                    self.ability.extra.breached = true
                    self.getting_sliced = true
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', blockable = false,
                    func = function()
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize('k_breached_ex'),
                            colour = G.C.RED
                        })
                        play_sound('tarot1')
                        self.T.r = -0.2
                        self:juice_up(0.3, 0.4)
                        self.states.drag.is = true
                        self.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, blockable = false,
                        func = function()
                            G.jokers:remove_card(self)
                            self:remove()
                            self = nil
                            return true; 
                        end})) 
                        return true
                    end }))
                end
            end
        elseif self.config.center_key == 'j_sdm_chaos_theory' then
            self.ability.extra.chips = sum_incremental(2)
        elseif self.config.center_key == 'j_sdm_incredible_icon' then
            self.ability.extra.mult = 0
            self.ability.extra.chips = 0
            for _, v in pairs(G.playing_cards) do
                if v.ability then 
                    if v.ability.effect == "Bonus Card" then
                        if v:get_id() == 14 then
                            self.ability.extra.mult = self.ability.extra.mult + (self.ability.extra.mult_mod * 2)
                        else
                            self.ability.extra.mult = self.ability.extra.mult + self.ability.extra.mult_mod
                        end
                    elseif v.ability.effect == "Mult Card" then
                        if v:get_id() == 14 then
                            self.ability.extra.chips = self.ability.extra.chips + (self.ability.extra.chips_mod * 2)
                        else
                            self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chips_mod
                        end
                    end
                end
            end
        end
    end
    card_updateref(self, dt)
end

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
        if self.config.center_key == 'j_sdm_tip_jar' then
            local highest = 0
            for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
                highest = math.max(highest, tonumber(digit))
            end
            if highest > 0 then
                return highest
            end
        elseif self.config.center_key == 'j_sdm_shareholder_joker' then
            rand_dollar = pseudorandom(pseudoseed('shareholder'), self.ability.extra.min, self.ability.extra.max)
            return rand_dollar
        elseif self.config.center_key == 'j_sdm_furnace' or self.config.center_key == 'j_sdm_denaturalisation' then
            if self.ability.extra.dollars > 0 then
                return self.ability.extra.dollars
            end
        elseif self.config.center_key == 'j_sdm_gold_dealer_joker' then
            rand_dollar = pseudorandom(pseudoseed('golddealer'), self.ability.extra.min, self.ability.extra.max)
            return rand_dollar
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
        if self.config.center_key == 'j_sdm_warehouse' then
            self.ability.extra.c_size = G.consumeables.config.card_limit
            G.hand:change_size(self.ability.extra.h_size)
            G.consumeables:change_size(-self.ability.extra.c_size)
        end
    end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
    if self.added_to_deck then
        if self.config.center_key == 'j_sdm_warehouse' then
            G.hand:change_size(-self.ability.extra.h_size)
            G.consumeables:change_size(self.ability.extra.c_size)
        end
    end
    remove_from_deckref(self, from_debuff)
end

local backapply_to_runref = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    backapply_to_runref(arg_56_0)

    if arg_56_0.effect.config.b_sdm_sdm_0_s_deck then
        G.E_MANAGER:add_event(Event({
            func = function()
                rand_jokers = get_random_sdm_modded_jokers(2, true)
                for i = 1, #rand_jokers do
                    add_joker2(rand_jokers[i], nil, true, true)
                end
                return true
            end
        }))
    end
    if arg_56_0.effect.config.b_sdm_sandbox_deck then
        G.GAME.win_ante = 10
    end
end

local card_set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    card_set_abilityref(self,center,initial,delay_sprites)
    local W, H = self.T.w, self.T.h
    local scale = 1
    if center.key == "j_sdm_treasure_chest" then 
        self.children.center.scale.y = self.children.center.scale.x
        H = W
        self.T.h = H*scale
        self.T.w = W*scale
    end
end

local end_calculate_contextref = SMODS.end_calculate_context
function SMODS.end_calculate_context(c)
    local e = end_calculate_contextref(c)
    return e and not c.sdm_adding_card
end

return
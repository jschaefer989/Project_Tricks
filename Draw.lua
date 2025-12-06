local suit = require('Libraries.suit-master')

Draw = {}

function Draw:card(card, btnW, btnH, onlySelectOne)
        local isSelected = card.selected
        local btnText = card.rank .. " " .. card.suit .. " (Val: " .. card.value .. ", Pow: " .. card.power .. ")"
        if isSelected then
            btnText = "[X] " .. btnText
        else
            btnText = "[ ] " .. btnText
        end
        local btnHit = suit.Button(btnText, suit.layout:col(btnW, btnH)).hit
        if btnHit then
            if onlySelectOne then
                --TODO: this should be made generic
                -- Deselect all other cards
                GameManager.board.dealer:deselectAllCards()
            end
            card.selected = not card.selected
        end
end
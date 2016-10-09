∇z←setup

⍝Setup should pass the number of players

⍝ask how many people are playing?
"How many people are playing?"
"Please enter a positive integer"
numberplayers←⍞

⍝coerce to a number
numberplayers←⍎numberplayers

⍝Each player is dealt 7 cards 
⍝from a 52 card deck (no jokers)

⍝make a deck of cards
deck←""
deck←deck,"🂡" "🂱" "🃁" "🃑" 
deck←deck,"🂢" "🂲" "🃂" "🃒"
deck←deck,"🂣" "🂳" "🃃" "🃓" 
deck←deck,"🂤" "🂴" "🃄" "🃔" 
deck←deck,"🂥" "🂵" "🃅" "🃕" 
deck←deck,"🂦" "🂶" "🃆" "🃖" 
deck←deck,"🂧" "🂷" "🃇" "🃗" 
deck←deck,"🂨" "🂸" "🃈" "🃘" 
deck←deck,"🂩" "🂹" "🃉" "🃙" 
deck←deck,"🂪" "🂺" "🃊" "🃚" 
deck←deck,"🂫" "🂻" "🃋" "🃛" 
⍝deck←deck,"🂬" "🂼" "🃌" "🃜"   ⍝knights? 
deck←deck,"🂭" "🂽" "🃍" "🃝" 
deck←deck,"🂮" "🂾" "🃎" "🃞"
⍝deck←deck,"🂠" "🂿" "🃏" "🃟"   ⍝jokers

decksize←⍴deck

HowManyPlayers:
⍝ask how many people are playing?
"How many people are playing?"
"Please enter a positive integer"
numberplayers←⍞
'hi'
⍝validate
→(~numberplayers∊'123456789')/HowManyPlayers
'number validated'
⍝coerce to a number
numberplayers←⍎numberplayers
'coerced'
handsize←7

⍝Check to make sure you have cards for everyone.
⍝Another feature to add would be to use multiple decks for many players
→(decksize≥handsize×numberplayers)/AllCanPlay
"Oh no! Not enough cards for everyone"
→HowManyPlayers

AllCanPlay:

⍝shuffle
deck_shuffled←deck[decksize?decksize]
⍝deal
hands←(decksize↑handsize/⍳numberplayers)⊂deck_shuffled
⍝
restofdeck←(~decksize↑(handsize×numberplayers)⍴1)/deck_shuffled

⍝After dealing, 
⍝the remaining cards are stacked face-down (called the stack), 
⍝we already defined restofdeck
⍝use a boolean to keep track of remaining cards vs discard pile
deck_bool←1,(¯1+⍴restofdeck)↑0

⍝and the top card on the stack is turned face-up next to the stack, 
⍝(beginning the discard pile).
"The top card on the stack (beginning of discard pile) is:"
deck_bool/restofdeck

⍝advance the bool
deck_bool←¯1⌽deck_bool
z←numberplayers
∇




⍝A player wins by  
∇z←deck winner player_hand
⍝z is 1 if the player has a winning hand
⍝mark the hand in the deck, as matrix
⍝so its easy to fin winning conditions
⍝given four suits
deck_rows←(⍴deck)÷4
⍝since the win conditions are mutually exclusive,
⍝we need to eliminate win cards each time
hand_boolmatrix←(deck_rows,4)⍴deck∊one_hand
⍝first to have 
⍝both a 3-of-a-kind (same card value, different suits)
⍝three ones in a row of the matrix
three_of_a_kind←∨/3=+/hand_boolmatrix ⍝ ←→ one if you got this
→(0=three_of_a_kind)/Loser
⍝and a 4-card-run (same suit, incrementing card value) 
rotated_boolmatrix←⍉(deck_rows,4)⍴deck∊one_hand
four_card_run←∨/,(+\bm)∊4
→(0=four_card_run)/Loser
⍝in their hand, 
⍝where the cards used for each goal are mutually exclusive.
TODO: make sure the sets arent mutually exclisive
Winner:
z←1
Loser:
⍝go to the next player
z←0
∇


∇z←a_turn a_hand
⍝Play is round robin, 
⍝with each player's turn consists of 
⍝display the hand
"This is your hand"
a_hand
⍝picking a card from either 
⍝the top of the stack 
"The top card on the stack is:"
stack_card←deck_bool/restofdeck
stack_card
⍝or 
⍝the top of the discard pile, 
"The top card on the discard pile is:"
discardpile_card←(1⌽deck_bool)/restofdeck
discardpile_card
ChooseCard:
"Press s to add the stack-card to your hand"
"Press d to add the discard-card to your hand"
cardpick←⍞
valid_cardpick←("s"=cardpick)∨("d"=cardpick)
(~valid_cardpick)/"Please enter a valid choice" 
→(~valid_cardpick)/ChooseCard
⍝adding the card to their hand, 
→("d"=cardpick)/AddDiscardCard
⍝If we got here, we are good to add the stack card,
⍝even though we didn't explicitly check for it.
AddStackCard:
a_hand←a_hand,stack_card
→AddCardEnd
AddDiscardCard:
a_hand←a_hand,discardpile_card
AddCardEnd:
⍝and then discarding to the top of the discard pile.
"Discard a card, by entering the location (1|2|3|4|5|6|7|8)"
⍝display the hand
a_hand
which_discard←⍞
⍝make sure number is 1 - 8
→(~which_discard∊⍳8)/AddCardEnd
⍝if they picked up from the discard pile then 
→("d"=cardpick)/ThrowOutDiscard
⍝if they picked up from the stack pile then
→("s"=cardpick)/ThrowOutStack
ThrowOutDiscard:
⍝put their discarded card where the discard pointer is
discard_bool←1⌽deck_bool
restofdeck[discard_bool/⍳⍴discard_bool]←a_hand[which_discard]
⍝remove the card from their hand
a_hand←(~(⍳8)∊which_discard)/a_hand
⍝do not update the restofdeck pointer
→EndDiscard
ThrowOutStack:
⍝put their card where the stack pointer is,
restofdeck[deck_bool/⍳⍴deck_bool]←a_hand[which_discard]
⍝and THEN update the pointer to the next card. 
deck_bool←¯1⌽deck_bool
EndDiscard:


⍝A player can only declare they win during their turn, 
⍝and must still discard at the end of their turn 
⍝and still have a winning hand.
⍝so check for a win after the discard
z←winbool← winner a_hand
∇
⍝If the stack is empty immediately after a player picks a card, 
⍝before the player can discard 
⍝the discard pile is shuffled 
⍝and becomes the stack.






∇z←playgame numberplayers
z←⍳0

⍝⍝ each turn ⍝⍝
turns←⍳numberplayers

ATurn:
whoseturn←1↑turns
winna←a_turn hands[whoseturn]

⍝advance player counter
turns←¯1⌽turns

⍝No Winner, go to next turn
→(0=winna)/Aturn

If you got here, someone won.
"Winner!"
hands[1⌽whoseturn]
∇

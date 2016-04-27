class Card

@@cards = {1 => 'Ace', 2 => 'Two', 3 => 'Three', 4 => 'Four', 5 => 'Five', 6 => 'Six',
  7 => 'Seven', 8 => 'Eight', 9 => 'Nine', 10 => 'Ten', 11 => 'Jack', 12 => 'Queen', 13 => 'King'}
@@suits = ['Diamonds', 'Hearts', 'Spades', 'Clubs']
@@values = {'Ace' => 1, 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5, 'Six' => 6,
  'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10, 'Jack' => 10, 'Queen' => 10, 'King' => 10 }
@@suits_symbols = ['Spades' => '♠','Diamonds' => '♦','Hearts' => '♥','Clubs' => '♣']
@@outputs_types = {'Ace' => 'A', 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5, 'Six' => 6,
  'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10, 'Jack' => 'J', 'Queen' => 'Q', 'King' => 'K' }


  def initialize
    @type = @@cards[1 + rand(12)]
    @value = @@values[@type]
    @suit = @@suits.sample
  end

  def type
    return @type
  end

  def value
    return @value
  end

  def suit
    return @suit
  end

#   def output_card(type, suit)
#     type = outputs_types[type]
#     suit = suits_symbols[suit]
#     print "
#
# ┌─────────┐
# │#{type}       │
# │         │
# │         │
# │    #{suit}    │
# │         │
# │         │
# │       #{type}│
# └─────────┘
#
#
#     "
#   end
    # print "░░░░░░░░"

end

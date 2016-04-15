#variables, arrays, and hashes
$cards = {1 => 'Ace', 2 => 'Two', 3 => 'Three', 4 => 'Four', 5 => 'Five', 6 => 'Six',
  7 => 'Seven', 8 => 'Eight', 9 => 'Nine', 10 => 'Ten', 11 => 'Jack', 12 => 'Queen', 13 => 'King'}
$suits = ['Diamonds', 'Hearts', 'Spades', 'Clubs']
$values = {'Ace' => 1, 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5, 'Six' => 6,
  'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10, 'Jack' => 10, 'Queen' => 10, 'King' => 10 }

class Card
  def initialize
    @type = $cards[1 + rand(12)]
    @value = $values[@type]
  end
  def type
    return @type
  end
  def value
    return @value
  end
end
class Hand
  def initialize(card)
    @value = card
  end
  def value
    return @value
  end
end

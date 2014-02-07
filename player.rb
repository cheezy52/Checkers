class Player
  attr_accessor :name, :game, :color
  def initialize(game, name)
    @name = name
    @game = game
    @color = nil
  end

  def take_turn
    raise NotImplementedError
  end

  def to_s
    "#{@name} (#{@color == :r ? "Red" : "Black"})"
  end
end
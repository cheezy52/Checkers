require_relative "errors"
require_relative "piece"
require_relative "board"
require_relative "player"

class Game
  attr_accessor :board, :current_player, :red_player, :black_player
  def initialize(red_player = HumanPlayer.new(self, "Alice"), black_player = HumanPlayer.new(self, "Bob"))
    @red_player = red_player
    @red_player.color = :r
    @black_player = black_player
    @black_player.color = :b
    @current_player = red_player
    @board = Board.new(self, true)
  end

  def play
    until over?
      puts @board
      puts "It is #{@current_player} (#{@current_player.color == :r ? "Red" : "Black"})'s turn."
      @current_player.take_turn
      @current_player = (@current_player == @red_player ? @black_player : @red_player)
    end
    puts @board
    puts "#{winner} (#{@current_player.color == :r ? "Red" : "Black"}) wins!"
  end

  def over?
    @board.all_pieces.all? { |piece| piece.color == @board.all_pieces[0].color}
  end

  def winner
    @board.all_pieces[0].color == :r ? @red_player : @black_player
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end
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
end

class HumanPlayer < Player
  INVALID_POSITION_ERROR = InvalidInputError.new("That is not a valid coordinate pair.")
  NO_PIECE_ERROR =  InvalidInputError.new("There is no piece at that square.")
  WRONG_COLOR_ERROR = InvalidInputError.new("That is not your piece.")

  def take_turn
    piece = ""
    start_pos = []
    piece = ""
    move_seq = []
    begin
      puts "Please enter the coordinates of the piece you wish to move.  (Format:  '5, 3')"
      start_pos = gets.chomp.gsub(" ", "").split(",").map { |num| num.to_i }
      raise INVALID_POSITION_ERROR unless valid_position?(start_pos)
      raise NO_PIECE_ERROR if @game.board[start_pos].nil?
      
      piece = @game.board[start_pos]
      raise WRONG_COLOR_ERROR if piece.color != self.color
      
      puts "Please enter the sequence of moves you would like this piece to undertake."
      while true
        puts "Enter the next position for this piece to move to, or Enter to finish.  (Format: '5, 3')"
        target_pos = gets.chomp.gsub(" ", "").split(",").map { |num| num.to_i }
        break if target_pos == []
        raise INVALID_POSITION_ERROR unless valid_position?(target_pos)
        move_seq << target_pos
      end
      piece.perform_moves(move_seq)
    rescue InvalidInputError => e
      puts e
      retry
    rescue InvalidMoveError => e
      puts e
      retry
    end
  end

  def valid_position?(input)
    return false if input.length != 2
    return false if input.any? { |entry| entry.class != Fixnum }
    return false if input.any? { |entry| entry < 0 || entry > 7}
    true
  end
end
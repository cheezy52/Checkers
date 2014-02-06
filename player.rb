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
    debugger
    begin
      piece = get_starting_piece
      move_seq = get_move_sequence(piece)
      piece.perform_moves(move_seq)
    rescue InvalidInputError => e
      puts e
      retry
    rescue InvalidMoveError => e
      puts e
      retry
    end
  end

  private

  def get_starting_piece
    puts "Please enter the coordinates of the piece you wish to move.  (Format:  '5, 3')"
    start_pos = get_input
    raise INVALID_POSITION_ERROR unless valid_position?(start_pos)
    raise NO_PIECE_ERROR if @game.board[start_pos].nil?
      
    piece = @game.board[start_pos]
    raise WRONG_COLOR_ERROR if piece.color != self.color
    piece
  end

  def get_move_sequence(piece)
    puts "Please enter the sequence of moves you would like this piece to undertake."
    move_seq = []
    while true
      puts "Enter the next position for this piece to move to, or Enter to finish.  (Format: '5, 3')"
      target_pos = get_input
      break if target_pos == []
      raise INVALID_POSITION_ERROR unless valid_position?(target_pos)
      move_seq << target_pos
    end
    move_seq
  end

  def get_input
    input = gets.chomp
    parse_input(input)
  end

  def parse_input(input)
    input.chomp.gsub(" ", "").split(",").map { |num| num.to_i }
  end

  def valid_position?(input)
    return false if input.length != 2
    return false if input.any? { |entry| entry.class != Fixnum }
    return false if input.any? { |entry| entry < 0 || entry > 7}
    true
  end

  def to_s
    name
  end
end
class HumanPlayer < Player
  def take_turn
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
    puts "Please enter the square of the piece you wish to move.  (Format:  'a4')"
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
      puts "Enter the next square for this piece to move to, or Enter to finish.  (Format: 'a4')"
      target_pos = get_input
      break if target_pos.nil?
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
    return nil if input == ""
    cols = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
    raw_coords = input.chomp
    row = 8 - raw_coords[1].to_i
    col = cols[raw_coords[0]]
    [row, col]
  end

  def valid_position?(pos)
    return false if pos.length != 2
    return false if pos.any? { |entry| entry.class != Fixnum }
    return false if pos.any? { |entry| entry < 0 || entry > 7}
    true
  end
end
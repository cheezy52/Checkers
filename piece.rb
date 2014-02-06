class Piece
  attr_reader :color
  attr_accessor :king, :pos, :board
  def initialize(pos, color, board = nil)
    @king = false
    @color = color
    @pos = pos
    @board = board
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else raise InvalidMoveError.new("Invalid move sequence.")
    end
    nil
  end

  def attempt_move(target_pos)
    if valid_slide?(target_pos)
      perform_slide!(target_pos)
    elsif valid_jump?(target_pos)
      perform_jump!(target_pos)
    else raise InvalidMoveError.new("Not a valid slide or jump.")
    end
  end

  def to_s
    if self.king
      @color == :r ? "R" : "B"
    else
      @color == :r ? "r" : "b"
    end
  end

  protected

  def perform_moves!(move_sequence)
    if move_sequence.length > 1
      if valid_slide?(move_sequence[0])
        raise InvalidMoveError.new("Cannot move again after initially sliding.")
      
      elsif valid_jump?(move_sequence[0])
        perform_jump!(move_sequence[0])
        
        move_sequence[1..-1].each do |target_pos|
          if valid_jump?(target_pos)
            perform_jump!(target_pos)
          else raise InvalidMoveError.new("All moves in sequence after the first must be valid jumps.")
          end
        end

      else raise InvalidMoveError.new("First move is not a valid slide or jump.")
      end

    else
      attempt_move(move_sequence[0])
    end
    nil
  end

  def perform_slide!(target_pos)
    move!(target_pos)
  end

  def perform_jump!(target_pos)
    jumped_pos = get_jumped_pos(self.pos, target_pos)
    move!(target_pos)
    board[jumped_pos] = nil
  end

  private

  def try_promotion
    self.king = true if (self.pos[0] == 0 && self.color == :r) 
    self.king = true if (self.pos[0] == 7 && self.color == :b)
  end

  def move_diffs(move_type)
    slide_diffs = { :b => [[1, 1], [1, -1]], :r => [[-1, 1], [-1, -1]] }
    jump_diffs = { :b => [[2, 2], [2, -2]], :r => [[-2, 2], [-2, -2]] }

    if move_type == "slide"
      self.king ? slide_diffs[:r] + slide_diffs[:b] : slide_diffs[self.color]
    elsif move_type == "jump"
      self.king ? jump_diffs[:r] + jump_diffs[:b] : jump_diffs[self.color]
    else raise "Invalid input to move_diffs - must be 'slide' or 'jump'"
    end
  end

  def valid_slide?(target_pos)
    return false unless move_diffs("slide").any? do |offset|
      target_pos == [self.pos[0] + offset[0], self.pos[1] + offset[1]]
    end
    return false unless board[target_pos].nil?
    true
  end

  def valid_jump?(target_pos)
    return false unless move_diffs("jump").any? do |offset|
      target_pos == [self.pos[0] + offset[0], self.pos[1] + offset[1]]
    end 
    return false unless board[target_pos].nil?
    return false unless !board[get_jumped_pos(self.pos, target_pos)].nil?
    return false unless board[get_jumped_pos(self.pos, target_pos)].color != self.color
    true
  end

  def get_jumped_pos(start_pos, target_pos)
    diff = [target_pos[0] - start_pos[0], target_pos[1] - start_pos[1]]
    jumped_pos = [start_pos[0] + diff[0] / 2, start_pos[1] + diff[1] / 2]   
  end

  def valid_move_seq?(move_sequence)
    begin
      temp_piece = self.dup
      temp_board = @board.dup
      temp_piece.board = temp_board
      temp_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts e
      false
    else
      true
    end
  end

  def move!(target_pos)
    board[target_pos] = self
    board[self.pos] = nil
    self.pos = target_pos
    try_promotion
  end

end
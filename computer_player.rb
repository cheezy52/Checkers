class ComputerPlayer < Player
  def take_turn
    possible_turns = build_move_tree
    #Randomly select a move to start with as our baseline
    best_piece = possible_turns.keys.sample
    best_move = [best_piece, possible_turns[best_piece].sample]
    best_length = best_move[1].length

    possible_turns.each do |piece, move_seqs|
      move_seqs.each do |move_seq|
        if move_seq.length > best_length
          best_move = [piece, move_seq]
        elsif piece.valid_jump?(move_seq[0]) && !best_piece.valid_jump?(best_move[1][0])
          best_move = [piece, move_seq]
        end
      end
    end
    best_move[0].perform_moves(best_move[1])
  end

  def build_move_tree
    #Returns results as a hash, with pieces as keys
    #The value for that piece is an array of all its possible move sequences
    #Each element of that array is an array representing a move sequence
    #Each element of that sub-array is a target position for one move in the sequence
    my_pieces = @game.board.all_pieces.select { |piece| piece.color == self.color }
    possible_sequences = {}
    my_pieces.each do |piece|
      piece_moves = build_piece_move_tree(piece)
      possible_sequences[piece] = piece_moves unless piece_moves == [] 
    end
    possible_sequences
  end

  def build_piece_move_tree(piece)
    possible_sequences = find_slides(piece) + find_jumps(piece)
    possible_sequences.delete([])
    possible_sequences
  end

  def find_slides(piece)
    slide_sequences = []
    piece.move_diffs("slide").each do |diff|
      target_pos = [piece.pos[0] + diff[0], piece.pos[1] + diff[1]]
      next if target_pos.any? { |coord| coord < 0 || coord > 7 }
      if piece.valid_slide?(target_pos)
        slide_sequences << [target_pos]
      end
    end
    slide_sequences
  end

  def find_jumps(piece)
    jump_sequences = []
    piece.move_diffs("jump").each do |diff|
      this_path_jumps = []
      target_pos = [piece.pos[0] + diff[0], piece.pos[1] + diff[1]]
      next if target_pos.any? { |coord| coord < 0 || coord > 7 }
      if piece.valid_jump?(target_pos)
        this_path_jumps << target_pos
        temp_board = piece.board.dup
        temp_piece = temp_board[piece.pos]
        temp_piece.attempt_move(target_pos)
        this_path_jumps += find_jumps(temp_piece).flatten(1)
      end
      jump_sequences << this_path_jumps unless this_path_jumps == []
    end
    jump_sequences
  end
end
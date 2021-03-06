class Board
  attr_accessor :game, :grid
  def initialize(game, populate = true)
    @game = game
    @grid = build_empty_grid
    populate_board if populate
  end

  def dup
    new_board = self.class.new(@game, false)
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        unless piece.nil?
          new_board.add_piece([row_index, col_index], piece.color, piece.king)
        end
      end
    end
    new_board
  end

  def populate_board
    (5..7).each { |row| (0..7).each { |col| add_piece([row, col], :r) if col % 2 == (row + 1) % 2 } }
    (0..2).each { |row| (0..7).each { |col| add_piece([row, col], :b) if col % 2 == (row + 1) % 2 } }
  end

  def add_piece(pos, color, king=false)
    self[pos] = Piece.new(pos, color, self)
    self[pos].king = true if king
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, arg)
    @grid[pos[0]][pos[1]] = arg
  end

  def all_pieces
    pieces = []
    @grid.each do |row|
      row.each do |piece|
        pieces << piece unless piece.nil?
      end
    end
    pieces
  end

  def to_s
    output_string = "\n  a b c d e f g h  \n"
    (0..7).each do |row|
      output_string += "#{8 - row} "
      (0..7).each { |col| self[[row, col]].nil? ? output_string += "  " : output_string += "#{self[[row, col]].to_s} " }
      output_string += "#{8 - row}\n"
    end
    output_string += "  a b c d e f g h  \n\n"
  end

  private
  
  def build_empty_grid
    @grid = Array.new(8) { Array.new(8) }
  end

end
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
          new_board.add_piece([row_index, col_index], piece.color)
        end
      end
    end
    new_board
  end

  def build_empty_grid
    @grid = Array.new(8) { Array.new(8) }
  end

  def populate_board
    (5..7).each { |row| (0..7).each { |col| add_piece([row, col], :r) if col % 2 == (row + 1) % 2 } }
    (0..2).each { |row| (0..7).each { |col| add_piece([row, col], :b) if col % 2 == (row + 1) % 2 } }
  end

  def add_piece(pos, color)
    self[pos] = Piece.new(pos, color, self)
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
    output_string = "\n  0 1 2 3 4 5 6 7  \n"
    (0..7).each do |row|
      output_string += "#{row} "
      (0..7).each { |col| self[[row, col]].nil? ? output_string += "  " : output_string += "#{self[[row, col]].to_s} " }
      output_string += "#{row}\n"
    end
    output_string += "  0 1 2 3 4 5 6 7  \n"
  end
end
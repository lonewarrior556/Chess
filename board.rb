require './pieces'

class Board

  attr_accessor :board, :dictionary, :turn

  ORDER= [:rook, nil, :bishop, :queen, nil, :bishop, nil, :rook]
  K_UNITS = [nil, :knight, nil, nil, :king, nil,:knight, nil]

  def initialize
    @board = Array.new(8) {Array.new(8)}
    build_board
    create_board_hash
    @turn = :white
  end

  def toggle_turn
    @turn == :white ? @turn = :black : @turn = :white
  end

  def build_board

    8.times do |col|
      @board[1][col] = Pawns.new([1,col],:white, @board, :pawn)
      @board[6][col] = Pawns.new([6,col],:black, @board, :pawn)
      @board[0][col] = Sliding_Pieces.new([0,col],:white,@board,ORDER[col])
      @board[7][col] = Sliding_Pieces.new([7,col],:black,@board,ORDER[col])
      next if K_UNITS[col].nil?
      @board[0][col] = Stepping_Pieces.new([0,col],:white,@board,K_UNITS[col])
      @board[7][col] = Stepping_Pieces.new([7,col],:black,@board,K_UNITS[col])
    end

  end

  def create_board_hash
    @dictionary = Hash.new
    columns = %w(a b c d e f g h)

    8.times do |row_idx|
      8.times do |col_idx|
        dictionary[columns[col_idx] + (8 - row_idx).to_s] = [row_idx, col_idx]
      end
    end

    nil
  end

  def display
    count = 8
    puts " A  B  C  D  E  F  G  H  "
    @board.each do |row|
      drawn=''
      row.each do | cell |
        if cell.nil?
          drawn << " _ "
        else
          drawn << " " + cell.render + " "
        end
      end
      drawn << count.to_s
      count -= 1
      puts drawn
    end

    nil
  end

  def check?(color)
    possible_moves = []
    king_pos = []

    @board.each do |row|
      row.each do |cell|
        next if cell.nil?
        if cell.color == color && cell.rank == :king
          king_pos = cell.position
        elsif cell.color != color
          possible_moves.concat(cell.moves)
        end
      end
    end

    possible_moves.include?(king_pos)
  end




end

require './pieces'
require 'yaml'

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
      @board[1][col] = Pawns.new([1,col],:black,          @board, :pawn)
      @board[6][col] = Pawns.new([6,col],:white,          @board, :pawn)
      @board[0][col] = Sliding_Pieces.new([0,col],:black, @board,ORDER[col])
      @board[7][col] = Sliding_Pieces.new([7,col],:white, @board,ORDER[col])
      next if K_UNITS[col].nil?
      @board[0][col] = Stepping_Pieces.new([0,col],:black, @board,K_UNITS[col])
      @board[7][col] = Stepping_Pieces.new([7,col],:white,@board,K_UNITS[col])
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

  def board_dup
    YAML.load(self.to_yaml)
  end

  def move(start_pos, end_pos)
    #reject if @turn != color
    piece = @board[start_pos.first][start_pos.last]
    return "No Piece" if piece.nil?
    return "Not 'yo Piece" if piece.color != @turn
    return "Wrong Move" unless piece.moves.include?(end_pos)

    test_board = self.board_dup

    test_board.board[start_pos.first][start_pos.last].move(end_pos)
    test_board.toggle_turn
    return "Cannot move self to check" if test_board.check?(test_board.turn)

    piece.move(end_pos)
    toggle_turn
    true
  end




  def game_over?(color)
    poss_move_set = check?(color,true)

    poss_move_set.each do |(from , to)|
      new_board = self.board_dup
      if new_board.move(from, to) == true
        return false
      end
    end

    true
  end

  def play
    display


    until game_over?(turn)
      puts "#{@turn} Please move (start,finish)"
      choice = gets.chomp.split(",")
      choice = [@dictionary[choice.first], @dictionary[choice.last]]
      move(*choice)
      display
    end
    toggle_turn
    return "#{@turn} WINS!" if check?(turn)
    "Draw"
  end



  def check?(color, more = false)
    possible_moves = []
    king_pos = []
    poss_move_set = []

    @board.each do |row|
      row.each do |cell|
        next if cell.nil?
        if cell.color != color && cell.rank == :king
          king_pos = cell.position
        elsif cell.color == color
          possible_moves.concat(cell.moves)

          cell.moves.each do |move|
            poss_move_set << [cell.position,move]
          end
        end
      end
    end

    return poss_move_set if more
    possible_moves.include?(king_pos)
  end

end

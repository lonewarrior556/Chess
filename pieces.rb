require 'byebug'

class Pieces
  RENDER_HASH_BLACK = {:pawn=>"\u265f",
                      :knight=>"\u265e",
                      :king=>"\u265a",
                      :queen=>"\u265b",
                      :rook=>"\u265c",
                      :bishop=>"\u265d"}

  RENDER_HASH_WHITE = {:pawn=>"\u2659",
                      :knight=>"\u2658",
                      :king=>"\u2654",
                      :queen=>"\u2655",
                      :rook=>"\u2656",
                      :bishop=>"\u2657"}

  attr_accessor :position, :color, :board, :rank

  def initialize(position, color, board, rank)
    @position = position
    @color = color
    @board = board
    @rank = rank
  end

  def moves
    "will return all able moves"
  end

  def move(pos)
    @board[@position.first][@position.last]=nil
    @board[pos.first][pos.last] = self
    @position = pos

  end

  def valid_moves(all_moves)
    valid_moves = []
    all_moves.each do |(row, col)|
      if @board[row][col].nil?
        valid_moves << [row,col]
        next
      end
      unless @board[row][col].color == @color
        valid_moves << [row, col]
      end
    end

    valid_moves
  end

  def remove_invalid(pos)
    pos -= [position]
    pos.select{ |(row, col)| row.between?(0,7) && col.between?(0,7)}
  end

  def render
    d={:white=>RENDER_HASH_WHITE,:black=>RENDER_HASH_BLACK}
    d[color][self.rank]
  end

end


class Sliding_Pieces < Pieces

    DIAGONAL_MOTION=[[1,1],[-1,1],[-1,-1],[1,-1]]
    STRAIGHT_MOTION = [[-1,0],[1,0],[0,1],[0,-1]]

    DIC = { :rook => STRAIGHT_MOTION, :bishop => DIAGONAL_MOTION, :queen => DIAGONAL_MOTION+STRAIGHT_MOTION}

  def moves
    pos = []
    DIC[self.rank].each do |(row,col)|
      (1...8).to_a.each do |idx|
        pos << [position.first + row*idx , position.last + col*idx]
        break if remove_invalid([pos[-1]]) == []

        last_obj = @board[pos.last.first][pos.last.last]
        break unless last_obj.nil?
      end
    end

    all_moves = remove_invalid(pos)
    valid_moves(all_moves)
  end

end

class Stepping_Pieces < Pieces

    KNIGHT_MOTION= [ [1,2],[2,1],[1,-2],[-2,1],[-1,2],[2,-1],[-1,-2],[-2,-1]]
    KING_MOTION=[[0,1],[0,-1],[1,0],[1,1],[1,-1],[-1,-1],[-1,0],[-1,1]]

    DIC= {:king=>KING_MOTION,:knight=>KNIGHT_MOTION}

  # def move(pos)
  #   if self.rank == :knight
  #     return "ERROR" if !knight_moves.include?(pos)
  #   else
  #     return "ERROR" if !king_moves.include?(pos)
  #   end
  #   super(pos)
  # end

  def moves
      pos=[]
      DIC[self.rank].each do |(row, col)|
        pos << [position.first + row, position.last + col]
      end

      all_moves = remove_invalid(pos)
      valid_moves(all_moves)
  end

end

class Pawns < Pieces
  attr_accessor :pawn_motion

  def initialize(position, color, board, rank)
    super(position, color, board, rank)
    @moved = false
    set_moves
  end

  def set_moves
    if color == :black
      @pawn_motion = [[1,0], [1,1], [1,-1], [2,0]]
    else
      @pawn_motion = [[-1,0], [-1,1], [-1,-1], [-2,0]]
    end
  end

  def move(pos)
    super(pos)
    @moved = true
  end

  def moves
    @pawn_motion = pawn_motion.take(3) if @moved
    pos = []
    @pawn_motion.each do |(row,col)|
      pos << [position.first + row, position.last + col]
    end

    all_moves = remove_invalid(pos)
    valid_moves(all_moves)
end

  def valid_moves(all_moves)
    valid_moves = []
    f_moves=[]
    all_moves.each do |(row,col)|
      if col == self.position.last
        f_moves << [row,col]
      else
        if !@board[row][col].nil? && @board[row][col].color != self.color
          valid_moves << [row,col]
        end
      end
    end
    f_moves.each do |(row,col)|
      if @board[row][col].nil?
        valid_moves << [row,col]
      else
        break
      end
    end

    valid_moves
  end

end

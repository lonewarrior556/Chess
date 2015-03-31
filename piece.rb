class Pieces
  RENDER_HASH = {:pawn=>" p ",
                :knight=>" n ",
                :king=>" K ",
                :queen=>" Q ",
                :rook=>" r ",
                :bishop=>" b "}

  attr_accessor :position, :color, :board, :rank

  def initialize(position, color, board, rank)
    @position = position
    @color = color
    @board = board
    @rank = rank
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
        valid_moves << [row,col]
      end
    end

    valid_moves
  end

  def remove_invalid(pos)
    pos = pos - [position]
    pos.select{ |(row, column)| row.between?(0,7) && column.between?(0,7)}
  end

  def render
    RENDER_HASH[self.rank]
  end


end


class Sliding_Pieces < Pieces

    DIAGONAL_MOTION=[[1,1],[-1,1],[-1,-1],[1,-1]]
    STRAIGHT_MOTION = [[-1,0],[1,0],[0,1],[0,-1]]

    DIC = { :rook => STRAIGHT_MOTION, :bishop => DIAGONAL_MOTION, :queen => DIAGONAL_MOTION+STRAIGHT_MOTION}

  def sliding_piece_moves
    pos = []
    DIC[self.rank].each do |(row,col)|
      8.times do |idx|
        next if idx == 0
        pos << [position.first + row*idx , position.last + col*idx]
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

  def move(pos)
    if self.rank == :knight
      return "ERROR" if !knight_moves.include?(pos)
    else
      return "ERROR" if !king_moves.include?(pos)
    end
    super(pos)
  end

  def stepping_piece_moves
      pos=[]
      DIC[self.rank].each do |move|
        pos << [position.first + move.first, position.last + move.last]
      end

      all_moves = remove_invalid(pos)
      valid_moves(all_moves)
  end

end

class Pawns < Pieces

  def initialize(position, color, board, rank)
    super(position, color, board, rank)
    @moved = false
    set_moves
  end

  attr_accessor :pawn_motion

  def set_moves
    if color == :white
      @pawn_motion = [[1,0],[1,1],[1,-1],[2,0]]
    else
      @pawn_motion = [[-1,0],[-1,1],[-1,-1],[-2,0]]
    end

  end

  def pawn_moves
    pos=[]
    if @moved
      @pawn_motion = pawn_motion.take(3)
    end

    @pawn_motion.each do |move|
      pos << [position.first + move.first, position.last + move.last]
    end

    valid_moves(pos)

  end

  def valid_moves(all_moves)
    valid_moves = []
    forward = []
    sides = all_moves[1..2]
    forward << all_moves[0] << all_moves[3].to_a

    sides.each do |(row,col)|
      next if @board[row][col].nil?
      if self.color != @board[row][col].color
        valid_move << side
      end
    end

    forward.each do |front|
      if @board[front.first][front.last].nil?
        valid_moves << front
      else
        break
      end
    end

    valid_moves
  end


end

class Pieces
  attr_accessor :position, :color

  def initialize (position, color, board)
    @position = position
    @color = color
    @board = board

  end

  def moves


  end

  def valid_moves
    "generic piece move"
  end

  def remove_invalid(pos)
    pos = pos - [position]
    pos.select{ |(row, column)| row.between?(0,7) && column.between?(0,7)}
  end



end


class Sliding_Pieces < Pieces

  DIAGNAL_MOTION=[[1,1],[-1,1],[-1,-1],[1,-1]]


  def initialize(position, color, board, rank)
    super(position, color, board)
    @rank = rank
  end

  def rook_moves
    pos_moves = []

    8.times do |idx|
      pos_moves << [position.first, idx]
      pos_moves << [idx, position.last]
    end

    remove_invalid(pos)
  end

  def bishop_moves
    pos = []
    8.times do |idx|
      DIAGNAL_MOTION.each do |move|
        pos << [position.first + move.first*idx , position.last + move.last*idx]
      end
    end

    remove_invalid(pos)
  end

end

class Stepping_Pieces < Pieces

    KNIGHT_MOTION= [ [1,2],[2,1],[1,-2],[-2,1],[-1,2],[2,-1],[-1,-2],[-2,-1]]
    KING_MOTION=[[0,1],[0,-1],[1,0],[1,1],[1,-1],[-1,-1],[-1,0],[-1,1]]

  def knight_moves
      pos=[]
      KNIGHT_MOTION.each do |move|
        pos << [position.first + move.first, position.last + move.last]
      end

      remove_invalid(pos)
  end

  def king_moves
      pos=[]
      KING_MOTION.each do |move|
        pos << [position.first + move.first, position.last + move.last]
      end

      remove_invalid(pos)
  end

end

class Pawns < Pieces

  def initialize(position, color, board)
    super(position, color, board)
    @moved = false
    set_moves
  end

  attr_accessor :pawn_motion

  def set_moves
    if color == :white
      @pawn_motion = [[0,1],[1,1],[-1,1],[0,2]]
    else
      @pawn_motion = [[0,-1],[1,-1],[-1,-1],[0,-2]]
    end

  end

  def pawn_moves
    pos=[]
    if @moved
      @pawn_motion = pawn_motion.take(3)
    end

    pawn_motion.each do |move|
      pos << [position.first + move.first, position.last + move.last]
    end

    remove_invalid(pos)
  end




end

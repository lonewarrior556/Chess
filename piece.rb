class Pieces
  attr_accessor :position

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

    pos_moves - [position]
  end

  def bishop_moves
    pos = []
    8.times do |idx|
      DIAGNAL_MOTION.each do |move|
        pos << [position.first + move.first*idx , position.last + move.last*idx]
      end
    end
    pos = pos - [position]
    pos.select{ |(row, column)| row.between?(0,7) && column.between?(0,7)}

  end



end


class Stepping_Pieces < Pieces



end

class Pawns < Pieces


end

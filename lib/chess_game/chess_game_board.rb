require_relative '../chess_pieces/pieces_creator.rb'
require_relative '../chess_game/move_generator.rb'

class ChessBoard
  # A Hash containing the info for setting up the major pieces as the game starts
  # the unicodes array follow the convention black unicode first (but it appears white on my terminal somehow)
  attr_reader :board, :pieces

  def initialize
    @board = create_board
    @pieces = get_pieces
  end

  # Board Related Methods

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def get_pieces
    piece_creator = ChessPiecesCreator.new
    piece_creator.pieces
  end

  def reset_board
    @board = create_board
    @pieces = get_pieces
  end

  def populate_board(pieces)
    pieces.each do |piece|
      row, col = piece.position
      @board[row][col] = piece.unicode
    end
  end

  def clean_cell(position)
    row, col = position
    @board[row][col] = " "
  end

  def display_board
    i = 8
    p "   #{('a'..'h').to_a.join('   ')}  "
    puts '   -------------------------------'
    @board.each do |row|
      puts " #{i}  #{row.join(' | ')}  #{i}"
      puts '   -------------------------------'
      i -= 1
    end
    p "   #{('a'..'h').to_a.join('   ')}  "
    puts
  end

  def update_board
    populate_board(@pieces)
    display_board
  end

  def select_piece_at(position)
    @pieces.find { |piece| piece.position == position }
  end

  def move_piece(piece, position)
    snack_piece_at(position) if has_oponent?(piece, position)
    piece.position = position
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    @pieces.delete(piece)
  end

  def position_is_free?(position)
    positions = @pieces.map(&:position)
    !positions.include?(position)
  end

  def has_oponent?(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color != moving_piece.color
  end

  def has_ally?(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color == moving_piece.color
  end

  def is_out_of_board?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7) ? false : true
  end

  def select_opponent_pieces(piece)
    opponent_pieces = @pieces.select { |p| p.color != piece.color }
  end

  def get_opponent_possible_moves(king)
    opponent_possible_moves = []
    opponent_pieces = select_opponent_pieces(king)
    opponent_pieces.each do |piece|
      mover = MoveGenerator.new(piece, self)
      opponent_possible_moves << mover.generate_possible_moves
    end
    opponent_possible_moves.flatten(1)
  end

  def is_check?(king)
    opp_possibles_moves = get_opponent_possible_moves(king)
    opp_possibles_moves.include?(king.position)
  end
end


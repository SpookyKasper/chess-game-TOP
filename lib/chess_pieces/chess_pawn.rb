require_relative '../chess_game/chess_game_move_module.rb'
require_relative '../chess_pieces/chess_piece.rb'

class ChessPawn < ChessPiece

  def on_initial_position?
    current_row = @position[0]
    initial_row = @color == 'white' ? 6 : 1

    current_row == initial_row
  end
end

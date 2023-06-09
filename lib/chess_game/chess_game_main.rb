require_relative '../chess_game/chess_game.rb'
require_relative '../chess_game/chess_game_player.rb'
require_relative '../chess_game/chess_game_board.rb'

player_1 = ChessPlayer.new('white', 'Daniel')
player_2 = ChessPlayer.new('black', 'Bruna')
board = ChessBoard.new

chess_game = ChessGame.new(board, player_1, player_2)

chess_game.play

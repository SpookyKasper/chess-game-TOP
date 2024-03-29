
require_relative 'chess_array_translator.rb'

class ChessDisplay
  include ChessArrayTranslator


  COLORS = {
    red: "\e[31m",
    green: "\e[32m",
    yellow: "\e[33m",
    blue: "\e[34m",
    magenta: "\e[35m",
    cyan: "\e[36m",
    white: "\e[37m"
  }

  def display_message_in_color(message, color)
    puts "#{COLORS[color]}#{message} \e[0m"
  end

  # Instructions messages are in Yellow

  def introduction(player1, player2)
    message = <<~HEREDOC

      Welcome #{player1.name} and #{player2.name} to your new favorite chess game
      In this game you select the positions by typing a combination of 2 characters:

      The first character denoting the 'file' or column and the second character
      representing the 'rank' or row.
      Here are some exemples e2, e4, d7, d5 etc.

      Each player can also type 'resign' to resign the game or 'save'
      to save the game.
      That's it! You are all set! Further instructions will come along the way if needed ;)
    HEREDOC
    display_message_in_color(message, :white)
  end

  def select_piece_message(player)
    message = "#{player.name} select the piece you would like to move by typing it\'s position"
    display_message_in_color(message, :yellow)
  end

  def move_piece_message(piece)
    message = "Type the position you want to move the #{piece.specie} to"
    display_message_in_color(message, :yellow)
  end

  def possible_moves_message(piece, moves)
    chess_moves = moves.map { |move| translate_array_to_chess(move) }
    message = "These are the possible moves for the #{piece.specie} #{chess_moves}"
    display_message_in_color(message, :yellow)
  end

  def promotion_message(player)
    message = "Which piece do you want to promote the pawn to #{player.name}?"
    display_message_in_color(message, :yellow)
  end

  # Confirmation messages are in green

  def confirm_saving_message
    message = 'Game was successfuly saved'
    display_message_in_color(message, :green)
  end

  def confirm_selection_message(player, piece)
    chess_position = translate_array_to_chess(piece.position)
    message = "#{player.name} you just selected the #{piece.specie} on #{chess_position}"
    display_message_in_color(message, :green)
  end


  def confirm_move_message(player, piece, target_position)
    chess_position = translate_array_to_chess(target_position)
    message = "#{player.name} just moved the #{piece.specie} to #{chess_position}"
    display_message_in_color(message, :green)
  end

  # Check related messages are in magenta

  def check_message(player)
    message = "#{player.name} you are in check!"
    display_message_in_color(message, :magenta)
  end

  def check_mate_message(player, winner)
    message = "Game is over, #{player.name} you are check_mate!, Congratulations #{winner.name} you won!"
    display_message_in_color(message, :magenta)
  end

  def resign_message(player, winner)
    message = "#{player.name} you just resigned the game, congratulations #{winner.name} you win!"
    display_message_in_color(message, :green)
  end

  # Error messages are in red

  def piece_cant_move_message(piece)
    message = "The #{piece.specie} can't move!"
    display_message_in_color(message, :red)
  end

  def wrong_move_message(input, piece)
    chess_piece = piece.specie
    chess_position = translate_array_to_chess(piece.position)
    message = <<~HEREDOC.chomp
      #{input} is not a valid move for the #{chess_piece} on #{chess_position}
      please input a valid move or type exit to select another piece!
    HEREDOC
    display_message_in_color(message, :red)
  end

  def wrong_piece_selection_message(player)
    message = <<~HEREDOC.chomp
      Please input the position of a #{player.color} piece
      HEREDOC
    display_message_in_color(message, :red)
  end

  def keep_out_of_check_message(player)
    message = "#{player.name} You have to keep your king out of check!"
    display_message_in_color(message, :red)
  end

  def wrong_promotion
    message = <<~HEREDOC.chomp
      Please input a valid piece to promote the pawn to, the options are:
      queen
      bishop
      knight
      rook
    HEREDOC
    display_message_in_color(message, :red)
  end

  # Draw messages are in cyan

  def draw_message
   message = 'Congratulations girls the game is draw and you both won! (or none of you did depending how you want to look at it)'
   display_message_in_color(message, :cyan)
  end
end

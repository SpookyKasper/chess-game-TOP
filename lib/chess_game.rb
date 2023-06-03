require_relative '../lib/chess_game_move_module.rb'

class ChessGame

  include MovePiece
  attr_reader :pieces

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
    @pieces = create_pieces
  end

  def play_move(player)
    from_chess_position = select_piece_input(player)
    from_array_position = translate_chess_to_array(from_chess_position)
    piece = select_piece(from_array_position)
    to_chess_position = move_piece_input(piece)
    to_array_position = translate_chess_to_array(to_chess_position)
    move_piece(piece, to_array_position)
    @board.clean_cell(from_array_position)
  end


  def play_round
    players = [@player_1, @player_2]
    until game_over?
      update_board
      current_player = players.shift
      play_move(current_player)
      players << current_player
    end
  end

  def game_over?
  end

  def select_piece_input(player)
    select_piece_message(player)
    input = gets.chomp
    until valid_pick?(player, input) do
      puts "Please input the position of a #{player.color} piece"
      input = gets.chomp
    end
    input
  end

  def select_piece(position)
    pieces = @pieces.flatten(1)
    piece = pieces.select { |piece| piece.position == position }
    piece.first
  end

  def move_piece_input(piece)
    move_piece_message
    chess_position = gets.chomp
    until valid_move?(piece, chess_position) do
      puts 'please input a valid move'
      chess_position = gets.chomp
    end
    chess_position
  end

  def move_piece(piece, position)
    piece.position = position
  end

  def valid_pick?(player, chess_position)
    array_position = translate_chess_to_array(chess_position)
    piece = select_piece(array_position)
    return if piece.nil?

    piece.color == player.color
  end

  def valid_move?(piece, chess_position)
    array_position = translate_chess_to_array(chess_position)
    possible_moves = get_potential_moves(piece)
    possible_moves.include?(array_position)
  end

  def has_oponent(moving_piece, position)
    piece = select_piece(position)
    return false if piece.nil?

    piece.color != moving_piece.color
  end

  def get_potential_moves(piece)
    moves = []
    moves << piece.potential_moves
    moves << add_special_case_pawn_moves(piece) if piece.is_a?(ChessPawn)
    moves.flatten(1)
  end

  def add_special_case_pawn_moves(pawn)
    valid_moves = []
    position = pawn.position
    direction = pawn.color == 'white' ? 1 : -1
    main_diag = move_main_diagonal(position, direction)
    sec_diag = move_secondary_diagonal(position, direction)

    valid_moves << main_diag if has_oponent(pawn, main_diag)
    valid_moves << sec_diag if has_oponent(pawn, sec_diag)

    valid_moves
  end

  def select_piece_message(player)
    puts "Hey #{player.name} you'r are playing with #{player.color} pieces,  select the piece you would like to move by typing it\'s position"
  end

  def move_piece_message
    puts 'Type the square you want to move the piece to'
  end

  def translate_chess_to_array(input)
    chess_rows = (8).downto(1).to_a
    chess_columns = ('a').upto('h').to_a
    col, row = input.split('')
    a_col = chess_columns.index(col)
    a_row = chess_rows.index(row.to_i)
    [a_row, a_col]
  end

  def create_pawns
    pawns = []
    (0..7).each_with_index do |num, index|
      pawns << ChessPawn.new([1, index], 'black')
      pawns << ChessPawn.new([6, index], 'white')
    end
    pawns
  end

  def create_pieces
    pieces = []
    pieces << create_pawns
    pieces
  end

  def update_board
    @board.populate_board(@pieces.flatten)
    @board.display_board
  end
end

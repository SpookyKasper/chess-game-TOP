require_relative '../lib/pieces_creator.rb'

describe ChessPiecesCreator do
  describe '#create_one_type_of_pieces' do
    context 'when passed the rook hash' do
      xit 'creates a rook for each initial position' do
        rook_hash = { constructor: ChessRook,
          positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
          unicodes: ["\u265C", "\u2656"]
        }
        result = chess_board.create_one_type_of_pieces(rook_hash)
        expect(result).to include(an_instance_of(ChessRook)).exactly(4).times
      end
    end
  end

  describe '#create_piece_at_position' do
    let(:piece_creator) { described_class.new }

    context 'when passed a queen type, with a positin of [0, 2] and a color of :white' do
      it 'creates a white queen with a position of [0, 2] and the equivalent unicode' do
        queen_type = {
          constructor: ChessQueen,
         positions: [[0, 3], [7, 3]],
          unicodes: ["\u265B", "\u2655"]
        }
        position = [0, 2]
        color = :white
        result = piece_creator.create_piece_at_position(queen_type, position, color)
        expect(result).to eq('hello')
      end
    end
  end

  describe '#create_all_pieces' do
    context 'when passed a specific hash containing all the needed info' do
      xit 'creates 32 pieces' do
        hash = ChessBoard::MAJOR_PIECES_INITIAL_SETUP
        result = chess_board.create_all_pieces
        expect(result).to include(ChessPiece).exactly(32).times
      end
    end
  end

  describe '#assign_piece_color' do
    context 'when the piece is on the upper half of the board' do
      xit 'returns black' do
        position = [0, 1]
        result = chess_board.assign_piece_color(position)
        expect(result).to eq(:black)
      end
    end

    context 'when the piece is on the lower half of the board' do
      xit 'returns white' do
        position = [6, 0]
        result = chess_board.assign_piece_color(position)
        expect(result).to eq(:white)
      end
    end
  end

  describe '#assign_piece_unicode' do
    context 'when the piece is white' do

      xit 'assigns the first unicode in the unicodes array' do
        unicodes = ["\u265C", "\u2656"]
        color = :white
        result = chess_board.assign_piece_unicode(color, unicodes)
        expect(result).to eq("\u265C")
      end
    end

    context 'when the piece is black' do

      xit 'assigns the first unicode in the unicodes array' do
        unicodes = ["\u265C", "\u2656"]
        color = :black
        result = chess_board.assign_piece_unicode(color, unicodes)
        expect(result).to eq("\u2656")
      end
    end
  end
end

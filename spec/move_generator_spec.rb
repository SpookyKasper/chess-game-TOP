require_relative '../lib/move_generator.rb'
require_relative '../lib/board.rb'
require_relative '../lib/piece.rb'
require_relative '../lib/move_module'

describe MoveGenerator do
  include MovePiece

  let(:white_piece) { instance_double(ChessPiece, position: [4, 3], color: :white) }
  let(:white_ally) { instance_double(ChessPiece, position: [4, 4], color: :white) }
  let(:black_piece) { instance_double(ChessPiece, position: [3, 3], color: :black) }
  let(:board) { instance_double(ChessBoard) }
  subject(:move_generator) { described_class.new(board)}

  before do
    board.instance_variable_set(:@pieces, [white_piece, black_piece])
  end

  describe '#generate_pawn_moves' do
    context 'when its a white pawn on [6, 1] and there are no opponents around'  do
      let(:white_pawn) { instance_double(ChessPiece, specie: :pawn, color: :white, position: [6, 1]) }
      let(:board) { instance_double(ChessBoard) }
      subject(:move_generator) { described_class.new(board)}

      before do
        main_diag = [5, 0]
        sec_diag = [5, 2]
        one_front = [5, 1]
        two_front = [4, 1]
        allow(board).to receive(:position_has_oponent?).with(main_diag, white_pawn).and_return(false)
        allow(board).to receive(:en_passant_permitted?).with(white_pawn, main_diag).and_return(false)
        allow(board).to receive(:position_has_oponent?).with(sec_diag, white_pawn).and_return(false)
        allow(board).to receive(:en_passant_permitted?).with(white_pawn, sec_diag).and_return(false)
        allow(board).to receive(:position_is_free?).with(one_front).and_return(true)
        allow(board).to receive(:position_is_free?).with(two_front).and_return(true)
        allow(board).to receive(:pawn_on_initial_position?).and_return(true)
      end

      it 'returns the 2 positions in front of the pawn' do
        result = move_generator.generate_pawn_moves(white_pawn)
        expectation = [[5, 1], [4, 1]]
        expect(result).to eq(expectation)
      end
    end
  end

  describe '#generate_moves' do
    context 'when the piece is a white rook on [4, 2]' do
      let(:rook) { instance_double(ChessPiece, specie: :rook, color: :white, position: [4, 2]) }

      context 'when the direction is up and there are no pieces on the way' do

        before do
          allow(move_generator).to receive(:invalid_move_for_piece?).and_return(false, false, false, true)
          allow(board).to receive(:position_has_oponent?).and_return(false)
          allow(move_generator).to receive(:move_one).and_return([3, 2], [2, 2], [1, 2])
        end

        it 'returns [[3, 2], [2, 2], [1, 2], [0, 2]]' do
          direction = [-1, 0]
          result = move_generator.generate_moves(rook, direction)
          expectation = [[3, 2], [2, 2], [1, 2]]
          expect(result).to eq(expectation)
        end
      end

      context 'when the direction is right and there is an ally on [4, 6]' do
        let(:white_piece) { instance_double(ChessPiece, color: :white, position: [4, 6])}

        before do
          allow(move_generator).to receive(:invalid_move_for_piece?).and_return(false, false, false, true)
          allow(board).to receive(:position_has_oponent?)
          allow(move_generator).to receive(:move_one).and_return([4, 3], [4, 4], [4, 5])
        end

        it 'returns [[4, 3], [4, 4], [4, 5]]' do
          direction = [0, 1]
          result = move_generator.generate_moves(white_piece, direction)
          expectation = [[4, 3], [4, 4], [4, 5]]
          expect(result).to eq(expectation)
        end
      end
    end
  end

  describe '#generate_up_vertical_moves' do
    context 'when the rook is white and on [4, 3]' do
      let(:rook) { instance_double(ChessPiece, specie: :rook, color: :white, position: [4, 3]) }
      let(:white_piece) { instance_double(ChessPiece, color: :white) }
      let(:board) { instance_double(ChessBoard) }
      let(:move_generator) { described_class.new(rook, board)}

      context 'when there are no pieces on the way' do

        before do
          allow(board).to receive(:select_piece_at).and_return(nil)
        end

        xit 'returns [[3, 3], [2, 3], [1, 3], [0, 3]]' do
          result = move_generator.generate_up_vertical_moves(rook)
          expectation = [[3, 3], [2, 3], [1, 3], [0, 3]]
          expect(result).to eq(expectation)
        end
      end

      context 'when there is an ally on [1, 3]' do

        before do
          allow(board).to receive(:select_piece_at).and_return(nil)
          allow(board).to receive(:select_piece_at).with([1, 3]).and_return(white_piece)
        end

        xit 'returns [[3, 3], [2, 3]]' do
          result = move_generator.generate_up_vertical_moves(rook)
          expectation = [[3, 3], [2, 3]]
          expect(result).to eq(expectation)
        end
      end
    end
  end

  describe '#generate_possible_moves' do
    context 'when the piece is a white pawn' do
      let(:white_pawn) { instance_double(ChessPiece, specie: :pawn, color: :white) }
      let(:board) { instance_double(ChessBoard) }
      subject(:move_generator) { described_class.new(board)}

      context 'when the pawn is on inital position and there are no opponents around' do

        before do
          white_pawn.instance_variable_set(:@position, [6, 1])
          allow(move_generator).to receive(:generate_pawn_moves).and_return([[5, 1], [4, 1]])
        end

        it 'returns the 2 positions in front of the pawn' do
          result = move_generator.generate_possible_moves_for_piece(white_pawn)
          expectation = [[5, 1], [4, 1]]
          expect(result).to eq(expectation)
        end
      end
    end
  end
end

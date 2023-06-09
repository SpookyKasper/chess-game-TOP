require_relative '../../lib/chess_pieces/chess_pawn.rb'
require_relative '../../lib/chess_game/chess_game_board.rb'

describe ChessPawn do
  subject(:pawn) { described_class.new }

  context '#set_unicode' do
    context 'when color is black' do
      let(:blackpawn) { described_class.new([1, 0], 'black') }

      it 'sets unicode to black pawn unicode' do
        result = blackpawn.set_unicode
        expect(result).to eq("\u2659")
      end
    end

    context 'when color is white' do
      let(:whitepawn) { described_class.new([6, 0], 'white') }

      it 'sets unicode to white pawn unicode' do
        result = whitepawn.set_unicode
        expect(result).to eq("\u265F")
      end
    end
  end

  context 'when pawn is white' do
    describe '#on_initial_position?' do
      context 'when on initial position' do
        let(:whitepawn) { described_class.new([6, 0], 'white') }

        it 'returns true' do
          position = whitepawn.instance_variable_get(:@position)
          color = whitepawn.instance_variable_get(:@color)
          result = whitepawn.on_initial_position?
          expect(result).to be(true)
        end
      end

      context 'when somewhere else' do
        let(:whitepawn) { described_class.new([4, 2], 'white') }

        it 'returns false' do
          position = whitepawn.instance_variable_get(:@position)
          color = whitepawn.instance_variable_get(:@color)
          result = whitepawn.on_initial_position?
          expect(result).to be(false)
        end
      end
    end

    describe '#generate_possible_moves' do
      context 'when the pawn is on [6, 3] (d2) and there is an opponent on [5, 2] (c3)' do
        let(:board) { instance_double(ChessBoard) }
        let(:white_pawn_moving) { described_class.new([6, 3], 'white') }
        let(:black_pawn) { described_class.new([5, 2], 'black') }

        before do
          allow(board).to receive(:has_oponent).with([5, 2], white_pawn_moving).and_return(true)
          allow(board).to receive(:has_oponent).with([5, 4], white_pawn_moving).and_return(false)
          board.instance_variable_set(:@pieces, [white_pawn_moving, black_pawn])
        end

        it 'returns 3 possible moves [5, 3], [4, 3] and [5, 2]' do
          pieces = [white_pawn_moving, black_pawn]
          result = white_pawn_moving.generate_possible_moves(board)
          expectation = [[5, 3], [4, 3], [5, 2]]
          expect(result).to eq(expectation)
        end
      end
    end

    describe '#potential_moves' do
      context 'when on initial position' do
        let(:whitepawn) { described_class.new([6, 0], 'white') }

        before do
          position = whitepawn.instance_variable_get(:@position)
          allow(whitepawn).to receive(:on_initial_position?).and_return(true)
          allow(whitepawn).to receive(:move_vertically).with(position, -1).and_return([5, 0])
          allow(whitepawn).to receive(:move_vertically).with(position, -2).and_return([4, 0])
        end

        it 'returns 2 positions, one or 2 rows down' do
          result = whitepawn.potential_moves.sort
          expectation = [[5, 0], [4, 0]].sort
          expect(result).to eq(expectation)
        end
      end

      context 'when not on initial position' do
        let(:whitepawn) { described_class.new([5, 2], 'white') }

        before do
          position = whitepawn.instance_variable_get(:@position)
          allow(whitepawn).to receive(:on_initial_position?)
          allow(whitepawn).to receive(:move_vertically).with(position, -1).and_return([4, 2])
        end

        it 'returns 1 position, one row down' do
          result = whitepawn.potential_moves.sort
          expectation = [[4, 2]].sort
          expect(result).to eq(expectation)
        end
      end
    end
  end
end

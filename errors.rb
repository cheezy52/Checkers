class InvalidInputError < ArgumentError
end

class InvalidMoveError < RuntimeError
end

INVALID_POSITION_ERROR = InvalidInputError.new("That is not a valid coordinate pair.")
NO_PIECE_ERROR =  InvalidInputError.new("There is no piece at that square.")
WRONG_COLOR_ERROR = InvalidInputError.new("That is not your piece.")
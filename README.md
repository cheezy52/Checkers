This is a terminal-based implementation of checkers.  To play, navigate to the containing directory and execute "ruby checkers.rb".  A Ruby installation is required.

By default, the game will have a human player against a computer player.  This may be modified by changing the players defined in the game's "initialize" function, changing their names or switching them from HumanPlayer to ComputerPlayer and vice-versa.

To make a move, input the square you are moving your piece from, press Enter, and repeat for each subsequent square you wish to move to (e.g. multiple moves in a jump chain).  Press Enter again on a blank line when all moves have been entered.  Squares use chess notation format, with the first character being a letter for the column, and the second character being a number for the row (e.g. "e7").  Remember that only kings may jump backwards.

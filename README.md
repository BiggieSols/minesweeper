tile class
board class
minesweeper class

tile is a node with relatives
need to set up a tile to know its neighbors

what happens when a user selects a tile to play (not flag)
if bomb - you lose
  then look at adjacent tiles
  if > 0 bombs, number displays as nearby bombs
    if no bombs, then open all adjacent && unexplored tiles as well (recursively)


      win condition?
      all bombs are flagged || all non-bomb tiles are open

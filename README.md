# TicTacToe
GNU GPL v3.0

Requirements
------------
1. An x86 processor (32-bit and 64-bit should work)
2. A linux operating system
3. The NetWide Assembler (NASM. FASM should also work)
4. The GNU Linker (ld)

Installation
------------
1. `nasm -felf32 tictactoe.asm`
2. `ld -melf_i386 tictactoe.o -o tictactoe`

Playing the game
----------------
To run the program use `./tictactoe`

the board looks like this:
```
...
...
...
```

Players 1 and 2 will alternate inputting their plays using the keys `1-9` and pressing `ENTER`.
These keys correspond to the board as such:
```
123
456
789
```
(Keep in mind that the game expects perfect input and error checking does not occur)

The first player to get 3 spaces of their number in a row will win and the game will end.
The game will also end after 9 turns.

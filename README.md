# sound-of-life

Sound of life is a mix between [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) and a [tonematrix](http://tonematrix.audiotool.com/). It has a 16x16 grid circular grid where cells get born or die according to the rules of Game of Life:
 
* Any live cell with fewer than two live neighbours dies, as if caused by under-population.
* Any live cell with two or three live neighbours lives on to the next generation.
* Any live cell with more than three live neighbours dies, as if by over-population.
* Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

The game will also play sound based on the configuration of the board, similar to the Tonematrix, where every row has a sound and the board is played column by column. Sound of Life supports additional ways of interpreting the board, such as row by row parsing, diagonal, and pulse mode, which goes from the center to the edges in waves. The simulation can also be paused in order to add or remove cells or switch the mode of playing sound.

## Installation

The game is written in ARM assembly for Raspberry Pi B, and should be used only on it. However, feel free to try it out on different models, as it may work. The project is bare-metal, as such, formatting an SD card with the operating system and replacing the kernel is enough to run it.

### Compiling

<!---
  Guys, complete here
--->

### SD Card

<!---
  Guys, complete here
--->

### Controller and wiring

![Controller setup](https://github.com/ImperialGroup29-2016/sound-of-life/images/bread.png "Controller setup")

For a quick install, see the image above which shows where each wire must be connected to.

However, if you want to create your custom install, the Raspberry will except the following GPIO input(please note input is only considered on the rising edge of the sound, and needs to read the falling edge in order to reset):

* GPIO 17 represents the toggle of the virtual software interrupt, enabling input to be read from the rest of the buttons.
* GPIO 22, 23, 24 represents one step in a specific direction, 22 is up-left diagonal, 23 is down, 24 is right.
* GPIO 25 represents the toggle of the cell the pointer is currently standing on.
* GPIO 27 represents the toggle of the sound play modes. The toggle order is: `no sound`, `column by column`, `row by row`, `diagonal`, `pulse`, after which it cycles.

A monitor connected to the HDMI port and a set of speakers connected to the audio jack are also required and trivial to install.


# [Digital Logic Design](https://www4.ceda.polimi.it/manifesti/manifesti/controller/ManifestoPublic.do?EVN_DETTAGLIO_RIGA_MANIFESTO=EVENTO&c_insegn=085877&aa=2018&k_cf=225&k_corso_la=358&ac_ins=0&k_indir=II3&lang=EN&tipoCorso=ALL_TIPO_CORSO&semestre=1&idItemOfferta=137349&idRiga=229504&codDescr=085877) 2019, Course Project

- [Project Description](#project-description)
- [Data](#data)
- [Sample Input](#sample-input)
- [Implementation](#implementation)
  - [`idle` State](#idle-state)
  - [`start` State](#start-state)
  - [`takex`, `takey` and `mem` States](#takex-takey-and-mem-states)
  - [`c..x`, `c..y`, `c...` and `c...d` States](#cx-cy-c-and-cd-states)
  - [`comp_min` and `comp` States](#compmin-and-comp-states)
  - [`stop` and `done` States](#stop-and-done-states)
- [Test Generator](#test-generator)

## Project Description
Conceptually, this project is rather easy: we are given a bidimensional space and the positions of _N_ points (**centroids**) inside such space. The goal is to build a hardware component through VHDL able to find the nearest centroids in terms of Manhattan distance to a given point.

The space is a square of size `256*256`. Of the given _N_ centroids, only _K<=N_ are to be considered: this is described in an input mask where every bit is 1 if the centroid is to consider and 0 otherwise.

The difficulties of this project lie on the language and the environment used in it. Indeed, VHDL and digital circuit design are programming paradigms way different than the ones a computer scientist usually uses, due to their different application targets.

## Data

Data is stored in a memory with byte addressing, starting at position 0:
-	Index 0 is used to store the number of centroids.
-	Indices 1 to 16 are used to store the positions X,Y of every centroid:
	- Index 1 – Coord. X of 1st centroid;
	- Index 2 – Coord. Y of 1st centroid;
	- Index 3 – Coord. X of 2nd centroid;
	- Index 4 – Coord. Y of 2nd centroid;
	- …
	- Index 15 – Coord. X of 8th centroid;
	- Index 16 – Coord. Y of 8th centroid;
-	Indices 17 and 18 are used to store coordinates X, Y of the target point.
-	Index 19 is used to write the output mask.

## Sample Input

| Memory Index | Value | Description |
| ------------ | ------------ | ------------ |
| 0 | 185 | input mask: `10111001` |
| 1 | 75 | X 1st centroid |
| 2 | 32 | Y 1st centroid |
| 3 | 111 | X 2nd centroid |
| 4 | 213 | Y 2nd centroid |
| 5 | 79 | X 3rd centroid |
| 6 | 33 | Y 3rd centroid |
| 7 | 1 | X 4th centroid |
| 8 | 33 | Y 4th centroid |
| 9 | 80 | X 5th centroid |
| 10 | 35 | Y 5th centroid |
| 11 | 12 | X 6th centroid |
| 12 | 254 | Y 6th centroid |
| 13 | 215 | X 7th centroid |
| 14 | 78 | Y 7th centroid |
| 15 | 211 | X 8th centroid |
| 16 | 121 | Y 8th centroid |
| 17 | 78 | X target centroid |
| 18 | 33 | Y target centroid |
| 19 | 17 | output mask `00010001` |

## Implementation

The solution to this project I've implemented is a Full State Machine. The code is available [here](/project.vhd). For a full description of the architecture and the implementation, you can check the [report](/report.pdf).

Below is the scheme of the machine:
![scheme](/fsm.png)

Let's dig deeper into the different states.

### `idle` State

It's the starting state of the machine. In such state, we're waiting for the `start` signal that will make the computation begin. If, during the execution, the `reset` signal is put to 1 or the `start` signal is put to 0, the machine will return to this state.

### `start` State

It's the state where the computation begins. It's where the variable initialization is done and also where the memory is enabled for the read of the data.

### `takex`, `takey` and `mem` States

The first two are the states where the coordinates of the target point are read drom the memory. `mem` is a dummy state used to give the circuit enough time to memorize the y coordinate before proceeding to the next computation.

### `c..x`, `c..y`, `c...` and `c...d` States

Those are the states where the distances of the different centroids to the target point are actually computed. `c..x` and `c..y` are where the coordinates are read, `c..` is again a dummy state to correctly memorize the y coordinate of the centroid and `c..d` is the state where the distance is computed.

### `comp_min` and `comp` States

In the first state, the minimum distance between the ones computed above is found. In the second one, the output mask is generated.

### `stop` and `done` States

Those are the two final states: they are used to write the result in memory and then to send the `done` signal to finish the computation.

## Test Generator

Since we weren't given many testsets, I've also implemented a generator in C. It's available [here](/test-generator.c), and it generates a txt file that contains inputs and outputs of a new batch. The content of such txt can be copied and pasted into the environment inside a pre-existing test file. I found this way of generating tests quicker than generating full new full test files (like the ones that can be found inside this [directory](/testbench/)) since importing new files to the project would usually be slow and cumbersome.
# [Digital Logic Design](https://www4.ceda.polimi.it/manifesti/manifesti/controller/ManifestoPublic.do?EVN_DETTAGLIO_RIGA_MANIFESTO=EVENTO&c_insegn=085877&aa=2018&k_cf=225&k_corso_la=358&ac_ins=0&k_indir=II3&lang=EN&tipoCorso=ALL_TIPO_CORSO&semestre=1&idItemOfferta=137349&idRiga=229504&codDescr=085877) 2019, Course Project

## Project Description
Conceptually, this project is rather easy: we are given a bidimensional space and the positions of _N_ points (*centroids) inside such space. The goal is to build a hardware component through VHDL able to find the nearest centroids in terms of Manhattan distance to a given point.

The space is a square of size `256*256`. Of the given _N_ centroids, only _K<=N_ are to be considered: this is described in an input mask where every bit is 1 if the centroid is to consider and 0 otherwise.

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

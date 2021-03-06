# Master Mind

## Goal
A simple [MasterMind](https://en.wikipedia.org/wiki/Mastermind) game in Elm

The program draw a solution, you propose some tries, each time the program evaluate your combination.

## Demo
[Demo](https://pointbar.github.io/elm-mastermind/)

## User Stories

### [US1 - View the board](https://github.com/pointbar/elm-mastermind/pull/1)
- [x] draw board
- [x] draw colors
- [x] draw evaluations
- [x] draw tries
- [x] draw solution

### US2 - Draw a solution
- [x] randomize sequence
- [x] display solution

### US3 - Propose combinations
- [x] manage onclick
- [x] display color for first position
- [x] display color by position
- [x] store proposition

### US4 - Evaluate a combination
- [x] evaluate right place colors
- [x] evaluate wrong place colors
- [x] store evaluation

### US5 - View the solution when game is over
- [x] hide solution
- [x] show solution

## To compile
```bash
$ elm-make Mastermind.elm --output build/masterMind-elm.js
```

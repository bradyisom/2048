'use strict'

class GameManager
  constructor: (@GridService, @cookieStore, @rootScope)->
    @grid = @GridService.grid
    @tiles = @GridService.tiles
    @gameSize = @GridService.size
    @winningValue = 2048

  newGame: ->
    @GridService.buildEmptyGameBoard()
    @GridService.buildStartingPosition()
    @reinit()

  reinit: ->
    @gameOver = false
    @win = false
    @currentScore = 0
    @highScore = @getHighScore()

  move: (key)->
    return false if @win
    @GridService.prepareTiles()
    positions = @GridService.traversalDirections(key)
    hasMoved = false
    for x in positions.x
      for y in positions.y
        originalPosition = {x:x,y:y}
        tile = @GridService.getCellAt(originalPosition)
        if tile
          cell = @GridService.calculateNextPosition(tile, key)
          next = cell.next

          if next and next.value == tile.value and not next.merged
            newValue = tile.value*2
            mergedTile = @GridService.newTile(tile, newValue)
            mergedTile.merged = [tile, next]
            @GridService.insertTile(mergedTile)
            @GridService.removeTile(tile)
            @GridService.moveTile(mergedTile, next)
            @updateScore(@currentScore + newValue)
            if mergedTile.value >= @winningValue
              @win = true
            hasMoved = true
          else if not @GridService.samePositions(originalPosition, cell.newPosition)
            @GridService.moveTile(tile, cell.newPosition)
            hasMoved = true
    if hasMoved
      @GridService.randomlyInsertNewTile()

      if @win or not @movesAvailable()
        @gameOver = true
    @rootScope.$digest()

  getHighScore: ->
    parseInt(@cookieStore.get('highScore')) or 0

  updateScore: (newScore)->
    @currentScore = newScore
    if @currentScore > @getHighScore()
      @highScore = newScore
      @cookieStore.put('highScore', newScore)

  movesAvailable: ->
    @GridService.anyCellsAvailable() or @GridService.tileMatchesAvailable()

GameManager.$inject = ['GridService', '$cookieStore', '$rootScope']

angular.module('Game', ['Grid', 'ngCookies'])
.service('GameManager', GameManager)

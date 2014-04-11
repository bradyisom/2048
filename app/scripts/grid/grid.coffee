'use strict'

class TileModel
  constructor: (pos, val)->
    @id = _.uniqueId('tile_')
    @x = pos.x
    @y = pos.y
    @value = val || 2

  updatePosition: (pos)->
    @x = pos.x
    @y = pos.y

  reset: ->
    @merged = null

  toJSON: ->
    "{Tile(#{@id}):#{@x},#{@y},#{@value}"

vectors =
  left: {x:-1,y:0}
  right: {x:1,y:0}
  up: {x:0,y:-1}
  down: {x:0,y:1}

class GridService
  constructor: (@TileModel)->
    @grid = []
    @tiles = []
    @size = 4
    @startingTileNumber = 2

    @buildEmptyGameBoard()
    @buildStartingPosition()


  buildEmptyGameBoard: ->
    nullArr = for x in [1..@size*@size]
      null

    @grid.splice.apply @grid, [0, @grid.length].concat(nullArr)
    @tiles.splice.apply @tiles, [0, @tiles.length].concat(nullArr)

    @forEach (x,y)=>
      @setCellAt({x:x,y:y}, null)

  buildStartingPosition: ->
    for x in [0..@startingTileNumber-1]
      @randomlyInsertNewTile()

  randomlyInsertNewTile: ->
    cell = @randomAvailableCell()
    tile = new @TileModel(cell, @startingTileNumber)
    @insertTile(tile)

  newTile: (pos, value)->
    new @TileModel(pos, value)

  insertTile: (tile)->
    pos = @coordinatesToPosition(tile)
    @tiles[pos] = tile

  removeTile: (tile)->
    pos = @coordinatesToPosition(tile)
    delete @tiles[pos]

  moveTile: (tile, pos)->
    oldPos =
      x: tile.x
      y: tile.y

    @setCellAt(oldPos, null)
    @setCellAt(pos, tile)
    tile.updatePosition(pos)

  prepareTiles: ->
    @forEach (x,y,tile)->
      tile.reset() if tile

  traversalDirections: (key)->
    vector = vectors[key]
    positions =
      x: []
      y: []
    for x in [0..@size-1]
      positions.x.push x
      positions.y.push x

    positions.x.reverse() if vector.x > 0
    positions.y.reverse() if vector.y > 0
    positions

  calculateNextPosition: (cell, key)->
    vector = vectors[key]
    previous = null
    getNext = ->
      previous = cell
      cell =
        x: previous.x + vector.x
        y: previous.y + vector.y
    getNext()
    while @withinGrid(cell) and @cellAvailable(cell)
      getNext()

    newPosition: previous
    next: @getCellAt(cell)

  positionToCoordinates: (i)->
    x = i % @size
    y = (i - x) / @size
    {x:x, y:y}

  coordinatesToPosition: (pos)->
    pos.y * @size + pos.x

  samePositions: (a, b)->
    a.x == b.x and a.y == b.y

  forEach: (cb)->
    for i in [0..@size*@size-1]
      pos = @positionToCoordinates(i)
      cb(pos.x, pos.y, @tiles[i])

  setCellAt: (pos, tile)->
    if @withinGrid(pos)
      xPos = @coordinatesToPosition(pos)
      @tiles[xPos] = tile

  getCellAt: (pos)->
    if @withinGrid(pos)
      x = @coordinatesToPosition(pos)
      @tiles[x]
    else
      null

  withinGrid: (pos)->
    pos.x >= 0 and pos.x < @size and pos.y >= 0 and pos.y < @size

  tileMatchesAvailable: ->
    totalSize = @size * @size
    for i in [0..totalSize-1]
      pos = @positionToCoordinates(i)
      tile = @tiles[i]
      if tile
        for vector in _.values(vectors)
          cell =
            x: pos.x + vector.x
            y: pos.y + vector.y
          other = @getCellAt(cell)
          if other and other.value == tile.value
            return true
    false

  cellAvailable: (pos)->
    if @withinGrid(pos)
      not @getCellAt(pos)
    else
      null

  availableCells: ->
    cells = []
    @forEach (x,y)=>
      foundTile = @getCellAt({x:x,y:y})
      cells.push({x:x,y:y}) if not foundTile
    cells

  anyCellsAvailable: ->
    @availableCells().length > 0

  randomAvailableCell: ->
    cells = @availableCells()
    if cells.length > 0
      cells[Math.floor(Math.random() * cells.length)]
    else
      null

GridService.$inject = ['TileModel']

angular.module('Grid', [])
.factory('TileModel', ->
  TileModel
)
.service('GridService', GridService)

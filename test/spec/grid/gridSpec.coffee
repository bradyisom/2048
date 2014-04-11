'use strict'

describe 'Grid module', ->
  beforeEach module('Grid')

  describe 'GridService', ->
    gridService = null

    beforeEach ->
      module ($provide)->
        false
      inject (GridService)->
        gridService = GridService
        false

    describe 'initialization', ->
      it 'should setup an empty grid', ->
        expect(gridService.grid).toEqual []

      it 'should setup empty tiles', ->
        expect(gridService.tiles).toEqual []

      it 'should setup the grid size', ->
        expect(gridService.size).toBe 4


    describe 'buildEmptyGameBoard', ->
      nullArr = []
      beforeEach ->
        nullArr = for x in [0..15]
          null

      it 'should clear out the grid array with nulls', ->
        gridService.grid = for x in [0..15]
          x
        gridService.buildEmptyGameBoard()
        expect(gridService.grid).toEqual nullArr

      it 'should clear out the tiles array with nulls', ->
        gridService.tiles = for x in [0..15]
          x
        gridService.buildEmptyGameBoard()
        expect(gridService.tiles).toEqual nullArr

  describe 'TileModel', ->
    tileModel = null

    beforeEach ->
      inject (TileModel)->
        tileModel = TileModel
        false

    it 'should create a tile model with the passed parameters', ->
      obj = new tileModel({x:1,y:2}, 8)
      expect(obj.x).toBe 1
      expect(obj.y).toBe 2
      expect(obj.value).toBe 8

    it 'should default to value of 2 if not passed', ->
      obj = new tileModel({x:1,y:2})
      expect(obj.x).toBe 1
      expect(obj.y).toBe 2
      expect(obj.value).toBe 2

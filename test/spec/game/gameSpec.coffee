'use strict'

describe 'Game module', ->
  describe 'GameManager', ->
    beforeEach module('Game')

    gameManager = null

    gridService = null

    beforeEach ->
      gridService =
        anyCellsAvailable: angular.noop
        tileMatchesAvailable: angular.noop
        grid: [1,2]
        tiles: [3,4]
        size: 4

      module ($provide)->
        $provide.value('GridService', gridService)
        false
      inject (GameManager)->
        gameManager = GameManager
        false

    describe 'initialization', ->
      it 'should initialize grid values', ->
        expect(gameManager.grid).toEqual [1,2]
        expect(gameManager.tiles).toEqual [3,4]
        expect(gameManager.gameSize).toBe 4

    describe 'movesAvailable', ->
      it 'should report true if there are cells available', ->
        spyOn(gridService, 'anyCellsAvailable').andReturn(true)
        expect(gameManager.movesAvailable()).toBeTruthy()

      it 'should report true if there are matches available', ->
        spyOn(gridService, 'tileMatchesAvailable').andReturn(true)
        expect(gameManager.movesAvailable()).toBeTruthy()

      it 'should report false if there are no cells or matches available', ->
        spyOn(gridService, 'anyCellsAvailable').andReturn(false)
        spyOn(gridService, 'tileMatchesAvailable').andReturn(false)
        expect(gameManager.movesAvailable()).toBeFalsy()

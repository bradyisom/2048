'use strict'

app = angular
  .module('twentyfortyeightApp', ['ngCookies','Game', 'Grid', 'Keyboard'])

class GameController
  constructor: (GameManager, @KeyboardService)->
    @game = GameManager
    @newGame()

  newGame: ->
    @KeyboardService.init()
    @game.newGame()
    @startGame()

  startGame: ->
    @KeyboardService.on (key)=>
      @game.move(key)

GameController.$inject = ['GameManager', 'KeyboardService']

app.controller('GameController', GameController)

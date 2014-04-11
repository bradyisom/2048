UP = 'up'
RIGHT = 'right'
DOWN = 'down'
LEFT = 'left'

keyboardMap =
  37: LEFT
  38: UP
  39: RIGHT
  40: DOWN

class KeyboardService
  constructor: (@document)->
    @keyEventHandlers = []

  init: ->
    @keyEventHandlers = []
    @document.bind('keydown', (evt)=>
      key = keyboardMap[evt.which]
      if key
        evt.preventDefault()
        @handleKeyEvent(key, evt)
    )

  on: (cb)->
    @keyEventHandlers.push cb

  handleKeyEvent: (key, evt)->
    callbacks = @keyEventHandlers
    return if not callbacks
    evt.preventDefault()
    for cb in callbacks
      cb(key, evt)


KeyboardService.$inject = ['$document']

angular.module('Keyboard', [])
.service('KeyboardService', KeyboardService)

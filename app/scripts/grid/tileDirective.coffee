angular.module('Grid')
.directive('tile', ->
  restrict: 'A'
  scope:
    ngModel: '='
  templateUrl: 'scripts/grid/tile.html'
)

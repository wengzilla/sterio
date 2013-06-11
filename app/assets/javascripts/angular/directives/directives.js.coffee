module = angular.module('directives', [])

module.directive 'stopEvent', () ->
  (scope, element, attr) ->
    element.bind(attr.stopEvent, (e) ->
      e.stopPropagation())

module.directive 'collapseOnClick', () ->
  (scope, element, attr) ->
    element.bind('click', () ->
      $(this).slideUp("slow") )
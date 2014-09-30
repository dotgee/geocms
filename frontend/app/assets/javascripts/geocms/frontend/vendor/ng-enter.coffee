angular.module('ng.enter', [])
# 
# This directive allows us to pass a function in on an enter key to do what we want.
#  
.directive "ngEnter", ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.ngEnter
          return

        event.preventDefault()
      return

    return
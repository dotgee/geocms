# angular.module("geocms.draggable", []).directive "draggable", ($document) ->
#   (scope, element, attr) ->
#     # Prevent default dragging of selected content
#     mousemove = (event) ->
#       console.log "zqd"
#       y = event.screenY - startY
#       x = event.screenX - startX
#       element.css
#         top: y + "px"
#         left: x + "px"

#       return
#     mouseup = ->
#       $document.off "mousemove", mousemove
#       $document.off "mouseup", mouseup
#       return
#     startX = 0
#     startY = 0
#     x = 0
#     y = 0
#     element.css
#       position: "relative"
#       border: "1px solid red"
#       backgroundColor: "lightgrey"
#       cursor: "pointer"

#     element.on "mousedown", (event) ->
#       event.preventDefault()
#       startX = event.screenX - x
#       startY = event.screenY - y
#       $document.on "mousemove", mousemove
#       $document.on "mouseup", mouseup
#       return

#     return

angular.module("geocms.draggable", []).directive "draggable", [
  "$document"
  ($document) ->
    return (
      restrict: "A"
      link: (scope, elm, attrs) ->
        mousemove = ($event) ->
          dx = $event.clientX - initialMouseX
          dy = $event.clientY - initialMouseY
          elm.css
            top: startY + dy + "px"
            left: startX + dx + "px"

          false
        mouseup = ->
          $document.unbind "mousemove", mousemove
          $document.unbind "mouseup", mouseup
          return
        startX = undefined
        startY = undefined
        initialMouseX = undefined
        initialMouseY = undefined
        # elm.css position: "fixed"
        elm.bind "mousedown", ($event) ->
          startX = elm.prop("offsetLeft")
          startY = elm.prop("offsetTop")
          initialMouseX = $event.clientX
          initialMouseY = $event.clientY
          $document.bind "mousemove", mousemove
          $document.bind "mouseup", mouseup
          false

        return
    )
]
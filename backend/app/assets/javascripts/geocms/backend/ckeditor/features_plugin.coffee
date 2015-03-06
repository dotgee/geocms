CKEDITOR.plugins.add 'features', init: (editor) ->
  items = undefined
  layer = $('#layer').data('id')
  if layer
    $.get '/backend/layers/' + layer + '/getfeatures.json', (data) ->
      items = data.layers
      return
    editor.addCommand 'insertFeatures', new (CKEDITOR.dialogCommand)('featuresDialog')
    editor.ui.addButton 'Features',
      label: 'Inserer des features'
      command: 'insertFeatures'
      icon: @path + 'images/icon.png'
    CKEDITOR.dialog.add 'featuresDialog', (editor) ->
      {
        title: 'Liste des features'
        minWidth: 400
        minHeight: 200
        contents: [ {
          id: 'general'
          label: 'Settings'
          elements: [
            {
              type: 'html'
              html: 'Choisissez dans la liste ci-dessous l\'information voulue et validez'
            }
            {
              type: 'select'
              id: 'features'
              label: 'Features'
              items: items
              size: 10
              commit: (data) ->
                data.features = @getValue()
                return

            }
          ]
        } ]
        onOk: ->
          dialog = this
          data = {}
          @commitContent data
          editor.insertHtml '{{' + data.features + '}}'
          return

      }
  return
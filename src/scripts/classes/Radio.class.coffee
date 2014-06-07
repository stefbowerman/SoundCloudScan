class RadioUI

  constructor: (elRadio, elTrackInfo, elStatus) ->
    @isOn = false

    @$radio = $(elRadio)
    @$trackInfo = $(elTrackInfo)
    @$status = $(elStatus)

  powerOnUI: ->
    @$radio.removeClass 'powered-off'

  powerOffUI: ->
    @$radio.addClass 'powered-off'

  startScan: ->
    @$trackInfo.hide()
    @$status.html('Scanning').show()

  finishScan: ->
    @$trackInfo.show()
    @$status.html('').hide()
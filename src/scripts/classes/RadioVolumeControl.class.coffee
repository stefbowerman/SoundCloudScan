class RadioVolumeControl

  constructor: (targetEl) ->
    @$targetEl = $(targetEl)
    @displayTimeout = null
    @displayTimeoutDuration = 2500
    @currentVol = 0.5

  # Increases volume by 0.1
  # Returns volume as a float (0.0 -> 1.0)
  increaseVolume: ->
    do @showVolumeMeter

    # Need to apply some math to ensure we have integers
    newVol = @currentVol + 0.1
    newVol = if newVol > 1 then 1 else newVol

    @currentVol = newVol
    
    @updateVolumeBarWidth( newVol )

    return newVol
  
  # Decreases volume by 0.1
  # Returns volume as a float (0.0 -> 1.0)
  decreaseVolume:  ->
    do @showVolumeMeter

    newVol = @currentVol - 0.1
    newVol = if newVol < 0 then 0 else newVol

    @currentVol = newVol

    @updateVolumeBarWidth( newVol )

    return newVol

  updateVolumeBarWidth: (volume) ->
    $('.radio-volume-bar').width( volume * 100 + "%" )

  showVolumeMeter: -> 
    clearTimeout(@displayTimeout)

    @$targetEl.show()
    
    @displayTimeout = setTimeout( =>
      @$targetEl.hide()
    , @displayTimeoutDuration)
class RadioVolumeControl

  constructor: (targetEl, initialVolume = 0.5) ->
    @$targetEl = $(targetEl)
    @displayTimeout = null
    @displayTimeoutDuration = 2500
    @currentVolume = initialVolume

  _changeVolume: (amount) ->
    return if !amount

    # Need to apply some math to ensure we have integers
    newVol = @currentVolume + amount

    # Apply limits
    newVol = 1 if newVol > 1 
    newVol = 0 if newVol < 0

    # Set new volume
    @currentVolume = newVol

    # Update UI
    @updateVolumeBarWidth()
    @showVolumeMeter()

    return newVol

  # Increases volume by passed in amount (default: 0.1)
  # Returns volume as a float (0.0 -> 1.0)
  increaseVolume: (amount = 0.1) ->
    @_changeVolume(amount)
  
  # Decreases volume by passed in amount (default: 0.1)
  # Returns volume as a float (0.0 -> 1.0)
  decreaseVolume: (amount = 0.1) ->
    @_changeVolume(-amount)

  updateVolumeBarWidth: =>
    $('.radio-volume-bar').width( @currentVolume * 100 + "%" )

  showVolumeMeter: -> 
    clearTimeout(@displayTimeout)

    @$targetEl.show()
    
    @displayTimeout = setTimeout( =>
      @$targetEl.hide()
    , @displayTimeoutDuration)
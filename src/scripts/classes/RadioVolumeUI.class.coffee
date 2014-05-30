class RadioVolumeControl

  constructor: (targetEl, @audioEl) ->
    @$targetEl = $(targetEl)
    @displayTimeout = null
    @displayTimeoutDuration = 2500

  increaseVolume: ->
    do @showVolumeMeter

    # Need to apply some math to ensure we have integers
    newVol = audioElement.volume + 0.1
    audioElement.volume = if newVol > 1 then 1 else newVol
    
    do @updateVolumeBarWidth
  
  decreaseVolume: ->
    do @showVolumeMeter

    newVol = audioElement.volume - 0.1
    audioElement.volume = if newVol < 0 then 0 else newVol

    do @updateVolumeBarWidth

  updateVolumeBarWidth:  ->
    $('.radio-volume-bar').width( @audioEl.volume * 100 + "%" )

  showVolumeMeter: -> # Somethign weird is going on here
    @$targetEl.show()

    clearTimeout(@displayTimeout)
    
    @displayTimeout = setTimeout( =>
      @$targetEl.hide()
    , @displayTimeoutDuration)
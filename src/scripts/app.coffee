audioElement = document.createElement('audio')

window.audioIsSupported = !!(audioElement.canPlayType && audioElement.canPlayType('audio/mpeg;').replace(/no/, ''));

SC_CLIENT_ID = 'a6edb50e62be5fdd8fad80afd621cdd9'

$ ->

  window.scRadioUI      = new RadioUI('.radio', "#track-information", '#radio-status')
  window.scTrackLibrary = new RadioTrackLibrary()
  window.scCurrentTrack = new RadioCurrentTrack()
  window.scRadioClock   = new RadioClock('#radio-clock')
  window.scRadioGenre   = new RadioGenre('#radio-genre')

  window.radioVolumeControl = new RadioVolumeControl('#radio-volume', 0.5)

  scTrackLibrary.loadTracks( {}, loadAndPlayRandomTrack )

  audioElement.volume = window.radioVolumeControl.currentVolume if audioIsSupported

  $audio = $(audioElement)

  loadAndPlayRandomTrack = ->

    do window.scRadioUI.startScan # Set 'scanning' while song loads

    track = scTrackLibrary.getRandomUnplayedTrack()

    do $audio.get(0).pause

    url = "#{track.stream_url}?allow_redirects=False&client_id=#{SC_CLIENT_ID}"

    $audio.attr('src', url)
    .bind 'canplay', ->

      window.scCurrentTrack.setTrack( track ) # Set the track info in the display
      window.scRadioUI.finishScan() # Remove the 'scanning' part
      audioElement.play()

    .bind 'ended error', loadAndPlayRandomTrack

  powerOffRadio = ->

    do audioElement.pause
    do window.scRadioUI.powerOffUI
    $("#track-information").hide()
    do window.scRadioClock.stopTicking
    $('#radio-clock').html('')
    $('.radio-screen-top-bar').hide()
    $('#radio-status').html('Goodbye').show()
    setTimeout(->
      $('#radio-status').hide()
      window.scRadioUI.isOn = false
    , 1500)

  powerOnRadio = ->

    do window.scRadioUI.powerOnUI
    $('.radio-screen-top-bar').show()
    do window.scRadioClock.startTicking
    $('#radio-status').html('Welcome').show()

    setTimeout( ->
      # do window.scRadioGenre.showGenre
      do loadAndPlayRandomTrack
      window.scRadioUI.isOn = true
    , 1000)

  toggleRadioOnOff = ->
    if window.scRadioUI.isOn then powerOffRadio() else powerOnRadio()

  getApiOptionsHash = ->
    hash = 
      filter : 'streamable'
      genres : window.scRadioGenre.getApiGenre()

    return hash

  $("#radio-power").on 'click', toggleRadioOnOff

  $('#new-song').on 'click', loadAndPlayRandomTrack

  $('#volume-up').on 'click', ->
    window.radioVolumeControl.increaseVolume()
    audioElement.volume = window.radioVolumeControl.currentVolume

  $('#volume-down').on 'click', ->
    window.radioVolumeControl.decreaseVolume()
    audioElement.volume = window.radioVolumeControl.currentVolume

  $('[data-genre]').on 'click', ->
    newGenre = $(this).data('genre')

    if window.scRadioGenre.genre is newGenre
      do window.scRadioGenre.showGenre
      return false

    window.scRadioGenre.setGenre newGenre #

    scTrackLibrary.loadTracks( getApiOptionsHash(), ->
      loadAndPlayRandomTrack()
      # window.scRadioGenre.setGenre newGenre
    )

  # Apply effect to rockable buttons depending on click location
  $('.rockable-target').on('mousedown', (e) ->
    $rockableButton = $(@).parents('.control-button.rockable')
    $rockableButton.addClass('rocked-up') if $(@).hasClass('target-top')
    $rockableButton.addClass('rocked-down') if $(@).hasClass('target-bottom')
  )
  .on('mouseup', ->
    $(@).parents('.control-button.rockable').removeClass('rocked-up rocked-down')
  )

  if window.audioIsSupported
    setTimeout ->
      powerOnRadio()
    , 1000
  else
    $('#radio-status').html("Audio is not supported by your browser").show()

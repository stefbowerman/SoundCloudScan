audioElement = document.createElement('audio')

window.audioIsSupported = !!(audioElement.canPlayType && audioElement.canPlayType('audio/mpeg;').replace(/no/, ''));

audioElement.volume = 0 if audioIsSupported

$audio = $(audioElement)

$ ->

  window.scRadio        = new Radio('.radio', '.radio-screen', '#radio-genre')
  window.scTrackLibrary = new RadioTrackLibrary()
  window.scCurrentTrack = new RadioCurrentTrack()
  window.scRadioClock   = new RadioClock('#radio-clock')
  window.scRadioGenre   = new RadioGenre('#radio-genre')

  window.radioVolumeControl = new RadioVolumeControl('#radio-volume')
  
  SC.initialize  
    client_id: 'a6edb50e62be5fdd8fad80afd621cdd9'

  scTrackLibrary.loadTracks( scRadio.getApiOptionsHash(), loadAndPlayRandomTrack )

  loadAndPlayRandomTrack = ->
    track = scTrackLibrary.getRandomUnplayedTrack()

    do $audio.get(0).pause
    do window.scRadio.startScan # Set 'scanning' while song loads

    url = "#{track.stream_url}?allow_redirects=False&client_id=a6edb50e62be5fdd8fad80afd621cdd9"

    $audio.attr('src', url)
    .bind 'canplay', ->

      window.scCurrentTrack.setTrack( track ) # Set the track info in the display
      window.scRadio.finishScan(track) # Remove the 'scanning' part
      audioElement.play()

    .bind 'ended error', loadAndPlayRandomTrack  

  powerOffRadio = ->

    do audioElement.pause
    do window.scRadio.powerOffUI
    $("#track-information").hide()
    do window.scRadioClock.stopTicking
    $('#radio-clock').html('')
    $('.radio-screen-top-bar').hide()
    $('#radio-status').html('Goodbye').show()
    setTimeout(->
      $('#radio-status').hide()
      window.scRadio.isOn = false
    , 1500)

  powerOnRadio = ->

    do window.scRadio.powerOnUI
    $('.radio-screen-top-bar').show()
    do window.scRadioClock.startTicking
    $('#radio-status').html('Welcome').show()

    setTimeout( ->
      do loadAndPlayRandomTrack
      window.scRadio.isOn = true      
    , 1000)

  toggleRadioOnOff = ->
    if window.scRadio.isOn then powerOffRadio() else powerOnRadio()

  $("#radio-power").on 'click', toggleRadioOnOff

  $('#new-song').on 'click', loadAndPlayRandomTrack

  $('#volume-up').on 'click', -> 
    window.audioElement.volume = window.radioVolumeControl.increaseVolume()

  $('#volume-down').on 'click', -> 
    window.audioElement.volume = window.radioVolumeControl.decreaseVolume()

  $('[data-genre]').on 'click', -> 
    # TODO - Deal with this messy genre issue
    genre = $(this).data('genre')

    return false if window.scRadioGenre.genre is genre

    window.scRadioGenre.setGenre $(this).data('genre')
             
    window.scRadio.setGenre $(this).data('genre')

    scTrackLibrary.loadTracks( scRadio.getApiOptionsHash(), loadAndPlayRandomTrack )

  # Apply effect to rockable buttons depending on click location
  $('.rockable-target').on('mousedown', (e) ->
    $rockableButton = $(@).parents('.control-button.rockable')
    $rockableButton.addClass('rocked-up') if $(@).hasClass('target-top')
    $rockableButton.addClass('rocked-down') if $(@).hasClass('target-bottom')
  )
  .on('mouseup', ->
    $(@).parents('.control-button.rockable').removeClass('rocked-up rocked-down')
  )

  if window. audioIsSupported
    setTimeout ->
      powerOnRadio()
    , 1000
  else
    $('#radio-status').html("Audio is not supported by your browser").show()


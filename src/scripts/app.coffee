window.SCS =
  tracks : null

window.SCApp = 
  _client_id : 'a6edb50e62be5fdd8fad80afd621cdd9'

# Do check if audio is supported
audioElement = document.createElement('audio')
audioElement.volume = 0.5

$ ->

  window.scRadio   = new Radio()
  window.scRadioUI = new RadioUI('.radio', '.radio-screen', '#track-title', '#track-artist', '#track-url')
  window.scTrackLibrary = new TrackLibrary()
  window.scRadioClock = new RadioClock('#radio-clock')

  window.radioVolumeControl = new RadioVolumeControl('#radio-volume', audioElement)

  # window.radioClock.startTicking()
  
  SC.initialize  
    client_id: 'a6edb50e62be5fdd8fad80afd621cdd9'

  scTrackLibrary.loadTracks( scRadio.getApiOptionsHash(), loadAndPlayRandomTrack )

  loadAndPlayRandomTrack = ->
    track = scTrackLibrary.getRandomUnplayedTrack()
    # duration = track.duration

    scRadio.playTrack(track)

    do audioElement.pause
    do window.scRadioUI.scan # Set 'scanning' while song loads

    url = "#{track.stream_url}?allow_redirects=False&client_id=a6edb50e62be5fdd8fad80afd621cdd9"

    audioElement.setAttribute('src', url)

    # audioElement.addEventListener 'durationchange', (e) ->
    #   console.log 'duration changed to ' + audioElement.duration
    
    audioElement.addEventListener "canplay", ->
      # This seeking destroys the audio element :-/
      # audioElement.currentTime = Math.floor( (track.duration * 0.001) * 0.03 ) # ms -> sec, then seek to 3% into the track
      
      audioElement.play()
      window.scRadioUI.finishScan(track) # Remove the 'scanning' and set the track info in the display
    , true

    audioElement.addEventListener "ended", loadAndPlayRandomTrack

    # setTimeout -> 
    #   audioElement.pause()
    # , 1000

  # loadSounds = ->
  #   SC.get '/tracks',
  #     # window.scRadio.getApiOptionsHash()
  #     # genres: 'electronic',
  #     filter: 'streamable',
  #     # bpm:
  #     #   from: 120
  #     # ,
  #     (tracks) ->

  #       window.SCS.tracks = tracks;
  #       do playRandomSound

  # getRandomTrack = ->

  #   track = window.SCS.tracks[ Math.floor((Math.random() * 50) + 1) ]

  #   if $.inArray(track.id, playedTrackIDs) is -1 # Not in array
  #     playedTrackIDs.push track.id
  #     return track
  #   else 
  #     do getRandomTrack

  # playRandomSound = ->
  #   track = getRandomTrack()

  #   do window.scRadioUI.scan
    
  #   url = "#{track.stream_url}?allow_redirects=False&client_id=a6edb50e62be5fdd8fad80afd621cdd9"

  #   audioElement = document.createElement('audio')

  #   audioElement.setAttribute('src', url)

  #   audioElement.addEventListener "canplay", ->
  #     audioElement.play()
  #     window.scRadioUI.finishScan(track)
  #   , true

    # setTimeout -> 
    #   audioElement.pause()
    # , 1000

  #   playedTrackIDs.push track.id

  $('#new-song').on('click', loadAndPlayRandomTrack)

  $('#volume-up').on 'click', -> window.radioVolumeControl.increaseVolume()

  $('#volume-down').on 'click', -> window.radioVolumeControl.decreaseVolume()

  $('.rockable-target').on('mousedown', (e) ->
    $rockableButton = $(@).parents('.control-button.rockable')
    $rockableButton.addClass('rocked-up') if $(@).hasClass('target-top')
    $rockableButton.addClass('rocked-down') if $(@).hasClass('target-bottom')
  )
  .on('mouseup', ->
    $(@).parents('.control-button.rockable').removeClass('rocked-up rocked-down')
  )

  setTimeout ->
    do window.scRadioUI.powerOn
    do window.scRadioClock.startTicking
    do loadAndPlayRandomTrack
  , 1200
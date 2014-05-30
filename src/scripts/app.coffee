window.SCS =
  tracks : null

window.SCApp = 
  _client_id : 'a6edb50e62be5fdd8fad80afd621cdd9'

audioElement = null

$ ->

  window.scRadio   = new Radio()
  window.scRadioUI = new RadioUI('.radio', '.radio-screen', '#track-title', '#track-artist', '#track-url')

  playedTrackIDs = []
  
  SC.initialize  
    client_id: 'a6edb50e62be5fdd8fad80afd621cdd9'

  loadSounds = ->
    SC.get '/tracks',
      # window.scRadio.getApiOptionsHash()
      # genres: 'electronic',
      filter: 'streamable',
      # bpm:
      #   from: 120
      # ,
      (tracks) ->

        window.SCS.tracks = tracks;
        do playRandomSound

  getRandomTrack = ->

    track = window.SCS.tracks[ Math.floor((Math.random() * 50) + 1) ]

    if $.inArray(track.id, playedTrackIDs) is -1 # Not in array
      playedTrackIDs.push track.id
      return track
    else 
      do getRandomTrack

  playRandomSound = ->
    track = getRandomTrack()

    do window.scRadioUI.scan
    
    url = "#{track.stream_url}?allow_redirects=False&client_id=a6edb50e62be5fdd8fad80afd621cdd9"

    audioElement = document.createElement('audio')

    audioElement.setAttribute('src', url)

    audioElement.addEventListener "canplay", ->
      audioElement.play()
      window.scRadioUI.finishScan(track)
    , true

    setTimeout -> 
      audioElement.pause()
    , 1000

    playedTrackIDs.push track.id

  $('#new-song').on('click', playRandomSound)

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
    do loadSounds
  , 1200
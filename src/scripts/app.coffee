window.SCS =
  tracks : null

$ ->
  
  SC.initialize  
    client_id: 'a6edb50e62be5fdd8fad80afd621cdd9'

  loadSounds = ->
    SC.get '/tracks',
      genres: 'electronic',
      filter: 'streamable',
      bpm:
        from: 120
      ,
      (tracks) ->

        window.SCS.tracks = tracks;
        do playRandomSound

  playRandomSound = ->
    track = window.SCS.tracks[ Math.floor((Math.random() * 50) + 1) ]

    $('.radio-screen').find('p').hide()
    $('#radio-status').html('Scanning...').show()
    
    $('#track-url').html(track.stream_url)

    url = track.stream_url + "?allow_redirects=False&client_id=a6edb50e62be5fdd8fad80afd621cdd9";

    audioElement = document.createElement('audio')

    audioElement.setAttribute('src', url)

    audioElement.addEventListener "canplay", ->
      audioElement.play()
      # console.log(track);
      $('#track-title').html(track.title)
      $('#track-artist').html(track.user.username)
      $('.radio-screen').find('p').show()
      $('#radio-status').html('').hide()
    , true

    setTimeout -> 
      audioElement.pause()
    , 2000

    # // SC.stream(track.stream_url, function(sound){
    # //   // sound.play();
    # // });

  $('#new-song').on('click', playRandomSound)

  do loadSounds
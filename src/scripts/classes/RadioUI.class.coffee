class RadioUI
  
  constructor: (elRadio, elScreen, elSongTitle, elSongArtist, elSongUrl) ->
    @$radio       = $(elRadio)
    @$radioScreen = $(elScreen)
    @$songTitle  = $(elSongTitle)
    @$songArtist = $(elSongArtist)
    @$songUrl    = $(elSongUrl)

  powerOn: ->
    @$radio.removeClass 'powered-off'

  powerOff: ->
    @$radio.addClass 'powered-off'

  setSongTitle: (title) ->
    @$songTitle.html title

  setSongArtist: (artist) ->
    @$songArtist.html artist

  setSongUrl: (url) ->
    @$songUrl.html url

  setNewSongProperties: (title, artist, url) ->
    @setSongTitle title
    @setSongArtist artist
    @setSongUrl url

  scan: ->
    $('.radio-screen').find('p').hide()
    $('#radio-status').html('Scanning...').show()

  finishScan: (song) ->
    @setNewSongProperties(song.title, song.user.username, song.permalink_url)
    @$radioScreen.find('p').show()
    $('#radio-status').html('').hide()
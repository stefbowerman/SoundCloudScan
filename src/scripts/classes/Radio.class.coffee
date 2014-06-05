class Radio

  constructor: (elRadio, elScreen, elRadioGenre) ->
    @isOn = false
    @genre =   null

    @$radio       = $(elRadio)
    @$radioScreen = $(elScreen)

    @$radioGenre  = $(elRadioGenre)

  getApiOptionsHash: ->
    hash = {}
    hash.filter = 'streamable'
    hash.genres = @genre if @genre? && @genre.length

    return hash

  setGenre: (genre = null) ->
    @genre = if genre is 'all' then null else genre

  powerOnUI: ->
    @$radio.removeClass 'powered-off'

  powerOffUI: ->
    @$radio.addClass 'powered-off'

  startScan: ->
    $("#track-information").hide()
    $('#radio-status').html('Scanning').show()

  finishScan: (song) ->
    $("#track-information").show()
    $('#radio-status').html('').hide()
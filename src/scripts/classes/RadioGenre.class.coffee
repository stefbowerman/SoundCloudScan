class RadioGenre

  # Available genres
  # 'all', 'rap', 'dance', 'jazz', 'rock'

  constructor: (targetEl, @genre = null) ->
    @$targetEl = $(targetEl)
    @displayTimeout = null
    @displayTimeoutDuration = 2500

  # Accepts genre as a string
  # Returns genre after it has been set
  setGenre: (genre) ->
    @genre = genre

    @$targetEl.html "Listening to #{genre}"

    do @showGenre

    return @genre

  showGenre: -> 
    clearTimeout(@displayTimeout)

    @$targetEl.show()
    
    @displayTimeout = setTimeout( =>
      @$targetEl.hide()
    , @displayTimeoutDuration)

  hideGenre: ->
    @$targetEl.hide()
class RadioCurrentTrack

  constructor: () ->
    @track = null
    @titleOverflowInterval = null

    @overflowIntervalDuration = 3500

  # Accepts a track as defined by the SoundCloud APi
  setTrack: (track) ->
    @track = track

    clearInterval @titleOverflowInterval

    # Update DOM with track info
    $('#track-title').html track.title

    fullWidth = $('#track-title')[0].scrollWidth
    visibleWidth = $('#track-title').width()

    if fullWidth > visibleWidth
      overflowWidth = fullWidth - visibleWidth
      
      $overflow = $('#track-title').wrapInner("<div></div>").children().addClass('text-overflowing')

      shifted = false

      shiftOverflowText = ->
        if shifted
          $overflow.css
            'margin-left' : 0
          shifted = false
        else
          $overflow.css
            'margin-left' : "-#{overflowWidth}px"
          shifted = true

      @titleOverflowInterval = setInterval shiftOverflowText, @overflowIntervalDuration

    $('#track-artist').html "BY: #{track.user.username}"

    $('#track-url').html "<a href=\"#{track.permalink_url}\" target=\"_blank\">Listen on SoundCloud <span class=\"track-url-arrow\">&#10095;</span></a>"


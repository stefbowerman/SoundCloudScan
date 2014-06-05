class RadioCurrentTrack

  constructor: () ->
    @track = null

  # Accepts a track as defined by the SoundCloud APi
  setTrack: (track) ->
    @track = track

    # Update DOM with track info
    $('#track-title').html track.title
    $('#track-title').wrapInner("<marquee></marquee>") if $('#track-title')[0].scrollWidth > $('#track-title').width()

    $('#track-artist').html "BY: #{track.user.username}"

    $('#track-url').html "<a href=\"#{track.permalink_url}\" target=\"_blank\">Listen on SoundCloud <span class=\"track-url-arrow\">&#10095;</span></a>"
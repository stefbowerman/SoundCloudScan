 do (window, SC) ->

  class window.RadioTrackLibrary
    
    constructor: () ->
      @_playedTrackIds = []
      @loadedTracks = []

    loadTracks: (apiOptions = {}, callback = false) ->
      
      opts = $.extend({}, {filter: 'streamable'}, apiOptions)
      
      SC.get '/tracks', opts,
        (tracks) =>
          @loadedTracks = tracks
          do callback if callback
          console.log('done loading tracks!')

    getRandomTrack: ->
      @loadedTracks[ Math.floor((Math.random() * @loadedTracks.length) + 1) ]

    getRandomUnplayedTrack: ->
      track = @getRandomTrack()

      if $.inArray(track.id, @_playedTrackIDs) is -1 # Not in array
        @_playedTrackIds.push track.id
        return track
      else 
        do @getRandomTrack
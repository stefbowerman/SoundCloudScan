 do (window, SC) ->

  class window.RadioTrackLibrary
    
    constructor: (@_scClientId) ->
      @_playedTrackIds = []
      @loadedTracks = []
      @unplayedTracks = []
      @playedTracks = []
      @currentApiOpts = {}

      SC.initialize
        client_id: 'a6edb50e62be5fdd8fad80afd621cdd9'

    loadTracks: (apiOptions = {}, callback = false) ->
      
      @currentApiOpts = $.extend({}, {filter: 'streamable'}, apiOptions) # Cache the current options
      
      SC.get '/tracks', @currentApiOpts,
        (tracks) =>
          @unplayedTracks = tracks
          do callback if callback
          console.log('done loading tracks!')

    getRandomUnplayedTrack: ->

      randomIndex =  Math.floor((Math.random() * @unplayedTracks.length) + 1) # Random number inside the length of the array

      track =  @unplayedTracks[ randomIndex ] # Retrieve the track at that index

      @unplayedTracks.splice(randomIndex, 1) # Remove that track from the unplayedTrack array

      @playedTracks.push track # Add that track to the array of playedTracks

      # console.log "unplayed track length #{@unplayedTracks.length}"
      # console.log "played track length #{@playedTracks.length}"

      do @loadTracks if @unplayedTracks.length < 3 # grab some more tracks if we get close to running out

      return track
      


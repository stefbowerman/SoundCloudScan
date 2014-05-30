class Radio

  constructor: ->
    @genre =   null
    @bpmFrom = null 
    @bpmTo =   null

  getApiOptionsHash: ->
    hash = {}
    hash.filter = 'streamable'
    hash.genres = @genre if @genre?
    if @bpmFrom || @bpmTo
      hash.bpm = {}
      hash.bpm.from = @bpmFrom if @bpmFrom?
      hash.bpm.to   = @bpmTo if @bpmTo?

    return hash
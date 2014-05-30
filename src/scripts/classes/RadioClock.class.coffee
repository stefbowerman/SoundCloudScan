class RadioClock
  
  constructor: (targetEl) ->
    @$targetEl = $(targetEl)
    @tickingInterval = null

  startTicking: ->
    @tick()
    @tickingInterval = setInterval( => 
      @tick()
    , 1000)

  stopTicking: ->
    clearInterval(@tickingInterval)

  tick: ->
    d = new Date()
    hours = d.getHours()
    mins  = d.getMinutes()
    timeSuffix = 'A.M.'

    if hours > 12
      hours = hours - 12
      timeSuffix = 'P.M.'

    @$targetEl.html "#{hours}:#{mins} #{timeSuffix}"
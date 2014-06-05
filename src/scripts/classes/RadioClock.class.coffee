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
    mins = "0#{mins}" if mins < 10
    timeSuffix = 'AM'

    if hours > 12
      hours = hours - 12
      timeSuffix = 'PM'

    @$targetEl.html "#{hours}:#{mins} #{timeSuffix}"
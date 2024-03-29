$ ->
  $('.datepicker[data-desktop=true]').datetimepicker({
    format: 'DD.MM.YYYY'
    showClear: true,
    showTodayButton: true
  })

  $('.metadata-popover').popover({
    html: true,
    trigger: 'hover click',
    viewport: '.container',
    placement: 'bottom',
    content: ->
      return $('.metadata-content').html()
  })

  $('[data-toggle="tooltip"]').tooltip()

  formatDates = (dates) ->
    dates.each ->
      rawDate = $(this).attr('datetime')
      formattedDate = moment(rawDate).format("ll")
      $(this).text(formattedDate)

  formatTimestamps = (timestamps) ->
    timestamps.each ->
      rawDateTime = $(this).attr('datetime')
      formattedDateTime = moment(rawDateTime).format("llll")
      $(this).text(formattedDateTime)

  formatDates($('time.moment-date'))
  formatTimestamps($('time.moment-datetime'))

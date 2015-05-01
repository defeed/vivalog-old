$ ->
  $('.datepicker').datetimepicker({
    format: 'DD.MM.YYYY'
    showClear: true,
    showTodayButton: true
  })

  formatDates = (dates) ->
    dates.each ->
      rawDate = $(this).attr('datetime')
      formattedDate = moment(rawDate).format("dd, LL")
      $(this).text(formattedDate)

  formatTimestamps = (timestamps) ->
    timestamps.each ->
      rawDateTime = $(this).attr('datetime')
      formattedDateTime = moment(rawDateTime).format("llll")
      $(this).text(formattedDateTime)

  formatDates($('time.moment-date'))
  formatTimestamps($('time.moment-datetime'))

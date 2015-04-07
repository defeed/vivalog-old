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

  formatDates($('time.moment'))

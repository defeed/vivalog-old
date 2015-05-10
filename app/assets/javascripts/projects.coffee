$ ->
  toggleBillingTypes = (show) ->
    if show
      $('#project-billing-types').show()
    else
      $('#project-billing-types').hide()

  toggleSumPolish = (show) ->
    if show
      $('.project_sum_polish').show()
    else
      $('.project_sum_polish').hide()

  toggleSumReceive = (show) ->
    if show
      $('.project_sum_receive').show()
    else
      $('.project_sum_receive').hide()

  toggleHourlyRate = (show) ->
    if show
      $('.project_hourly_rate').show()
    else
      $('.project_hourly_rate').hide()

  toggleDailyRate = (show) ->
    if show
      $('.project_daily_rate').show()
    else
      $('.project_daily_rate').hide()

  toggleProjectRate = (show) ->
    if show
      $('.project_project_rate').show()
    else
      $('.project_project_rate').hide()

  toggleRequired = (element, required) ->
    element.prop('required', required)

  show_billing_types = $('#project_work_types_other').is(':checked')
  show_sum_receive = $('#project_work_types_receive').is(':checked')
  show_sum_polish = $('#project_work_types_polish').is(':checked')
  show_hourly_rate = $('#project_billing_types_hourly_rate').is(':checked')
  show_daily_rate = $('#project_billing_types_daily_rate').is(':checked')
  show_project_rate = $('#project_billing_types_project_rate').is(':checked')
  toggleSumReceive(show_sum_receive)
  toggleSumPolish(show_sum_polish)
  toggleBillingTypes(show_billing_types)
  toggleHourlyRate(show_hourly_rate)
  toggleDailyRate(show_daily_rate)
  toggleProjectRate(show_project_rate)

  $('#project-work-types').change ->
    show_billing_types = $('#project_work_types_other').is(':checked')
    show_sum_receive = $('#project_work_types_receive').is(':checked')
    show_sum_polish = $('#project_work_types_polish').is(':checked')
    toggleSumReceive(show_sum_receive)
    toggleSumPolish(show_sum_polish)
    toggleBillingTypes(show_billing_types)
    toggleRequired($('#project_sum_receive'), show_sum_receive)
    toggleRequired($('#project_sum_polish'), show_sum_polish)

  $('#project-billing-types').change ->
    show_hourly_rate = $('#project_billing_types_hourly_rate').is(':checked')
    show_daily_rate = $('#project_billing_types_daily_rate').is(':checked')
    show_project_rate = $('#project_billing_types_project_rate').is(':checked')
    toggleHourlyRate(show_hourly_rate)
    toggleDailyRate(show_daily_rate)
    toggleProjectRate(show_project_rate)

  $.each [$(".new_project"), $('.edit_project')], ->
    this.validate({rules: {'project[work_types][]': {required: true}, 'project[billing_types][]': {required: true}}})

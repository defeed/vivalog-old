$ ->
  toggleFinalDate = (show) ->
    if show
      $('#final-date').show()
    else
      $('#final-date').hide()

  toggleBillingTypes = (show) ->
    if show
      $('#billing-types').show()
    else
      $('#billing-types').hide()

  toggleWorkersCoefficient = (show) ->
    if show
      $('#workers').show()
      $('#coefficient').show()
    else
      $('#workers').hide()
      $('#coefficient').hide()

  toggleHourlyRate = (show) ->
    if show
      $('#hours').show()
      $('#hourly-rate').show()
    else
      $('#hours').hide()
      $('#hourly-rate').hide()

  toggleDailyRate = (show) ->
    if show
      $('#daily-rate').show()
    else
      $('#daily-rate').hide()

  toggleProjectRate = (show) ->
    if show
      $('#project-rate').show()
    else
      $('#project-rate').hide()

  show_workers_coeff = $('#entry_work_type_receive').is(':checked') || $('#entry_work_type_polish').is(':checked')
  toggleWorkersCoefficient(show_workers_coeff)

  show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
  toggleHourlyRate(show_hourly_rate)

  show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
  toggleDailyRate(show_daily_rate)

  show_final_date = $('#entry_multiple_days').is(':checked')
  toggleFinalDate(show_final_date)

  $('#entry_multiple_days').change ->
    show_final_date = $(this).is(':checked')
    toggleFinalDate(show_final_date)

  show_billing_types = $('#entry_work_type_other').is(':checked')
  toggleBillingTypes(show_billing_types)

  $('#work-types').change ->
    show_billing_types = $('#entry_work_type_other').is(':checked')
    show_workers_coeff = $('#entry_work_type_receive').is(':checked') || $('#entry_work_type_polish').is(':checked')
    show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
    show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
    show_project_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_project_rate').is(':checked')
    toggleBillingTypes(show_billing_types)
    toggleWorkersCoefficient(show_workers_coeff)
    toggleHourlyRate(show_hourly_rate)
    toggleDailyRate(show_daily_rate)
    toggleProjectRate(show_project_rate)

  $('#billing-types').change ->
    show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
    show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
    show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
    show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
    show_project_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_project_rate').is(':checked')
    toggleHourlyRate(show_hourly_rate)
    toggleDailyRate(show_daily_rate)
    toggleProjectRate(show_project_rate)

  projects_select = $('#entry_project_id')

  loadProjects = (date) ->
    $.ajax '/projects/find_by_start_date',
      data: { date: date }
      success: (data, status, xhr) ->
        populateProjectsSelect(data)
      error: (xhr, status, err) ->
        alert 'Failed to load projects. Refresh page and try again.'

  $('#new_entry').on 'change', '#entry_user_id', (event) ->
    user_id = $(this).val()
    $.ajax '/users/' + user_id + '/hourly_rate',
      success: (data, status, xhr) ->
        $('#entry_hourly_rate').val(data)
      error: (xhr, status, err) ->
        $('#entry_hourly_rate').val('')

  $('#new_entry').on 'dp.change', "#entry_worked_on", (event) ->
    clearProjectsSelect()
    loadProjects($(this).val())

  clearProjectsSelect = ->
    projects_select.find('option:not([value=""])').remove()
  populateProjectsSelect = (projects) ->
    $.each projects, () ->
      title = '[' + this.code + '] ' + this.title
      projects_select.append($("<option />").val(this.id).text(title))

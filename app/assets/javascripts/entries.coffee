$ ->
  toggleFinalDate = (show) ->
    if show
      $('#final-date').show()
    else
      $('#final-date').hide().find('input').val('')

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

  toggleCheckMultipleDays = (checked) ->
    $('#entry_multiple_days').prop('checked', checked)

  toggleRequired = (element, required) ->
    element.prop('required', required)

  show_workers_coeff = $('#entry_work_type_receive').is(':checked') || $('#entry_work_type_polish').is(':checked')
  toggleWorkersCoefficient(show_workers_coeff)

  show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
  toggleHourlyRate(show_hourly_rate)

  show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
  toggleDailyRate(show_daily_rate)

  show_final_date = $('#entry_multiple_days').is(':checked') || $('#entry_billing_type_project_rate').is(':checked')
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
    toggleRequired($('#entry_workers'), show_workers_coeff)
    toggleRequired($('#entry_coefficient'), show_workers_coeff)

  $('#billing-types').change ->
    show_hourly_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_hourly_rate').is(':checked')
    show_daily_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_daily_rate').is(':checked')
    show_project_rate = $('#entry_work_type_other').is(':checked') && $('#entry_billing_type_project_rate').is(':checked')
    show_final_date = $('#entry_billing_type_project_rate').is(':checked') || ($('#entry_multiple_days').is(':checked') && $('#entry_final_date').val() != '')
    toggleHourlyRate(show_hourly_rate)
    toggleDailyRate(show_daily_rate)
    toggleProjectRate(show_project_rate)
    toggleFinalDate(show_final_date)
    toggleCheckMultipleDays(show_final_date)
    toggleRequired($('#entry_hourly_rate'), show_hourly_rate)
    toggleRequired($('#entry_hours'), show_hourly_rate)
    toggleRequired($('#entry_daily_rate'), show_daily_rate)
    toggleRequired($('#entry_project_rate'), show_project_rate)
    toggleRequired($('#entry_final_date'), show_project_rate)

  projects_select = $('#entry_project_id')

  loadProjectData = (project_id) ->
    return if project_id == ''
    $.ajax '/projects/' + project_id,
    dataType: 'json',
    success: (data, status, xhr) ->
      updateForm(data.project)
    error: (xhr, status, err) ->
      console.log err

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

  $('#new_entry').on 'change', "#entry_worked_on", (event) ->
    clearProjectsSelect()
    loadProjects($(this).val())

  $('#new_entry').on 'change', '#entry_project_id', (event) ->
    clearProjectFields()
    loadProjectData($(this).val())

  updateValue = (element, value) ->
    element.val(value)

  clearProjectFields = ->
    updateValue($('#entry_hourly_rate'), '')
    updateValue($('#entry_daily_rate'), '')
    updateValue($('#entry_project_rate'), '')
    $('#workers').hide()
    $('#coefficient').hide()
    $('#hourly-rate').hide()
    $('#hours').hide()
    $('#daily-rate').hide()
    $('#project-rate').hide()
    $('#help-start-on').hide().find('.date').text('')
    $('#help-end-on').hide().find('.date').text('')

  updateForm = (project) ->
    updateWorkTypes(project.work_types)
    updateBillingTypes(project.billing_types)
    updateValue($('#entry_hourly_rate'), project.hourly_rate)
    updateValue($('#entry_daily_rate'), project.daily_rate)
    updateValue($('#entry_project_rate'), project.project_rate)
    updateHelpBlocks(project.start_on, project.end_on)

  updateWorkTypes = (types) ->
    $('#work-types fieldset').html('')
    $.each types, () ->
      div = $('<div>').addClass('radio')
      label = $('<label>').text(this.value)
      input_attrs =
        id: 'entry_work_type_' + this.key
        value: this.key
        type: 'radio'
        name: 'entry[work_type]'
      input = $('<input>').attr(input_attrs)

      input.prependTo(label)
      label.appendTo(div)
      $('#work-types fieldset').append(div)

  updateBillingTypes = (types) ->
    $('#billing-types fieldset').html('')
    $.each types, () ->
      div = $('<div>').addClass('radio')
      label = $('<label>').text(this.value)
      input_attrs =
        id: 'entry_billing_type_' + this.key
        value: this.key
        type: 'radio'
        name: 'entry[billing_type]'
      input = $('<input>').attr(input_attrs)

      input.prependTo(label)
      label.appendTo(div)
      $('#billing-types fieldset').append(div)

  updateHelpBlocks = (start_on, end_on) ->
    if start_on != null
      $('#start-on-help').show().find('.date').text(start_on)
    if end_on != null
      $('#end-on-help').show().find('.date').text(end_on)

  clearProjectsSelect = ->
    projects_select.find('option:not([value=""])').remove()

  populateProjectsSelect = (projects) ->
    $.each projects, () ->
      title = '[' + this.code + '] ' + this.title
      projects_select.append($("<option />").val(this.id).text(title))

  $("#new_entry").validate({rules: {'entry[work_type]': {required: true}, 'entry[billing_type]': {required: true}}})

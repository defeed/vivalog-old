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

  show_final_date = $('#entry_multiple_days').is(':checked')
  toggleFinalDate(show_final_date)

  $('#entry_multiple_days').change ->
    show_final_date = $(this).is(':checked')
    toggleFinalDate(show_final_date)

  show_billing_types = $('#entry_work_type_other').is(':checked')
  toggleBillingTypes(show_billing_types)

  $('#work-types').change ->
    show_billing_types = $('#entry_work_type_other').is(':checked')
    toggleBillingTypes(show_billing_types)

  projects_select = $('#entry_project_id')

  setFieldsVisibility = (work_type) ->
    if work_type == ''
      $('#workers').hide()
      $('#coefficient').hide()
      $('#hours').hide()
      $('#hourly-rate').hide()
    else if work_type == 'other'
      $('#workers').hide()
      $('#coefficient').hide()
      $('#hours').show()
      $('#hourly-rate').show()
    else
      $('#workers').show()
      $('#coefficient').show()
      $('#hours').hide()
      $('#hourly-rate').hide()

  loadProjects = (date) ->
    $.ajax '/projects/find_by_start_date',
      data: { date: date }
      success: (data, status, xhr) ->
        populateProjectsSelect(data)
      error: (xhr, status, err) ->
        alert 'Failed to load projects. Refresh page and try again.'

  setFieldsVisibility($('#entry_work_type').val())

  $('#new_entry').on 'change', '#entry_work_type', (event) ->
    setFieldsVisibility($(this).val())

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

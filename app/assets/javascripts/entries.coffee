$ ->
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


  setFieldsVisibility($('#entry_work_type').val())

  $('#new_entry').on 'change', '#entry_work_type', (event) ->
    setFieldsVisibility($(this).val())

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

  $('#new_entry').on 'change', '#entry_user_id', (event) ->
    user_id = $(this).val()
    $.ajax '/users/' + user_id + '/hourly_rate',
      success: (res, status, xhr) ->
        $('#entry_hourly_rate').val(res)
      error: (xhr, status, err) ->
        $('#entry_hourly_rate').val('')

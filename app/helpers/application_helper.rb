module ApplicationHelper
  BOOTSTRAP_FLASH_MSGS = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSGS.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def roles_for_select
    hash = {}
    User::ROLES.each do |role|
      hash[I18n.t("roles.#{role}")] = role
    end

    hash
  end

  def work_types_for_select
    hash = {}
    Entry::WORK_TYPES.each do |type|
      hash[I18n.t("work_types.#{type}")] = type
    end

    hash
  end

  def status_label(is_active)
    if is_active
      string = I18n.t('statuses.active')
      content = fa_icon('check-circle-o', text: string)
      label_class = 'success'
    else
      string = I18n.t('statuses.inactive')
      content = fa_icon('ban', text: string)
      label_class = 'default'
    end

    content_tag(
      :span,
      content,
      class: "label label-#{label_class}"
    )
  end

  def role_label(role)
    content_tag(
      :span,
      I18n.t("roles.#{role}"),
      class: 'label label-primary'
    )
  end

  def activate_button_text(is_active)
    if is_active
      fa_icon 'lock', text: I18n.t('statuses.deactivate')
    else
      fa_icon 'unlock', text: I18n.t('statuses.activate')
    end
  end

  def activate_button(user)
    btn_class = user.is_active ? 'danger' : 'success'
    link_to(
      activate_button_text(user.is_active?),
      toggle_active_user_path(user),
      class: "btn btn-#{btn_class}",
      method: :patch
    )
  end

  def project_finalized_label(finalized)
    if finalized
      string = I18n.t(:project_finalized)
      content = fa_icon('check-square-o', text: string)
      label_class = 'success'
    else
      string = I18n.t(:project_not_finalized)
      content = fa_icon('square-o', text: string)
      label_class = 'default'
    end

    content_tag(
      :span,
      content,
      class: "label label-#{label_class}"
    )
  end

  def eur(number)
    return '-' unless number
    number_to_currency(
      number,
      unit: '€',
      format: '%n %u',
      delimiter: ' ',
      separator: ','
    )
  end

  def volume(number)
    return '-' unless number
    number_to_human(
      number,
      units: {  unit: 'm³' },
      precision: 5,
      delimiter: ' ',
      separator: ','
    )
  end
end

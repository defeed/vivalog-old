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

  def billing_types_for_select
    hash = {}
    Entry::BILLING_TYPES.each do |type|
      hash[I18n.t("billing_types.#{type}")] = type
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

  def project_code_label(code)
    return if code.blank?
    content_tag(
      :span,
      code,
      class: 'label label-primary project-code',
    )
  end

  def project_finalized_label(finalized, show_text: false, show_tooltip: false)
    if finalized
      text = t('projects.finalized_label')
      icon = 'check-square-o'
      label_class = 'success'
    else
      text = t('projects.not_finalized_label')
      icon = 'square-o'
      label_class = 'default'
    end

    string = show_text ? text : nil
    title = show_tooltip ? text : nil
    content = fa_icon(icon, text: string)

    content_tag(
      :span,
      content,
      class: "label label-#{label_class}",
      data: { toggle: 'tooltip', placement: 'right' },
      title: title
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
      units: {  unit: 'm²' },
      precision: 5,
      delimiter: ' ',
      separator: ','
    )
  end

  def moment(value, full = false)
    value = value.to_date unless full
    time_class = full ? 'moment-datetime' : 'moment-date'
    time_tag(
      value,
      class: time_class
    )
  end

  def metadata_label
    content_tag(
      :span,
      fa_icon('info-circle'),
      class: 'label label-default metadata-popover',
      title: t('info.title')
    )
  end

  def payment_data_for_entry(entry)
    if ['receive', 'polish'].include?(entry.work_type)
      "#{coeff(entry.coefficient)} × #{eur(entry.payout.base_amount)}"
    else
      "#{entry.hours} × #{eur(entry.hourly_rate)}"
    end
  end

  def coeff(number)
    return '-' unless number
    number_to_human(
      number,
      units: nil,
      precision: 1,
      separator: ','
    )
  end

  def project_dates(project)
    return if [project.start_on, project.end_on].none?
    return moment(project.start_on) unless project.end_on
    return moment(project.start_on) if project.start_on == project.end_on

    "#{moment(project.start_on)} &mdash; #{moment(project.end_on)}".html_safe
  end

  def project_dates_label(project)
    return if [project.start_on, project.end_on].none?
    content_tag(
      :span,
      fa_icon('calendar', text: project_dates(project)),
      class: 'label label-primary',
    )
  end

  def desktop_browser?
    %i( mac windows linux ).include? browser.platform
  end
end

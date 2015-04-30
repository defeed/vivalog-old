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
    string = is_active ? I18n.t('statuses.active') : I18n.t('statuses.inactive')
    label_class = is_active ? 'success' : 'default'

    content_tag(
      :span,
      string,
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
    is_active ? I18n.t('statuses.deactivate') : I18n.t('statuses.activate')
  end
end

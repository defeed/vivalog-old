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
end

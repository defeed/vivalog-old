json.project do
  json.start_on @project.start_on.try(:strftime, '%d.%m.%Y')
  json.end_on @project.end_on.try(:strftime, '%d.%m.%Y')
  json.work_types @project.work_types do |type|
    json.key type
    json.value t("work_types.#{type}")
  end
  json.billing_types @project.billing_types do |type|
    json.key type
    json.value t("billing_types.#{type}")
  end
  json.hourly_rate @project.hourly_rate
  json.daily_rate @project.daily_rate
  json.project_rate @project.project_rate
end

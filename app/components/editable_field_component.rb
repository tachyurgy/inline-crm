class EditableFieldComponent < ViewComponent::Base
  attr_reader :record, :field, :label, :input_type

  def initialize(record:, field:, label: nil, input_type: :text)
    @record = record
    @field = field
    @label = label || field.to_s.humanize
    @input_type = input_type
  end

  def display_value
    value = record.public_send(field)
    value.present? ? value : "Click to edit"
  end

  def blank?
    record.public_send(field).blank?
  end

  def url
    polymorphic_path(record)
  end

  def param_key
    record.model_name.param_key
  end

  def input_name
    "#{param_key}[#{field}]"
  end
end

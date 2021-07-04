# frozen_string_literal: true

class AddTypeInRussianToEvents < ActiveRecord::Migration[6.1]
  def up
    Event.find_each do |event|
      event.update!(type_in_russian: Event.human_attribute_name("type.#{event.type}")) if event.type
    end
  end

  def down
    Event.update(type_in_russian: nil)
  end
end

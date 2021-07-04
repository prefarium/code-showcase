# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :recipient, class_name: 'User'

  validates :title, :body, presence: true

  scope :with_type, ->(type) { where(notifiable_type: type) unless type.nil? }

  def mark_as_read
    # Обычный #update не срабатывает в ситуациях, когда notifiable удалён
    update_attribute(:read, true) # rubocop:disable Rails/SkipsModelValidations
  end

  def self.mark_as_read
    # Аналогично, обычный #update не срабатывает на тех моделях, у которых notifiable удалён
    update_all(read: true) # rubocop:disable Rails/SkipsModelValidations
  end
end

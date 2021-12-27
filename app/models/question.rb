# frozen_string_literal: true

class Question < ApplicationRecord
  has_many    :answers, class_name: '::Answer', dependent: :destroy
  has_many    :multiple_choice_answers, class_name: '::MultipleChoiceAnswer', dependent: :destroy
  belongs_to  :survey,  class_name: '::Survey'
  validates :name, presence: true
  validates :type, presence: true
end

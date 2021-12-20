class Question < ApplicationRecord
  has_many    :answers, class_name: '::Answer', dependent: :destroy
  has_many    :multiple_choice_answers, class_name: '::MultipleChoiceAnswer', dependent: :destroy
  belongs_to  :survey,  class_name: '::Survey'
end
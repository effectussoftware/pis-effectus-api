class MultipleChoiceAnswer < ApplicationRecord   
    # Relations
    belongs_to  :question,  class_name: '::Question'

    # Validations
    validates :text, presence: true, uniqueness: { scope: :question_id }, length: { maximum: 19 }

end

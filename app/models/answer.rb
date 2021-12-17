class Answer < ApplicationRecord
    belongs_to :question
    belongs_to :user


    validate :numerical_answer
    validate :range_answer


    def numerical_answer
        if question.type == "Question::Numeric"
            return if Integer(value) rescue nil != nil
            errors.add(:base, :invalid_numeric_value)
        end
    end

    def range_answer
    answer_value = Integer(value) rescue nil
        if question.type == "Question::Range"
            if answer_value != nil
                 if question.max_range >= answer_value && question.min_range <= answer_value
                    return
                 end
            end
            errors.add(:base, :invalid_range_value)
            
        end
    end

    
end

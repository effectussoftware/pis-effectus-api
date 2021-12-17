class Question::MultipleChoice < Question
    validates :options, presence: true
end
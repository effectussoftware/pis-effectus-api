class Question::MultiSel < Question
    validates :options, presence: true
end
class RecipeInstruction < ApplicationRecord
    belongs_to :recipe

    validates :instruction, presence: true
    validates :instruction_step, presence: true
end

module Types
    class RecipeInstructionType < Types::BaseObject
        field :id, ID, null: false
        field :instruction, String, null: false
        field :instruction_step, Integer, null: false, method: :instruction_step
    end
end

module Types
    class RecipeInstructionType < Types::BaseObject
        field :id, ID, null:false
        field :instruction, String, null:false
        field :instruction_step, Integer, null:false
        field :recipe, Type::RecipeType, null:true
    end
end
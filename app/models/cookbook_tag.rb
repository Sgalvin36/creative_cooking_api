class CookbookTag < ApplicationRecord
    belongs_to :cookbook
    belongs_to :tag
end
module Mutations
    class RegisterUser < BaseMutation
        field :user, Types::UserType, null: true
        field :token, String, null: true
        field :errors, [String], null: false
    
        argument :first_name, String, required: true
        argument :last_name, String, required: true
        argument :email, String, required: true
        argument :password, String, required: true
    
        def resolve(first_name:, last_name:, email:, password:)
          user = User.new(
            first_name: first_name,
            last_name: last_name,
            email: email,
            password: password,
          )
    
          if user.save
            token = JsonWebToken.encode({user_id: user.id, roles: user.roles})
            {
              user: user,
              token: token,
              errors: []
            }
          else
            {
              user: nil,
              token: nil,
              errors: user.errors.full_messages
            }
          end
        end
      end
    end
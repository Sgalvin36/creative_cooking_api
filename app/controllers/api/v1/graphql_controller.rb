# frozen_string_literal: true

class Api::V1::GraphqlController < ApplicationController
  skip_after_action :verify_authorized

  def execute
    token = if Rails.env.test?
      request.cookies["jwt"]
    else
      cookies.signed[:jwt]
    end

    current_user = if token
      begin
        decoded_token = JsonWebToken.decode(token)
        User.find_by(id: decoded_token["user_id"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        nil
      end
    else
      nil
    end

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName] || nil
    context = {
      current_user: current_user,
      controller: self
    }
    result = CreativeCookingApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end

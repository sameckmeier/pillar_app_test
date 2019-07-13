module Api
  module V1
    class ReposController < ApplicationController
      def index
        result = FetchRepos.call(organization_name: params[:organization_name])
        if result.success?
          render json: RepoSerializer.new(result.repos)
        else
          render json:   { error: result.error },
                 status: :unprocessable_entity
        end
      end
    end
  end
end

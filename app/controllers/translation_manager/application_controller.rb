module TranslationManager
  class ApplicationController < ::ApplicationController
    protected

    def authenticate!
      if current_user.blank?
        head :forbidden
      end
    end
  end
end

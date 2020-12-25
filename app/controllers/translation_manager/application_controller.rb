module TranslationManager
  class ApplicationController < TranslationManager.base_controller
    protected

    def authenticate!
      if current_user.blank?
        head :forbidden
      end
    end
  end
end

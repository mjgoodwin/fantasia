module Fantasia
  module Policy
    alias_method :call, :send

    def admin?
      admin_for?(user)
    end

    def signed_in?
      user.present?
    end

    private

    attr_reader :model, :user

    def initialize(user, model)
      @user = user
      @model = model
    end

    def admin_for?(user)
      return false unless user
      user.email == "noochworldorder@gmail.com"
    end
  end
end

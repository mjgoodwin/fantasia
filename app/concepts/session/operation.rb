module Session
  class SignIn < Trailblazer::Operation
    contract do
      undef :persisted?
      attr_reader :user

      property :email,    virtual: true
      property :password, virtual: true

      validates :email, :password, presence: true
      validate :password_ok?

      private

      def password_ok?
        return if email.blank? || password.blank?
        @user = User.find_by(email: email)
        if @user.nil? || !Tyrant::Authenticatable.new(@user).digest?(password)
          errors.add(:password, "Wrong password.")
        end
      end
    end

    def process(params)
      validate(params[:session]) do |contract|
        @model = contract.user
      end
    end
  end

  class SignOut < Trailblazer::Operation
    def process(params)
      # empty for now, this could e.g. log signout, etc.
    end
  end

  require "reform/form/validation/unique_validator.rb"
  require "tyrant/sign_up"
  class SignUp < Tyrant::SignUp::Confirmed
    contract do
      validates :email, email: true, unique: true
    end
  end
end

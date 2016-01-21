module Homepage
  class Cell < ::Cell::Concept
    property :current_user
    property :signed_in?

    def show
      if signed_in?
        render "signed_in"
      else
        render "anonymous"
      end
    end
  end
end

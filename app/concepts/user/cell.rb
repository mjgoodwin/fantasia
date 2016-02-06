class User::Cell < ::Cell::Concept
  property :email
  property :created_at

  include Fantasia::Cell::CreatedAt

  def show
    render
  end
end

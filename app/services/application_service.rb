require 'dry/monads/result'

# A Base class for all services in the project
class ApplicationService
  include Dry::Monads::Result::Mixin

  def self.call(*args)
    new.call(*args)
  end
end

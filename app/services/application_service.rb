require 'dry/monads/result'

class ApplicationService
  include Dry::Monads::Result::Mixin

  def self.call(*args)
    new.call(*args)
  end
end

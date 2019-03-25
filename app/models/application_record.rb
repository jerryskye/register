# A base class for all models in the project
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

# frozen_string_literal: true

class ProjectRole < ApplicationRecord
  has_many :project_user
  enum role: { Manager: 1, Tester: 2, Developer: 3 }
end

class TestCase < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort # Indicate a sort column, Mine is position followed https://github.com/itmammoth/rails_sortable
  has_many :case_suites
  has_and_belongs_to_many :test_suites, join_table: :case_suites

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
      end
    end
  end
end

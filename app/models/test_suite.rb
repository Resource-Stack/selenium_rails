require "csv"

class TestSuite < ApplicationRecord
  acts_as_xlsx
  belongs_to :environment
  has_many :case_suites
  has_and_belongs_to_many :test_cases, join_table: :case_suites
  has_many :schedulers

  def self.validate_header(header)
    if header[0] != "field_name"
      return false
    else
      return true
    end
  end

  def self.import(file, name, environment_id, description, dependency)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    if validate_header(header)
      #no_of_suites = TestSuite.all.count

      new_suite = TestSuite.new
      #new_suite_id = no_of_suites.to_i + 1
      new_suite.name = name
      new_suite.environment_id = environment_id
      new_suite.dependency = dependency
      new_suite.description = description
      new_suite.save!
      new_suite_id = new_suite.id
      # Now starting to iterate through each row.
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        test_case = TestCase.new
        test_case.dependency = dependency
        test_case.field_name = row["field_name"]
        test_case.field_type = row["field_type"]
        test_case.read_element = row["read_element"]
        test_case.input_value = row["input_value"]
        test_case.action = row["action"]
        test_case.action_url = row["action_url"]
        test_case.base_url = row["base_url"]
        test_case.xpath = row["xpath"]
        test_case.sleeps = row["sleeps"]
        test_case.new_tab = row["new_tab"]
        test_case.description = row["description"]
        test_case.need_screenshot = row["need_screenshot"]
        test_case.priority = row["sequence"]
        #test_case = TestCase.where(field_name: row['field_name']).first
        #if test_case.blank?
        #  test_case = TestCase.new
        #  test_case.dependency = dependency
        #end
        #if !row['field_name'].blank?
        #  test_case.field_name = row['field_name']
        #end
        #if !row['read_element'].blank?
        #  test_case.read_element = row['read_element']
        #end
        #if !row['input_value'].blank?
        #  test_case.input_value = row['input_value']
        #end
        #if !row['action'].blank?
        #  test_case.action = row['action']
        #end
        #if !row['action_url'].blank?
        #  test_case.action_url = row['action_url']
        #end
        test_case.save!

        CaseSuite.create(test_suite_id: new_suite_id, test_case_id: test_case.id, sequence: row["sequence"])
      end
    else
      logger.error "TestSuite.import invalid xls file. Exitting without creating a test suite"
      return
    end
  end

  def self.open_spreadsheet(file)
    require "iconv"
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end

require 'csv'

class TestSuite < ActiveRecord::Base
  acts_as_xlsx
  belongs_to :environment
  has_and_belongs_to_many :test_cases, join_table: :case_suites
  has_many :schedulers
  
  def self.validate_header(header)
    logger.debug "TestSuite.validate_header - header received is #{header}"
    if header[0] != "field_name" then
      logger.error "TestSuite.validate_header - first column is #{header[0]}"
      return false
      
    else
      logger.debug "TestSuite.validate_header - Valid XLS file. Moving forward..."
      return true
    end
  end
  
  def self.import(file, name, environment_id, dependency)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    if validate_header(header) then
      no_of_suites = TestSuite.all.count
      
      new_suite = TestSuite.new
      new_suite_id = no_of_suites.to_i + 1
      new_suite.name = name
      logger.debug "TestSuite.import - new suite name is #{new_suite.name}"
      new_suite.environment_id = environment_id
      new_suite.dependency = dependency
      
      # Now starting to iterate through each row. 
      (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      logger.debug "TestSuite.import - row is #{row}"
        test_case = TestCase.new
        test_case.dependency = dependency
        test_case.field_name = row['field_name']
        test_case.field_type = row['field_type']
        test_case.read_element = row['read_element']
        test_case.input_value = row['input_value']
        test_case.action = row['action']
        test_case.action_url = row['action_url']
        test_case.base_url = row['base_url']
        test_case.xpath = row['xpath']
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
        CaseSuite.create(test_suite_id: new_suite_id, test_case_id: test_case.id, sequence: row['sequence'])
      end
      new_suite.save!
    else
      logger.error "TestSuite.import invalid xls file. Exitting without creating a test suite"
      return  
    end
  end
  
  def self.open_spreadsheet(file)
    require 'iconv'
    logger.debug("ORIGINAL FILENAME: #{file.original_filename}")
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end

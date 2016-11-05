# encoding: utf-8

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require "rexml/document"
require "date"

puts 'Note a cause of spending:'
expense_text = STDIN.gets.chomp

puts 'How much did you spend?'
expense_amount = STDIN.gets.to_i

puts 'Note date in dd.mm.yyyy format(push a void enter if you make spending today)'
date_input = STDIN.gets.chomp

expense_date = nil

if expense_date == ''
  expense_date = Date.today
else
  expense_date = Date.parse(date_input)
end

puts 'What category of spending?'
expense_category = STDIN.gets.chomp

current_path = File.dirname(__FILE__)

begin
file_name = current_path + '/data/my_expenses.xml'
rescue Errno::ENOENT => error
  abort error.message
end

file = File.new(file_name, 'r:UTF-8')

begin
doc = REXML::Document.new(file)
rescue REXML::ParseException => e
  abort e.message
end

file.close

expenses = doc.elements.find('expenses').first

expense = expenses.add_element('expense', {
                                         'amount' => expense_amount,
                                         'category' => expense_category,
                                         'date' => expense_date.to_s
                                          })

expense.text = expense_text

file = File.new(file_name, 'w:UTF-8')
doc.write(file, 2)
file.close

puts 'Note saved successfully'
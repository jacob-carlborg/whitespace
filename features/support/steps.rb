# encoding: UTF-8

# rubocop:disable Metrics/LineLength
Given(/^a file named "([^"]*)" with invalid UTF-8 content "\\x80"$/) do |filename|
  write_file(filename, "\x80    ")
end

Then(/^the file "([^"]*)" should contain exactly invalid UTF-8 "\\x80"$/) do |filename|
  expect(filename).to have_file_content file_content_eq("\x80")
end
# rubocop:enable Metrics/LineLength

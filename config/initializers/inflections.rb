# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'API'
  inflect.acronym 'CSV'
  inflect.acronym 'CUSIP'
  inflect.acronym 'ISIN'
  inflect.acronym 'RESTful'
  inflect.acronym 'SEDOL'
  inflect.acronym 'TCW'
  inflect.acronym 'XLSX'
  inflect.acronym 'XML'
end

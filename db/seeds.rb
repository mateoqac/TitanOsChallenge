# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Crear países básicos
countries = [
  { code: 'gb', name: 'United Kingdom' },
  { code: 'es', name: 'Spain' }
]

countries.each do |country_data|
  Country.find_or_create_by(code: country_data[:code]) do |country|
    country.name = country_data[:name]
    country.active = true
  end
end

puts "Seeds creados exitosamente!"
puts "Países creados: #{Country.count}"

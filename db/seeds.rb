# Limpiar datos existentes
puts "Limpiando datos existentes..."
UserFavorite.destroy_all
ViewingTime.destroy_all
Schedule.destroy_all
Availability.destroy_all

# Eliminar referencias circulares primero
Content.update_all(tv_show_id: nil, season_id: nil, channel_id: nil)
Content.destroy_all
StreamingApp.destroy_all
Country.destroy_all

# Crear países básicos
puts "Creando países..."
countries = [
  { code: 'GB', name: 'United Kingdom' },
  { code: 'ES', name: 'Spain' }
]

countries.each do |country_data|
  Country.find_or_create_by(code: country_data[:code]) do |country|
    country.name = country_data[:name]
    country.active = true
  end
end

puts "Países creados: #{Country.count}"

# Importar datos del JSON
puts "Importando datos del archivo streams_data.json..."
json_file_path = Rails.root.join('public', 'streams_data.json')

if File.exist?(json_file_path)
  DataImportService.import_from_json(json_file_path)
  puts "¡Datos importados exitosamente!"
else
  puts "Error: No se encontró el archivo streams_data.json en public/"
end

# Mostrar estadísticas finales
puts "\n=== ESTADÍSTICAS FINALES ==="
puts "Países: #{Country.count}"
puts "Apps de streaming: #{StreamingApp.count}"
puts "Contenidos totales: #{Content.count}"
puts "  - Películas: #{Content.where(type: 'Movie').count}"
puts "  - Series: #{Content.where(type: 'TvShow').count}"
puts "  - Temporadas: #{Content.where(type: 'Season').count}"
puts "  - Episodios: #{Content.where(type: 'Episode').count}"
puts "  - Canales: #{Content.where(type: 'Channel').count}"
puts "  - Programas de canal: #{Content.where(type: 'ChannelProgram').count}"
puts "Disponibilidades: #{Availability.count}"
puts "Horarios: #{Schedule.count}"

puts "\n¡Seeds completados exitosamente! 🎉"

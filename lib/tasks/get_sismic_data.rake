namespace :seismic_data do
  desc "Obtener y persistir datos de sismologia mundial"
  task fetch: :environment do
    require 'httparty'
    require 'json'

    api_url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'

    begin
      response = HTTParty.get(api_url)

      if response.success?
        data = JSON.parse(response.body)

        Feature.transaction do
          data['features'].each do |feature_data|
            Feature.create!(
              external_id: feature_data['id'],
              magnitude: feature_data['properties']['mag'],
              place: feature_data['properties']['place'],
              time: Time.at(feature_data['properties']['time'] / 1000), # Convert Unix timestamp to Time object
              tsunami: feature_data['properties']['tsunami'],
              mag_type: feature_data['properties']['magType'],
              title: feature_data['properties']['title'],
              longitude: feature_data['geometry']['coordinates'][0],
              latitude: feature_data['geometry']['coordinates'][1]
            )
          end
        end
        puts "Seismic data fetched and persisted successfully."
      else
        puts "Failed to fetch seismic data: #{response.code} - #{response.message}"
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end
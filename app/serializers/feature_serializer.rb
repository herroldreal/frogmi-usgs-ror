class FeatureSerializer < ActiveModel::Serializer
=begin
  attributes :id, :type, :attributes, :links

  def id
    object.id
  end

  def type
    'feature'
  end

  def links
    {
      external_url: ""
    }
  end
=end

  def attributes(*args)
    hash = super
    attributes_list
  end

  def attributes_list
    {
      id: object.id,
      type: 'feature',
      attributes: {
        external_id: object.external_id,
        magnitude: object.magnitude,
        place: object.place,
        time: object.time,
        tsunami: object.tsunami,
        mag_type: object.mag_type,
        title: object.title,
        coordinates: {
          latitude: object.latitude,
          longitude: object.longitude
        }
      },
      links: {
        external_url: ""
      }
    }
  end
end

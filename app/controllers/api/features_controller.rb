class Api::FeaturesController < ApplicationController
  before_action :set_feature, only: [:create]

  def index
    @features = Feature.all
    filter_features_by_mag_type if params[:mag_type]
    paginate_features
    render_features_as_json
  end

  def create
    create_comment
    render_comment_response
  end

  private

  def set_feature
    @feature = Feature.find(params[:feature_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Feature not found' }, status: :not_found
  end

  def filter_features_by_mag_type
    @features = @features.where(mag_type: params[:mag_type])
  end

  def paginate_features
    @features = @features.page(params[:page]).per(per_page)
  end

  def render_features_as_json
    render json: {
      data: serialize_features,
      pagination: pagination_info(@features)
    }
  end

  def create_comment
    @comment = @feature.comments.create(body: params[:body])
  end

  def render_comment_response
    if @comment.persisted?
      render json: { data: serialize_comment }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def serialize_features
    @features.map { |feature| FeatureSerializer.new(feature) }
  end

  def serialize_comment
    CommentsSerializer.new(@comment)
  end

  def pagination_info(collection)
    {
      current_page: collection.current_page,
      total: collection.total_count,
      per_page: collection.limit_value
    }
  end

  def per_page
    per_page_param = params[:per_page].to_i
    [per_page_param.positive? ? per_page_param : 25, 1000].min
  end
end

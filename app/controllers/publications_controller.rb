class PublicationsController < ApplicationController
  before_action :set_publication, only: [:show, :edit, :update, :destroy, :publish, :hide]
  # noinspection RailsParamDefResolve
  before_action :authenticate_user!, except: [:index]

  # GET /refresh
  def refresh
    PublicationsController.twitter.search('#FeteDesGrandMeres  -rt').each do |tweet|
      unless Publication.find_by_twitter_id tweet.id
        pub = Publication.new author: "@#{tweet.user.screen_name}",
                              author_image: tweet.user.profile_image_url_https.to_s,
                              content: tweet.full_text,
                              published: false
        if tweet.media.first
          m = tweet.media.first
          if m.instance_of? Twitter::Media::Photo
            pub.resource_type = 'image'
            pub.resource = m.media_uri_https
          elsif m.instance_of? Twitter::Media::Video
            pub.resource_type = 'video'
            pub.resource = m.video_info.variants.first.url.to_s
            pub.time = m.video_info.duration_millis
          elsif m.instance_of? Twitter::Media::AnimatedGif
            pub.resource_type = 'gif'
            pub.resource = m.video_info.variants.first.url.to_s
          end
        end
        pub.save!
      end
    end
    redirect_to action: :index
  end

  # GET /publications/1/publish
  def publish
    @publication.update! published: true
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { render json: {status: @publication.published}}
    end
  end

  # GET /publications/1/hide
  def hide
    @publication.update! published: false
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { render json: {status: @publication.published}}
    end
  end

  # GET /publications
  # GET /publications.json
  def index
    @publications = Publication.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: Publication.where(published: true)}
    end
  end

  # GET /publications/1
  # GET /publications/1.json
  def show
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications
  # POST /publications.json
  def create
    @publication = Publication.new(publication_params)

    respond_to do |format|
      if @publication.save
        format.html { redirect_to @publication, notice: 'Publication was successfully created.' }
        format.json { render :show, status: :created, location: @publication }
      else
        format.html { render :new }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1
  # PATCH/PUT /publications/1.json
  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to @publication, notice: 'Publication was successfully updated.' }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    @publication.destroy
    respond_to do |format|
      format.html { redirect_to publications_url, notice: 'Publication was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    @twitter_api = nil
    def self.twitter
      @twitter_api = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['CONSUMER_KEY']
        config.consumer_secret = ENV['CONSUMER_SECRET']
        config.access_token = ENV['YOUR_ACCESS_TOKEN']
        config.access_token_secret = ENV['YOUR_ACCESS_SECRET']
      end if @twitter_api.nil?
      @twitter_api
    end
  # Use callbacks to share common setup or constraints between actions.
    def set_publication
      @publication = Publication.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def publication_params
      params.require(:publication).permit(:author, :author_image, :content, :resource_type, :resource, :time, :twitter_id, :published)
    end
end

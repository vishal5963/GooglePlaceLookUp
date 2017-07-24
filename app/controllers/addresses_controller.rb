class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = Address.all
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @existing_address = Address.where('address LIKE ?', "#{params[:address][:address]}%")
    if @existing_address.present?
      puts @existing_address.as_json
      @address = @existing_address.take.dup
      # @address.save
      # redirect_to root_path
    else
      @address = Address.new(address_params)
      random_array = [true, false]
      # serverlookup = false
      serverlookup = random_array.sample
      if serverlookup == true
        address = params[:address][:address]
        puts "______"
        puts Geocoder.coordinates(address).as_json
        lat = Geocoder.coordinates(address).first
        lng = Geocoder.coordinates(address).last
        puts "********#{lat}************#{lng}************"
      # redirect_to root_path

      else
        # (30.730032 , -170.859375)
        lat =  random_location(-170.859375,30.730032,100)[1]
        lng =  random_location(-170.859375,30.730032,100)[0]
      end
      @address.latitude = lat
      @address.longitude = lng
      @address.save
      # respond_to do |format|
      #   if @address.save
      #     format.html { redirect_to @address, notice: 'Address was successfully created.' }
      #     format.json { render :show, status: :created, location: @address }
      #   else
      #     format.html { render :new }
      #     format.json { render json: @address.errors, status: :unprocessable_entity }
      #   end
      # end
    end
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:address, :latitude, :longitude)
    end


    def random_point_in_disk(max_radius)
      r = max_radius * rand**0.5
      theta = rand * 2 * Math::PI
      [r * Math.cos(theta), r * Math.sin(theta)]
    end

    def random_location(lon, lat, max_radius)
      earth_radius = 6371 # km
      one_degree = earth_radius * 2 * Math::PI / 360 * 1000 # 1° latitude in meters
      dx, dy = random_point_in_disk(max_radius)
      random_lat = lat + dy / one_degree
      random_lon = lon + dx / ( one_degree * Math::cos(lat * Math::PI / 180) )
      puts random_lat
      puts random_lon
      puts "*****************"
      [random_lon, random_lat]
    end
end

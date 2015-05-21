require "geocoder"
require "httparty"

class Submission < ActiveRecord::Base
  # Attributes
  attr_accessible :restaurant_name, :restaurant_address, :description, :date,
    :first_name, :last_name, :twitter_handle, :email, :phone, :tweet_id

  # Validation
  validates :restaurant_name, :restaurant_address, :description, :date,
    :first_name, :last_name, :email,
    :presence => true

  # Callbacks
  before_create :create_service_request

  def api_enabled?
    L10N['API_ENABLED'] ? true : false
  end

  private

  # Create an Open311 service request
  def create_service_request
    # Geocode the address
    lat, long = Geocoder.coordinates("#{self.restaurant_address} , #{L10N['CITY']}, #{L10N['STATE_ABBREV']}") 
    request_body =  {
      :api_key => L10N['API_KEY'],
      :service_code => L10N['API_SERVICE_CODE'],
      :attribute => {
      :PLEASESE => 'FOODPOIS',
      :WHATISTH => self.restaurant_name,
      :ONWHATDA => self.date
    },
      :address_string => self.restaurant_address,
      :description => self.description,
      :lat => lat, 
      :long => long, 
      :first_name => self.first_name,
      :last_name => self.last_name,
      :email => self.email,
      :phone => self.phone
    }

    if api_enabled?
      HTTParty.post(L10N['API_POST_ENDPOINT'], :body => request_body)
    else
      puts request_body
    end
  end
end

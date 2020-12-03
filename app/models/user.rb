class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :environments

  def self.generate_jwt_token(user_id , expiry_time = 1.hours.from_now.to_i)
    payload = {'user_id'=> user_id, 'exp'=> expiry_time};
    JWT.encode(payload, jwt_secret)
  end
      
  def self.decode_jwt_token(authToken)
    token = authToken.present? ? authToken.split(' ')[1]: ''
    HashWithIndifferentAccess.new(JWT.decode(token, jwt_secret)[0])
  rescue
    nil
  end

  private

  def self.jwt_secret
    YAML.load(File.read('config/jwt-secret.yml'))
  end
end

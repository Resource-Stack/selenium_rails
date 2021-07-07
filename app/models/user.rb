# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :environments
  has_many :invitations, class_name: to_s, as: :invited_by
  has_many :project_users
  has_many :projects
  attribute :admin, :boolean, default: false

  def self.generate_jwt_token(user_id, expiry_time = 1.hours.from_now.to_i)
    payload = { 'user_id' => user_id, 'exp' => expiry_time }
    JWT.encode(payload, jwt_secret)
  end

  def self.decode_jwt_token(authToken)
    token = authToken.present? ? authToken.split(' ')[1] : ''
    HashWithIndifferentAccess.new(JWT.decode(token, jwt_secret)[0])
  rescue StandardError
    nil
  end

  def self.jwt_secret
    YAML.safe_load(File.read('config/jwt-secret.yml'))
  end
end

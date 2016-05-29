
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, 
    :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:facebook,:twitter,:linkedin,:instagram]
  acts_as_voter
  acts_as_follower
  acts_as_followable

  has_many :posts
  has_many :comments
  has_many :events
  has_many :identities

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader

  validates_presence_of :name

  self.per_page = 10

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]


   def self.from_omniauth(auth, current_user)
    identity = Identity.where(:provider => auth.provider, :uid => auth.uid, :accesstoken => auth.credentials.token, :secret => auth.credentials.secret ).first_or_initialize
      if identity.user.blank?
       user = current_user || User.where('email = ?', auth["info"]["email"]).first
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
       user.password = Devise.friendly_token[0,20]
       user.save
       user
      if auth.provider == "twitter" 
         user.save(:validate => false) 
       else
         user.save
      end
     end
     identity.avatar_url = auth.info.image
     identity.profile_url = auth.info.link
     identity.user_id = user.id
     identity.save
    end
   identity.user
 end
   
  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

 end

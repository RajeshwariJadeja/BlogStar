class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,:confirmable
  attr_accessible :image
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png",:storage => :s3,
       :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    {:bucket => "miipls", :access_key_id => "AKIAIIE6B7BA475DGKEA", :secret_access_key => "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"}
  end
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
                                           
  # Setup accessible (or protected) attributes for your model
  attr_accessor :login

  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :user_name, :first_name, :last_name,:image
  validates :user_name, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
 
	validates_uniqueness_of(:user_name)

  def login=(login)
    @login = login
  end

  def login
    @login || self.user_name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:user_name) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

 def self.from_omniauth(auth)


   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
   	 		user.provider = auth.provider
        user.uid = auth.uid
     case auth.provider
     when "twitter"
      user.user_name = auth.info.nickname
         user.email = auth.info.nickname.to_s+'@twitter.com'
         user.image=auth.info.image
         user.save(:validate => false) 
    when "facebook"
      user.email = auth.info.email
        user.user_name = auth.info.name
        user.image = auth.info.image.gsub("http","https")
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save(:validate => false)
    when "google_oauth2"
          user.email = auth.info.email
          user.user_name = auth.info.name
           user.image=auth.info.image
          user.save(:validate => false)


      else
        user.save
      	
       end
     end
  end

  def self.new_with_session(params,session)
   	if session["devise.user_attributes"]
	 		new(session["devise.user_attributes"],without_protection:true) do |user|
				user_attributes=params
	 			user.valid?
	 		end
	 	else
	 		super
	 	end
	 end

	 def password_required?
	 	super && provider.blank?
	 end

	 def update_with_password(params,*options)
	 	if encrypted_password.blank?
	 		update_attributes(params,*options)
	 	else
	 		super
	 	end
			
			
	 end
end

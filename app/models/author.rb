require 'digest/sha1'
class Author < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  has_many :questions
  attr_accessor :password

#  validates_presence_of     :login ,                     :message => 'Имя не может быть пустым'
#  validates_presence_of     :password,                   :message => 'Пароль не может быть пустым'
#  validates_presence_of     :password_confirmation,      :message => 'Подтверждение пароля не может быть пустым'      
  validates_length_of       :password, :in => 4..20, :too_long => 'Длина пароля должна быть не более 20 символа', :too_short => 'Длина пароля должна быть не менее 4 символов'
  validates_confirmation_of :password, :message => 'Подтверждение пароля не совпадает'                   
  validates_length_of       :login,    :in => 4..20, :too_long => 'Длина имени должна быть не более 20 символа', :too_short => 'Длина имени должна быть не менее 4 символов'
#  validates_length_of       :email,    :within => 3..100
  validates_presence_of     :fio, :message => 'ФИО не может быть пустым'
  validates_uniqueness_of   :login, :case_sensitive => false, :message => 'Это имя уже занято'
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def change_password(params)
    pass = params[:password]
    pass_conf = params[:password_confirmation]
    if pass != pass_conf
      errors.add_to_base 'Подтверждение пароля не совпадает'
    elsif pass.size < 4 
      errors.add_to_base 'Длина пароля должна быть не менее 4 символов'
    elsif pass.size > 20
      errors.add_to_base 'Длина пароля должна быть не более 20 символа'
    else
      self.password = pass
      self.password_confirmation = pass_conf
      return save
    end
    false    
  end

  def change_fio(params)
    fio = params[:fio]
    unless fio.blank?
      self.update_attribute :fio, fio
      return true
    else
      errors.add_to_base 'ФИО не может быть пустым'
    end
    false
  end
  
  def admin?
    admin
  end
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end

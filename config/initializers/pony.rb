Pony.options = {
  :to => 'jurgis.megnis@gmail.com',
  :via => :smtp,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'jurgis.megnis',
    :password             => 'kastanis',
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "jackalope.umhost.eu" # the HELO domain provided by the client to the server
  }
}
class Db
  def initialize
    @host     = ENV['DB_HOST']     ||= 'localhost'
    @port     = ENV['DB_PORT']     ||= '5432'
    @dbname   = ENV['DB_NAME']     ||= 'db'
    @user     = ENV['DB_USER']     ||= ''
    @password = ENV['DB_PASSWORD'] ||= ''
  end

  def config
    { host: @host, port: @port, dbname: @dbname, user: @user, password: @password }
  end
end

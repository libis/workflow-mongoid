require 'mongoid'

class LogConfig
  include Mongoid::Document

  field :path, type: String
  field :filename, type: String
  field :count, type: Integer
  field :rotate, type: String, default: 'daily'
  field :max_size, type: Integer
  field :level, type: Integer, default: 0

  def logger(filename)
    @logger ||=
        self.path ?
            begin
              logger = ::Logger.new(
                  File.join(self.path, self.filename || filename),
                  (self.count || self.rotate),
                  (self.max_size || 1024 ** 2)
              )
              logger.formatter = ::Logger::Formatter.new
              logger.level = self.log_level
              logger
            end : nil
  end

end
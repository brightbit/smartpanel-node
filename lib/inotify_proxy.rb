def is_mac?
  RUBY_PLATFORM.downcase.include?("darwin")
end

def is_windows?
  RUBY_PLATFORM.downcase.include?("mswin")
end

def is_linux?
  RUBY_PLATFORM.downcase.include?("linux")
end

require 'rb-inotify' if is_linux?
require 'rb-fsevent' if is_mac?

class InotifyProxy
  attr_reader :notifier

  def initialize(absolute_path, options={})
    @path = absolute_path
    @notifier = INotify::Notifier.new if is_linux?
    @notifier = FSEvent.new if is_mac?
  end

  def watch(proc=nil)
    if proc.nil? and not(proc.kind_of?(Proc))
      proc = lambda { |event| puts "Detected change inside: #{event.class}" }
    end

    if is_mac?
      @notifier.watch([@path]) do |event|
        proc.call
      end
    elsif is_linux?
      @notifier.watch(@path, :modify) do |event|
        proc.call
      end
    end
  end

  def run
    @notifier.run
  end

  def stop
    @notifier.stop
  end
end

module EurekaBot::Tg::Controller::RepliesConcern
  extend ActiveSupport::Concern

  def reply_markup(type: :classic, **options, &block)
    markup = case type
               when :inline
                 InlineMarkup.new(self, options)
               when :classic
                 ClassicMarkup.new(self, options)
               else
                 raise
             end
    markup.run(&block)
    markup
  end

  def global_reply_markup
    reply_markup resize_keyboard: true, one_time_keyboard: false do
      [
        ['Get Tasks', 'Account', 'Help']
      ]
    end
  end

  class Markup
    attr_reader :context, :items, :options

    def initialize(context, options={})
      @context = context
      @options = options
      @items   = []
    end

    def run(&block)
      @items = block.call(self)
    end

    def method_missing(symbol, *args)
      if context.respond_to?(symbol)
        context.send(symbol, *args)
      else
        super
      end
    end
  end

  class ClassicMarkup < Markup
    def as_json(*args)
      {
        keyboard:          items,
        resize_keyboard:   options[:resize_keyboard],
        one_time_keyboard: options[:one_time_keyboard],
        selective:         options[:selective],
      }.compact.as_json(*args)
    end
  end

  class InlineMarkup < Markup
    def as_json(*args)
      {
        inline_keyboard: items
      }.as_json(*args)
    end
  end
end

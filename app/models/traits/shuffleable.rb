module Traits::Shuffleable
  extend ActiveSupport::Concern

  module ClassMethods
    # Pluck random ideas
    def take_random(options = {})
      count = options.fetch(:count)
      seed  = options.fetch(:seed, nil)
      limit(count).order(get_random_order_sql(seed))
    end

    protected

    PRIME_A      = 7_901
    PRIME_B      = 7_907
    PRIME_C      = 7_919

    # Pseudo-RNG seeded by +seed+ and +id+.
    def get_random_order_sql(seed)
      "((#{PRIME_A} * ((id + #{seed % PRIME_C}) % #{PRIME_C}) + #{PRIME_B}) % #{PRIME_C})"
    end

  end
end

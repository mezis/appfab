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

    PRIME_A      = 46_691
    PRIME_B      = 50_821
    PRIME_C      = 54_251
    MAX_ELEMENTS = 10_000

    # Pseudo-RNG seeded by +seed+ and +id+.
    def get_random_order_sql(seed)
      "((#{PRIME_A} * id + #{PRIME_B * seed + PRIME_C}) % #{MAX_ELEMENTS})"
    end

  end
end
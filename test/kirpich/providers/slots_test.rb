require 'test_helper'
require 'kirpich/providers/slots'

class Kirpich::Providers::SlotsTest < Minitest::Test
  def setup
  end

  def test_zero_spin
    text, state = Kirpich::Providers::Slots.spin(0)
    assert { state == 0 }
    assert { Kirpich::Dict::SPIN_ZERO.include?(text) }
  end

  def test_spin
    text, state = Kirpich::Providers::Slots.spin(100)
    assert { text.any? }
  end

  def test_scores
    c = Kirpich::Providers::Slots::CHERRY
    b = Kirpich::Providers::Slots::BAR
    j = Kirpich::Providers::Slots::JACKPOT

    score = Kirpich::Providers::Slots.calc_score([j, j, j])
    assert { score == Kirpich::Providers::Slots::JACKPOT_SCORE }

    score = Kirpich::Providers::Slots.calc_score([c, c, c])
    assert { score == Kirpich::Providers::Slots::CHERRY_SCORE_3 }

    score = Kirpich::Providers::Slots.calc_score([c, c, b])
    assert { score == Kirpich::Providers::Slots::CHERRY_SCORE_2 }

    score = Kirpich::Providers::Slots.calc_score([c, b, b])
    assert { score == Kirpich::Providers::Slots::CHERRY_SCORE_1 }

    score = Kirpich::Providers::Slots.calc_score([b, b, b])
    assert { score == Kirpich::Providers::Slots::BAR_SCORE }
  end
end

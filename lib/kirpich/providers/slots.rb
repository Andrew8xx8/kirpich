module Kirpich::Providers
  class Slots
    RATE = 10
    JACKPOT_SCORE = 1000
    CHERRY_SCORE_3 = 100
    CHERRY_SCORE_2 = 60
    CHERRY_SCORE_1 = 10
    BAR_SCORE = 200
    CHERRY = '🍒'
    BAR = '🍷'
    JACKPOT = '🎰'
    FRUITS = ['🍋', '🍌', '🥝', '🍑']
    SECTORS = [CHERRY, FRUITS[0], JACKPOT, FRUITS[1], BAR, FRUITS[2], FRUITS[3]]

    class << self
      def wintable
        ["3 x #{CHERRY} — #{CHERRY_SCORE_3} | 2 x #{CHERRY} — #{CHERRY_SCORE_2} | #{CHERRY} — #{CHERRY_SCORE_1} | 3 x #{BAR} — #{BAR_SCORE} | 3 x #{JACKPOT} — #{JACKPOT_SCORE}", "Выплаты лучшие в городе, :APPEAL:!"]
      end

      def spin(score, line_index = 1, rate = 1)
        if score <= RATE * rate
          text = Kirpich::Dict::SPIN_ZERO.sample
          return [text, score]
        end

        lines = random_lines
        earned_socre = calc_score(lines[line_index].map { |s| show_sector(s) }) * rate

        score = score - rate * RATE + earned_socre

        texts = ["Вкинул #{rate * RATE}"]
        lines.each_with_index do |line, i|
          texts.push(print_line(line, rate, earned_socre, i == line_index))
        end
        texts.push((earned_socre > 0) ? Kirpich::Dict::SPIN_WIN.sample : Kirpich::Dict::SPIN_FAIL.sample)
        texts.push("Cчет: #{score}")

        [texts, score]
      end

      def calc_score(line)
        return JACKPOT_SCORE if select(line, JACKPOT).length == 3
        return BAR_SCORE if select(line, BAR).length == 3

        cherry_count = select(line, CHERRY).length
        return CHERRY_SCORE_3 if cherry_count == 3
        return CHERRY_SCORE_2 if cherry_count == 2
        return CHERRY_SCORE_1 if cherry_count == 1

        0
      end

      private

      def random_lines
        first_line = [rand(SECTORS.length), rand(SECTORS.length), rand(SECTORS.length)]
        second_line = first_line.map { |l| l + 1 }
        third_line = first_line.map { |l| l + 2 }
        [first_line, second_line, third_line]
      end

      def select(line, type)
        line.select{ |s| s == type }
      end

      def print_line(line, rate, earned_score, winline = false)
        "#{show_sector(line[0])} : #{show_sector(line[1])} : #{show_sector(line[2])} #{winline ? rate_sign('<', rate) + " #{(earned_score / rate).to_i} x #{rate}" : ''}"
      end

      def rate_sign(sign, rate)
        (1..rate).map { |_| sign }.join('')
      end

      def show_sector(i)
        if i < SECTORS.length && i >= 0
          SECTORS[i]
        elsif i < 0
          SECTORS[i + SECTORS.length]
        else
          SECTORS[i - SECTORS.length]
        end
      end
    end
  end
end

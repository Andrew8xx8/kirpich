module Kirpich::Providers
  class Slots
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
      def spin
        winline = [rand(SECTORS.length), rand(SECTORS.length), rand(SECTORS.length)]
        first_line = winline.map { |l| l - 1 }
        last_line = winline.map { |l| l + 1 }

        [
          [
            print_line(first_line, false),
            print_line(winline, true),
            print_line(last_line, false),
          ],
          calc_score(winline.map { |s| show_sector(s) })
        ]
      end

      def calc_score(winline)
        return JACKPOT_SCORE if select(winline, JACKPOT).length == 3
        return BAR_SCORE if select(winline, BAR).length == 3

        cherry_count = select(winline, CHERRY).length
        return CHERRY_SCORE_3 if cherry_count == 3
        return CHERRY_SCORE_2 if cherry_count == 2
        return CHERRY_SCORE_1 if cherry_count == 1
        0
      end

      private

      def select(line, type)
        line.select{ |s| s == type }
      end

      def print_line(line, winline = false)
        "#{show_sector(line[0])} : #{show_sector(line[1])} : #{show_sector(line[2])} #{winline ? '<' : ''}"
      end

      def jackpot?(slots)
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

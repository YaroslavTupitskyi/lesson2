require 'yaml'

class Ball
  ANSWERS = YAML.load_file(File.join(__dir__, './answers.yml'))
  COLORS = [31, 32, 33, 34]
  def shake
    number_answer = Random.rand(ANSWERS.size)
    puts "\e[#{COLORS[number_answer / 5]}m#{ANSWERS[number_answer]}\e[0m"
    ANSWERS[number_answer]
  end
end

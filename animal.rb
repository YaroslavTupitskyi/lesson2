module Actions
  SOME_VALUE = 1
  MIN_VALUE = 0
  MAX_VALUE = 20
  WHEN_ASLEEP = ['В даний момент герой спить', 'Не чіпайте коли він спить']

  def feed
    if @asleep
      puts WHEN_ASLEEP.sample
    else
      @info[:level_of_food] = MAX_VALUE
      @info[:demand_for_walk] += SOME_VALUE
      @info[:placidity] += SOME_VALUE
      @info[:health] += SOME_VALUE
      puts "#{@name} наївся."
      passed_few_time
    end
  end

  def walk
    if @asleep
      puts WHEN_ASLEEP.sample
    else
      @info[:demand_for_walk] = MIN_VALUE
      @info[:cleanliness] -= rand(SOME_VALUE + 2)
      @info[:activity] -= rand(SOME_VALUE * 2)
      @info[:health] += SOME_VALUE
      puts "#{@name} гуляє."
      passed_few_time
    end
  end

  def play
    if @asleep
      puts WHEN_ASLEEP.sample
    else
      @info[:level_of_food] -= SOME_VALUE
      @info[:activity] -= SOME_VALUE
      @info[:mood] = MAX_VALUE
      @info[:health] -= rand(0..SOME_VALUE)
      puts "#{@name} бігає за вами та весело сміється."
      passed_few_time
    end
  end

  def slumber
    @asleep = true
    rand(3).times do
      passed_few_time
    end
    @info[:placidity] = MAX_VALUE
    @info[:health] += SOME_VALUE
    puts "#{@name} солодко спить."
  end

  def wake
    if !@asleep
      puts 'Малюк на даний момент не спить.'
    else
      @asleep = false
      puts "#{@name} проснувся(лась)."
      @info[:activity] = MAX_VALUE
      status
    end
  end

  def bathe
    if @asleep
      puts WHEN_ASLEEP.sample
    else
      @info[:cleanliness] = MAX_VALUE
      @info[:level_of_food] -= SOME_VALUE
      @info[:mood] += SOME_VALUE
      puts 'Ваш улубленець плаває в ванній.'
      passed_few_time
    end
  end

  def kick
    if @asleep
      puts 'Ваш покемон проснувся и засмутився що ви його б’єте.'
      @info[:placidity] -= rand(SOME_VALUE + 2)
      @asleep = false
    else
      @info[:placidity] -= SOME_VALUE
      @info[:health] -= SOME_VALUE
      puts 'Навіщо ви б’єте покемона? Йому це не подобається.'
      passed_few_time
    end
  end

  def kiss
    puts 'Покемони це люблять'
    @info[:placidity] += SOME_VALUE
    @info[:mood] += SOME_VALUE
  end

  def shout
    @info[:mood] -= rand(SOME_VALUE + 2)
    puts 'Покемони не люблять коли на них кричать.'
    passed_few_time
  end

  def kill
    puts 'Ви вбили вашого героя. Це залишиться на вашій совісті.'
    exit
  end
end

class Animal
  include Actions
  MIN_VALUE = 0
  MAX_VALUE = 20

  def initialize(name)
    @name = name
    @asleep = false
    @info = { mood: MAX_VALUE, health: MAX_VALUE, level_of_food: MAX_VALUE,
              activity: MAX_VALUE, cleanliness: MAX_VALUE,
              demand_for_walk: MIN_VALUE, placidity: MAX_VALUE }
    @small = ''
  end

  def status
    puts "\tПокімон: #{@name}
    Настрій            : #{@info[:mood]}
    Здоров’я           : #{@info[:health]}
    Ситість            : #{@info[:level_of_food]}
    Активність         : #{@info[:activity]}
    Чистота            : #{@info[:cleanliness]}
    Потреба прогулянки : #{@info[:demand_for_walk]}
    Доброзичливість    : #{@info[:placidity]}"
  end

  def help
    file = IO.read('help.txt')
    puts "\e[32m#{file}\e[0m"
  end

  private

  def passed_few_time
    @info.each_key { |key| @info[key] -= rand(2) if key != :demand_for_walk }
    check_max
    check_min
    status
  end

  def check_max
    @info.each_key { |key| @info[key] = MAX_VALUE if @info[key] > MAX_VALUE }
    after_check_max
  end

  def after_check_max
    puts "\e[33mУпссс..не встигли\e[0m" if @info[:demand_for_walk] >= MAX_VALUE
    @info[:demand_for_walk] = MIN_VALUE if @info[:demand_for_walk] >= MAX_VALUE
  end

  def check_min
    @info.each { |key, value| @small = key if value <= 0 }
    after_check_min
  end

  def after_check_min
    case @small
    when :health, :level_of_food, :activity
      puts "\e[31m#{@name} помер(ла) від втрати енергії\e[0m"
      exit
    when :mood, :placidity, :cleanliness
      puts "\e[31m#{@name} розцарапав(ла) Вас та втік(ла)\e[0m"
      exit
    end
  end
end

puts 'Введіть ім’я героя:'
animal = Animal.new(name = gets.chomp)
puts "Вашого покемона звати #{name}"
puts 'Щоб дізнатися інформацію про команди - введіть "help"
      Для того щоб вийти з гри - команду "exit"'
command = ''
until command == 'exit'
  command = gets.chomp
  case command
  when 'feed'
    animal.feed
  when 'walk'
    animal.walk
  when 'play'
    animal.play
  when 'slumber'
    animal.slumber
  when 'wake'
    animal.wake
  when 'bathe'
    animal.bathe
  when 'kick'
    animal.kick
  when 'kiss'
    animal.kiss
  when 'shout'
    animal.shout
  when 'kill'
    animal.kill
  when 'help'
    animal.help
  when 'status'
    animal.status
  end
end

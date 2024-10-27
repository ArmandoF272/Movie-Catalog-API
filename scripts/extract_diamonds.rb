def extract_diamonds(expression)
  diamonds_count = 0
  expression.delete!('.')

  while expression.include?('<>')
    expression = expression.sub('<>', '')
    diamonds_count += 1
  end

  diamonds_count
end

expression = "<<.<<..>><>><.>.>.<<.>.<.>>>><>><>>"

puts "Enter an expression or press enter to continue with the expression below"
puts expression

inserted_expression = gets.chomp

expression = inserted_expression.strip.size > 0 ? inserted_expression : expression
puts "Diamonds extracted: #{extract_diamonds(expression)}"
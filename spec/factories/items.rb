FactoryBot.define  do
  factory :item do
    name { Factory::StarWars.character }
    done false
    todo_id nil
  end
end
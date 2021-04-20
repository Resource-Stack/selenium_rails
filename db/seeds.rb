if ResultsDictionary.count == 0
    ResultsDictionary.create(description: "SUCCESS")
    ResultsDictionary.create(description: "ERROR")
end

if ProjectRole.count == 0 
    ProjectRole.create({:id=>1, :is_active=>true, :name=>"Manager"})
    ProjectRole.create({:id=>2, :is_active=>true, :name=>"Tester"})
    ProjectRole.create({:id=>3, :is_active=>true, :name=>"Developer"})
end

# frozen_string_literal: true

if ResultsDictionary.count.zero?
  ResultsDictionary.create(description: 'SUCCESS')
  ResultsDictionary.create(description: 'ERROR')
end

if ProjectRole.count.zero?
  ProjectRole.create({ id: 1, is_active: true, name: 'Manager' })
  ProjectRole.create({ id: 2, is_active: true, name: 'Tester' })
  ProjectRole.create({ id: 3, is_active: true, name: 'Developer' })
end

if Browser.count.zero?
  Browser.browsers.map do |b|
    Browser.create(id: b[1], name: b[0])
  end
end

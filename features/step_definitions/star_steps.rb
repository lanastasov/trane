Дадено 'че студент "$user" има звездичка за тема "$topic"' do |user_name, topic_title|
  user = Factory(:user, :full_name => user_name)
  Factory(:topic, :user => user, :starred => true, :title => topic_title)
end

Когато 'махна звездичката на темата "$topic"' do |topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within 'ol.topic li:first-child' do
    click_link 'Махни звездичката'
  end
end

Когато 'дам звездичка на темата "$topic"' do |topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within 'ol.topic li:first-child' do
    click_link 'Дай звездичка'
  end
end

Когато 'дам звездичка на отговора на "$user" на темата "$topic"' do |user, topic_title|
  topic = Topic.find_by_title! topic_title
  visit topic_path(topic)

  within "ol.topic li:has(:contains('#{user}'))" do
    click_link 'Дай звездичка'
  end
end

То /^"(.*?)" трябва да има "(\d+)" точк(?:а|и)$/ do |name, points|
  user = User.find_by_full_name! name
  user.points.should == points.to_i
end

То 'темата "$topic" трябва да има звездичка' do |topic_title|
  topic = Topic.find_by_title! topic_title
  topic.should be_starred
end

Дадено 'че студент "$user" има звездичка за отговор на тема "$topic"' do |user_name, topic_title|
  user  = User.find_by_full_name(user_name) || Factory(:user, :full_name => user_name)
  topic = Factory(:topic, :title => topic_title)
  Factory(:reply, :topic => topic, :user => user, :starred => true)
end

То 'профилът на "$user" трябва да показва, че има бонус точки от темите:' do |user_name, table|
  user = User.find_by_full_name! user_name
  visit user_path(user)

  table.raw.each do |row|
    topic_title = row.first
    page.should have_selector("a:contains('#{topic_title}')")
  end
end

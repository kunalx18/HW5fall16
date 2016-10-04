# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  
  movies_table.hashes.each do |movie|
    @movies = Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  all_args = ["G", "PG-13", "NC-17", "R", "PG"]
  arg_array = arg1.gsub(/\s+/, "").split(",")
  arg_array.each{|x| check('ratings_'<<x)}
  all_args = all_args - arg_array
  all_args.each{|x| uncheck('ratings_'<<x)}
  click_button('Refresh')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    @i = 0
    result = true
    arg1 = arg1.gsub(/\s+/, "").split(",")
    page.all('td').each do |x|
        if ((@i-1) % 4) == 0 then
            result = (arg1.include? x.text) && result
        end
        @i = @i + 1
    end
    expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
    result = false
    @i = -1
    
    page.all('tr').each do |x|
        @i = @i + 1
    end
    
    if Movie.count() == @i then
        result = true
    end
    
    expect(result).to be_truthy
end

When /^I have selected the link to sort by "(.*?)"$/ do |arg1|
    arg1 = arg1.gsub(/\s+/, "").downcase
    if arg1 == "title" then
        click_link('title_header')
    elsif arg1 == "release_date" then
        click_link('release_date_header')
    end
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2| 
    @i = 0
    
    result = false
    
    page.all('td').each do |x|
        if (@i % 4) == 0 then
            if x.text == movie1 then
                @one_pos = @i
            elsif x.text == movie2 then
                @two_pos = @i
            end
        end
        @i = @i + 1
    end
    
    if @one_pos < @two_pos then
        result = true
    end
    
    expect(result).to be_truthy
end
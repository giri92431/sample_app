module ApplicationHelper

#return  atitle on a page
def title 
 base_title ="ruby on rails tutorial sample app"
 if @title.nil?
 base_title
 else
 "#{base_title} | #{@title}"
 end
end
end

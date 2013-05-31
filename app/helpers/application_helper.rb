module ApplicationHelper
  def rank_name(rank_id)
    case
    when rank_id == 1
      "Tenth Gup"
    when rank_id == 2
      "Ninth Gup"
    when rank_id == 3
      "Eighth Gup"
    when rank_id == 4
      "Seventh Gup"
    when rank_id == 5
      "Sixth Gup"
    when rank_id == 6
      "Fifth Gup"
    when rank_id == 7
      "Fourth Gup"
    when rank_id == 8
      "Third Gup"
    when rank_id == 9
      "Second Gup"
    when rank_id == 10
      "First Gup"
    when rank_id == 11
      "First Dan"
    when rank_id == 12
      "Second Dan"
    when rank_id == 13
      "Third Dan"
    when rank_id == 14
      "Fourth Dan"
    else
      "Senior Master"
    end
  end
  
  def role_name(role)     # role is a string, i.e. "admin"
    (0...User::ROLES.length).each do |i|
      return User::ROLES[i][0] if role.to_sym == User::ROLES[i][1]    # returns the corresponding name of the role, i.e. "Administrator"
    end
  end
  
  def eligible_sections_for_student(student)
    # I want sections for a specific rank, for a specific age, that are active and for active future tournaments 
    # and have the list arranged in alphabetical order.
    all_sections = Section.for_rank(student.rank).for_age(student.age).active.alphabetical.all
    eligible_sections = Array.new
    all_sections.each do |section|
      eligible_sections << section unless (section.tournament.date < Date.today || !section.tournament.active || !section.active)
    end
  end
  
  def eligible_unregistered_sections_for_student(student)
    eligible = eligible_sections_for_student(student)
    already_registered = student.sections
    eligible_unregistered = eligible - already_registered
  end
  
  def eligible_students_for_section(section)
    # I want students between a set of ranks, between a set of ages, who are active and have the list arranged in alphabetical order.
    # Thankfully I have methods for all of those which were done and tested last phase, so this task is now super easy...
    Student.ranks_between(section.min_rank, section.max_rank).ages_between(section.min_age, section.max_age).active.alphabetical.all
  end
  
  def eligible_unregistered_students_for_section(section)
    eligible = eligible_students_for_section(section)
    already_registered = section.students
    eligible_unregistered = eligible - already_registered
  end
  
  def registrations_for_past_tournaments(student)
    all_registrations = student.registrations
    if !all_registrations.empty?
      registrations_for_past_tournaments = Array.new
      all_registrations.each { |r|
        registrations_for_past_tournament << r if r.tournament.date < Date.today
      }
        registrations_for_past_tournament.sort_by{|r| r.tournament.date}
    end
  end
  
  def age_range_for(section)
    if section.min_age == section.max_age
      "#{section.min_age}"
    elsif section.max_age.nil?
      "#{section.min_age} and up"
    else
      "#{section.min_age} - #{section.max_age}"
    end
  end
  
  def rank_range_for(section)
    if section.min_rank == section.max_rank
      "#{rank_name section.min_rank}"
    elsif section.max_rank.nil?
      "#{rank_name section.min_rank} and up"
    else
      "#{rank_name section.min_rank} - #{rank_name section.max_rank}"
    end
  end
  
  # for Registration's views (when creating or editing a registration)
  def get_section_options
    Section.active.alphabetical.map{|s| ["#{s.tournament.name}, #{s.event.name}: ages #{age_range_for(s)}, ranks #{rank_range_for(s)}", s.id] }
  end
  
  # for Section's index page
  def get_tournament_options
    Tournament.chronological.map{|t| ["#{t.date.strftime("%m/%d/%Y")} #{t.name} (#{t.active? ? "active" : "inactive"}): ranks #{rank_range_for(t)}", t.id] }
  end
end

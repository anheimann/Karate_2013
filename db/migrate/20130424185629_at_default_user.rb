class AtDefaultUser < ActiveRecord::Migration
  def up
    s = Student.new
    s.first_name = "Amy"
    s.last_name = "Adams"
    s.date_of_birth = 24.years.ago.to_date
    s.rank = 12
    s.active = true
    s.save!
    admin = User.new
    admin.email = "admin@example.com"
    admin.password = "secret"
    admin.password_confirmation = "secret"
    admin.student_id = s.id
    admin.role = "admin"
    admin.active = true
    admin.save!
  end

  def down
    admin = User.find_by_email "admin@example.com"
    User.delete admin
  end
end

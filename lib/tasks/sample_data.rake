namespace :db do
	desc "Fill database with sampel data"
	task populate: :environment do
		User.create(name:"jordan",
						email:"jordan@uvic.ca",
						password:"jordan",
						password_confirmation:"jordan",
						admin: true)

		99.times do |n|
			name = Faker::Name.name
			email = "email#{n+1}@uvic.ca"
			password = "password"
			User.create(name:name,
							email:email,
							password:password,
							password_confirmation:password,
							admin: false)
		end

		users = User.limit(6)
		40000.times do |n|
			task="task"
			comment = Faker::Lorem.sentence(5)
			start_time = DateTime.now
			end_time = (start_time.to_time + 30.minutes).to_datetime

			users.each do |user| 
				 user.timesheets.create!(
					task: task,
					comment: comment,
					start_time: start_time.to_s,
					end_time: end_time.to_s)
			end			
		end
		

	end
end
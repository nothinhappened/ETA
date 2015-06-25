# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#tampon = org.time_entries.create({
#	start_time: "2014-06-02",
#	duration: "2000-01-01 04:24:00 UTC"
#})
#
#TimeEntry.create
#Task.create
#UserTask.create
#
#2014-06-02
#2000-01-01 04:24:00 UTC

org = Organization.create({
	name:"NERV"
})

jordan = org.users.create({
	first_name: "jordan",
	last_name: "yu",
	user_type: 0,	
	email: "jordan@uvic.ca",	
	password: "jordan",
	password_confirmation: "jordan"
})

org.tasks.create({
	name:"task1",
	description:"task1 description"
})
org.tasks.create({
	name:"task2",
	description:"task2 description"
})
UserTask.create([	
	{user_id: 1, task_id:1},
	{user_id: 1, task_id:2},	
])

new_entries = [
	{start_time: "2014-06-02", duration: 1, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-03", duration: 2.5, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-04", duration: 3, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-05", duration: 4, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-07", duration: 7, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-12", duration: 23, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-13", duration: 0.5, organization_id: 1, user_id: 1, task_id: 1 },
	{start_time: "2014-06-02", duration: 0.5, organization_id: 1, user_id: 1, task_id: 2 },
	{start_time: "2014-06-06", duration: 1.5, organization_id: 1, user_id: 1, task_id: 2 },
	{start_time: "2014-06-12", duration: 2.35, organization_id: 1, user_id: 1, task_id: 2 },
]
TimeEntry.create(new_entries)

# SEEDS.RB file (upload initial data)

# Create users
user1 = User.create(name: 'Jean Reno', email: "jeanreno@gmail.com", password: "me1234", password_confirmation: "me1234", role: 'admin')
user2 = User.create(name: 'John Lennon', email: "johnlennon@gmail.com", password: "me1234", password_confirmation: "me1234", role: 'default')

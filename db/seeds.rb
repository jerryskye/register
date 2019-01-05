user = FactoryBot.create(:user, email: 'test@test.org', password: 'test.8')
admin = FactoryBot.create(:admin, email: 'admin@test.org', password: 'test.8')
FactoryBot.create_list(:entry, 8, uid: user.uid)

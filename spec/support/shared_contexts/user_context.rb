RSpec.shared_context 'with authenticated user' do
  let(:user) { create(:user) }

  before do
    @request.env['warden'] = double(
      authenticate!: true,
      authenticated?: true,
      user: user,
      authenticate: user
    )
  end
end

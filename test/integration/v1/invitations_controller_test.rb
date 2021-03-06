require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test 'posting incorrect API token returns 401' do
    post new_invitation_path, params: { date: '', time: '10:00' }, headers: {}
    assert_response 401
    assert_not_nil JSON.parse(response.body)['error']
  end

  test 'posting incomplete data to create returns 422' do
    post new_invitation_path, params: { date: '2017-06-01',
                                        time: '10:00' }, headers: api_headers
    assert_response 422
    assert_not_nil JSON.parse(response.body)['error']
  end

  test 'posting complete data to creates new invitation' do
    assert_difference('Invitation.count') do
      post new_invitation_path, params: { user_id: users(:one).id,
                                          place: 'Limerick',
                                          date: '2017-04-15',
                                          time: '09:00:00' },
                                headers: api_headers
    end
    assert_response 201
  end

  test 'posting data creates new event only if new place/date/time' do
    assert_difference('Event.count') do
      post new_invitation_path, params: { user_id: users(:one).id,
                                          place: 'Limerick',
                                          date: '2017-04-15',
                                          time: '09:00:00',
                                          max_places: 10 }, headers: api_headers
    end
    assert_response 201
    assert_no_difference('Event.count') do
      post new_invitation_path, params: { user_id: users(:one).id,
                                          place: 'Limerick',
                                          date: '2017-04-15',
                                          time: '09:00:00',
                                          max_places: 10 }, headers: api_headers
    end
    assert_response 201
  end

  test 'status should return status info for invitation' do
    invite = invitations(:one)
    get invitation_status_path(invite.unique_uri)
    assert_response 200

    json_response = JSON.parse(response.body)
    assert_equal json_response['status'], invite.status
  end

  test 'show invitation info for invitee' do
    invite = invitations(:one)
    get invitation_show_path(invite.unique_uri)
    assert_response 200

    serializer = InvitationSerializer.new(invite)
    assert_equal response.body,
                 ActiveModelSerializers::Adapter.create(serializer).to_json
  end

  test 'accept invite' do
    invite = invitations(:one)
    get invitation_accept_path(invite.unique_uri)
    invite.reload
    assert_equal 'accepted', invite.status
  end

  test 'decline invite' do
    invite = invitations(:one)
    get invitation_decline_path(invite.unique_uri)
    invite.reload
    assert_equal 'declined', invite.status
  end

  test 'tentative invite' do
    invite = invitations(:one)
    get invitation_tentative_path(invite.unique_uri)
    invite.reload
    assert_equal 'tentative', invite.status
  end

  test 'full event refuses any new acceptances' do
    invite = invitations(:four)
    get invitation_accept_path(invite.unique_uri)
    invite.reload
    assert_equal 'refused', invite.status
  end

  test 'already accepted event refuses any new acceptances' do
    invite = invitations(:fiveB)
    get invitation_accept_path(invite.unique_uri)
    invite.reload
    assert_equal 'refused', invite.status
  end

  test 'handle recurring events' do
    assert_difference('Invitation.count', 4) do
      post new_invitation_path, params: { user_id: users(:one).id,
                                          place: 'Limerick',
                                          date: '2017-04-15',
                                          time: '09:00:00',
                                          repeats: 'weekly',
                                          date_end: '2017-05-06' },
                                headers: api_headers
    end
    assert_response 201
  end
end

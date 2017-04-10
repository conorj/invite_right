require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test 'posting incomplete data to create returns 422' do
    post new_invitation_path, params: { date: '', time: '10:00' }
    assert_response 422
  end

  test 'posting complete data to creates new invitation' do
    assert_difference('Invitation.count') do
      post new_invitation_path, params: { place: 'Limerick', date: '2017-04-15', time: '09:00:00' }
    end
    assert_response 201
  end

  test 'posting data creates new event only if new place/date/time' do
    assert_difference('Event.count') do
      post new_invitation_path, params: { place: 'Limerick',
                                          date: '2017-04-15',
                                          time: '09:00:00',
                                          max_places: 10 }
    end
    assert_response 201
    assert_no_difference('Event.count') do
      post new_invitation_path, params: { place: 'Limerick', date: '2017-04-15', time: '09:00:00' }
    end
    assert_response 201
  end

  test 'status should return status info for invitation' do
    invite = invitations(:one)
    get invitation_status_path(invite.unique_uri)
    assert_response 200

    json_response = JSON.parse(response.body)
    assert_equal json_response['accepted'], invite.accepted
    assert_equal json_response['declined'], invite.declined
    assert_equal json_response['tentative'], invite.tentative
  end

  test 'show invitation info for invitee' do
    invite = invitations(:one)
    get invitation_show_path(invite.unique_uri)
    assert_response 200

    serializer = InvitationSerializer.new(invite)
    assert_equal response.body, ActiveModelSerializers::Adapter.create(serializer).to_json
  end

  test 'accept invite' do
    invite = invitations(:one)
    accepted_count = invite.accepted
    get invitation_accept_path(invite.unique_uri)
    invite.reload
    assert_equal accepted_count + 1, invite.accepted
  end

  test 'decline invite' do
    invite = invitations(:one)
    declined_count = invite.declined
    get invitation_decline_path(invite.unique_uri)
    invite.reload
    assert_equal declined_count + 1, invite.declined
  end

  test 'tentative invite' do
    invite = invitations(:one)
    tentative_count = invite.tentative
    get invitation_tentative_path(invite.unique_uri)
    invite.reload
    assert_equal tentative_count + 1, invite.tentative
  end
end

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
      post new_invitation_path, params: { place: 'Limerick', date: '2017-04-15', time: '09:00:00' }
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
end

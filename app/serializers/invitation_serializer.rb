class InvitationSerializer < ActiveModel::Serializer
  attributes :invitation_uri, :place, :invitation_date
end

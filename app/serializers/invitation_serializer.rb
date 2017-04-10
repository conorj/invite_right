class InvitationSerializer < ActiveModel::Serializer
  attributes :unique_uri, :place, :date, :time
end

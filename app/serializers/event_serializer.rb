class EventSerializer < ActiveModel::Serializer
  attributes :place, :date
  has_many :invitations
end

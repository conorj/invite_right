class EventSerializer < ActiveModel::Serializer
  attributes :place, :date, :time
  has_many :invitations
end

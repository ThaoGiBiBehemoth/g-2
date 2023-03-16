class UserSerializer < ActiveModel::Serializer
  attributes :id, :nickname, :email#, :password_digest
  # has_many :tasks
end

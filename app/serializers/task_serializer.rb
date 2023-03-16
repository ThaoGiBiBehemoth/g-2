class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :descrip, :done, :deadline
  # has_one :user
end

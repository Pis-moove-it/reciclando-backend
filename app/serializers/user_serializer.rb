class UserSerializer < ActiveModel::Serializer
  attributes :name, :surname, :email, :ci
end

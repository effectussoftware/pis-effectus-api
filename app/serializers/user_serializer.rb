class UserSerializer < ActiveModel::Serializer
    attributes :id,:email,:name,:picture,:is_active,:is_admin
end
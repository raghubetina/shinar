# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  subject    :string           default("pending"), not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint           not null
#
# Indexes
#
#  index_chats_on_creator_id  (creator_id)
#  index_chats_on_token       (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
class Chat < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :chat_users, dependent: :destroy
  has_many :users, through: :chat_users, source: :user
  has_many :messages, dependent: :destroy

  has_secure_token

  after_create :update_subject

  def update_subject
    self.update subject: "Chat ##{id}"
  end

  def to_param
    token
  end
end

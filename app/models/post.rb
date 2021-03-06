# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  # uploaderファイルをimagesカラムに適用
  # 複数画像を取り扱いのでuploadersと複数形にする

  serialize :images, JSON
  # carrierwaveで複数画像を保存する場合はJSON型で扱う必要がある。
  # DBをJSON型で設定していないケースでは、modelにて設定する。

  belongs_to :user
  # postは１つのuserを持つ、というアソシエーション
  # この記載がないと、参照先(この場合はuser)テーブルにアクセスできない

  has_many :comments, dependent: :destroy
  # postは複数のcommentを持つ
  # dependent: :destroyについてはuserモデルに記述済

  has_many :likes, dependent: :destroy
  # ↓いいねをしたuserを取得するための記述
  has_many :like_users, through: :likes, source: :user
  # 記述意図はuser.rbと重複するので割愛

  scope :body_contain, ->(word) { where('body LIKE ?', "%#{word}%") }
  # 検索のロジックを記述。検索フォームに入力されたものを（SearchPostsFormインスタンスのself.bodyを受け取っている。はず？）
  # 第2引数である、"->(word) { where('body LIKE ?', "%#{word}%") }" を実行し、値を返す。
  # ？はプレースホルダーと言い、SQLインジェクションという攻撃を防止するための記述。

  validates :body, presence: true, length: { maximum: 255 }
  validates :images, presence: true
  # migrationファイルでnullfalseをつけたものはこちらでもバリデーションをつける。
end

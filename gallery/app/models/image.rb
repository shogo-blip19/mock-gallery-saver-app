class Image < ApplicationRecord
  # 画像ファイルを1つ添付できるようにする（Active Storage）
  # image.file で添付ファイルを扱える
  has_one_attached :file

  # 保存する前のチェック（バリデーション）
  validates :prompt, presence: true # プロンプトは必須
  validates :file, presence: true   # 画像ファイルの添付も必須
end

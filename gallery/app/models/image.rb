class Image < ApplicationRecord
  # 画像ファイルを1つ添付できるようにする（Active Storage）
  # ブロックの中で「variant（変換した別バージョン）」に名前を付けて定義できる
  has_one_attached :file do |attachable|
    # :thumb という名前で、400x400 に切り抜いて縮小したサムネイルを使えるようにする
    # 使うときは image.file.variant(:thumb)
    attachable.variant :thumb, resize_to_fill: [400, 400]
  end

  # 保存する前のチェック（バリデーション）
  validates :prompt, presence: true # プロンプトは必須
  validates :file, presence: true   # 画像ファイルの添付も必須
end

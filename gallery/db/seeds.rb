# ダミー画像をデータベースに登録するスクリプト
# 実行: docker compose run --rm web bin/rails db:seed

# 何度実行しても同じ状態になるように、最初に全部消す
# （destroy_all は添付ファイルもいっしょに削除してくれる）
Image.destroy_all

# 画像とメタデータが置いてあるフォルダ
images_dir = Rails.root.join("db/seeds/images")

# metadata.json を読み込んで、Rubyの配列（中身はハッシュ）に変換する
metadata = JSON.parse(File.read(images_dir.join("metadata.json")))

metadata.each do |data|
  image = Image.new(
    prompt:   data["prompt"],
    seed:     data["seed"],
    ai_model: data["ai_model"]
  )

  # 画像ファイルを Active Storage で添付する
  image.file.attach(
    io:           File.open(images_dir.join(data["file"])),
    filename:     data["file"],
    content_type: "image/png"
  )

  # 保存に失敗したらエラーで止める（! が付いているメソッドは失敗時に例外を出す）
  image.save!
end

puts "Image を #{Image.count} 件登録しました"

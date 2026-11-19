require "rails_helper"

# GET /api/images が仕様どおりに動くかを確かめるテスト（リクエストスペック）
RSpec.describe "Api::Images", type: :request do
  # テスト用の画像を1件作るための便利メソッド
  def create_image(prompt: "test prompt", seed: 1)
    Image.create!(
      prompt: prompt,
      seed: seed,
      ai_model: "mock-diffusion-v1",
      file: {
        io: File.open(Rails.root.join("db/seeds/images/01.png")),
        filename: "01.png",
        content_type: "image/png"
      }
    )
  end

  describe "GET /api/images" do
    it "画像一覧を JSON で返す" do
      create_image(prompt: "a cat sitting on a window")

      get "/api/images"

      expect(response).to have_http_status(:ok) # ステータスコード 200 が返る

      json = response.parsed_body                # JSON を Ruby のハッシュに戻す
      expect(json["images"].size).to eq 1

      image = json["images"].first
      expect(image["prompt"]).to eq "a cat sitting on a window"
      expect(image.keys).to include("id", "url", "thumbnail_url", "prompt", "seed", "model", "created_at")
    end

    it "1ページ 12 件ずつ返し、次のページ番号を教える" do
      13.times { |i| create_image(seed: i) }

      # 1ページ目：12件と「次は2ページ目」
      get "/api/images"
      json = response.parsed_body
      expect(json["images"].size).to eq 12
      expect(json["next_page"]).to eq 2

      # 2ページ目：残りの1件と「次はない（nil）」
      get "/api/images", params: { page: 2 }
      json = response.parsed_body
      expect(json["images"].size).to eq 1
      expect(json["next_page"]).to be_nil
    end

    it "画像が1件もないときは空の配列を返す" do
      get "/api/images"

      json = response.parsed_body
      expect(json["images"]).to eq []
      expect(json["next_page"]).to be_nil
    end
  end
end

# 拡張機能などのプログラム向けに、画像一覧を JSON で返すコントローラ
# Api:: が付いているのは、config/routes.rb の namespace :api に対応しているため
#（ファイルも app/controllers/api/ フォルダに置く）
module Api
  class ImagesController < ApplicationController
    # 1ページに何件返すか（定数は大文字で書く）
    PER_PAGE = 12

    # GET /api/images?page=1
    def index
      # URL の ?page=2 の部分は params[:page] で受け取れる（文字列 "2" で届くので to_i で数値にする）
      # 指定がなければ 1 ページ目。0 や -1 のようなおかしな値も 1 ページ目として扱う
      page = params.fetch(:page, 1).to_i
      page = 1 if page < 1

      # 1件多め（PER_PAGE + 1 件）取ってくるのがコツ
      # 13件取れたら「次のページがある」、12件以下なら「これが最後のページ」とわかる
      images = Image.with_attached_file
                    .order(created_at: :desc, id: :desc)
                    .limit(PER_PAGE + 1)              # 最大 13 件
                    .offset((page - 1) * PER_PAGE)    # 2ページ目なら先頭の 12 件を飛ばす
                    .to_a                             # ここで DB に問い合わせて配列にする

      has_next_page = images.size > PER_PAGE

      # render json: で、Ruby のハッシュを JSON に変換してレスポンスとして返す
      render json: {
        images: images.first(PER_PAGE).map { |image| image_json(image) },
        next_page: has_next_page ? page + 1 : nil   # 最後のページなら nil（JSON では null）
      }
    end

    private

    # 画像1件分を、API で返す形のハッシュに変換する
    def image_json(image)
      {
        id: image.id,
        # _url で終わるヘルパーは「http://localhost:3000/...」のような完全な URL を作る
        # （拡張機能は別の場所から呼ぶので、/rails/... だけの相対パスだと困る）
        url: rails_blob_url(image.file),
        thumbnail_url: rails_representation_url(image.file.variant(:thumb)),
        prompt: image.prompt,
        seed: image.seed,
        model: image.ai_model,   # DB のカラム名は ai_model だが、API では README の仕様どおり model で返す
        created_at: image.created_at
      }
    end
  end
end

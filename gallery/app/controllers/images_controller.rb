class ImagesController < ApplicationController
  # GET /images （トップページもここ）
  def index
    # with_attached_file : 添付ファイルの情報もまとめて1回で取ってくる（N+1問題の対策）
    # order            : 新しい順に並べる
    @images = Image.with_attached_file.order(created_at: :desc, id: :desc)
  end
end

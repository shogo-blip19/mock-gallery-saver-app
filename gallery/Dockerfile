# Rubyのバージョンを指定（3.3系）
FROM ruby:3.3

# OSレベルで必要なパッケージ
#  build-essential : Gemのコンパイルに必要
#  libpq-dev       : PostgreSQLに接続するpg Gemに必要
#  libyaml-dev     : psych Gemに必要
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential libpq-dev libyaml-dev git curl && \
    rm -rf /var/lib/apt/lists/*

# コンテナ内の作業ディレクトリ
WORKDIR /app

# 先にGemfileだけコピーしてbundle install
# （コードを変更してもGemのインストールがやり直しにならず、ビルドが速くなる）
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリ本体をコピー
COPY . .

# 本番用にCSS/JSを事前にビルド（Tailwind CSSなど）
# RAILS_ENV=production : 本番用の設定でビルドする（これを付けないとdevelopmentモードでビルドされてしまう）
# SECRET_KEY_BASE_DUMMY=1 : master.key（秘密情報）が無い状態でもビルドできるようにする
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

EXPOSE 3000

# コンテナ起動時にDBのマイグレーションを実行してからRailsサーバーを起動
# （compose.ymlで上書きされるので、ローカルのdocker composeでは実行されない）
CMD ["sh", "-c", "bin/rails db:prepare && bin/rails server -b 0.0.0.0"]
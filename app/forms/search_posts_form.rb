# 検索のための新たなクラスを作成
class SearchPostsForm
  include ActiveModel::Model
  # DBを介さずActiveRecordを利用している時のような機能を得る
  # DBに保存せずにform_withで処理を返すことができるようになる
  include ActiveModel::Attributes
  # 属性を指定の型へ変換してくれる

  attribute :body, :string
  # 型の指定をしている。
  # キーがbodyのものはstring型となる。

  def search
    # posts_controllerのsearchアクションで実行される。
    # (application_controllerで定義した@search_formに対して)
    scope = Post.distinct
    # 重複を除外している。
    scope = scope.body_contain(body) if body.present?
    # 後置if記法。scopeに対してpostモデルで設定した検索メソッド（スコープ）を実行。
    scope
    # 1行上の"if body.present?"がfalseだった場合にnilが返ってしまうのを回避するためのscope
  end
end

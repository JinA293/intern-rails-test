# frozen_string_literal: true

class Task < ApplicationRecord
  # Railsを知らなくても読解可能なように敢えてenumは使用しません
  STATUS = { todo: 1, doing: 2, review: 3, completed: 4 }.freeze

  validates :status, inclusion: { in: STATUS.values, message: '存在しないタスクステータスが指定されました' }
  validates :title, presence: { message: 'タイトルを入力してください' }
  validates :description, presence: { message: 'タスク詳細を入力してください' }
  validates :due_date, presence: { message: '期限を入力してください' }
  validate :status_check, on: :update
  validates :status, inclusion: { on: :update, in: 1..2, if: :status1? }
  validates :status, inclusion: { on: :update, in: 1..4, if: :status2? }
  validates :status, inclusion: { on: :update, in: 2..4, if: :status3? }
  validates :status, inclusion: { on: :update, in: [4], if: :status4? }
  # railsのバリデーションについて調べ実装、一行での記述がうまくいかなかったため下記の方法で実装
  # validates :カラム名, ヘルパー
  def status1?
    attribute_in_database(:status) == 1
    # errors.add(:status, 'エラーメッセージ')
  end

  def status2?
    attribute_in_database(:status) == 2
    # errors.add(:status, 'エラーメッセージ')
  end

  def status3?
    attribute_in_database(:status) == 3
    # errors.add(:status, 'エラーメッセージ')
  end

  def status4?
    attribute_in_database(:status) == 4
    # errors.add(:status, 'エラーメッセージ')
  end
  #不格好すぎるので余裕があれば直す
  private

  def status_check
    # 変更前のステータス
    logger.debug("変更前のステータスはattribute_in_database(:status)で取得可能です。\n値：#{attribute_in_database(:status)}")
    # 変更後のステータス
    logger.debug("変更後のステータスはstatusで取得可能です。\n値：#{status}")
    # 更新を中止するため、エラーを格納する
    # errors.add(:status, '選択したステータスには更新できません')
    # 上記の文を追加するとどの値にも更新できず、update_statusというページに遷移し更新できなかったstatusが表示される
  end
end

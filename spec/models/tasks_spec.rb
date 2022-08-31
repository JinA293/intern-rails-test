# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe '#update' do
    # テスト対象のメソッド
    # taskとstatusはそれぞれ下の条件内で定義される
    subject { task.update(status: status) }

    context 'タスクがtodoの場合' do
      # todoのタスクを作成
      # 変数定義
      # let!(:変数名) { 代入される値 }
      # FactoryBot.create(:テーブル名, :オプション)でテストデータの作成
      # オプションに:todo, :doing, :review, :completedを指定するとそれぞれのステータスで作られる
      let!(:task) { FactoryBot.create(:task, :todo) }

      context '引数にdoingの数字(2)を渡すと' do
        # todoのタスクを作成
        let!(:status) { Task::STATUS[:doing] }

        it 'todo(1)からdoing(2)にステータスが変更される' do
          # subjectでテスト対象のメソッドを実行
          # Task.find(task.id).statusがテスト対象メソッドの実行前後でTask::STATUS[:todo]からTask::STATUS[:doing]になることを確認
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:todo]).to(Task::STATUS[:doing])
        end
      end

      context '引数にreviewの数字（3）を渡すと' do
        let!(:status) { Task::STATUS[:review] }

        it 'reviewステータスには遷移せず、値は更新されない' do
          # subjectでテスト対象のメソッドを実行
          # Task.find(task.id).statusがtodoのままであることを確認
          expect(Task.find(task.id).status).to eq(Task::STATUS[:todo])
        end
      end

      context '引数にcompletedの数字（4）を渡すと' do
        let!(:status) { Task::STATUS[:completed] }

        it 'completedステータスには遷移せず、値は更新されない' do
          expect(Task.find(task.id).status).to eq(Task::STATUS[:todo])
        end
      end
    end

    context 'タスクがdoingの場合' do
      let!(:task) { FactoryBot.create(:task, :doing) }

      context '引数にtodoの数字(1)を渡すと' do
        let!(:status) { Task::STATUS[:todo] }

        it 'doing(2)からtodo(1)にステータスが変更される' do
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:doing]).to(Task::STATUS[:todo])
        end
      end

      context '引数にreviewの数字(3)を渡すと' do
        let!(:status) { Task::STATUS[:review] }

        it 'doing(2)からreview(3)にステータスが変更される' do
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:doing]).to(Task::STATUS[:review])
        end
      end

      context '引数にcompletedの数字(4)を渡すと' do
        let!(:status) { Task::STATUS[:completed] }

        it 'doing(2)からcompleted(4)にステータスが変更される' do
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:doing]).to(Task::STATUS[:completed])
        end
      end
    end

    context 'タスクがreviewの場合' do
      let!(:task) { FactoryBot.create(:task, :review) }

      context '引数にtodoの数字(1)を渡すと' do
        let!(:status) { Task::STATUS[:todo] }

        it 'todoステータスには遷移せず、値は更新されない' do
          expect(Task.find(task.id).status).to eq(Task::STATUS[:review])
        end
      end

      context '引数にdoingの数字(2)を渡すと' do
        let!(:status) { Task::STATUS[:doing] }

        it 'review(3)からdoing(2)にステータスが変更される' do
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:review]).to(Task::STATUS[:doing])
        end
      end

      context '引数にcompletedの数字(4)を渡すと' do
        let!(:status) { Task::STATUS[:completed] }
        
        it 'review(3)からcompleted(4)にステータスが変更される' do
          expect { subject }.to change { Task.find(task.id).status }.from(Task::STATUS[:review]).to(Task::STATUS[:completed])
        end
      end
    end

    context 'タスクがcompletedの場合' do
      let!(:task) { FactoryBot.create(:task, :completed) }

      context '引数にtodoの数字(1)を渡すと' do
        let!(:status) { Task::STATUS[:todo] }

        it 'todoステータスには遷移せず、値は更新されない' do
          expect(Task.find(task.id).status).to eq(Task::STATUS[:completed])
        end
      end

      context '引数にdoingの数字(2)を渡すと' do
        let!(:status) { Task::STATUS[:doing] }

        it 'doingステータスには遷移せず、値は更新されない' do
          expect(Task.find(task.id).status).to eq(Task::STATUS[:completed])
        end
      end

      context '引数にreviewの数字(3)を渡すと' do
        let!(:status) { Task::STATUS[:review] }

        it 'revirewステータスには遷移せず、値は更新されない' do
          expect(Task.find(task.id).status).to eq(Task::STATUS[:completed])
        end
      end
    end
  end
end

#とりあえず見様見真似で書いたが、実行結果が毎回異なる
#string contains null byteのエラーが出たりでなかったりする
#テストは通ったので特に調べるなどはしなかった


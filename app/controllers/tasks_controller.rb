# frozen_string_literal: true

class TasksController < ApplicationController
  # 課題➂
  # 検索を押すとクエリに追加
  # ?utf8=✓&status_filter=0&search_words=&due_date_start=&due_date_end=&commit=検索
  def index
    @status_filter = params[:status_filter].to_i
    all_tasks = @status_filter.zero? ? Task.all : Task.where(status: @status_filter) # 初期値なのでall_tasksに変更
    ###
    # クエリサンプル
    # filtered_tasksにメソッドチェーンすることで以下のようにクエリ条件を追加することが可能です
    # filtered_tasks = filtered_tasks.where("due_date >=", Date.current)
    # filtered_tasks = filtered_tasks.order(:created_at)
    ###

    if params[:search_words] != nil # 検索欄に入力されたときのみ検索
      filtered_tasks_by_title = all_tasks.where("title LIKE ?", "%#{params[:search_words]}%")
      filtered_tasks_by_description = all_tasks.where("description LIKE ?", "%#{params[:search_words]}%")
      filtered_tasks = filtered_tasks_by_title + filtered_tasks_by_description
      filtered_tasks = filtered_tasks.uniq #配列の結合の際に重複するデータを削除
    end

    if params[:due_date_start] and params[:due_date_end] != nil # 検索欄に何か入力されたときのみ検索
      filtered_tasks_by_date = all_tasks.where(due_date: "%#{params[:search_words]}%".."%#{params[:due_date_end]}%")
    end

    # 検索語句 string
    # ex) "検索ワード"
    logger.debug("検索ワードはparams[:search_words]で取得可能です。\n値：#{params[:search_words]}")

    # 期限の絞り込み開始日 string
    # ex) "yyyy-mm-dd"
    logger.debug("期限の絞り込み開始日はparams[:due_date_start]で取得可能です。\n値：#{params[:due_date_start]}")

    # 期限の絞り込み終了日 string
    # ex) "yyyy-mm-dd"
    logger.debug("期限の絞り込み終了日はparams[:due_date_end]で取得可能です。\n値：#{params[:due_date_end]}")

    if filtered_tasks != nil
      @tasks = filtered_tasks
    else
      @tasks = all_tasks
    end
    # 検索結果が空ではないときは検索結果を返すようにし、初期レンダリング時はすべて表示されるように実装

  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(create_params)
    if @task.save
      redirect_to "/tasks/#{@task.id}", flash: { success: '作成に成功しました' }
    else
      flash.now[:danger] = '作成に失敗しました。'
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(update_params[:id])
    if @task.update(update_params)
      redirect_to "/tasks/#{@task.id}", flash: { success: '更新に成功しました' }
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end

  def update_status
    status = params[:status].to_i
    task_id = params[:task_id].to_i
    @task = Task.find(task_id)
    # 課題➀
    if @task.update(status: status)
      redirect_to "/tasks/#{@task.id}", flash: { success: 'ステータス更新に成功しました' }
    else
      flash.now[:danger] = 'ステータス更新に失敗しました。'
      render :show
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.delete
      redirect_to '/tasks', flash: { success: '削除に成功しました' }
    else
      flash.now[:danger] = '削除に失敗しました。'
      redirect_to '/tasks'
    end
  end

  private

  def create_params
    params.permit(:title, :status, :description, :due_date)
  end

  def update_params
    params.permit(:id, :title, :status, :description, :due_date)
  end
end

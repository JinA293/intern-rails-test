# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @status_filter = params[:status_filter].to_i
    filtered_tasks = @status_filter.zero? ? Task.all : Task.where(status: @status_filter)
    ###
    # クエリサンプル
    # filtered_tasksにメソッドチェーンすることで以下のようにクエリ条件を追加することが可能です
    # filtered_tasks = filtered_tasks.where("due_date >=", Date.current)
    # filtered_tasks = filtered_tasks.order(:created_at)
    ###

    # 検索語句 string
    # ex) "検索ワード"
    logger.debug("検索ワードはparams[:search_words]で取得可能です。\n値：#{params[:search_words]}")

    # 期限の絞り込み開始日 string
    # ex) "yyyy-mm-dd"
    logger.debug("期限の絞り込み開始日はparams[:due_date_start]で取得可能です。\n値：#{params[:due_date_start]}")

    # 期限の絞り込み終了日　string
    # ex) "yyyy-mm-dd"
    logger.debug("期限の絞り込み終了日はparams[:due_date_end]で取得可能です。\n値：#{params[:due_date_end]}")

    @tasks = filtered_tasks
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

class RemoveRedundantColumnsFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :question, :string
    remove_column :answers, :reference, :string
  end
end

# frozen_string_literal: true

class AddRecurrentToCommunication < ActiveRecord::Migration[6.0]
  def change
    add_column :communications, :recurrent_on, :timestamp
  end
end

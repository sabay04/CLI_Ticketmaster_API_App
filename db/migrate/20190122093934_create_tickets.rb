class CreateTickets < ActiveRecord::Migration[4.2]

      def change
        create_table :tickets do |t|
          t.integer :user_id
          t.integer :event_id #from api
        end
      end
end

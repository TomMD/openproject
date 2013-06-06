class AllowNullPositionInPlanningElementTypes < ActiveRecord::Migration
  def self.up
    change_column :timelines_planning_element_types, :position, :integer, :default => 1, :null => true
  end

  def self.down
    change_column :timelines_planning_element_types, :position, :integer, :default => 1, :null => false
  end
end

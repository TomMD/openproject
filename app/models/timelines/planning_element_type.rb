class Timelines::PlanningElementType < ActiveRecord::Base
  unloadable

  self.table_name = 'timelines_planning_element_types'

  acts_as_list
  default_scope :order => 'position ASC'

  include Timelines::TimestampsCompatibility

  extend Timelines::Pagination::Model

  has_many :default_planning_element_types, :class_name  => 'Timelines::DefaultPlanningElementType',
                                            :foreign_key => 'planning_element_type_id',
                                            :dependent   => :delete_all
  has_many :project_types, :through => :default_planning_element_types

  has_many :enabled_planning_element_types, :class_name  => 'Timelines::EnabledPlanningElementType',
                                            :foreign_key => 'planning_element_type_id',
                                            :dependent   => :delete_all
  has_many :projects, :through => :enabled_planning_element_types

  belongs_to :color, :class_name  => 'Timelines::Color',
                     :foreign_key => 'color_id'

  has_many :planning_elements, :class_name  => 'Timelines::PlanningElement',
                               :foreign_key => 'planning_element_type_id',
                               :dependent   => :nullify

  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :name
  validates_inclusion_of :in_aggregation, :is_default, :is_milestone, :in => [true, false]

  validates_length_of :name, :maximum => 255, :unless => lambda { |e| e.name.blank? }

  scope :like, lambda { |q|
    s = "%#{q.to_s.strip.downcase}%"
    { :conditions => ["LOWER(name) LIKE :s", {:s => s}],
    :order => "name" }
  }

  def self.search_scope(query)
    like(query)
  end

  def enabled_in?(object)
    case object
    when Timelines::ProjectType
      object.planning_element_types.include?(self)
    when Project
      object.timelines_planning_element_types.include?(self)
    else
      false
    end
  end

  def available_colors
    Timelines::Color.all
  end
end

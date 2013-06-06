class Timelines::ProjectType < ActiveRecord::Base
  unloadable

  extend Timelines::Pagination::Model

  self.table_name = 'timelines_project_types'

  acts_as_list
  default_scope :order => 'position ASC'

  include Timelines::TimestampsCompatibility

  has_many :projects, :class_name  => 'Project',
                      :foreign_key => 'timelines_project_type_id'


  has_many :available_project_statuses, :class_name  => 'Timelines::AvailableProjectStatus',
                                        :foreign_key => 'project_type_id',
                                        :dependent => :destroy
  has_many :reported_project_statuses, :through => :available_project_statuses


  has_many :default_planning_element_types, :class_name  => 'Timelines::DefaultPlanningElementType',
                                            :foreign_key => 'project_type_id',
                                            :dependent => :destroy
  has_many :planning_element_types, :through => :default_planning_element_types


  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :name
  validates_inclusion_of :allows_association, :in => [true, false]

  validates_length_of :name, :maximum => 255, :unless => lambda { |e| e.name.blank? }

  scope :like, lambda { |q|
    s = "%#{q.to_s.strip.downcase}%"
    { :conditions => ["LOWER(name) LIKE :s", {:s => s}],
    :order => "name" }
  }

  def self.search_scope(query)
    # this should be all project types to which there are projects to
    # which there are dependencies from projects that the user can see
    like(query)
  end

  def self.available_grouping_project_types
    # this should be all project types to which there are projects to
    # which there are dependencies from projects that the user can see
    find(:all, :order => :name)
  end
end

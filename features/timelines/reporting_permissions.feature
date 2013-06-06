Feature: Reporting Permissions
  Admin actions are covered in the General Reporting administration feature.
  This concerns users other than admins

  Background:
    Given there is 1 user with:
          | login | privileged |
      And there is 1 user with:
          | login | unprivileged |
      And there is 1 user with:
          | login | observer |
      And there is 1 user with:
          | login | editor |

      And there is 1 project with the following:
          | Name | Santas Project |
      And there is 1 project with the following:
          | Name | World Domination |
      And there is 1 project with the following:
          | Name | How to stay sane and drink lemonade |

      And there is a role "project admin"
      And the role "project admin" may have the following rights:
          | view_timelines    |
          | edit_project      |
          | view_project      |
          | edit_reportings   |
          | view_reportings   |
          | delete_reportings |

      And there is a role "random guy"
      And the role "random guy" may have the following rights:
          | edit_project |
          | view_project |

      And there is a role "view reportings"
      And the role "view reportings" may have the following rights:
          | view_timelines  |
          | edit_project    |
          | view_project    |
          | view_reportings |

      And there is a role "view and edit reportings"
      And the role "view and edit reportings" may have the following rights:
          | view_timelines  |
          | edit_project    |
          | view_project    |
          | view_reportings |
          | edit_reportings |

      And there is a role "crud reportings"
      And the role "crud reportings" may have the following rights:
          | view_timelines    |
          | edit_project      |
          | view_project      |
          | view_reportings   |
          | edit_reportings   |
          | delete_reportings |

      And I am working in project "Santas Project"

      And the project uses the following modules:
          | timelines |

      And the user "privileged" is a "project admin"
      And the user "unprivileged" is a "random guy" in the project "Santas Project"

  @javascript
  Scenario: Creating a reporting by a privileged user
     When I am logged in as "privileged"
      And I go to the page of the project called "Santas Project"
      And I toggle the "Timelines" submenu
      And I click on "Status reportings"
      And I click on "New reporting"

      And I select "World Domination" from "Reports to project"
      And I click on "Create"

     Then I should see "Successful creation."

  Scenario: Editing a reporting as a privileged user
    Given I am logged in as "privileged"
      And there are the following reportings:
          | Project        | Reporting To Project | Reported Project Status Comment |
          | Santas Project | World Domination     | Hallo Junge                     |

     When I go to the page of the project called "Santas Project"
      And I toggle the "Timelines" submenu
      And I click on "Status reportings"
      And I follow "Edit status for project: World Domination"

      And I fill in "So'n Feuerball" for "Status comment"
      And I click on "Save"

     Then I should see "Successful update."

  Scenario: Cannot create a reporting as an unprivileged user
    Given the user "observer" is a "view reportings" in the project "Santas Project"
      And I am logged in as "observer"
     When I go to the page of the project called "Santas Project"
      And I toggle the "Timelines" submenu
      And I click on "Status reportings"
     Then I should not see "New reporting"

  Scenario: Can see reportings as a privileged user
    Given the user "editor" is a "random guy" in the Project "World Domination"
      And the user "editor" is a "view and edit reportings" in the project "Santas Project"
      And there are the following reportings:
          | Project        | Reporting To Project | Reported Project Status Comment |
          | Santas Project | World Domination     | Hallo Junge                     |
      And I am logged in as "editor"
     When I go to the page of the project called "Santas Project"
      And I toggle the "Timelines" submenu
      And I click on "Status reportings"

     Then I should see "New reporting"
      And I should see "Edit status for project: World Domination"
      And I should not see "Delete status reported to project: World Domination"

     When I follow "Edit status for project: World Domination"
      And I fill in "Yeah Boy" for "Status comment"
      And I click on "Save"

     Then I should see "Successful update."
      And I should see "Yeah Boy"

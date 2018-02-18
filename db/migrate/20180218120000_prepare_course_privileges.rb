class PrepareCoursePrivileges < ActiveRecord::Migration[5.1]
  def up
    Privilege.create(slug: 'chief_course_manager', name: 'Главный управляющий курсами')

    chief = Privilege.find_by!(slug: 'chief_course_manager')
    Privilege.create(slug: 'course_manager', name: 'Управляющий курсами', parent: chief)
    PrivilegeGroup.create(slug: 'course_managers', name: 'Управляющие курсами')

    manager = Privilege.find_by!(slug: 'course_manager')
    group   = PrivilegeGroup.find_by!(slug: 'course_managers')

    group.add_privilege(chief)
    group.add_privilege(manager)
  end

  def down
    #   No rollback needed
  end
end

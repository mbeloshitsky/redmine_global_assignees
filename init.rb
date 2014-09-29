require 'redmine'

require 'issue_assignees_helper_patch'

ActiveRecord::Base.observers << :issue_observer

Redmine::Plugin.register :global_assignees do
  name 'Global Assignees plugin'
  author 'Michel Beloshitsky'
  description 'Allows to assign to issue any user not only project member.'
  version '0.2.1'
  url 'http://github.com/mbeloshitsky/global_assignees'
  author_url 'http://github.com/mbeloshitsky'

  requires_redmine :version_or_higher => '2.3.0'
end

require_dependency 'issue'

class IssueObserver < ActiveRecord::Observer
  	observe :issue

  	def before_save(issue)
  		project = Project.find(issue.project_id)
  		if (issue.assigned_to && !project.members.where(:user_id => issue.assigned_to.id).first)
			member = Member.new 
			member.user = issue.assigned_to
			member.project = project
			member.roles = [Role.find_by_id(4)] # Nasty selecting developer
 			member.save
		end
		if (issue.author && !project.members.where(:user_id => issue.author.id).first)
			member = Member.new 
			member.user = issue.author
			member.project = project
			member.roles = [Role.find_by_id(3)] # Nasty selecting manager
 			member.save
		end
	    return true
  	end
end

module IssueAssigneesHelperPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			alias_method_chain :assignable_users, :global
		end
	end

	module InstanceMethods
		def assignable_users_with_global
			users = Principal.where(
				:status => Principal::STATUS_ACTIVE, 
				:type => Setting.issue_group_assignment? ? ['User', 'Group'] : ['User']
			)
			users << author if author
    		users << assigned_to if assigned_to
			users
				.uniq
				.sort
		end
	end
end

Issue.send(:include, IssueAssigneesHelperPatch)
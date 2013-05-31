class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
        user ||= User.new
        if user.role? :admin            # what the admin may access
          can :manage, :all

        elsif user.role? :member        # what the member may access
          can :show, Student do |student|             # see his/her own information, except role and active fields
            student.id == user.student_id
          end
          can :update, Student do |student|           # edit his/her own information, except rank, waiver_signed and active fields
            student.id == user.student_id
          end
          can :show, User do |user|                   # see his/her own user information
            student.id == user.student_id
          end
          can :read, Dojo do |dojo|                   # read (index and show) details of his/her dojo
            dojo.id == user.dojo_student.dojo_id
          end
          can :read, Registration do |registration|   # (index and show) read details of his/her registrations
            student.id == user.student_id
          end
          can :read, Tournament, :active => true
          # can :read, Section, :active => true       # may see (index and show) of active sections
          can :show, Section, :active => true         # may see (show) of a particular section

        else                            # what the public may access
          can :read, Dojo do |dojo|                   # may see (index and show) of active dojos
              Dojo.active
          end
          can :show, Section, :active => true         # may see (show) of a particular section
          can :read, Tournament do |tournament|       # may see (index and show) of active tournaments
              Tournament.active
          end
        end

      end
    end

RSpec::Matchers.define :permit_action do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}."
  end
end


RSpec::Matchers.define :permit_actions_and_forbid_all_others do |permitted_actions|

  match_status = true
  failed_permitted = []
  failed_forbidden = []

  permitted_fail_message = ->(policy, action) do
    match_status = false
    "#{policy.class} does not permit #{action} on #{policy.record} for #{policy.user.inspect}"
  end

  forbidden_fail_message = ->(policy, action) do
    match_status = false
    "#{policy.class} does not forbid #{action} on #{policy.record} for #{policy.user.inspect}"
  end

  match do |policy|
    remove_question_mark = ->(method_name) { method_name.to_s.chop.to_sym }
    all_actions = subject.public_methods(false).map &remove_question_mark
    forbidden_actions = all_actions - permitted_actions
    permitted_actions.each do |action|
      failed_permitted << permitted_fail_message.call(subject, action) if !policy.public_send("#{action}?")
    end
    forbidden_actions.each do |action|
      failed_forbidden << forbidden_fail_message.call(subject, action) if policy.public_send("#{action}?")
    end
    match_status
  end

  failure_message do |policy|
    permitted_message = if !failed_permitted.empty?
                          ["Expected actions to be permitted:", failed_permitted].join "\n"
                        else
                          ""
                        end
    disallowed_message = if !failed_forbidden.empty?
                           ["Expected actions to be forbidden:", failed_forbidden].join "\n"
                         else
                           ""
                         end
    [permitted_message, disallowed_message].join "\n"*2
  end

end

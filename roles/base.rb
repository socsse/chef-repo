name "base"
description "Base role applied to all nodes."
override_attributes(
  :active_groups => ["admin"],
  :authorization => {
    :sudo => {
      :groups => ["admin"],
      :users  => ["ubuntu"],
      :passwordless => true
    }
  }
)
run_list(
  "recipe[apt]",
  "recipe[build-essential]",
  "recipe[zsh]",
  "recipe[users]",
  "recipe[sudo]",
  "recipe[git]"
)

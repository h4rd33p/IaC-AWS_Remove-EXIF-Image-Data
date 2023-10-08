
// get the account_id in use
locals {
  account_id = data.aws_caller_identity.current.account_id
}

// users to create
locals {
  users = {
    "UserA" = {
      name  = "User A"
      email = "User.B@example.com"
    },
    "UserB" = {
      name  = "User B"
      email = "User.B@example.com"
    }
  }
}

// mapping groups and polices
locals {
  association-list = flatten([
    for group in keys(var.group_policy_mappings) : [
      for policy in var.group_policy_mappings[group] : {
        group  = group
        policy = policy
      }
    ]
  ])
}

// mapping users and groups
locals {
  association-list-users = flatten([
    for user in keys(var.user_group_mappings) : [
      for group in var.user_group_mappings[user] : {
        user  = user
        group = group
      }
    ]
  ])
}
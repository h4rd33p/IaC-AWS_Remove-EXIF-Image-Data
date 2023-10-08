// create users
resource "aws_iam_user" "create_users" {
  for_each      = local.users
  name          = each.key
  force_destroy = true
}

// create groups
resource "aws_iam_group" "iam_groups" {
  for_each = toset(var.user_groups)
  name     = each.value
  path     = "/"
}

// create public key per user
resource "pgp_key" "user_login_key" {
  for_each = local.users
  name     = each.value.name
  email    = each.value.email
  comment  = "PGP Key for ${each.value.name}"
}

// iam access polices to access the s3 buckets
resource "aws_iam_policy" "user_access_policy" {
  for_each = toset(var.s3_bucket_name)

  name        = "${each.value}-policy"
  path        = "/"
  description = "Allow access to the bucket"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "${each.value}" == "ge-images-bucket-a" ? ["s3:ListAllMyBuckets","s3:GetBucketLocation"] : ["s3:ListAllMyBuckets","s3:GetBucketLocation"],
        "Resource" : [
          "arn:aws:s3:::*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "${each.value}" == "ge-images-bucket-a" ? ["s3:ListBucket","s3:Get*", "s3:Put*"] : ["s3:ListBucket","s3:Get*"],
        "Resource" : [
          "arn:aws:s3:::${each.value}",
          "arn:aws:s3:::${each.value}/*"
        ]
      }
    ]
  })
}

// attach policies to the groups using the mappings
resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  count      = length(local.association-list)
  group      = local.association-list[count.index].group
  policy_arn = "arn:aws:iam::${local.account_id}:policy/${local.association-list[count.index].policy}"
  depends_on = [resource.aws_iam_group.iam_groups, resource.aws_iam_policy.user_access_policy]
}

// add users to the groups using the mappings
resource "aws_iam_user_group_membership" "group_users_add" {
  count      = length(local.association-list-users)
  user       = local.association-list-users[count.index].user
  groups     = ["${local.association-list-users[count.index].group}"]
  depends_on = [aws_iam_user.create_users, aws_iam_group.iam_groups]
}

// create password for users
resource "aws_iam_user_login_profile" "generate_user_password" {
  for_each                = local.users
  user                    = each.key
  pgp_key                 = pgp_key.user_login_key[each.key].public_key_base64
  password_reset_required = false

  depends_on = [aws_iam_user.create_users, pgp_key.user_login_key]
}


locals {
  branchid = var.branch == "main" ? "main" : var.branch
  lower_id = lower("${var.project_name}-${local.branchid}")
}

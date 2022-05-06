module "project_playground_christerbeke" {
  source = "./modules/gcp_project"

  name            = "playground-christerbeke"
  project_id      = "playground-christerbeke"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account
  services        = ["dataflow", "cloudbuild", "compute", "cloudtrace", "dns", "iam", "iamcredentials", "logging", "monitoring", "runtimeconfig", "servicemanagement", "serviceusage", "storage"]

  labels = {
    managed_by = "terraform"
  }
}

module "network_playground" {
  source = "./modules/gcp_network"

  project_id    = module.project_playground_christerbeke.project_id
  name          = "playground-network"
  create_subnet = true
  subnet_region = "europe-west1"

  depends_on = [
    module.project_playground_christerbeke,
  ]
}

module "dataflow_flex_simple" {
  source = "./apps/gcp_dataflow_flex"

  enabled                    = true
  project_id                 = module.project_playground_christerbeke.project_id
  app_name                   = "dataflow-flex-simple"
  region                     = "europe-west1"
  vcp_subnet_name            = module.network_playground.subnet_name
  template_storage_location  = "EU"
  template_github_repository = "ChrisTerBeke/terraform-playground-dataflow-templates:main"
  template_directory         = "simple"

  depends_on = [
    module.project_playground_christerbeke,
    module.network_playground,
  ]
}

# resource "google_cloud_scheduler_job" "test_load_scheduler" {
#   count = var.enabled ? 1 : 0

#   project  = var.project_id
#   name     = "${var.name}-load"
#   schedule = "* * * * *" // every minute
#   region   = "europe-west1"

#   pubsub_target {
#     topic_name = module.dataflow_simple.pubsub_topic_id
#     data       = base64encode(jsonencode({ "url" : "https://christerbeke.com", "review" : "positive" }))
#   }
# }

# resource "google_cloud_scheduler_job" "test_load_scheduler_negative" {
#   count = var.enabled ? 1 : 0

#   project  = var.project_id
#   name     = "${var.name}-load-negative"
#   schedule = "*/2 * * * *" // every two minutes
#   region   = "europe-west1"

#   pubsub_target {
#     topic_name = module.dataflow_simple.pubsub_topic_id
#     data       = base64encode(jsonencode({ "url" : "https://christerbeke.com", "review" : "negative" }))
#   }
# }

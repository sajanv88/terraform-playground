module "project_playground_christerbeke" {
  source = "./modules/gcp_project"

  name            = "playground-christerbeke"
  project_id      = "playground-christerbeke"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account
  services        = ["dataflow", "cloudbuild", "compute", "cloudtrace", "dns", "iam", "iamcredentials", "logging", "monitoring", "run", "runtimeconfig", "servicemanagement", "serviceusage", "storage"]

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

# module "dataflow_flex_simple" {
#   source = "./apps/gcp_dataflow_flex"

#   project_id                 = module.project_playground_christerbeke.project_id
#   app_name                   = "dataflow-flex-simple"
#   region                     = "europe-west1"
#   vcp_subnet_name            = module.network_playground.subnet_name
#   template_storage_location  = "EU"
#   template_github_repository = "ChrisTerBeke/terraform-playground-dataflow-templates:main"
#   template_directory         = "simple"

#   depends_on = [
#     module.project_playground_christerbeke,
#     module.network_playground,
#   ]
# }

module "cloud_run_placeholder" {
  source = "./apps/gcp_cloud_run"

  project_id   = module.project_playground_christerbeke.project_id
  app_name     = "placeholder"
  version_name = "latest"
  regions      = ["europe-west1"]
  image        = "gcr.io/cloudrun/placeholder"
  domains      = ["placeholder.cloud.christerbeke.com"]

  depends_on = [
    module.project_playground_christerbeke,
  ]
}

module "dns_playground" {
  source = "./modules/gcp_dns"

  project_id = module.project_playground_christerbeke.project_id
  zone_name  = "cloud-christerbeke-com"
  domain     = "cloud.christerbeke.com"

  a_records = {
    placeholder = [module.cloud_run_placeholder.ip_address]
  }

  depends_on = [
    module.project_playground_christerbeke,
    module.cloud_run_placeholder,
  ]
}

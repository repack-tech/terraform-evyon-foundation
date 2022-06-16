/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  environment_code = element(split("", var.environment), 0)
}

resource "google_artifact_registry_repository" "cloud-run-repo" {
  provider      = google-beta
  project       = data.google_project.env_project.project_id
  location      = var.region
  repository_id = "${var.project_suffix}-repository"
  description   = "Docker repository for Cloud Run"
  format        = "DOCKER"
}

resource "google_service_account" "cloud_run_service_account" {
  project      = data.google_project.env_project.project_id
  account_id   = "sa-example-app"
  display_name = "Example app service Account"
}

# Additional roles to Cloud Run SA
resource "google_project_iam_member" "app_infra_pipeline_sa_roles" {
  for_each = toset(var.cr_sa_roles)
  project  = data.google_project.env_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

# https://github.com/GoogleCloudPlatform/terraform-google-cloud-run
module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.3.0"

  # Required variables
  service_name          = var.project_suffix
  service_account_email = google_service_account.cloud_run_service_account.email
  project_id            = data.google_project.env_project.project_id
  location              = var.region
  image                 = "gcr.io/cloudrun/hello"
  #  env_secret_vars = [
  #    {
  #      name       = "LEGACY_DB_HOST",
  #      value_from = [{ secret_key_ref = { name = "db-sync_legacy-db-host", key = "1" } }]
  #    }
  #  ]
}

#module "instance_template" {
#  source       = "terraform-google-modules/vm/google//modules/instance_template"
#  version      = "7.7.0"
#  machine_type = var.machine_type
#  region       = var.region
#  project_id   = data.google_project.env_project.project_id
#  subnetwork   = data.google_compute_subnetwork.subnetwork.self_link
#  service_account = {
#    email  = google_service_account.compute_engine_service_account.email
#    scopes = ["compute-rw"]
#  }
#}
#
#module "compute_instance" {
#  source            = "terraform-google-modules/vm/google//modules/compute_instance"
#  version           = "6.2.0"
#  region            = var.region
#  subnetwork        = data.google_compute_subnetwork.subnetwork.self_link
#  num_instances     = var.num_instances
#  hostname          = var.hostname
#  instance_template = module.instance_template.self_link
#}

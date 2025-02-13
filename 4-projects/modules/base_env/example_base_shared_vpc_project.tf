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

module "base_shared_vpc_project" {
  source                   = "../single_project"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  folder_id                = data.google_active_folder.env.name
  environment              = var.env
  vpc_type                 = "base"
  alert_spent_percents     = var.alert_spent_percents
  alert_pubsub_topic       = var.alert_pubsub_topic
  budget_amount            = var.budget_amount
  project_prefix           = var.project_prefix
  enable_hub_and_spoke     = var.enable_hub_and_spoke
  sa_roles                 = [
    "roles/artifactregistry.writer",
    "roles/editor",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/run.admin",
    "roles/run.serviceAgent"
  ]
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "datastore.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
  ]
  folders_to_grant_browser_role = [
    var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  ]

  # Metadata
  project_suffix    = "sample-base"
  application_name  = "${var.business_code}-sample-application"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = var.business_code
  environment_admin_groups = var.environment_admin_groups
}


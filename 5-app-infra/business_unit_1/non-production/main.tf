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



data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-non-production"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

module "base_cloud_run_container" {
  source         = "../../modules/env_base"
  environment    = "non-production"
  vpc_type       = "base"
  folder_id      = data.google_active_folder.env.name
  business_code  = "bu1"
  project_suffix = "sample-base"
  region         = var.instance_region
}
